LIBRARY ieee  ; 
USE ieee.numeric_std.all  ; 
USE ieee.std_logic_1164.all  ;

entity contrl_int is
	generic(
		sclk_frequency  : integer := 12500E3;  -- 12.5 MHz
		clk_frequency   : integer := 50E6; -- Clock Input 50 MHz
		cntrl_word_size : integer := 16
	);
	
  port(
      clk_i						:	in  std_logic;
      rst_i					  :	in  std_logic;
      --port out
      sclk_o		      : out	std_logic;
      busy_o          : out std_logic;
      sdout_o         : out std_logic;
      --port in
      ncs_o        : out std_logic;
      sdin_adr_i  : in std_logic_vector(15 downto 9); -- control word
      sdin_dat_i  : in std_logic_vector(8 downto 0);
      data_enable     : in std_logic
      
  );
end entity;  

architecture cntrl_Arch of contrl_int is

constant sclk_div:integer := (clk_frequency/sclk_frequency)/2;

signal sdin: std_logic_vector(cntrl_word_size-1 downto 0);
signal sclk_tmp:std_logic;
signal freq_count:integer range 0 to sclk_div-1;
signal cscount: integer range cntrl_word_size-1 downto 0;
type states is (WAIT_FOR_ENABLE, SEND_DATA);
signal state: states;


begin
  
 sdin <= sdin_adr_i & sdin_dat_i;
  
process(clk_i,rst_i)
  begin
    if rst_i='1' then
      busy_o<='0';
      ncs_o<='1';
      cscount<=cntrl_word_size-1;
	   	sclk_tmp <= '0';
    elsif rising_edge(clk_i) then
      case state is
         when WAIT_FOR_ENABLE =>
            ncs_o<='1';
            busy_o<='0';
            cscount<=cntrl_word_size-1;
              if data_enable = '1' then
                  state<=SEND_DATA;
                  busy_o <='1';
                  freq_count <= 0;
                  ncs_o<='0';
              end if; --data_enable
         when SEND_DATA =>
			     if freq_count=sclk_div-1 then
				         sclk_tmp<=not sclk_tmp;
				         freq_count <= 0;
            if sclk_tmp = '1' then
              if cscount =  0 then
                  ncs_o <= '1';
                  busy_o <= '0';
                  state<=WAIT_FOR_ENABLE;
              else
                  cscount <= cscount-1;
              end if; --cscount
            end if; -- sclk_tmp
			     else
			       	freq_count<=freq_count+1;
			     end if; --freq_count  
       end case;  
    end if;  --clk
end process;  

sclk_o <= sclk_tmp;
sdout_o <= sdin(cscount);

end architecture;  

