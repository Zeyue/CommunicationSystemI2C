----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.12.2014 16:08:01
-- Design Name: 
-- Module Name: I2cSystem - Behavioral
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
use work.state_type_pkg.all;

entity I2cSystem is
    Port ( Clk : in STD_LOGIC;
           SlaveAddress : in STD_LOGIC_VECTOR (7 downto 1);
           --SendAddress : in STD_LOGIC;
           Write : in STD_LOGIC;
           DataToTransmit : in STD_LOGIC_VECTOR (7 downto 0);
           LoadNextOctetToTransmit : out STD_LOGIC;
           Read : in STD_LOGIC;
           DataReceived : out STD_LOGIC_VECTOR (7 downto 0);
           NextOctetReceivedReady : out STD_LOGIC;
           NbToTransmit : in INTEGER;
           NbTransmitted : out INTEGER;
           --DoneTransmitting : out STD_LOGIC;
           NbToReceive : in INTEGER;
           NbReceived : out INTEGER;
           --DoneReceiving : out STD_LOGIC ;
           Scl : out STD_LOGIC;
           Sda : inout STD_LOGIC);
           --sdaAddresser : inout STD_LOGIC);
          -- CurrentState : out STATE_TYPE;
         --  currAddr : out STD_LOGIC_VECTOR (7 downto 0);
         --  SdaAddr : out STD_LOGIC ); ------------------------------------pour le test
end I2cSystem;

architecture Behavioral of I2cSystem is

component ClockGenerator
   Port (   MAINCLK : in STD_LOGIC;
            TRIGGER : in STD_LOGIC;
           BAUDRATE : in INTEGER;
             CLKOUT : out STD_LOGIC ;
             HALFTIMECLKOUT : out STD_LOGIC);
end component;

component Address
   Port ( Clk : in STD_LOGIC;
      BdClk : in STD_LOGIC;
      HalftimeBdClk : in STD_LOGIC;
SlaveAddress : in STD_LOGIC_VECTOR (7 downto 0);
        SCL : out STD_LOGIC;
        SDA : inout STD_LOGIC;
    BdClkEn : out STD_LOGIC ;
SendAddress : in STD_LOGIC ;
AddressSent : out STD_LOGIC;
RW : out STD_LOGIC);         ------------------------------------------------------------------------
end component;

component Transmit
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
      LoadNextOctetToTransmit : out STD_LOGIC;
      DoneTransmitting : out STD_LOGIC;
      RW : out STD_LOGIC );
end component;

component Receive
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
    RW :out STD_LOGIC );
end component;

component MUX
Port ( Clk : in STD_LOGIC;
           SclTransmitter : in STD_LOGIC;
           SclAddresser : in STD_LOGIC;
           SclReceiver : in STD_LOGIC;
           SdaTransmitter : inout STD_LOGIC;
           SdaAddresser : inout STD_LOGIC;
           SdaReceiver : inout STD_LOGIC ;
           BdClkEnTransmitter : in STD_LOGIC;
           BdClkEnAddresser : in STD_LOGIC;
           BdClkEnReceiver : in STD_LOGIC;
           RWAddresser : in STD_LOGIC;
           RWTransmitter : in STD_LOGIC;
           RWReceiver : in STD_LOGIC;
           BdClkEn : out STD_LOGIC;
           Scl : out STD_LOGIC;
           Sda : inout STD_LOGIC;
           state : in STATE_TYPE );
end component;

constant BaudRate : integer := 200000;
signal BdClkEn : STD_LOGIC;
signal BdClk : STD_LOGIC;
signal HalftimeBdClk : STD_LOGIC;
--signal ClkAddresser : STD_LOGIC;
--signal ClkTransmitter : STD_LOGIC;
--signal ClkReceiver : STD_LOGIC;
--signal SendAddress : STD_LOGIC;
signal AddressSent : STD_LOGIC;
signal DoneTransmitting :  STD_LOGIC;
signal DoneReceiving :  STD_LOGIC ;
signal GoTransmit : STD_LOGIC;
signal GoReceive : STD_LOGIC;
signal GoAddress : STD_LOGIC;
signal BdClkEnAddresser : STD_LOGIC;
signal BdClkEnTransmitter : STD_LOGIC;
signal BdClkEnReceiver : STD_LOGIC;
signal SdaAddresser : STD_LOGIC;
signal SclAddresser : STD_LOGIC;
signal SdaTransmitter : STD_LOGIC;
signal SclTransmitter : STD_LOGIC;
signal SdaReceiver : STD_LOGIC;
signal SclReceiver : STD_LOGIC;
--signal fsdaaddresser : STD_LOGIC;
--signal WritingAddress: STD_LOGIC_VECTOR (7 downto 0):= SlaveAddress & '0';
--signal ReadingAddress : STD_LOGIC_VECTOR (7 downto 0):= SlaveAddress & '0';
signal CurrentAddress : STD_LOGIC_VECTOR (7 downto 0);
signal RWAddresser : STD_LOGIC ;         -----------------------------------------------------------
signal RWTransmitter : STD_LOGIC;
signal RWReceiver : STD_LOGIC;
--TYPE STATE_TYPE IS (SendingAddress, TransmittingData, ReceivingData, Idle);
signal state : STATE_TYPE;

begin
ClkGen : ClockGenerator PORT MAP (
    MAINCLK => Clk,
    TRIGGER => BdClkEn,
    BAUDRATE => BaudRate,
    CLKOUT => BdClk,
    HALFTIMECLKOUT => HalftimeBdClk );

Addresser : Address PORT MAP (
          Clk => Clk,
        BdClk => BdClk,
  HalftimeBdClk => HalftimeBdClk,
 SlaveAddress => CurrentAddress,
          SCL => SclAddresser,
          SDA => SdaAddresser,
      BdClkEn => BdClkEnAddresser,
  SendAddress => GoAddress,
  AddressSent => AddressSent ,
  RW => RWAddresser);             ----------------------------------------------------------------------

Transmitter : Transmit PORT MAP (
                 Clk => Clk, 
               BdClk => BdClk,
       HalftimeBdClk => HalftimeBdClk,
        NbToTransmit => NbToTransmit,
                Data => DataToTransmit,
            Transmit => GoTransmit, 
                 SCL => SclTransmitter,
                 SDA => SdaTransmitter,
       NbTransmitted => NbTransmitted,
             BdClkEn => BdClkEnTransmitter, 
  LoadNextOctetToTransmit =>  LoadNextOctetToTransmit,
    DoneTransmitting => DoneTransmitting ,
    RW => RWTransmitter );

Receiver : Receive PORT MAP (
         Clk => Clk,
       BdClk => BdClk,
       HalftimeBdClk => HalftimeBdClk,
 NbToReceive => NbToReceive,
        Data => DataReceived,
     Receive => GoReceive,
         SCL => SclReceiver,
         SDA => SdaReceiver,
  NbReceived => NbReceived,
     BdClkEn => BdClkEnReceiver,
     OctetReceived => NextOctetReceivedReady,
DoneReceiving => DoneReceiving,
RW => RWReceiver );

Multiplexer : MUX PORT MAP (
           Clk => Clk,
           SclTransmitter => SclTransmitter,
           SclAddresser => SclAddresser,
           SclReceiver => SclReceiver,
           SdaTransmitter => SdaTransmitter,
           SdaAddresser => SdaAddresser,
           SdaReceiver => SdaReceiver,
           BdClkEnTransmitter => BdClkEnTransmitter,
           BdClkEnAddresser => BdClkEnAddresser,
           BdClkEnReceiver => BdClkEnReceiver,
           RWAddresser => RWAddresser,   -------------------------------------------------------------
           RWTransmitter => RWTransmitter,
           RWReceiver => RWreceiver,
           BdClkEn => BdClkEn,
           Scl => Scl,
           Sda => Sda,
           state => state );
           

FSMTransition : process (Clk)
begin
if Clk'event and Clk = '1' then
    CASE state IS 
        WHEN Idle =>       -----------------------------------------------------------------------
            if (write = '1' or read = '1') then
                state <= SendingAddress;
            else state <= Idle;
            end if;
        WHEN SendingAddress =>
            if AddressSent = '1' then
                if (write = '1' and read = '0') then state <= TransmittingData;
                elsif (read = '1' and write = '0') then state <= ReceivingData;
                else state <= Idle;
                end if;
            else
                state <= SendingAddress;
            end if;
        WHEN TransmittingData =>
            if DoneTransmitting = '1' then state <= Idle;
            else state <= TransmittingData;
            end if;
        WHEN ReceivingData =>
            if DoneReceiving = '1' then state <= Idle;
            else state <= ReceivingData;
            end if;
    END CASE;
end if;
end process;

FSMValue : process (Clk)
begin 
if Clk' event and Clk = '1' then
    CASE state IS
        WHEN Idle =>
            GoAddress <= '0';
            GoTransmit <= '0';
            GoReceive <= '0';
--            LoadNextOctetToTransmit <= '0';
--            NextOctetReceivedReady <= '0';
--            NbTransmitted <= 0;
--            NbReceived <= 0;
--            AddressSent <= '0';
--            DoneTransmitting <= '0';
--            DoneReceiving <= '0';
--            if read = '1' then 
--                CurrentAddress <= ReadingAddress;
--                GoAddress <= '1';
--            else 
--                CurrentAddress <= WritingAddress;
--                GoAddress <= '1';
--            end if;
        WHEN SendingAddress =>
            if read= '1' then CurrentAddress <= SlaveAddress & '1' ;---------------CHANGER
            else CurrentAddress <= SlaveAddress & '0';
            end if;
            GoAddress <= '1';
        WHEN TransmittingData =>
          GoAddress <= '0';
          GoTransmit <= '1';
        WHEN ReceivingData =>
        GoAddress <= '0';
        GoReceive <= '1';
    END CASE;
end if;
end process;

--CurrentState <= state ; ----------------------------------------------------------------test
--SdaAddr <= SdaAddresser;
--currAddr <= CurrentAddress;
end Behavioral;
