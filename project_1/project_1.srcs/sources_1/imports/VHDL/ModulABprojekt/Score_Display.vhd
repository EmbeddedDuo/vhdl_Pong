LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Score_Display IS
    GENERIC (score_max : INTEGER RANGE 0 TO 99 := 10); -- Max Point 
    PORT (
        clock_i : IN STD_LOGIC;
        reset_i : IN STD_LOGIC;
        led_enable_i : IN STD_LOGIC;
        push_but1_deb_i : IN STD_LOGIC;
        push_but2_deb_i : IN STD_LOGIC;
        hit_wall_i : IN STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
        seven_seg_leds_o : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        seven_seg_sel_o : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
        game_over_o : OUT STD_LOGIC);
END Score_Display;

ARCHITECTURE Behavioral OF Score_Display IS
    SIGNAL player_left_score, player_right_score : INTEGER RANGE 0 TO 99 := 0;
    TYPE state_type IS (game_restarted, game_running, game_over);
    SIGNAL current_state : state_type := game_running;
    SIGNAL next_state : state_type := game_running;
BEGIN

    seven_segment: ENTITY work.Seven_Segment_Displays
        Port Map(
        clock_i => clock_i,
        reset_i => reset_i,
        led_enable_i => led_enable_i,
        player_left_score_i => player_left_score,
        player_right_score_i => player_right_score,
        seven_seg_leds_o =>  seven_seg_leds_o,
        seven_seg_sel_o => seven_seg_sel_o
        );
    

    zuef_p : PROCESS (hit_wall_i, current_state, clock_i )
    BEGIN
        if rising_edge(clock_i) then
            CASE current_state IS
                WHEN game_restarted =>
                    player_left_score <= 0;
                    player_right_score <= 0;
                    next_state <= game_running;

                WHEN game_running =>
                    IF (player_left_score = score_max) or (player_right_score = score_max)  THEN
                            next_state <= game_over;
                    ELSIF hit_wall_i = "101" THEN
                            player_left_score <= player_left_score + 1;
                            next_state <= game_running;
                    ELSIF hit_wall_i = "110" THEN
                            player_right_score <= player_right_score + 1;
                            next_state <= game_running;
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
        end if;
    END PROCESS;

    speicher_p : PROCESS (clock_i, reset_i)
    BEGIN
        IF reset_i = '1' THEN
            current_state <= game_restarted;
        ELSIF rising_edge(clock_i) THEN
            current_state <= next_state;
        END IF;
    END PROCESS;

    af_p : PROCESS (clock_i, current_state)
    BEGIN
        IF rising_edge(clock_i) THEN
            IF current_state = game_over THEN
                game_over_o <= '1';
            ELSE
                game_over_o <= '0';
            END IF;
        END IF;
    END PROCESS;

END Behavioral;