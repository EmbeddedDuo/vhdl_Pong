--------------------------------------------------------------------------------
-- Title          : Pong Clock-Enable-Modul
-- Filename       : clock_enable.vhd
-- Project        : 6. �bungsblatt VHDL-Kurs (Pong-Spiel)
--------------------------------------------------------------------------------
-- Author         : Michael Kunz
-- Company        : Universit�t Kassel, FG Digitaltechnik
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
-- Dieses Modul erm�glicht die Synchronisation der Spielgeschwindigkeit sowie
-- der VGA-Frame Update-Rate f�r das Pong-Spiel, welches von den Studierenden 
-- des VHDL-Kurses entwickelt werden soll. 
--
-- Mittels eines Z�hlers wird ein Enable-Signal f�r den 25 MHz Takt des VGA-
-- Interfaces sowie ein 60 Hz Freigabesignal erzeugt. Letzteres entspricht
-- der Bildwiederholungsfrequenz und kann zur Steuerung des Spiels verwendet
-- werden.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_enable is
    generic(
      game_enable_clocks: integer := 1680000
      );
    Port ( clock 		: in   std_logic;
           reset 				: in   std_logic;
           vga_enable_o 	: out  std_logic;
           game_enable_o	: out  std_logic;
			  led_enable_o		: out  std_logic;
			  note_enable_o	: out  std_logic;
			  dds_enable_o	: out  std_logic);
end clock_enable;

architecture Behavioral of clock_enable is

	-- Spieletakt
	signal count : std_logic_vector(22 downto 0);
	signal count_dds : std_logic_vector(3 downto 0);
	signal count_note : std_logic_vector(21 downto 0);
	signal count_vga : std_logic_vector(3 downto 0);
  constant cnt_max : integer := 50000-1;
  signal count_led : integer range 0 to cnt_max;
	--signal step : std_logic_vector(20 downto 0);			-- Teilungsfaktor f�r Spieletakt
	signal game_enable, vga_enable, note_enable, dds_enable : std_logic;



begin

-------------------------------------------------------------------------------
-- PROCESS: CLOCK-ENABLE
-- Freigabesignale erzeugen
-------------------------------------------------------------------------------

clk_en : process (clock, reset)
begin
if (reset = '1') then
	count <= STD_LOGIC_VECTOR(TO_UNSIGNED(game_enable_clocks,23)); --CONV_STD_LOGIC_VECTOR(250000,18);
	game_enable <= '0';
elsif rising_edge(clock) then
	if (count = 0) then
		count <= STD_LOGIC_VECTOR(TO_UNSIGNED(game_enable_clocks,23));
		game_enable <= '1';
	else
		count <= count - 1;
		game_enable <= '0';
	end if;
end if;
end process; --gameclk

clk_vga : process(clock, reset)
begin

    if (reset = '1') then 
        count_vga <= x"3";
        vga_enable <= '0';
    elsif rising_edge(clock) then 
        if (count_vga = 0) then 
            count_vga <= x"3";
            vga_enable <= '1';
        else 
            count_vga <= count_vga - 1;
            vga_enable <= '0';
        end if; 
    end if; 

end process; 

dds_en : process (clock, reset)
begin
if (reset = '1') then
	count_dds <= x"A"; 
	dds_enable <= '0';
elsif rising_edge(clock) then
	if (count_dds = 0) then
		count_dds <= x"A";
		dds_enable <= '1';
	else
		count_dds <= count_dds - 1;
		dds_enable <= '0';
	end if;
end if;
end process; --gameclk

not_en : process (clock, reset)
begin
if (reset = '1') then
	count_note <= STD_LOGIC_VECTOR(TO_UNSIGNED(3125000,22)); 
	note_enable <= '0';
elsif rising_edge(clock) then
	if (count_note = 0) then
		count_note <= STD_LOGIC_VECTOR(TO_UNSIGNED(3125000,22));
		note_enable <= '1';
	else
		count_note <= count_note - 1;
		note_enable <= '0';
	end if;
end if;
end process; --gameclk

	enable_p : process(reset,clock)
	begin
	  if reset='1' then	
	    count_led <= 0;
       led_enable_o <= '0';
	  elsif clock'event and clock = '1' then	
       if count_led = cnt_max then
         led_enable_o <= '1';
         count_led <= 0;
	    else
         led_enable_o <= '0';
         count_led <= count_led + 1;
	    end if;
	  end if;
	end process;



-------------------------------------------------------------------------------
-- CONCURRENT: Ausgangssignale
-------------------------------------------------------------------------------

game_enable_o 	<= game_enable;
vga_enable_o	<= vga_enable;
note_enable_o	<= note_enable;
dds_enable_o	<= dds_enable;




end Behavioral;

