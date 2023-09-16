library IEEE;
use IEEE.std_logic_1164.all;

entity latch is
port (
D : in std_ulogic;
clk : in std_ulogic;
Q : out std_ulogic
);

end entity latch;
architecture rtl of latch is
begin
    process(clk) is 
    begin
        if clk='1' then
            Q <= D;
        end if;
    end process;
end architecture rtl;
