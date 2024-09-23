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
        clk_frequency_in_Hz : integer := 125_000_000; 
        debounce_time_in_us : integer := 2000
    );

    Port ( 
        clk : in std_logic;
        rst : in STD_LOGIC;
        input : in STD_LOGIC;
        debounce : out STD_LOGIC
    );
end Rotation_Encoder_Debounced;

architecture Behavioral of Rotation_Encoder_Debounced is

    signal max_count : integer := (clk_frequency_in_Hz / 1_000_000) * (debounce_time_in_us);
    signal counter : integer := 0;
    signal sync_in : std_logic := '0';
    signal deb_out : std_logic := '0';

begin

    sync_process: process(clk)
    begin
        if rising_edge(clk) then
            sync_in <= input;
        end if;
    end process;

    debounce_process: process(clk, rst,sync_in)
    begin
        if rst = '1' then
            counter <= 0;
        end if;
        if rising_edge(clk) then
            if sync_in = '0' then
                if counter = max_count then
                    deb_out <= '1';
                    counter <= 0;
                else 
                    counter <= counter + 1;
                end if;
            else
                if counter = 0 then
                    deb_out <= '0';
                else 
                    counter <= counter - 1;
                end if;
            end if;
        end if;
    end process;

    debounce <= deb_out;
end Behavioral;

