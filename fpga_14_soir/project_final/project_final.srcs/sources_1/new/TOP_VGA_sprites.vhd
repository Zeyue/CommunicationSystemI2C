library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP_VGA_sprites is
  Port ( mclk : in STD_LOGIC;
         btnr : in STD_LOGIC;
         x_computed : in STD_LOGIC_VECTOR (15 downto 0);
         y_computed : in STD_LOGIC_VECTOR (15 downto 0);
         z_computed : in STD_LOGIC_VECTOR (15 downto 0);
         hsync : out STD_LOGIC;
         vsync : out STD_LOGIC;
         red : out STD_LOGIC_VECTOR(3 downto 0);
         green: out STD_LOGIC_VECTOR(3 downto 0);
         blue: out STD_LOGIC_VECTOR(3 downto 0) );
end TOP_VGA_sprites;

architecture Behavioral of TOP_VGA_sprites is
component pixel_clock is
    Port ( mclk : in STD_LOGIC;
           raz : in STD_LOGIC;
           clk25 : out STD_LOGIC);
end component;

component VGA_640480 is
    Port ( clk25 : in STD_LOGIC;
           rst : in STD_LOGIC; -- remise à zéro
           hsync : out STD_LOGIC; -- synchronisation horizontale
           vsync : out STD_LOGIC; -- synchronisation verticale
           hc : out integer; -- signal permettant de connaître le numéro du pixel courant sur une ligne
           vc : out integer; -- signal permettant de connaître le numéro de ligne courant
           vidon : out STD_LOGIC -- signal permettant de savoir si position courante est dans une zone d'affichage ou non
   );
end component;

component square_clock is
    Port ( mclk : in STD_LOGIC;
           square_clk : out STD_LOGIC);
end component;

component Pixel_generator is
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
           blue : out STD_LOGIC_VECTOR (3 downto 0) );
end component;

signal clk25_bis : STD_LOGIC := '0';
signal square_clk_bis : STD_LOGIC := '0';
signal hc_bis : integer := 0;
signal vc_bis : integer := 0;
signal vidon_bis : STD_LOGIC := '0';

begin
uut1 : pixel_clock port map (
    mclk => mclk,
    raz => btnr,
    clk25 => clk25_bis );

uut2 : VGA_640480 port map (
    clk25 => clk25_bis,
    rst => btnr,
    hsync => hsync,
    vsync => vsync,
    hc => hc_bis,
    vc => vc_bis,
    vidon => vidon_bis);

uut3 : square_clock port map ( 
   mclk => mclk,
   square_clk => square_clk_bis);

uut4 : Pixel_generator port map (
    square_clk => square_clk_bis,
    hc => hc_bis,
    vc => vc_bis,
    vidon => vidon_bis,
    raz => btnr,
    x_computed => x_computed,
    y_computed => y_computed,
    z_computed => z_computed,
    red => red,
    green => green,
    blue => blue);

end Behavioral;