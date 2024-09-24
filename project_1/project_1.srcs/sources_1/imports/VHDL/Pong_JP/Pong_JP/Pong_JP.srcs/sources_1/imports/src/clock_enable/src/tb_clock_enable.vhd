--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:48:08 06/22/2010
-- Design Name:   
-- Module Name:   C:/Dokumente und Einstellungen/mikunz/Eigene Dateien/Lehrveranstaltungen/VHDL-Kurs/pong/source/tb_clock_enable.vhd
-- Project Name:  pong
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: clock_enable
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY tb_clock_enable IS
END tb_clock_enable;
 
ARCHITECTURE behavior OF tb_clock_enable IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT clock_enable
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         vga_enable_o : OUT  std_logic;
         game_enable_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal vga_enable : std_logic;
   signal game_enable : std_logic;

   -- Clock period definitions
   constant clk_50MHz_i_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: clock_enable PORT MAP (
          clock => clock,
          reset => reset,
          vga_enable_o => vga_enable,
          game_enable_o => game_enable
        );

   -- Clock process definitions
   clk_50MHz_i_process :process
   begin
		clock <= '0';
		wait for clk_50MHz_i_period/2;
		clock <= '1';
		wait for clk_50MHz_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      reset <= '1';
      wait for clk_50MHz_i_period*4;
		reset <= '0';
      wait for clk_50MHz_i_period*1000000;

      -- insert stimulus here 

      wait;
   end process;

END;
