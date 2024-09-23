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
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
        SIGNAL player_left_score_first_digit : INTEGER RANGE 0 TO 9 := 0;
        SIGNAL player_right_score_first_digit : INTEGER RANGE 0 TO 9 := 0;
        SIGNAL player_left_score_second_digit : INTEGER RANGE 0 TO 9 := 0;
        SIGNAL player_right_score_second_digit : INTEGER RANGE 0 TO 9 := 0;
        SIGNAL current_number_to_display : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
        SIGNAL seg_sel : STD_LOGIC_VECTOR (5 DOWNTO 0) := "000001";
begin



    select_display: PROCESS(led_enable_i, seg_sel)
    begin
        if reset_i = '1' then
            seg_sel <= "000001";
        elsif rising_edge(led_enable_i) then
            if seg_sel = "100000" THEN
                seg_sel <= "000001";
            ELSE
                seg_sel <= std_logic_vector(shift_left(unsigned(seg_sel), 1));
            END IF;
        END IF;
        seven_seg_sel_o <= seg_sel;
    END PROCESS;
    
    calc_digits: PROCESS(clock_i, reset_i)
    begin
        if reset_i = '1' then
            player_left_score_first_digit <= 0;
            player_right_score_first_digit <= 0;
            player_left_score_second_digit <= 0;
            player_right_score_second_digit <= 0;
        elsif rising_edge(clock_i) then
            player_left_score_first_digit <= player_left_score_i mod 10;
            player_right_score_first_digit <= player_right_score_i mod 10;
            player_left_score_second_digit <= (player_left_score_i / 10) mod 10;
            player_right_score_second_digit <= (player_right_score_i / 10) mod 10;
        end if;
    END PROCESS;
    
    -- process for printing numbers, defines number to display depending on current display
    print_numbers: PROCESS(clock_i, seg_sel)
        begin
        if rising_edge(clock_i) then
                CASE seg_sel is
                    when "000001" =>
                        current_number_to_display <= std_logic_vector(TO_UNSIGNED(player_right_score_first_digit ,4));
                    when "000010" =>
                        current_number_to_display <= std_logic_vector(TO_UNSIGNED(player_right_score_second_digit ,4));
                    when "000100" =>
                        current_number_to_display <= "1010"; -- say to bcd_encoder to make seperator line
                    when "001000" =>
                        current_number_to_display <= "1010"; -- say to bcd_encoder to make seperator line
                    when "010000" =>
                        current_number_to_display <= std_logic_vector(TO_UNSIGNED(player_left_score_first_digit ,4));
                    when "100000" =>
                        current_number_to_display <= std_logic_vector(TO_UNSIGNED(player_left_score_second_digit ,4));
                    when OTHERS =>
                        current_number_to_display <= "0000";
                END CASE;
            END IF;
    END PROCESS;
    
    bcd_Decoder_Ins : ENTITY work.BCD_Decoder
        PORT MAP(
            bcd_in => current_number_to_display, 
            segment_out => seven_seg_leds_o
    );

end Behavioral;
