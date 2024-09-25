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
-- Additional Comments: Dieses Modul wird verwendet um das Eingangssignal zu entprellen.
-- dies wird verwendet für Entprellung von den Ausgangssignale a, b und dem Button vom Drehimpulsgeber
----------------------------------------------------------------------------------


library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;

entity Rotation_Encoder_Debounced is
    Generic (
        clk_frequency_in_Hz : integer := 125_000_000; -- takt_frequenz : die Frequenz der Eingangstaktsignal von clk in HZ
        debounce_time_in_us : integer := 2000  -- Entprellzeit in Mikrosekunden 
    );

    Port ( 
        clk : in std_logic; -- Takteingang
        rst : in STD_LOGIC;  -- reseteingang
        input : in STD_LOGIC; -- zu entprellendens Eingangssignal 
        debounce : out STD_LOGIC -- Entprelltes Ausgangssignal 
    );
end Rotation_Encoder_Debounced;

architecture Behavioral of Rotation_Encoder_Debounced is

    signal max_count : integer := (clk_frequency_in_Hz / 1_000_000) * (debounce_time_in_us); -- Maximal Zählwert: Anzahl der Taktzyklen die der Entprellzeit entspricht
    signal counter : integer := 0;        -- Zähler 
    signal sync_in : std_logic := '0';  -- synchronisierter Eingangssignal 
    signal deb_out : std_logic := '0'; -- Entprelltes signal 

begin

    sync_process: process(clk)  -- synchronisierung vom asynchrone Eingangssignal input mit dem Systemtakt clk zu 
    begin
        if rising_edge(clk) then
            sync_in <= input;
        end if;
    end process;

    -- hier wird der Zähler entsprechend dem Eingangssignal dekrementiert oder Inkrementiert. 
    -- Erreicht er den maximalen Zählwert oder bleibt er 0, so wird entsprechend das Ausgangssignal gesetzt. 
    debounce_process: process(clk, rst,sync_in) -- 
    begin
        if rst = '1' then  --Zurücksetzung der Zähler bei reset
            counter <= 0;   
        end if;
        if rising_edge(clk) then
            if sync_in = '0' then  
                if counter = max_count then 
                    deb_out <= '1';
                    counter <= 0;
                else                        -- Ansonsten den Zähler inkrementieren
                    counter <= counter + 1;
                end if;
            else               -- bei synchronisierter  Eingangssignal 1
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