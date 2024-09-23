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

entity melody_player is
  generic(song : song_type);
  port(note_clk_i  : in std_logic;
       lrclk_i     : in std_logic;
       reset_i     : in std_logic;
       sample_en_i : in std_logic;
       clear_o     : out std_logic;
       audio_o     : out std_logic_vector(15 downto 0) );
end melody_player;

-- Architecture

architecture melody_player_arch of melody_player is

  -- interne Transfersignale, Konstanten, Typdefinitionen
  signal note : std_logic_vector(5 downto 0);
  signal vol  : std_logic_vector(1 downto 0);
  signal ftw  : std_logic_vector(31 downto 0);
  signal ampl : std_logic_vector(15 downto 0);

begin

  -- Instanz Note-Generator
  ng_inst : entity work.note_generator
  generic map(song)
  port map(note_clk_i => note_clk_i,
           reset_i => reset_i,
           clear_o => clear_o,
           note_o => note,
           vol_o => vol);

  -- Instanz Tuning-Table
  tt_inst : entity work.tuning_table
  port map(note_i => note,
           ftw_o => ftw);

  -- Instanz DDS
  dds_inst : entity work.dds
  port map(clock => lrclk_i,
           reset_i => reset_i,
           dds_enable_i => sample_en_i,
           ftw_i => ftw,
           ampl_o => ampl);

  -- Instanz Volume-Control
  vc_inst : entity work.vol_ctrl
  port map(clk_i => lrclk_i,
           reset_i => reset_i,
           dds_enable_i => sample_en_i,
           ampl_i => ampl,
           vol_i => vol,
           ampl_o => audio_o);

end melody_player_arch;