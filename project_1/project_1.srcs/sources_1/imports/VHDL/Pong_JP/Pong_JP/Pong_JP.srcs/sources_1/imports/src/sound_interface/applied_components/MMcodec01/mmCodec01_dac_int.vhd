library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;



entity dac_mmcodec01 is
	
	generic(
		clk_frequency:integer := 50E6; -- Clock Input 50 MHz
		dac_word_size : integer := 16
	);
	
	port(
	    -- Clock and reset Input 
			clk_i							:	in  std_logic;
			rst_i							:	in  std_logic;
			--serial port out 
			dac_dout_o				: out std_logic;
			--parallel port in
			audio_l_i		: in std_logic_vector(dac_word_size-1 downto 0);
			audio_r_i		: in std_logic_vector(dac_word_size-1 downto 0);
			--enable signal
			bit_enable_i: in std_logic;
			smpl_enable_i:in std_logic
	);

end entity;

architecture dac_mmcodec01_arch of dac_mmcodec01 is

signal bit_cnt: integer range 0 to dac_word_size-1;
signal audio_shift : std_logic_vector(dac_word_size-1 downto 0);
signal audio_r_tmp : std_logic_vector(dac_word_size-1 downto 0);


begin
  
process(rst_i,clk_i)
  begin 
    if rst_i = '1' then
		   bit_cnt <= dac_word_size-1;
   	   audio_shift <= (others => '0');
       audio_r_tmp <= (others => '0');
	  elsif rising_edge(clk_i) then 
      if smpl_enable_i='1' then
         bit_cnt <= dac_word_size-1;
         audio_shift <= audio_l_i;
				 audio_r_tmp <= audio_r_i;        
      elsif bit_enable_i='1' then 
         audio_shift <= audio_shift(14 downto 0) & "0";
         if bit_cnt = 0 then	--	wechsel des Kanals durchfuehren
            bit_cnt <= dac_word_size-1;
            audio_shift <= audio_r_tmp; 
         else
            bit_cnt <= bit_cnt - 1;
         end if; -- bit_cnt
      end if; -- enable
    end if; -- clk
end process; 

dac_dout_o <= audio_shift(15);

end architecture;
