----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.07.2024 16:54:32
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
-- Additional Comments: Dieses Modul dient als Top Level für das Score Display
-- Zudem wird hier eine einfache Spiellogik implementiert
---------------------------------------------------------------------------------- 


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
        hit_wall_i : IN STD_LOGIC_VECTOR (2 DOWNTO 0) := "000"; -- Kollisionserkennung wichtig für uns: 101 im Aus rechts; 110 im Aus links
        seven_seg_leds_o : OUT STD_LOGIC_VECTOR (6 DOWNTO 0); -- 7 Bits für 7 Segment Anzeige der Displays
        seven_seg_sel_o : OUT STD_LOGIC_VECTOR (5 DOWNTO 0); -- Auswahl der 6 Displays
        game_over_o : OUT STD_LOGIC);
END Score_Display;



ARCHITECTURE Behavioral OF Score_Display IS
    SIGNAL player_left_score, player_right_score : INTEGER RANGE 0 TO 99 := 0;
    TYPE state_type IS (game_restarted, game_running, game_over);
    SIGNAL current_state : state_type := game_running;
    SIGNAL next_state : state_type := game_running;
BEGIN

    -- Logik für Anzeige des Scores auf Display
    seven_segment: ENTITY work.Seven_Segment_Displays
        Port Map(
        clock_i => clock_i,
        reset_i => reset_i,
        led_enable_i => led_enable_i,
        player_left_score_i => player_left_score,
        player_right_score_i => player_right_score,
        seven_seg_leds_o =>  seven_seg_leds_o,  -- 
        seven_seg_sel_o => seven_seg_sel_o
        );
    
    --Zustandsübergangsprozess für die Spiellogik
    zuef_p : PROCESS (hit_wall_i, current_state, clock_i )
    BEGIN
        if rising_edge(clock_i) then
            -- Falls Spiel neustartet wird Score der beiden Spieler zurückgesetzt und der nächste Zustand wird game running
            CASE current_state IS
                WHEN game_restarted =>
                    player_left_score <= 0;
                    player_right_score <= 0;
                    next_state <= game_running;
                    
           -- Zustand: Spiel ist am Laufen    
                WHEN game_running =>
                -- Falls ein Spieler die maximale Punktzahl erreicht, wird der nächste Zustand game_over
                    IF (player_left_score = score_max) or (player_right_score = score_max)  THEN
                            next_state <= game_over;
                -- Falls Ball rechts im Aus punktet linker Spieler
                    ELSIF hit_wall_i = "101" THEN
                            player_left_score <= player_left_score + 1;
                            next_state <= game_running;
                            
                -- Falls Ball links im Aus punktet rechter Spieler
                    ELSIF hit_wall_i = "110" THEN
                            player_right_score <= player_right_score + 1;
                 
                            next_state <= game_running;
                -- Falls nichts davon eintritt soll nichts gemacht werden            
                    ELSE
                        next_state <= current_state;
                    END IF;

                -- Falls Zustand: Game Over
                WHEN game_over =>
                -- Score wird zurückgesetzt wenn einer der Button des Rotation Encoders gedrückt wird
                    IF push_but1_deb_i = '1' OR push_but2_deb_i = '1' THEN
                        player_left_score <= 0;
                        player_right_score <= 0;
                        
                -- Nächster Zustand wird dann game_running
                        next_state <= game_running;
                    ELSE
                -- Falls Button nicht gedrückt wird bleibt Zustand auf Game Over
                        next_state <= current_state;
                    END IF;

                WHEN OTHERS =>
                    next_state <= current_state;
            END CASE;
        end if;
    END PROCESS;

    -- Speicherprozess
    speicher_p : PROCESS (clock_i, reset_i)
    BEGIN
        -- Falls resetet wird ist der nächste Zustand: game restarted
        IF reset_i = '1' THEN
            current_state <= game_restarted;
        -- Bei jedem clock cycle wird der aktuelle Zustand mit dem nächsten aktualisiert
        ELSIF rising_edge(clock_i) THEN
            current_state <= next_state;
        END IF;
    END PROCESS;

    -- Ausgangsprozess
    af_p : PROCESS (clock_i, current_state)
    BEGIN
        IF rising_edge(clock_i) THEN
            -- Falls der Zustand auf Game over wechselt wird auch Game over ausgegeben
            IF current_state = game_over THEN
                game_over_o <= '1';
            -- Sonst soll Game Over auf 0 bleiben, also Spiel läuft
            ELSE
                game_over_o <= '0';
            END IF;
        END IF;
    END PROCESS;

END Behavioral;