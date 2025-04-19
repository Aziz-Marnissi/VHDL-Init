library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity fsmde is
	generic(
		n:integer:=10
	);
	port(
		clk:in std_logic;
		reset:in std_logic;
		btn:in std_logic;
		clean:out std_logic
	);
end fsmde;
architecture behaviour of fsmde is
	type state is (idle,weit);
	signal etat:state;
	signal button_in:std_logic;
	signal stability:std_logic;
	signal timer:integer range 0 to n;
begin
	process(clk,reset)
	begin
		if reset='1' then
			etat<=idle;
			timer<=n;
			stability<='0';
			button_in<='0';
		elsif rising_edge(clk) then
			button_in<=btn;
			case etat is
				when idle=>
					if button_in /= stability then
						etat<=weit;
					end if;
				when weit=>
					if timer=0 then
						stability<=button_in;
						etat<=idle;
					else
						timer<= timer -1;

					end if;
			end case;
		end if;
	end process;
	clean<=stability;
end behaviour;
			
			
