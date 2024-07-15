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
    SIGNAL player_left_score, player_right_score : INTEGER RANGE 0 TO 99 := 0;
    TYPE state_type IS (game_restarted,game_running, game_over);
    SIGNAL current_state : state_type := game_running;
    SIGNAL next_state : state_type;
BEGIN

--    restart : PROCESS (clock_i, push_but1_deb_i, push_but2_deb_i)
--    BEGIN
--        IF rising_edge(clock_i) THEN

--        END IF;
--    END PROCESS;
    
    zuef_p : PROCESS (clock_i, current_state, hit_wall_i, player_left_score, player_right_score)
    BEGIN
        if rising_edge(clock_i) THEN
            CASE current_state is
                when game_restarted => 
                        player_left_score <= 0;
                        player_right_score <= 0;
                        next_state <= game_running;
                when game_running =>
                    if hit_wall_i = "101" THEN
                        if(player_left_score = score_max) then
                            next_state <= game_over;
                        else
                            player_left_score <= player_left_score + 1;
                        END IF;
                    elsif hit_wall_i = "101" THEN
                        if(player_right_score = score_max) then
                            next_state <= game_over;
                        else
                            player_right_score <= player_right_score + 1;
                        end if;    
                    ELSE
                        next_state <= current_state;
                    END IF;
                WHEN game_over =>
                    IF push_but1_deb_i = '1' OR push_but2_deb_i = '1' THEN
                        player_left_score <= 0;
                        player_right_score <= 0;
                        next_state <= game_running;
                    ELSE
                    next_state <= current_state;
                    END IF;
                WHEN OTHERS =>
                    next_state <= current_state;
                END CASE;
            END IF;
    END PROCESS;

    speicher_p : process(clock_i, reset_i)
    begin
        if reset_i = '1' then
            current_state <= game_restarted;
        ELSIF rising_edge(clock_i) THEN
            current_state <= next_state;
        else
            current_state <= current_state;
            next_state <= next_state;
        END IF;
    END PROCESS;

    af_p : process(clock_i, current_state)
    begin
        IF rising_edge(clock_i) THEN
            if current_state = game_over then
                game_over_o <= '1';
            else
                game_over_o <= '0';
            END IF;
        END IF;
    end process;

END Behavioral;