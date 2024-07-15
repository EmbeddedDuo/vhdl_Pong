## This file is a general .xdc for the PYNQ-Z1 board Rev. C
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal 125 MHz
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { clock_i }]; #IO_L13P_T2_MRCC_35 Sch=sysclk
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { clock_i }];

##Switches
set_property -dict { PACKAGE_PIN M20   IOSTANDARD LVCMOS33 } [get_ports { sw[0] }]; #IO_L7N_T1_AD2N_35 Sch=sw[0]
set_property -dict { PACKAGE_PIN M19   IOSTANDARD LVCMOS33 } [get_ports { sw[1] }]; #IO_L7P_T1_AD2P_35 Sch=sw[1]

##RGB LEDs
#set_property -dict { PACKAGE_PIN L15   IOSTANDARD LVCMOS33 } [get_ports { led4_b }]; #IO_L22N_T3_AD7N_35 Sch=led4_b
#set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { led4_g }]; #IO_L16P_T2_35 Sch=led4_g
#set_property -dict { PACKAGE_PIN N15   IOSTANDARD LVCMOS33 } [get_ports { led4_r }]; #IO_L21P_T3_DQS_AD14P_35 Sch=led4_r
#set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { led5_b }]; #IO_0_35 Sch=led5_b
#set_property -dict { PACKAGE_PIN L14   IOSTANDARD LVCMOS33 } [get_ports { led5_g }]; #IO_L22P_T3_AD7P_35 Sch=led5_g
#set_property -dict { PACKAGE_PIN M15   IOSTANDARD LVCMOS33 } [get_ports { led5_r }]; #IO_L23N_T3_35 Sch=led5_r

##LEDs
set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33 } [get_ports { led[0] }]; #IO_L6N_T0_VREF_34 Sch=led[0]
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { led[1] }]; #IO_L6P_T0_34 Sch=led[1]
set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports { led[2] }]; #IO_L21N_T3_DQS_AD14N_35 Sch=led[2]
set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { led[3] }]; #IO_L23P_T3_35 Sch=led[3]

##Buttons
set_property -dict { PACKAGE_PIN D19   IOSTANDARD LVCMOS33 } [get_ports { reset_i }]; #IO_L4P_T0_35 Sch=btn[0]
set_property -dict { PACKAGE_PIN D20   IOSTANDARD LVCMOS33 } [get_ports { btn[1] }]; #IO_L4N_T0_35 Sch=btn[1]
set_property -dict { PACKAGE_PIN L20   IOSTANDARD LVCMOS33 } [get_ports { btn[2] }]; #IO_L9N_T1_DQS_AD3N_35 Sch=btn[2]
set_property -dict { PACKAGE_PIN L19   IOSTANDARD LVCMOS33 } [get_ports { btn[3] }]; #IO_L9P_T1_DQS_AD3P_35 Sch=btn[3]

##Pmod Header JA
set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { rot_enc_i[0]  }]; #IO_L17P_T2_34 Sch=ja_p[1]
set_property -dict { PACKAGE_PIN Y19   IOSTANDARD LVCMOS33 } [get_ports { rot_enc_i[1] }]; #IO_L17N_T2_34 Sch=ja_n[1]
set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33 } [get_ports { push_but_i }]; #IO_L7P_T1_34 Sch=ja_p[2]
set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33 } [get_ports { ja[3] }]; #IO_L7N_T1_34 Sch=ja_n[2]
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { ja[4] }]; #IO_L12P_T1_MRCC_34 Sch=ja_p[3]
set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports { ja[5] }]; #IO_L12N_T1_MRCC_34 Sch=ja_n[3]
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports { ja[6] }]; #IO_L22P_T3_34 Sch=ja_p[4]
set_property -dict { PACKAGE_PIN W19   IOSTANDARD LVCMOS33 } [get_ports { ja[7] }]; #IO_L22N_T3_34 Sch=ja_n[4]

##Pmod Header JB
set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports { jb[0] }]; #IO_L8P_T1_34 Sch=jb_p[1]
set_property -dict { PACKAGE_PIN Y14   IOSTANDARD LVCMOS33 } [get_ports { jb[1] }]; #IO_L8N_T1_34 Sch=jb_n[1]
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { jb[2] }]; #IO_L1P_T0_34 Sch=jb_p[2]
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { jb[3] }]; #IO_L1N_T0_34 Sch=jb_n[2]
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { jb[4] }]; #IO_L18P_T2_34 Sch=jb_p[3]
set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports { jb[5] }]; #IO_L18N_T2_34 Sch=jb_n[3]
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { jb[6] }]; #IO_L4P_T0_34 Sch=jb_p[4]
set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports { jb[7] }]; #IO_L4N_T0_34 Sch=jb_n[4]

##Audio Out
set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { aud_pwm }]; #IO_L20N_T3_34 Sch=aud_pwm
set_property -dict { PACKAGE_PIN T17   IOSTANDARD LVCMOS33 } [get_ports { aud_sd }]; #IO_L20P_T3_34 Sch=aud_sd

##Misc input
set_property -dict { PACKAGE_PIN F17   IOSTANDARD LVCMOS33 } [get_ports { m_clk }]; #IO_L6N_T0_VREF_35 Sch=m_clk
set_property -dict { PACKAGE_PIN G18   IOSTANDARD LVCMOS33 } [get_ports { m_data }]; #IO_L16N_T2_35 Sch=m_data

#####################################################################################################################################
###################################################          Pynq-Shield          ###################################################
#####################################################################################################################################
## Jumper J15

set_property -dict { PACKAGE_PIN P16   IOSTANDARD LVCMOS33 } [get_ports { IO_1 }]; # ck_scl 
set_property -dict { PACKAGE_PIN Y9    IOSTANDARD LVCMOS33 } [get_ports { IO_2 }]; # io41  

## Blue LEDS, active low

set_property -dict { PACKAGE_PIN Y11   IOSTANDARD LVCMOS33 } [get_ports { push_but_deb_o }]; # most left
set_property -dict { PACKAGE_PIN F19   IOSTANDARD LVCMOS33 } [get_ports { racket_y_pos_o[6] }];
set_property -dict { PACKAGE_PIN W11   IOSTANDARD LVCMOS33 } [get_ports { racket_y_pos_o[5] }];      
set_property -dict { PACKAGE_PIN C20   IOSTANDARD LVCMOS33 } [get_ports { racket_y_pos_o[4] }];                                               
set_property -dict { PACKAGE_PIN T5    IOSTANDARD LVCMOS33 } [get_ports { racket_y_pos_o[3] }];                 
set_property -dict { PACKAGE_PIN B19   IOSTANDARD LVCMOS33 } [get_ports { racket_y_pos_o[2] }];               
set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { racket_y_pos_o[1] }];               # ck_sc
set_property -dict { PACKAGE_PIN F16   IOSTANDARD LVCMOS33 } [get_ports { racket_y_pos_o[0] }]; #most right   # ck_ss

## Switches, active low

set_property -dict { PACKAGE_PIN Y12   IOSTANDARD LVCMOS33 } [get_ports { n_blue_sw[7] }]; # most left     
set_property -dict { PACKAGE_PIN F20   IOSTANDARD LVCMOS33 } [get_ports { n_blue_sw[6] }];                
set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports { n_blue_sw[5] }];               
set_property -dict { PACKAGE_PIN B20   IOSTANDARD LVCMOS33 } [get_ports { n_blue_sw[4] }];               
set_property -dict { PACKAGE_PIN U10   IOSTANDARD LVCMOS33 } [get_ports { n_blue_sw[3] }];               
set_property -dict { PACKAGE_PIN A20   IOSTANDARD LVCMOS33 } [get_ports { n_blue_sw[2] }];
set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33 } [get_ports { n_blue_sw[1] }];               # ck_miso
set_property -dict { PACKAGE_PIN T12   IOSTANDARD LVCMOS33 } [get_ports { n_blue_sw[0] }]; #most right   # ck_mosi

## Seven Segment Displays, data is active low, enable is active high

set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { n_ssd_enable[7] }]; # most left   # ck_io[11]
set_property -dict { PACKAGE_PIN T16   IOSTANDARD LVCMOS33 } [get_ports { n_ssd_enable[6] }];               # ck_io[10]
set_property -dict { PACKAGE_PIN V18   IOSTANDARD LVCMOS33 } [get_ports { n_ssd_enable[5] }];               # ck_io[09]
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { n_ssd_enable[4] }];               # ck_io[08]
set_property -dict { PACKAGE_PIN U7    IOSTANDARD LVCMOS33 } [get_ports { n_ssd_enable[3] }];               # ck_io[29]
set_property -dict { PACKAGE_PIN V6    IOSTANDARD LVCMOS33 } [get_ports { n_ssd_enable[2] }];               # ck_io[28]
set_property -dict { PACKAGE_PIN V5    IOSTANDARD LVCMOS33 } [get_ports { n_ssd_enable[1] }];               # ck_io[27]
set_property -dict { PACKAGE_PIN U5    IOSTANDARD LVCMOS33 } [get_ports { n_ssd_enable[0] }]; #most right   # ck_io[26]

set_property -dict { PACKAGE_PIN R16     IOSTANDARD LVCMOS33 } [get_ports { n_ssd_data[7] }]; # a           # ck_io[06]
set_property -dict { PACKAGE_PIN T14     IOSTANDARD LVCMOS33 } [get_ports { n_ssd_data[6] }]; # b           # ck_io[02]
set_property -dict { PACKAGE_PIN U12     IOSTANDARD LVCMOS33 } [get_ports { n_ssd_data[5] }]; # c           # ck_io[01]
set_property -dict { PACKAGE_PIN T15     IOSTANDARD LVCMOS33 } [get_ports { n_ssd_data[4] }]; # d           # ck_io[05]
set_property -dict { PACKAGE_PIN U17     IOSTANDARD LVCMOS33 } [get_ports { n_ssd_data[3] }]; # e           # ck_io[07]
set_property -dict { PACKAGE_PIN V15     IOSTANDARD LVCMOS33 } [get_ports { n_ssd_data[2] }]; # f           # ck_io[04]
set_property -dict { PACKAGE_PIN U13     IOSTANDARD LVCMOS33 } [get_ports { n_ssd_data[1] }]; # g           # ck_io[00]
set_property -dict { PACKAGE_PIN V13     IOSTANDARD LVCMOS33 } [get_ports { n_ssd_data[0] }]; # dp          # ck_io[03]


## PS2 interface

set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { PS2_1_data }];  # SDA   
set_property -dict { PACKAGE_PIN Y13   IOSTANDARD LVCMOS33 } [get_ports { PS2_1_clk  }];  # ck_ioA
                                                                                          
set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { PS2_2_data }];  # io13
set_property -dict { PACKAGE_PIN P18   IOSTANDARD LVCMOS33 } [get_ports { PS2_2_clk  }];  # io12


#---------------------------------------#
#PMODC, just one set usable at the same time!!!

## PMODC

#set_property -dict { PACKAGE_PIN W8   IOSTANDARD LVCMOS33 } [get_ports { pmod_c[0] }];  
#set_property -dict { PACKAGE_PIN Y7   IOSTANDARD LVCMOS33 } [get_ports { pmod_c[1] }];  
#set_property -dict { PACKAGE_PIN Y8   IOSTANDARD LVCMOS33 } [get_ports { pmod_c[2] }];  
#set_property -dict { PACKAGE_PIN Y6   IOSTANDARD LVCMOS33 } [get_ports { pmod_c[3] }];  
#set_property -dict { PACKAGE_PIN W9   IOSTANDARD LVCMOS33 } [get_ports { pmod_c[4] }];  
#set_property -dict { PACKAGE_PIN W6   IOSTANDARD LVCMOS33 } [get_ports { pmod_c[5] }];  
#set_property -dict { PACKAGE_PIN V10  IOSTANDARD LVCMOS33 } [get_ports { pmod_c[6] }];  
#set_property -dict { PACKAGE_PIN W10  IOSTANDARD LVCMOS33 } [get_ports { pmod_c[7] }];  

## 10 Pin Connector
# A_MCK   	ck_io[30] V7
# A_CS    	ck_io[32] V8 
# A_SDIN  	ck_io[40] W9 
# A_DIN   	ck_io[38] W8 
# A_CLKOUT	ck_io[36] Y6 
# A_DOUT  	ck_io[34] W10 
# A_MODE  	ck_io[31] U8 
# A_SCLK  	ck_io[33] V10 
# A_BCLK  	ck_io[39] Y8 
# A_LRCIN 	ck_io[37] Y7 
# A_LRCOUT	ck_io[35] W6


## Audio-port

 set_property -dict { PACKAGE_PIN V7   IOSTANDARD LVCMOS33 } [get_ports { A_MCK    }]; # ck_io[30] 
 set_property -dict { PACKAGE_PIN V8   IOSTANDARD LVCMOS33 } [get_ports { A_CS     }]; # ck_io[32] 
 set_property -dict { PACKAGE_PIN W9   IOSTANDARD LVCMOS33 } [get_ports { A_SDIN   }]; # ck_io[40] 
 set_property -dict { PACKAGE_PIN W8   IOSTANDARD LVCMOS33 } [get_ports { A_DIN    }]; # ck_io[38] 
 set_property -dict { PACKAGE_PIN Y6   IOSTANDARD LVCMOS33 } [get_ports { A_CLKOUT }]; # ck_io[36] 
 set_property -dict { PACKAGE_PIN W10  IOSTANDARD LVCMOS33 } [get_ports { A_DOUT   }]; # ck_io[34] 
 set_property -dict { PACKAGE_PIN U8   IOSTANDARD LVCMOS33 } [get_ports { A_MODE   }]; # ck_io[31] 
 set_property -dict { PACKAGE_PIN V10  IOSTANDARD LVCMOS33 } [get_ports { A_SCLK   }]; # ck_io[33]
 set_property -dict { PACKAGE_PIN Y8   IOSTANDARD LVCMOS33 } [get_ports { A_BCLK   }]; # ck_io[39]
 set_property -dict { PACKAGE_PIN Y7   IOSTANDARD LVCMOS33 } [get_ports { A_LRCIN  }]; # ck_io[37]
 set_property -dict { PACKAGE_PIN W6   IOSTANDARD LVCMOS33 } [get_ports { A_LRCOUT }]; # ck_io[35]
