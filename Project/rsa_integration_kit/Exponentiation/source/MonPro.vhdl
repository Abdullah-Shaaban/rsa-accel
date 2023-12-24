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
  -- Registers for A, B, N, U, and B+N
  signal A_reg        : unsigned(k downto 0);
  signal B_reg        : unsigned(k - 1 downto 0);
  signal N_reg        : unsigned(k - 1 downto 0);
  -- The following registers have 1 more bit than the others because addition can overflow
  signal U_reg        : unsigned(k downto 0);
  signal B_plus_N_reg : unsigned(k downto 0); 

  -- Counter
  signal count : unsigned(positive(log2(real(k))) - 1 downto 0);

  -- Intermediate signals
  signal count_en     : std_logic;
  signal cnt_max      : std_logic;
  signal done_reg     : std_logic;
  signal pre_process  : std_logic;
  signal sel          : std_logic_vector(2 downto 0);

  -- Adder
  signal add_in1 : unsigned(k downto 0);
  -- This is k+1 bits because B+N can be k+1 bits
  signal add_in2 : unsigned(k downto 0);
  -- This is k+2 bits because U+(B+N) can be k+2 bits
  signal add_out : unsigned(k + 1 downto 0);
  -- Used for 2's complement subtraction to do U-N
  signal carry_in     : std_logic;

begin

  -- Data path
  data_path : process (all)
    variable u0, ai  : std_logic;
  begin
    -- Logic for the operands MUX selector
    ai  := A_reg(0);
    u0  := U_reg(0) xor (A_reg(0) and B_reg(0));
    if pre_process='1' then
      -- Forcing a special value when "pre-processing"
      sel <= "001"; 
    elsif done_reg='1' then
      -- Forcing a special value when "post-processing"
      sel <= "011";
    else
      -- Otherwise, the selector depends on u0 and ai
      sel <= u0 & ai & '0';
    end if;

    -- MUX: Select the inputs of the adder
    case? sel is
      when "-01" =>
        add_in1 <= '0' & B_reg;
        add_in2 <= '0' & N_reg;
      when "-11" =>
        add_in1 <= U_reg;
        add_in2 <= not('0' & N_reg);
      when "000" =>
        add_in1 <= U_reg;
        add_in2 <= (others => '0');
      when "010" =>
        add_in1 <= '0' & B_reg;
        add_in2 <= U_reg;
      when "100" =>
        add_in1 <= U_reg;
        add_in2 <= '0' & N_reg;
      when "110" =>
        add_in1 <= B_plus_N_reg;
        add_in2 <= U_reg;
      when others =>
        add_in1 <= U_reg;
        add_in2 <= (others => '0');
    end case?;

    -- Adder
    -- After we finish, we perform U + not(N) + carry_in, which is U-N.
    carry_in <= done_reg;
    add_out <= ('0' & add_in1) + ('0' & add_in2) + carry_in;
  end process;

  -- Data Registers, no need for reset
  process (clk)
  begin
    if rising_edge(clk) then
      -- Assuming load to be a one-cycle Pulse
      if load = '1' then
        B_reg <= B;
        N_reg <= N;
      end if;
      
      if pre_process = '1' then   
        B_plus_N_reg <= add_out(k downto 0);
      end if;

      -- A is a shift register
      if load = '1' then
        -- Putting extra '0' to compensate for 1 early shift -> Avoids making an extra MUX
        A_reg <= A & '0';
      else
        -- Shift          
        A_reg <= '0' & A_reg(k downto 1);
      end if;
      
      if pre_process = '1' then  
        -- Initialize U_reg with zero just before starting the counter next cycle 
        U_reg <= (others => '0');
      else                        
        -- Divide U by 2
        U_reg <= add_out(k+1 downto 1);
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
      if count_en = '1' then
        count <= count + 1;
      end if;
    end if;
  end process;

  -- Final Output: either U or U-N
  -- When the output takes the value from "add_out", the output is not from a register
  -- in MonPro, which may cause timing problems. But MonExp has a register that takes 
  -- the output directly, and it should not matter.
--  out_p <= U_reg(k-1 downto 0) when (U_reg<N_reg) else add_out(k-1 downto 0);
  out_p <= U_reg(k-1 downto 0) when (add_out(k+1)='0') else add_out(k-1 downto 0);
  done <= done_reg;
  -- When doing add_out = {'0', U_reg} + ~{"00", N_reg} + 1, N_reg is bigger if c_out = '1'
  -- For some reason, using the adder's output (c_out = add_out(k+1)) to indicate the comparison
  -- (U_reg<N_reg) only saves 2 Slice LUTs! It gives worse timing (~100ps slower), which makes sense,
  -- but I expected much more utilization savings!

end architecture rtl;

-- architecture ref of MonPro is
-- begin
--   monpro_ref :
--   process
--     variable BN_ref : unsigned(k downto 0); 
--     variable A_ref : unsigned(k-1 downto 0);
--     variable B_ref : unsigned(k-1 downto 0);
--     variable N_ref : unsigned(k-1 downto 0);
--     variable U_ref : unsigned(k+1 downto 0);
--     variable U_minus_N_ref : unsigned(k downto 0);
--     variable qi : std_logic;
--     variable ai : std_logic;
--   begin
--     -- while (1)
--     wait until load = '1';
--     wait until rising_edge(clk);
--     A_ref := A;
--     B_ref := B;
--     N_ref := N;
--     wait until rising_edge(clk);
--     BN_ref := ('0' & B_ref) + ('0' & N_ref);
--     wait until rising_edge(clk);
--     U_ref := (others => '0'); -- Initialize u to zero
--     for i in 0 to k-1 loop
--         wait until rising_edge(clk);
--         -- Extract individual bits from A and B
--         qi := (U_ref(0) xor (A_ref(i) and B(0)));
--         ai := A_ref(i);

--         if qi = '0' and ai = '0' then
--             U_ref := U_ref; -- No change to u
--         elsif qi = '0' and ai = '1' then
--             U_ref := U_ref + ("00" & B_ref);
--         elsif qi = '1' and ai = '0' then
--             U_ref := U_ref + ("00" & N_ref);
--         elsif qi = '1' and ai = '1' then
--             U_ref := U_ref + ("0" & BN_ref);
--         end if;

--         U_ref := '0' & U_ref(k+1 downto 1); -- Shift right by 1
--     end loop;
--     U_minus_N_ref := U_ref(k downto 0) - ('0' & N_ref);
--     if U_ref > ("00" & N_ref) then
--         out_p <= U_minus_N_ref(k-1 downto 0); -- Output result
--     else
--         out_p <= U_ref(k-1 downto 0); -- Output result
--     end if;
-- end process;
-- end architecture ref;