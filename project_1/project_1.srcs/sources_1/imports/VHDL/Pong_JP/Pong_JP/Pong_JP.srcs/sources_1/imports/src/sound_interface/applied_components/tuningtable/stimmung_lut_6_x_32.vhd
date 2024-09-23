--------------------------------------------------------------------------------
-- Title          : Package Stimmungstabelle
-- Filename       : stimmung_lut_6_x_32.vhd
-- Project        : Meldody Player (Praktikum Digitaltechnik)
--------------------------------------------------------------------------------
-- Author         : Michael Kunz
-- Company        : Universität Kassel, FG Digitaltechnik
-- Date           : 21.09.2010
-- Language       : VHDL93
-- Synthesis      : Yes
-- Target Family  : ALL
-- Test Status    : Yes
--------------------------------------------------------------------------------
-- Applicable Documents:
-- 
--
--------------------------------------------------------------------------------
-- Revision History:
-- Date        Version  Author   Description
-- 13.01.2010  1.0      MK       Created (f_sample = 5MHz for self-made dac)
-- 21.09.2010	 1.1			MK			 set to f_sample = 91,911 kHz (f_clk/544) for
--                               mmCodec
--------------------------------------------------------------------------------
-- Description:
--
-- LUT for Note-Number to FTW for the DDS

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_signed.all;

package stimmung_lut_pkg is

constant NOTE_WIDTH : integer := 6;
constant FTW_WIDTH : integer := 32;

type stimmung_type is array(0 to 2**(NOTE_WIDTH)-1) of std_logic_vector(FTW_WIDTH-1 downto 0);

	constant stimmung_lut : stimmung_type := (
		conv_std_logic_vector(5140217,FTW_WIDTH),
		conv_std_logic_vector(5445870,FTW_WIDTH),
		conv_std_logic_vector(5769698,FTW_WIDTH),
		conv_std_logic_vector(6112782,FTW_WIDTH),
		conv_std_logic_vector(6476267,FTW_WIDTH),
		conv_std_logic_vector(6861366,FTW_WIDTH),
		conv_std_logic_vector(7269364,FTW_WIDTH),
		conv_std_logic_vector(7701623,FTW_WIDTH),
		conv_std_logic_vector(8159586,FTW_WIDTH),
		conv_std_logic_vector(8644780,FTW_WIDTH),
		conv_std_logic_vector(9158825,FTW_WIDTH),
		conv_std_logic_vector(9703437,FTW_WIDTH),
		conv_std_logic_vector(10280434,FTW_WIDTH),
		conv_std_logic_vector(10891740,FTW_WIDTH),
		conv_std_logic_vector(11539397,FTW_WIDTH),
		conv_std_logic_vector(12225565,FTW_WIDTH),
		conv_std_logic_vector(12952535,FTW_WIDTH),
		conv_std_logic_vector(13722733,FTW_WIDTH),
		conv_std_logic_vector(14538729,FTW_WIDTH),
		conv_std_logic_vector(15403247,FTW_WIDTH),
		conv_std_logic_vector(16319171,FTW_WIDTH),
		conv_std_logic_vector(17289560,FTW_WIDTH),
		conv_std_logic_vector(18317650,FTW_WIDTH),
		conv_std_logic_vector(19406875,FTW_WIDTH),
		conv_std_logic_vector(20560867,FTW_WIDTH),
		conv_std_logic_vector(21783480,FTW_WIDTH),
		conv_std_logic_vector(23078793,FTW_WIDTH),
		conv_std_logic_vector(24451130,FTW_WIDTH),
		conv_std_logic_vector(25905070,FTW_WIDTH),
		conv_std_logic_vector(27445465,FTW_WIDTH),
		conv_std_logic_vector(29077458,FTW_WIDTH),
		conv_std_logic_vector(30806493,FTW_WIDTH),
		conv_std_logic_vector(32638343,FTW_WIDTH),
		conv_std_logic_vector(34579119,FTW_WIDTH),
		conv_std_logic_vector(36635301,FTW_WIDTH),
		conv_std_logic_vector(38813749,FTW_WIDTH),
		conv_std_logic_vector(41121735,FTW_WIDTH),
		conv_std_logic_vector(43566960,FTW_WIDTH),
		conv_std_logic_vector(46157587,FTW_WIDTH),
		conv_std_logic_vector(48902260,FTW_WIDTH),
		conv_std_logic_vector(51810139,FTW_WIDTH),
		conv_std_logic_vector(54890931,FTW_WIDTH),
		conv_std_logic_vector(58154915,FTW_WIDTH),
		conv_std_logic_vector(61612986,FTW_WIDTH),
		conv_std_logic_vector(65276685,FTW_WIDTH),
		conv_std_logic_vector(69158239,FTW_WIDTH),
		conv_std_logic_vector(73270602,FTW_WIDTH),
		conv_std_logic_vector(77627498,FTW_WIDTH),
		conv_std_logic_vector(82243470,FTW_WIDTH),
		conv_std_logic_vector(87133921,FTW_WIDTH),
		conv_std_logic_vector(92315174,FTW_WIDTH),
		conv_std_logic_vector(97804519,FTW_WIDTH),
		conv_std_logic_vector(103620279,FTW_WIDTH),
		conv_std_logic_vector(109781861,FTW_WIDTH),
		conv_std_logic_vector(116309830,FTW_WIDTH),
		conv_std_logic_vector(123225973,FTW_WIDTH),
		conv_std_logic_vector(130553370,FTW_WIDTH),
		conv_std_logic_vector(138316478,FTW_WIDTH),
		conv_std_logic_vector(146541204,FTW_WIDTH),
		conv_std_logic_vector(155254997,FTW_WIDTH),
		conv_std_logic_vector(164486940,FTW_WIDTH),
		conv_std_logic_vector(174267842,FTW_WIDTH),
		conv_std_logic_vector(184630347,FTW_WIDTH),
		conv_std_logic_vector(0,FTW_WIDTH)
	);

end stimmung_lut_pkg;

package body stimmung_lut_pkg is
end stimmung_lut_pkg;

--		conv_std_logic_vector(3595754,FTW_WIDTH)
