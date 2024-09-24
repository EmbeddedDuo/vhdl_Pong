LIBRARY ieee  ; 
USE ieee.numeric_std.all  ; 
USE ieee.std_logic_1164.all  ;

entity frequenz_div is
  generic(
          divider:integer:=4  -- divider frequency 
          );
  port(clk_i:in std_logic;
       rst_i: in std_logic;
       new_clk:out std_logic;
       clk_enable:out std_logic);
end entity;  

architecture frequenzdivArch of frequenz_div is

constant div:integer := divider-1;

signal new_clk_tmp:std_logic;
signal count:integer range 0 to divider-1;

begin
  
process(clk_i,rst_i)   
  begin
    if rst_i='1' then
       new_clk_tmp<='1';
       count<=0;
       clk_enable<='0';
    elsif rising_edge(clk_i) then
       clk_enable<='0';
       if count=div then
          clk_enable<='1';
          count<=0;  
          new_clk_tmp<=not new_clk_tmp;  
       else
          clk_enable<='0';
          if count=div/2 then   
             new_clk_tmp<=not new_clk_tmp;        
          end if; 
          count<=count+1;
       end if; 
    end if; -- clk 
end process;  
 new_clk<=new_clk_tmp;
end architecture;
