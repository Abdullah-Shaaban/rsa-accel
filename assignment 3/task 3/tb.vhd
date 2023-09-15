-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb is
end entity tb;

architecture stimuli of tb is
  signal A  : std_logic;
  signal B  : std_logic;
  signal Q  : std_logic;
  signal QN : std_logic;

  impure function rand_bit(n : integer) return std_logic is
    variable r            : real;
    variable out1         : std_logic;
    variable seed1, seed2 : integer := 50;
  begin
    uniform(seed1, seed2, r);
    out1 := '1' when r > 0.5 else
            '0';
    return out1;
  end function;

begin
  DUT : entity work.assig2 port map (A => A, B => B, Q => Q, QN => QN);
  process is
  begin
    A <= '0';
    B <= '1';
    wait for 10 ns;
    A <= '0';
    B <= '0';
    wait for 10 ns;
    A <= '1';
    B <= '0';
    wait for 10 ns;
    A <= '0';
    B <= '0';
    wait for 10 ns;
    A <= '1';
    B <= '0';
    wait for 10 ns;
    A <= '0';
    B <= '1';
    wait for 10 ns;
    B <= '1';
    A <= '1';
    wait for 10 ns;
    -- Oscillation here:
    -- B <= '0' ; 
    -- A <= '0' ;
    -- wait for 10 ns ;
    wait;
  end process;

end architecture stimuli;