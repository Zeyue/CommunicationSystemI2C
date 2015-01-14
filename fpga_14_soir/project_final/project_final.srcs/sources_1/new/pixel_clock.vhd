library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pixel_clock is
    Port ( mclk : in STD_LOGIC;
           raz : in STD_LOGIC;
           clk25 : out STD_LOGIC);
end pixel_clock;

architecture Behavioral of pixel_clock is
signal clk25_bis : STD_LOGIC := '0';
begin
clk25 <= clk25_bis;

-- génération de l'horloge à 25 MHz
process(raz, mclk)
variable k : integer := 1;
begin
    if (raz = '1') then
        k := 1;
        clk25_bis <= '0';
    elsif (mclk'event and mclk='1') then    
        if (k = 2) then
            clk25_bis <= NOT clk25_bis;
            k := 1;
        else
            k := k+1;
        end if;
    end if;
end process;
end Behavioral;

