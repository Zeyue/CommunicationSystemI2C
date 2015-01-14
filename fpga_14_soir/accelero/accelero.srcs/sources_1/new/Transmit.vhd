----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.12.2014 15:30:26
-- Design Name: 
-- Module Name: Transmit - Behavioral
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

entity Transmit is
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
     -- OctetTransmitted : out STD_LOGIC;
      LoadNextOctetToTransmit : out STD_LOGIC;
      DoneTransmitting : out STD_LOGIC;
      RW : out STD_LOGIC );
end Transmit;

architecture Behavioral of Transmit is
TYPE STATE_TYPE IS (BusFree, T7D, T7U, T6D, T6U, T5D, T5U, T4D, T4U, T3D, T3U,
T2D, T2U, T1D, T1U, T0D, T0U, LisToAckD, LisToAckU, AckReceived, NackReceived, StopD, StopU);
signal state : STATE_TYPE;
signal NbTrans : integer := 0;
signal InternalData : STD_LOGIC_VECTOR (7 downto 0);
signal Ack : STD_LOGIC;

begin
-- state machine
FSM1Transition : process (Clk)
begin
    If Clk' event and Clk = '1' then
        CASE state IS
            WHEN BusFree =>
                if Transmit = '1' then
                    state <= T7D;
                else 
                    state <= BusFree;
                end if;
            WHEN T7D =>
                if BdClk = '1' then
                    state <= T7U;
                else
                    state <= T7D;
                end if;
            WHEN T7U =>
                if BdClk = '1' then
                    state <= T6D;
                else
                    state <= T7U;
                end if;
            WHEN T6D =>
                if BdClk = '1' then
                    state <= T6U;
                else
                    state <= T6D;
                end if;
            WHEN T6U =>
                if BdClk = '1' then
                    state <= T5D;
                else
                     state <= T6U;
                end if;
            WHEN T5D =>
                if BdClk = '1' then
                    state <= T5U;
                else
                    state <= T5D;
                end if;
            WHEN T5U =>
                if BdClk = '1' then
                    state <= T4D;
                else
                    state <= T5U;
                end if;
            WHEN T4D =>
                if BdClk = '1' then
                    state <= T4U;
                else
                    state <= T4D ;
                end if;
            WHEN T4U =>
                if BdClk = '1' then
                    state <= T3D;
                else
                    state <= T4U ;
                end if;
            WHEN T3D =>
                if BdClk = '1' then
                    state <= T3U;
                else
                    state <= T3D;
                end if;
            WHEN T3U =>
                if BdClk = '1' then
                    state <= T2D;
                else
                    state <= T3U;
                end if;
            WHEN T2D =>
                if BdClk = '1' then
                    state <= T2U;
                else
                    state <= T2D;
                end if;
            WHEN T2U =>
                if BdClk = '1' then
                    state <= T1D;
                else
                    state <= T2U;
                end if;
            WHEN T1D =>
                if BdClk = '1' then
                    state <= T1U;
                else
                    state <= T1D;
                end if;
            WHEN T1U =>
                if BdClk = '1' then
                    state <= T0D;
                else
                    state <= T1U;
                end if;
            WHEN T0D =>
                if BdClk = '1' then
                    state <= T0U;
                else
                    state <= T0D;
                end if;
            WHEN T0U=>
                if BdClk = '1' then
                    state <= LisToAckD;
                else
                    state <= T0U ;
                end if;
            WHEN LisToAckD =>
                if BdClk = '1' then
                    state <= LisToAckU;
                else 
                    state <= LisToAckD;
                end if;
            WHEN LisToAckU =>               
                if BdClk = '1' then
                    if Ack = '1' then
                        state <= AckReceived;
                    else state <= NackReceived;
                    end if;
                else state <= LisToAckU;
                end if;
            WHEN AckReceived =>              
                if Nbtrans < NbToTransmit -1 then
                    state <= T7D;
                else
                    state <= StopD;
                end if;       
            WHEN NackReceived =>
                state <= StopD;                   
            WHEN StopD =>
                if BdClk = '1' then
                    state <= StopU;
                else
                    state <= StopD ;
                end if;
            WHEN StopU =>
                if BdClk = '1' then
                    state <= BusFree;
                else 
                    state <= StopU;
                end if;
                if Transmit = '0' then state <= BusFree;
                end if;
        END CASE;
    end if;
end process;

-- Interpretation
FSM1Value : process(Clk)
begin
    If Clk' event and Clk = '1' then
        CASE state IS
            WHEN BusFree =>  
                InternalData <= Data;
                LoadNextOctetToTransmit <= '0';
                SCL <= '1';
                SDA <= 'Z';
                NbTransmitted <= 0;
                NbTrans <= 0;
                BdClkEn <= '0';
                DoneTransmitting <= '0';
                Ack <= '0';
                RW <= '0';
            WHEN  T7D=> 
                DoneTransmitting <= '0';
                SCL <= '0';
                SDA <= InternalData(7);
                BdClkEn <= '1';
                --OctetTransmitted <= '0';
                if HalftimeBdClk = '1' and NbTrans < NbToTransmit - 1 then                  
                      LoadNextOctetToTransmit <= '1';
                else
                    LoadNextOctetToTransmit <= '0';
                end if;
            WHEN T7U => 
                SCL <= '1';
                SDA <= InternalData(7);
                BdClkEn <= '1';
                LoadNextOctetToTransmit <= '0';
            WHEN T6D => 
                SCL <= '0';
                SDA <= InternalData(6);
                BdClkEn <= '1';
            WHEN T6U => 
                SCL <= '1';
                SDA <= InternalData(6);
                BdClkEn <= '1';
            WHEN T5D => 
                SCL <= '0';
                SDA <= InternalData(5);
                BdClkEn <= '1';
            WHEN T5U => 
                SCL <= '1';
                SDA <= InternalData(5);
                BdClkEn <= '1';
            WHEN T4D => 
                SCL <= '0';
                SDA <= InternalData(4);
                BdClkEn <= '1';
            WHEN T4U => 
                SCL <= '1';
                SDA <= InternalData(4);
                BdClkEn <= '1';
            WHEN T3D => 
                SCL <= '0';
                SDA <= InternalData(3);
                BdClkEn <= '1';
            WHEN T3U => 
                SCL <= '1';
                SDA <= InternalData(3);
                BdClkEn <= '1';
            WHEN T2D => 
                SCL <= '0';
                SDA <= InternalData(2);
                BdClkEn <= '1';
            WHEN T2U => 
                SCL <= '1';
                SDA <= InternalData(2);
                BdClkEn <= '1';
            WHEN T1D => 
                SCL <= '0';
                SDA <= InternalData(1);
                BdClkEn <= '1';
            WHEN T1U => 
                SCL <= '1';
                SDA <= InternalData(1);
                BdClkEn <= '1';
            WHEN T0D => 
                SCL <= '0';
                SDA <= InternalData(0);
                BdClkEn <= '1';
            WHEN T0U => 
                SCL <= '1';
                SDA <= InternalData(0);
                BdClkEn <= '1';
            WHEN LisToAckD => 
                SCL <= '0';
                SDA <='Z'; 
                BdClkEn <= '1';
                InternalData <= Data;
                RW <= '1';
            WHEN LisToAckU =>
                SCL <= '1';
                SDA <= 'Z';
                BdClkEn <= '1';
                if HalftimeBdClk = '1' and SDA = '0' then
                    Ack <= '1';               
                end if;
                RW <= '1';
            WHEN AckReceived =>
                SCL <= '1';
                SDA <= 'Z';
                NbTransmitted <= Nbtrans + 1;
                Nbtrans <= Nbtrans + 1;               
                --OctetTransmitted <= '1';
                BdClkEn <= '1';
                Ack <= '0';
                RW <= '0';
            WHEN NackReceived =>
                SCL <= '1';
                SDA <= 'Z';
                --OctetTransmitted <= '0';
                BdClkEn <= '1';
                RW <= '0';
            WHEN StopD =>
                SCL <= '0';
                SDA <= '0';
                BdClkEn <= '1';
                if HalftimeBdClk = '1' then
                LoadNextOctetToTransmit <= '1';  --------for module_RW because done transmitting not used
                else LoadNextOctetToTransmit <= '0';
                end if;
               -- OctetTransmitted <= '0';
            WHEN StopU =>        -- SDA being set from stop to BusFree is the stop condition
                SCL <= '1';
                SDA <= '0';
                BdClkEn <= '1';
                if HalftimeBdClk = '1' then
                  DoneTransmitting <= '1';
                end if;               
        END CASE;
    end if;
end process;

end Behavioral;
