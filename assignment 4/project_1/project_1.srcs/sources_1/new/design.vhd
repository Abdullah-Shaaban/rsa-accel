-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;

entity assig2 is
port (
A : in std_ulogic;
B : in std_ulogic;
Q : out std_ulogic;
QN: out std_ulogic
);

end entity assig2;


architecture rtl of assig2 is
begin
  Q <= A nor QN;
  QN <= B nor Q;
end architecture rtl;