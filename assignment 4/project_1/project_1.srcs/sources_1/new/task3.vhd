library ieee;
use ieee.std_logic_1164.all;

entity task3 is
  port (
    a, b : in  std_logic;
    y    : out std_logic
  );
end entity;

architecture design1 of task3 is
begin

  process (a) is
  begin
    if a = '1' then
      y <= b;
    else
      y <= '0';
    end if;
  end process;
end architecture;