library ieee;
use ieee.std_logic_1164.all;
entity regcir is
	generic(
		n:integer:=8
	);
    	port (
        -- Signaux de contrôle
        	clk       : in  STD_LOGIC;
        	reset     : in  STD_LOGIC;
        	enable    : in  STD_LOGIC;                     -- Activation globale
        	direction : in  STD_LOGIC;                     -- '1'=droite, '0'=gauche
        	load      : in  STD_LOGIC;                     -- Chargement parallèle
        
        -- Entrées données
        	parallel_in : in  STD_LOGIC_VECTOR(n-1 downto 0); -- Entrée parallèle
        	serial_in   : in  STD_LOGIC;                          -- Entrée série
        
        -- Sorties
        	parallel_out : out STD_LOGIC_VECTOR(n-1 downto 0); -- Sortie parallèle
        	serial_out   : out STD_LOGIC                           -- Sortie série
    );
end regcir;
architecture behaviour of regcir is
	signal decalage:std_logic_vector(n-1 downto 0):=(others=>'0');
begin
	process(reset,clk)
	begin
		if reset='1' then
			decalage<=(others=>'0');
		elsif rising_edge(clk) then
			if enable='1' then
				if load='1' then
					decalage<=parallel_in;
				else
					if direction='1' then
						decalage<=serial_in & decalage(n-1 downto 0);
					else
						decalage<=decalage(n-2 downto 0)& serial_in;
					end if;
				end if;
			end if;
		end if;
	end process;
	parallel_out<=decalage;
	serial_out<=decalage(0) when direction='1' else
					decalage(n-1);
end behaviour;
		
			
			
			
	

