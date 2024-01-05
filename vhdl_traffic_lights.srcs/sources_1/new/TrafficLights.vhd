----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2024 00:03:20
-- Design Name: 
-- Module Name: TrafficLights - Behavioral
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

entity TrafficLights is
    Generic (
        pedestrians_delay_ms : INTEGER := 8000;   -- Time for the Pedestrians to pass (ms)
        warning_delay_ms : INTEGER := 4000;       -- Amount of time the traffic light stays in both warning states (ms)
        cars_delay_ms : INTEGER := 16000         -- Time for the cars to pass (ms)
    );
    Port ( 
        CLK_1KHZ : in STD_LOGIC;
        RST : in STD_LOGIC;
        PEDESTRIANS_BUTTON : in STD_LOGIC;
        CARS_RED : out STD_LOGIC;
        CARS_YELLOW : out STD_LOGIC;
        CARS_GREEN : out STD_LOGIC;
        PEDESTRIANS_RED : out STD_LOGIC;
        PEDESTRIANS_GREEN : out STD_LOGIC
    );
end TrafficLights;

architecture Behavioral of TrafficLights is

    type t_TrafficState is (
        PEDESTRIANS_PASS,   -- Pedestrians can pass
        PEDESTRIANS_WARNING,-- Notify the pedestrians that cars will soon pass
        CARS_WARNING,       -- Notify the cars that pedestrians will soon pass
        CARS_PASS           -- Cars can pass
    );

    signal state : t_TrafficState := PEDESTRIANS_PASS;
    signal counter : INTEGER := 0;

begin

    process (CLK_1KHZ, RST) is
        variable reset_counter : boolean := false;
    begin
        if(RST = '1') then
            state <= PEDESTRIANS_PASS;
            counter <= 0;
        elsif(rising_edge(CLK_1KHZ)) then

            reset_counter := false;
            case state is
                when PEDESTRIANS_PASS =>
                    if(counter = pedestrians_delay_ms) then
                        reset_counter := true;
                        state <= PEDESTRIANS_WARNING;
                    end if;
                when PEDESTRIANS_WARNING =>
                    if(counter = warning_delay_ms) then
                        reset_counter := true;
                        state <= CARS_PASS;
                    end if;
                when CARS_WARNING =>
                    if(counter = warning_delay_ms) then
                        reset_counter := true;
                        state <= PEDESTRIANS_PASS;
                    end if;
                when CARS_PASS =>
                    if(counter = cars_delay_ms or PEDESTRIANS_BUTTON = '1') then
                        reset_counter := true;
                        state <= CARS_WARNING;
                    end if;
            end case;

            if(reset_counter) then
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;

    end process;
    
    CARS_RED <= '1' when state = PEDESTRIANS_PASS or state = PEDESTRIANS_WARNING else '0';
    CARS_YELLOW <= '1' when state = CARS_WARNING else '0';
    CARS_GREEN <= '1' when state = CARS_PASS else '0';

    PEDESTRIANS_RED <= '0' when state = PEDESTRIANS_PASS else '1';
    PEDESTRIANS_GREEN <= '1' when state = PEDESTRIANS_PASS else '0';

end Behavioral;
