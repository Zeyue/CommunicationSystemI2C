----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2014 19:22:37
-- Design Name: 
-- Module Name: tb_I2C_system - Behavioral
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

entity tb_I2C_system is
end tb_I2C_system;

architecture Behavioral of tb_I2C_system is
component I2C_system
port (   Send : in STD_LOGIC;
         Receive : in STD_LOGIC;
      ToTransmit : in INTEGER;
     Transmitted : out INTEGER;
          ToRead : in INTEGER;
      DataToSend : in STD_LOGIC_VECTOR (7 downto 0);
        DataRead : out STD_LOGIC_VECTOR (7 downto 0);
            Done : out STD_LOGIC;
             Clk : in STD_LOGIC;
             SCL : out STD_LOGIC;
             SDA : inout STD_LOGIC );
end component;

signal Clk : STD_LOGIC := '0';
--signal BdClk : STD_LOGIC := '0';
signal Send : STD_LOGIC := '0';

signal Transmitted : INTEGER;
signal Done : STD_LOGIC;
signal BdClkEn : STD_LOGIC;
signal Receive : STD_LOGIC := '0';
signal bytesToTransmit : integer := 3;
signal ToRead : integer := 0;
signal DataToSend : STD_LOGIC_VECTOR (7 downto 0) := "10101001";
signal DataRead : STD_LOGIC_VECTOR (7 downto 0);
signal SCL : STD_LOGIC;
signal SDA : STD_LOGIC;

constant Clk_period : time := 10 ns;
--constant BdClk_period : time := 100 ns;

begin
uut : I2C_system PORT MAP ( 
           Send => Send,
        Receive => Receive,
     ToTransmit => bytesToTransmit,
     Transmitted => Transmitted,
         ToRead => ToRead,
     DataToSend => DataToSend,
       DataRead => DataRead,
           Done => Done,
            Clk => Clk,
            SCL => SCL,
            SDA  => SDA);

Clk_process : process
begin
Clk <= '0';
wait for Clk_period / 2;
Clk <= '1';
wait for Clk_period / 2;
end process;

stim_proc : process
begin
wait for 100 ns;
wait for Clk_period * 130;
Send <= '1';
wait for Clk_period;
--Send <= '0';
--wait for Clk_period * 330;
--Send <= '1';
--wait for Clk_period;
--Send <= '0';
wait;
end process;

end Behavioral;
