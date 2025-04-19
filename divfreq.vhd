library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity divfreq is
    generic(
        n : integer := 100000
    );
    port(
        clk_in  : in  std_logic;
        reset   : in  std_logic;
        clk_out : out std_logic
    );
end divfreq;

architecture behaviour of divfreq is
    signal clk_tmp : std_logic := '0';
    signal counter : integer range 0 to n-1 := 0;
begin
    process(clk_in, reset)
    begin
        if reset = '1' then
            clk_tmp <= '0';
            counter <= 0;
        elsif rising_edge(clk_in) then
            if counter = (n/2 - 1) then
                clk_tmp <= not clk_tmp;
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    clk_out <= clk_tmp;
end behaviour;
