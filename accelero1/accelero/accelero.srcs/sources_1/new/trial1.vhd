----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.01.2015 11:30:18
-- Design Name: 
-- Module Name: trial1 - Behavioral
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

entity trial1 is
    Port (
    Clk : in STD_LOGIC;
    Sda : inout STD_LOGIC;
    Scl : out STD_LOGIC;
    x : out STD_LOGIC_VECTOR (7 downto 0) );
end trial1;

architecture Behavioral of trial1 is

component get_acc
 Port ( 
   Clk : in STD_LOGIC;
   SDA : inout STD_LOGIC;
   SCL : out STD_LOGIC;
   x_computed : out STD_LOGIC_VECTOR (15 downto 0);
   y_computed : out STD_LOGIC_VECTOR (15 downto 0);
   z_computed : out STD_LOGIC_VECTOR (15 downto 0));
end component;
 signal x_computed :  STD_LOGIC_VECTOR (15 downto 0);
 signal y_computed :  STD_LOGIC_VECTOR (15 downto 0);
 signal z_computed :  STD_LOGIC_VECTOR (15 downto 0);



begin
measure : get_acc port map (
Clk => Clk,
sda => sda,
scl => scl,
x_computed => x_computed,
y_computed => y_computed,
z_computed => z_computed);

mes_process : process (Clk)
begin
if Clk'event and Clk = '1' then
x <= x_computed (15 downto 8);
end if;
end process;

end Behavioral;
