----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2024 00:02:08
-- Design Name: 
-- Module Name: FSM_interface - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM_interface is
    Port (
        CLK100MHZ : in STD_LOGIC; -- 100mHz clock
        btnC : in STD_LOGIC; -- Pedestrian button
        btnU : in STD_LOGIC; -- System reset
        LED : out STD_LOGIC_VECTOR (0 to 15) -- 16 LEDs
    );
end FSM_interface;

architecture Behavioral of FSM_interface is

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

    signal clk_ms : STD_LOGIC := '1'; -- 1kHz clock
    signal prescaler_counter : INTEGER range 0 to 50000 := 0; -- counter for the clock divider 
    signal rst : STD_LOGIC; -- System reset
begin
    rst <= btnU;

    clock_divider : process (CLK100MHZ, rst) is begin
        if(rst = '1') then
            prescaler_counter <= 0;
        elsif(rising_edge(CLK100MHZ)) then
            
            if(prescaler_counter = 50000) then
                clk_ms <= not clk_ms;  -- Invert the output clock each every 500 ticks of the input clock
                prescaler_counter <= 1;
            else
                prescaler_counter <= prescaler_counter + 1;
            end if;

        end if;
    end process;

    -- Instantiation of the FSM
    -- You can map the generics to edit the default delays
    TrafficLights_FSM : TrafficLights port map(
        CLK_1KHZ => clk_ms,
        RST => rst,
        PEDESTRIANS_BUTTON => btnC,
        CARS_RED => LED(0),
        CARS_YELLOW => LED(1),
        CARS_GREEN => LED(2),
        PEDESTRIANS_RED => LED(14),
        PEDESTRIANS_GREEN => LED(15)
    );
    
end Behavioral;
