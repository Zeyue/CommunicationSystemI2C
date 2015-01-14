----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2014 15:04:58
-- Design Name: 
-- Module Name: I2C_system - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity I2C_system is
    Port (     Send : in STD_LOGIC;
               Read : in STD_LOGIC;
         ToTransmit : in INTEGER;
        Transmitted : out INTEGER;
             ToRead : in INTEGER;
          OctetsRead : out INTEGER;
       SlaveAddress : in STD_LOGIC_VECTOR ( 7 downto 0);
         DataToSend : in STD_LOGIC_VECTOR (7 downto 0);
           DataRead : out STD_LOGIC_VECTOR (7 downto 0);
                Clk : in STD_LOGIC;
                SCL : out STD_LOGIC;
                SDAR : inout STD_LOGIC ; -- SDA read
                SDAW : inout STD_LOGIC ;
                DoneReading : out STD_LOGIC;
                DoneWriting : out STD_LOGIC);
end I2C_system;

architecture Behavioral of I2C_system is
component ClockGenerator
   Port (   MAINCLK : in STD_LOGIC;
            TRIGGER : in STD_LOGIC;
           BAUDRATE : in INTEGER;
             CLKOUT : out STD_LOGIC );
end component;

component TransmitFSM
   Port (       Clk : in STD_LOGIC;
              BdClk : in STD_LOGIC;
         ToTransmit : in INTEGER;
               Data : in STD_LOGIC_VECTOR (7 downto 0);
           Transmit : in STD_LOGIC;
                SCL : out STD_LOGIC;
                SDA : inout STD_LOGIC;
        Transmitted : out INTEGER;
            BdClkEn : out STD_LOGIC;
            DoneWriting : out STD_LOGIC );
end component;

component ReadFSM is
    Port (        Clk : in STD_LOGIC;
                BdClk : in STD_LOGIC;
               ToRead : in INTEGER;
         SlaveAddress : in STD_LOGIC_VECTOR (7 downto 0);
                 Data : out STD_LOGIC_VECTOR (7 downto 0);
                 Read : in STD_LOGIC;
                  SCL : out STD_LOGIC;
                  SDA : inout STD_LOGIC;
           OctetsRead : out INTEGER;
              BdClkEn : out STD_LOGIC ;
              DoneReading : out STD_LOGIC);
end component;

constant BaudRate : integer := 200000;
signal BdClkEn : STD_LOGIC;
signal BdClk : STD_LOGIC;
--signal Transmitted : integer;

begin
ClkGen : ClockGenerator PORT MAP (
    MAINCLK => Clk,
    TRIGGER => BdClkEn,
    BAUDRATE => BaudRate,
    CLKOUT => BdClk );
    
Transmitter : TransmitFSM PORT MAP (
    Clk => Clk,
    BdClk => BdClk,
    ToTransmit => ToTransmit,
    Data => DataToSend,
    Transmit => Send,
    SCL => SCL,
    SDA => SDAW,
    Transmitted => Transmitted,
    BdClkEn => BdClkEn,
    DoneWriting => DoneWriting );
    
Reader : ReadFSM PORT MAP (
               Clk => Clk,
             BdClk => BdClk,
            ToRead => ToRead,
      SlaveAddress => SlaveAddress,
              Data => DataRead,
              Read => Read,
               SCL => SCL,
               SDA => SDAR,
        OctetsRead => OctetsRead,
           BdClkEn => BdClkEn,
           DoneReading => DoneReading );

end Behavioral;
