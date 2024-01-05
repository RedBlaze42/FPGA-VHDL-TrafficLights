----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2024 00:06:19
-- Design Name: 
-- Module Name: TrafficLights_tb - Behavioral
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

entity TrafficLights_tb is
end TrafficLights_tb;
    
architecture Behavioral of TrafficLights_tb is
    
    component TrafficLights
        Generic (
            pedestrians_delay_ms : integer := 8000;   -- Time for the Pedestrians to pass (ms)
            warning_delay_ms : integer := 4000;       -- Amount of time the traffic light stays in both warning states (ms)
            cars_delay_ms : integer := 16000         -- Time for the cars to pass (ms)
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
    end component;

    signal CLK_1KHZ_tb : STD_LOGIC := '0';
    signal RST_tb : STD_LOGIC := '0';
    signal PEDESTRIANS_BUTTON_tb : STD_LOGIC := '0';
    signal CARS_RED_tb : STD_LOGIC := '0';
    signal CARS_YELLOW_tb : STD_LOGIC := '0';
    signal CARS_GREEN_tb : STD_LOGIC := '0';
    signal PEDESTRIANS_RED_tb : STD_LOGIC := '0';
    signal PEDESTRIANS_GREEN_tb : STD_LOGIC := '0';

begin

    clk_gen : process
    begin
        CLK_1KHZ_tb <= '1';
        wait for 500 us;
        CLK_1KHZ_tb <= '0';
        wait for 500 us;
    end process;

    stimulus : process
    begin
        RST <= '1';
        wait for 1000 ms;
        RST <= '0';

        wait for 42000 ms; -- One and a half full cycles

        PEDESTRIANS_BUTTON_tb <= '1';

        wait for 28000 ms; -- Wait for the state to be CARS_PASS then observe
        wait;
    end process;

    uut : TrafficLights port map(
        CLK_1KHZ => CLK_1KHZ_tb,
        RST => RST_tb,
        PEDESTRIANS_BUTTON => PEDESTRIANS_BUTTON_tb,
        CARS_RED => CARS_RED_tb,
        CARS_YELLOW => CARS_YELLOW_tb,
        CARS_GREEN => CARS_GREEN_tb,
        PEDESTRIANS_RED => PEDESTRIANS_RED_tb,
        PEDESTRIANS_GREEN => PEDESTRIANS_GREEN_tb
    );

end Behavioral;
