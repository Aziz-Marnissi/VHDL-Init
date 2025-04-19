library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity memo is
	port(
		data_in:in std_logic_vector(3 downto 0);

		addr:in std_logic_vector(1 downto 0);
		rw:in std_logic;
		clk:in std_logic;
		data_out:out std_logic_vector(3 downto 0)
	);
end memo;
architecture behaviour of memo is
	type memo_type is array(0 to 3 ) of std_logic_vector(3 downto 0);
	signal memory:memo_type:=(others=>(others=>'0'));
	signal tmp_out:std_logic_vector(3 downto 0);
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if rw='1' then
				memory(to_integer(unsigned(addr)))<=data_in;
			else
				tmp_out<=memory(to_integer(unsigned(addr)));
			end if;
		end if;
	end process;
	data_out<=tmp_out;
end behaviour;
