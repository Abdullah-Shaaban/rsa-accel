--------------------------------------------------------------------------------
-- Author       : Oystein Gjermundnes
-- Organization : Norwegian University of Science and Technology (NTNU)
--                Department of Electronic Systems
--                https://www.ntnu.edu/ies
-- Course       : TFE4141 Design of digital systems 1 (DDS1)
-- Year         : 2018-2019
-- Project      : RSA accelerator
-- License      : This is free and unencumbered software released into the
--                public domain (UNLICENSE)
--------------------------------------------------------------------------------
-- Purpose:
--   RSA encryption core template. This core currently computes
--   C = M xor key_n
--
--   Replace/change this module so that it implements the function
--   C = M**key_e mod key_n.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity rsa_core is
	generic (
		-- Users to add parameters here
		C_BLOCK_SIZE          : integer := 256
	);
	port (
		-----------------------------------------------------------------------------
		-- Clocks and reset
		-----------------------------------------------------------------------------
		clk                    :  in std_logic;
		reset_n                :  in std_logic;

		-----------------------------------------------------------------------------
		-- Slave msgin interface
		-----------------------------------------------------------------------------
		-- Message that will be sent out is valid
		msgin_valid             : in std_logic;
		-- Slave ready to accept a new message
		msgin_ready             : out std_logic;
		-- Message that will be sent out of the rsa_msgin module
		msgin_data              :  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		-- Indicates boundary of last packet
		msgin_last              :  in std_logic;

		-----------------------------------------------------------------------------
		-- Master msgout interface
		-----------------------------------------------------------------------------
		-- Message that will be sent out is valid
		msgout_valid            : out std_logic;
		-- Slave ready to accept a new message
		msgout_ready            :  in std_logic;
		-- Message that will be sent out of the rsa_msgin module
		msgout_data             : out std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		-- Indicates boundary of last packet
		msgout_last             : out std_logic;

		-----------------------------------------------------------------------------
		-- Interface to the register block
		-----------------------------------------------------------------------------
		key_e_d                 :  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		key_n                   :  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		r2         				:  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		rsa_status              : out std_logic_vector(31 downto 0)

	);
end rsa_core;

architecture rtl of rsa_core is
	-- We buffer the msg_in_last into the msg_last_flag. When MonExp is done ( msgout_valid='1' ) and the output is acknowledged (msgout_ready='1') we bring the flag back to 0
	-- msg_last_flag stores that this is the last message to be compute
	-- Flag2 signals that we are currently computing the last message. 
	-- Flag2 is needed because the last input can assert msg_in_last while we have the previous output valid. 
	signal msg_last_flag, flag2 : std_logic;
begin
	i_exponentiation : entity work.exponentiation
		generic map (
			C_block_size => C_BLOCK_SIZE
		)
		port map (
			message   => msgin_data  ,
			key       => key_e_d     ,
			valid_in  => msgin_valid ,
			ready_in  => msgin_ready ,
			ready_out => msgout_ready,
			valid_out => msgout_valid,
			result    => msgout_data ,
			modulus   => key_n       ,
			r2		  => r2			 ,
			clk       => clk         ,
			reset_n   => reset_n
		);

	process (reset_n, clk)
	begin
		if reset_n = '0' then
			msg_last_flag <= '0';
			flag2 <= '0';
		elsif rising_edge(clk) then
			if msgin_last='1' then
				msg_last_flag  <= '1';
			elsif msgout_valid='1' and msgout_ready='1' then	
				msg_last_flag  <= '0';
			end if;
			if msg_last_flag='1' and msgout_valid='0' then
				flag2 <= '1';
			elsif msgout_valid='1' and msgout_ready='1' then	
				flag2 <= '0';
			end if;
		end if;
	end process;

	msgout_last  <= msg_last_flag and msgout_valid and flag2;
	rsa_status   <= (others => '0');
end rtl;
