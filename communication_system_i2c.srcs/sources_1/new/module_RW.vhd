----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2014/12/19 14:37:47
-- Design Name: 
-- Module Name: module_RW - Behavioral
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

entity module_RW is
  Port ( 
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
end module_RW;

architecture Behavioral of module_RW is
constant SLAVE_ADDR : STD_LOGIC_VECTOR (6 downto 0) := "1010011"; --0x53
constant W : STD_LOGIC := '0';
constant R : STD_LOGIC := '1';

TYPE MODE is (PW_CTL, DATA_FORMAT_CTL, DATA);
TYPE PW_MODE is (PW_REG_ADDR, MESURE);
TYPE DATA_CTL_MODE is (DATA_CTL_REG_ADDR, VAL);
TYPE DATA_MODE is (DATA_REG_ADDR, DATA_REC);
TYPE XYZ_MODE is (X0, X1, Y0, Y1, Z0, Z1);

signal currentMode : MODE;
signal pw : PW_MODE;
signal data_ctl : DATA_CTL_MODE;
signal dataMode: DATA_MODE;
signal xyz: XYZ_MODE;

signal internalX0 : STD_LOGIC_VECTOR (7 downto 0):= "00000000";
signal internalX1 : STD_LOGIC_VECTOR (7 downto 0):= "00000000";
signal internalY0 : STD_LOGIC_VECTOR (7 downto 0):= "00000000";
signal internalY1 : STD_LOGIC_VECTOR (7 downto 0):= "00000000";
signal internalZ0 : STD_LOGIC_VECTOR (7 downto 0):= "00000000";
signal internalZ1 : STD_LOGIC_VECTOR (7 downto 0):= "00000000";

signal internalR : STD_LOGIC:= '0';
signal internalW : STD_LOGIC:= '1';

begin
ADDR <= SLAVE_ADDR;
NUM_IN <= 1;
NUM_OUT <= 2;
WRITE <= internalW;
READ <= internalR;

Transmit : process (CLK,LOAD_NEXT, OCTET_READY) is 
begin
if CLK'EVENT and CLK = '1' then
  case currentMode is
  
   when PW_CTL =>
    case pw is
     when PW_REG_ADDR =>
      DATA_OUT <= "00101101"; -- power control register address 0x2D
      if LOAD_NEXT = '1' then
       pw <= MESURE;
      end if;
     when MESURE =>
      DATA_OUT <= "00111010"; -- mesure mode 0x3A
      currentMode <= DATA_FORMAT_CTL;
      data_ctl <= DATA_CTL_REG_ADDR;
     end case;
     
   when DATA_FORMAT_CTL =>
    case data_ctl is
     when DATA_CTL_REG_ADDR =>
      DATA_OUT <= "00110001"; -- data format control register address 0x31
      if LOAD_NEXT = '1' then
       data_ctl <= VAL;
      end if;
     when VAL =>
      DATA_OUT <= "00000001";
      currentMode <= DATA;
      dataMode <= DATA_REG_ADDR;
      xyz <= X0;
     end case;
     
   when DATA =>
      case xyz is
       when X0 =>
        case dataMode is
         when DATA_REG_ADDR =>
          internalW <= '1';
          internalR <= '0';
          DATA_OUT <= "00110010"; -- 0x32
          if LOAD_NEXT = '1' then
           dataMode <= DATA_REC;
          end if;
         when DATA_REC =>
          internalW <= '0';
          internalR <= '1';
          if OCTET_READY = '1' then
           internalX0 <= DATA_IN;
           xyz <= X1;
           dataMode <= DATA_REG_ADDR;
          end if;
         end case;
       when X1 =>
       case dataMode is
        when DATA_REG_ADDR =>
         internalW <= '1';
         internalR <= '0';
         DATA_OUT <= "00110011"; -- 0x33
         if LOAD_NEXT = '1' then
          dataMode <= DATA_REC;
         end if;
        when DATA_REC =>
         internalW <= '0';
         internalR <= '1';
         if OCTET_READY = '1' then
          internalX1 <= DATA_IN;
          X_COMPUTED <= internalX1 & internalX0;
          xyz <= Y0;
          dataMode <= DATA_REG_ADDR;
         end if;
        end case;
       when Y0 =>
       case dataMode is
        when DATA_REG_ADDR =>
         internalW <= '1';
         internalR <= '0';
         DATA_OUT <= "00110100"; -- 0x34
         if LOAD_NEXT = '1' then
          dataMode <= DATA_REC;
         end if;
        when DATA_REC =>
         internalW <= '0';
         internalR <= '1';
         if OCTET_READY = '1' then
          internalY0 <= DATA_IN;
          xyz <= Y1;
          dataMode <= DATA_REG_ADDR;
         end if;
        end case;
       when Y1 =>
       case dataMode is
        when DATA_REG_ADDR =>
         internalW <= '1';
         internalR <= '0';
         DATA_OUT <= "00110101"; -- 0x35
         if LOAD_NEXT = '1' then
          dataMode <= DATA_REC;
         end if;
        when DATA_REC =>
         internalW <= '0';
         internalR <= '1';
         if OCTET_READY = '1' then
          internalY1 <= DATA_IN;
          Y_COMPUTED <= internalY1 & internalY0;
          xyz <= Z0;
          dataMode <= DATA_REG_ADDR;
         end if;
        end case;
       when Z0 =>
       case dataMode is
        when DATA_REG_ADDR =>
         internalW <= '1';
         internalR <= '0';
         DATA_OUT <= "00110110"; -- 0x36
         if LOAD_NEXT = '1' then
          dataMode <= DATA_REC;
         end if;
        when DATA_REC =>
         internalW <= '0';
         internalR <= '1';
         if OCTET_READY = '1' then
          internalZ0 <= DATA_IN;
          xyz <= Z1;
          dataMode <= DATA_REG_ADDR;
         end if;
        end case;
       when Z1 =>
       case dataMode is
        when DATA_REG_ADDR =>
         internalW <= '1';
         internalR <= '0';
         DATA_OUT <= "00110111"; -- 0x37
         if LOAD_NEXT = '1' then
          dataMode <= DATA_REC;
         end if;
        when DATA_REC =>
         internalW <= '0';
         internalR <= '1';
         if OCTET_READY = '1' then
          internalZ1 <= DATA_IN;
          Z_COMPUTED <= internalZ1 & internalZ0;
          xyz <= X0;
          dataMode <= DATA_REG_ADDR;
         end if;
        end case;
       end case;
      end case;
end if;
end process;
end Behavioral;
