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
USE IEEE.numeric_std.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Controller_Interface IS
    GENERIC (
        clk_frequency_in_Hz : INTEGER := 125_000_0000;
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
        racket_y_pos_o : OUT std_logic_vector (9 DOWNTO 0)
        );
END Controller_Interface; 

ARCHITECTURE Behavioral OF Controller_Interface IS

    SIGNAL debounceoutput_a_b : STD_LOGIC_VECTOR (1 DOWNTO 0);
    Signal push_but_deb : STD_LOGIC := '0';
    SIGNAL pos_i : INTEGER := 209;

    TYPE state_type IS (clockwise, counterclockwise);
    SIGNAL current_state : state_type := clockwise; 
    SIGNAL next_state : state_type;
    SIGNAL a : STD_LOGIC := '0';
    SIGNAL b : STD_LOGIC := '0';
BEGIN

    g_debounce_signals : FOR i IN 0 TO rot_enc_i'length - 1 GENERATE
        debounce_signal : ENTITY work.Rotation_Encoder_Debounced
            GENERIC MAP(
                clk_frequency_in_Hz => clk_frequency_in_Hz,
                debounce_time_in_us => debounce_time_in_us,
                active_low => true 
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
        debounce_time_in_us => debounce_time_in_us,
        active_low => true 
    )
    PORT MAP(
        clk => clock_i,
        rst => reset_i,
        input => push_but_i,
        debounce => push_but_deb
    );

    zuef_p : PROCESS (current_state, debounceoutput_a_b) 

    BEGIN
        a <= debounceoutput_a_b(0);
        b <= debounceoutput_a_b(1);

        IF rising_edge(a) THEN
            IF b = '0' THEN
                IF current_state = counterclockwise THEN
                    next_state <= clockwise;
                END IF;
            ELSE
                IF current_state = clockwise THEN
                    next_state <= counterclockwise;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    speicher_p : PROCESS (clock_i)
    BEGIN
        IF reset_i = '1' THEN
            current_state <= clockwise;
        ELSIF clock_i' event AND clock_i = '1' THEN
            current_state <= next_state;
        END IF;
    END PROCESS;
 
    af_p : PROCESS (current_state)
    BEGIN
        CASE current_state IS
            WHEN clockwise =>
                if pos_i > 449 then
                     pos_i <= 449; 
                 else 
                     pos_i <= pos_i + racket_steps;
                 end if;
            WHEN counterclockwise =>
               if pos_i < 0 then
                     pos_i <= 0;
                 else 
                     pos_i <= pos_i - racket_steps;
                 end if;
            WHEN OTHERS =>
                pos_i <= pos_i;
        END CASE;
 
    END PROCESS;

    racket_y_pos_o <= std_logic_vector(to_unsigned(pos_i, 10));  
    push_but_deb_o <= push_but_deb;

END Behavioral;