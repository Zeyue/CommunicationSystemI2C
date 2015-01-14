----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.01.2015 15:26:39
-- Design Name: 
-- Module Name: receiver_tb - Behavioral
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

entity receiver_tb is
end receiver_tb;

architecture Behavioral of receiver_tb is
component Receive
Port (       Clk : in STD_LOGIC;
               BdClk : in STD_LOGIC;
        HalftimeBdClk : in STD_LOGIC;
         NbToReceive : in INTEGER;
                Data : out STD_LOGIC_VECTOR (7 downto 0);
             Receive : in STD_LOGIC;
                 SCL : out STD_LOGIC;
                 SDA : inout STD_LOGIC;
          NbReceived : out INTEGER;
             BdClkEn : out STD_LOGIC ;
       OctetReceived : out STD_LOGIC;
       DoneReceiving : out STD_LOGIC );
end component;

signal Clk :  STD_LOGIC;
signal BdClk :  STD_LOGIC;
 signal HalftimeBdClk :  STD_LOGIC;
signal NbToReceive :  INTEGER;
signal  Data :  STD_LOGIC_VECTOR (7 downto 0);
signal  goReceive :  STD_LOGIC;
signal  SCL :  STD_LOGIC;
signal  SDA :  STD_LOGIC;
signal   NbReceived :  INTEGER;
signal   BdClkEn :  STD_LOGIC ;
signal  OctetReceived :  STD_LOGIC;
signal  DoneReceiving :  STD_LOGIC;
constant Clk_period : time := 10 ns;
constant BdClk_period : time := 5 us;
constant baudrate : integer := 200000;
constant mainfreq : integer := 100000000;
signal counter : integer;

begin
uut : Receive port map (
                Clk => Clk,
               BdClk => BdClk,
        HalftimeBdClk => HalftimeBdClk,
         NbToReceive => NbToReceive,
                Data => Data,
             Receive => goReceive,
                 SCL => SCL,
                 SDA => SDA,
          NbReceived => NbReceived,
             BdClkEn => BdClkEn,
       OctetReceived => OctetReceived,
       DoneReceiving => DoneReceiving );
       
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
           
           
NbToReceive <= 2;
stimul : process
begin
SDA <= '1';
goReceive <= '1';
wait for 30 ns;
goReceive <= '0';
wait for 80 us;
SDA <= 'Z';
wait for 11 us;
SDA <= '0';
wait for 79 us;
SDA <= 'Z';
wait for 1 ms;

end process;

end Behavioral;
