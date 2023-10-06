----------------------------------------------------------------------------------
-- Company    :  NTNU
-- Engineer   : �ystein Gjermundnes
-- 
-- Create Date: 09/11/2016 04:21:16 PM
-- Module Name: mega_adder_datapath
-- Description:   
--   Datapath for the mega_adder. The datapath consists of shift registers
--   at the inputs and outputs and a large 128 bit adder.
--
--   CHALLENGE 1:
--   Set different synthesis constraints for the max frequency and check how the
--   area of the design changes.
--  
--   CHALLENGE 2: 
--   Can you think of a way to significantly increase the max clock frequency 
--   as well as reducing the area?
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_datapath is
  port (      
    -- Clocks and resets
    clk             : in std_logic;
    reset_n         : in std_logic;
    
    -- Data in interface       
    data_in         : in std_logic_vector (31 downto 0);
    input_reg_en    : in std_logic;
    
    -- Data out interface
    data_out        : out std_logic_vector (31 downto 0);
    output_reg_en   : in std_logic;
    output_reg_load : in std_logic);
        
end adder_datapath;

architecture rtl of adder_datapath is

  -- Signals associated with the input registers
  signal a_r, a_nxt: std_logic_vector(127 downto 0);
  signal b_r, b_nxt: std_logic_vector(127 downto 0);
  
  -- Signals associated with the output registers
  signal y_r : std_logic_vector(127 downto 0);
  signal y_load_val : std_logic_vector(127 downto 0);
  
  -- addition signals
  signal add_reg: std_logic_vector(127 downto 0);
  signal add_33: unsigned(32 downto 0);
  signal carry_out : std_logic;
begin

  -- ***************************************************************************
  -- Register a_r and b_r
  -- ***************************************************************************
  process (clk, reset_n) begin
    if(reset_n = '0') then
      a_r <= (others => '0');
      b_r <= (others => '0'); 
    elsif(clk'event and clk='1') then
      if(input_reg_en ='1') then
        a_r <= a_nxt;
        b_r <= b_nxt;      
      end if;
    end if;
  end process;
    
  process (data_in, a_r, b_r) begin
    a_nxt <= data_in & a_r(127 downto 32);
    b_nxt <= a_r(31 downto 0) & b_r(127 downto 32);
  end process; 

  -- ***************************************************************************
  -- Register y_r
  -- Add the content of a_r and b_r and store it in y_r.
  -- Logic for shifting out the content of y_r to data_out
  -- ***************************************************************************
  y_load_val <= std_logic_vector(add_33(31 downto 0)) & add_reg(127 downto 32);
  process (clk, reset_n) begin
    if(reset_n = '0') then
      y_r <= (others => '0');     
    elsif(clk'event and clk='1') then
      if(output_reg_en ='1') then
        if(output_reg_load = '1') then
          y_r <= y_load_val;
        else
          y_r <= x"00000000" & y_r(127 downto 32);
        end if;
      end if;
    end if;
  end process;

  process (clk, reset_n) begin
    if(reset_n = '0') then
      add_reg <= (others => '0');     
      carry_out <= '0';
    elsif(clk'event and clk='1') then
      carry_out <= add_33(32);
      if(input_reg_en = '1') then
        add_reg <= std_logic_vector(add_33(31 downto 0)) & add_reg(127 downto 32);
      end if;
    end if;
  end process;
  add_33 <= unsigned('0' & a_r(127 downto 96)) + unsigned('0' & b_r(127 downto 96)) + ("" & carry_out);
  
  data_out <= y_r(31 downto 0);

end rtl;
