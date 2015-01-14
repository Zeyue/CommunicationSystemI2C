----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.01.2015 14:00:28
-- Design Name: 
-- Module Name: trial1_tb - Behavioral
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

entity trial1_tb is
end trial1_tb;

architecture Behavioral of trial1_tb is

component trial1
port (
Clk : in STD_LOGIC;
    Sda : inout STD_LOGIC;
    Scl : out STD_LOGIC;
    x : out STD_LOGIC_VECTOR (7 downto 0) );
end component;

signal clk : STD_LOGIC;
signal sda : STD_LOGIC;
signal scl : STD_LOGIC;
signal x : STD_LOGIC_VECTOR (7 downto 0);
constant Clk_period : time := 10 ns;

begin
uut : trial1 port map (
clk => clk,
sda => sda,
scl => scl,
x => x);


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
wait for 9 us;
sda <= 'Z';
wait for 83 us;
sda <= '0';
wait for 7 us;
sda <= 'Z';
wait for 102 us;
sda <= '0';
wait for 6 us;
sda <= 'Z';
wait for 83 us;
sda <= '0';
wait for 7 us;
sda <= 'Z';
wait for 83 us;
sda <= '0';
wait for 7 us;
sda <= 'Z';
wait for 100 us;
sda <= '0';
wait for 7 us;
sda <= 'Z';
wait for 84 us;
sda <= '0';
wait for 7 us;
sda <= 'Z';
wait for 100 us;
sda <= '0';
wait for 7 us;
sda <= 'Z';
--wait for 83 us;
--sda <= '0';
--wait for 7 us;
--sda <= 'Z';
--wait for 100 us;
--sda <= '0';
--wait for 7 us;
--sda <= 'Z';
wait for 2ms;
end process;
end Behavioral;
