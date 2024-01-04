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
    Port ( 
        100HZ_CLK : in STD_LOGIC;
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

    signal State : t_TrafficState;

    
begin

    process timers

end Behavioral;
