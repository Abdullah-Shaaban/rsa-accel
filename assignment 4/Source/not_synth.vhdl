library IEEE;
use IEEE.std_logic_1164.all;

entity latch is
port (
a : in std_ulogic;
b : in std_ulogic;
y : out std_ulogic
);

end entity latch;
architecture rtl of latch is
begin
    process (a) is
    begin
        if (a = '1') then
            y <= b;
        else
            y <= '0';
        end if;
    end process;
end architecture rtl;