library IEEE;
use IEEE.std_logic_1164.all;

entity latch is
  port (
    d, g : in  std_logic;
    q    : out std_logic
  );

end entity latch;

architecture arch of latch is begin
  q <= d when g = '1' else
       q;
end architecture;