library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity exponentiation is
	generic (
		C_block_size : integer := 256
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
		reset_n 	: in STD_LOGIC
	);
end exponentiation;


architecture expBehave of exponentiation is

	signal MonExp_result : unsigned(C_block_size-1 downto 0);
	signal load_MonExp, MonExp_done : std_logic;
	--FSM
	-- We have the register "ready_for_input" for the input state. We are ready upon reset and when MonExp is done
	-- The register "msg_out_valid" is for the output state. The value in msg_out_buf is valid when MonExp is done,
	-- and it stays valid until it is acknowledged. 
	-- The Buffer "msg_out_buf" for MonExp output allows starting the next message even if we are still waiting for 
	-- the output to be acknowledged
	type input_state_t is (reset_s, ready_s, busy_s);
	signal input_state : input_state_t;
	signal msg_out_buf: STD_LOGIC_VECTOR(C_block_size-1 downto 0); 
	signal msg_out_valid : std_logic; --Says that the buffer value is valid
begin
	-- result <= message xor modulus;
	result <= msg_out_buf;
	valid_out <= msg_out_valid;
	ready_in <= '1' when input_state=ready_s else '0';

	process (reset_n, clk)
	begin
	  if reset_n = '0' then
		msg_out_valid <= '0';
		input_state <= reset_s;
		msg_out_buf <= (others => '0');
	  elsif rising_edge(clk) then
		if MonExp_done='1' then
			msg_out_buf <= std_logic_vector(MonExp_result);
			msg_out_valid <= '1';
		elsif ready_out = '1' then
			msg_out_valid <= '0';
		end if;
		-- Changing input state
		case input_state is
			when reset_s =>
			  input_state <= ready_s;
			when ready_s =>
				if valid_in='1' then
					input_state <= busy_s;
				end if;
			when busy_s =>
				if MonExp_done='1' then
					input_state <= ready_s;
				end if;
		end case;
	  end if;
	end process;

	load_MonExp <= '1' when input_state=ready_s and valid_in='1' else '0';

	i_MonExp : entity work.MonExp(rtl)
		generic map (
			k => C_BLOCK_SIZE
		)
		port map (
			clk		=> clk,
			rst_n	=> reset_n,
			load	=> load_MonExp,
			msg		=> unsigned(message),
			e		=> unsigned(key),
			n		=> unsigned(modulus),
			r2		=> unsigned(r2),
			done	=> MonExp_done,
			result	=> MonExp_result
		);

	

end expBehave;
