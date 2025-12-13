# PL System Clock
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L13P_T2_MRCC_35 Sch=sysclk
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { clk }];#set





## Pmod Header JA
set_property -dict { PACKAGE_PIN Y19   IOSTANDARD LVCMOS33 } [get_ports { miso }];    # i_SPI_MISO
set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33 } [get_ports { sclk }];    # o_SPI_Clk
set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33 } [get_ports { ss_n[0] }]; # o_SPI_CS_n


# PMOD JB – segments a–g + digit select

set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports {als_data[0]}]
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33} [get_ports {als_data[1]}]
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports {als_data[2]}]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {als_data[3]}]
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports {als_data[4]}]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports {als_data[5]}]
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports {als_data[6]}]
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports {als_data[7]}]
set_property DRIVE 8 [get_ports {als_data[*]}]
set_property SLEW SLOW [get_ports {als_data[*]}]

# rst
set_property -dict { PACKAGE_PIN D20   IOSTANDARD LVCMOS33 } [get_ports { reset_n }]; #IO_L4N_T0_35 Sch=btn[0]
