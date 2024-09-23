--------------------------------------------------------------------------------
-- Title          : Pong Visualization-Modul
-- Filename       : vga_controller.vhd
-- Project        : 6. �bungsblatt VHDL-Kurs (Pong-Spiel)
--------------------------------------------------------------------------------
-- Author         : Michael Kunz
-- Company        : Universit�t Kassel, FG Digitaltechnik
-- Date           : 17.06.2010
-- Language       : VHDL93
-- Synthesis      : Yes
-- Target Family  : pong_top.vhd
-- Test Status    : OK
--------------------------------------------------------------------------------
-- Applicable Documents:
-- http://www.epanorama.net/documents/pc/vga_timing.html
--
--------------------------------------------------------------------------------
-- Revision History:
-- Date        Version  Author   Description
-- 17.06.2010  1.0      MK       Created
-- 01.07.2010	1.0a		MK			Anpassung Schnittstellen an Aufgabenbeschreibung
--------------------------------------------------------------------------------
-- Description:
--
-- Dieses Modul stellt das Visualisations-Modul des Pong-Spieles dar, welches
-- von den Studierenden des VHDL-Kurses entwickelt werden soll. Es basiert auf
-- der VGA-Testansteuerung der Fa. Propox f�r das Modul MMFPGA02.
--
-- Es werden die Positionen der Schl�ger (racket_y_pos1, racket_y_pos2) sowie des 
-- Balls (ball_x, ball_y) ausgewertet, die entsprechenden Pixel gesetzt und an
-- einen VGA-Monitor ausgegeben.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--use work.pong_pkg.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_controller is
	 Generic (ball_length			: integer := 6;
				 racket_length			: integer := 10;
				 racket_height			: integer := 30;
				 racket_left_space	: integer := 20;
				 racket_right_space	: integer := 620;
				 H_max					: integer := 799;
				 V_max					: integer := 524
				 );

    Port ( clock_i 						: in   std_logic;
           reset_i 						: in   std_logic;
			  vga_enable_i				: in	 std_logic;
			  
           racket_y_pos1_i, racket_y_pos2_i 	: in   std_logic_vector (9 downto 0);
           ball_x_i, ball_y_i 					: in   std_logic_vector (9 downto 0);
			  
           h_sync_o, v_sync_o 			: out  std_logic;
           red_o, green_o, blue_o 		: out  std_logic_vector (2 downto 0));
end vga_controller;

architecture Behavioral of vga_controller is

-- Bildfl�che 640 x 480 Pixel plus jeweils Synchronisationspixel
--constant H_max : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(799,10); -- # Pixel horizontal: 799
--constant V_max : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(524,10); -- # Pixel vertikal: 524

--signal video_clk  : std_logic;

signal video_out  : std_logic_vector(8 downto 0);
signal Hcnt, Vcnt	: std_logic_vector(9 downto 0);

begin

---------------------------------------------------------------------------------
---- PROCESS: VIDEO-CLOCK
---- Stellt einen 25 MHz Takt f�r die Video-Signale bereit
---------------------------------------------------------------------------------
--
--v_clk : process(clock,reset_i)
--
--begin
--
--if (reset_i = '1') then
--
--	video_clk <= '0';
--
--elsif rising_edge(clock) then
--
--	video_clk <= not video_clk;
--
--end if; -- clk
--
--end process; -- v_clk

-------------------------------------------------------------------------------
-- PROCESS: SYNCHRONIZATION
-- Generiert die Synchronisationssignale
-------------------------------------------------------------------------------

sync	: process(clock_i,reset_i)

begin

if (reset_i = '1') then

	Hcnt <= (others => '0');
	Vcnt <= (others => '0');
	h_sync_o <= '0';
	v_sync_o <= '0';

elsif rising_edge(clock_i) then

	if (vga_enable_i = '1') then

		-- z�hlen der Horizontalen Pixel (640 plus Synchronisationspixel)
		if (Hcnt >= H_max) then
			Hcnt <= (others => '0');
		else
			Hcnt <= Hcnt + "0000000001";
		end if;
		
		-- generieren des horizontalen Sync-Signals
		if (Hcnt <= 755) and (Hcnt >= 659) then
			h_sync_o <= '0';
		else
			h_sync_o <= '1';
		end if;
		
		-- z�hlen der Zeilen (480 pus Synchronisationszeilen)
		if (Vcnt >= V_max) and (Hcnt >= 699) then -- Feldende
			Vcnt <= (others => '0');
		else 
			if (Hcnt = 699) then
				Vcnt <= Vcnt + "0000000001";
			end if;
		end if;
		
		-- generieren des vertikalen Sync-Signals
		if (Vcnt <= 494) and (Vcnt >= 493) then
			v_sync_o <= '0';
		else
			v_sync_o <= '1';
		end if;
		
	end if; -- vga_enable

end if; -- clk

end process; -- sync

-------------------------------------------------------------------------------
-- TEST: BILDGENERIERUNG
-------------------------------------------------------------------------------

video_out <= "111111111" when (((Hcnt >= ball_x_i) and (Hcnt < ball_x_i + ball_length)) and
										((Vcnt >= ball_y_i) and (Vcnt < ball_y_i  + ball_length))) or
										(((Hcnt >= racket_left_space-1) and (Hcnt < racket_left_space + racket_length-1)) and
										((Vcnt >= racket_y_pos1_i) and (Vcnt < racket_y_pos1_i  + racket_height))) or
										(((Hcnt >= racket_right_space-1) and (Hcnt < racket_right_space + racket_length-1)) and
										((Vcnt >= racket_y_pos2_i) and (Vcnt < racket_y_pos2_i  + racket_height)))
								 else "000000000";

--(((Hcnt >= 20) and (Hcnt < 30)) and
--										((Vcnt >= 20) and (Vcnt < 30)))


-------------------------------------------------------------------------------
-- CONCURRENT: AUSGANGSSIGNALE
-------------------------------------------------------------------------------

red_o		<= video_out(8 downto 6);
green_o	<= video_out(5 downto 3);
blue_o	<= video_out(2 downto 0);

end Behavioral;

