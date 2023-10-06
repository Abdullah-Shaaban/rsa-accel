library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity MonPro is
  generic (k : positive := 256);
  port (
    clk   : in  std_logic;
    rst_n : in  std_logic;
    load  : in  std_logic;
    A     : in  unsigned(k - 1 downto 0);
    B     : in  unsigned(k - 1 downto 0);
    N     : in  unsigned(k - 1 downto 0);
    done  : out std_logic;
    out_p     : out unsigned(k - 1 downto 0));
end entity MonPro;
architecture rtl of MonPro is
  -- Registers for A, B, and U
  signal A_reg        : unsigned(k downto 0);
  signal B_reg        : unsigned(k - 1 downto 0);
  signal N_reg        : unsigned(k - 1 downto 0);
  signal U_reg        : unsigned(k - 1 downto 0);
  signal B_plus_N_reg : unsigned(k downto 0); -- 1 more than the others because addition can overflow

  -- Counter
  signal count : unsigned(positive(log2(real(k))) - 1 downto 0);

  -- Intermediate signals
  signal count_en     : std_logic;
  signal cnt_max      : std_logic;
  signal done_reg     : std_logic;
  signal pre_process  : std_logic;
  signal sel2         : std_logic_vector(1 downto 0);
  --signal U_minus_N    : signed(k downto 0);
  signal U_minus_N    : unsigned(k-1 downto 0);
  -- Adder
  signal add_in1 : unsigned(k - 1 downto 0);
  signal add_in2 : unsigned(k downto 0); -- This is k+1 bits because B+n can be k+1 bits
  signal add_out : unsigned(k downto 0);

begin

  -- Data path
  data_path : process (all)
    variable sel1 : std_logic;
    variable u0   : std_logic;
  begin
    -- Mux1: Select the first input of the adder
    sel1 := pre_process;
    if sel1 = '1' then  add_in1 <= N_reg;
    else                add_in1 <= U_reg;
    end if;
    -- Mux2: Select the second input of the adder
    u0  := U_reg(0) xor (A_reg(0) and B_reg(0));
    sel2 <= (u0 & A_reg(0)) and (not(sel1) & not(sel1));
    case? sel2 is
      when "0-" =>  add_in2 <= '0' & B_reg;
      when "10" =>   add_in2 <= '0' & N_reg;
      when "11" =>   add_in2 <= B_plus_N_reg;
    end case?;
    -- Adder
    add_out <= ('0' & add_in1) + add_in2;
    -- Subtractor: makes sure the output is less than N
--    U_minus_N <= signed('0'&U_reg) - signed('0'&N_reg);
    U_minus_N <= U_reg - N_reg;
  end process;

  -- Data Registers, no need for reset
  process (clk)
  begin
    if rising_edge(clk) then
      
      if load = '1' then -- Pulse
        B_reg <= B;
        N_reg <= N;
      end if;
      
      if pre_process = '1' then   B_plus_N_reg <= add_out;
      end if;

      if load = '1' then    A_reg <= A & '0';   -- Compensate for 1 early shift. Avoids making MUX
      else                  A_reg <= '0' & A_reg(k downto 1);
      end if;
      
      if pre_process = '1' then   U_reg <= (others => '0'); -- Initialize U_reg with zero just before starting the counter next cycle
      elsif sel2 = "00" then      U_reg <= '0' & U_reg(k-1 downto 1);
      else                        U_reg <= add_out(k downto 1); -- U/2
      end if;

    end if;
  end process;

  -- Control
  cnt_max <= '1' when (count = k - 1) else
             '0';
  cont : process (rst_n, clk)
  begin
    if rst_n = '0' then
      pre_process <= '0';
      count_en    <= '0';
      done_reg    <= '0';
    elsif rising_edge(clk) then
      pre_process <= load;
      if pre_process = '1' then
        count_en <= '1';
      elsif cnt_max = '1' then
        count_en <= '0';
      end if;
      done_reg <= cnt_max;
    end if;
  end process;

  -- Counter
  counter : process (rst_n, clk)
  begin
    if rst_n = '0' then
      count <= (others => '0');
    elsif rising_edge(clk) then
      if count_en = '1' then -- Pulse
        count <= count + 1;
      end if;
    end if;
  end process;

  -- Final Output ___ Optimize later by omitting the "<" comparison, and doing the subtraction alone.
--  out_p <= U_reg when (U_minus_N(k)) else  -- Because U < N means result of U-N is negative, i.e., sign=1
--          unsigned(U_minus_N(k-1 downto 0));
  out_p <= U_reg when (U_reg<N_reg) else U_minus_N;
  done <= done_reg;

end architecture rtl;