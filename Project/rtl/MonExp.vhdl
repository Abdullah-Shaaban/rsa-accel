library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

entity MonExpr is
  generic (k : positive := 256);
  port (
    clk   : in  std_logic;
    rst_n : in  std_logic;
    load  : in  std_logic;
    msg   : in  unsigned(k - 1 downto 0);
    e     : in  unsigned(k - 1 downto 0);
    n     : in  unsigned(k - 1 downto 0);
    r2    : in  unsigned(k - 1 downto 0); -- Precalculated 2^(2*k) mod n
    done  : out std_logic;
    x     : out unsigned(k - 1 downto 0)
  );
end entity MonExpr;

architecture rtl of MonExpr is
  -- Registers
  signal r2_reg  : unsigned(k - 1 downto 0);
  signal msg_reg : unsigned(k - 1 downto 0);
  signal e_reg   : unsigned(k - 1 downto 0);
  signal n_reg   : unsigned(k - 1 downto 0);
  signal x_reg   : unsigned(k - 1 downto 0);

  -- Idle, when load, save to registers, calculate M_bar, calculate initial x_bar, do all the counter steps, which can be 1 or two products. 
  type state_t is (idle_s, setup1_s, setup2_s, calc1_s, calc2_s, calc3_s, done_s);
  signal crnt_state : state_t;

  -- Next state signals
  signal next_state   : state_t;
  signal next_r2_reg  : unsigned(k - 1 downto 0);
  signal next_msg_reg : unsigned(k - 1 downto 0);
  signal next_e_reg   : unsigned(k - 1 downto 0);
  signal next_n_reg   : unsigned(k - 1 downto 0);
  signal next_x_reg   : unsigned(k - 1 downto 0);

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
      P     : out unsigned(k - 1 downto 0));
  end component MonPro;

  -- To control when to load the MonPro, active when it's the first cycle of a state.
  signal first_cycle : std_logic;

  -- MonPro signals
  signal monpro_load : std_logic;
  signal monpro_done : std_logic;
  signal monpro_a    : unsigned(k - 1 downto 0);
  signal monpro_b    : unsigned(k - 1 downto 0);
  signal monpro_n    : unsigned(k - 1 downto 0);
  signal monpro_p    : unsigned(k - 1 downto 0);

begin

  regs : process (rst_n, clk)
  begin
    if rst_n = '0' then
      first_cycle <= '0';
      crnt_state  <= idle_s;
      r2_reg      <= (others => '0');
      msg_reg     <= (others => '0');
      e_reg       <= (others => '0');
      x_reg       <= (others => '0');
    elsif rising_edge(clk) then
      first_cycle <= '1' when next_state /= crnt_state else '0';
      crnt_state  <= next_state;
      r2_reg      <= next_r2_reg;
      msg_reg     <= next_msg_reg;
      e_reg       <= next_e_reg;
      x_reg       <= next_x_reg;
    end if;
  end process;

  comb : process (all)
  begin
    -- Always
    x        <= x_reg;
    monpro_n <= n_reg;

    -- Default transitions
    next_state   <= crnt_state;
    next_r2_reg  <= r2_reg;
    next_msg_reg <= msg_reg;
    next_e_reg   <= e_reg;
    next_n_reg   <= n_reg;
    next_x_reg   <= x_reg;
    count_en     <= '0';
    done         <= '0';
    monpro_a     <= (others => '0');
    monpro_b     <= (others => '0');
    monpro_load  <= '0';

    case crnt_state is
      when idle_s =>
        if load = '1' then
          next_state   <= setup1_s;
          next_r2_reg  <= r2;
          next_msg_reg <= msg;
          next_e_reg   <= e;
          next_n_reg   <= n;
          next_x_reg   <= (0 => '1', others => '0');
        end if;
      when setup1_s =>
        -- M_bar = mon_pro(M, r2_mod, n)
        if first_cycle = '1' then
          monpro_load <= '1';
          monpro_a    <= msg_reg;
          monpro_b    <= r2_reg;
        elsif monpro_done = '1' then
          next_state   <= setup2_s;
          next_msg_reg <= monpro_p;
        end if;
      when setup2_s =>
        -- x_bar = mon_pro(1, r2_mod, n)
        if first_cycle = '1' then
          monpro_load <= '1';
          monpro_a    <= x_reg;
          monpro_b    <= r2_reg;
        elsif monpro_done = '1' then
          next_state <= setup2_s;
          next_x_reg <= monpro_p;
        end if;
      when calc1_s =>
        if first_cycle = '1' then
          monpro_load <= '1';
          monpro_a    <= x_reg;
          monpro_b    <= x_reg;
        elsif monpro_done = '1' then
          next_state <= calc2_s;
          next_x_reg <= monpro_p;
        end if;
      when calc2_s =>
        -- if get_bit(e, i):
        --   x_bar = mon_pro(M_bar, x_bar, n)
        if e_reg(to_integer(counter_reg)) = '1' then
          if first_cycle = '1' then
            monpro_load <= '1';
            monpro_a    <= msg_reg;
            monpro_b    <= x_reg;
          elsif monpro_done = '1' then
            if count_done = '1' then
              next_state <= calc3_s;
            else
              next_state <= calc1_s;
            end if;
          end if;
        else
          if count_done = '1' then
            next_state <= calc3_s;
          else
            next_state <= calc1_s;
          end if;
        end if;
      when calc3_s =>
        -- x = mon_pro(x_bar, 1, n)
        if first_cycle = '1' then
          monpro_load <= '1';
          monpro_a    <= x_reg;
          monpro_b    <= (0 => '1', others => '0');
        elsif monpro_done = '1' then
          next_state <= done_s;
          next_x_reg <= monpro_p;
        end if;
      when done_s =>
        done       <= '1';
        next_state <= idle_s;
      when others => next_state <= idle_s;
    end case;
  end process;

  -- Decrementing Counter
  counter : process (rst_n, clk)
  begin
    if rst_n = '0' then
      counter_reg <= to_unsigned(k - 1, counter_reg'length);
    elsif rising_edge(clk) then
      if count_en = '1' then -- Pulse
        if counter_reg = (others => '0') then
          counter_reg <= to_unsigned(k - 1, counter_reg'length);
        else
          counter_reg <= counter_reg - 1;
        end if;
      end if;
    end if;
  end process;
  count_done <= '1' when counter_reg = (others => '0') else
                '0';

  -- Montgomery product component
  monpro_instance : MonPro
  generic map(k => k)
  port map(
    clk   => clk,
    rst_n => rst_n,
    load  => monpro_load,
    A     => monpro_a,
    B     => monpro_b,
    N     => monpro_n,
    done  => monpro_done,
    P     => monpro_p
  );

end architecture;