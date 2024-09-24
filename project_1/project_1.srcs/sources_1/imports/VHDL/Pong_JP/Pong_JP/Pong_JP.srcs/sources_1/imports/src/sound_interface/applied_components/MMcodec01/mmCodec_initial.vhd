LIBRARY ieee  ; 
USE ieee.numeric_std.all  ; 
USE ieee.std_logic_1164.all  ;

entity mmCodec_init is
  port(
       clk_i:in std_logic;
       rst_i:in std_logic;
       busy_i:in std_logic;
       addr_o:out std_logic_vector(6 downto 0);
       data_o:out std_logic_vector(8 downto 0);
       enable_o:out std_logic
       );
       
end entity;

architecture mmCodec_init_Arch of mmCodec_init is


type states is (SEND_DATA, WAIT_FOR,WAIT_FOR_BUSY,END_INIT);
signal state: states;
signal count:integer range 0 to 15;

signal addr_tmp:std_logic_vector(6 downto 0);

begin

 process (rst_i,clk_i)
  begin
    if rst_i = '1' then
      enable_o <='0';
      state <= SEND_DATA;
      count <= 15;
    elsif rising_edge(clk_i) then
 
    case state is
      when SEND_DATA =>
		      enable_o <= '1'; 
  			  state <= WAIT_FOR; 
      when  WAIT_FOR =>
			    enable_o <= '0'; 
			    state<=WAIT_FOR_BUSY;
      when WAIT_FOR_BUSY =>
         if busy_i = '0' then
           if count < 9 then
      		     count<=count+1;
               state<=SEND_DATA;
    			 else
    			    if count = 15 then
    			       count <= 0;
                 state<=SEND_DATA;
              else
                 state<=END_INIT;
              end if; -- count = 15
  			   end if; -- count < 9
         end if; --busy
      when END_INIT => 
   end case;
 end if; --clk       

end process;

addr_tmp<=std_logic_vector(to_unsigned(count,7));
addr_o<=addr_tmp;

-- mmCodec Konfiguration
with addr_tmp select
data_o<= "010010111" when "0000000",
         "010010111" when "0000001",
         "001111001" when "0000010",
         "001111001" when "0000011",
         "110010010" when "0000100",
         "000000111" when "0000101",
         "000000000" when "0000110",
         "000010001" when "0000111",
         "000111110" when "0001000",
         "000000001" when "0001001",
         "000000000" when "0001111",
         "000000000" when others;

end architecture;        


