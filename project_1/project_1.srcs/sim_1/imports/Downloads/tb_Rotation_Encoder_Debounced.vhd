LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_Rotation_Encoder_Debounced IS
END tb_Rotation_Encoder_Debounced;

ARCHITECTURE behavior OF tb_Rotation_Encoder_Debounced IS

    -- Komponentendeklaration für die zu testende Einheit (UUT)
    COMPONENT Rotation_Encoder_Debounced
        GENERIC (
            clk_frequency_in_Hz : INTEGER := 125_000_000;
            debounce_time_in_us : INTEGER := 2000
           -- active_low : BOOLEAN := true
        );
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            input : IN STD_LOGIC;
            debounce : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Testbench-Signale
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '1';
    SIGNAL input : STD_LOGIC := '0';
    SIGNAL debounce : STD_LOGIC;

    -- Definition der Taktperiode
    CONSTANT clk_period : TIME := 4 ns; 

BEGIN

    -- Instanziierung der zu testenden Einheit (UUT)
    uut : Rotation_Encoder_Debounced
    PORT MAP(
        clk => clk,
        rst => rst,
        input => input,
        debounce => debounce
    );

    -- Taktprozessdefinition
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    -- Stimulus-Prozess
    stim_proc : PROCESS
    BEGIN
        -- Halte den Reset-Zustand für 100 ns
        WAIT FOR 100 ns;
        rst <= '1';
        WAIT FOR 20 ns;
        rst <= '0';

        -- Simuliere Tastendruck mit Prellen (prellendes Signal)
        WAIT FOR 200 ns;

        input <= '1'; 
        WAIT FOR 200 ns;

        WAIT;
    END PROCESS;

END;
