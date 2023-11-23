library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity exponentiation is
	generic (
		C_block_size : integer := 256;
		CORE_COUNT : integer := 4
	);
	port (
		--input controll
		valid_in	: in STD_LOGIC;
		ready_in	: out STD_LOGIC;

		--input data
		message 	: in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
		key 		: in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
		r2 			: in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );

		--ouput controll
		ready_out	: in STD_LOGIC;
		valid_out	: out STD_LOGIC;

		--output data
		result 		: out STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		--modulus
		modulus 	: in STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		--utility
		clk 		: in STD_LOGIC;
		reset_n 	: in STD_LOGIC;

		-- Last Message flags
		only_one_output : out std_logic;
		no_busy_cores : out std_logic
	);
end exponentiation;


architecture expBehave of exponentiation is

	-- Load and Done signals for each core
	signal load_MonExp, MonExp_done, MonExp_busy : std_logic_vector(CORE_COUNT-1 downto 0);
	signal MonExp_done_ORed : std_logic;

	-- Output buffers for the cores
	type   buff_arr_t is array(0 to CORE_COUNT-1) of std_logic_vector(C_BLOCK_SIZE-1 downto 0); 
	signal msg_out_buffers_d, msg_out_buffers_q : buff_arr_t;
	
	-- Ready Outputs Count:
		-- It is incremented when any of the MonExp cores asserts its "done" signal,and decremented 
		-- when ready_out and valid_out are asserted. We keep msg_out_valid asserted when this counter
		-- is more than 0
	signal ready_outputs_cnt : unsigned(2 downto 0);

	-- Input Core-Turn Counter 
		-- This counter is used to select which core should be loaded if we have valid input message.
		-- It is incremented when valid_in and ready_in are asserted. It chooses the cores strictly 
		-- in order until it overflows and starts back at core 0.
	signal input_cores_turn : unsigned(2 downto 0);

	-- Output Core-Turn Counter
		-- This counter is used to select which core should be read if we have valid output message.
		-- It is incremented when valid_out and ready_out are asserted. It chooses the cores strictly 
		-- in order until it overflows and starts back at core 0.
	signal output_cores_turn : unsigned(2 downto 0);	

begin

	-- Module Outputs Assignment
	-- result <= message xor modulus;
	process(all)
	begin
		valid_out <= '1' when ready_outputs_cnt/=0 else '0';
		-- We are ready when the current core is not busy, and when there is space in the output buffers
		ready_in <= '1' when MonExp_busy(to_integer(input_cores_turn))='0' and ready_outputs_cnt/=CORE_COUNT else '0';
		-- Select the result from the buffer whose turn is given by output_cores_turn
		result <= msg_out_buffers_q(to_integer(output_cores_turn));
		-- Last message flags
		only_one_output <= '1' when ready_outputs_cnt=1 else '0';
		no_busy_cores <= nor MonExp_busy;
	end process;


	-- Selecting the core to load
	process(all)
	begin
		-- By default, we don't load any core
		load_MonExp <= (others => '0');
		for i in 0 to CORE_COUNT-1 loop
			load_MonExp(i) <= '1' when input_cores_turn=i and valid_in='1' and MonExp_busy(i)='0' else '0' ;
		end loop;
	end process;

	-- ORing MonExp_done(i) signals to increment ready_outputs_cnt whenever one of the cores is done
	MonExp_done_ORed <= or MonExp_done;
	
	-- Generating cores
	generate_cores : for i in 0 to CORE_COUNT-1 generate
		-- Instantiate MonExp
		i_MonExp : entity work.MonExp(rtl)
		generic map (
			k => C_BLOCK_SIZE
		)
		port map (
			clk		=> clk,
			rst_n	=> reset_n,
			load	=> load_MonExp(i),
			msg		=> unsigned(message),
			e		=> unsigned(key),
			n		=> unsigned(modulus),
			r2		=> unsigned(r2),
			busy 	=> MonExp_busy(i),
			done	=> MonExp_done(i),
			result	=> msg_out_buffers_d(i)
		);
		-- Reading MonExp's output in the output buffers
		process (reset_n, clk)
		begin
		  if reset_n = '0' then
			msg_out_buffers_q(i) <= (others => '0');
		  elsif rising_edge(clk) then
			if MonExp_done(i)='1' then
				msg_out_buffers_q(i) <= msg_out_buffers_d(i);
			end if;
		  end if;
		end process;
	end generate;


	-- State Counters
	process (reset_n, clk)
	begin
	  if reset_n = '0' then
		ready_outputs_cnt <= (others => '0');
		input_cores_turn <= (others => '0');
		output_cores_turn <= (others => '0');
	  elsif rising_edge(clk) then
		-- Update ready_outputs_cnt
		if MonExp_done_ORed='1' then
			ready_outputs_cnt <= ready_outputs_cnt + 1;
		elsif ready_out and valid_out then
			ready_outputs_cnt <= ready_outputs_cnt - 1;
	  	end if;
		-- Update input_cores_turn (saturates)
		if valid_in and ready_in then
			if input_cores_turn=CORE_COUNT-1 then
				input_cores_turn <= (others => '0');
			else 
				input_cores_turn <= input_cores_turn + 1;
			end if;
	  	end if;
		-- Update output_cores_turn (saturates)
		if valid_out and ready_out then
		   if output_cores_turn=CORE_COUNT-1 then
				output_cores_turn <= (others => '0');
		   else
				output_cores_turn <= output_cores_turn + 1;
		   end if;
	  	end if;
	  end if;
	end process;

end expBehave;
