library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.textio.all;


entity MonPro_tb is    
end entity MonPro_tb;

architecture tb of MonPro_tb is
    file inputs_file : text open read_mode is "C:\My_Computer\Study_Work_materials\EMECS\NTNU\Fall Semester\DDS\Project\src\monpro_golden_inputs.txt";
    file golden_file : text open read_mode is "C:\My_Computer\Study_Work_materials\EMECS\NTNU\Fall Semester\DDS\Project\src\monpro_golden_outputs.txt";
    constant cycle: time := 10 ns;
    constant k : positive := 256;
    constant N : unsigned(k-1 downto 0) := x"82b9c9e425d9b508e4d7cbe5d5eaf42d27fd80e944f28d7fbdf71e1edbf5d943";
    signal clk : std_logic := '1';
    signal rst_n : std_logic;
    signal load : std_logic;
    signal A : unsigned(k-1 downto 0);
    signal B : unsigned(k-1 downto 0);
    signal done : std_logic;
    signal P : unsigned(k-1 downto 0);
    signal P_expected : unsigned(k-1 downto 0);
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
        P : out unsigned(k-1 downto 0) );
    end component;

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
        P => P
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
    wait for 2*cycle;
    rst_n <= '1';
    while not endfile(inputs_file) loop
        readline(inputs_file, inputs_line);
        hread(inputs_line, A_var);
        A <= A_var;
        readline(inputs_file, inputs_line);
        hread(inputs_line, B_var);
        B <= B_var;
        load <= '1';
        wait for cycle;
        load <= '0';
        wait until done='1';
        readline(golden_file, golden_line);
        hread(golden_line, P_expected_var);
        P_expected <= P_expected_var;    -- The assertion will fail because the "signal" is assigned in next delta!!!!
        wait for 0 ns;   -- Insert 1 delta
        assert (P=P_expected)
            report "Expected Output is: " & to_string(P_expected) & " but Dut Output is: " & to_string(P)
            severity warning;
        wait for cycle;
    end loop;
    wait;
end process;

end architecture tb;