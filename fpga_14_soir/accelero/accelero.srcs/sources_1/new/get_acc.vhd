----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.01.2015 09:14:17
-- Design Name: 
-- Module Name: get_acc - Behavioral
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

entity get_acc is
    Port ( 
    Clk : in STD_LOGIC;
    SDA : inout STD_LOGIC;
    SCL : out STD_LOGIC;
    x_computed : out STD_LOGIC_VECTOR (15 downto 0);
    y_computed : out STD_LOGIC_VECTOR (15 downto 0);
    z_computed : out STD_LOGIC_VECTOR (15 downto 0));
end get_acc;

architecture Behavioral of get_acc is

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
end component;
component module_RW 
Port (
DATA_IN : in STD_LOGIC_VECTOR (7 downto 0);
LOAD_NEXT : in STD_LOGIC;
OCTET_READY : in STD_LOGIC;
CLK : in STD_LOGIC;
ADDR : out STD_LOGIC_VECTOR (6 downto 0);
NUM_IN : out INTEGER;
NUM_OUT : out INTEGER;
DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0);
WRITE : out STD_LOGIC; -- "1" start write
READ : out STD_LOGIC; -- "1" start read
X_COMPUTED : out STD_LOGIC_VECTOR (15 downto 0);
Y_COMPUTED : out STD_LOGIC_VECTOR (15 downto 0);
Z_COMPUTED : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal SlaveAddress :  STD_LOGIC_VECTOR (7 downto 1);
signal  Write :  STD_LOGIC;
signal  DataToTransmit :  STD_LOGIC_VECTOR (7 downto 0);
signal  LoadNextOctetToTransmit :  STD_LOGIC;
signal  Read :  STD_LOGIC;
signal  DataReceived :  STD_LOGIC_VECTOR (7 downto 0);
signal  NextOctetReceivedReady :  STD_LOGIC;
signal  NbToTransmit :  INTEGER;
signal   NbTransmitted :  INTEGER;
signal  NbToReceive :  INTEGER;
signal   NbReceived :  INTEGER;

begin
I2c : I2cSystem port map (
           Clk => Clk,
           SlaveAddress  => SlaveAddress,
           Write  => Write,
           DataToTransmit  => DataToTransmit,
           LoadNextOctetToTransmit  => LoadNextOctetToTransmit,
           Read  =>Read ,
           DataReceived  => DataReceived,
           NextOctetReceivedReady  => NextOctetReceivedReady,
           NbToTransmit  => NbToTransmit,
           NbTransmitted  => NbTransmitted ,
           NbToReceive  => NbToReceive,
           NbReceived  => NbReceived,
           Scl  => Scl,
           Sda  => Sda);
           
rw : module_RW port map (
DATA_IN => DataReceived,
LOAD_NEXT => LoadNextOctetToTransmit,
OCTET_READY => NextOctetReceivedReady,
CLK => Clk,
ADDR => SlaveAddress,
NUM_IN => NbToReceive,
NUM_OUT => NbToTransmit,
DATA_OUT => DataToTransmit,
WRITE => write,
READ => read,
X_COMPUTED => X_COMPUTED,
Y_COMPUTED => Y_COMPUTED,
Z_COMPUTED => Z_COMPUTED );



end Behavioral;
