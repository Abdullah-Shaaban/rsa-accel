library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity MonPro is
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
end entity MonPro;
architecture rtl of MonPro is
    -- Registers for A, B, and U
    signal A_reg : unsigned(k-1 downto 0);
    signal B_reg : unsigned(k-1 downto 0);
    signal N_reg : unsigned(k-1 downto 0);
    signal U_reg : unsigned(k-1 downto 0);    -- NOTE: U is k+1 in width

    -- counter
    signal count : unsigned(positive(log2(real(k)))-1 downto 0);

    -- Intermediate signals
    signal A_i : std_logic;
    signal count_en : std_logic;
    signal cnt_max : std_logic;
    signal done_del : std_logic;
    signal A_and_B : unsigned(k-1 downto 0);
    signal U_plus_AiB : unsigned(k downto 0);
    signal U_plus_N : unsigned(k downto 0);
    signal U_out : unsigned(k downto 0);
    signal U_minus_N : unsigned(k-1 downto 0);
begin

-- Combinational path
comb : process(all)
begin
    A_i <= A_reg( to_integer(count) );
    A_and_B <= (k-1 downto 0 => A_i) and B_reg;
    U_plus_AiB <= ('0' & U_reg) + A_and_B;  
    U_plus_N <= U_plus_AiB + N_reg;
    if U_plus_AiB(0) = '1' then
        U_out <= U_plus_N;
    else
        U_out <= U_plus_AiB;
    end if;
    U_minus_N <= U_reg - N_reg;   -- Bringing output to be less than N if necessary
    cnt_max <= '1' when (count = k-1) else '0';
end process;

synch : process(rst_n, clk)
begin
    if rst_n = '0' then
        A_reg <= (others => '0');
        B_reg <= (others => '0');
        N_reg <= (others => '0');
        U_reg <= (others => '0');
        count_en <= '0';
    elsif rising_edge(clk) then
        U_reg <= U_out(k downto 1); -- The U/2 is done here by omitting U_out(0)
        if load = '1' then  -- Pulse
            A_reg <= A;
            B_reg <= B;
            U_reg <= (others => '0');   -- U starts at 0
            N_reg <= N;
            count_en <= '1';
        elsif cnt_max = '1' then
            count_en <= '0';
        -- else they stay the same 
        end if;
    end if;
end process;

-- Counter
counter : process(rst_n, clk)
begin
    if rst_n = '0' then
        count <= (others => '0');
    elsif rising_edge(clk) then
        if count_en = '1' then  -- Pulse
            count <= count + 1;
        end if;
    end if;
end process;

-- Delay done by 1 cycle
say_we_are_done : process(rst_n, clk)
begin
    if rst_n = '0' then
        done_del <= '0';
    elsif rising_edge(clk) then
        done_del <= cnt_max;
    end if;
end process;

-- Final Output
P <= U_reg when (U_reg < N_reg) else U_minus_N;   -- Optimize later by omitting the comparisong, and doing the subtraction alone.
done <= done_del;

end architecture rtl;
