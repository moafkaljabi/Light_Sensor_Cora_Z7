# PL System Clock
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L13P_T2_MRCC_35 Sch=sysclk
create_clock -add -name sys_clk_pin -period 20.00 -waveform {0 10} [get_ports { clk }]; # 50 MHz (adjust to 8.00 if using 125 MHz)

# Reset
set_property -dict { PACKAGE_PIN D20   IOSTANDARD LVCMOS33 } [get_ports { reset_n }]; #IO_L4N_T0_35 Sch=btn[0]

## Pmod Header JA (SPI to sensor)
set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33 } [get_ports { miso }];    # i_SPI_MISO , p2
set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33 } [get_ports { sclk }];    # o_SPI_Clk  , n2
set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { ss_n[0] }]; # o_SPI_CS_n , p1

# Pmod JB – 7-segment display (segments a–g + digit select)
# Assumes: seg_out[6:0] = a..g (JB1-JB7), digit_sel[1:0] = tens/ones enables (JB8-JB9, active LOW)
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports {seg_out[0]}];  # JB1: segment a
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33} [get_ports {seg_out[1]}];  # JB2: segment b
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports {seg_out[2]}];  # JB3: segment c
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {seg_out[3]}];  # JB4: segment d
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports {seg_out[4]}];  # JB7: segment e
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports {seg_out[5]}];  # JB8: segment f
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports {seg_out[6]}];  # JB9: segment g
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports {digit_sel[0]}]; # JB10: ones enable
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33} [get_ports {digit_sel[1]}]; # JB4? Wait, standard JB9 is V12 for g, adjust if needed; added for digit_sel[1]

# Drive/Slew for segments (optional, for reduced noise)
set_property DRIVE 8 [get_ports {seg_out[*]}];
set_property SLEW SLOW [get_ports {seg_out[*]}];