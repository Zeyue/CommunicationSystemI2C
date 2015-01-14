----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.12.2014 15:54:24
-- Design Name: 
-- Module Name: MUX - Behavioral
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
use work.state_type_pkg.all;

entity MUX is
    Port ( Clk : in STD_LOGIC;
           SclTransmitter : in STD_LOGIC;
           SclAddresser : in STD_LOGIC;
           SclReceiver : in STD_LOGIC;          
           SdaTransmitter : inout STD_LOGIC;
           SdaAddresser : inout STD_LOGIC;
           SdaReceiver : inout STD_LOGIC ;
           BdClkEnTransmitter : in STD_LOGIC;
           BdClkEnAddresser : in STD_LOGIC;
           BdClkEnReceiver : in STD_LOGIC;
           RWAddresser : in STD_LOGIC;---------------------------------------------------------------------------
           RWTransmitter : in STD_LOGIC;
           RWReceiver : in STD_LOGIC;
           BdClkEn : out STD_LOGIC;
           Scl : out STD_LOGIC;
           Sda : inout STD_LOGIC;
           state : in STATE_TYPE );
end MUX;

architecture Behavioral of MUX is

begin
Multiplexing : process (Clk)
begin
if (Clk' event and Clk = '1') then
if state = SendingAddress then 
    Scl <= SclAddresser;
    if RWAddresser = '0' then   ----------------------------------------------------------------------------------------------------------   
        sdaAddresser <= 'Z';
        sda <= sdaAddresser;
    else 
        sda <= 'Z';
        sdaAddresser <= sda;
    end if;                     --------------------------------------------------------------------------------------------------------------
    BdClkEn <= BdClkEnAddresser;
    SdaTransmitter <= 'Z';
    SdaReceiver <= 'Z';
elsif state = TransmittingData then
    Scl <= SclTransmitter;
    if RWTransmitter = '0' then
      SdaTransmitter <= 'Z';
      Sda <= SdaTransmitter;
    else
      Sda <= 'Z';
      SdaTransmitter <= Sda;
    end if;
    BdClkEn <= BdClkEnTransmitter;
    SdaAddresser <= 'Z';
    SdaReceiver <= 'Z';
elsif state = ReceivingData then
    Scl <= SclReceiver;
    if RWReceiver = '0' then
      SdaReceiver <= 'Z';
      Sda  <= SdaReceiver;
    else
      Sda <= 'Z';
      SdaReceiver <= Sda;
    end if;
    BdClkEn <= BdClkEnReceiver;
    SdaAddresser <= 'Z';
    SdaTransmitter <= 'Z';
else Scl <= '1';
     Sda <= '1';
     BdClkEn <= '0';
     SdaAddresser <= 'Z';
     SdaTransmitter <= 'Z';
     SdaReceiver <= 'Z';
end if;
end if;
end process;


end Behavioral;
