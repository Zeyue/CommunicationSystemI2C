library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity Pixel_generator is
    Port ( square_clk: in STD_LOGIC;
           hc : in integer;
           vc : in integer;
           vidon : in STD_LOGIC;
           raz : in STD_LOGIC;
           x_computed : in STD_LOGIC_VECTOR (15 downto 0);
           y_computed : in STD_LOGIC_VECTOR (15 downto 0);
           z_computed : in STD_LOGIC_VECTOR (15 downto 0);
           red : out STD_LOGIC_VECTOR (3 downto 0);
           green : out STD_LOGIC_VECTOR (3 downto 0);
           blue : out STD_LOGIC_VECTOR (3 downto 0)
           );
end Pixel_generator;

architecture Behavioral of Pixel_generator is
-- square

signal x: integer := conv_integer(unsigned(x_computed));
signal y: integer := conv_integer(unsigned(y_computed));
signal z: integer := conv_integer(unsigned(z_computed));

signal squaron : STD_LOGIC;
signal square_xl : integer := 144;
signal square_xr : integer := 183;
signal square_yt : integer := 31;
signal square_yb : integer := 70;

constant deplacement : integer := 5;

begin
squaron <= '1' when ((square_xl < hc) and (hc < square_xr) and (square_yt < vc) and (vc < square_yb)) else '0';

process(raz, square_clk, square_xl, square_yt, square_xr, square_yb)  --left, right, up, down, 
begin
if (square_clk'event and square_clk='1') then
    if (raz = '1') then    
        square_xl <= 144;        
        square_xr <= 183;
        square_yt <= 31;
        square_yb <= 70;
    elsif (x > 0) then --mouvement vers la droite
         if (square_xr + x < 640+144) then
            square_xl <= square_xl + x;
            square_xr <= square_xr + x;
         end if;
    elsif (y < 0) then --mouvement vers le haut
        if ( square_yt - deplacement > 31 ) then 
            square_yt <= square_yt - deplacement;
            square_yb <= square_yb - deplacement;
        end if;
   end if;
end if;
end process;

process(vidon, squaron)
begin
if (vidon = '1' and squaron = '1') then
      red <= "1111";
      green <= "1111";
      blue <= "1111";
else
    red <= "0000";
    green <= "0000";
    blue <= "0000";
end if;
end process; 

end Behavioral;
