----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2015/01/06 14:07:35
-- Design Name: 
-- Module Name: tb_module_RW - Behavioral
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

entity tb_module_RW is
end tb_module_RW;

architecture Behavioral of tb_module_RW is

component module_RW is 
 port (
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

signal DATA_IN : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
signal LOAD_NEXT : STD_LOGIC := '0';
signal OCTET_READY : STD_LOGIC := '0';
signal CLK : STD_LOGIC := '0';
signal ADDR :STD_LOGIC_VECTOR (6 downto 0) := "0000000";
signal NUM_IN : INTEGER := 0;
signal NUM_OUT : INTEGER := 0;
signal DATA_OUT : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
signal WRITE : STD_LOGIC := '0';
signal READ : STD_LOGIC := '0';
signal X_COMPUTED : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";
signal Y_COMPUTED : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";
signal Z_COMPUTED : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";

begin

uut : module_RW port map(
    DATA_IN => DATA_IN,
    LOAD_NEXT => LOAD_NEXT,
    OCTET_READY => OCTET_READY,
    CLK => CLK,
    ADDR => ADDR,
    NUM_IN => NUM_IN,
    NUM_OUT => NUM_OUT,
    DATA_OUT => DATA_OUT,
    WRITE => WRITE,
    READ => READ,
    X_COMPUTED => X_COMPUTED,
    Y_COMPUTED => Y_COMPUTED,
    Z_COMPUTED => Z_COMPUTED
);
DATA_SIM : process
begin
 DATA_IN <= "00001111";
 wait for 10ns;
 DATA_IN <= "10101010";
 wait for 10ns;
 DATA_IN <= "11001100";
 wait for 10ns;
 DATA_IN <= "11111100";
 wait for 10ns; 
 DATA_IN <= "10000100";
 wait for 10ns;
 DATA_IN <= "00001100";
 wait for 10ns;
end process;

CLK_SIM : process
begin
 CLK <= '1';
 wait for 10ns;
 CLK <= '0';
 wait for 10ns;
 end process;

sim : process
begin
 LOAD_NEXT <= '1';
 OCTET_READY <= '0';
 wait for 100ns;
 LOAD_NEXT <= '0';
 OCTET_READY <= '1';
 wait for 100ns;
end process;
end Behavioral;
