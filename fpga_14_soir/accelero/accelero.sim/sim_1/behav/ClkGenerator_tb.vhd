----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.01.2015 17:24:11
-- Design Name: 
-- Module Name: ClkGenerator_tb - Behavioral
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

entity ClkGenerator_tb is
end ClkGenerator_tb;

architecture Behavioral of ClkGenerator_tb is
component ClockGenerator is
Port (   MAINCLK : in STD_LOGIC;
             TRIGGER : in STD_LOGIC;
            BAUDRATE : in INTEGER;
              CLKOUT : out STD_LOGIC ;
      HALFTIMECLKOUT : out STD_LOGIC);
end component;

signal MAINCLK : STD_LOGIC;
signal  TRIGGER : STD_LOGIC;
signal      BAUDRATE :  INTEGER;
signal    CLKOUT :  STD_LOGIC ;
signal   HALFTIMECLKOUT :  STD_LOGIC;
constant Clk_period : time := 10 ns;
begin
uut : ClockGenerator PORT MAP (
MAINCLK => MAINCLK,
             TRIGGER => TRIGGER,
            BAUDRATE => BAUDRATE,
              CLKOUT => CLKOUT,
      HALFTIMECLKOUT => HALFTIMECLKOUT);

Clk_Process : process
begin

MAINCLK <= '0';
wait for Clk_period/2;
MAINCLK <= '1';
wait for Clk_period/2;
MAINCLK <= '0';
end process;

stimul : process
begin
TRIGGER <= '1';
wait for 100 us;
TRIGGER <= '1';
wait for 10000 us;
end process;

end Behavioral;
