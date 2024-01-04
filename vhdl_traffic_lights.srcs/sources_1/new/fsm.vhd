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
        clk : in STD_LOGIC; -- 100mHz clock
        btnC : in STD_LOGIC; -- Pedestrian button
        btnU : in STD_LOGIC; -- System reset
        LED : in STD_LOGIC_VECTOR (0 to 15) -- 16 LEDs
    );
end FSM_interface;

architecture Behavioral of FSM_interface is

    component TrafficLights
        Port ( 
            100HZ_CLK : in STD_LOGIC;
            PEDESTRIANS_BUTTON : in STD_LOGIC;
            CARS_RED : out STD_LOGIC;
            CARS_YELLOW : out STD_LOGIC;
            CARS_GREEN : out STD_LOGIC;
            PEDESTRIANS_RED : out STD_LOGIC;
            PEDESTRIANS_GREEN : out STD_LOGIC
        );
    end component;

    signal clk_ms : STD_LOGIC := 1; -- 1kHz clock
    signal prescaler_counter : INTEGER range 0 to 500 := 0; -- counter for the clock divider 
    signal rst : STD_LOGIC; -- System reset
begin
    rst <= btnU;

    clock_divider : process (clk, rst) is begin
        if(rst = '1')
            prescaler_counter = 0;
        elsif(rising_edge(clk))
            
            if(prescaler_counter = 500)
                clk_ms = not clk;  -- Invert the output clock each every 500 ticks of the input clock
                prescaler_counter <= 1;
            else
                prescaler_counter <= prescaler_counter + 1;
            end if;

        end if;
    end process;

    TrafficLights_FSM : port map(
        100HZ_CLK => clk_ms,
        PEDESTRIANS_BUTTON => btnC,
        CARS_RED => LED(0),
        CARS_YELLOW => LED(1),
        CARS_GREEN => LED(2),
        PEDESTRIANS_RED => LED(14),
        PEDESTRIANS_GREEN => LED(15),
    )
    
end Behavioral;
