library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.textio.all;


entity MonPro_tb is    
end entity MonPro_tb;

architecture tb of MonPro_tb is
    constant base_path : string := "C:/My_Computer/Study_Work_materials/EMECS/NTNU/Fall_Semester/DDS/dds-group10/Project/tb/";
    file inputs_file : text open read_mode is base_path & "monpro_golden_inputs.txt";
    file golden_file : text open read_mode is base_path & "monpro_golden_outputs.txt";
    constant cycle: time := 10 ns;
    constant k : positive := 256;
    constant N : unsigned(k-1 downto 0) := x"c9e0ecb4e5937f391371c0c1ec8a9190afc28d942ee615b466e86b525e75fb67";
    signal clk : std_logic := '1';
    signal rst_n : std_logic;
    signal load : std_logic;
    signal A : unsigned(k-1 downto 0);
    signal B : unsigned(k-1 downto 0);
    signal done : std_logic;
    signal P : unsigned(k-1 downto 0);
    signal P_expected : unsigned(k-1 downto 0);
    -- Ref Model Signals
    signal P_ref : unsigned(k-1 downto 0);
    -- signal BN_ref : unsigned(k downto 0); 
    -- signal A_ref : unsigned(k-1 downto 0);
    -- signal B_ref : unsigned(k-1 downto 0);
    -- signal N_ref : unsigned(k-1 downto 0);
    -- signal U_ref : unsigned(k downto 0);
    -- Declare MonPro
    component MonPro is
        generic(k : positive := 256);
        port (
        clk : in std_logic;
        rst_n : in std_logic;
        load : in std_logic;
        A : in unsigned(k-1 downto 0);
        B : in unsigned(k-1 downto 0);
        N : in unsigned(k-1 downto 0);
        done : out std_logic;
        out_p : out unsigned(k-1 downto 0) );
    end component;

    procedure read_value(signal num : out unsigned(k - 1 downto 0); file read_file : text) is
        variable num_var     : unsigned(k - 1 downto 0);
        variable read_line   : line;
        variable golden_line : line;
      begin
        readline(read_file, read_line);
        hread(read_line, num_var);
        num <= num_var;
      end procedure read_value;

begin
    
clk <= not clk after cycle/2;

DUT : MonPro 
    generic map (k => k)
    port map(
        clk => clk,
        rst_n => rst_n,
        load => load,
        A => A,
        B => B,
        N => N,
        done => done,
        out_p => P
    );

stimuli : process is
    variable inputs_line : line;
    variable golden_line : line;
    variable ok : boolean;
    variable A_var : unsigned(k-1 downto 0);
    variable B_var : unsigned(k-1 downto 0);
    variable P_expected_var : unsigned(k-1 downto 0);
begin
    rst_n <= '0';
    load <= '0';
    A <= (others => '0');
    B <= (others => '0');
    wait for 2*cycle;--2.5*cycle;
    rst_n <= '1';    
    wait for 2*cycle;--2.5*cycle;
    while not endfile(inputs_file) loop
        read_value(A, inputs_file);
        read_value(B, inputs_file);
        load <= '1';
        wait for cycle;
        load <= '0';
        wait until done='1';
        read_value(P_expected, golden_file);
        -- The assertion will fail because the "signal" is assigned in next delta!!!!
        wait for cycle;   -- Insert 1 delta
        assert (P=P_expected)
            report "Expected Output is: " & to_hstring(P_expected) & " but Dut Output is: " & to_hstring(P)
            severity ERROR;
        wait for cycle;
    end loop;
    wait;
end process;

monpro_ref : process
variable BN_ref : unsigned(k downto 0); 
variable A_ref : unsigned(k-1 downto 0);
variable B_ref : unsigned(k-1 downto 0);
variable N_ref : unsigned(k-1 downto 0);
variable U_ref : unsigned(k+1 downto 0);
variable U_minus_N_ref : unsigned(k downto 0);
variable qi : std_logic;
variable ai : std_logic;
-- variable P_ref : unsigned(k-1 downto 0);
variable U_dut : unsigned(k downto 0);
variable P_dut : unsigned(k-1 downto 0);
begin
while 1=1 loop
    wait until load = '1';
    wait until rising_edge(clk);
    A_ref := A;
    B_ref := B;
    N_ref := N;
    wait until rising_edge(clk);
    BN_ref := ('0' & B_ref) + ('0' & N_ref);
    wait until rising_edge(clk);
    U_ref := (others => '0'); -- Initialize u to zero
    for i in 0 to k-1 loop
        wait until rising_edge(clk);
        -- Extract individual bits from A and B
        qi := (U_ref(0) xor (A_ref(i) and B(0)));
        ai := A_ref(i);

        if qi = '0' and ai = '0' then
            U_ref := U_ref; -- No change to u
        elsif qi = '0' and ai = '1' then
            U_ref := U_ref + ("00" & B_ref);
        elsif qi = '1' and ai = '0' then
            U_ref := U_ref + ("00" & N_ref);
        elsif qi = '1' and ai = '1' then
            U_ref := U_ref + ("0" & BN_ref);
        end if;

        U_ref := '0' & U_ref(k+1 downto 1); -- Shift right by 1
        U_dut := << signal .MonPro_tb.DUT.U_reg : unsigned(k downto 0) >> ;
        assert (U_dut=U_ref(k downto 0))
            report "U_ref is: " & to_hstring(U_ref(k downto 0)) & " but U_dut is: " & to_hstring(U_dut)
            severity warning;
--        wait until rising_edge(clk);
    end loop;
    U_minus_N_ref := U_ref(k downto 0) - ('0' & N_ref);
    if U_ref > ("00" & N_ref) then
        P_ref <= U_minus_N_ref(k-1 downto 0); -- Output result
    else
        P_ref <= U_ref(k-1 downto 0); -- Output result
    end if;
    P_dut :=  << signal .MonPro_tb.DUT.out_p : unsigned(k-1 downto 0) >> ;
    wait for 0 ns;
    assert (P_dut=P_ref)
        report "P_ref is: " & to_hstring(P_ref) & " but P_dut is: " & to_hstring(P_dut)
        severity failure; 
end loop;
end process;

-- compare : process (rst_n, clk)
-- begin
--     if rst_n then
--         if rising_edge(clk) then
--            assert (P=P_ref)
--             report "P_ref is: " & to_hstring(P_ref) & " but P_dut is: " & to_hstring(P)
--             severity FAILURE; 
--         end if;
--     end if;
-- end process;


end architecture tb;