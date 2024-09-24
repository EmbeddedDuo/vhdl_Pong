LIBRARY ieee  ; 
USE ieee.numeric_std.all  ; 
USE ieee.std_logic_1164.all  ;


entity audio_clk_gen is
  	
  port(clk_i:in std_logic;
       rst_i:in std_logic;
       -- output
       mclk_o:out std_logic;
       mclk_en_o:out std_logic;
       bclk_o:out std_logic;
       bclk_en_o:out std_logic;
       lrcout_o:out std_logic;
       sample_en_o:out std_logic;
       note_clk_o:out std_logic;
       note_clk_en_o:out std_logic
   );
       
end entity;

architecture audio_clk_gen_Arch of audio_clk_gen is


component frequenz_div is
  generic(
          divider:integer:=4  -- divider  
          );
  port(clk_i:in std_logic;
       rst_i: in std_logic;
       new_clk:out std_logic;
       clk_enable:out std_logic);
end component;  

begin
  
mclk_gen: frequenz_div  
  generic map(
      divider =>4  -- divider 
         )
  port map(clk_i => clk_i,
       rst_i => rst_i,
       new_clk => mclk_o,
       clk_enable => mclk_en_o);
       
bclk_gen: frequenz_div  
  generic map(
      divider =>17  -- divider 
         )
  port map(clk_i => clk_i,
       rst_i => rst_i,
       new_clk => bclk_o,
       clk_enable => bclk_en_o);
       
 lrcout_gen: frequenz_div  
  generic map(
      divider =>544  -- divider 
         )
  port map(clk_i => clk_i,
       rst_i => rst_i,
       new_clk => lrcout_o,
       clk_enable => sample_en_o);
             
   note_clk_gen: frequenz_div  
  generic map(
      divider =>3125000-- hexadezimal zeigt er Fehler an x"2FAF08"  -- divider 
         )
  port map(clk_i => clk_i,
       rst_i => rst_i,
       new_clk => note_clk_o,
       clk_enable => note_clk_en_o);             
end architecture;       

