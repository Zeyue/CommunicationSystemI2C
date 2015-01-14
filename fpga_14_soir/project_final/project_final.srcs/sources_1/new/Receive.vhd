library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Receive is
    Port (       Clk : in STD_LOGIC;
               BdClk : in STD_LOGIC;
        HalftimeBdClk : in STD_LOGIC;
         NbToReceive : in INTEGER;
                Data : out STD_LOGIC_VECTOR (7 downto 0);
             Receive : in STD_LOGIC;
                 SCL : out STD_LOGIC;
                 SDA : inout STD_LOGIC;
          NbReceived : out INTEGER;
             BdClkEn : out STD_LOGIC ;
       OctetReceived : out STD_LOGIC;
       DoneReceiving : out STD_LOGIC;
       RW : out STD_LOGIC );
end Receive;

architecture Behavioral of Receive is
TYPE STATE_TYPE IS (BusFree, D7D, D7U, D6D, D6U, D5D, D5U, D4D, D4U, D3D, D3U,
 D2D, D2U, D1D, D1U, D0D, D0U,
SendAckD, SendAckU, AckSent, SendNackD, SendNackU, NackSent, StopD, StopU);
signal state : STATE_TYPE;
signal NbRd : integer := 0;
signal InternalData : STD_LOGIC_VECTOR (7 downto 0);

begin
FSMTransition : process (Clk)
begin
    if Clk' event and Clk = '1' then
        CASE state IS
                            WHEN BusFree =>
                               if Receive = '1' then
                                   state <= D7D;
                               else
                                      state <= BusFree;
                                end if;
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
                                     if NbRd < NbToReceive - 1 then
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
                                if Receive = '0' then state <= BusFree; 
                                end if ;        
                        END CASE;
                    end if;
                end process;

FSMValue : process (Clk)
begin
    if Clk' event and Clk = '1' then
        CASE state IS
                     WHEN BusFree =>
                         SCL <= '1';
                         SDA <= 'Z';
                         NbRd <= 0; --------------???
                         NbReceived <= NbRd;
                         BdClkEn <= '0';
                         Data <= "00000000";
                         InternalData <= "00000000";
                         DoneReceiving <= '0';
                         RW <= '1';
                         OctetReceived <= '0';
                       WHEN D7D =>
                         DoneReceiving <= '0';
                         SCL <= '0';
                         SDA <= 'Z';
                         BdClkEn <= '1';
                         OctetReceived <= '0';
                         RW <= '1';
                       WHEN D7U =>
                          SCL <= '1';
                          SDA <= 'Z';
                          BdClkEn <= '1';
                          if HalftimeBdClk = '1' then
                            InternalData(7) <= SDA;
                          end if;
                       WHEN D6D =>
                          SCL <= '0';
                          SDA <= 'Z';
                          BdClkEn <= '1';
                       WHEN D6U =>
                          SCL <= '1';
                          SDA <= 'Z';
                          BdClkEn <= '1';
                          if HalftimeBdClk = '1' then
                            InternalData (6) <= SDA;
                          end if;
                       WHEN D5D =>
                          SCL <= '0';
                          SDA <= 'Z';
                          BdClkEn <= '1';
                       WHEN D5U =>
                          SCL <= '1';
                          SDA <= 'Z';
                          BdClkEn <= '1';
                          if HalftimeBdClk = '1' then
                            InternalData (5) <= SDA;
                          end if;
                       WHEN D4D =>
                           SCL <= '0';
                          SDA <= 'Z';
                          BdClkEn <= '1';
                       WHEN D4U =>
                          SCL <= '1';
                          SDA <= 'Z';
                          BdClkEn <= '1';
                          if HalftimeBdClk = '1' then
                            InternalData(4) <= SDA;
                          end if;
                       WHEN D3D =>
                          SCL <= '0';
                          SDA <= 'Z';
                          BdClkEn <= '1';
                       WHEN D3U =>
                          SCL <= '1';
                          SDA <= 'Z';
                          BdClkEn <= '1';
                          if HalftimeBdClk = '1' then
                            InternalData(3) <= SDA;
                          end if;
                       WHEN D2D =>
                          SCL <= '0';
                          SDA <= 'Z';
                          BdClkEn <= '1';
                       WHEN D2U =>
                          SCL <= '1';
                          SDA <= 'Z';
                          BdClkEn <= '1';
                          if HalftimeBdClk = '1' then
                            InternalData (2) <= SDA;
                          end if;
                       WHEN D1D =>
                          SCL <= '0';
                          SDA <= 'Z';
                          BdClkEn <= '1';
                       WHEN D1U =>
                          SCL <= '1';
                          SDA <= 'Z';
                          BdClkEn <= '1';
                          if HalftimeBdClk = '1' then
                            InternalData (1) <= SDA;
                          end if;
                       WHEN D0D =>
                          SCL <= '0';
                          SDA <= 'Z';
                          BdClkEn <= '1';
                       WHEN D0U =>
                          SCL <= '1';
                          SDA <= 'Z';
                          BdClkEn <= '1'; 
                          if HalftimeBdClk = '1' then
                            InternalData (0) <= SDA;
                          end if;
                       WHEN SendAckD =>
                          SCL <= '0';
                          SDA <= '0';
                          BdClkEn <= '1';
                          Data <= InternalData;
                          RW <= '0';
                       WHEN SendAckU =>
                          SCL <= '1';
                          SDA <= '0';
                          BdClkEn <= '1';
                          RW <= '0';
                      WHEN AckSent =>
                          SCL <= '1';
                          SDA <= '0';
                          NbReceived <= NbRd + 1;
                          NbRd <= NbRd + 1;
                          OctetReceived <= '1';
                          BdClkEn <= '1';
                          RW <= '0';
                      WHEN SendNackD =>
                          SCL <= '0';
                          SDA <= '1';
                          BdClkEn <= '1';
                          Data <= InternalData;
                          RW <= '0';
                      WHEN SendNackU =>
                          SCL <= '1';
                          SDA <='1';
                          BdClkEn <= '1';
                          RW <= '0';
                      WHEN NackSent =>
                          SCL <= '1';
                          SDA <= '1';
                          NbReceived <= NbRd + 1;
                          NbRd <= NbRd + 1;                         
                          OctetReceived <= '1';
                          BdClkEn <= '1';
                          RW <= '0';
                      WHEN StopD =>
                          SCL <= '0';
                          SDA <= '0';
                          BdClkEn <= '1';
                          OctetReceived <= '0';
                          RW <= '0';
                       WHEN StopU =>
                          SCL <= '1';
                          SDA <= '0';
                          BdClkEn <= '1';
                          if HalftimeBdClk = '1' then
                            DoneReceiving <= '1';
                          end if;
                          RW <= '0';
                     END CASE;
                 end if;
             end process;
end Behavioral;
