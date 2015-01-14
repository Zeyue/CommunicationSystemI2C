library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ClockGenerator is
    Port (   MAINCLK : in STD_LOGIC;
             TRIGGER : in STD_LOGIC;
            BAUDRATE : in INTEGER;
              CLKOUT : out STD_LOGIC ;
      HALFTIMECLKOUT : out STD_LOGIC);
end ClockGenerator;

architecture Behavioral of ClockGenerator is
CONSTANT MAINFREQ : integer := 100000000;

signal counter : integer;
begin

process (MAINCLK , TRIGGER)
begin
    if MAINCLK' event and MAINCLK = '1' then
        if TRIGGER = '1' then
            if counter >= MAINFREQ/(2 * Baudrate) and counter < MAINFREQ/(2*Baudrate)+1 then
                HALFTIMECLKOUT <= '1';
            else HALFTIMECLKOUT <= '0';  
            end if;
            if counter >= MAINFREQ/BAUDRATE then counter <= 0;
                                                 CLKOUT <= '1';
            else counter <= counter + 1;
                 CLKOUT <= '0';
            end if;
        else counter <= 0;
             CLKOUT <= '0';
             HALFTIMECLKOUT <= '0';
        end if;
    end if;
end process;

end Behavioral;
