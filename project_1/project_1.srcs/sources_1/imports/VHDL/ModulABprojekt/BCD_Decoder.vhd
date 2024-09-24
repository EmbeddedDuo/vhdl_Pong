----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.06.2024 21:11:18
-- Design Name: 
-- Module Name: BCD_Decoder - Behavioral
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

entity BCD_Decoder is
    Port (
        bcd_in: in std_logic_vector(3 downto 0);
        segment_out : out std_logic_vector(6 downto 0)
     );
end BCD_Decoder;

architecture Behavioral of BCD_Decoder is

begin
    process(bcd_in)
    begin
        case bcd_in is
        when "0000" =>
        segment_out <= not "0000001";
        when "0001" =>
        segment_out <= not "1001111";
        when "0010" =>
        segment_out <= not "0010010";
        when "0011" =>
        segment_out <= not "0000110";
        when "0100" =>
        segment_out <= not "1001100";
        when "0101" =>
        segment_out <= not "0100100";
        when "0110" =>
        segment_out <= not "0100000";
        when "0111" =>
        segment_out <= not "0001111";
        when "1000" =>
        segment_out <= not "0000000";
        when "1001" =>
        segment_out <= not "0000100";
        when "1010" =>
        segment_out <= not "1111110";
        when others =>
        segment_out <= not "1111111";
        end case;
    end process;
end Behavioral;