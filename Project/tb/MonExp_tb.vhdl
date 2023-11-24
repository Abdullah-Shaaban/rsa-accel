library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use std.textio.all;

entity MonExp_tb is
end entity MonExp_tb;

architecture tb of MonExp_tb is
  constant base_path : string := "C:/My_Computer/Study_Work_materials/EMECS/NTNU/Fall_Semester/DDS/dds-group10/Project/tb/";
  file inputs_file   : text open read_mode is base_path & "exp_golden_inputs.txt";
  file golden_file   : text open read_mode is base_path & "exp_golden_outputs.txt";
  constant cycle     : time     := 10 ns;
  constant k         : positive := 256;
  signal clk         : std_logic := '1';
  signal rst_n       : std_logic;
  signal load        : std_logic;
  signal N           : unsigned(k - 1 downto 0);
  signal r2          : unsigned(k - 1 downto 0);
  signal e           : unsigned(k - 1 downto 0);
  signal msg         : unsigned(k - 1 downto 0);
  signal done        : std_logic;
  signal result_sig  : std_logic_vector(k - 1 downto 0);
  signal ref_done    : std_logic;
  signal ref_result  : unsigned(k - 1 downto 0);
  signal result      : unsigned(k - 1 downto 0);
  signal expected    : unsigned(k - 1 downto 0);
  component MonExp is
    generic (k : positive := 256);
    port (
      clk    : in  std_logic;
      rst_n  : in  std_logic;
      load   : in  std_logic;
      msg    : in  unsigned(k - 1 downto 0);
      e      : in  unsigned(k - 1 downto 0);
      n      : in  unsigned(k - 1 downto 0);
      r2     : in  unsigned(k - 1 downto 0);
      done   : out std_logic;
      busy   : out std_logic;
      result : out std_logic_vector(k - 1 downto 0)
    );
  end component MonExp;

  procedure read_value(signal num : out unsigned(k - 1 downto 0); file read_file : text) is
    variable num_var     : unsigned(k - 1 downto 0);
    variable read_line   : line;
    variable golden_line : line;
  begin
    readline(read_file, read_line);
    hread(read_line, num_var);
    num <= num_var;
  end procedure read_value;

begin

  clk <= not clk after cycle/2;

  DUT : entity work.MonExp(rtl)
  generic map(k => k)
  port map(
    clk    => clk,
    rst_n  => rst_n,
    load   => load,
    msg    => msg,
    e      => e,
    n      => N,
    r2     => r2,
    done   => done,
    result => result_sig
  );
  
  -- REF : entity work.MonExp(ref)
  -- generic map(k => k)
  -- port map(
  --   clk    => clk,
  --   rst_n  => rst_n,
  --   load   => load,
  --   msg    => msg,
  --   e      => e,
  --   n      => N,
  --   r2     => r2,
  --   done   => ref_done,
  --   result => ref_result
  -- );

  process begin
    wait until load = '1';
    result <= (others => '0');
    wait until done = '1';
    result <= unsigned(result_sig);
  end process;
 
  stimuli : process is
    variable ok             : boolean;
    variable A_var          : unsigned(k - 1 downto 0);
    variable B_var          : unsigned(k - 1 downto 0);
    variable P_expected_var : unsigned(k - 1 downto 0);

  begin
    rst_n <= '0';
    load  <= '0';
    msg   <= (others => '0');
    e     <= (others => '0');
    n     <= (others => '0');
    r2    <= (others => '0');
    wait for 2 * cycle;--2.5*cycle;
    rst_n <= '1';
    wait for 2 * cycle;--2.5*cycle;
    while not endfile(inputs_file) loop
      read_value(expected, golden_file);
      read_value(n, inputs_file);
      read_value(r2, inputs_file);
      read_value(e, inputs_file);
      read_value(msg, inputs_file);
      load <= '1';
      wait for cycle;
      load <= '0';
      wait until done = '1';
      wait for 0 ns; -- Insert 1 delta
      assert (result = expected)
      report "Expected Output is: " & to_hstring(expected) & " but Dut Output is: " & to_hstring(result)
        severity warning;
      wait for cycle;
    end loop;
    wait;
  end process;

end architecture tb;