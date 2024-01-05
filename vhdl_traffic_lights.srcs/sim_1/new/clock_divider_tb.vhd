----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2024 01:59:14
-- Design Name: 
-- Module Name: clock_divider_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity clock_divider_tb is
end clock_divider_tb;

architecture sim of clock_divider_tb is
    signal CLK100MHZ_tb : STD_LOGIC := '0';
    signal btnC_tb : STD_LOGIC := '0';
    signal btnU_tb : STD_LOGIC := '0';
    signal LED_tb : STD_LOGIC_VECTOR (0 to 15) := (others => '0');

    component FSM_interface
        Port (
            CLK100MHZ : in STD_LOGIC;
            btnC : in STD_LOGIC;
            btnU : in STD_LOGIC;
            LED : out STD_LOGIC_VECTOR (0 to 15)
        );
    end component;

begin

    clk_gen : process
    begin
        CLK100MHZ_tb <= '1';
        wait for 5 ns;
        CLK100MHZ_tb <= '0';
        wait for 5 ns;
    end process;

    -- Stimulus process
    stimulus : process
    begin
        btnU_tb <= '1'; -- Set system reset initially
        wait for 100 ns;

        btnU_tb <= '0'; -- Release system reset
        wait;
    end process;

    uut : FSM_interface port map(
        CLK100MHZ => CLK100MHZ_tb,
        btnC => btnC_tb,
        btnU => btnU_tb,
        LED => LED_tb
    );

end sim;

