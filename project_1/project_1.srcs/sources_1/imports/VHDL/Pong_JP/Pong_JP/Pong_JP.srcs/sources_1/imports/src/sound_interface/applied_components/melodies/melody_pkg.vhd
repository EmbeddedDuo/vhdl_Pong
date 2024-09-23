--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 


library IEEE;
use IEEE.STD_LOGIC_1164.all;

package melodie_constants_pkg is

  
-- Notennamen

	constant a_2	: std_logic_vector := "000000";
	constant ais_2	: std_logic_vector := "000001"; alias b_2		: std_logic_vector(5 downto 0) is ais_2;
	constant h_2	: std_logic_vector := "000010";
	constant c_1	: std_logic_vector := "000011";
	constant cis_1	: std_logic_vector := "000100"; alias des_1	: std_logic_vector(5 downto 0) is cis_1;
	constant d_1	: std_logic_vector := "000101";
	constant dis_1	: std_logic_vector := "000110"; alias es_1	: std_logic_vector(5 downto 0) is dis_1;
	constant e_1	: std_logic_vector := "000111";
	constant f_1	: std_logic_vector := "001000";
	constant fis_1	: std_logic_vector := "001001"; alias ges_1	: std_logic_vector(5 downto 0) is fis_1;
	constant g_1	: std_logic_vector := "001010";
	constant gis_1	: std_logic_vector := "001011"; alias as_1	: std_logic_vector(5 downto 0) is gis_1;
	constant a_1	: std_logic_vector := "001100";
	constant ais_1	: std_logic_vector := "001101"; alias b_1		: std_logic_vector(5 downto 0) is ais_1; 
	constant h_1	: std_logic_vector := "001110";
	constant c0		: std_logic_vector := "001111";                                         
	constant cis0	: std_logic_vector := "010000"; alias des0		: std_logic_vector(5 downto 0) is cis0;
	constant d0		: std_logic_vector := "010001";                                         
	constant dis0	: std_logic_vector := "010010"; alias es0		: std_logic_vector(5 downto 0) is dis0;
	constant e0		: std_logic_vector := "010011";                                         
	constant f0		: std_logic_vector := "010100";                                         
	constant fis0	: std_logic_vector := "010101"; alias ges0		: std_logic_vector(5 downto 0) is fis0;
	constant g0		: std_logic_vector := "010110";                                         
	constant gis0	: std_logic_vector := "010111"; alias as0		: std_logic_vector(5 downto 0) is gis0;
	constant a0		: std_logic_vector := "011000";                                         
	constant ais0	: std_logic_vector := "011001"; alias b0		: std_logic_vector(5 downto 0) is ais0;
	constant h0		: std_logic_vector := "011010";                                         
	constant c1		: std_logic_vector := "011011";                                         
	constant cis1	: std_logic_vector := "011100"; alias des1	: std_logic_vector(5 downto 0) is cis1;
	constant d1		: std_logic_vector := "011101";                                         
	constant dis1	: std_logic_vector := "011110"; alias es1		: std_logic_vector(5 downto 0) is dis1;
	constant e1		: std_logic_vector := "011111";                                         
	constant f1		: std_logic_vector := "100000";                                         
	constant fis1	: std_logic_vector := "100001"; alias ges1	: std_logic_vector(5 downto 0) is fis1;
	constant g1		: std_logic_vector := "100010";                                         
	constant gis1	: std_logic_vector := "100011"; alias as1		: std_logic_vector(5 downto 0) is gis1;
	constant a1		: std_logic_vector := "100100";                                         
	constant ais1	: std_logic_vector := "100101"; alias b1		: std_logic_vector(5 downto 0) is ais1;
	constant h1		: std_logic_vector := "100110";                                         
	constant c2		: std_logic_vector := "100111";                                         
	constant cis2	: std_logic_vector := "101000"; alias des2	: std_logic_vector(5 downto 0) is cis2;
	constant d2		: std_logic_vector := "101001";                                         
	constant dis2	: std_logic_vector := "101010"; alias es2		: std_logic_vector(5 downto 0) is dis2;
	constant e2		: std_logic_vector := "101011";                                         
	constant f2		: std_logic_vector := "101100";                                         
	constant fis2	: std_logic_vector := "101101"; alias ges2	: std_logic_vector(5 downto 0) is fis2;
	constant g2		: std_logic_vector := "101110";                                         
	constant gis2	: std_logic_vector := "101111"; alias as2		: std_logic_vector(5 downto 0) is gis2;
	constant a2		: std_logic_vector := "110000";                                         
	constant ais2	: std_logic_vector := "110001"; alias b2		: std_logic_vector(5 downto 0) is ais2;
	constant h2		: std_logic_vector := "110010";                                         
	constant c3		: std_logic_vector := "110011";                                         
	constant cis3	: std_logic_vector := "110100"; alias des3	: std_logic_vector(5 downto 0) is cis3;
	constant d3		: std_logic_vector := "110101";                                         
	constant dis3	: std_logic_vector := "110110"; alias es3		: std_logic_vector(5 downto 0) is dis3;
	constant e3		: std_logic_vector := "110111";                                         
	constant f3		: std_logic_vector := "111000";                                         
	constant fis3	: std_logic_vector := "111001"; alias ges3	: std_logic_vector(5 downto 0) is fis3;
	constant g3		: std_logic_vector := "111010";                                         
	constant gis3	: std_logic_vector := "111011"; alias as3		: std_logic_vector(5 downto 0) is gis3;
	constant a3		: std_logic_vector := "111100";                                         
	constant ais3	: std_logic_vector := "111101"; alias b3		: std_logic_vector(5 downto 0) is ais3;
	constant h3		: std_logic_vector := "111110";                                         
	constant	pause	: std_logic_vector := "111111";
	
	constant res	: std_logic_vector := "000000"; 

-- Notenwerte

	constant v		: std_logic_vector := "11";		-- viertel
	constant a		: std_logic_vector := "10";		-- achtel
	constant s		: std_logic_vector := "01";		-- sechzentel
	constant z		: std_logic_vector := "00";		-- zweiunddreissigstel

-- Dynamik

	constant o		: std_logic_vector := "00";		-- off
	constant p		: std_logic_vector := "01";		-- piano
	constant m		: std_logic_vector := "10";		-- mezzo
	constant f		: std_logic_vector := "11";		-- forte
	
-- Notenbefehl

	type note_type is
		record
			hoehe : std_logic_vector(5 downto 0);
			wert	: std_logic_vector(1 downto 0);
			vol	: std_logic_vector(1 downto 0);
		end record;
			
	type song_type is array(0 to 255) of note_type;

end melodie_constants_pkg;


package body melodie_constants_pkg is 
end melodie_constants_pkg;
