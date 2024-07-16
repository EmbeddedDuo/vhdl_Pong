----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.07.2024 00:16:11
-- Design Name: 
-- Module Name: Seven_Segment_Displays_tb - Behavioral
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
USE IEEE.NUMERIC_STD.ALL;

entity Seven_Segment_Displays_tb is
end Seven_Segment_Displays_tb;

architecture Behavioral of Seven_Segment_Displays_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component Seven_Segment_Displays
    Port (
        clock_i : IN STD_LOGIC;
        reset_i : IN STD_LOGIC;
        led_enable_i : IN STD_LOGIC;
        player_left_score_i : IN INTEGER RANGE 0 TO 99;
        player_right_score_i : IN INTEGER RANGE 0 TO 99;
        seven_seg_leds_o : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        seven_seg_sel_o : OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
    );
    end component;

    -- Signals to connect to UUT
    signal clock_i : STD_LOGIC := '0';
    signal reset_i : STD_LOGIC := '0';
    signal led_enable_i : STD_LOGIC := '0';
    signal player_left_score_i : INTEGER RANGE 0 TO 99 := 0;
    signal player_right_score_i : INTEGER RANGE 0 TO 99 := 0;
    signal seven_seg_leds_o : STD_LOGIC_VECTOR (7 DOWNTO 0);
    signal seven_seg_sel_o : STD_LOGIC_VECTOR (5 DOWNTO 0);

    -- Clock period definitions
    constant clock_period : time := 8 ns;
    constant led_enable_period : time := 1 ms;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: Seven_Segment_Displays
    Port map (
        clock_i => clock_i,
        reset_i => reset_i,
        led_enable_i => led_enable_i,
        player_left_score_i => player_left_score_i,
        player_right_score_i => player_right_score_i,
        seven_seg_leds_o => seven_seg_leds_o,
        seven_seg_sel_o => seven_seg_sel_o
    );

    -- Clock process definitions
    clock_process :process
    begin
        clock_i <= '0';
        wait for clock_period/2;
        clock_i <= '1';
        wait for clock_period/2;
    end process;

    -- LED Enable process definitions
    led_enable_process :process
    begin
        led_enable_i <= '0';
        wait for led_enable_period/2;
        led_enable_i <= '1';
        wait for led_enable_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin		
        -- hold reset state for 100 ns.
        reset_i <= '1';
        wait for 100 ns;	
        reset_i <= '0';
        
        -- Set initial player scores
        player_left_score_i <= 34;
        player_right_score_i <= 56;
        

        
        -- Wait for some time to observe outputs
        wait for 50 ms;
        
        -- Change scores
        player_left_score_i <= 78;
        player_right_score_i <= 12;
        
                
        -- Wait for some time to observe outputs
        wait for 50 ms;
        
        -- hold reset state for 100 ns.
        reset_i <= '1';
        wait for 100 ns;	
        reset_i <= '0';
        
                -- Change scores
        player_left_score_i <= 97;
        player_right_score_i <= 52;
        
        -- Wait for some time to observe outputs
        wait for 50 ms;

        -- Add more test cases as needed
        -- End simulation
        wait;
    end process;

end Behavioral;
