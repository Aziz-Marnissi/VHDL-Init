library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity code is
    port(
        clk     : in  std_logic;
        reset   : in  std_logic;
        data_in : in  std_logic;
        enter   : in  std_logic;
        unlock  : out std_logic;
        alarm   : out std_logic
    );
end code;

architecture behaviour of code is
    type state is (idle, input, verify, success, failure);
    signal etat, suivant : state;
    signal reg : std_logic_vector(3 downto 0) := "0000";
    constant mdp : std_logic_vector(3 downto 0) := "1101";
    signal counter : integer range 0 to 3 := 0;
    signal nb_code : integer range 0 to 10 := 0;  -- Changed to integer
    signal closed : std_logic := '0';
begin
    -- State register process
    process(clk, reset)
    begin
        if reset = '1' then
            reg <= "0000";
            counter <= 0;
            etat <= idle;
            nb_code <= 0;
            closed <= '0';
        elsif rising_edge(clk) then
            etat <= suivant;
            
            -- Shift register logic
            if etat = input and enter = '1' and closed = '0' then
                reg <= reg(2 downto 0) & data_in;
                counter <= counter + 1;
            elsif etat = idle then
                reg <= "0000";
                counter <= 0;
            end if;
            
            -- Failure counter logic
            if etat = failure then
                if nb_code < 10 then
                    nb_code <= nb_code + 1;
                else
                    closed <= '1';
                end if;
            elsif etat = success then
                closed <= '0';
                nb_code <= 0;
            end if;
        end if;
    end process;

    -- State transition logic
    transition: process(etat, enter, reg, closed, counter)
    begin
        suivant <= etat; -- Default: stay in current state
        
        case etat is
            when idle =>
                if enter = '1' and closed = '0' then
                    suivant <= input;
                end if;
                
            when input =>
                if counter = 3 then -- Received 4 bits
                    suivant <= verify;
                end if;
                
            when verify =>
                if reg = mdp then
                    suivant <= success;
                else
                    suivant <= failure;
                end if;
                
            when success =>
                suivant <= idle;
                
            when failure =>
                suivant <= idle; -- Transition back after failure handling
        end case;
    end process;

    -- Output logic
    unlock <= '1' when etat = success else '0';
    alarm <= '1' when etat = failure else '0';
    
end behaviour;
