library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb is
end tb;

architecture mytb of tb is
    signal a, b, clk, reset, q: std_logic;
begin
    dut: entity work.task3(design1) port map (a, b, q);
    
    process begin
    a <= '0';
    b <= '0';
    wait for 100 ns;
    a <= '1';
    wait for 100 ns;
    b <= '1';
    wait for 100 ns;
    a <= '0';
    wait for 100 ns;
    a <= '1'; 
    wait;
    end process;
end mytb;
