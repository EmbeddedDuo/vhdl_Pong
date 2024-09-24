LIBRARY ieee  ; 
USE ieee.numeric_std.all  ; 
USE ieee.std_logic_1164.all  ; 
ENTITY contrl_int_tb  IS 
  GENERIC (
    adc_word_size  : integer   := 16 ;  
    sclk_frequency  : integer   := 12500000 ;  
    clk_frequency  : integer   := 50000000 ); 
END ; 
 
ARCHITECTURE contrl_int_tb_arch OF contrl_int_tb IS
  SIGNAL data_enable   :  std_logic  ; 
  SIGNAL adc_sdin_dat_i   :  std_logic_vector (8 downto 0)  ; 
  SIGNAL sdout_o   :  std_logic  ; 
  SIGNAL busy_o   :  std_logic  ; 
  SIGNAL rst_i   :  std_logic  ; 
  SIGNAL clk_i   :  std_logic  ; 
  SIGNAL adc_sdin_adr_i   :  std_logic_vector (15 downto 9)  ; 
  SIGNAL adc_cs_o   :  std_logic  ; 
  SIGNAL sclk_o   :  std_logic  ; 
  COMPONENT contrl_int  
    GENERIC ( 
      adc_word_size  : integer ; 
      sclk_frequency  : integer ; 
      clk_frequency  : integer  );  
    PORT ( 
      data_enable  : in std_logic ; 
      adc_sdin_dat_i  : in std_logic_vector (8 downto 0) ; 
      sdout_o  : out std_logic ; 
      busy_o  : out std_logic ; 
      rst_i  : in std_logic ; 
      clk_i  : in std_logic ; 
      adc_sdin_adr_i  : in std_logic_vector (15 downto 9) ; 
      adc_cs_o  : out std_logic ; 
      sclk_o  : out std_logic ); 
  END COMPONENT ; 
BEGIN
  DUT  : contrl_int  
    GENERIC MAP ( 
      adc_word_size  => adc_word_size  ,
      sclk_frequency  => sclk_frequency  ,
      clk_frequency  => clk_frequency   )
    PORT MAP ( 
      data_enable   => data_enable  ,
      adc_sdin_dat_i   => adc_sdin_dat_i  ,
      sdout_o   => sdout_o  ,
      busy_o   => busy_o  ,
      rst_i   => rst_i  ,
      clk_i   => clk_i  ,
      adc_sdin_adr_i   => adc_sdin_adr_i  ,
      adc_cs_o   => adc_cs_o  ,
      sclk_o   => sclk_o   ) ; 
      
      rst_i<='1','0' after 20 ns;
      process
        begin
          clk_i<='0';
          wait for 10 ns;
          clk_i<='1';
          wait for 10 ns;
     end process;   
      
END ; 

