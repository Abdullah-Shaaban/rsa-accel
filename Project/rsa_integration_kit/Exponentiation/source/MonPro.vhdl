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
    out_p : out unsigned(k - 1 downto 0));
end entity MonPro;

architecture rtl of MonPro is
  -- Registers for A, B, and U
  signal A_reg        : unsigned(k - 1 downto 0);
  signal B_reg        : unsigned(k - 1 downto 0);
  signal N_reg        : unsigned(k - 1 downto 0);
  signal U_reg        : unsigned(k downto 0); -- 1 more than the others because addition can overflow
  signal B_plus_N_reg : unsigned(k downto 0); 

  -- Counter
  signal count : unsigned(positive(log2(real(k))) - 1 downto 0);

  -- Intermediate signals
  signal count_en     : std_logic;
  signal cnt_max      : std_logic;
  signal done_reg     : std_logic;
  signal pre_process  : std_logic;
  signal sel2         : std_logic_vector(1 downto 0);
  --signal U_minus_N    : signed(k downto 0);
  signal U_minus_N    : unsigned(k downto 0);
  -- Adder
  signal add_in1 : unsigned(k downto 0);
  signal add_in2 : unsigned(k downto 0); -- This is k+1 bits because B+n can be k+1 bits
  signal add_out : unsigned(k + 1 downto 0); -- This is k+2 bits because U + B+n can be k+2 bits

begin

  -- Data path
  data_path : process (all)
    variable sel1 : std_logic;
    variable u0   : std_logic;
  begin
    -- Mux1: Select the first input of the adder
    sel1 := pre_process;
    if sel1 = '1' then  add_in1 <= '0' & N_reg;
    else                add_in1 <= U_reg;
    end if;
    -- Mux2: Select the second input of the adder
    u0  := U_reg(0) xor (A_reg(to_integer(count)) and B_reg(0));
    sel2 <= (u0 & A_reg(to_integer(count))) and (not(sel1) & not(sel1));
    case? sel2 is
      when "0-" =>  add_in2 <= '0' & B_reg;
      when "10" =>   add_in2 <= '0' & N_reg;
      when "11" =>   add_in2 <= B_plus_N_reg;
    end case?;
    -- Adder
    add_out <= ('0' & add_in1) + ('0' & add_in2);
    -- Subtractor: makes sure the output is less than N
--    U_minus_N <= signed('0'&U_reg) - signed('0'&N_reg);
    U_minus_N <= (U_reg - ('0' & N_reg));
  end process;

  -- Data Registers, no need for reset
  process (clk)
  begin
    if rising_edge(clk) then
      
      if load = '1' then -- Pulse
        A_reg <= A;
        B_reg <= B;
        N_reg <= N;
      end if;
      
      if pre_process = '1' then   B_plus_N_reg <= add_out(k downto 0);
      end if;

      if pre_process = '1' then   U_reg <= (others => '0'); -- Initialize U_reg with zero just before starting the counter next cycle
      elsif sel2 = "00" then      U_reg <= '0' & U_reg(k downto 1);
      else                        U_reg <= add_out(k+1 downto 1); -- U/2
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
  out_p <= U_reg(k-1 downto 0) when (U_reg<N_reg) else U_minus_N(k-1 downto 0);
  done <= done_reg;

end architecture rtl;

architecture ref of MonPro is
begin
  monpro_ref :
  process
    variable BN_ref : unsigned(k downto 0); 
    variable A_ref : unsigned(k-1 downto 0);
    variable B_ref : unsigned(k-1 downto 0);
    variable N_ref : unsigned(k-1 downto 0);
    variable U_ref : unsigned(k+1 downto 0);
    variable U_minus_N_ref : unsigned(k downto 0);
    variable qi : std_logic;
    variable ai : std_logic;
  begin
    -- while (1)
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
    end loop;
    U_minus_N_ref := U_ref(k downto 0) - ('0' & N_ref);
    if U_ref > ("00" & N_ref) then
        out_p <= U_minus_N_ref(k-1 downto 0); -- Output result
    else
        out_p <= U_ref(k-1 downto 0); -- Output result
    end if;
end process;
end architecture ref;