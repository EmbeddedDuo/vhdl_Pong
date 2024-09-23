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
use work.melodie_constants_pkg.all;

-- Entity

entity note_generator is
  generic(song : song_type);
  port(note_clk_i : in std_logic;
       reset_i    : in std_logic;
       clear_o    : out std_logic;
       note_o     : out std_logic_vector(5 downto 0);
       vol_o      : out std_logic_vector(1 downto 0) );
end note_generator;

-- Architecture

architecture note_generator_arch of note_generator is

  -- interne Transfersignale, Konstanten, Typdefinitionen
  signal clear    : std_logic;
  signal duration : std_logic_vector(1 downto 0);
  signal address  : std_logic_vector(7 downto 0);

begin

  -- Instanz Address-Generator
  ad_inst : entity work.address_generator
  port map(note_clk_i => note_clk_i,
           reset_i => reset_i,
           clear_i => clear,
           duration_i => duration,
           address_o => address);

  -- Instanz Melody-Table
  mt_inst : entity work.melody_table
  generic map(song)
  port map(address_i => address,
           clear_o => clear,
           note_o => note_o,
           vol_o => vol_o,
           duration_o => duration);

  -- Clear-Ausgang zuweisen
  clear_o <= clear;

end note_generator_arch;