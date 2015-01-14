library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is
    Port ( 
       Horloge : in STD_LOGIC;
       SDA : inout STD_LOGIC;
       SCL : out STD_LOGIC;
       btnr : in STD_LOGIC; --reset de l'ecran
       hsync : out STD_LOGIC;
       vsync : out STD_LOGIC;
       red : out STD_LOGIC_VECTOR(3 downto 0);
       green: out STD_LOGIC_VECTOR(3 downto 0);
       blue: out STD_LOGIC_VECTOR(3 downto 0));
end TOP;

architecture Behavioral of TOP is
component get_acc is
Port ( 
Clk : in STD_LOGIC;
       SDA : inout STD_LOGIC;
       SCL : out STD_LOGIC;
       x_computed : out STD_LOGIC_VECTOR (15 downto 0);
       y_computed : out STD_LOGIC_VECTOR (15 downto 0);
       z_computed : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component TOP_VGA_sprites is
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
end component;

signal x : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";
signal y : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";
signal z : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";

begin
uut1 : get_acc port map (
    Clk => Horloge,
    SDA => SDA,
    SCL => SCL,
    x_computed => x,
    y_computed => y,
    z_computed => z );

uut2 : TOP_VGA_sprites port map (
    mclk => Horloge,
    btnr => btnr,
  --  SCL => SCL,
    x_computed => x,
    y_computed => y,
    z_computed => z,
    hsync => hsync,
    vsync => vsync,
    red => red,
    green => green,
    blue => blue);

end Behavioral;
