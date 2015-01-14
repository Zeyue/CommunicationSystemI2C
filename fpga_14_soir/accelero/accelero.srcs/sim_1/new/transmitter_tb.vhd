----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.01.2015 17:39:21
-- Design Name: 
-- Module Name: transmitter_tb - Behavioral
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

entity transmitter_tb is
end transmitter_tb;

architecture Behavioral of transmitter_tb is
component Transmit
 Port (         Clk : in STD_LOGIC;
                BdClk : in STD_LOGIC;
                HalftimeBdClk : in STD_LOGIC;
         NbToTransmit : in INTEGER;
                 Data : in STD_LOGIC_VECTOR (7 downto 0);
             Transmit : in STD_LOGIC;
                  SCL : out STD_LOGIC;
                  SDA : inout STD_LOGIC;
        NbTransmitted : out INTEGER;
              BdClkEn : out STD_LOGIC; 
 LoadNextOctetToTransmit : out STD_LOGIC;
     DoneTransmitting : out STD_LOGIC);
end component;

signal Clk :  STD_LOGIC;
signal BdClk :  STD_LOGIC;
signal HalftimeBdClk : STD_LOGIC;
signal NbToTransmit :  INTEGER;
signal Data :  STD_LOGIC_VECTOR (7 downto 0);
signal goTransmit :  STD_LOGIC;
signal SCL :  STD_LOGIC;
signal SDA :  STD_LOGIC;
signal NbTransmitted :  INTEGER;
signal  BdClkEn :  STD_LOGIC; 
signal  LoadNextOctetToTransmit :  STD_LOGIC;
signal DoneTransmitting :  STD_LOGIC;
constant Clk_period : time := 10 ns;
constant BdClk_period : time := 5 us;
constant baudrate : integer := 200000;
constant mainfreq : integer := 100000000;
signal counter : integer;




begin

uut : transmit PORT MAP (
                  Clk => Clk,
                BdClk => BdClk,
                HalftimeBdClk => HalftimeBdClk,
         NbToTransmit =>NbToTransmit,
                 Data => Data,
             Transmit => goTransmit,
                  SCL => SCL,
                  SDA => SDA,
        NbTransmitted => NbTransmitted,
              BdClkEn => BdClkEn,
     LoadNextOctetToTransmit => LoadNextOctetToTransmit,
     DoneTransmitting => DoneTransmitting );
     

     Clk_process : process
     begin
       Clk <= '0';
       wait for Clk_period / 2;
       Clk <= '1';
       if BdClkEn = '1' then
                   if counter >= MAINFREQ/(BAUDRATE * 2) and counter < MAINFREQ/(BAUDRATE * 2) + 1 then
                        HalftimeBdClk <= '1';
                   else HalftimeBdClk <= '0';
                   end if;
                   if counter >= MAINFREQ/BAUDRATE then counter <= 0;
                                                        BdClk <= '1';
                   else counter <= counter + 1;
                        BdClk <= '0';
                   end if;
               else counter <= 0;
                    BdClk <= '0';
               end if;
       wait for Clk_period / 2;
     end process;

NbToTransmit <= 2;
stimul : process
begin
    Data <= "11000011";
    goTransmit <= '0';
    sda <= 'Z';
    wait for Clk_period * 30;
    goTransmit <= '1';
    wait for 20 ns;
    goTransmit <= '0';
    wait for 3 us;
    Data <= "00111100";
    wait for 78 us;
    sda <= '0';   
    wait for 10 us;
    sda <= 'Z';  
    wait for 80 us;
    sda <= '0';
    wait for 10 us;
    sda <= 'Z';
    wait for 1 ms;
end process;

end Behavioral;
