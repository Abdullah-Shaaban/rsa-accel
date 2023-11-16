library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

-- Modular exponentiation using iterated right-to-left application of the montgomery product.
-- High-level algorithm:
-- def mon_exp_rl(msg, e, n):
--     r2_mod = (1 << (2*k)) % n
--     product = mon_pro(msg, r2_mod, n)
--     result = mon_pro(1, r2_mod, n)
--     for i in range(k):
--         if get_bit(e, i):
--             result = mon_pro(result, product, n)
--         product = mon_pro(product, product, n)
--     result = mon_pro(result, 1, n)
--     return result
entity MonExp is
  generic (k : positive := 256);
  port (
    clk    : in  std_logic;
    rst_n  : in  std_logic;
    load   : in  std_logic;
    msg    : in  unsigned(k - 1 downto 0);
    e      : in  unsigned(k - 1 downto 0);
    n      : in  unsigned(k - 1 downto 0);
    r2     : in  unsigned(k - 1 downto 0); -- Precalculated 2^(2*k) mod n (shifting factor to montgomery space)
    done   : out std_logic;
    result : out unsigned(k - 1 downto 0)
  );
end entity MonExp;

architecture rtl of MonExp is
  -- Registers / state
  signal r2_reg      : unsigned(k - 1 downto 0);
  signal e_reg       : unsigned(k - 1 downto 0);
  signal n_reg       : unsigned(k - 1 downto 0);
  signal product_reg : unsigned(k - 1 downto 0);
  signal result_reg  : unsigned(k - 1 downto 0);
  signal done_reg    : std_logic;

  -- Main FSM
  -- Idle       : Sit at idle until load is signaled, store the inputs.
  -- To Mongom  : Transform the product and result variables into the Montgomery space by left shifting (with modulo)
  -- Loop       : Iterated squaring of the message and accumulating it in the result.
  -- From Mongom: Bring the result back from the Montgomery space into normal number space.
  type state_t is (idle_s, to_mg_fst_s, to_mg_s, loop_fst_s, loop_s, from_mg_fst_s, from_mg_s);
  signal crnt_state : state_t;

  -- Next state signals
  signal next_state       : state_t;
  signal next_r2_reg      : unsigned(k - 1 downto 0);
  signal next_product_reg : unsigned(k - 1 downto 0);
  signal next_e_reg       : unsigned(k - 1 downto 0);
  signal next_n_reg       : unsigned(k - 1 downto 0);
  signal next_result_reg  : unsigned(k - 1 downto 0);
  signal next_done_reg    : std_logic;

  -- Loop counter signals
  signal counter_reg : unsigned(positive(log2(real(k))) - 1 downto 0);
  signal count_done  : std_logic;
  signal count_en    : std_logic;

  -- Montgomery Product module, calculates P = A*B*2^-k mod N
  component MonPro is
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
  end component MonPro;

  -- MonPro signals
  signal monpro_n : unsigned(k - 1 downto 0);
  -- I'm expecting both to be done at the same time and only reading one of them at a time.
  -- TODO: think about this
  signal p_monpro_done : std_logic;
  signal p_monpro_load : std_logic;
  signal p_monpro_a    : unsigned(k - 1 downto 0);
  signal p_monpro_b    : unsigned(k - 1 downto 0);
  signal p_monpro_p    : unsigned(k - 1 downto 0);
  signal r_monpro_done : std_logic;
  signal r_monpro_load : std_logic;
  signal r_monpro_a    : unsigned(k - 1 downto 0);
  signal r_monpro_b    : unsigned(k - 1 downto 0);
  signal r_monpro_p    : unsigned(k - 1 downto 0);

begin

  -- Update the registers at every clock with calculated next value
  regs : process (rst_n, clk)
  begin
    if rst_n = '0' then
      crnt_state  <= idle_s;
      r2_reg      <= (others => '0');
      e_reg       <= (others => '0');
      n_reg       <= (others => '0');
      product_reg <= (others => '0');
      result_reg  <= (others => '0');
      done_reg    <= '0';
    elsif rising_edge(clk) then
      crnt_state  <= next_state;
      r2_reg      <= next_r2_reg;
      e_reg       <= next_e_reg;
      n_reg       <= next_n_reg;
      product_reg <= next_product_reg;
      result_reg  <= next_result_reg;
      done_reg    <= next_done_reg;
    end if;
  end process;

  -- Calculates next state values and control for the sub-components
  comb : process (all)
  begin
    -- Always
    result   <= result_reg;
    monpro_n <= n_reg;
    done     <= done_reg;

    -- Default values
    next_state       <= crnt_state;
    next_r2_reg      <= r2_reg;
    next_e_reg       <= e_reg;
    next_n_reg       <= n_reg;
    next_product_reg <= product_reg;
    next_result_reg  <= result_reg;
    next_done_reg    <= done_reg;
    count_en         <= '0';
    r_monpro_a       <= (others => '0');
    r_monpro_b       <= (others => '0');
    r_monpro_load    <= '0';
    p_monpro_a       <= (others => '0');
    p_monpro_b       <= (others => '0');
    p_monpro_load    <= '0';

    case crnt_state is
      when idle_s =>
        if load = '1' then
          next_state       <= to_mg_fst_s;
          next_r2_reg      <= r2;
          next_e_reg       <= e;
          next_n_reg       <= n;
          next_product_reg <= msg;
          next_result_reg  <= (0 => '1', others => '0');
          next_done_reg    <= '0';
        end if;

      -- Product and result variables into Montgomery space (left shift k bits (mod n))
      -- product = mon_pro(msg, r2_mod, n)
      -- result  = mon_pro(1, r2_mod, n)
      when to_mg_fst_s =>
        p_monpro_load <= '1';
        p_monpro_a    <= product_reg;
        p_monpro_b    <= r2_reg;
        r_monpro_load <= '1';
        r_monpro_a    <= result_reg;
        r_monpro_b    <= r2_reg;
        next_state    <= to_mg_s;
      when to_mg_s =>
        if r_monpro_done = '1' then
          next_state       <= loop_fst_s;
          next_product_reg <= p_monpro_p;
          next_result_reg  <= r_monpro_p;
        end if;

      -- Calculate the exponentiation by multiplying powers of 2 of the message (msg^5 = msg^1 * msg^4)
      -- if get_bit(e, i):
      --     result = mon_pro(result, product, n)
      -- product = mon_pro(product, product, n)
      when loop_fst_s =>
        -- We implement e as a shift register so only read the last bit
        if e_reg(0) = '1' then
          r_monpro_load <= '1';
          r_monpro_a    <= result_reg;
          r_monpro_b    <= product_reg;
        end if;
        p_monpro_load <= '1';
        p_monpro_a    <= product_reg;
        p_monpro_b    <= product_reg;
        next_state    <= loop_s;
      when loop_s =>
        if p_monpro_done = '1' then
          if e_reg(0) = '1' then
            next_result_reg <= r_monpro_p;
          end if;
          next_product_reg <= p_monpro_p;
          count_en   <= '1';
          if count_done = '1' then
            next_state <= from_mg_fst_s;
          else
            next_e_reg <= '0' & e_reg(k - 1 downto 1);
            next_state <= loop_fst_s;
          end if;
        end if;

      -- From Montgomery space back to normal number space (right shift k bits (mod n))
      -- result = mon_pro(result, 1, n)
      when from_mg_fst_s =>
        r_monpro_load <= '1';
        r_monpro_a    <= result_reg;
        r_monpro_b    <= (0 => '1', others => '0');
        next_state <= from_mg_s;
      when from_mg_s =>
        if r_monpro_done = '1' then
          next_state      <= idle_s;
          next_done_reg   <= '1';
          next_result_reg <= r_monpro_p;
        end if;

      when others =>
        -- We reached an invalid state, go back to idle and mark whatever result we had as not correct anymore
        next_state    <= idle_s;
        next_done_reg <= '0';
    end case;
  end process;

  -- Decrementing Counter
  -- We only care about when it's done counting, the intermediate values are not important
  counter : process (rst_n, clk)
  begin
    if rst_n = '0' then
      counter_reg <= to_unsigned(k - 1, counter_reg'length);
    elsif rising_edge(clk) then
      if count_en = '1' then -- Pulse
        if counter_reg = 0 then
          counter_reg <= to_unsigned(k - 1, counter_reg'length);
        else
          counter_reg <= counter_reg - 1;
        end if;
      end if;
    end if;
  end process;
  count_done <= '1' when counter_reg = 0 else
                '0';

  -- Montgomery product component that does the squaring (calculating powers of 2 of the msg)
  p_monpro : entity work.MonPro(rtl)
  generic map(k => k)
  port map(
    clk   => clk,
    rst_n => rst_n,
    load  => p_monpro_load,
    A     => p_monpro_a,
    B     => p_monpro_b,
    N     => monpro_n,
    done  => p_monpro_done,
    out_p => p_monpro_p
  );

  -- Montgomery product component that multiplies the result by the current power of 2 of the msg.
  r_monpro : entity work.MonPro(rtl)
  generic map(k => k)
  port map(
    clk   => clk,
    rst_n => rst_n,
    load  => r_monpro_load,
    A     => r_monpro_a,
    B     => r_monpro_b,
    N     => monpro_n,
    done  => r_monpro_done,
    out_p => r_monpro_p
  );

end architecture;

architecture ref of MonExp is
  signal n_reg       : unsigned(k - 1 downto 0);
  signal e_reg       : unsigned(k - 1 downto 0);
  signal r2_reg      : unsigned(k - 1 downto 0);
  signal msg_reg     : unsigned(k - 1 downto 0);
  signal result_reg  : unsigned(k - 1 downto 0);
  signal product_reg : unsigned(k - 1 downto 0);
  
  signal p_monpro_done : std_logic;
  signal p_monpro_load : std_logic;
  signal p_monpro_a    : unsigned(k - 1 downto 0);
  signal p_monpro_b    : unsigned(k - 1 downto 0);
  signal p_monpro_p    : unsigned(k - 1 downto 0);
  signal r_monpro_done : std_logic;
  signal r_monpro_load : std_logic;
  signal r_monpro_a    : unsigned(k - 1 downto 0);
  signal r_monpro_b    : unsigned(k - 1 downto 0);
  signal r_monpro_p    : unsigned(k - 1 downto 0);
begin

--     product = mon_pro(msg, r2_mod, n)
--     result = mon_pro(1, r2_mod, n)
--     for i in range(k):
--         if get_bit(e, i):
--             result = mon_pro(result, product, n)
--         product = mon_pro(product, product, n)
--     result = mon_pro(result, 1, n)
--     return result
  result <= result_reg;
  process begin
    r_monpro_load <= '0';
    p_monpro_load <= '0';
    wait until load = '1';
    wait until rising_edge(clk);
    result_reg <= (others => '0');
    done <= '0';
    n_reg <= n;
    e_reg <= e;
    r2_reg <= r2;
    msg_reg <= msg;
    wait for 0 ns;
    r_monpro_load <= '1';
    r_monpro_a <= to_unsigned(1, k);
    r_monpro_b <= r2_reg;
    p_monpro_load <= '1';
    p_monpro_a <= msg_reg;
    p_monpro_b <= r2_reg;
    wait until rising_edge(clk);
    r_monpro_load <= '0';
    p_monpro_load <= '0';
    wait until r_monpro_done = '1' and p_monpro_done = '1';
    wait until rising_edge(clk);
    result_reg <= r_monpro_p;
    product_reg <= p_monpro_p;
    wait for 0 ns;
    for i in 0 to k-1 loop
        if e_reg(i) = '1' then
            r_monpro_load <= '1';
            r_monpro_a <= result_reg;
            r_monpro_b <= product_reg;
        end if;
        p_monpro_load <= '1';
        p_monpro_a <= product_reg;
        p_monpro_b <= product_reg;
        wait until rising_edge(clk);
        r_monpro_load <= '0';
        p_monpro_load <= '0';
        wait until p_monpro_done = '1';
        wait until rising_edge(clk);
        if e_reg(i) = '1' then
            result_reg <= r_monpro_p;
        end if;
        product_reg <= p_monpro_p;
        wait for 0 ns;
    end loop;
    r_monpro_load <= '1';
    r_monpro_a <= result_reg;
    r_monpro_b <= to_unsigned(1, k);
    wait until rising_edge(clk);
    r_monpro_load <= '0';
    wait until r_monpro_done = '1';
    wait until rising_edge(clk);
    result_reg <= r_monpro_p;
    done <= '1';
  end process;

  r_monpro : entity work.MonPro(rtl)
  generic map(k => k)
  port map(
    clk   => clk,
    rst_n => rst_n,
    load  => r_monpro_load,
    A     => r_monpro_a,
    B     => r_monpro_b,
    N     => n_reg,
    done  => r_monpro_done,
    out_p => r_monpro_p
  );
  p_monpro : entity work.MonPro(rtl)
  generic map(k => k)
  port map(
    clk   => clk,
    rst_n => rst_n,
    load  => p_monpro_load,
    A     => p_monpro_a,
    B     => p_monpro_b,
    N     => n_reg,
    done  => p_monpro_done,
    out_p => p_monpro_p
  );
end architecture ref;