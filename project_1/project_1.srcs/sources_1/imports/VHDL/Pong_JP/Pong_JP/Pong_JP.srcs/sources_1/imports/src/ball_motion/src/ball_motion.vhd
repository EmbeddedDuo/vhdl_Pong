--------------------------------------------------------------------------------
-- Title          : Pong Ball Motion
-- Filename       : ball_motion.vhd
-- Project        : 6. Übungsblatt VHDL-Kurs (Pong-Spiel)
--------------------------------------------------------------------------------
-- Author         : Michael Kunz
-- Company        : Universität Kassel, FG Digitaltechnik
-- Date           : 21.06.2010
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
-- 21.06.2010  1.0      MK       Created
--------------------------------------------------------------------------------
-- Description:
--
-- Dieses Modul ermöglicht die Ballbewegung des Pong-Spieles, welches von den 
-- Studierenden des VHDL-Kurses entwickelt werden soll. 
--
-- Mittels eines Zustandsautomaten werden die Ballbewegungen und Winkeländerungen
-- gesetzt und ggf. entsprechende Steuersignale gesetzt. Die Geschwindigkeit der 
-- Ballbewegung wird mittels eines ladbaren Zählers gesteuert.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


--use work.pong_pkg.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ball_motion is

	 Generic (ball_length			: integer := 6;
				 racket_length			: integer := 10;
				 racket_height			: integer := 30;
				 racket_left_space	: integer := 20;
				 racket_right_space	: integer := 620;
				 screen_height			: integer := 480;
				 speedup_racket		: integer := 10
				 );

    Port ( clock_i 										: in   std_logic;
           reset_i 										: in   std_logic;
			  game_enable_i							: in	 std_logic;
			  
			  push_but1_deb_i, push_but2_deb_i 	: in	 std_logic;
			  game_over_i								: in	 std_logic;
			  
			  hit_wall_i 								: in   std_logic_vector (2 downto 0);
           hit_racket_l_i, hit_racket_r_i 	: in   std_logic_vector (1 downto 0);
			  
           ball_x_o, ball_y_o 					: out  std_logic_vector (9 downto 0)			  
           );
end ball_motion;

architecture Behavioral of ball_motion is

	-- FSM
	type state_type is (stop, move, collision_l, collision_r, out_lr, wall_t, wall_b);
	signal state : state_type;

	
	-- Ballbewegung
	signal delta_x, delta_y : std_logic_vector (9 downto 0);		-- Steigung
	signal ball_x, ball_y : std_logic_vector (9 downto 0);
	signal add_x, add_y : std_logic; 									-- Zählrichtungen
	signal restart, clearflag_wall, 
			 clearflag_left, clearflag_right : std_logic;							-- Neustart nach "Aus"
	
	-- Kollisionen
	signal tmp_hit_wall : std_logic_vector (2 downto 0);
   signal tmp_hit_racket_l, tmp_hit_racket_r : std_logic_vector (1 downto 0);

		
	-- Speed
	signal count_hits : std_logic_vector (3 downto 0);				-- Zähler Schläger
	signal speed : std_logic_vector (9 downto 0);					-- Addititon für Speed
	signal tmp_hit_racket : std_logic_vector (1 downto 0);		-- Zwischenspeicher zur Mehrfacherkennung



begin

-------------------------------------------------------------------------------
-- PROCESS: Hit-Flags
-------------------------------------------------------------------------------

catchhit_wall : process (clock_i, reset_i, clearflag_wall)

begin

if (reset_i = '1' or clearflag_wall = '1') then

	tmp_hit_wall <= (others => '0');
	
elsif rising_edge(clock_i) then

	if (hit_wall_i /= 0) then
		tmp_hit_wall <= hit_wall_i;
	end if; -- hits
end if; -- clk
end process; -- catchhits
	
catchhit_left : process (clock_i, reset_i, clearflag_left)

begin

if (reset_i = '1' or clearflag_left = '1') then

	tmp_hit_racket_l <= (others => '0');
	
elsif rising_edge(clock_i) then

	if (hit_racket_l_i /= 0) then
		tmp_hit_racket_l <= hit_racket_l_i;
	end if; -- hits
end if; -- clk
end process; -- catchhits

catchhit_right : process (clock_i, reset_i, clearflag_right)

begin

if (reset_i = '1' or clearflag_right = '1') then

	tmp_hit_racket_r <= (others => '0');
	
elsif rising_edge(clock_i) then

	if (hit_racket_r_i /= 0) then
		tmp_hit_racket_r <= hit_racket_r_i;
	end if; -- hits
end if; -- clk
end process; -- catchhits
		
	


-------------------------------------------------------------------------------
-- PROCESS: Ballbewegung
-------------------------------------------------------------------------------

ballmove : process (clock_i, reset_i, restart)

begin

if (reset_i = '1' or restart = '1') then

	ball_x 	 <= STD_LOGIC_VECTOR(TO_UNSIGNED(320,10)); -- CONV_STD_LOGIC_VECTOR(320,10);			-- Bildschirmmitte
   ball_y 	 <= STD_LOGIC_VECTOR(TO_UNSIGNED(240,10)); -- CONV_STD_LOGIC_VECTOR(240,10);
	
elsif rising_edge(clock_i) then

	if (game_enable_i = '1') then
	
		-- Berechne x-Position
		if (add_x = '0') then
			if (ball_x + delta_x + speed < racket_right_space + racket_length-1) then
				ball_x <= ball_x + delta_x + speed;							-- x nach rechts
			else
				ball_x <= STD_LOGIC_VECTOR(TO_UNSIGNED(racket_right_space-1,10));
			end if;
		else
			if (ball_x - delta_x - speed > racket_left_space-1) then
				ball_x <= ball_x - delta_x - speed;							-- x nach links
			else
				ball_x <= STD_LOGIC_VECTOR(TO_UNSIGNED(racket_left_space + racket_length-1,10));
			end if;
		end if;
		
		-- Berechne y-Position
		if (add_y = '0') then
			if (ball_y + delta_y + speed <= screen_height-1) then					-- Ergebnis <= unterer Bildrand?
				ball_y <= ball_y + delta_y + speed;						-- y nach unten
			else
				ball_y <= STD_LOGIC_VECTOR(TO_UNSIGNED(screen_height-1,10));
			end if;
		else
			if (ball_y > delta_y + speed) then							-- Ergebnis <= 0?
				ball_y <= ball_y - delta_y - speed;						-- y nach oben
			else
				ball_y <= (others => '0');
			end if;
		end if;
		
	end if; -- enable
end if; -- clk

end process; -- ballmove

-----------------------------------------------------------------------------
-- PROCESS: Speed-Up
-----------------------------------------------------------------------------
speedup: process(clock_i, reset_i, game_over_i)

begin

	if (reset_i = '1' or game_over_i = '1') then
	
		count_hits	<= (others => '0');
		speed <= (others => '0');
		
	elsif rising_edge(clock_i) then
	
		if (game_enable_i = '1') then
		
			tmp_hit_racket <= tmp_hit_racket_l or tmp_hit_racket_r;
	
			if (((tmp_hit_racket_l /= 0) or (tmp_hit_racket_r /= 0)) and
					tmp_hit_racket = 0) then
				if (count_hits >= speedup_racket) then
					count_hits 	<= (others => '0');
					speed 		<= speed + 1;
				else
					count_hits 	<= count_hits + 1;
				end if; -- count_hits
			end if; -- hit_racket

		end if; -- game_enable
		
	end if; -- clk

end process; -- speedup

-----------------------------------------------------------------------------
-- PROCESS: FSM Ballbewegung
-----------------------------------------------------------------------------

fsm: process(clock_i, reset_i)

begin

	if (reset_i = '1') then
		state <= stop;
		add_x <= '0';
		add_y <= '0';
		restart <= '0';
		clearflag_wall <= '0';
		clearflag_left <= '0';
		clearflag_right <= '0';
		delta_x 		<= STD_LOGIC_VECTOR(TO_UNSIGNED(4,10));
		delta_y 		<= STD_LOGIC_VECTOR(TO_UNSIGNED(1,10));
		
		--step <= STD_LOGIC_VECTOR(TO_UNSIGNED(840000,21)); --CONV_STD_LOGIC_VECTOR(250000,18);
		
	elsif rising_edge(clock_i) then
	
		if (game_enable_i = '1') then
	
		case state is
			
			-- Stop --------------------------------------------------------------
			when stop =>
				add_x <= '0';
				add_y <= '0';
				restart <= '1';
				clearflag_wall <= '1';
				clearflag_left <= '1';
				clearflag_right <= '1';
				delta_x 		<= STD_LOGIC_VECTOR(TO_UNSIGNED(4,10));
				delta_y 		<= STD_LOGIC_VECTOR(TO_UNSIGNED(1,10));
				
				if (push_but1_deb_i = '1' or push_but2_deb_i = '1') then
					state <= move;
				end if;
			
			-- Move --------------------------------------------------------------
			when move  =>
			
				restart <= '0';
				clearflag_wall <= '0';
				clearflag_left <= '0';
				clearflag_right <= '0';
				
				if (tmp_hit_racket_l /= 0) then 			-- Kollision mit linkem Schläger
					state <= collision_l;
				
				elsif (tmp_hit_racket_r /= 0) then 		-- Kollision mit rechtem Schläger
					state <= collision_r;
					
				elsif (tmp_hit_wall(2) = '1') then				-- Aus
					state <= out_lr;
					
				elsif (tmp_hit_wall = "010") then 				-- Kollision mit oberer Wand
					state <= wall_t;
				
				elsif (tmp_hit_wall = "001") then 				-- Kollision mit unterer Wand
					state <= wall_b;
				
				end if; -- Kollision
			
			-- Collision left ----------------------------------------------------
			when collision_l =>
				restart <= '0';
				clearflag_wall <= '0';
				clearflag_left <= '1';
				clearflag_right <= '0';
				
				add_x <= '0';
				if (tmp_hit_racket_l = "10") then				-- Abflachen
					if (delta_y + speed > 1) then						-- d_y nicht Null werden
						delta_x <= delta_x + 1;
						delta_y <= delta_y - 1;
					end if;
				elsif (tmp_hit_racket_l = "01") then			-- Anschneiden
					if (delta_x + speed > 1) then
						delta_x <= delta_x - 1;
						delta_y <= delta_y + 1;
					end if;
				elsif (tmp_hit_racket_l = "00") then
					state <= move;
				end if;
							
			-- Collision right ---------------------------------------------------
			when collision_r =>
				restart <= '0';
				clearflag_wall <= '0';
				clearflag_left <= '0';
				clearflag_right <= '1';

				add_x <= '1';
				if (tmp_hit_racket_r = "10") then				-- Abflachen
					if (delta_y + speed > 1) then						-- d_y nicht Null werden
						delta_x <= delta_x + 1;
						delta_y <= delta_y - 1;
					end if;
				elsif (tmp_hit_racket_r = "01") then			-- Anschneiden
					if (delta_x + speed > 1) then
						delta_x <= delta_x - 1;
						delta_y <= delta_y + 1;
					end if;
				elsif (tmp_hit_racket_r = "00") then
					state <= move;
				end if;
		
			-- Out left ----------------------------------------------------------
			when out_lr =>
				restart <= '1';
				clearflag_wall <= '1';
				clearflag_left <= '0';
				clearflag_right <= '0';
				
				if (push_but1_deb_i = '1' or push_but2_deb_i = '1') then
					state <= move;
				end if;
				
			-- Wall top ----------------------------------------------------------
			when wall_t =>
				restart <= '0';
				clearflag_wall <= '1';
				clearflag_left <= '0';
				clearflag_right <= '0';

				add_y <= '0';
				
				if (tmp_hit_wall /= "010") then
					state <= move;
				end if;
			-- Wall bottom -------------------------------------------------------
			when wall_b =>	
				restart <= '0';
				clearflag_wall <= '1';
				clearflag_left <= '0';
				clearflag_right <= '0';

				add_y <= '1';

				if (tmp_hit_wall /= "001") then
					state <= move;
				end if;
			-- Others ------------------------------------------------------------
			when others =>
				restart <= '1';
				clearflag_wall <= '1';
				clearflag_left <= '1';
				clearflag_right <= '1';
				state <= stop;
			
		end case; -- state
		
	end if; -- game_enable
	
	end if; -- clk

end process; -- fsm


-------------------------------------------------------------------------------
-- CONCURRENT: Ausgabe
-------------------------------------------------------------------------------

ball_x_o <= ball_x;
ball_y_o <= ball_y;

end Behavioral;

--		if (add_x = '0' and add_y = '1') then				-- x nach rechts, y nach oben
--			ball_x <= ball_x + delta_x;
--				
--				if(ball_y > delta_y) then
--					ball_y <= ball_y - delta_y;
--				else
--					ball_y <= (others => '0');
--				end if;
--		elsif (add_x = '1' and add_y = '1') then			-- x nach links, y nach oben
--			ball_x <= ball_x - delta_x;
--				if(ball_y > delta_y) then
--					ball_y <= ball_y - delta_y;
--				else
--					ball_y <= (others => '0');
--				end if;
--		elsif (add_x = '1' and add_y = '0') then			-- x nach links, y nach unten
--			ball_x <= ball_x - delta_x;
--			if (ball_y + delta_y <= 480) then
--				ball_y <= ball_y + delta_y;
--			else
--				ball_y <= STD_LOGIC_VECTOR(TO_UNSIGNED(480,10));
--			end if;
--		else															-- x nach rechts, y nach unten
--			ball_x <= ball_x + delta_x;
--			if (ball_y + delta_y <= 480) then
--				ball_y <= ball_y + delta_y;
--			else
--				ball_y <= STD_LOGIC_VECTOR(TO_UNSIGNED(480,10));
--			end if;
--		end if; -- Bewegungsrichtungen
