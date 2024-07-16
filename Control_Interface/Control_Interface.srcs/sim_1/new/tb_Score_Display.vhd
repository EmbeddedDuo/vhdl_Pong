LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_Score_Display IS
END tb_Score_Display;

ARCHITECTURE behavior OF tb_Score_Display IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT Score_Display
    GENERIC (score_max : INTEGER RANGE 0 TO 99 := 10);
    PORT(
         clock_i : IN STD_LOGIC;
         reset_i : IN STD_LOGIC;
         led_enable_i : IN STD_LOGIC;
         push_but1_deb_i : IN STD_LOGIC;
         push_but2_deb_i : IN STD_LOGIC;
         hit_wall_i : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
         seven_seg_leds_o : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
         seven_seg_sel_o : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
         game_over_o : OUT STD_LOGIC
        );
    END COMPONENT;
    
    -- Inputs
    SIGNAL clock_i : STD_LOGIC := '0';
    SIGNAL reset_i : STD_LOGIC := '0';
    SIGNAL led_enable_i : STD_LOGIC := '0';
    SIGNAL push_but1_deb_i : STD_LOGIC := '0';
    SIGNAL push_but2_deb_i : STD_LOGIC := '0';
    SIGNAL hit_wall_i : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";

    -- Outputs
    SIGNAL seven_seg_leds_o : STD_LOGIC_VECTOR (6 DOWNTO 0);
    SIGNAL seven_seg_sel_o : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL game_over_o : STD_LOGIC;

    -- Clock period definition
    CONSTANT clock_period : TIME := 8ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: Score_Display
        GENERIC MAP (
            score_max => 10
        )
        PORT MAP (
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

    hit_wall_p : PROCESS
    BEGIN
            hit_wall_i <= "101";
            WAIT FOR clock_period;
            hit_wall_i <= "000";
            WAIT FOR clock_period;
            hit_wall_i <= "110";
            WAIT FOR clock_period;
    END PROCESS;

    -- Clock process definitions
    clock_process : PROCESS
    BEGIN
        clock_i <= '0';
        WAIT FOR  8ns;
        clock_i <= '1';
        WAIT FOR 8ns;
    END PROCESS;

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN	
    
        WAIT FOR 10 ms;	
        -- hold reset state for 100 ns.
        reset_i <= '1';
        WAIT FOR 10 ns;	
        reset_i <= '0';
        
        -- Initial state: No button press, no hits
        WAIT FOR 5 ns;
        push_but1_deb_i <= '1';
         push_but1_deb_i <= '1';
        
         WAIT FOR 5 ns;
        
 
        -- Continue simulation for player scores to reach the maximum score


--        -- Now the left player should reach max score and game should be over
--        hit_wall_i <= "101";
--        WAIT FOR clock_period;
--        hit_wall_i <= "000";
--        WAIT FOR clock_period;
        
--        -- Check if game over is asserted
--        ASSERT (game_over_o = '1')
--        REPORT "Game over not asserted as expected" SEVERITY ERROR;
        
--        -- Simulate a reset button press to restart the game
--        push_but1_deb_i <= '1';
--        WAIT FOR clock_period;
--        push_but1_deb_i <= '0';
        
--        -- Check if game has restarted
--        ASSERT (game_over_o = '0')
--        REPORT "Game did not restart as expected" SEVERITY ERROR;
        
        WAIT;
    END PROCESS;

END behavior;
