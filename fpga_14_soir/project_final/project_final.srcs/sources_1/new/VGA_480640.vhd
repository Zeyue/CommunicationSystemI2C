library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity VGA_640480 is
  Port ( clk25 : in STD_LOGIC;
         rst : in STD_LOGIC; -- remise à zéro
         hsync : out STD_LOGIC; -- synchronisation horizontale
         vsync : out STD_LOGIC; -- synchronisation verticale
         hc : out integer; -- signal permettant de connaître le numéro du pixel courant sur une ligne
         vc : out integer; -- signal permettant de connaître le numéro de ligne courant
         vidon : out STD_LOGIC -- signal permettant de savoir si position courante est dans une zone d'affichage ou non
   );
end VGA_640480;

architecture Behavioral of VGA_640480 is

constant hbp : integer := 96 + 48; -- back porch
constant hfp : integer := 640 + 96 + 48; -- front porch
constant hpixels : integer := 800; -- nombres de pixels sur une ligne
constant vbp :integer := 29 + 2; -- back porch
constant vfp : integer := 480 + 29 + 2; -- front porch
constant vlines : integer := 521; -- nombre de lignes par frame

signal counter_h: integer := 0;
signal counter_v: integer := 0;
signal activate_v: STD_LOGIC := '0';

begin

process(clk25, rst, counter_h, counter_v, activate_v)
begin
-- remize à zero
    if (rst = '1') then
        counter_h <= 0;
        counter_v <= 0;
-- compteur horizontal
    elsif (clk25'event and clk25='1') then    
        if (counter_h = hpixels-1) then 
            counter_h <= 0;
            activate_v <= '1';
        else
            counter_h <= counter_h + 1;
            activate_v <= '0';
        end if;
    -- compteur vertical
        if (activate_v = '1') then
            if (counter_v = vlines-1) then 
                counter_v <= 0;
            else
                counter_v <= counter_v + 1;
            end if;
        end if;
    end if;
end process;

hsync <='0' when (counter_h < 96) else '1';
vsync <='0' when (counter_v < 2) else '1';
vidon <='1' when ((counter_h > hbp) and (counter_h < hfp) 
                    and (counter_v > vbp) and (counter_v < vfp)) 
                    else '0';

hc <= counter_h;
vc <= counter_v;

end Behavioral;
