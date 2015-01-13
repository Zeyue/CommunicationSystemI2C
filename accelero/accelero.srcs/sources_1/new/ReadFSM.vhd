----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2014 12:06:02
-- Design Name: 
-- Module Name: ReadFSM - Behavioral
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

entity ReadFSM is
    Port (        Clk : in STD_LOGIC;
                BdClk : in STD_LOGIC;
               ToRead : in INTEGER;
         SlaveAddress : in STD_LOGIC_VECTOR (7 downto 0);
                 Data : out STD_LOGIC_VECTOR (7 downto 0);
                 Read : in STD_LOGIC;
                  SCL : out STD_LOGIC;
                  SDA : inout STD_LOGIC;
           OctetsRead : out INTEGER;
              BdClkEn : out STD_LOGIC ;
          DoneReading : out STD_LOGIC);
end ReadFSM;

architecture Behavioral of ReadFSM is
TYPE STATE_TYPE IS (BusFree, Start, 
A7D, A7U, A6D, A6U, A5D, A5U, A4D, A4U, A3D, A3U, A2D, A2U, A1D, A1U, A0D, A0U, -- A0 : r/w -> r = 1
LisToAck, AckReceived,
D7D, D7U, D6D, D6U, D5D, D5U, D4D, D4U, D3D, D3U, D2D, D2U, D1D, D1U, D0D, D0U,
SendAckD, SendAckU, AckSent, SendNackD, SendNackU, NackSent, StopD, StopU);
signal state : STATE_TYPE;
signal OctRd : integer := 0;

begin
FSMTransition : process (Clk)
begin
    if Clk' event and Clk = '1' then
        CASE state IS
            WHEN BusFree =>
                if Read = '1' and OctRd < ToRead then
                    state <= Start;
                else
                    state <= BusFree;
                end if;
            WHEN Start =>
                if BdClk = '1' then
                    state <= A7D;
                else 
                    state <= Start;
                end if;
            WHEN A7D =>
                if BdClk = '1' then
                    state <= A7U;
                else 
                    state <= A7D;
                end if;
            WHEN A7U =>
                if BdClk = '1' then
                    state <= A6D;
                else 
                    state <= A7U;
                end if;
            WHEN A6D =>
                if BdClk = '1' then
                    state <= A6U;
                else 
                    state <= A6D;
                end if;
            WHEN A6U =>
                if BdClk = '1' then
                    state <= A5D;
                else 
                    state <= A6U;
                end if;
            WHEN A5D =>
                if BdClk = '1' then
                    state <= A5U;
                else 
                    state <= A5D;
                end if;
            WHEN A5U =>
                if BdClk = '1' then
                    state <= A4D;
                else 
                    state <= A5U;
                end if;
            WHEN A4D =>
                if BdClk = '1' then
                    state <= A4U;
                else 
                    state <= A4D;
                end if;
            WHEN A4U =>
                if BdClk = '1' then
                    state <= A3D;
                else 
                    state <= A4U;
                end if;
            WHEN A3D =>
                if BdClk = '1' then
                    state <= A3U;
                else 
                    state <= A3D;
                end if;
            WHEN A3U =>
                if BdClk = '1' then
                    state <= A2D;
                else 
                    state <= A3U;
                end if;
            WHEN A2D =>
                if BdClk = '1' then
                    state <= A2U;
                else 
                    state <= A2D;
                end if;
            WHEN A2U =>
                if BdClk = '1' then
                    state <= A1D;
                else 
                    state <= A2U;
                end if;
            WHEN A1D =>
                if BdClk = '1' then
                    state <= A1U;
                else
                    state <= A1D;
                end if;
            WHEN A1U =>
                if BdClk = '1' then
                    state <= A0D;
                else 
                    state <= A1U;
                end if;
            WHEN A0D =>
                if BdClk = '1' then
                    state <= A0U;
                else 
                    state <= A0D;
                end if;
            WHEN A0U =>
                if BdClk = '1' then
                    state <= LisToAck;
                else 
                    state <= A0U;
                end if;
            WHEN LisToAck =>
                if BdClk = '1' then
                    if SDA = '1' then
                        state <= AckReceived;
                        else state <= LisToAck;
                    end if;
                end if;
            WHEN AckReceived =>
                state <= D7D;
            WHEN D7D =>
                 if BdClk = '1' then
                     state <= D7U;
                 else 
                     state <= D7D;
                 end if;
             WHEN D7U =>
                 if BdClk = '1' then
                     state <= D6D;
                 else 
                     state <= D7U;
                 end if;
             WHEN D6D =>
                 if BdClk = '1' then
                     state <= D6U;
                 else 
                     state <= D6D;
                 end if;
             WHEN D6U =>
                 if BdClk = '1' then
                     state <= D5D;
                 else 
                     state <= D6U;
                 end if;
             WHEN D5D =>
                 if BdClk = '1' then
                     state <= D5U;
                 else 
                     state <= D5D;
                 end if;
             WHEN D5U =>
                 if BdClk = '1' then
                     state <= D4D;
                 else 
                     state <= D5U;
                 end if;
             WHEN D4D =>
                 if BdClk = '1' then
                     state <= D4U;
                 else 
                     state <= D4D;
                 end if;
             WHEN D4U =>
                 if BdClk = '1' then
                     state <= D3D;
                 else 
                     state <= D4U;
                 end if;
             WHEN D3D =>
                 if BdClk = '1' then
                     state <= D3U;
                 else 
                     state <= D3D;
                 end if;
             WHEN D3U =>
                 if BdClk = '1' then
                     state <= D2D;
                 else 
                     state <= D3U;
                 end if;
             WHEN D2D =>
                 if BdClk = '1' then
                     state <= D2U;
                 else 
                     state <= D2D;
                 end if;
             WHEN D2U =>
                 if BdClk = '1' then
                     state <= D1D;
                 else 
                     state <= D2U;
                 end if;
             WHEN D1D =>
                if BdClk = '1' then
                    state <= D1U;
                else 
                    state <= D1D;
                end if;
             WHEN D1U =>
                 if BdClk = '1' then
                     state <= D0D;
                 else 
                     state <= D1U;
                 end if;
             WHEN D0D =>
                 if BdClk = '1' then
                     state <= D0U;
                 else 
                     state <= D0D;
                 end if;
             WHEN D0U =>
                 if BdClk = '1' then
                     if OctRd < ToRead - 1 then
                        state <= SendAckD;
                     else
                        state <= SendNackD;
                     end if;
                 else 
                     state <= D0U;
                 end if;
             WHEN SendAckD =>
                if BdClk = '1' then
                    state <= SendAckU;
                else 
                    state <= SendAckD;
                end if;
             WHEN SendAckU =>
                if BdClk = '1' then
                    state <= AckSent;
                else
                    state <= SendAckU;
                end if;
             WHEN AckSent =>
                state <= D7D;
             WHEN SendNackD =>
                if BdClk = '1' then
                    state <= SendNackU;
                else
                    state <= SendNackD;
                end if;
             WHEN SendNackU =>
                if BdClk = '1' then
                    state <= NackSent;
                else
                    state <= SendNackU;
                end if;
             WHEN NackSent =>
                state <= StopD;
            WHEN StopD =>
                if BdClk = '1' then
                    state <= StopU;
                else
                    state <= StopD;
                end if;   
            WHEN StopU =>
                if BdClk = '1' then
                    state <= BusFree;
                else
                    state <= StopU;
                end if;           
        END CASE;
    end if;
end process;

-- interpretation

FSMValue : process (Clk)
begin
    if Clk' event and Clk = '1' then
        CASE state IS
         WHEN BusFree =>
             SCL <= '1';
             SDA <= '1';
             OctetsRead <= OctRd;
             BdClkEn <= '0';
             Data <= "00000000";
         WHEN Start =>
             SCL <= '1';
             SDA <= '0';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
             Data <= "00000000"; 
             DoneReading <= '0';            
         WHEN A7D =>
            SCL <= '0';
            SDA <= SlaveAddress(7);
            OctetsRead <= OctRd;
            BdClkEn <= '1';
            Data <= "00000000";            
         WHEN A7U =>
            SCL <= '1';
            SDA <= SlaveAddress(7);
            OctetsRead <= OctRd;
            BdClkEn <= '1';
            Data <= "00000000";    
         WHEN A6D =>
            SCL <= '0';
            SDA <= SlaveAddress(6);
            OctetsRead <= OctRd;
            BdClkEn <= '1';
            Data <= "00000000";   
         WHEN A6U =>
            SCL <= '1';
            SDA <= SlaveAddress(6);
            OctetsRead <= OctRd;
            BdClkEn <= '1';
            Data <= "00000000"; 
         WHEN A5D =>
            SCL <= '0';
            SDA <= SlaveAddress(5);
            OctetsRead <= OctRd;
            BdClkEn <= '1';
            Data <= "00000000"; 
         WHEN A5U =>
            SCL <= '1';
            SDA <= SlaveAddress(5);
            OctetsRead <= OctRd;
            BdClkEn <= '1';
            Data <= "00000000";  
         WHEN A4D =>
            SCL <= '0';
            SDA <= SlaveAddress(4);
            OctetsRead <= OctRd;
            BdClkEn <= '1';
            Data <= "00000000"; 
         WHEN A4U =>
            SCL <= '1';
            SDA <= SlaveAddress(4);
            OctetsRead <= OctRd;
            BdClkEn <= '1';
            Data <= "00000000"; 
         WHEN A3D =>
            SCL <= '0';
            SDA <= SlaveAddress(3);
            OctetsRead <= OctRd;
            BdClkEn <= '1';
            Data <= "00000000";
         WHEN A3U =>
            SCL <= '1';
            SDA <= SlaveAddress(3);
            OctetsRead <= OctRd;
            BdClkEn <= '1';
            Data <= "00000000"; 
         WHEN A2D =>
            SCL <= '0';
            SDA <= SlaveAddress(2);
            OctetsRead <= OctRd;
            BdClkEn <= '1';
            Data <= "00000000"; 
         WHEN A2U =>
            SCL <= '1';
            SDA <= SlaveAddress(2);
            OctetsRead <= OctRd;
            BdClkEn <= '1';
            Data <= "00000000"; 
        WHEN A1D =>
            SCL <= '0';
            SDA <= SlaveAddress(1);
            OctetsRead <= OctRd;
            BdClkEn <= '1';
            Data <= "00000000";
         WHEN A1U =>
            SCL <= '1';
            SDA <= SlaveAddress(1);
            OctetsRead <= OctRd;
            BdClkEn <= '1';
            Data <= "00000000";
         WHEN A0D =>
            SCL <= '0';
            SDA <= SlaveAddress(0);
            OctetsRead <= OctRd;
            BdClkEn <= '1';
            Data <= "00000000";          
         WHEN A0U =>
            SCL <= '1';
            SDA <= SlaveAddress(0);
            OctetsRead <= OctRd;
            BdClkEn <= '1';
            Data <= "00000000";          
         WHEN LisToAck =>
            SCL <= '0';
            SDA <= '1';  -- a changer, sda <= Z ---------------------------------
            OctetsRead <= OctRd;
            BdClkEn <= '1';
            Data <= "00000000";             
         WHEN AckReceived =>
            SCL <= '0';
            SDA <= '1'; -------------------idem
            OctetsRead <= OctRd;
            BdClkEn <= '1';
            Data <= "00000000";          
         WHEN D7D =>
            SCL <= '0';
            SDA <= 'Z';
            OctetsRead <= OctRd;
            BdClkEn <= '1';
          WHEN D7U =>
             SCL <= '1';
             SDA <= 'Z';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
             Data(7) <= SDA;
          WHEN D6D =>
             SCL <= '0';
             SDA <= 'Z';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
          WHEN D6U =>
             SCL <= '1';
             SDA <= 'Z';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
             Data (6) <= SDA;
          WHEN D5D =>
             SCL <= '0';
             SDA <= 'Z';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
          WHEN D5U =>
             SCL <= '1';
             SDA <= 'Z';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
             Data (5) <= SDA;
          WHEN D4D =>
              SCL <= '0';
             SDA <= 'Z';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
          WHEN D4U =>
             SCL <= '1';
             SDA <= 'Z';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
             Data(4) <= SDA;
          WHEN D3D =>
             SCL <= '0';
             SDA <= 'Z';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
          WHEN D3U =>
             SCL <= '1';
             SDA <= 'Z';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
             Data(3) <= SDA;
          WHEN D2D =>
             SCL <= '0';
             SDA <= 'Z';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
          WHEN D2U =>
             SCL <= '1';
             SDA <= 'Z';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
             Data (2) <= SDA;
          WHEN D1D =>
             SCL <= '0';
             SDA <= 'Z';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
          WHEN D1U =>
             SCL <= '1';
             SDA <= 'Z';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
             Data (1) <= SDA;
          WHEN D0D =>
             SCL <= '0';
             SDA <= 'Z';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
          WHEN D0U =>
             SCL <= '1';
             SDA <= 'Z';
             OctetsRead <= OctRd;
             BdClkEn <= '1'; 
             Data (0) <= SDA;
          WHEN SendAckD =>
             SCL <= '0';
             SDA <= '1';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
          WHEN SendAckU =>
             SCL <= '1';
             SDA <= '1';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
         WHEN AckSent =>
             SCL <= '1';
             SDA <= '1';
             OctRd <= OctRd + 1;
             OctetsRead <= OctRd;
             BdClkEn <= '1';
         WHEN SendNackD =>
             SCL <= '0';
             SDA <= '0';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
         WHEN SendNackU =>
             SCL <= '1';
             SDA <='0';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
         WHEN NackSent =>
             SCL <= '1';
             SDA <= '0';
             OctRd <= OctRd + 1;
             OctetsRead <= OctRd;
             BdClkEn <= '1';
         WHEN StopD =>
             SCL <= '0';
             SDA <= '0';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
          WHEN StopU =>
             SCL <= '1';
             SDA <= '0';
             OctetsRead <= OctRd;
             BdClkEn <= '1';
             DoneReading <= '1';
        END CASE;
    end if;
end process;

end Behavioral;
