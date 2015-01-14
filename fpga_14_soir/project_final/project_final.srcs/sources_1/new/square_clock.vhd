library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity square_clock is
    Port ( mclk : in STD_LOGIC;
           square_clk : out STD_LOGIC);
end square_clock;

architecture Behavioral of square_clock is
signal square_clk_bis : STD_LOGIC := '0';
begin
square_clk <= square_clk_bis;


process(mclk)
variable k : integer := 1;
begin
    if (mclk'event and mclk='1') then    
        if (k = 500000) then
            square_clk_bis <= NOT square_clk_bis;
            k := 1;
        else
            k := k+1;
        end if;
    end if;
end process;
end Behavioral;

