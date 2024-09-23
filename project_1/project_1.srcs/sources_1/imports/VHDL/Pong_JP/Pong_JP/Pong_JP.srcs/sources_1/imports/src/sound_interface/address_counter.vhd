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
use ieee.numeric_std.all;

-- Entity

entity address_counter is
  port(note_clk_i : in std_logic;
       reset_i    : in std_logic;
       clear_i    : in std_logic;
       enable_i   : in std_logic;
		   address_o  : out std_logic_vector(7 downto 0) );
end address_counter;

-- Architecture

architecture address_counter_arch of address_counter is

  -- interne Transfersignale, Konstanten, Typdefinitionen
  signal counter : integer range 0 to 255;  
  
begin

  -- Zaehler
  count_address : process(note_clk_i, reset_i, clear_i)
  begin
    
    if (clear_i = '1') or (reset_i = '1') then -- Initialisierung/Reset (asynchron)
      counter <= 0;
    elsif rising_edge(note_clk_i) then         -- synchrones Registerverhalten
      if enable_i = '1' then                   -- Wenn Zaehler freigegeben, dann Address-Zaehler um 1 erhöhen
        if counter < 255 then                  -- Zaehlerbegrenzung auf 255 (max. Wert des 8bit-Ausgangsvektors)
          counter <= counter + 1;
        else
          counter <= 0;                        -- Wenn Zaehlerbegrenzung erreicht, dann Address-Zaehler zuruecksetzen
        end if;
      end if;
    end if;

  end process;

  -- Integer-Zaehlvariable auf Ausgangsvektor geben
  address_o <= std_logic_vector(to_unsigned(counter, 8));

end address_counter_arch;