library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity du_tog is
    generic(
        DEBOUNCE_CYCLES : natural := 10  -- Number of clock cycles for debounce
    );
    port(
        clk     : in  std_logic;  -- System clock
        reset_n : in  std_logic;  -- Active-low asynchronous reset
        button1 : in  std_logic;  -- Physical button input 1
        button2 : in  std_logic;  -- Physical button input 2
        led1    : out std_logic;  -- Toggle output 1
        led2    : out std_logic   -- Toggle output 2
    );
end du_tog;

architecture Behavioral of du_tog is
    -- Synchronization registers for button inputs
    signal sync_button1 : std_logic_vector(1 downto 0) := "00";
    signal sync_button2 : std_logic_vector(1 downto 0) := "00";
    
    -- Debounced button signals
    signal debounced_button1 : std_logic := '0';
    signal debounced_button2 : std_logic := '0';
    
    -- Previous debounced states for edge detection
    signal prev_button1 : std_logic := '0';
    signal prev_button2 : std_logic := '0';
    
    -- Debounce counters
    signal counter1 : natural range 0 to DEBOUNCE_CYCLES := 0;
    signal counter2 : natural range 0 to DEBOUNCE_CYCLES := 0;
    
    -- Internal toggle states
    signal toggle1 : std_logic := '0';
    signal toggle2 : std_logic := '0';
    
begin
    -- Main process for synchronization, debounce and toggle control
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            -- Asynchronous reset
            sync_button1 <= "00";
            sync_button2 <= "00";
            debounced_button1 <= '0';
            debounced_button2 <= '0';
            prev_button1 <= '0';
            prev_button2 <= '0';
            counter1 <= 0;
            counter2 <= 0;
            toggle1 <= '0';
            toggle2 <= '0';
            
        elsif rising_edge(clk) then
            -- Synchronize button inputs (double flip-flop for metastability)
            sync_button1 <= sync_button1(0) & button1;
            sync_button2 <= sync_button2(0) & button2;
            
            -- Debounce logic for button1
            if sync_button1(1) /= prev_button1 then
                -- Button state changed - reset counter
                prev_button1 <= sync_button1(1);
                counter1 <= 0;
            elsif counter1 < DEBOUNCE_CYCLES then
                -- Count stable cycles
                counter1 <= counter1 + 1;
            else
                -- Stable for required cycles - update debounced signal
                debounced_button1 <= prev_button1;
            end if;
            
            -- Debounce logic for button2 (same as button1)
            if sync_button2(1) /= prev_button2 then
                prev_button2 <= sync_button2(1);
                counter2 <= 0;
            elsif counter2 < DEBOUNCE_CYCLES then
                counter2 <= counter2 + 1;
            else
                debounced_button2 <= prev_button2;
            end if;
            
            -- Toggle control on rising edges
            if debounced_button1 = '1' and prev_button1 = '0' then
                toggle1 <= not toggle1;
            end if;
            
            if debounced_button2 = '1' and prev_button2 = '0' then
                toggle2 <= not toggle2;
            end if;
            
            -- Update previous states for next edge detection
            prev_button1 <= debounced_button1;
            prev_button2 <= debounced_button2;
        end if;
    end process;
    
    -- Connect internal toggle states to outputs
    led1 <= toggle1;
    led2 <= toggle2;
    
end Behavioral;
