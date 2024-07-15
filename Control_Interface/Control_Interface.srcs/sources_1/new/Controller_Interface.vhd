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
        racket_y_pos_o : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        n_ssd_enable : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        n_ssd_data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
END Controller_Interface;

ARCHITECTURE Behavioral OF Controller_Interface IS

    SIGNAL debounceoutput_a_b : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL push_but_deb : STD_LOGIC := '0';
    SIGNAL pos_i : INTEGER := 5;
    SIGNAL pos_s : STD_LOGIC_VECTOR(3 DOWNTO 0);

    TYPE state_type IS (s00, s01, s11, s10);
    SIGNAL current_state : state_type := s00;
    SIGNAL next_state : state_type;
    SIGNAL prev_state : state_type := s00;
    SIGNAL a : STD_LOGIC := '0';
    SIGNAL b : STD_LOGIC := '0';

BEGIN

    n_ssd_enable <= "11111110";

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
    debounce_signal : ENTITY work.Rotation_Encoder_Debounced
        GENERIC MAP(
            clk_frequency_in_Hz => clk_frequency_in_Hz,
            debounce_time_in_us => debounce_time_in_us
        )
        PORT MAP(
            clk => clock_i,
            rst => reset_i,
            input => push_but_i,
            debounce => push_but_deb
        );
        
    sync: process(clock_i)
    begin
        if rising_edge(clock_i) then
            a <= debounceoutput_a_b(0);
            b <= debounceoutput_a_b(1);
        end if;
    end process;
    

    zuef_p : PROCESS (current_state)
    BEGIN
        case current_state is
            when s00 =>
                if a = '1' then
                    next_state <= s01;
                elsif b = '1' then
                    next_state <= s10;
                else
                    next_state <= current_state;
                end if;
            when s01 =>
                if a = '0' then
                    next_state <= s00;
                elsif b = '1' then
                    next_state <= s11;
                else
                    next_state <= current_state;
                end if;
            when s11 =>
                if a = '0' then
                    next_state <= s10;
                elsif b = '0' then
                    next_state <= s01;
                else
                    next_state <= current_state;
                end if;
            when s10 =>
                if a = '1' then
                    next_state <= s11;
                elsif b = '0' then
                    next_state <= s00;
                else
                    next_state <= current_state;
                end if;
        end case;
    END PROCESS;
    


    speicher_p : PROCESS (clock_i)
    BEGIN
        IF rising_edge(clock_i) THEN
            prev_state <= current_state;
            current_state <= next_state;
        END IF;
    END PROCESS;

    af_p : PROCESS (current_state)
    BEGIN
        if current_state = s00 then
            if prev_state = s10 then
                if pos_i <= 9 then
                    pos_i <= pos_i + 1;
                else
                    pos_i <= 9;
                end if;
            elsif prev_state = s01 then
                if pos_i >= 0 then
                    pos_i <= pos_i - 1;
                else
                    pos_i <= 0;
                end if;
            end if;
        end if;
        
    END PROCESS;
    
    pos_s <= std_logic_vector(to_signed(pos_i, 4));
    
    bcd_Decoder_Ins : ENTITY work.BCD_Decoder
        PORT MAP(
            bcd_in => pos_s, 
            segment_out => n_ssd_data
        );

    racket_y_pos_o(1 DOWNTO 0) <= rot_enc_i;
    racket_y_pos_o(3 DOWNTO 2) <= debounceoutput_a_b;
    racket_y_pos_o(6 DOWNTO 4) <= "111";
    push_but_deb_o <= NOT push_but_deb;

END Behavioral;
