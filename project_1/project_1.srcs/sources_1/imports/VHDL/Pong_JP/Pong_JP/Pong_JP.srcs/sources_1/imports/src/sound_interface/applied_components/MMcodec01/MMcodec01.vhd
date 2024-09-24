LIBRARY ieee  ; 
USE ieee.numeric_std.all  ; 
USE ieee.std_logic_1164.all  ;


entity mmCodec01 is
  	generic(
    clk_frequency:integer := 50E6; -- Clock Input 50 MHz
    data_word_size : integer := 16;  -- bitbreite 16 bit
    sclk_frequency : integer := 6250E3 -- clock frequency of control interface (max. 12.5 MHz!)
    
	  );
  	
  port(--input
       clk_i:in std_logic;
       rst_i:in std_logic;
       din_i:in std_logic;
       mclk_i:in std_logic;
       bclk_i:in std_logic;
       lrclk_i:in std_logic;
       bclk_en_i:in std_logic;
       audio_i:in std_logic_vector(data_word_size-1 downto 0);
       sample_en_i:in std_logic;
       --output
       dout_o:out std_logic;
       lrcout_o:out std_logic;
       bclk_o:out std_logic;
       sclk_o:out std_logic;
       sdout_o:out std_logic;
       ncs_o:out std_logic;
		   mode_o:out std_logic;
		   mck_o:out std_logic
       );
       
end entity;


architecture mmCodec01Arch of mmCodec01 is

signal reset : std_logic;
signal busy: std_logic;
signal sdin_adr_i  :  std_logic_vector(15 downto 9); 
signal sdin_dat_i  :  std_logic_vector(8 downto 0);
signal enable_init: std_logic;


component mmCodec_init is
    port(
       clk_i:in std_logic;
       rst_i:in std_logic;
       busy_i:in std_logic;
       addr_o:out std_logic_vector(6 downto 0);
       data_o:out std_logic_vector(8 downto 0);
       enable_o:out std_logic
       );
end component;     



  component contrl_int is
	generic(
		sclk_frequency:integer := 12500E3;  --12,5 MHz
		clk_frequency:integer := 50E6; -- Clock Input 50 MHz
		cntrl_word_size : integer := 16
	);
	
  port(
      clk_i							:	in  std_logic;
      rst_i							:	in  std_logic;
      --port out
      sclk_o		: out	std_logic;
      busy_o      : out std_logic;
      sdout_o     : out std_logic;
      --port in
      ncs_o        : out std_logic;
      sdin_adr_i  : in std_logic_vector(15 downto 9); 
      sdin_dat_i  : in std_logic_vector(8 downto 0);
      data_enable     : in std_logic
      
  );
  
end component;
--
--component adc_mmcodec01 is
--   generic(
--    adc_word_size : integer := 16
--  );
--  port(
--      clk_i							:	in  std_logic;
--      rst_i							:	in  std_logic;
--      --serial port in
--      adc_bclk_i				: in	std_logic;
--      adc_lrcout_i				: in std_logic;
--      adc_dout_i				: in std_logic;
--      --parallel port out
--      audio_l_o		: out std_logic_vector(adc_word_size-1 downto 0);
--      audio_r_o		: out std_logic_vector(adc_word_size-1 downto 0);
--      enable_o : out std_logic --signals that both ports (left & right) are updated
--  );
--  
--end component;

component dac_mmcodec01 is
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
	
	end component;


begin
 
  mmcodec_initial:  mmCodec_init 
    port map(
       clk_i =>clk_i,
       rst_i => reset,
       busy_i => busy,
       addr_o => sdin_adr_i,
       data_o => sdin_dat_i,
       enable_o => enable_init
       );
  
  
  cntrl_int: contrl_int
	  generic map(
		  sclk_frequency => sclk_frequency,
		  clk_frequency  => clk_frequency,
		  cntrl_word_size => data_word_size
	    )
    port map(
		  clk_i							=>clk_i,
      rst_i						=> reset,
      --port out
      sclk_o	=> sclk_o,
      busy_o     => busy,
      sdout_o    => sdout_o,
      --port in
      ncs_o  => ncs_o ,     
      sdin_adr_i  =>sdin_adr_i,
      sdin_dat_i  =>sdin_dat_i,
      data_enable     => enable_init
		  );
	
 
 	dac_interface: dac_mmcodec01
  generic map(
		clk_frequency => clk_frequency,
		dac_word_size => data_word_size
	)
  
    port 	map(
	    -- Clock and reset Input 
			clk_i							=>clk_i,
			rst_i							=>reset,
			--serial port out 
			dac_dout_o				=>dout_o,
			--parallel port in
			audio_l_i		=> audio_i,
			audio_r_i		=> audio_i,
			--enable signal
			bit_enable_i => bclk_en_i,
			smpl_enable_i => sample_en_i
	);     


--
-- adc_int: adc_mmcodec01
--    port map(
--      clk_i			=> clk_i,
--      rst_i			=> reset,
--      --serial port in
--      adc_bclk_i			=> bclk_tmp,
--      adc_lrcout_i	=> lrcout_tmp,
--      adc_din_i			=> din_i,
--      --parallel port out
--      audio_l_o	=> audio_l_tmp,
--      audio_r_o	=> audio_r,	
--      enable_o  => enable_adc
--  );

--------------------------------------------------------------------------------
-- CONCURRENT: Output-Map
--------------------------------------------------------------------------------

bclk_o<=not bclk_i; --bclk negiert, da das MMcodec01 auf fallende Flanke reagiert
mode_o<= '1'; -- SPI-mode
--reset <= not rst; -- reset in außenbeschaltung
reset <= rst_i;
lrcout_o <= lrclk_i;
mck_o <= mclk_i;

end architecture;       


