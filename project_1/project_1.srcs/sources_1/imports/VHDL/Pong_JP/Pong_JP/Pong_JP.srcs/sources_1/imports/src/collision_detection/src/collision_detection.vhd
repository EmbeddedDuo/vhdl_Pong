--------------------------------------------------------------------------------
-- Title          : Pong Collision Detection-Modul
-- Filename       : collision_detection.vhd
-- Project        : 6. Übungsblatt VHDL-Kurs (Pong-Spiel)
--------------------------------------------------------------------------------
-- Author         : Michael Kunz
-- Company        : Universität Kassel, FG Digitaltechnik
-- Date           : 22.06.2010
-- Language       : VHDL93
-- Synthesis      : No
-- Target Family  : toplevel_pong.vhd
-- Test Status    : !!! not released !!!
--------------------------------------------------------------------------------
-- Applicable Documents:
-- 
--
--------------------------------------------------------------------------------
-- Revision History:
-- Date        Version  Author   Description
-- 22.06.2010  1.0      MK       Created
--------------------------------------------------------------------------------
-- Description:
--
-- Dieses Modul ermöglicht die Kollisionserkennung des Pong-Spieles, welches von 
-- den Studierenden des VHDL-Kurses entwickelt werden soll. 
--
-- Mittels eines Zustandsautomaten werden die Positionen der Spielobjekte 
-- ausgewertet und Kollisionen erkannt welches entsprechende Steuersignale setzt.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--use work.pong_pkg.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity collision_detection is
	 Generic (ball_length			: integer := 6;
				 racket_length			: integer := 10;
				 racket_height			: integer := 30;
				 racket_left_space	: integer := 20;
				 racket_right_space	: integer := 620;
				 screen_height			: integer := 480
				 );

    Port ( clock_i 										: in   std_logic;
           reset_i 										: in   std_logic;
			  
           racket_y_pos1_i, racket_y_pos2_i	: in   std_logic_vector (9 downto 0);
           ball_x_i, ball_y_i 					: in   std_logic_vector (9 downto 0);
			  
           hit_wall_o 								: out  std_logic_vector (2 downto 0);
           hit_racket_l_o, hit_racket_r_o 	: out  std_logic_vector (1 downto 0));

end collision_detection;

architecture Behavioral of collision_detection is

	-- FSM
	type state_type is (stop, move, collision_l, collision_r, out_l, out_r, wall_t, wall_b);
	signal state : state_type;


begin

-----------------------------------------------------------------------------
-- PROCESS: FSM Kollisionsbehandlung
-----------------------------------------------------------------------------

fsm: process(clock_i, reset_i)

begin

	if (reset_i = '1') then
	
		hit_wall_o  	<= (others => '0');
		hit_racket_l_o	<= (others => '0');
		hit_racket_r_o	<= (others => '0');

		state <= stop;
		
	elsif rising_edge(clock_i) then
	
		case state is
			
			-- Stop --------------------------------------------------------------
			when stop =>
			
				hit_wall_o  	<= (others => '0');
				hit_racket_l_o	<= (others => '0');
				hit_racket_r_o	<= (others => '0');

				state <= move;
				
			-- Move --------------------------------------------------------------
			when move  =>
			
				hit_wall_o  	<= (others => '0');
				hit_racket_l_o	<= (others => '0');
				hit_racket_r_o	<= (others => '0');

				if ((ball_x_i <= racket_left_space + racket_length-1) and 			-- Kollision mit linkem Schläger
					 ((ball_y_i >= racket_y_pos1_i-1) and 
					  (ball_y_i <= racket_y_pos1_i + racket_height-1))) then		

					state <= collision_l;
					
					if ((ball_y_i >= racket_y_pos1_i) and (ball_y_i < racket_y_pos1_i + 12)) then				-- oben oben
						hit_racket_l_o	<= "01";
					elsif ((ball_y_i >= racket_y_pos1_i + 12) and (ball_y_i < racket_y_pos1_i + 24)) then	-- oben unten
						hit_racket_l_o	<= "10";
					elsif ((ball_y_i >= racket_y_pos1_i + 24) and (ball_y_i < racket_y_pos1_i + 36)) then	-- mitte
						hit_racket_l_o	<= "11";
					elsif ((ball_y_i >= racket_y_pos1_i + 36) and (ball_y_i < racket_y_pos1_i + 48)) then	-- unten oben
						hit_racket_l_o	<= "10";					
					else																										-- unten unten
						hit_racket_l_o	<= "01";
					end if;
					
				
				elsif ((ball_x_i + ball_length >= racket_right_space-1) and	-- Kollision mit rechtem Schläger
						 ((ball_y_i >= racket_y_pos2_i-1) and 
						  (ball_y_i <= racket_y_pos2_i + racket_height-1))) then 	
					
					state <= collision_r;

					if ((ball_y_i >= racket_y_pos1_i) and (ball_y_i < racket_y_pos1_i + 12)) then				-- oben oben
						hit_racket_r_o	<= "01";
					elsif ((ball_y_i >= racket_y_pos1_i + 12) and (ball_y_i < racket_y_pos1_i + 24)) then	-- oben unten
						hit_racket_r_o	<= "10";
					elsif ((ball_y_i >= racket_y_pos1_i + 24) and (ball_y_i < racket_y_pos1_i + 36)) then	-- mitte
						hit_racket_r_o	<= "11";
					elsif ((ball_y_i >= racket_y_pos1_i + 36) and (ball_y_i < racket_y_pos1_i + 48)) then	-- unten oben
						hit_racket_r_o	<= "10";					
					else																										-- unten unten
						hit_racket_r_o	<= "01";
					end if;

					
				elsif (ball_x_i < racket_left_space + racket_length-1) then		-- Aus links
					
					state 		<= out_l;
					hit_wall_o  <= "110";
					
				elsif (ball_x_i > racket_right_space-1)	then						-- Aus rechts

					state 		<= out_r;
					hit_wall_o  <= "101";
					
				
				elsif (ball_y_i <= 0) then 											-- Kollision mit oberer Wand
					
					state 		<= wall_t;
					hit_wall_o  <= "010";
				
				elsif (ball_y_i >= screen_height-1) then 										-- Kollision mit unterer Wand
					
					state <= wall_b;
					hit_wall_o  	<= "001";
				
				end if; -- Kollision
			
			-- Collision left ----------------------------------------------------
			when collision_l =>
			
				hit_wall_o  	<= (others => '0');
				hit_racket_l_o	<= (others => '0');
				hit_racket_r_o	<= (others => '0');
				
				if (ball_x_i > racket_left_space + racket_length-1) then
					state <= move;
				end if;

				
			-- Collision right ---------------------------------------------------
			when collision_r =>

				hit_wall_o  	<= (others => '0');
				hit_racket_l_o	<= (others => '0');
				hit_racket_r_o	<= (others => '0');
				
				if (ball_x_i + ball_length < racket_right_space-1) then
					state <= move;
				end if;

			-- Out left ----------------------------------------------------------
			when out_l =>

				hit_wall_o  	<= (others => '0');
				hit_racket_l_o	<= (others => '0');
				hit_racket_r_o	<= (others => '0');

				if (ball_x_i > racket_left_space + racket_length-1) then
					state <= move;
				end if;
			
			-- Out right ---------------------------------------------------------
			when out_r =>

				hit_wall_o  	<= (others => '0');
				hit_racket_l_o	<= (others => '0');
				hit_racket_r_o	<= (others => '0');

				if (ball_x_i < racket_right_space-1) then
					state <= move;
				end if;
			
			-- Wall top ----------------------------------------------------------
			when wall_t =>

				hit_wall_o  	<= (others => '0');
				hit_racket_l_o	<= (others => '0');
				hit_racket_r_o	<= (others => '0');


				if (ball_y_i > 0) then
					state <= move;
				end if;
			
			-- Wall bottom -------------------------------------------------------
			when wall_b =>			
				
				hit_wall_o  	<= (others => '0');
				hit_racket_l_o	<= (others => '0');
				hit_racket_r_o	<= (others => '0');

				if (ball_y_i < screen_height-1) then
					state <= move;
				end if;
			
			-- Others ------------------------------------------------------------
			when others =>			
				state <= stop;
			
		end case; -- state
		--end if; -- game_enable
	
	end if; -- clk

end process; -- fsm


end Behavioral;

