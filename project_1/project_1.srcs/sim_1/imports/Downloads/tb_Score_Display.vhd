LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_Score_Display IS
END tb_Score_Display;

ARCHITECTURE behavior OF tb_Score_Display IS 

    -- Komponentendeklaration für die zu testende Einheit (UUT)
    COMPONENT Score_Display
    GENERIC (score_max : INTEGER RANGE 0 TO 99 := 10);
    PORT(
        clock_i : IN std_logic;
        reset_i : IN std_logic;
        led_enable_i : IN std_logic;
        push_but1_deb_i : IN std_logic;
        push_but2_deb_i : IN std_logic;
        hit_wall_i : IN std_logic_vector (2 DOWNTO 0);
        seven_seg_leds_o : OUT std_logic_vector (6 DOWNTO 0);
        seven_seg_sel_o : OUT std_logic_vector (5 DOWNTO 0);
        game_over_o : OUT std_logic
    );
    END COMPONENT;
   
    -- Signale zur Verbindung mit der UUT
    signal clock_i : std_logic := '0';
    signal reset_i : std_logic := '0';
    signal led_enable_i : std_logic := '1';
    signal push_but1_deb_i : std_logic := '0';
    signal push_but2_deb_i : std_logic := '0';
    signal hit_wall_i : std_logic_vector(2 downto 0) := "000";
    signal seven_seg_leds_o : std_logic_vector(6 downto 0);
    signal seven_seg_sel_o : std_logic_vector(5 downto 0);
    signal game_over_o : std_logic;

    -- Definition der Taktperiode
    constant clock_period : time := 8 ns;
    
BEGIN

    -- Instanziierung der zu testenden Einheit (UUT)
    uut: Score_Display PORT MAP (
          clock_i => clock_i,
          reset_i => reset_i,
          led_enable_i => led_enable_i,
          push_but1_deb_i => push_but1_deb_i,
          push_but2_deb_i => push_but2_deb_i,
          hit_wall_i => hit_wall_i,
          seven_seg_leds_o => seven_seg_leds_o,
          seven_seg_sel_o => seven_seg_sel_o,
          game_over_o => game_over_o
        );

    -- Taktprozessdefinition
    clock_process :process
    begin
        clock_i <= '1';
        wait for clock_period;
        clock_i <= '0';
        wait for clock_period;
    end process;
    
    enable : process 
    begin 
        led_enable_i <= '1';
        wait for clock_period;
        led_enable_i <= '0';
        wait for 1ms;
    end process ;

    -- Stimulus-Prozess
    stim_proc: process
    begin		
    
        hit_wall_i <= "101"; -- Erhöhe den Spielstand des linken Spielers
        wait for clock_period;
        hit_wall_i <= "000"; 
        wait for 8ms;
        hit_wall_i <= "110"; -- Erhöhe den Spielstand des rechten Spielers
        wait for clock_period;
        hit_wall_i <= "000"; 
        wait for 8ms;
    end process;
    
    push_button : process
    begin
        wait for 180ms;
        push_but1_deb_i <= '1';
    end process;

END;
