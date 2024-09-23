--------------------------------------------------
-- VHDL-Kurs SS 2014
-- Abschlussprojekt Pong
--
-- Komponente: Sound-Interface
--
-- Erstellt von: Martin Scharf, MatNr. 31211046
--
-- Datum: 21.08.2014
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- Entity

entity note_duration_fsm is
  port(note_clk_i : in std_logic;
       reset_i    : in std_logic;
       clear_i    : in std_logic;
		   duration_i : in std_logic_vector(1 downto 0);
       enable_o   : out std_logic );
end note_duration_fsm;

-- Architecture

architecture note_duration_fsm_arch of note_duration_fsm is

  -- interne Transfersignale, Konstanten, Typdefinitionen
  type state_t is (READ_DURATION, WAITCYC_1, WAITCYC_2, WAITCYC_3, WAITCYC_4, WAITCYC_5, WAITCYC_6, WAITCYC_7);
  signal state         : state_t;
  signal enable        : std_logic;
  signal duration_sync : std_logic_vector(1 downto 0);
  
begin

  -- Synchronisierung des Automaten-Eingangssignals zur Vermeidung von Fehlverhalten (Setup-/Hold-Zeiten Verletzung)
  sync_duration : process(note_clk_i, reset_i)
  begin

    if reset_i = '1' then
      duration_sync <= "00";
    elsif rising_edge(note_clk_i) then
      duration_sync <= duration_i;
    end if;

  end process;

  -- Mealy-Automat zur Steuerung der Notendauer (2-Prozess-Modell: Ausgabe des enable-Signals ohne Zwischenspeicherung/Verzoegerung)
  fsm_note_duration : process(note_clk_i, reset_i, clear_i)
  begin
    
    if (clear_i = '1') or (reset_i = '1') then -- Initialisierung/Reset (asynchron)
      state <= READ_DURATION;
    elsif rising_edge(note_clk_i) then         -- synchrones Register
      
      case state is
        
        when READ_DURATION =>       -- Zustand 1: Einlesen der aktuellen Notendauer
          if duration_sync = "00" then
            state <= READ_DURATION;
          else
            state <= WAITCYC_1;
          end if;

        when WAITCYC_1 =>           -- Zustand 2: Wartezyklus bzw. Ende Sechzehntel
          if duration_sync = "01" then
            state <= READ_DURATION;
          else
            state <= WAITCYC_2;
          end if;

        when WAITCYC_2 =>           -- Zustand 3: Wartezyklus
          state <= WAITCYC_3;
 
        when WAITCYC_3 =>           -- Zustand 4: Wartezyklus bzw. Ende Achtel
          if duration_sync = "10" then
            state <= READ_DURATION;
          else
            state <= WAITCYC_4;
         end if;

        when WAITCYC_4 =>           -- Zustand 5: Wartezyklus
          state <= WAITCYC_5;

        when WAITCYC_5 =>           -- Zustand 6: Wartezyklus
          state <= WAITCYC_6;
 
        when WAITCYC_6 =>           -- Zustand 7: Wartezyklus
          state <= WAITCYC_7;
 
        when WAITCYC_7 =>           -- Zustand 8: Ende Viertel
          state <= READ_DURATION;
 
      end case;

    end if;
  end process;
 
  -- Ausgabe-Prozess des Automaten
  fsm_note_output : process(state)
  begin
    
    case state is
        
      when READ_DURATION =>             -- Zustand 1: Einlesen der aktuellen Notendauer
        if duration_sync = "00" then
          enable <= '1';
        else
          enable <= '0';
        end if;

      when WAITCYC_1 =>                 -- Zustand 2: Wartezyklus bzw. Ende Sechzehntel
        if duration_sync = "01" then
          enable <= '1';
        else
          enable <= '0';
        end if;

      when WAITCYC_2 =>                 -- Zustand 3: Wartezyklus
         enable <= '0';

      when WAITCYC_3 =>                 -- Zustand 4: Wartezyklus bzw. Ende Achtel
        if duration_sync = "10" then
          enable <= '1';
        else
          enable <= '0';
        end if;

      when WAITCYC_4 =>                 -- Zustand 5: Wartezyklus
        enable <= '0';

      when WAITCYC_5 =>                 -- Zustand 6: Wartezyklus
        enable <= '0';

      when WAITCYC_6 =>                 -- Zustand 7: Wartezyklus
        enable <= '0';

      when WAITCYC_7 =>                 -- Zustand 8: Ende Viertel
        enable <= '1';

      end case;

  end process;
 

  -- Enable-Ausgang mit Prozess-Ausgang verknuepfen (Enable-Ausgang nur gemeinsam mit Clock auf 1)
  enable_o <= enable;

end note_duration_fsm_arch;