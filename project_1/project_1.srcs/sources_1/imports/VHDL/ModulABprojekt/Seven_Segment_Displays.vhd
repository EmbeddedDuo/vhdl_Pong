----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.07.2024 00:16:11
-- Design Name: 
-- Module Name: Seven_Segment_Displays - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: Modul für die Anzeige Logik der Displays
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity Seven_Segment_Displays is
    Port (
        clock_i : IN STD_LOGIC;
        reset_i : IN STD_LOGIC;
        led_enable_i : IN STD_LOGIC;
        player_left_score_i : IN INTEGER RANGE 0 TO 99;
        player_right_score_i : IN INTEGER RANGE 0 TO 99;
        seven_seg_leds_o : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        seven_seg_sel_o : OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
     );
end Seven_Segment_Displays;

architecture Behavioral of Seven_Segment_Displays is
        -- Aufteilung der zweistelligen Zahl in Einer -und Zehnerstellen
        SIGNAL player_left_score_first_digit : INTEGER RANGE 0 TO 9 := 0;
        SIGNAL player_right_score_first_digit : INTEGER RANGE 0 TO 9 := 0;
        SIGNAL player_left_score_second_digit : INTEGER RANGE 0 TO 9 := 0;
        SIGNAL player_right_score_second_digit : INTEGER RANGE 0 TO 9 := 0;
        -- Signal für aktuelle anzuzeigende Zahl
        SIGNAL current_number_to_display : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
        -- Auswahl der aktuellen 7 Segment Anzeige
        SIGNAL seg_sel : STD_LOGIC_VECTOR (5 DOWNTO 0) := "000001";
begin


    -- Prozess für Auswahl der Anzeige, wird durch led_enable getaktet
    select_display: PROCESS(led_enable_i, seg_sel)
    begin
        -- Falls resettet wird, wird der erste Bildschirm ausgewählt
        if reset_i = '1' then
            seg_sel <= "000001";
        elsif rising_edge(led_enable_i) then
            -- Sobald das letzte Display ausgewählt war, wird wieder das erste genommen
            if seg_sel = "100000" THEN
                seg_sel <= "000001"; 
            ELSE
            -- Zum Wechseln des Displays benutzen wir ein Links shift um 1, das heißt
            -- die eins wandert immer weiter nach Links des vectors: 000001 -> 000010
                seg_sel <= std_logic_vector(shift_left(unsigned(seg_sel), 1));
            END IF;
        END IF;
        -- Ausgabe des Select siganls
        seven_seg_sel_o <= seg_sel;
    END PROCESS;
    
    -- Prozess um die anzuzeigende Zahl in den einzelnen Stellen aufzuteilen
    calc_digits: PROCESS(clock_i, reset_i)
    begin
        -- Bei reset wird Score wieder auf 0 gesetzt
        if reset_i = '1' then
            player_left_score_first_digit <= 0;
            player_right_score_first_digit <= 0;
            player_left_score_second_digit <= 0;
            player_right_score_second_digit <= 0;
        elsif rising_edge(clock_i) then
        -- Mit Modulo Rechnung wird Einer- dann Zehnerstelle errechnet
            player_left_score_first_digit <= player_left_score_i mod 10;
            player_right_score_first_digit <= player_right_score_i mod 10;
            player_left_score_second_digit <= (player_left_score_i / 10) mod 10;
            player_right_score_second_digit <= (player_right_score_i / 10) mod 10;
        end if;
    END PROCESS;
    
    -- Prozess um Zahl auf Display anzeigen zu lassen
    -- Hier sagt seg_sel welches Display ausgewählt wird, 0000001 ist ganz rechts und 100000 ganz links
    print_numbers: PROCESS(clock_i, seg_sel)
        begin
        if rising_edge(clock_i) then
                CASE seg_sel is
                    -- Einerstelle von rechten Spieler in 4 bit vector umrechnen für BCD Decoder
                    when "000001" =>
                        current_number_to_display <= std_logic_vector(TO_UNSIGNED(player_right_score_first_digit ,4));
                    -- Zehnerstelle von rechten Spieler in 4 bit vector umrechnen für BCD Decoder
                    when "000010" =>
                        current_number_to_display <= std_logic_vector(TO_UNSIGNED(player_right_score_second_digit ,4));
                    -- Trennzeichen für beide mittleren Displays
                    when "000100" =>
                        current_number_to_display <= "1010"; 
                    when "001000" =>
                        current_number_to_display <= "1010";
                    -- Einerstelle von linken Spieler in 4 bit vector umrechnen für BCD Decoder
                    when "010000" =>
                        current_number_to_display <= std_logic_vector(TO_UNSIGNED(player_left_score_first_digit ,4));
                    -- Zehnerstelle von linken Spieler in 4 bit vector umrechnen für BCD Decoder
                    when "100000" =>
                        current_number_to_display <= std_logic_vector(TO_UNSIGNED(player_left_score_second_digit ,4));
                    -- Um Latches zu vermeiden werden alle anderen Auswahlzustände mit der Zahl 0 zugewiesen
                    when OTHERS =>
                        current_number_to_display <= "0000";
                END CASE;
            END IF;
    END PROCESS;
    
    -- BCD Decoder für Decodig von 4 Bit Zahl in Format für 7 Segment Display
    bcd_Decoder_Ins : ENTITY work.BCD_Decoder
        PORT MAP(
            bcd_in => current_number_to_display, 
            segment_out => seven_seg_leds_o
    );

end Behavioral;
