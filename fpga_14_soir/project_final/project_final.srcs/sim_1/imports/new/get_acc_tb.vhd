----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.01.2015 09:44:18
-- Design Name: 
-- Module Name: get_acc_tb - Behavioral
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

entity get_acc_tb is
end get_acc_tb;

architecture Behavioral of get_acc_tb is
component get_acc
    Port ( 
    Clk : in STD_LOGIC;
    SDA : inout STD_LOGIC;
    SCL : out STD_LOGIC;
    x_computed : out STD_LOGIC_VECTOR (15 downto 0);
    y_computed : out STD_LOGIC_VECTOR (15 downto 0);
    z_computed : out STD_LOGIC_VECTOR (15 downto 0));
end component;
signal Clk :  STD_LOGIC;
signal SDA :  STD_LOGIC;
signal SCL :  STD_LOGIC;
signal x_computed :  STD_LOGIC_VECTOR (15 downto 0);
signal y_computed :  STD_LOGIC_VECTOR (15 downto 0);
signal z_computed :  STD_LOGIC_VECTOR (15 downto 0);
constant Clk_period : time := 10 ns;

begin
uut : get_acc port map (
Clk => Clk,
    SDA  => SDA,
    SCL  => SCL,
    x_computed  => x_computed,
    y_computed  => y_computed,
    z_computed  => z_computed);

Clk_process : process
begin
  Clk <= '0';
  wait for Clk_period / 2;
  Clk <= '1';
  wait for Clk_period / 2;
end process;

stimulation : process
begin
sda <= 'Z';
wait for 91 us;
sda <= '0';
wait for 8 us;
sda <= 'Z';
wait for 82 us;
sda <= '0';
wait for 7 us;
sda <= 'Z';
wait for 83 us;
sda <= '0';
wait for 8 us;
sda <= 'Z';
wait for 1 ms;
end process;
end Behavioral;
