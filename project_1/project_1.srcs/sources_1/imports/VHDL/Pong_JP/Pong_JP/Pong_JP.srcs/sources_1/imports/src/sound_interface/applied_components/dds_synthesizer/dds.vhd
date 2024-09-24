----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:02:32 12/21/2009 
-- Design Name: 
-- Module Name:    dds - Behavioral 
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
use work.dds_synthesizer_pkg.all;
use work.sine_lut_pkg.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dds is
    Port ( clock : in  STD_LOGIC;
           reset_i : in  STD_LOGIC;
			  dds_enable_i : in std_logic;
           ftw_i : in  STD_LOGIC_VECTOR (31 downto 0);
           ampl_o : out  STD_LOGIC_VECTOR (15 downto 0));
end dds;

architecture dds_toplevel of dds is

  signal ampl_temp : std_logic_vector(7 downto 0);

begin

	dds_synth: dds_synthesizer
  generic map(
		ftw_width   => 32
  )
  port map(
		clk_i => clock,
		rst_i => reset_i,
		dds_enable_i => dds_enable_i,
		ftw_i    => ftw_i,
		phase_i  => (others => '0'),
		phase_o  => open,
		ampl_o => ampl_o --ampl_temp
  );

  --ampl_o <= ampl_temp + x"7F";


end dds_toplevel;

