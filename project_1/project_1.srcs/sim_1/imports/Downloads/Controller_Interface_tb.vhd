----------------------------------------------------------------------------------
-- Firma: 
-- Ingenieur: 
-- 
-- Erstellungsdatum: 10.07.2024 11:40:41
-- Designname: 
-- Modulname: Controller_Interface_tb - Testbench
-- Projektname: 
-- Zielgeräte: 
-- Tool-Versionen: 
-- Beschreibung: Testbench für das Modul Controller_Interface
-- 
-- Abhängigkeiten: 
-- 
-- Revision:
-- Revision 0.01 - Datei erstellt
-- Zusätzliche Kommentare:
-- 
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Controller_Interface_tb IS
END Controller_Interface_tb;

ARCHITECTURE behavior OF Controller_Interface_tb IS 

    -- Komponentendeklaration für die zu testende Einheit (UUT)
    COMPONENT Controller_Interface
    GENERIC (
        clk_frequency_in_Hz : INTEGER := 125_000_000;
        racket_steps : INTEGER := 5;
        debounce_time_in_us : INTEGER := 2000;
        racket_height : INTEGER := 30;
        screen_height : INTEGER := 480
    );
    PORT(
        clock_i : IN STD_LOGIC;
        reset_i : IN STD_LOGIC;
        rot_enc_i : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        push_but_i : IN STD_LOGIC;
        push_but_deb_o : OUT STD_LOGIC;
        racket_y_pos_o : OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
       -- n_ssd_enable : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        -- n_ssd_data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
    END COMPONENT;
    
    -- Eingänge
    signal clock_i : STD_LOGIC := '0';
    signal reset_i : STD_LOGIC := '0';
    signal rot_enc_i : STD_LOGIC_VECTOR (1 DOWNTO 0) := (others => '0');
    signal push_but_i : STD_LOGIC := '0';

    -- Ausgänge
    signal push_but_deb_o : STD_LOGIC;
    signal racket_y_pos_o : STD_LOGIC_VECTOR (9 DOWNTO 0);
   --  signal n_ssd_enable : STD_LOGIC_VECTOR (7 DOWNTO 0);
    -- signal n_ssd_data : STD_LOGIC_VECTOR (7 DOWNTO 0);

    -- Definition der Taktperiode
    constant clk_period : time := 8 ns;

BEGIN

    -- Instanziierung der zu testenden Einheit (UUT)
    uut: Controller_Interface
    PORT MAP (
        clock_i => clock_i,
        reset_i => reset_i,
        rot_enc_i => rot_enc_i,
        push_but_i => push_but_i,
        push_but_deb_o => push_but_deb_o,
        racket_y_pos_o => racket_y_pos_o
       --  n_ssd_enable => n_ssd_enable,
        --  n_ssd_data => n_ssd_data
    );

    -- Taktprozessdefinition
    clock_process :process
    begin
        clock_i <= '0';
        wait for clk_period/2;
        clock_i <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus-Prozess
    stim_proc: process
    begin		
        -- Halte den Reset-Zustand für 100 ns.
        reset_i <= '1';
        wait for 100 ns;	
        reset_i <= '0';
        
        -- Stimulierung der Eingänge
        -- Simulation des Drehencoders
        wait for 2 ms;  -- 2000 µs Entprellzeit
        rot_enc_i <= "11";
        wait for 4 ms;  -- 2000 µs Entprellzeit
        rot_enc_i <= "10";
        wait for 4 ms;  -- 2000 µs Entprellzeit
        rot_enc_i <= "00";
        wait for 4 ms;  -- 2000 µs Entprellzeit
        rot_enc_i <= "01";
        wait for 4 ms;  -- 2000 µs Entprellzeit
        
        rot_enc_i <= "11";
        wait for 4 ms;  -- 2000 µs Entprellzeit
        rot_enc_i <= "10";
        wait for 4 ms;  -- 2000 µs Entprellzeit
        rot_enc_i <= "00";
        wait for 4 ms;  -- 2000 µs Entprellzeit
        rot_enc_i <= "01";
        wait for 4 ms;  -- 2000 µs Entprellzeit
        
        rot_enc_i <= "11";
        wait for 4 ms;  -- 2000 µs Entprellzeit
        rot_enc_i <= "10";
        wait for 4 ms;  -- 2000 µs Entprellzeit
        rot_enc_i <= "00";
        wait for 4 ms;  -- 2000 µs Entprellzeit
        rot_enc_i <= "01";
        wait for 4 ms;  -- 2000 µs Entprellzeit
        
        -- Simulation des Druckknopfs
        push_but_i <= '1';
        wait for 2 ms;  -- 2000 µs Entprellzeit
        push_but_i <= '0';
        wait for 2 ms;  -- 2000 µs Entprellzeit

        -- Fügen Sie hier weitere Stimuli hinzu, um die UUT gründlich zu testen

        -- Simulation beenden
        wait;
    end process;

END;
