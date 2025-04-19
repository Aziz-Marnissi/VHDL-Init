library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ledsq is
    port(
        clk    : in  std_logic;
        reset  : in  std_logic;
        enable : in  std_logic;
        leds   : out std_logic_vector(3 downto 0)
    );
end ledsq;

architecture behaviour of ledsq is
    type state is (l0, l1, l2, l3);
    signal current_state, next_state : state;
    signal counter : unsigned(23 downto 0) := (others => '0');
    constant speed : unsigned(23 downto 0) := x"000FFF"; -- Slower speed for visibility
begin
    -- Synchronous process
    process(clk, reset)
    begin 
        if reset = '0' then
            current_state <= l0;
            counter <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                if counter >= speed then 
                    counter <= (others => '0');
                    current_state <= next_state;
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process;

    -- Combinational process
    process(current_state)
    begin
        case current_state is
            when l0 =>
                leds <= "0001";
                next_state <= l1;
            when l1 =>
                leds <= "0010";
                next_state <= l2;
            when l2 =>
                leds <= "0100";
                next_state <= l3;
            when l3 =>
                leds <= "1000";
                next_state <= l0;
            when others =>
                leds <= "0000";
                next_state <= l0;
        end case;
    end process;
end behaviour;
