----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2014 17:31:59
-- Design Name: 
-- Module Name: TransmitFSM - Behavioral
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

entity TransmitFSM is
    Port (         Clk : in STD_LOGIC;
                 BdClk : in STD_LOGIC;
            ToTransmit : in INTEGER;
                  Data : in STD_LOGIC_VECTOR (7 downto 0);
              Transmit : in STD_LOGIC;
                   SCL : out STD_LOGIC;
                   SDA : inout STD_LOGIC;
           Transmitted : out INTEGER;
               BdClkEn : out STD_LOGIC; 
               DoneWriting : out STD_LOGIC);
end TransmitFSM;

architecture Behavioral of TransmitFSM is
TYPE STATE_TYPE IS (BusFree, Start, T7, R7, T6, R6, T5, R5, T4, R4, T3,
 R3, T2, R2, T1, R1, T0, R0, LisToAck, AckReceived, Stop);
signal state : STATE_TYPE;
signal trans : integer := 0;

begin
-- state machine
FSM1Transition : process (Clk)
begin
    If Clk' event and Clk = '1' then
        CASE state IS
            WHEN BusFree =>
                if Transmit = '1' and trans < ToTransmit then
                    state <= Start;
                else 
                    state <= BusFree;
                end if;
            WHEN Start =>
                if BdClk = '1' then
                    state <= T7;
                else 
                    state <= Start;
                end if;
            WHEN T7 =>
                if BdClk = '1' then
                    state <= R7;
                else
                    state <= T7;
                end if;
            WHEN R7 =>
                if BdClk = '1' then
                    state <= T6;
                else
                    state <= R7;
                end if;
            WHEN T6 =>
                if BdClk = '1' then
                    state <= R6;
                else
                    state <= T6;
                end if;
            WHEN R6 =>
                if BdClk = '1' then
                    state <= T5;
                else
                     state <= R6;
                end if;
            WHEN T5 =>
                if BdClk = '1' then
                    state <= R5;
                else
                    state <= T5;
                end if;
            WHEN R5 =>
                if BdClk = '1' then
                    state <= T4;
                else
                    state <= R5;
                end if;
            WHEN T4 =>
                if BdClk = '1' then
                    state <= R4;
                else
                    state <= T4 ;
                end if;
            WHEN R4 =>
                if BdClk = '1' then
                    state <= T3;
                else
                    state <= R4 ;
                end if;
            WHEN T3 =>
                if BdClk = '1' then
                    state <= R3;
                else
                    state <= T3;
                end if;
            WHEN R3 =>
                if BdClk = '1' then
                    state <= T2;
                else
                    state <= R3;
                end if;
            WHEN T2 =>
                if BdClk = '1' then
                    state <= R2;
                else
                    state <= T2;
                end if;
            WHEN R2 =>
                if BdClk = '1' then
                    state <= T1;
                else
                    state <= R2;
                end if;
            WHEN T1 =>
                if BdClk = '1' then
                    state <= R1;
                else
                    state <= T1;
                end if;
            WHEN R1 =>
                if BdClk = '1' then
                    state <= T0 ;
                else
                    state <= R1;
                end if;
            WHEN T0 =>
                if BdClk = '1' then
                    state <= R0;
                else
                    state <= T0;
                end if;
            WHEN R0=>
                if BdClk = '1' then
                    state <= LisToAck;
                else
                    state <= R0 ;
                end if;
            WHEN LisToAck =>
                if BdClk = '1' then
                    if SDA = '1' then
                        state <= AckReceived;
                    else state <= LisToAck;
                    end if;
                end if;
            WHEN AckReceived =>              
                if trans < ToTransmit -1 then
                    state <= T7;
                else
                    state <= Stop;
                end if;                          
            WHEN Stop =>
                if BdClk = '1' then
                    state <= BusFree;
                else
                    state <= Stop ;
                end if;
        END CASE;
    end if;
end process;

-- Interpretation
FSM1Value : process(Clk)
begin
    If Clk' event and Clk = '1' then
        CASE state IS
            WHEN BusFree =>  -- SDA being cleared from BusFree to SDA is the start condition
                SCL <= '1';
                SDA <= '1';
                Transmitted <= trans;
                BdClkEn <= '0';
            WHEN Start => 
                SCL <= '1';
                SDA <= '0';
                Transmitted <= trans;
                BdClkEn <= '1';
                DoneWriting <= '0';
            WHEN  T7=> 
                SCL <= '0';
                SDA <= Data(7);
                Transmitted <= trans;
                BdClkEn <= '1';
            WHEN R7 => 
                SCL <= '1';
                SDA <= Data(7);
                Transmitted <= trans;
                BdClkEn <= '1';
            WHEN T6 => 
                SCL <= '0';
                SDA <= Data(6);
                Transmitted <= trans;
                BdClkEn <= '1';
            WHEN R6 => 
                SCL <= '1';
                SDA <= Data(6);
                Transmitted <= trans;
                BdClkEn <= '1';
            WHEN T5 => 
                SCL <= '0';
                SDA <= Data(5);
                Transmitted <= trans;
                BdClkEn <= '1';
            WHEN R5 => 
                SCL <= '1';
                SDA <= Data(5);
                Transmitted <= trans;
                BdClkEn <= '1';
            WHEN T4 => 
                SCL <= '0';
                SDA <= Data(4);
                Transmitted <= trans;
                BdClkEn <= '1';
            WHEN R4 => 
                SCL <= '1';
                SDA <= Data(4);
                Transmitted <= trans;
                BdClkEn <= '1';
            WHEN T3 => 
                SCL <= '0';
                SDA <= Data(3);
                Transmitted <= trans;
                BdClkEn <= '1';
            WHEN R3 => 
                SCL <= '1';
                SDA <= Data(3);
                Transmitted <= trans;
                BdClkEn <= '1';
            WHEN T2 => 
                SCL <= '0';
                SDA <= Data(2);
                Transmitted <= trans;
                BdClkEn <= '1';
            WHEN R2 => 
                SCL <= '1';
                SDA <= Data(2);
                Transmitted <= trans;
                BdClkEn <= '1';
            WHEN T1 => 
                SCL <= '0';
                SDA <= Data(1);
                Transmitted <= trans;
                BdClkEn <= '1';
            WHEN R1 => 
                SCL <= '1';
                SDA <= Data(1);
                Transmitted <= trans;
                BdClkEn <= '1';
            WHEN T0 => 
                SCL <= '0';
                SDA <= Data(0);
                Transmitted <= trans;
                BdClkEn <= '1';
            WHEN R0 => 
                SCL <= '1';
                SDA <= Data(0);
                Transmitted <= trans;   
                BdClkEn <= '1';
            WHEN LisToAck => 
                SCL <= '0';
                SDA <='1'; --test, a changer SDA <= Z
                Transmitted <= trans;
                BdClkEn <= '1';
            WHEN AckReceived =>
                SCL <= '0';
                trans <= trans + 1;
                Transmitted <= trans;
                BdClkEn <= '1';
            WHEN Stop =>        -- SDA being set from stop to BusFree is the stop condition
                SCL <= '1';
                SDA <= '0';
                Transmitted <= trans;
                BdClkEn <= '1';
                DoneWriting <= '1';
        END CASE;
    end if;
end process;

end Behavioral;
