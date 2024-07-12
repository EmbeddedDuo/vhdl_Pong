LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_Rotation_Encoder_Debounced IS
END tb_Rotation_Encoder_Debounced;

ARCHITECTURE behavior OF tb_Rotation_Encoder_Debounced IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT Rotation_Encoder_Debounced
        GENERIC (
            clk_frequency_in_Hz : INTEGER := 125_000_000;
            debounce_time_in_us : INTEGER := 2000;
            active_low : BOOLEAN := true
        );
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            input : IN STD_LOGIC;
            debounce : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Testbench signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '1';
    SIGNAL input : STD_LOGIC := '0';
    SIGNAL debounce : STD_LOGIC;

    -- Clock period definition
    CONSTANT clk_period : TIME := 4 ns; 

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut : Rotation_Encoder_Debounced
    PORT MAP(
        clk => clk,
        rst => rst,
        input => input,
        debounce => debounce
    );

    -- Clock process definitions
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- hold reset state for 100 ns
        WAIT FOR 100 ns;
        rst <= '1';
        WAIT FOR 20 ns;
        rst <= '0';

        -- Simulate button press with bouncing (prellendes Signal)
        WAIT FOR 200 ns;

        input <= '1'; 
        WAIT FOR 200 ns;

        WAIT;
    END PROCESS;

END;