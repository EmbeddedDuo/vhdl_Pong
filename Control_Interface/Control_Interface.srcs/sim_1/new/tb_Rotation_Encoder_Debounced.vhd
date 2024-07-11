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
    PORT(
        clk : IN std_logic;
        rst : IN std_logic;
        input : IN std_logic;
        debounce : OUT std_logic
    );
    END COMPONENT;
    
    -- Testbench signals
    SIGNAL clk : std_logic := '0';
    SIGNAL rst : std_logic := '1';
    SIGNAL input : std_logic := '1';
    SIGNAL debounce : std_logic;
    
    -- Clock period definition
    CONSTANT clk_period : time := 8 ns; -- 125 MHz

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: Rotation_Encoder_Debounced
    PORT MAP (
          clk => clk,
          rst => rst,
          input => input,
          debounce => debounce
    );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    -- Stimulus process
    stim_proc: process
    begin		
        -- hold reset state for 100 ns
        wait for 100 ns;  
        rst <= '0';
        wait for 20 ns;
        rst <= '1';
        
        -- Simulate button press with bouncing (prellendes Signal)
        wait for 200 ns;
        input <= '0';
        wait for 5 ns;
        input <= '1';
        wait for 5 ns;
        input <= '0';
        wait for 5 ns;
        input <= '1';
        wait for 5 ns;
        input <= '0';
        wait for 100 ns;
        input <= '1';
        
        -- Another bouncing scenario
        wait for 500 ns;
        input <= '0';
        wait for 10 ns;
        input <= '1';
        wait for 10 ns;
        input <= '0';
        wait for 10 ns;
        input <= '1';
        wait for 10 ns;
        input <= '0';
        wait for 50 ns;
        input <= '1';
        
        -- End simulation
        wait for 500 ns;
        wait;
    end process;

END;
