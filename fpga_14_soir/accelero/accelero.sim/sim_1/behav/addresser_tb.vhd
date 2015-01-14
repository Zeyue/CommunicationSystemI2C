----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.01.2015 16:49:35
-- Design Name: 
-- Module Name: addresser_tb - Behavioral
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

entity addresser_tb is
end addresser_tb;

architecture Behavioral of addresser_tb is
component Address 
    Port ( Clk : in STD_LOGIC;
         BdClk : in STD_LOGIC;
         HalftimeBdClk : in STD_LOGIC;
  SlaveAddress : in STD_LOGIC_VECTOR (7 downto 0);
           SCL : out STD_LOGIC;
           SDA : inout STD_LOGIC;
       BdClkEn : out STD_LOGIC ;
   SendAddress : in STD_LOGIC ;
   AddressSent : out STD_LOGIC);
end component;

signal           Clk : STD_LOGIC;
signal         BdClk : STD_LOGIC;
signal HalftimeBdClk :  STD_LOGIC;
signal  SlaveAddress :  STD_LOGIC_VECTOR (7 downto 0);
signal           SCL :  STD_LOGIC;
signal           SDA :  STD_LOGIC;
signal       BdClkEn :  STD_LOGIC ;
signal   SendAddress :  STD_LOGIC ;
signal   AddressSent :  STD_LOGIC;
constant Clk_period : time := 10 ns;
constant BdClk_period : time := 5 us;
constant baudrate : integer := 200000;
constant mainfreq : integer := 100000000;
signal counter : integer;
begin
--counter <= 0;
uut : address PORT MAP (
 Clk => Clk,
         BdClk => BdClk,
         HalftimeBdClk => HalftimeBdClk,
  SlaveAddress => SlaveAddress,
           SCL => SCL,
           SDA => SDA,
       BdClkEn => BdClkEn,
   SendAddress => SendAddress,
   AddressSent => AddressSent);

--Clk_process : process
--begin
 -- Clk <= '0';
 -- wait for Clk_period / 2;
 -- Clk <= '1';
 -- if BdClkEn = '1' then
--              if counter >= MAINFREQ/BAUDRATE then counter <= 0;
--                                                   BdClk <= '1';
--              else counter <= counter + 1;
--                   BdClk <= '0';
--              end if;
--          else counter <= 0;
 --              BdClk <= '0';
  --        end if;
 -- wait for Clk_period / 2;
--end process;
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

SlaveAddress <= "11001100";


stimu : process
begin
SDA <= 'Z';
SendAddress <= '0';
wait for Clk_period * 30;
SendAddress <= '1';
wait for 20 ns;
SendAddress <= '0';
wait for 86 us;
SDA <= '0';
wait for 9 us;
SDA <= 'Z';
wait for 1 ms;
end process;


end Behavioral;
