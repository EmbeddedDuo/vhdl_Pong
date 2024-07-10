----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.07.2024 13:51:46
-- Design Name: 
-- Module Name: Rotation_Encoder_Debounced - Behavioral
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

entity Rotation_Encoder_Debounced is
    Generic (
        clk_frequency_in_Hz : integer := 125_000_0000; 
        debounce_time_in_us : integer := 2000
    );
    
    Port ( 
        clk_i : in std_logic;
        rst_i : in STD_LOGIC;
        rot_enc_i : in STD_LOGIC_VECTOR (1 downto 0);
        rot_enc_debounced : out STD_LOGIC_VECTOR (1 downto 0)
    );
end Rotation_Encoder_Debounced;

architecture Behavioral of Rotation_Encoder_Debounced is

    signal max_count : integer :=  debounce_time_in_us /((1 / clk_frequency_in_Hz) * 1_000_000); -- max count damit debounce time auf 2000us 
    signal counter_a : integer := 0;
    signal counter_b : integer := 0;
    signal a : std_logic := '0';
    signal b : std_logic := '0';

begin

    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            counter_a <= 0;
            a <= '0';
            b <= '0';
        end if;
    end process;
    
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if counter_a = max_count then
            a <= '1';
            elsif counter_a = 0 then
            a <= '0';
            end if;
            if rot_enc_i(0) = '0' then
                counter_a <= counter_a + 1;
            else
                counter_a <= counter_a - 1;
            end if;
        end if;
    end process;
    
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if counter_b = max_count then
            b <= '1';
            elsif counter_b = 0 then
            b <= '0';
            end if;
            if rot_enc_i(1) = '0' then
                counter_b <= counter_b + 1;
            else
                counter_b <= counter_b - 1;
            end if;
        end if;
    end process;

end Behavioral;
