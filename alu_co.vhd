library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity alu_co is
	port(
		a:in std_logic_vector(3 downto 0);
		b:in std_logic_vector(3 downto 0);
		sel:in std_logic_vector(1 downto 0);
		resultat:out std_logic_vector(3 downto 0);
		eq:out std_logic;
		sup:out std_logic;
		inf:out std_logic
	);
end alu_co;
architecture behaviour of alu_co is
	signal a_int,b_int,res:unsigned(3 downto 0);
begin
	a_int<=unsigned(a);
	b_int<=unsigned(b);
	process(a_int,b_int,sel)
		begin
			if sel="00" then
				res<=a_int + b_int;
			elsif sel="01" then
				res<=a_int- b_int;
			elsif sel="10" then
				res<=a_int or b_int;
			else
				res<=a_int and b_int;
		end if;

		if a_int = b_int then
           	 	eq  <= '1';
            		sup <= '0';
            		inf <= '0';
        	elsif a_int > b_int then
            	      eq  <= '0';
            	      sup <= '1';
                      inf <= '0';
       		 else
            	      eq  <= '0';
            	      sup <= '0';
            	      inf <= '1';
        	end if;
    end process;

    resultat <= std_logic_vector(res);
end behaviour;
			
