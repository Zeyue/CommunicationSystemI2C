----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2014 18:31:54
-- Design Name: 
-- Module Name: slowCLK - Behavioral
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

entity slowCLK is
    Port ( CLK : in STD_LOGIC;
        SPEED : in INTEGER;
        CLKOUT : out STD_LOGIC);

end slowCLK;

architecture Behavioral of slowCLK is

CONSTANT mainFreq : integer := 100000000;
signal counter : integer;

begin
process (CLK)
begin
if CLK' event and CLK = '1' then
if counter >= mainFreq/SPEED then counter <= 0;
                                CLKOUT <= '1';
else counter <= counter + 1;
    CLKOUT <= '0';
end if;
end if;
end process;



end Behavioral;
