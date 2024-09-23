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

entity address_generator is
  port(note_clk_i : in std_logic;
       reset_i    : in std_logic;
       clear_i    : in std_logic;
       duration_i : in std_logic_vector(1 downto 0);
       address_o  : out std_logic_vector(7 downto 0) );
end address_generator;

-- Architecture

architecture address_generator_arch of address_generator is

  -- interne Transfersignale, Konstanten, Typdefinitionen
  signal enable : std_logic;

begin

  -- Instanz Notenlaengen-Automat
  nd_fsm_inst : entity work.note_duration_fsm
  port map(note_clk_i,
           reset_i,
           clear_i,
           duration_i,
           enable_o => enable);

  -- Instanz Adress-Zaehler
  ac_inst : entity work.address_counter
  port map(note_clk_i,
           reset_i,
           clear_i,
           enable_i => enable,
           address_o => address_o);

end address_generator_arch;