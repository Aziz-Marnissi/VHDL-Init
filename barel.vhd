library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity barel is
	generic(
		n:integer:=10
	);
	port(
		data_in:in std_logic_vector(n-1 downto 0);
		data_out: out std_logic_vector(n-1 downto 0);
		dec:in std_logic_vector(n-1 downto 0);
		op:in std_logic_vector(1 downto 0)
	);
end barel;
architecture behaviour of barel is
begin
	process(dec,op,data_in)
		variable dec_v:integer;
	begin
		dec_v:=to_integer(unsigned(dec)) mod n ;
		if op="00" then
			data_out<=std_logic_vector(shift_right(unsigned(data_in),dec_v));
		
		elsif op="01" then
			data_out<=std_logic_vector(shift_left(unsigned(data_in),dec_v));
		elsif op="10" then
			data_out<=std_logic_vector(shift_right(signed(data_in),dec_v));
		elsif op="11" then
			data_out<=std_logic_vector(shift_left(signed(data_in),dec_v));
		else
			data_out<=(others=>'0');
		end if;
	end process;
end behaviour;
	
		

