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
use work.melodie_constants_pkg.all;
use work.melodie.all;

-- Entity

entity sound_interface is
  port(clock_i        : in std_logic;
       reset_i        : in std_logic;
       dds_enable_i   : in std_logic;
       note_enable_i  : in std_logic;
       hit_wall_i     : in std_logic_vector(2 downto 0);
       hit_racket_l_i : in std_logic_vector(1 downto 0);
       hit_racket_r_i : in std_logic_vector(1 downto 0);
       game_over_i    : in std_logic;
       dout_o         : out std_logic;
       lrcout_o       : out std_logic;
       bclk_o         : out std_logic;
       sclk_o         : out std_logic;
       sdout_o        : out std_logic;
       ncs_o          : out std_logic;
       mode_o         : out std_logic;
       mck_o          : out std_logic );
end sound_interface;

-- Architecture

architecture sound_interface_arch of sound_interface is

  -- interne Transfersignale, Konstanten, Typdefinitionen
  signal mclk        : std_logic;
  signal mclk_en     : std_logic; -- Audio Clock Generator, einseitig belegt
  signal bclk        : std_logic;
  signal bclk_en     : std_logic;
  signal lrclk       : std_logic;
  signal sample_en   : std_logic;
  signal note_clk    : std_logic;
  signal note_clk_en : std_logic; -- Audio Clock Generator, einseitig belegt
  signal din         : std_logic; -- mmCodec01, einseitig belegt
 
  -- Steuerung und Ausgaenge Melody-Player
  signal audio_temp   : std_logic_vector(19 downto 0);
  signal audio_sum    : std_logic_vector(15 downto 0);
  signal audio_hw     : std_logic_vector(15 downto 0);
  signal audio_hr     : std_logic_vector(15 downto 0);
  signal audio_ho     : std_logic_vector(15 downto 0);
  signal audio_bg     : std_logic_vector(15 downto 0);
  signal audio_go     : std_logic_vector(15 downto 0);
  signal clear_hw     : std_logic;
  signal clear_hr     : std_logic;
  signal clear_ho     : std_logic;
  signal clear_bg     : std_logic;
  signal clear_go     : std_logic;
  signal sample_en_hw : std_logic;
  signal sample_en_hr : std_logic;
  signal sample_en_ho : std_logic;
  signal sample_en_bg : std_logic;
  signal sample_en_go : std_logic;
  signal play_hw      : std_logic;
  signal play_hr      : std_logic;
  signal play_ho      : std_logic;
  signal play_bg      : std_logic;
  signal play_go      : std_logic;

begin

  -- Ansteuerung Melody-Player
  mp_control : process(clock_i,
                       reset_i, 
                       hit_wall_i, 
                       hit_racket_l_i, 
                       hit_racket_r_i, 
                       game_over_i, 
                       clear_hw, 
                       clear_hr, 
                       clear_ho, 
                       clear_bg,
                       clear_go )
  begin

    if reset_i = '1' then           -- Initialisierung/Reset (asynchron)
      play_hw <= '0';
      play_hr <= '0';
      play_ho <= '0';
      play_bg <= '1';
      play_go <= '0';
    elsif rising_edge(clock_i) then -- synchrones Register

      -- Zuruecksetzen der Abspielfreigabe nach einmaligen Abspielen (Hintergrundmusik ausgenommen)
      if clear_hw = '1' then    -- wenn hit_wall Sound einmalig abgespielt
        play_hw <= '0';         -- Abspielen stoppen
      elsif clear_hr = '1' then -- wenn hit_racket Sound einmalig abgespielt
        play_hr <= '0';         -- Abspielen stoppen
      elsif clear_ho = '1' then -- wenn hit_out Sound einmalig abgespielt
        play_ho <= '0';         -- Abspielen stoppen
      elsif clear_bg = '1' then -- wenn background_melody abgespielt
        play_bg <= '1';         -- Abspielen fortsetzen/wiederholen
      elsif clear_go = '1' then -- wenn game_over Sound abgespielt
        play_go <= '0';         -- Abspielen stoppen
      else

        -- Auswertung hit_wall
        if (hit_wall_i = "001") or (hit_wall_i ="010") then     -- wenn Wand oben oder unten getroffen
          play_hw <= '1';                                       -- hit_wall Sound abspielen
        elsif (hit_wall_i = "101") or (hit_wall_i = "110") then -- wenn Ball im Aus
          play_ho <= '1';                                       -- hit_out Sound abspielen
        end if;                                                 -- (unvollstaendige Definition; speicherndes Verhalten)

        -- Auswertung hit_racket
        if (hit_racket_l_i /= "00") or (hit_racket_r_i /= "00") then -- wenn Schlaeger getroffen
          play_hr <= '1';                                            -- hit_racket Sound abspielen
        end if;                                                      -- (unvollstaendige Definition; speicherndes Verhalten)

        -- Auswertung game_over
        if game_over_i = '1' then -- wenn max. Spielstand erreicht
          play_bg <= '0';         -- Hintergrundmusik stoppen
          play_go <= '1';         -- game_over Sound abspielen
        end if;                   -- (unvollstaendige Definition; speicherndes Verhalten)

      end if;

    end if;

  end process;

  -- Abspielfreigaben auf sample_enable der Melody-Player anwenden
  sample_en_hw <= sample_en and play_hw;
  sample_en_hr <= sample_en and play_hr;
  sample_en_ho <= sample_en and play_ho;
  sample_en_bg <= sample_en and play_bg;
  sample_en_go <= sample_en and play_go;

  -- Audio-Ausgaenge der Melody-Player summieren (4 Additions-Operationen -> 4bit erweitern) und normieren (niederwertige Bits abschneiden)
  audio_temp <= std_logic_vector(unsigned("0000" & audio_hw) +
                                 unsigned("0000" & audio_hr) + 
                                 unsigned("0000" & audio_ho) + 
                                 unsigned("0000" & audio_bg) + 
                                 unsigned("0000" & audio_go) );
  audio_sum <= audio_temp(19 downto 4);

  -- Instanz Audio-Clock-Generator
  acg_inst : entity work.audio_clk_gen
  port map(clk_i => clock_i,
           rst_i => reset_i,
           mclk_o => mclk,
           mclk_en_o => mclk_en,
           bclk_o => bclk,
           bclk_en_o => bclk_en,
           lrcout_o => lrclk,
           sample_en_o => sample_en,
           note_clk_o => note_clk,
           note_clk_en_o => note_clk_en);

  -- Instanz D/A-Wandler (mmCodec01)
  da_mmc_inst : entity work.mmCodec01
  port map(clk_i => clock_i,
           rst_i => reset_i,
           din_i => din,
           mclk_i => mclk,
           bclk_i => bclk,
           lrclk_i => lrclk,
           bclk_en_i => bclk_en,
           audio_i => audio_sum,
           sample_en_i => sample_en,
           dout_o => dout_o,
           lrcout_o => lrcout_o,
           bclk_o => bclk_o,
           sclk_o => sclk_o,
           sdout_o => sdout_o,
           ncs_o => ncs_o,
           mode_o => mode_o,
           mck_o => mck_o);

  -- Instanz Melody-Player hit_wall
  mp_hw_inst : entity work.melody_player
  generic map(song => hit_wall)
  port map(note_clk_i => note_clk,
           lrclk_i => clock_i,          -- DDS/VolCtrl laeuft nur mit Haupttakt an dieser Stelle
           reset_i => reset_i,
           sample_en_i => sample_en_hw,
           clear_o => clear_hw,
           audio_o => audio_hw);

  -- Instanz Melody-Player hit_racket
  mp_hr_inst : entity work.melody_player
  generic map(song => hit_racket)
  port map(note_clk_i => note_clk,
           lrclk_i => clock_i,          -- DDS/VolCtrl laeuft nur mit Haupttakt an dieser Stelle
           reset_i => reset_i,
           sample_en_i => sample_en_hr,
           clear_o => clear_hr,
           audio_o => audio_hr);

  -- Instanz Melody-Player hit_out
  mp_ho_inst : entity work.melody_player
  generic map(song => hit_out)
  port map(note_clk_i => note_clk,
           lrclk_i => clock_i,          -- DDS/VolCtrl laeuft nur mit Haupttakt an dieser Stelle
           reset_i => reset_i,
           sample_en_i => sample_en_ho,
           clear_o => clear_ho,
           audio_o => audio_ho);

  -- Instanz Melody-Player background_melody
  mp_bg_inst : entity work.melody_player
  generic map(song => background_melody)
  port map(note_clk_i => note_clk,
           lrclk_i => clock_i,          -- DDS/VolCtrl laeuft nur mit Haupttakt an dieser Stelle
           reset_i => reset_i,
           sample_en_i => sample_en_bg,
           clear_o => clear_bg,
           audio_o => audio_bg);

  -- Instanz Melody-Player game_over
  mp_go_inst : entity work.melody_player
  generic map(song => looser)
  port map(note_clk_i => note_clk,
           lrclk_i => clock_i,          -- DDS/VolCtrl laeuft nur mit Haupttakt an dieser Stelle
           reset_i => reset_i,
           sample_en_i => sample_en_go,
           clear_o => clear_go,
           audio_o => audio_go);

end sound_interface_arch;