 library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ConstantsHit.all;

-- ball-motion and -collision-testmodule for pong-game, vhdl-lecture uni-kassel ss2011
-- (c) moenia@student.uni-kassel.de
-- licence: CC BY-NC-SA (http://creativecommons.org/licenses)
-- version 20110907-1

entity pong_tb is
end pong_tb;

architecture bench of pong_tb is


 
 component pong_top
    generic(
      game_enable_clocks: integer := 840000
      );
    Port ( clock 							: in   std_logic;
           reset 							: in   std_logic;
			  
			  -- Controller Interface
			  rot_enc1_i 					: in  std_logic_vector(1 downto 0);
			  push_button1_i 				: in std_logic;
		     rot_enc2_i 					: in  std_logic_vector(1 downto 0);
			  push_button2_i 				: in std_logic;
			  
           -- Sound Interface
			  dac_o							: out  std_logic_vector (7 downto 0);
			  
			  -- Seven Segment Display
			  nseven_seg_leds_o 			: out std_logic_vector(6 downto 0);
			  nseven_seg_sel_o 			: out std_logic_vector(5 downto 0);

			  
			  -- VGA Controller
			  h_sync_o, v_sync_o 		: out  std_logic;
           red_o, green_o, blue_o	: out  std_logic_vector (2 downto 0);

			  -- leds
			  nled_o          : out  std_logic_vector (7 downto 0)

           );

END component;

signal clock : std_logic := '0';
signal nreset : std_logic;

begin
  
  clock <= not clock after 10 ns;
  nreset <= '0', '1' after 50 ns;
  
   pong: pong_top
    generic map(
      game_enable_clocks => 840000
      )
    Port map ( clock => clock,
           reset => nreset,
			  
			  -- Controller Interface
			  rot_enc1_i => "00",
			  push_button1_i => '1',
		     rot_enc2_i => "00",
			  push_button2_i => '1',
			  
           -- Sound Interface
			  dac_o => open,
			  
			  -- Seven Segment Display
			  nseven_seg_leds_o => open,
			  nseven_seg_sel_o  => open,

			  
			  -- VGA Controller
			  h_sync_o  => open,
			  v_sync_o 	=> open,
        red_o  => open,
        green_o  => open,
        blue_o  => open,

			  -- leds
			  nled_o => open

           );

  
end bench;