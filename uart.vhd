library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart is
    generic(
        f : integer := 500000;   
        baud : integer := 2540  
    );
    port(
        clk, reset : in std_logic;
        tx_info : in std_logic_vector(7 downto 0);
        rx_info : out std_logic_vector(7 downto 0);
        tx_ready : in std_logic;
        rx_ready : out std_logic;
        tx : out std_logic;
        rx : in std_logic
    );
end uart;

architecture behaviour of uart is
    type etat is (hold, start, data, stop);
    signal tx_state, rx_state : etat := hold;
    signal tx_bit, rx_bit : integer range 0 to 7 := 0;
    signal tx_cycles, rx_cycles : integer range 0 to (f/baud)-1 := 0;
    signal tx_reg, rx_reg : std_logic_vector(7 downto 0) := (others => '0');
    
    
    signal rx_sync : std_logic_vector(2 downto 0) := (others => '1');
    signal rx_falling_edge : std_logic := '0';
    

    constant CYCLES_PER_BIT : integer := f/baud;
begin 



    process(clk, reset)
    begin
        if reset = '1' then
            tx_state <= hold;
            tx_bit <= 0;
            tx_cycles <= 0;
            tx <= '1'; 
        elsif rising_edge(clk) then 
            case tx_state is
                when hold =>
                    tx <= '1';
                    if tx_ready = '1' then
                        tx_reg <= tx_info;
                        tx_state <= start;
                        tx_cycles <= 0;
                    end if;
                    
                when start =>
                    tx <= '0';
                    if tx_cycles = CYCLES_PER_BIT-1 then
                        tx_state <= data;
                        tx_cycles <= 0;
                        tx_bit <= 0;
                    else
                        tx_cycles <= tx_cycles + 1;
                    end if;
                    
                when data =>
                    tx <= tx_reg(tx_bit);
                    if tx_cycles = CYCLES_PER_BIT-1 then
                        tx_cycles <= 0;
                        if tx_bit = 7 then  
                            tx_state <= stop;
                        else
                            tx_bit <= tx_bit + 1;
                        end if;
                    else
                        tx_cycles <= tx_cycles + 1;
                    end if;
                    
                when stop =>
                    tx <= '1';
                    if tx_cycles = CYCLES_PER_BIT-1 then  
                        tx_state <= hold;
                    else
                        tx_cycles <= tx_cycles + 1;
                    end if;
            end case;
        end if;
    end process;

    process(clk, reset)
    begin
        if reset = '1' then
            rx_state <= hold;
            rx_bit <= 0;
            rx_cycles <= 0;
            rx_info <= (others => '0');
            rx_ready <= '0';
        elsif rising_edge(clk) then  
            rx_ready <= '0'; 
            
            case rx_state is
                when hold =>
                    if rx_falling_edge = '1' then  
                        rx_state <= start;
                        rx_cycles <= CYCLES_PER_BIT/2;  
                    end if;
                    
                when start =>
                    if rx_cycles = 0 then
                        if rx_sync(1) = '0' then  
                            rx_state <= data;
                            rx_cycles <= CYCLES_PER_BIT-1;
                            rx_bit <= 0;
                        else
                            rx_state <= hold;
                        end if;
                    else
                        rx_cycles <= rx_cycles - 1;
                    end if;
                    
                when data =>
                    if rx_cycles = 0 then
                        rx_reg(rx_bit) <= rx_sync(1);
                        rx_cycles <= CYCLES_PER_BIT-1;
                        
                        if rx_bit = 7 then
                            rx_state <= stop;
                        else
                            rx_bit <= rx_bit + 1;
                        end if;
                    else
                        rx_cycles <= rx_cycles - 1;
                    end if;
                    
                when stop =>
                    if rx_cycles = 0 then
                        if rx_sync(1) = '1' then  
                            rx_info <= rx_reg;
                            rx_ready <= '1';
                        end if;
                        rx_state <= hold;
                    else
                        rx_cycles <= rx_cycles - 1;
                    end if;
            end case;
        end if;
    end process;
end behaviour;
