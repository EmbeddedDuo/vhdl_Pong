----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.07.2024 11:40:41
-- Design Name: 
-- Module Name: Score_Display - Behavioral
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Score_Display IS
    GENERIC (score_max : INTEGER RANGE 0 TO 99 := 10); -- Max Point 
    PORT (
        clock_i : IN STD_LOGIC;
        reset_i : IN STD_LOGIC;
        led_enable_i : IN STD_LOGIC;
        push_but1_deb_i : IN STD_LOGIC;
        push_but2_deb_i : IN STD_LOGIC;
        hit_wall_i : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        seven_seg_leds_o : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        seven_seg_sel_o : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
        game_over_o : OUT STD_LOGIC);
END Score_Display;

ARCHITECTURE Behavioral OF Score_Display IS
    SIGNAL player1_score, player2_score : INTEGER RANGE 0 TO 99 := 0;
    SIGNAL allow_restart : BOOLEAN := false;

BEGIN
    PROCESS (hit_wall_i)
    BEGIN
        IF hit_wall_i = "101" THEN
            IF player1_score = score_max THEN
                allow_restart <= true;
            ELSE
                player1_score <= player1_score + 1;
            END IF;
        ELSIF hit_wall_i = "110" THEN
            IF player2_score = score_max THEN
                allow_restart <= true;
            ELSE
                player2_score <= player2_score + 1;
            END IF;
        END IF;
    END PROCESS;
END Behavioral;