----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:22:26 12/21/2009 
-- Design Name: 
-- Module Name:    vol_ctrl - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use work.sine_lut_pkg.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vol_ctrl is
    Port ( clk_i 	 : in   STD_LOGIC;
			  reset_i : in   STD_LOGIC;
			  dds_enable_i : in std_logic;
			  ampl_i  : in   STD_LOGIC_VECTOR (AMPL_WIDTH-1 downto 0);
           vol_i  : in   STD_LOGIC_VECTOR (1 downto 0);
          -- vol1_i  : in   STD_LOGIC;
           --stacc_i : in   STD_LOGIC;
           ampl_o  : out  STD_LOGIC_VECTOR (AMPL_WIDTH-1 downto 0));
end vol_ctrl;

architecture volume_control of vol_ctrl is

--signal volume 	 : std_logic_vector (1 downto 0);
signal tmp_ampl :	 std_logic_vector (AMPL_WIDTH-1 downto 0);

begin

-- concurrent -----------------------------------------------------------------------

--volume <= vol_i;
--volume(1) <= vol1_i;

ampl_o <= tmp_ampl;

-- shifter --------------------------------------------------------------------------

shift : process(clk_i, reset_i)
	
	begin
	
		if (reset_i = '1') then
		
			tmp_ampl <= (others => '0');
		
		elsif clk_i'event and clk_i = '1' then
		
		if (dds_enable_i = '1') then

		
			case vol_i is
				when "11" 	=> tmp_ampl <= ampl_i;
				when "10" 	=> tmp_ampl <= ampl_i(AMPL_WIDTH-1) & ampl_i (AMPL_WIDTH-1 downto 1);
				when "01" 	=> tmp_ampl <= ampl_i(AMPL_WIDTH-1) & ampl_i(AMPL_WIDTH-1) & ampl_i (AMPL_WIDTH-1 downto 2);
				when others => tmp_ampl <= (others => '0');
			end case; -- volume
			
		end if;
		
		end if; --clk
	
	end process; -- shift

end volume_control;

