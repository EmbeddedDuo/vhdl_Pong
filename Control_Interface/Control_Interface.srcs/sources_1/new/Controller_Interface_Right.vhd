----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.07.2024 11:40:41
-- Design Name: 
-- Module Name: Controller_Interface_Right - Behavioral
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

entity Controller_Interface is
    Generic (
        clk_frequency_in_Hz : integer := 125_000_0000; 
        racket_steps : integer := 5;
        debounce_time_in_us : integer := 2000;
        racket_height : integer := 30;
        screen_height : integer := 480
    );
    Port ( clock_i : in STD_LOGIC;
           reset_i : in STD_LOGIC;
           rot_enc_i : in STD_LOGIC_VECTOR (1 downto 0);
           push_but_i : in STD_LOGIC;
           push_but_deb_o : out STD_LOGIC;
           racket_y_pos_o : out STD_LOGIC);
end Controller_Interface;

architecture Behavioral of Controller_Interface is

begin

process (clock_i, reset_i) 
    begin 
        

end process;

end Behavioral;
