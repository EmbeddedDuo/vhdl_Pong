----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:55:53 12/17/2009 
-- Design Name: 
-- Module Name:    tuning_table - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.stimmung_lut_pkg.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tuning_table is
    Port ( note_i		: in STD_LOGIC_VECTOR (5 downto 0);
    			 --note0_i : in   STD_LOGIC;
           --note1_i : in   STD_LOGIC;
           --note2_i : in   STD_LOGIC;
           --note3_i : in   STD_LOGIC;
			  	 --note4_i : in   STD_LOGIC;
			  	 --note5_i : in   STD_LOGIC;
           ftw_o	 : out  STD_LOGIC_VECTOR (31 downto 0));
end tuning_table;

architecture Behavioral of tuning_table is

--signal note : std_logic_vector (5 downto 0);

begin

--	note(0) <= note0_i;
--	note(1) <= note1_i;
--	note(2) <= note2_i;
--	note(3) <= note3_i;
--	note(4) <= note4_i;
--	note(5) <= note5_i;

	ftw_o <= stimmung_lut(conv_integer(note_i));

end Behavioral;



