--------------------------------------------------------------------------------
-- Title          : Pong Melodietabelle
-- Filename       : melody_table.vhd
-- Project        : 6. Übungsblatt VHDL-Kurs (Pong-Spiel)
--------------------------------------------------------------------------------
-- Author         : Michael Kunz
-- Company        : Universität Kassel, FG Digitaltechnik
-- Date           : 23.06.2010
-- Language       : VHDL93
-- Synthesis      : No
-- Target Family  : sound_interface.vhd
-- Test Status    : !!! not released !!!
--------------------------------------------------------------------------------
-- Applicable Documents:
-- 
--
--------------------------------------------------------------------------------
-- Revision History:
-- Date        Version  Author   Description
-- 23.06.2010  1.0      MK       Created
-- 18.08.2014	2.0		MK			Generic Song
--------------------------------------------------------------------------------
-- Description:
--
-- Dieses Modul stellt eine Tabelle mit der Melodie zur Soudausgabe des 
-- Pong-Spiels bereit, welches von den Studierenden des VHDL-Kurses entwickelt 
-- werden soll. 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.melodie_constants_pkg.all;
--use work.melodie.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity melody_table is
	GENERIC(
			song				: song_type);
   PORT( 
			address_i 		: in   STD_LOGIC_VECTOR (7 downto 0);
			clear_o			: out  std_logic;
         note_o 			: out  STD_LOGIC_VECTOR (5 downto 0);
			vol_o 			: out  STD_LOGIC_VECTOR (1 downto 0);
         duration_o 		: out  STD_LOGIC_VECTOR (1 downto 0)
		  );
end melody_table;

architecture Behavioral of melody_table is

	signal ton : note_type;

begin

-- CONCURRENT -----------------------------------------------------------------

	ton <= song(to_integer(unsigned(address_i)));
	
	note_o <= ton.hoehe;
	vol_o		<= ton.vol;
	duration_o <= ton.wert;

	clear_o <= '1' when (ton.hoehe = "000000" and ton.vol = "00" and ton.wert = "00") else '0';


end Behavioral;

