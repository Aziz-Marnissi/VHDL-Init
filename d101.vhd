library ieee;
use ieee.std_logic_1164.all;
entity d101 is
	port(
		clk,reset,e:in std_logic;
		seq:out std_logic
	);
end d101;
architecture behaviour of d101 is
	type state is(e0,e1,e2,e3);
	signal etat_act,etat_suivant:state;
begin
		process(reset,clk)
		begin
			if reset='1' then
				etat_act<=e0;
			elsif rising_edge(clk) then
				etat_act<=etat_suivant;
			end if;
		end process;
		process(etat_act,e)
		begin
			case etat_act is
				when e0=>
					if e='1' then
						etat_suivant<=e1;
					else
						etat_suivant<=e0;
					end if;
					seq<='0';
				when e1=>
					if e='1' then
						etat_suivant<=e2;
					else
						etat_suivant<=e3;
					end if;
					seq<='0';
				when e2=>
					if e='1' then
						etat_suivant<=e3;
					else
						etat_suivant<=e2;
					end if;
					seq<='0';
				when e3=>
					seq<='1';
					if e='1' then
						etat_suivant<=e1;
					else
						etat_suivant<=e2;
					end if;
					
			end case;
	end process;
end behaviour;
			
			

