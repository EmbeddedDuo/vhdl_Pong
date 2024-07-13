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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Rotation_Encoder_Debounced IS
    GENERIC (
        clk_frequency_in_Hz : INTEGER := 125_000_000;
        debounce_time_in_us : INTEGER := 2000;
        active_low : BOOLEAN := true
    );

    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        input : IN STD_LOGIC;
        debounce : OUT STD_LOGIC
    );
END Rotation_Encoder_Debounced;

ARCHITECTURE Behavioral OF Rotation_Encoder_Debounced IS
    SIGNAL max_count : INTEGER := (clk_frequency_in_Hz / 1_000_000) * (debounce_time_in_us / 2 );

    SIGNAL counter : INTEGER := 0;
    SIGNAL sample : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
    SIGNAL sample_rate : STD_LOGIC := '0';

BEGIN

    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            counter <= 0;
            sample_rate <= '0';
        ELSIF rising_edge(clk) THEN
            IF (counter < max_count) THEN
                counter <= counter + 1;
                sample_rate <= '0';
            ELSE
                counter <= 0;
                sample_rate <= '1';
            END IF;
        END IF;
    END PROCESS;

    PROCESS (clk, rst) --Sampling Process
    BEGIN
        IF rst = '1' THEN
            sample <= (OTHERS => input);
        ELSIF rising_edge(clk) THEN
            IF (sample_rate = '1') THEN
                sample(3 DOWNTO 1) <= sample(2 DOWNTO 0); -- Linksschieben
                sample(0) <= input;
            END IF;
        END IF;
    END PROCESS;

    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            debounce <= '0';
        ELSIF rising_edge(clk) THEN
            IF (active_low) THEN
                IF (sample = "0000") THEN
                    debounce <= '1';
                ELSIF (sample = "1111") THEN
                    debounce <= '0';
                END IF;
            ELSE
                IF (sample = "1111") THEN --Aktiv High Konstant-Ausgang
                    debounce <= '0';
                ELSIF (sample = "0000") THEN
                    debounce <= '1';
                END IF;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;