----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.07.2024 11:40:41
-- Design Name: 
-- Module Name: Score_Display - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Score_Display is
    Generic( score_max : integer range 0 to 99 := 10); -- Max Point 
    Port ( clock_i : in STD_LOGIC;
           reset_i : in STD_LOGIC;
           led_enable_i : in STD_LOGIC;
           push_but1_deb_i : in STD_LOGIC;
           push_but2_deb_i : in STD_LOGIC;
           hit_wall_i : in STD_LOGIC_VECTOR (2 downto 0);
           seven_seg_leds_o : out STD_LOGIC_VECTOR (6 downto 0);
           seven_seg_sel_o : out STD_LOGIC_VECTOR (5 downto 0);
           game_over_o : out STD_LOGIC);
end Score_Display;

architecture Behavioral of Score_Display is

begin


end Behavioral;
