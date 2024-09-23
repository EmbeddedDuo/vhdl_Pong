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
-- Additional Comments:
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Controller_Interface IS
    GENERIC (
        clk_frequency_in_Hz : INTEGER := 125_000_000;
        racket_steps : INTEGER := 5;
        debounce_time_in_us : INTEGER := 2000;
        racket_height : INTEGER := 30;
        screen_height : INTEGER := 480
    );
    PORT (
        clock_i : IN STD_LOGIC;
        reset_i : IN STD_LOGIC;
        rot_enc_i : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        push_but_i : IN STD_LOGIC;
        push_but_deb_o : OUT STD_LOGIC;
        racket_y_pos_o : OUT STD_LOGIC_VECTOR (9 DOWNTO 0)

    );
END Controller_Interface;

ARCHITECTURE Behavioral OF Controller_Interface IS

    SIGNAL debounceoutput_a_b : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL pos_i : INTEGER := (screen_height - racket_height)/2 ;
    SIGNAL push_but_s : STD_LOGIC := '1';

    TYPE state_type IS (s00, s01, s11, s10);
    SIGNAL current_state : state_type := s00;
    SIGNAL next_state : state_type;
    SIGNAL prev_state : state_type := s00;
    SIGNAL a : STD_LOGIC := '0';
    SIGNAL b : STD_LOGIC := '0';

BEGIN
    -- debounced value for rotation encoder
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

    -- debounced value for the button (sw)
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

    sync : PROCESS (clock_i)
    BEGIN
        IF rising_edge(clock_i) THEN
            a <= debounceoutput_a_b(0);
            b <= debounceoutput_a_b(1);
        END IF;
    END PROCESS;
    zuef_p : PROCESS (current_state, a, b)
    BEGIN
        CASE current_state IS
            WHEN s00 =>
                IF a = '1' THEN
                    next_state <= s01;
                ELSIF b = '1' THEN
                    next_state <= s10;
                ELSE
                    next_state <= current_state;
                END IF;
            WHEN s01 =>
                IF a = '0' THEN
                    next_state <= s00;
                ELSIF b = '1' THEN
                    next_state <= s11;
                ELSE
                    next_state <= current_state;
                END IF;
            WHEN s11 =>
                IF a = '0' THEN
                    next_state <= s10;
                ELSIF b = '0' THEN
                    next_state <= s01;
                ELSE
                    next_state <= current_state;
                END IF;
            WHEN s10 =>
                IF a = '1' THEN
                    next_state <= s11;
                ELSIF b = '0' THEN
                    next_state <= s00;
                ELSE
                    next_state <= current_state;
                END IF;
            WHEN OTHERS =>
                next_state <= s00;
        END CASE;
    END PROCESS;

    speicher_p : PROCESS (clock_i)
    BEGIN
        IF rising_edge(clock_i) THEN
            prev_state <= current_state;
            current_state <= next_state;
        END IF;
    END PROCESS;

    af_p : PROCESS (current_state, prev_state, pos_i, clock_i)
    BEGIN

        IF rising_edge(clock_i) THEN
            IF current_state = s00 THEN
                IF prev_state = s10 AND pos_i < (screen_height - (racket_height) + 5 ) THEN
                    pos_i <= pos_i + racket_steps;
                ELSIF prev_state = s01 AND pos_i > 0 THEN
                    pos_i <= pos_i - racket_steps;
                ELSE
                    pos_i <= pos_i;
                END IF;
            ELSE
                pos_i <= pos_i;
            END IF;

            racket_y_pos_o <= STD_LOGIC_VECTOR(to_signed(pos_i, 10));
        END IF;

    END PROCESS;

    push_but_deb_o <= NOT push_but_s;
END Behavioral;