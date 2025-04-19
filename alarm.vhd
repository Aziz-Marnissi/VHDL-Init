library ieee;
use ieee.std_logic_1164.all;

entity alarm is
    port(
        arm    : in  std_logic;   -- Signal d'armement
        disarm : in  std_logic;   -- Signal de désarmement
        capt   : in  std_logic;   -- Signal du capteur
        clk    : in  std_logic;   -- Horloge
        reset  : in  std_logic;   -- Reset asynchrone
        al_out : out std_logic    -- Sortie d'alarme
    );
end alarm;

architecture behaviour of alarm is
    type state is (armed, disarmed, detector);
    signal etat : state;
begin
    process(clk, reset)
    begin
        if reset = '1' then    
            etat <= disarmed;
        elsif rising_edge(clk) then
            case etat is
                when disarmed =>
                    if arm = '1' then
                        etat <= armed;
                    elsif capt = '1' then
                        etat <= detector;
                    end if;
                
                when armed =>
                    if disarm = '1' then
                        etat <= disarmed;
                    elsif capt = '1' then
                        etat <= detector;
                    end if;
                
                when detector =>
                    if disarm = '1' then
                        etat <= disarmed;
                    end if;
            end case;
        end if;
    end process;

    al_out <= '1' when etat = detector else '0';
end behaviour;
