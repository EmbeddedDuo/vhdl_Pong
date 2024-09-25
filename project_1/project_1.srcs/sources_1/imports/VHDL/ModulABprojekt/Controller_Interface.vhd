----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 10.07.2024 11:40:41
-- Design Name:
-- Module Name: Controller_Interface_Right - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: Dieses Modul dient zur Steuerung des Schlägers, 
-- basierend auf Eingaben von einem Drehimpulsgebers.
-- die Eingaben werden entprellt

----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY Controller_Interface IS
    GENERIC (
        clk_frequency_in_Hz : INTEGER := 125_000_000; -- takt_frequenz
        racket_steps : INTEGER := 5;  -- Schritte um der sich Schläger bewegt (in Pixeln)
        debounce_time_in_us : INTEGER := 2000;  -- Entprellzeit in Mikrosekunden 
        racket_height : INTEGER := 30;   -- die Größe der Schläger (Pixel)
        screen_height : INTEGER := 480  -- die Größe der Bildschilm (Pixel)
    );
    PORT (
        clock_i : IN STD_LOGIC; -- Takteingang
        reset_i : IN STD_LOGIC;  -- reseteingang
        rot_enc_i : IN STD_LOGIC_VECTOR (1 DOWNTO 0);  -- Eingang von Drehimplusgebr (A und B)
        push_but_i : IN STD_LOGIC;  -- Signal vom Druckknopf des Drehimpulsgeber
        push_but_deb_o : OUT STD_LOGIC;   -- Entprelltes Ausgangsignal des Druckknopf
        racket_y_pos_o : OUT STD_LOGIC_VECTOR (9 DOWNTO 0) -- Ausgang für die Position des Schlägers.

    );
END Controller_Interface;

ARCHITECTURE Behavioral OF Controller_Interface IS

    SIGNAL debounceoutput_a_b : STD_LOGIC_VECTOR (1 DOWNTO 0); -- Signal für das Entprellte Eingangssignale (A und B) 
    SIGNAL pos_i : INTEGER := (screen_height - racket_height)/2 ; -- Position des Schlägers (fängt in der Mitte an)
    SIGNAL push_but_s : STD_LOGIC := '1'; -- - Signal für das Entprellte Eingangssignal (Druckknopf) 

    TYPE state_type IS (s00, s01, s11, s10); -- die Zustände der Zustandsmaschine
    -- Aktueller und nächster Zustand
    SIGNAL current_state : state_type := s00;  
    SIGNAL next_state : state_type;
    SIGNAL a : STD_LOGIC := '0'; -- Signal für die Synchronisierung 
    SIGNAL b : STD_LOGIC := '0'; -- Signal für die Synchronisierung 
    
    -- Schrittzähler für die Drehung des Encoder
    SIGNAL step_count : INTEGER range -4 to +4 := 0;
    SIGNAL next_step_count : INTEGER range -4 to +4 := 0;

BEGIN
    -- Debounce Modul der Eingangssignale (A und B)
    g_debounce_signals : FOR i IN 0 TO rot_enc_i'length - 1 GENERATE
        debounce_signal : ENTITY work.Rotation_Encoder_Debounced
            GENERIC MAP(
                clk_frequency_in_Hz => clk_frequency_in_Hz,
                debounce_time_in_us => debounce_time_in_us
            )
            PORT MAP(
                clk => clock_i,
                rst => reset_i,
                input => rot_enc_i(i),
                debounce => debounceoutput_a_b(i)
            );
    END GENERATE;

    -- Debounce Modul des Eingangssignals (Durckknopf)
    debounce_signal : ENTITY work.Rotation_Encoder_Debounced
        GENERIC MAP(
            clk_frequency_in_Hz => clk_frequency_in_Hz,
            debounce_time_in_us => debounce_time_in_us
        )
        PORT MAP(
            clk => clock_i,
            rst => reset_i,
            input => push_but_i,
            debounce => push_but_s
        );

    -- Synchronisation der Eingangssignale
    sync : PROCESS (clock_i)
    BEGIN
        IF rising_edge(clock_i) THEN
            a <= debounceoutput_a_b(0);
            b <= debounceoutput_a_b(1);
        END IF;
    END PROCESS;

    -- Prozess für die Zustandsübergangsfunktion
    -- Hier werden die Zustandsübergänge für den Drehencoder festgelegt. 
    -- Und mit jeder Neuzuweiseung für den Nextstate, wird der Zähler entsprechend inkrementiert und dekrementiert, abhängig der Drehrichtung. 
    --     s00, s01, s11, s10: Repräsentieren die vier möglichen Kombinationen der Signale a und b.
    zuef_p : PROCESS (current_state, a, b)
        VARIABLE temp_next_step_count : INTEGER range -4 to +4;
    BEGIN
    
        temp_next_step_count := step_count;

        CASE current_state IS
            WHEN s00 =>
                IF a = '1' THEN
                    next_state <= s01;
                    temp_next_step_count := temp_next_step_count + 1;
                ELSIF b = '1' THEN
                    next_state <= s10;
                    temp_next_step_count := temp_next_step_count - 1;
                ELSE
                    next_state <= current_state;
                END IF;
            WHEN s01 =>
                IF a = '0' THEN
                    next_state <= s00;
                    temp_next_step_count := temp_next_step_count - 1;
                ELSIF b = '1' THEN
                    next_state <= s11;
                    temp_next_step_count := temp_next_step_count + 1;
                ELSE
                    next_state <= current_state;
                END IF;
            WHEN s11 =>
                IF a = '0' THEN
                    next_state <= s10;
                    temp_next_step_count := temp_next_step_count + 1;
                ELSIF b = '0' THEN
                    next_state <= s01;
                    temp_next_step_count := temp_next_step_count - 1;
                ELSE
                    next_state <= current_state;
                END IF;
            WHEN s10 =>
                IF a = '1' THEN
                    next_state <= s11;
                    temp_next_step_count := temp_next_step_count - 1;
                ELSIF b = '0' THEN
                    next_state <= s00;
                    temp_next_step_count := temp_next_step_count + 1;
                ELSE
                    next_state <= current_state;
                END IF;
            WHEN OTHERS =>
                next_state <= s00;
        END CASE;

        next_step_count <= temp_next_step_count;
    END PROCESS;

    -- Prozess für die Speicherung der Zustände und für die Ausgangsfunktion
    -- Aktualisiert den aktuellen Zustand und die Position des Schlägers 
    speicher_p : PROCESS (clock_i)
    BEGIN
        IF rising_edge(clock_i) THEN
            current_state <= next_state;
            step_count <= next_step_count;

            -- Positionsaktualisierung basierend auf Schrittzähler
            IF step_count = 4 THEN            
                IF pos_i < (screen_height - racket_height) THEN
                    pos_i <= pos_i + racket_steps;
                END IF;
                step_count <= 0;
            ELSIF step_count = -4 THEN
                IF pos_i > 0 THEN
                    pos_i <= pos_i - racket_steps;
                END IF;
                step_count <= 0;
            END IF;

            -- Positionsausgabe
            racket_y_pos_o <= STD_LOGIC_VECTOR(to_signed(pos_i, 10));
        END IF;
    END PROCESS;

    push_but_deb_o <= NOT push_but_s;
END Behavioral;