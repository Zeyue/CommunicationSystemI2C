----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2014 19:27:02
-- Design Name: 
-- Module Name: get_part_id - Behavioral
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

entity get_part_id is
    Port ( Clk : in STD_LOGIC;
           getID : in STD_LOGIC ;
            ID : out STD_LOGIC_VECTOR (7 downto 0);
            SCL : out STD_LOGIC;
            SDA : inout STD_LOGIC);
end get_part_id;

architecture Behavioral of get_part_id is
component I2C_system is
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
               SDAR : inout STD_LOGIC ;
               SDAW : inout STD_LOGIC ;
               DoneReading : out STD_LOGIC;
               DoneWriting : out STD_LOGIC);
end component;

signal Send : STD_LOGIC := '0';
signal Read : STD_LOGIC := '0';
signal ToTransmit : INTEGER := 0;
signal Transmitted : INTEGER := 0;
signal ToRead : INTEGER := 0;
signal OctetsRead : INTEGER := 0;
constant SlaveAddress : STD_LOGIC_VECTOR := "01111011";
signal DataToSend : STD_LOGIC_VECTOR (7 downto 0);
signal DataRead : STD_LOGIC_VECTOR (7 downto 0);
signal DoneReading: STD_LOGIC := '1';
signal DoneWriting : STD_LOGIC := '1';
signal SDAR : STD_LOGIC;
signal SDAW : STD_LOGIC;

begin

I2C_Bus : I2C_system PORT MAP (
              Send => Send,
              Read => Read,
        ToTransmit => ToTransmit,
       Transmitted => Transmitted,
            ToRead => ToRead,
         OctetsRead => OctetsRead,
      SlaveAddress => SlaveAddress,
        DataToSend => DataToSend,
          DataRead => ID,
               Clk => Clk,
               SCL => SCL,
               SDAR => SDAR,
               SDAW => SDAW,
               DoneReading => DoneReading,
               DoneWriting => DoneWriting);

Clk_process : process (Clk, getID)
begin
if Clk' event and Clk = '1' and getID = '1' then
    SDA <= SDAR and SDAW;
    if Transmitted = 0 then 
        ToTransmit <= 2;
        DataToSend <= "01111010";
        Send <= '1';
    elsif Transmitted = 1 then
        ToTransmit <= 2;
        DataToSend <= "00000000";
        Send <= '1';
    elsif DoneWriting = '1' and OctetsRead = 0 then
        ToTransmit <= 0;
        Send <= '0';
        ToRead <= 1;
        Read <= '1';
    end if;
        
end if;

end process;

end Behavioral;
