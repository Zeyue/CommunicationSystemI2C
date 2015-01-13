----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.01.2015 18:01:29
-- Design Name: 
-- Module Name: i2cSystemReadingTB - Behavioral
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

entity i2cSystemReadingTB is
end i2cSystemReadingTB;

architecture Behavioral of i2cSystemReadingTB is

component I2cSystem 
Port ( Clk : in STD_LOGIC;
           SlaveAddress : in STD_LOGIC_VECTOR (7 downto 1);
           --SendAddress : in STD_LOGIC;
           Write : in STD_LOGIC;
           DataToTransmit : in STD_LOGIC_VECTOR (7 downto 0);
           LoadNextOctetToTransmit : out STD_LOGIC;
           Read : in STD_LOGIC;
           DataReceived : out STD_LOGIC_VECTOR (7 downto 0);
           NextOctetReceivedReady : out STD_LOGIC;
           NbToTransmit : in INTEGER;
           NbTransmitted : out INTEGER;
           --DoneTransmitting : out STD_LOGIC;
           NbToReceive : in INTEGER;
           NbReceived : out INTEGER;
           --DoneReceiving : out STD_LOGIC ;
           Scl : out STD_LOGIC;
           Sda : inout STD_LOGIC);
           --sdaAddresser : inout STD_LOGIC);
       --    CurrentState : out STATE_TYPE ;
         --  currAddr : out STD_LOGIC_VECTOR (7 downto 0);
          -- SdaAddr : out STD_LOGIC);
end component;

signal Clk : STD_LOGIC := '0';
signal SlaveAddress : STD_LOGIC_VECTOR (7 downto 1);
signal Write : STD_LOGIC := '0';
signal DataToTransmit : STD_LOGIC_VECTOR (7 downto 0);
--signal DataToTransmit : STD_LOGIC_VECTOR (7 downto 0);
signal LoadNextOctetToTransmit : STD_LOGIC := '0';
signal Read : STD_LOGIC ;
signal DataReceived : STD_LOGIC_VECTOR (7 downto 0);
signal NextOctetReceivedReady : STD_LOGIC  ;
signal NbToTransmit :  INTEGER := 0;
signal NbTransmitted : INTEGER;
           --DoneTransmitting : out STD_LOGIC;
signal NbToReceive : INTEGER ;
signal NbReceived :  INTEGER  ;
           --DoneReceiving : out STD_LOGIC ;
signal Scl :  STD_LOGIC := '0' ;
signal Sda :  STD_LOGIC := '0';
--signal CurrentState : STATE_TYPE;
--signal currAddr : STD_LOGIC_VECTOR (7 downto 0);
--signal SdaAddresser : STD_LOGIC;
constant Clk_period : time := 10 ns;

begin
uut : I2cSystem PORT MAP (
           Clk => Clk,
           SlaveAddress => SlaveAddress,
           --SendAddress : in STD_LOGIC;
           Write => Write,
           DataToTransmit => DataToTransmit,
           LoadNextOctetToTransmit => LoadNextOctetToTransmit,
           Read => Read,
           DataReceived => DataReceived,
           NextOctetReceivedReady => NextOctetReceivedReady,
           NbToTransmit => NbToTransmit,
           NbTransmitted => NbTransmitted,
           --DoneTransmitting : out STD_LOGIC;
           NbToReceive => NbToReceive,
           NbReceived => NbReceived,
           --DoneReceiving : out STD_LOGIC ;
           Scl => Scl,
           Sda => Sda );
          -- sdaAddresser => sdaAddresser);
         --  CurrentState => CurrentState,
         --  CurrAddr => currAddr,
        --   SdaAddr => SdaAddr );
           
Clk_process : process
begin
  Clk <= '0';
  wait for Clk_period / 2;
  Clk <= '1';
  wait for Clk_period / 2;
end process;

stim_proc : process
begin
sda <= 'Z';
--wait for Clk_period * 130;
SlaveAddress <= "1111000";

wait for 100 ns;
NbToReceive <= 1;
Read <= '1';
wait for 87 us;
sda <= '0';
wait for 6 us;
sda <= 'Z';
wait for 3 us;
sda <= '1';
wait for 79 us;
sda <= 'Z';
wait for 18 us;
read <= '0';
wait for 1 ms;
end process;

end Behavioral;



