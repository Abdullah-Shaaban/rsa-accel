library ieee;
use ieee.std_logic_1164.all;

entity task2 is
  port (
    a, b       : in  std_logic;
    clk, reset : in  std_logic;
    y          : out std_logic  
  );
end entity;

architecture design1 of task2 is
begin
  process (clk) is
  begin
   y <= a xor b;
   end process;

  process (clk, reset) is
    variable t : std_ulogic;
  begin
    if (reset = '1') then
      t := '0';
      y <= '0';
    elsif (rising_edge(clk)) then
      y <= t;
      t := a xor b;
    end if;
  end process;
end architecture;

--architecture design2 of task2 is
--begin
--  process (clk, reset) is
--    variable t : std_ulogic;
--  begin
--    if (reset = '1') then
--      t := '0';
--      y <= '0';
--    elsif (rising_edge(clk)) then
--      t := a xor b;
--      y <= t;
--    end if;
--  end process;
--end architecture;