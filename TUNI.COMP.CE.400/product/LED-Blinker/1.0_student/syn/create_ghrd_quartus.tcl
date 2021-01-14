# to execute this script using quartus_sh for generating Quartus QPF and QSF accordingly
#   quartus_sh --script=create_ghrd_quartus.tcl
#
set devicefamily CYCLONEV
set device 5CSXFC6D6F31C6
set projectname soc_system
# thinking to change project name to ghrd_5csxfc6d6, not yet agreed
set qipfiles "soc_system/synthesis/soc_system.qip,ip/altsource_probe/hps_reset.qip"
set hdlfiles "ip/edge_detect/altera_edge_detector.v,ip/debounce/debounce.v,ghrd_top.v"
set topname ghrd_top

# ... alternatively, above parameters can be passed in as script arguments
#   quartus_sh --script=create_ghrd_quartus.tcl <parameter1 value1 parameter2 value2 ...>
# parameters of this TCL includes
#   devicefamily  : FPGA device family
#   device        : FPGA device number
#   projectname   : Quartus project name
#   qipfiles      : QIP file path(s), multiple paths need seperator of ","
#   hdlfiles      : HDL file path(s), multiple paths need seperator of ","
#   topname       : top module name


proc show_arguments {} {
  global quartus
  global devicefamily
  global device
  global projectname
  global topname
  global qipfiles
  global hdlfiles

  foreach {key value} $quartus(args) {
    puts "-> Accepted parameter: $key,  \tValue: $value"
    if {$key == "devicefamily"} {
      set devicefamily $value
    }
    if {$key == "device"} {
      set device $value
    }
    if {$key == "projectname"} {
      set projectname $value
    }
    if {$key == "topname"} {
      set topname $value
    }
    if {$key == "qipfiles"} {
      set qipfiles $value
    }
    if {$key == "hdlfiles"} {
      set hdlfiles $value
    }

  }
}
show_arguments

#regsub -all {\mfoo\M} $string bar string
#set wordList [regexp -inline -all -- {\S+} $text]
if {[regexp {,} $qipfiles]} {
  set qipfilelist [split $qipfiles ,]
} else {
  set qipfilelist $qipfiles
}

if {[regexp {,} $hdlfiles]} {
  set hdlfilelist [split $hdlfiles ,]
} else {
  set hdlfilelist $hdlfiles
}

project_new -overwrite -family $devicefamily -part $device $projectname

set_global_assignment -name TOP_LEVEL_ENTITY $topname

foreach qipfile $qipfilelist {
  set_global_assignment -name QIP_FILE $qipfile
}

foreach hdlfile $hdlfilelist {
  set_global_assignment -name VERILOG_FILE $hdlfile
}

set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
set_global_assignment -name EDA_SIMULATION_TOOL "<None>"
set_global_assignment -name EDA_OUTPUT_DATA_FORMAT NONE -section_id eda_simulation
set_global_assignment -name SDC_FILE soc_system_timing.sdc

# enabling signaltap 
set_global_assignment -name ENABLE_SIGNALTAP ON
set_global_assignment -name USE_SIGNALTAP_FILE cti_tapping.stp
set_global_assignment -name SIGNALTAP_FILE cti_tapping.stp

# pin location assignments
set_location_assignment PIN_AC18 -to fpga_clk_50
set_location_assignment PIN_AB13 -to fpga_button_pio[1]
set_location_assignment PIN_AA13 -to fpga_button_pio[0]
set_location_assignment PIN_AG11 -to fpga_dipsw_pio[3]
set_location_assignment PIN_AF11 -to fpga_dipsw_pio[2]
set_location_assignment PIN_AH9 -to fpga_dipsw_pio[1]
set_location_assignment PIN_AG10 -to fpga_dipsw_pio[0]
set_location_assignment PIN_AB17 -to fpga_led_pio[3]
set_location_assignment PIN_W15 -to fpga_led_pio[2]
set_location_assignment PIN_Y16 -to fpga_led_pio[1]
set_location_assignment PIN_AK2 -to fpga_led_pio[0]

# instance assignments
set_instance_assignment -name IO_STANDARD "1.5 V" -to fpga_led_pio[0]
set_instance_assignment -name IO_STANDARD "1.5 V" -to fpga_led_pio[1]
set_instance_assignment -name IO_STANDARD "1.5 V" -to fpga_led_pio[2]
set_instance_assignment -name IO_STANDARD "1.5 V" -to fpga_led_pio[3]
set_instance_assignment -name IO_STANDARD "1.5 V" -to fpga_dipsw_pio[0]
set_instance_assignment -name IO_STANDARD "1.5 V" -to fpga_dipsw_pio[1]
set_instance_assignment -name IO_STANDARD "1.5 V" -to fpga_dipsw_pio[2]
set_instance_assignment -name IO_STANDARD "1.5 V" -to fpga_dipsw_pio[3]
set_instance_assignment -name IO_STANDARD "1.5 V" -to fpga_button_pio[0]
set_instance_assignment -name IO_STANDARD "1.5 V" -to fpga_button_pio[1]
set_instance_assignment -name IO_STANDARD "1.5 V" -to fpga_clk_50
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_can0_RX
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_can0_TX
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_emac1_MDC
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_emac1_MDIO
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_emac1_RXD0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_emac1_RXD1
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_emac1_RXD2
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_emac1_RXD3
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_emac1_RX_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_emac1_RX_CTL
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_emac1_TXD0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_emac1_TXD3
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_emac1_TXD1
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_emac1_TXD2
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_emac1_TX_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_emac1_TX_CTL
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_gpio_GPIO09
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_gpio_GPIO35
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_gpio_GPIO41
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_gpio_GPIO42
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_gpio_GPIO43
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_gpio_GPIO44
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_i2c0_SCL
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_i2c0_SDA
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_qspi_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_qspi_IO0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_qspi_IO1
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_qspi_IO2
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_qspi_IO3
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_qspi_SS0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_sdio_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_sdio_CMD
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_sdio_D0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_sdio_D1
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_sdio_D2
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_sdio_D3
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_spim0_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_spim0_MISO
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_spim0_MOSI
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_spim0_SS0
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to hps_trace_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to hps_trace_D0
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to hps_trace_D1
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to hps_trace_D2
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to hps_trace_D3
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to hps_trace_D4
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to hps_trace_D5
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to hps_trace_D6
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to hps_trace_D7
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_uart0_RX
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_uart0_TX
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_usb1_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_usb1_D0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_usb1_D1
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_usb1_D2
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_usb1_D3
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_usb1_D4
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_usb1_D5
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_usb1_D6
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_usb1_D7
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_usb1_DIR
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_usb1_NXT
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_usb1_STP
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac1_MDC
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac1_MDIO
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac1_RXD0
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac1_RXD1
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac1_RXD2
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac1_RXD3
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac1_RX_CLK
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac1_RX_CTL
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac1_TXD0
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac1_TXD1
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac1_TXD2
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac1_TXD3
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac1_TX_CLK
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac1_TX_CTL
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_usb1_CLK
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_usb1_D0
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_usb1_D1
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_usb1_D2
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_usb1_D3
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_usb1_D4
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_usb1_D5
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_usb1_D6
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_usb1_D7
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_usb1_DIR
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_usb1_NXT
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_usb1_STP
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_i2c0_SCL
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_i2c0_SDA
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_spim0_CLK
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_spim0_MISO
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_spim0_MOSI
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_spim0_SS0
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_can0_RX
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_can0_TX
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_gpio_GPIO35
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_trace_CLK
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_trace_D0
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_trace_D1
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_trace_D2
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_trace_D3
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_trace_D4
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_trace_D5
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_trace_D6
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_trace_D7
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_gpio_GPIO41
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_gpio_GPIO42
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_gpio_GPIO43
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_gpio_GPIO44
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_gpio_GPIO09
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_qspi_CLK
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_qspi_IO0
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_qspi_IO1
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_qspi_IO2
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_qspi_IO3
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_qspi_SS0
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_sdio_CLK
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_sdio_CMD
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_sdio_D0
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_sdio_D1
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_sdio_D2
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_sdio_D3
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_uart0_RX
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_uart0_TX
set_instance_assignment -name SLEW_RATE 1 -to hps_trace_CLK
set_instance_assignment -name SLEW_RATE 1 -to hps_trace_D0
set_instance_assignment -name SLEW_RATE 1 -to hps_trace_D1
set_instance_assignment -name SLEW_RATE 1 -to hps_trace_D2
set_instance_assignment -name SLEW_RATE 1 -to hps_trace_D3
set_instance_assignment -name SLEW_RATE 1 -to hps_trace_D4
set_instance_assignment -name SLEW_RATE 1 -to hps_trace_D5
set_instance_assignment -name SLEW_RATE 1 -to hps_trace_D6
set_instance_assignment -name SLEW_RATE 1 -to hps_trace_D7

set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

project_close

