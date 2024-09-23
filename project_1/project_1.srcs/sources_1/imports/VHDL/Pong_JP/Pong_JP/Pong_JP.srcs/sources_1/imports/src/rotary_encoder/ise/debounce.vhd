-------------------------------------------------------------------------------
--
-- M. Kumm
-- 
-- Debounce logic for debouncing of machanical switches or similar noisy input logic
--
-------------------------------------------------------------------------------

-- Package Definition

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;

package debounce_pkg is
  component debounce
  	generic(
  		debounce_clks  : integer
  	);
  	port(
  			rst_i	:	in std_logic ;
  			clk_i	:	in std_logic ;
  			x_i		:	in std_logic ;
  			x_o 	:	out std_logic
  	);
  end component;
end debounce_pkg;

package body debounce_pkg is
end debounce_pkg;

-- Entity Definition

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity debounce is
	generic(
		debounce_clks  : integer :=2
	);
	port(
 			rst_i	:	in std_logic ;
			clk_i	:	in std_logic ;
			x_i		:	in std_logic ;
			x_o 	:	out std_logic
	);
	
end debounce; 

architecture debounce_arch of debounce is
	signal count : integer range 0 to debounce_clks;

signal x_sync: std_logic;
begin

debounce_p: process (clk_i,rst_i,x_i)
begin
	if rst_i='1' then	
	  x_o <= x_i;
	elsif clk_i'event and clk_i = '1' then	
		x_sync <= x_i;
		if x_sync = '1' then
			if count = debounce_clks then
				x_o <= '1';
			else
				count <= count + 1;
			end if;
		else
			if count = 0 then
				x_o <= '0';
			else
				count <= count - 1;
			end if;
		end if;
	end if;
end process debounce_p;

end debounce_arch;