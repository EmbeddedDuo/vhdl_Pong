--------------------------------------------------------------------------------
-- Title          : Pong Toplevel
-- Filename       : toplevel_pong.vhd
-- Project        : 6. �bungsblatt VHDL-Kurs (Pong-Spiel)
--------------------------------------------------------------------------------
-- Author         : Michael Kunz
-- Company        : Universit�t Kassel, FG Digitaltechnik
-- Date           : 21.06.2010
-- Language       : VHDL93
-- Synthesis      : No
-- Target Family  : ALL
-- Test Status    : !!! not released !!!
--------------------------------------------------------------------------------
-- Applicable Documents:
-- 
--
--------------------------------------------------------------------------------
-- Revision History:
-- Date        Version  Author   Description
-- 21.06.2010  1.0      MK       Created
-- 27.08.2013  1.1			MK			 MMCodec01 & Eliminating Component Declaration
--------------------------------------------------------------------------------
-- Description:
--
-- Dieses Modul stellt die Toplevel-Dom�ne f�r das Pong-Spiel dar, welches
-- von den Studierenden des VHDL-Kurses entwickelt werden soll. 
--
-- Es verbindet das Visualisierungsmodul mit dem Modul zur Ballbewegung und
-- Kollisionserkennung. Die fehlenden Eingaben der Module zur Schl�gerbewegung
-- werden hier exemplarisch (testweise) gesetzt.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.all;
 
ENTITY pong_top IS
	generic(
		game_enable_clocks: integer := 1680000);
	port( 
		clock 									: in  std_logic;
		reset 									: in  std_logic;
		
		-- Play Modus Selector
		slide_sw_i							    : in std_logic_vector(1 downto 0);
				  
		-- Controller Interface
		rot_enc1_i 							    : in  std_logic_vector(1 downto 0);
		push_button1_i 					        : in  std_logic;
		rot_enc2_i 							    : in  std_logic_vector(1 downto 0);
		push_button2_i 					        : in  std_logic;
		  
		-- Sound Interface
		--lrcout_o 								: out std_logic;
		--bclk_o 									: out std_logic;
		--sclk_o 									: out std_logic;
		--din_i 									: in 	std_logic;
		--dout_o 									: out std_logic;
		--sdout_o 								: out std_logic;
		--ncs_o 									: out std_logic;
		--mck_o 									: out std_logic;
		--lmode_o 									: out std_logic;

		-- Seven Segment Display
		nseven_seg_leds_o 			            : out std_logic_vector(6 downto 0);
		nseven_seg_sel_o 				        : out std_logic_vector(5 downto 0);

		-- VGA Controller
		h_sync_o, v_sync_o 			            : out  std_logic;
		red_o, green_o, blue_o	                : out  std_logic_vector (2 downto 0)

		-- leds
		--;nled_o         		 	: out  std_logic_vector (7 downto 0)
		);

END pong_top;
 
ARCHITECTURE behavior OF pong_top IS 
   
	signal racket_y_pos1, racket_y_pos1_player : std_logic_vector(9 downto 0);
	signal racket_y_pos2, racket_y_pos2_player : std_logic_vector(9 downto 0);
	signal ball_x : std_logic_vector(9 downto 0);
	signal ball_y : std_logic_vector(9 downto 0);
	signal hit_wall : std_logic_vector(2 downto 0);
	signal hit_racket_l : std_logic_vector(1 downto 0);
	signal hit_racket_r : std_logic_vector(1 downto 0);
	signal game_over	: std_logic;
	signal push_but_deb1, push_but_deb2 : std_logic;
	signal Npush_but_deb1, Npush_but_deb2 : std_logic;
	signal seven_seg_leds : std_logic_vector(6 downto 0);
	signal seven_seg_sel : std_logic_vector(5 downto 0);

	signal nreset : std_logic;
	signal game_enable : std_logic;
	signal vga_enable : std_logic;
	signal note_enable : std_logic;
	signal dds_enable : std_logic;
	signal led_enable : std_logic;
	signal nslide_sw : std_logic_vector(1 downto 0);

	signal leds : std_logic_vector (7 downto 0);
 
BEGIN

	clk_enable: entity work.clock_enable 
		generic map(
			game_enable_clocks => game_enable_clocks)
		port map (
			clock 				=> clock,
			reset 				=> nreset,
			vga_enable_o 	=> vga_enable,
			game_enable_o	=> game_enable,
			led_enable_o	=> led_enable,
			note_enable_o	=> note_enable,
			dds_enable_o	=> dds_enable
			);
	
	controller_interface1 : entity work.controller_interface
		generic map(
			clk_frequency_in_Hz => 50E6,
			debounce_time_in_us => 2000,
			racket_height 			 => 60,
			racket_steps 			 => 10,
			screen_height			 => 480)
		port map(
			clock_i				 => clock,	
			reset_i				 => nreset,
			rot_enc_i			 => rot_enc1_i,
			push_but_i		 => push_button1_i,
			push_but_deb_o => push_but_deb1,
			racket_y_pos_o => racket_y_pos1_player
			);
	
	controller_interface2 : entity work.controller_interface
		generic map(
			clk_frequency_in_Hz => 50E6,
			debounce_time_in_us => 2000,
			racket_height 			 => 60,
			racket_steps				 => 10,
			screen_height			 => 480)
		port map(
			clock_i				 => clock,	
			reset_i				 => nreset,
			rot_enc_i 		 => rot_enc2_i,
			push_but_i 		 => push_button2_i,
			push_but_deb_o => push_but_deb2,
			racket_y_pos_o => racket_y_pos2_player
			);

--racket_y_pos2_player <= ball_y;
--push_but_deb1 <= '0';
--racket_y_pos1 <= (others => '0');
--push_but_deb2 <= '0';
--racket_y_pos2 <= (others => '0');


	collision: entity work.collision_detection
		generic map(
			ball_length					=> 6,
			racket_length				=> 10,
			racket_height				=> 60,
			racket_left_space		=> 20,
			racket_right_space 	=> 610,
			screen_height 			=> 480)
		port map(
			clock_i 				=> clock,
			reset_i 				=> nreset,
			racket_y_pos1_i => racket_y_pos1,
			racket_y_pos2_i => racket_y_pos2,
			ball_x_i 		 	 	=> ball_x,
			ball_y_i 			 	=> ball_y,
			hit_wall_o 		 	=> hit_wall,
			hit_racket_l_o 	=> hit_racket_l,
			hit_racket_r_o 	=> hit_racket_r
			);


	motion: entity work.ball_motion
		generic map(
			ball_length					=> 6,
			racket_length				=> 10,
			racket_height				=> 60,
			racket_left_space		=> 20,
			racket_right_space 	=> 610,
			screen_height 			=> 480,
			speedup_racket			=> 2)
		port map(
			clock_i 				=> clock,
			reset_i 				=> nreset,
			game_enable_i		=> game_enable,
			push_but1_deb_i	=>	Npush_but_deb1,
			push_but2_deb_i =>	Npush_but_deb2,
			game_over_i			=>	game_over,
			hit_wall_i 		 	=> hit_wall,
			hit_racket_l_i 	=> hit_racket_l,
			hit_racket_r_i 	=> hit_racket_r,
			ball_x_o 			 	=> ball_x,
			ball_y_o 			 	=> ball_y
			);
	
		--ball_x <= "0000100000";
		--ball_y <= "0000100000";
 
	visualization: entity work.vga_controller
		generic map(
			ball_length				 =>  6,
			racket_length			 =>  10,
			racket_height			 =>  60,
			racket_left_space	 =>  20,
			racket_right_space =>  610,
			H_max							 =>  799,
			V_max							 =>  524)
		port map(
			clock_i 				=> clock,
			reset_i 				=> nreset,
			vga_enable_i 		=> vga_enable,
			racket_y_pos1_i => racket_y_pos1,
			racket_y_pos2_i => racket_y_pos2,
			ball_x_i 				=> ball_x,
			ball_y_i 				=> ball_y,
			h_sync_o 				=> h_sync_o,
			v_sync_o 				=> v_sync_o,
			red_o 					=> red_o,
			green_o 				=> green_o,
			blue_o 					=> blue_o
			);
		  
	--sound: entity work.sound_interface 
	--	port map(
	--		clock_i 			 => clock,
	--		reset_i 			 => nreset,
	--		note_enable_i	 => note_enable,
	--		dds_enable_i	 => dds_enable,
	--		hit_wall_i 		 => hit_wall,
  	--		hit_racket_l_i => hit_racket_l,
	--		hit_racket_r_i => hit_racket_r,
	--		game_over_i		 => game_over,
	--		lrcout_o 			 => lrcout_o,
	--		bclk_o 				 => bclk_o,
	--		sclk_o				 => sclk_o,
	--		--din_i					 => din_i,
	--		dout_o				 =>  dout_o,
	--		sdout_o				 => sdout_o,
	--		ncs_o					 => ncs_o,
	--		mck_o					 => mck_o,
	--		mode_o				 => mode_o
	--		);

	score_display_inst : entity work.score_display
		generic map(
			score_max => 15)
		port map(
			clock_i					 => clock,
			reset_i					 => nreset,
			hit_wall_i 			 => hit_wall,
			led_enable_i 		 => led_enable,
			push_but1_deb_i  => Npush_but_deb1,
			push_but2_deb_i  => Npush_but_deb2,
			seven_seg_leds_o => seven_seg_leds,
			seven_seg_sel_o  => seven_seg_sel,
			game_over_o 		 => game_over
			);
	
	--game_over <= '0';
	
	--nled_o(7) <= not game_over;
	--nled_o(6 downto 0) <=  not leds(6 downto 0);
	
	nseven_seg_leds_o <= not seven_seg_leds;
	nseven_seg_sel_o <= not seven_seg_sel;
	nslide_sw <= not slide_sw_i;


--	bar_y_pos1 <= CONV_STD_LOGIC_VECTOR(20,10);
--   bar_y_pos2 <= CONV_STD_LOGIC_VECTOR(300,10);

with nslide_sw(1) select
	racket_y_pos1 <= 	ball_y-14 when '1',
							racket_y_pos1_player when others;

with nslide_sw(0) select
	racket_y_pos2 <= 	ball_y-14 when '1',
							racket_y_pos2_player when others;
							
						  
	
	
	--racket_y_pos1 <= ball_y-14;
   --racket_y_pos2 <= ball_y-14;
--	game_over <= '0';
--	push_but_deb1 <= not nSw(0);
--	push_but_deb2 <= not nSw(1);

	
	nreset <= not reset;
	Npush_but_deb1 <= not push_but_deb1;
	Npush_but_deb2 <= not push_but_deb2;
--	Npush_but_deb1 <= push_but_deb1;
--	Npush_but_deb2 <= push_but_deb2;

--   ball_x 	 <= CONV_STD_LOGIC_VECTOR(640,10);
--   ball_y 	 <= CONV_STD_LOGIC_VECTOR(480,10);

END;
