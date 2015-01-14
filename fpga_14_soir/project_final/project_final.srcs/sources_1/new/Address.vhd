library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Address is
    Port ( Clk : in STD_LOGIC;
         BdClk : in STD_LOGIC;
         HalftimeBdClk : in STD_LOGIC;
  SlaveAddress : in STD_LOGIC_VECTOR (7 downto 0);
           SCL : out STD_LOGIC;
           SDA : inout STD_LOGIC;
       BdClkEn : out STD_LOGIC ;
   SendAddress : in STD_LOGIC ;
   AddressSent : out STD_LOGIC;
   RW : out STD_LOGIC);-------------------------------------------------------------------------------------------------------------------------------------
end Address;

architecture Behavioral of Address is
TYPE STATE_TYPE IS (BusFree, StartD, StartU, A7D, A7U, A6D, A6U, A5D, 
A5U, A4D, A4U, A3D, A3U, A2D, A2U, A1D, A1U, A0D, A0U, LisToAckD, LisToAckU, AckReceived, NackReceived);

signal state : STATE_TYPE;
signal Ack : STD_LOGIC;

begin
FSMTransition : process (Clk)
begin
    if Clk' event and Clk = '1' then
        CASE state IS
            WHEN BusFree =>
                if SendAddress = '1' then
                    state <= StartD;
                else
                    state <= BusFree;
                end if;
            WHEN StartD =>
                if BdClk = '1' then
                    state <= StartU;
                else
                    state <= StartD;
                end if;
            WHEN StartU =>
                if BdClk = '1' then
                    state <= A7D;
                else 
                    state <= StartU;
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
                    state <= LisToAckD;
                else 
                    state <= A0U;
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
                state <= BusFree;
            WHEN NackReceived =>
                state <= BusFree;
        END CASE;
    end if;
end process;
              
FSMValue : process (Clk)
                begin
                    if Clk' event and Clk = '1' then
                        CASE state IS
                         WHEN BusFree =>
                             AddressSent <= '0';
                             SCL <= '1';
                             SDA <= '1';
                             Ack <= '0';
                             BdClkEn <= '0';
                             RW <= '0';         --------------------------------------------------------------------------------------------------------
                         WHEN StartD =>
                            SCL <= '1';
                            SDA <= '1';
                            BdClkEn <= '1';
                            AddressSent <= '0';
                         WHEN StartU =>
                             SCL <= '1';
                             SDA <= '0';
                             BdClkEn <= '1';
                             AddressSent <= '0';            
                         WHEN A7D =>
                            SCL <= '0';
                            SDA <= SlaveAddress(7);
                            BdClkEn <= '1';        
                         WHEN A7U =>
                            SCL <= '1';
                            SDA <= SlaveAddress(7);
                            BdClkEn <= '1'; 
                         WHEN A6D =>
                            SCL <= '0';
                            SDA <= SlaveAddress(6);
                            BdClkEn <= '1';  
                         WHEN A6U =>
                            SCL <= '1';
                            SDA <= SlaveAddress(6);
                            BdClkEn <= '1';
                         WHEN A5D =>
                            SCL <= '0';
                            SDA <= SlaveAddress(5);
                            BdClkEn <= '1';
                         WHEN A5U =>
                            SCL <= '1';
                            SDA <= SlaveAddress(5);
                            BdClkEn <= '1'; 
                         WHEN A4D =>
                            SCL <= '0';
                            SDA <= SlaveAddress(4);
                            BdClkEn <= '1';
                         WHEN A4U =>
                            SCL <= '1';
                            SDA <= SlaveAddress(4);
                            BdClkEn <= '1';
                         WHEN A3D =>
                            SCL <= '0';
                            SDA <= SlaveAddress(3);
                            BdClkEn <= '1';
                         WHEN A3U =>
                            SCL <= '1';
                            SDA <= SlaveAddress(3);
                            BdClkEn <= '1'; 
                         WHEN A2D =>
                            SCL <= '0';
                            SDA <= SlaveAddress(2);
                            BdClkEn <= '1';
                         WHEN A2U =>
                            SCL <= '1';
                            SDA <= SlaveAddress(2);
                            BdClkEn <= '1';
                        WHEN A1D =>
                            SCL <= '0';
                            SDA <= SlaveAddress(1);
                            BdClkEn <= '1';
                         WHEN A1U =>
                            SCL <= '1';
                            SDA <= SlaveAddress(1);
                            BdClkEn <= '1';
                         WHEN A0D =>
                            SCL <= '0';
                            SDA <= SlaveAddress(0);
                            BdClkEn <= '1';        
                         WHEN A0U =>
                            SCL <= '1';
                            SDA <= SlaveAddress(0);
                            BdClkEn <= '1';         
                         WHEN LisToAckD =>
                            SCL <= '0';
                            SDA <= 'Z';  
                            BdClkEn <= '1';  
                            RW <= '1';---------------------------------------------------------------------------------------------------------
                         WHEN LisToAckU =>
                            SCL <= '1';
                            SDA <= 'Z';
                            BdClkEn <= '1';  
                            if HalftimeBdClk = '1' and SDA = '0' then
                                 Ack <= '1';               
                            end if;  
                            RW <= '1';    ----------------------------------------------------------------------------------------------------------- 
                         WHEN AckReceived =>
                            SCL <= '1';
                            SDA <= 'Z'; 
                            AddressSent <= '1';
                            BdClkEn <= '1';
                            Ack <= '0';
                            RW <= '0';--------------------------------------------------------------------------------------------------------------
                         WHEN NackReceived =>
                            SCL <= '1';
                            SDA <= 'Z';
                            AddressSent <= '0';
                            BdClkEn <= '1';
                            RW <= '0';   -----------------------------------------------------------------------------------------------------
          end CASE;
    end if;
end process;
end Behavioral;
