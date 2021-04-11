//-----------------------------------------------------------------------------
// File          : Kvazaar_IP_acc_Camera.v
// Creation date : 10.04.2021
// Creation time : 17:22:12
// Description   : 
// Created by    : 
// Tool : Kactus2 3.5.84 32-bit
// Plugin : Verilog generator 2.1
// This file was generated based on IP-XACT component TUNI.fi:product:Kvazaar_IP_acc_Camera:1.0_student
// whose XML file is P:/shared_p/5/TUNI.fi/product/Kvazaar_IP_acc_Camera/1.0_student/k2u_Kvazaar_IP_acc_Camera.1.0_student.xml
//-----------------------------------------------------------------------------

module Kvazaar_IP_acc_Camera(
    // Interface: CCD_data
    input          [11:0]               CAMERA_D,
    input                               CAMERA_FVAL,
    input                               CAMERA_LVAL,

    // Interface: HPS_connection
    input                               can_0_rx,
    input                               ddr3_hps_rzq,
    input                               enet_hps_rx_clk,
    input                               enet_hps_rx_dv,
    input          [3:0]                enet_hps_rxd,
    input                               spi_miso,
    input                               uart_rx,
    input                               usb_clk,
    input                               usb_dir,
    input                               usb_nxt,
    output                              can_0_tx,
    output         [14:0]               ddr3_hps_a,
    output         [2:0]                ddr3_hps_ba,
    output                              ddr3_hps_casn,
    output                              ddr3_hps_cke,
    output                              ddr3_hps_clk_n,
    output                              ddr3_hps_clk_p,
    output                              ddr3_hps_csn,
    output         [4:0]                ddr3_hps_dm,
    output                              ddr3_hps_odt,
    output                              ddr3_hps_rasn,
    output                              ddr3_hps_resetn,
    output                              ddr3_hps_wen,
    output                              enet_hps_gtx_clk,
    output                              enet_hps_mdc,
    output                              enet_hps_tx_en,
    output         [3:0]                enet_hps_txd,
    output                              qspi_clk,
    output                              qspi_ss0,
    output                              sd_clk,
    output                              spi_csn,
    output                              spi_mosi,
    output                              spi_sck,
    output                              trace_clk_mic,
    output         [7:0]                trace_data,
    output                              uart_tx,
    output                              usb_stp,
    inout          [39:0]               ddr3_hps_dq,
    inout          [4:0]                ddr3_hps_dqs_n,
    inout          [4:0]                ddr3_hps_dqs_p,
    inout                               enet_hps_intn,
    inout                               enet_hps_mdio,
    inout                               gpio09,
    inout                               i2c_scl_hps,
    inout                               i2c_sda_hps,
    inout          [3:0]                qspi_io,
    inout                               sd_cmd,
    inout          [3:0]                sd_dat,
    inout          [7:0]                usb_data,
    inout          [3:0]                user_led_hps,

    // Interface: LCD
    output         [7:0]                LCD_B,
    output                              LCD_DCLK,
    output                              LCD_DIM,
    output         [7:0]                LCD_G,
    output                              LCD_HSD,
    output                              LCD_MODE,
    output                              LCD_POWER_CTL,
    output         [7:0]                LCD_R,
    output                              LCD_RSTB,
    output                              LCD_SHLR,
    output                              LCD_UPDN,
    output                              LCD_VSD,

    // Interface: clock_25MHz
    output                              CAMERA_RESET_n,
    output                              CAMERA_XCLKIN,

    // Interface: clock_50MHz
    input                               clk_50m_fpga,

    // Interface: clock_camera
    input                               CAMERA_PIXCLK,

    // Interface: dip_switch
    input          [3:0]                user_dipsw_fpga,

    // Interface: i2c_data
    output                              CAMERA_SCLK,
    inout                               CAMERA_SDATA,

    // Interface: push_buttons
    input          [1:0]                user_pb_fpga,

    // These ports are not in any interface
    output                              CAMERA_TRIGGER
);

// WARNING: EVERYTHING ON AND ABOVE THIS LINE MAY BE OVERWRITTEN BY KACTUS2!!!

    // Clock_Reset_0_clock_25MHz_to_clock_25MHz wires:
    wire        Clock_Reset_0_clock_25MHz_to_clock_25MHzCLK;
    wire        Clock_Reset_0_clock_25MHz_to_clock_25MHzRST_N;
    // Clock_Reset_0_clock_50MHz_ref_to_clock_50MHz wires:
    wire        Clock_Reset_0_clock_50MHz_ref_to_clock_50MHzCLK;
    // Clock_Reset_0_clock_camera_ref_to_clock_camera wires:
    wire        Clock_Reset_0_clock_camera_ref_to_clock_cameraCLK;
    // Clock_Reset_0_push_buttons_to_push_buttons wires:
    wire [1:0]  Clock_Reset_0_push_buttons_to_push_buttonsUSER_PB_FPGA;
    // Kvazaar_QSYS_0_dip_switch_to_dip_switch wires:
    wire [3:0]  Kvazaar_QSYS_0_dip_switch_to_dip_switchUSER_DIPSW_FPGA;
    // Kvazaar_QSYS_0_HPS_connection_to_HPS_connection wires:
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_CAN0_INST_RX;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_CAN0_INST_TX;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_MDC;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_RXD0;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_RXD1;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_RXD2;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_RXD3;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_RX_CLK;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_RX_CTL;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_TXD0;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_TXD1;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_TXD2;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_TXD3;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_TX_CLK;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_TX_CTL;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_QSPI_INST_CLK;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_QSPI_INST_SS0;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_SDIO_INST_CLK;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_SPIM0_INST_CLK;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_SPIM0_INST_MISO;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_SPIM0_INST_MOSI;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_SPIM0_INST_SS0;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_CLK;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D0;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D1;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D2;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D3;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D4;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D5;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D6;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D7;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_UART0_INST_RX;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_UART0_INST_TX;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_USB1_INST_CLK;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_USB1_INST_DIR;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_USB1_INST_NXT;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_USB1_INST_STP;
    wire [14:0] Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_A;
    wire [2:0]  Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_BA;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_CAS_N;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_CK;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_CKE;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_CK_N;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_CS_N;
    wire [4:0]  Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_DM;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_ODT;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_RAS_N;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_RESET_N;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_WE_N;
    wire        Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_OCT_RZQIN;
    // Clock_Reset_0_clock_75MHz_to_Kvazaar_QSYS_0_clock_75MHz wires:
    wire        Clock_Reset_0_clock_75MHz_to_Kvazaar_QSYS_0_clock_75MHzCLK;
    wire        Clock_Reset_0_clock_75MHz_to_Kvazaar_QSYS_0_clock_75MHzRST_N;
    // Clock_Reset_0_clock_camera_to_Kvazaar_QSYS_0_clock_camera wires:
    wire        Clock_Reset_0_clock_camera_to_Kvazaar_QSYS_0_clock_cameraCLK;
    wire        Clock_Reset_0_clock_camera_to_Kvazaar_QSYS_0_clock_cameraRST_N;
    // Kvazaar_QSYS_0_orig_channel_to_IP_SAD_Accelerator_0_orig_channel wires:
    wire [31:0] Kvazaar_QSYS_0_orig_channel_to_IP_SAD_Accelerator_0_orig_channelCHANNEL_DATA;
    wire        Kvazaar_QSYS_0_orig_channel_to_IP_SAD_Accelerator_0_orig_channelCHANNEL_LZ;
    wire        Kvazaar_QSYS_0_orig_channel_to_IP_SAD_Accelerator_0_orig_channelCHANNEL_VZ;
    // Kvazaar_QSYS_0_config_channel_to_IP_SAD_Accelerator_0_config_channel wires:
    wire [31:0] Kvazaar_QSYS_0_config_channel_to_IP_SAD_Accelerator_0_config_channelCHANNEL_DATA;
    wire        Kvazaar_QSYS_0_config_channel_to_IP_SAD_Accelerator_0_config_channelCHANNEL_LZ;
    wire        Kvazaar_QSYS_0_config_channel_to_IP_SAD_Accelerator_0_config_channelCHANNEL_VZ;
    // Kvazaar_QSYS_0_top_ref_channel_to_IP_SAD_Accelerator_0_top_ref_channel wires:
    wire [15:0] Kvazaar_QSYS_0_top_ref_channel_to_IP_SAD_Accelerator_0_top_ref_channelCHANNEL_DATA;
    wire        Kvazaar_QSYS_0_top_ref_channel_to_IP_SAD_Accelerator_0_top_ref_channelCHANNEL_LZ;
    wire        Kvazaar_QSYS_0_top_ref_channel_to_IP_SAD_Accelerator_0_top_ref_channelCHANNEL_VZ;
    // Kvazaar_QSYS_0_left_ref_channel_to_IP_SAD_Accelerator_0_left_ref_channel wires:
    wire [15:0] Kvazaar_QSYS_0_left_ref_channel_to_IP_SAD_Accelerator_0_left_ref_channelCHANNEL_DATA;
    wire        Kvazaar_QSYS_0_left_ref_channel_to_IP_SAD_Accelerator_0_left_ref_channelCHANNEL_LZ;
    wire        Kvazaar_QSYS_0_left_ref_channel_to_IP_SAD_Accelerator_0_left_ref_channelCHANNEL_VZ;
    // Kvazaar_QSYS_0_sad_result_to_IP_SAD_Accelerator_0_sad_result wires:
    wire [63:0] Kvazaar_QSYS_0_sad_result_to_IP_SAD_Accelerator_0_sad_resultSAD_RESULT;
    // Kvazaar_QSYS_0_camera_start_config_to_CCD_Configer_0_camera_start_config wires:
    wire        Kvazaar_QSYS_0_camera_start_config_to_CCD_Configer_0_camera_start_configCONFIGURE_CAMERA_EXTERNAL_CONNECTION_EXPORT;
    // Kvazaar_QSYS_0_y_channel_to_RGB_to_YUV_0_y_channel wires:
    wire [7:0]  Kvazaar_QSYS_0_y_channel_to_RGB_to_YUV_0_y_channelCHANNEL_DATA;
    wire        Kvazaar_QSYS_0_y_channel_to_RGB_to_YUV_0_y_channelCHANNEL_LZ;
    wire        Kvazaar_QSYS_0_y_channel_to_RGB_to_YUV_0_y_channelCHANNEL_VZ;
    // Kvazaar_QSYS_0_yuv_ctrl_to_RGB_to_YUV_0_yuv_ctrl wires:
    wire [3:0]  Kvazaar_QSYS_0_yuv_ctrl_to_RGB_to_YUV_0_yuv_ctrlctrl;
    wire        Kvazaar_QSYS_0_yuv_ctrl_to_RGB_to_YUV_0_yuv_ctrldone;
    // CCD_Configer_0_camera_config_to_Kvazaar_QSYS_0_camera_config wires:
    wire [5:0]  CCD_Configer_0_camera_config_to_Kvazaar_QSYS_0_camera_configCAMERA_CONTROL_OC_S2_ADDRESS;
    wire [1:0]  CCD_Configer_0_camera_config_to_Kvazaar_QSYS_0_camera_configCAMERA_CONTROL_OC_S2_BYTEENABLE;
    wire        CCD_Configer_0_camera_config_to_Kvazaar_QSYS_0_camera_configCAMERA_CONTROL_OC_S2_CHIPSELECT;
    wire        CCD_Configer_0_camera_config_to_Kvazaar_QSYS_0_camera_configCAMERA_CONTROL_OC_S2_CLKEN;
    wire [15:0] CCD_Configer_0_camera_config_to_Kvazaar_QSYS_0_camera_configCAMERA_CONTROL_OC_S2_READDATA;
    wire        CCD_Configer_0_camera_config_to_Kvazaar_QSYS_0_camera_configCAMERA_CONTROL_OC_S2_WRITE;
    wire [15:0] CCD_Configer_0_camera_config_to_Kvazaar_QSYS_0_camera_configCAMERA_CONTROL_OC_S2_WRITEDATA;
    // CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_config wires:
    wire [15:0] CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configBLUE_GAIN;
    wire [15:0] CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configGREEN1_GAIN;
    wire [15:0] CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configGREEN2_GAIN;
    wire [15:0] CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configRED_GAIN;
    wire [15:0] CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_COLUMN_MODE;
    wire [15:0] CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_COLUMN_SIZE;
    wire [15:0] CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_EXPOSURE;
    wire [15:0] CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_ROW_MODE;
    wire [15:0] CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_ROW_SIZE;
    wire [15:0] CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_START_COLUMN;
    wire [15:0] CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_START_ROW;
    wire        CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSET_CONF;
    // Kvazaar_QSYS_0_v_channel_to_RGB_to_YUV_0_v_channel wires:
    wire [7:0]  Kvazaar_QSYS_0_v_channel_to_RGB_to_YUV_0_v_channelCHANNEL_DATA;
    wire        Kvazaar_QSYS_0_v_channel_to_RGB_to_YUV_0_v_channelCHANNEL_LZ;
    wire        Kvazaar_QSYS_0_v_channel_to_RGB_to_YUV_0_v_channelCHANNEL_VZ;
    // Kvazaar_QSYS_0_u_channel_to_RGB_to_YUV_0_u_channel wires:
    wire [7:0]  Kvazaar_QSYS_0_u_channel_to_RGB_to_YUV_0_u_channelCHANNEL_DATA;
    wire        Kvazaar_QSYS_0_u_channel_to_RGB_to_YUV_0_u_channelCHANNEL_LZ;
    wire        Kvazaar_QSYS_0_u_channel_to_RGB_to_YUV_0_u_channelCHANNEL_VZ;
    // CCD_Capture_0_CCD_data_to_CCD_data wires:
    wire [11:0] CCD_Capture_0_CCD_data_to_CCD_dataIDATA;
    wire        CCD_Capture_0_CCD_data_to_CCD_dataIFVAL;
    wire        CCD_Capture_0_CCD_data_to_CCD_dataILVAL;
    // CCD_Configer_I2C_0_I2C_data_to_i2c_data wires:
    wire        CCD_Configer_I2C_0_I2C_data_to_i2c_dataCAMERA_SCLK;
    // RAW_to_RGB_0_RAW_data_to_CCD_Capture_0_RAW_data wires:
    wire [11:0] RAW_to_RGB_0_RAW_data_to_CCD_Capture_0_RAW_dataIDATA;
    wire        RAW_to_RGB_0_RAW_data_to_CCD_Capture_0_RAW_dataIDVAL;
    wire [15:0] RAW_to_RGB_0_RAW_data_to_CCD_Capture_0_RAW_dataIX_CONT;
    wire [15:0] RAW_to_RGB_0_RAW_data_to_CCD_Capture_0_RAW_dataIY_CONT;
    // RAW_to_RGB_0_RGB_data_to_LTP_Controller_0_RGB_data wires:
    wire [11:0] RAW_to_RGB_0_RGB_data_to_LTP_Controller_0_RGB_dataOBLUE;
    wire        RAW_to_RGB_0_RGB_data_to_LTP_Controller_0_RGB_dataODVAL;
    wire [11:0] RAW_to_RGB_0_RGB_data_to_LTP_Controller_0_RGB_dataOGREEN;
    wire [11:0] RAW_to_RGB_0_RGB_data_to_LTP_Controller_0_RGB_dataORED;
    // LTP_Controller_0_LCD_to_LCD wires:
    wire [7:0]  LTP_Controller_0_LCD_to_LCDLCD_B;
    wire        LTP_Controller_0_LCD_to_LCDLCD_DCLK;
    wire        LTP_Controller_0_LCD_to_LCDLCD_DIM;
    wire [7:0]  LTP_Controller_0_LCD_to_LCDLCD_G;
    wire        LTP_Controller_0_LCD_to_LCDLCD_HSD;
    wire        LTP_Controller_0_LCD_to_LCDLCD_MODE;
    wire        LTP_Controller_0_LCD_to_LCDLCD_POWER_CTL;
    wire [7:0]  LTP_Controller_0_LCD_to_LCDLCD_R;
    wire        LTP_Controller_0_LCD_to_LCDLCD_RSTB;
    wire        LTP_Controller_0_LCD_to_LCDLCD_SHLR;
    wire        LTP_Controller_0_LCD_to_LCDLCD_UPDN;
    wire        LTP_Controller_0_LCD_to_LCDLCD_VSD;
    // Clock_Reset_0_clock_33MHz_to_LTP_Controller_0_clock_33MHz wires:
    wire        Clock_Reset_0_clock_33MHz_to_LTP_Controller_0_clock_33MHzCLK;
    wire        Clock_Reset_0_clock_33MHz_to_LTP_Controller_0_clock_33MHzRST_N;

    // Ad-hoc wires:
    wire        Kvazaar_QSYS_0_axi_dma_unfiltered1_clear_fifo_export_to_IP_SAD_Accelerator_0_clear_unfilt1_fifo;
    wire        Kvazaar_QSYS_0_axi_dma_unfiltered2_clear_fifo_export_to_IP_SAD_Accelerator_0_clear_unfilt2_fifo;
    wire        Kvazaar_QSYS_0_axi_dma_orig_block_clear_fifo_export_to_IP_SAD_Accelerator_0_clear_orig_fifo;
    wire [1:0]  Kvazaar_QSYS_0_result_ready_external_connection_export_to_IP_SAD_Accelerator_0_result_ready;
    wire        Kvazaar_QSYS_0_lcu_loaded_external_connection_export_to_IP_SAD_Accelerator_0_lcu_loaded;
    wire        Kvazaar_QSYS_0_lambda_loaded_external_connection_export_to_IP_SAD_Accelerator_0_lambda_loaded;

    // CCD_Capture_0 port wires:
    wire        CCD_Capture_0_iCLK;
    wire [11:0] CCD_Capture_0_iDATA;
    wire        CCD_Capture_0_iFVAL;
    wire        CCD_Capture_0_iLVAL;
    wire        CCD_Capture_0_iRST;
    wire [11:0] CCD_Capture_0_oDATA;
    wire        CCD_Capture_0_oDVAL;
    wire [15:0] CCD_Capture_0_oX_Cont;
    wire [15:0] CCD_Capture_0_oY_Cont;
    // CCD_Configer_0 port wires:
    wire [15:0] CCD_Configer_0_blue_gain;
    wire [5:0]  CCD_Configer_0_camera_control_oc_address;
    wire [15:0] CCD_Configer_0_camera_control_oc_data_in;
    wire        CCD_Configer_0_clk;
    wire        CCD_Configer_0_exposure_less;
    wire        CCD_Configer_0_exposure_more;
    wire [15:0] CCD_Configer_0_green1_gain;
    wire [15:0] CCD_Configer_0_green2_gain;
    wire        CCD_Configer_0_read_confs;
    wire [15:0] CCD_Configer_0_red_gain;
    wire        CCD_Configer_0_rst_n;
    wire [15:0] CCD_Configer_0_sensor_column_mode;
    wire [15:0] CCD_Configer_0_sensor_column_size;
    wire [15:0] CCD_Configer_0_sensor_exposure;
    wire [15:0] CCD_Configer_0_sensor_row_mode;
    wire [15:0] CCD_Configer_0_sensor_row_size;
    wire [15:0] CCD_Configer_0_sensor_start_column;
    wire [15:0] CCD_Configer_0_sensor_start_row;
    wire        CCD_Configer_0_set_conf;
    // CCD_Configer_I2C_0 port wires:
    wire        CCD_Configer_I2C_0_I2C_SCLK;
    wire        CCD_Configer_I2C_0_iCLK;
    wire        CCD_Configer_I2C_0_iMIRROR_SW;
    wire        CCD_Configer_I2C_0_iRST_N;
    wire        CCD_Configer_I2C_0_iSetConf;
    wire [15:0] CCD_Configer_I2C_0_iblue_gain;
    wire [15:0] CCD_Configer_I2C_0_igreen1_gain;
    wire [15:0] CCD_Configer_I2C_0_igreen2_gain;
    wire [15:0] CCD_Configer_I2C_0_ired_gain;
    wire [15:0] CCD_Configer_I2C_0_sensor_column_mode;
    wire [15:0] CCD_Configer_I2C_0_sensor_column_size;
    wire [15:0] CCD_Configer_I2C_0_sensor_exposure;
    wire [15:0] CCD_Configer_I2C_0_sensor_row_mode;
    wire [15:0] CCD_Configer_I2C_0_sensor_row_size;
    wire [15:0] CCD_Configer_I2C_0_sensor_start_column;
    wire [15:0] CCD_Configer_I2C_0_sensor_start_row;
    // Clock_Reset_0 port wires:
    wire        Clock_Reset_0_cameraclk;
    wire        Clock_Reset_0_fpga_pb_1;
    wire        Clock_Reset_0_fpga_pb_2;
    wire        Clock_Reset_0_outclk_0;
    wire        Clock_Reset_0_outclk_1;
    wire        Clock_Reset_0_outclk_2;
    wire        Clock_Reset_0_outclk_3;
    wire        Clock_Reset_0_refclk;
    wire        Clock_Reset_0_rst_n_0;
    wire        Clock_Reset_0_rst_n_1;
    wire        Clock_Reset_0_rst_n_2;
    wire        Clock_Reset_0_rst_n_3;
    // IP_SAD_Accelerator_0 port wires:
    wire        IP_SAD_Accelerator_0_arst_n;
    wire        IP_SAD_Accelerator_0_clear_orig_fifo;
    wire        IP_SAD_Accelerator_0_clear_unfilt1_fifo;
    wire        IP_SAD_Accelerator_0_clear_unfilt2_fifo;
    wire        IP_SAD_Accelerator_0_clk;
    wire        IP_SAD_Accelerator_0_ip_config_in_lz;
    wire        IP_SAD_Accelerator_0_ip_config_in_vz;
    wire [31:0] IP_SAD_Accelerator_0_ip_config_in_z;
    wire        IP_SAD_Accelerator_0_lambda_loaded;
    wire        IP_SAD_Accelerator_0_lcu_loaded;
    wire        IP_SAD_Accelerator_0_orig_block_data_in_lz;
    wire        IP_SAD_Accelerator_0_orig_block_data_in_vz;
    wire [31:0] IP_SAD_Accelerator_0_orig_block_data_in_z;
    wire [1:0]  IP_SAD_Accelerator_0_result_ready;
    wire [63:0] IP_SAD_Accelerator_0_sad_result;
    wire        IP_SAD_Accelerator_0_unfiltered1_lz;
    wire        IP_SAD_Accelerator_0_unfiltered1_vz;
    wire [15:0] IP_SAD_Accelerator_0_unfiltered1_z;
    wire        IP_SAD_Accelerator_0_unfiltered2_lz;
    wire        IP_SAD_Accelerator_0_unfiltered2_vz;
    wire [15:0] IP_SAD_Accelerator_0_unfiltered2_z;
    // Kvazaar_QSYS_0 port wires:
    wire [31:0] Kvazaar_QSYS_0_acc_config_channel_data;
    wire        Kvazaar_QSYS_0_acc_config_channel_lz;
    wire        Kvazaar_QSYS_0_acc_config_channel_vz;
    wire [31:0] Kvazaar_QSYS_0_axi_dma_orig_block_channel_data_export;
    wire        Kvazaar_QSYS_0_axi_dma_orig_block_channel_lz_export;
    wire        Kvazaar_QSYS_0_axi_dma_orig_block_channel_vz_export;
    wire        Kvazaar_QSYS_0_axi_dma_orig_block_clear_fifo_export;
    wire [15:0] Kvazaar_QSYS_0_axi_dma_unfiltered1_channel_data_export;
    wire        Kvazaar_QSYS_0_axi_dma_unfiltered1_channel_lz_export;
    wire        Kvazaar_QSYS_0_axi_dma_unfiltered1_channel_vz_export;
    wire        Kvazaar_QSYS_0_axi_dma_unfiltered1_clear_fifo_export;
    wire [15:0] Kvazaar_QSYS_0_axi_dma_unfiltered2_channel_data_export;
    wire        Kvazaar_QSYS_0_axi_dma_unfiltered2_channel_lz_export;
    wire        Kvazaar_QSYS_0_axi_dma_unfiltered2_channel_vz_export;
    wire        Kvazaar_QSYS_0_axi_dma_unfiltered2_clear_fifo_export;
    wire [5:0]  Kvazaar_QSYS_0_camera_control_oc_s2_address;
    wire [1:0]  Kvazaar_QSYS_0_camera_control_oc_s2_byteenable;
    wire        Kvazaar_QSYS_0_camera_control_oc_s2_chipselect;
    wire        Kvazaar_QSYS_0_camera_control_oc_s2_clken;
    wire [15:0] Kvazaar_QSYS_0_camera_control_oc_s2_readdata;
    wire        Kvazaar_QSYS_0_camera_control_oc_s2_write;
    wire [15:0] Kvazaar_QSYS_0_camera_control_oc_s2_writedata;
    wire        Kvazaar_QSYS_0_clk_clk;
    wire        Kvazaar_QSYS_0_configure_camera_external_connection_export;
    wire        Kvazaar_QSYS_0_dma_yuv_fifo_clk_clk;
    wire        Kvazaar_QSYS_0_dma_yuv_yuv_input_u_data_in_lz;
    wire        Kvazaar_QSYS_0_dma_yuv_yuv_input_u_data_in_vz;
    wire [7:0]  Kvazaar_QSYS_0_dma_yuv_yuv_input_u_data_in_z;
    wire        Kvazaar_QSYS_0_dma_yuv_yuv_input_v_data_in_lz;
    wire        Kvazaar_QSYS_0_dma_yuv_yuv_input_v_data_in_vz;
    wire [7:0]  Kvazaar_QSYS_0_dma_yuv_yuv_input_v_data_in_z;
    wire        Kvazaar_QSYS_0_dma_yuv_yuv_input_y_data_in_lz;
    wire        Kvazaar_QSYS_0_dma_yuv_yuv_input_y_data_in_vz;
    wire [7:0]  Kvazaar_QSYS_0_dma_yuv_yuv_input_y_data_in_z;
    wire [27:0] Kvazaar_QSYS_0_hps_0_f2h_stm_hw_events_stm_hwevents;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_can0_inst_RX;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_can0_inst_TX;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_MDC;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_RXD0;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_RXD1;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_RXD2;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_RXD3;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_RX_CLK;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_RX_CTL;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_TXD0;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_TXD1;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_TXD2;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_TXD3;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_TX_CLK;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_TX_CTL;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_qspi_inst_CLK;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_qspi_inst_SS0;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_sdio_inst_CLK;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_spim0_inst_CLK;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_spim0_inst_MISO;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_spim0_inst_MOSI;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_spim0_inst_SS0;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_CLK;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D0;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D1;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D2;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D3;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D4;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D5;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D6;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D7;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_uart0_inst_RX;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_uart0_inst_TX;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_usb1_inst_CLK;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_usb1_inst_DIR;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_usb1_inst_NXT;
    wire        Kvazaar_QSYS_0_hps_0_hps_io_hps_io_usb1_inst_STP;
    wire        Kvazaar_QSYS_0_lambda_loaded_external_connection_export;
    wire        Kvazaar_QSYS_0_lcu_loaded_external_connection_export;
    wire [14:0] Kvazaar_QSYS_0_memory_mem_a;
    wire [2:0]  Kvazaar_QSYS_0_memory_mem_ba;
    wire        Kvazaar_QSYS_0_memory_mem_cas_n;
    wire        Kvazaar_QSYS_0_memory_mem_ck;
    wire        Kvazaar_QSYS_0_memory_mem_ck_n;
    wire        Kvazaar_QSYS_0_memory_mem_cke;
    wire        Kvazaar_QSYS_0_memory_mem_cs_n;
    wire [4:0]  Kvazaar_QSYS_0_memory_mem_dm;
    wire        Kvazaar_QSYS_0_memory_mem_odt;
    wire        Kvazaar_QSYS_0_memory_mem_ras_n;
    wire        Kvazaar_QSYS_0_memory_mem_reset_n;
    wire        Kvazaar_QSYS_0_memory_mem_we_n;
    wire        Kvazaar_QSYS_0_memory_oct_rzqin;
    wire        Kvazaar_QSYS_0_reset_reset_n;
    wire [1:0]  Kvazaar_QSYS_0_result_ready_external_connection_export;
    wire [31:0] Kvazaar_QSYS_0_sad_result_high_external_connection_export;
    wire [31:0] Kvazaar_QSYS_0_sad_result_low_external_connection_export;
    wire [3:0]  Kvazaar_QSYS_0_yuv_ctrl_external_connection_export;
    wire        Kvazaar_QSYS_0_yuv_status_external_connection_export;
    // LTP_Controller_0 port wires:
    wire [7:0]  LTP_Controller_0_LCD_blue;
    wire        LTP_Controller_0_LCD_clock;
    wire        LTP_Controller_0_LCD_dim;
    wire [7:0]  LTP_Controller_0_LCD_green;
    wire        LTP_Controller_0_LCD_mode;
    wire        LTP_Controller_0_LCD_power_ctl;
    wire [7:0]  LTP_Controller_0_LCD_red;
    wire        LTP_Controller_0_LCD_rstb;
    wire        LTP_Controller_0_LCD_shlr;
    wire        LTP_Controller_0_LCD_updn;
    wire [7:0]  LTP_Controller_0_blue_in;
    wire        LTP_Controller_0_clk;
    wire        LTP_Controller_0_fifo_in_clk;
    wire        LTP_Controller_0_fifo_write;
    wire [7:0]  LTP_Controller_0_green_in;
    wire        LTP_Controller_0_horizontal_sync;
    wire [7:0]  LTP_Controller_0_red_in;
    wire        LTP_Controller_0_rst_n;
    wire        LTP_Controller_0_vertical_sync;
    // RAW_to_RGB_0 port wires:
    wire        RAW_to_RGB_0_iCLK;
    wire [11:0] RAW_to_RGB_0_iData;
    wire        RAW_to_RGB_0_iDval;
    wire        RAW_to_RGB_0_iMIRROR;
    wire        RAW_to_RGB_0_iRST_n;
    wire [15:0] RAW_to_RGB_0_iX_Cont;
    wire [15:0] RAW_to_RGB_0_iY_Cont;
    wire [11:0] RAW_to_RGB_0_oBlue;
    wire        RAW_to_RGB_0_oDval;
    wire [11:0] RAW_to_RGB_0_oGreen;
    wire [11:0] RAW_to_RGB_0_oRed;
    // RGB_to_YUV_0 port wires:
    wire        RGB_to_YUV_0_clk;
    wire        RGB_to_YUV_0_frame_valid;
    wire [7:0]  RGB_to_YUV_0_iBlue_z;
    wire        RGB_to_YUV_0_iDval_z;
    wire [7:0]  RGB_to_YUV_0_iGreen_z;
    wire [7:0]  RGB_to_YUV_0_iRed_z;
    wire        RGB_to_YUV_0_oU_lz;
    wire        RGB_to_YUV_0_oU_vz;
    wire [7:0]  RGB_to_YUV_0_oU_z;
    wire        RGB_to_YUV_0_oV_lz;
    wire        RGB_to_YUV_0_oV_vz;
    wire [7:0]  RGB_to_YUV_0_oV_z;
    wire        RGB_to_YUV_0_oY_lz;
    wire        RGB_to_YUV_0_oY_vz;
    wire [7:0]  RGB_to_YUV_0_oY_z;
    wire        RGB_to_YUV_0_rst_n;
    wire        RGB_to_YUV_0_write_done;
    wire [3:0]  RGB_to_YUV_0_yuv_ctrl;

    // Assignments for the ports of the encompassing component:
    assign CCD_Capture_0_CCD_data_to_CCD_dataIDATA[11:0] = CAMERA_D[11:0];
    assign CCD_Capture_0_CCD_data_to_CCD_dataIFVAL = CAMERA_FVAL;
    assign CCD_Capture_0_CCD_data_to_CCD_dataILVAL = CAMERA_LVAL;
    assign Clock_Reset_0_clock_camera_ref_to_clock_cameraCLK = CAMERA_PIXCLK;
    assign CAMERA_RESET_n = Clock_Reset_0_clock_25MHz_to_clock_25MHzRST_N;
    assign CAMERA_SCLK = CCD_Configer_I2C_0_I2C_data_to_i2c_dataCAMERA_SCLK;
    assign CAMERA_TRIGGER = 1;
    assign CAMERA_XCLKIN = Clock_Reset_0_clock_25MHz_to_clock_25MHzCLK;
    assign LCD_B[7:0] = LTP_Controller_0_LCD_to_LCDLCD_B[7:0];
    assign LCD_DCLK = LTP_Controller_0_LCD_to_LCDLCD_DCLK;
    assign LCD_DIM = LTP_Controller_0_LCD_to_LCDLCD_DIM;
    assign LCD_G[7:0] = LTP_Controller_0_LCD_to_LCDLCD_G[7:0];
    assign LCD_HSD = LTP_Controller_0_LCD_to_LCDLCD_HSD;
    assign LCD_MODE = LTP_Controller_0_LCD_to_LCDLCD_MODE;
    assign LCD_POWER_CTL = LTP_Controller_0_LCD_to_LCDLCD_POWER_CTL;
    assign LCD_R[7:0] = LTP_Controller_0_LCD_to_LCDLCD_R[7:0];
    assign LCD_RSTB = LTP_Controller_0_LCD_to_LCDLCD_RSTB;
    assign LCD_SHLR = LTP_Controller_0_LCD_to_LCDLCD_SHLR;
    assign LCD_UPDN = LTP_Controller_0_LCD_to_LCDLCD_UPDN;
    assign LCD_VSD = LTP_Controller_0_LCD_to_LCDLCD_VSD;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_CAN0_INST_RX = can_0_rx;
    assign can_0_tx = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_CAN0_INST_TX;
    assign Clock_Reset_0_clock_50MHz_ref_to_clock_50MHzCLK = clk_50m_fpga;
    assign ddr3_hps_a[14:0] = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_A[14:0];
    assign ddr3_hps_ba[2:0] = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_BA[2:0];
    assign ddr3_hps_casn = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_CAS_N;
    assign ddr3_hps_cke = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_CKE;
    assign ddr3_hps_clk_n = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_CK_N;
    assign ddr3_hps_clk_p = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_CK;
    assign ddr3_hps_csn = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_CS_N;
    assign ddr3_hps_dm[4:0] = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_DM[4:0];
    assign ddr3_hps_odt = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_ODT;
    assign ddr3_hps_rasn = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_RAS_N;
    assign ddr3_hps_resetn = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_RESET_N;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_OCT_RZQIN = ddr3_hps_rzq;
    assign ddr3_hps_wen = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_WE_N;
    assign enet_hps_gtx_clk = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_TX_CLK;
    assign enet_hps_mdc = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_MDC;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_RX_CLK = enet_hps_rx_clk;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_RX_CTL = enet_hps_rx_dv;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_RXD0 = enet_hps_rxd[0];
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_RXD1 = enet_hps_rxd[1];
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_RXD2 = enet_hps_rxd[2];
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_RXD3 = enet_hps_rxd[3];
    assign enet_hps_tx_en = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_TX_CTL;
    assign enet_hps_txd[0] = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_TXD0;
    assign enet_hps_txd[1] = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_TXD1;
    assign enet_hps_txd[2] = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_TXD2;
    assign enet_hps_txd[3] = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_TXD3;
    assign qspi_clk = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_QSPI_INST_CLK;
    assign qspi_ss0 = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_QSPI_INST_SS0;
    assign sd_clk = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_SDIO_INST_CLK;
    assign spi_csn = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_SPIM0_INST_SS0;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_SPIM0_INST_MISO = spi_miso;
    assign spi_mosi = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_SPIM0_INST_MOSI;
    assign spi_sck = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_SPIM0_INST_CLK;
    assign trace_clk_mic = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_CLK;
    assign trace_data[0] = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D0;
    assign trace_data[1] = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D1;
    assign trace_data[2] = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D2;
    assign trace_data[3] = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D3;
    assign trace_data[4] = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D4;
    assign trace_data[5] = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D5;
    assign trace_data[6] = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D6;
    assign trace_data[7] = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D7;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_UART0_INST_RX = uart_rx;
    assign uart_tx = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_UART0_INST_TX;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_USB1_INST_CLK = usb_clk;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_USB1_INST_DIR = usb_dir;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_USB1_INST_NXT = usb_nxt;
    assign usb_stp = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_USB1_INST_STP;
    assign Kvazaar_QSYS_0_dip_switch_to_dip_switchUSER_DIPSW_FPGA[3:0] = user_dipsw_fpga[3:0];
    assign Clock_Reset_0_push_buttons_to_push_buttonsUSER_PB_FPGA[1:0] = user_pb_fpga[1:0];

    // CCD_Capture_0 assignments:
    assign CCD_Capture_0_iCLK = Clock_Reset_0_clock_camera_to_Kvazaar_QSYS_0_clock_cameraCLK;
    assign CCD_Capture_0_iDATA[11:0] = CCD_Capture_0_CCD_data_to_CCD_dataIDATA[11:0];
    assign CCD_Capture_0_iFVAL = CCD_Capture_0_CCD_data_to_CCD_dataIFVAL;
    assign CCD_Capture_0_iLVAL = CCD_Capture_0_CCD_data_to_CCD_dataILVAL;
    assign CCD_Capture_0_iRST = Clock_Reset_0_clock_camera_to_Kvazaar_QSYS_0_clock_cameraRST_N;
    assign RAW_to_RGB_0_RAW_data_to_CCD_Capture_0_RAW_dataIDATA[11:0] = CCD_Capture_0_oDATA[11:0];
    assign RAW_to_RGB_0_RAW_data_to_CCD_Capture_0_RAW_dataIDVAL = CCD_Capture_0_oDVAL;
    assign RAW_to_RGB_0_RAW_data_to_CCD_Capture_0_RAW_dataIX_CONT[15:0] = CCD_Capture_0_oX_Cont[15:0];
    assign RAW_to_RGB_0_RAW_data_to_CCD_Capture_0_RAW_dataIY_CONT[15:0] = CCD_Capture_0_oY_Cont[15:0];
    // CCD_Configer_0 assignments:
    assign CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configBLUE_GAIN[15:0] = CCD_Configer_0_blue_gain[15:0];
    assign CCD_Configer_0_camera_config_to_Kvazaar_QSYS_0_camera_configCAMERA_CONTROL_OC_S2_ADDRESS[5:0] = CCD_Configer_0_camera_control_oc_address[5:0];
    assign CCD_Configer_0_camera_control_oc_data_in[15:0] = CCD_Configer_0_camera_config_to_Kvazaar_QSYS_0_camera_configCAMERA_CONTROL_OC_S2_READDATA[15:0];
    assign CCD_Configer_0_clk = Clock_Reset_0_clock_75MHz_to_Kvazaar_QSYS_0_clock_75MHzCLK;
    assign CCD_Configer_0_exposure_less = Clock_Reset_0_push_buttons_to_push_buttonsUSER_PB_FPGA[1];
    assign CCD_Configer_0_exposure_more = Clock_Reset_0_push_buttons_to_push_buttonsUSER_PB_FPGA[0];
    assign CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configGREEN1_GAIN[15:0] = CCD_Configer_0_green1_gain[15:0];
    assign CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configGREEN2_GAIN[15:0] = CCD_Configer_0_green2_gain[15:0];
    assign CCD_Configer_0_read_confs = Kvazaar_QSYS_0_camera_start_config_to_CCD_Configer_0_camera_start_configCONFIGURE_CAMERA_EXTERNAL_CONNECTION_EXPORT;
    assign CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configRED_GAIN[15:0] = CCD_Configer_0_red_gain[15:0];
    assign CCD_Configer_0_rst_n = Clock_Reset_0_clock_75MHz_to_Kvazaar_QSYS_0_clock_75MHzRST_N;
    assign CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_COLUMN_MODE[15:0] = CCD_Configer_0_sensor_column_mode[15:0];
    assign CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_COLUMN_SIZE[15:0] = CCD_Configer_0_sensor_column_size[15:0];
    assign CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_EXPOSURE[15:0] = CCD_Configer_0_sensor_exposure[15:0];
    assign CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_ROW_MODE[15:0] = CCD_Configer_0_sensor_row_mode[15:0];
    assign CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_ROW_SIZE[15:0] = CCD_Configer_0_sensor_row_size[15:0];
    assign CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_START_COLUMN[15:0] = CCD_Configer_0_sensor_start_column[15:0];
    assign CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_START_ROW[15:0] = CCD_Configer_0_sensor_start_row[15:0];
    assign CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSET_CONF = CCD_Configer_0_set_conf;
    // CCD_Configer_I2C_0 assignments:
    assign CCD_Configer_I2C_0_I2C_data_to_i2c_dataCAMERA_SCLK = CCD_Configer_I2C_0_I2C_SCLK;
    assign CCD_Configer_I2C_0_iCLK = Clock_Reset_0_clock_75MHz_to_Kvazaar_QSYS_0_clock_75MHzCLK;
    assign CCD_Configer_I2C_0_iMIRROR_SW = Kvazaar_QSYS_0_dip_switch_to_dip_switchUSER_DIPSW_FPGA[3];
    assign CCD_Configer_I2C_0_iRST_N = Clock_Reset_0_clock_75MHz_to_Kvazaar_QSYS_0_clock_75MHzRST_N;
    assign CCD_Configer_I2C_0_iSetConf = CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSET_CONF;
    assign CCD_Configer_I2C_0_iblue_gain[15:0] = CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configBLUE_GAIN[15:0];
    assign CCD_Configer_I2C_0_igreen1_gain[15:0] = CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configGREEN1_GAIN[15:0];
    assign CCD_Configer_I2C_0_igreen2_gain[15:0] = CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configGREEN2_GAIN[15:0];
    assign CCD_Configer_I2C_0_ired_gain[15:0] = CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configRED_GAIN[15:0];
    assign CCD_Configer_I2C_0_sensor_column_mode[15:0] = CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_COLUMN_MODE[15:0];
    assign CCD_Configer_I2C_0_sensor_column_size[15:0] = CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_COLUMN_SIZE[15:0];
    assign CCD_Configer_I2C_0_sensor_exposure[15:0] = CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_EXPOSURE[15:0];
    assign CCD_Configer_I2C_0_sensor_row_mode[15:0] = CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_ROW_MODE[15:0];
    assign CCD_Configer_I2C_0_sensor_row_size[15:0] = CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_ROW_SIZE[15:0];
    assign CCD_Configer_I2C_0_sensor_start_column[15:0] = CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_START_COLUMN[15:0];
    assign CCD_Configer_I2C_0_sensor_start_row[15:0] = CCD_Configer_0_CCD_config_to_CCD_Configer_I2C_0_CCD_configSENSOR_START_ROW[15:0];
    // Clock_Reset_0 assignments:
    assign Clock_Reset_0_cameraclk = Clock_Reset_0_clock_camera_ref_to_clock_cameraCLK;
    assign Clock_Reset_0_fpga_pb_1 = Clock_Reset_0_push_buttons_to_push_buttonsUSER_PB_FPGA[0];
    assign Clock_Reset_0_fpga_pb_2 = Clock_Reset_0_push_buttons_to_push_buttonsUSER_PB_FPGA[1];
    assign Clock_Reset_0_clock_25MHz_to_clock_25MHzCLK = Clock_Reset_0_outclk_0;
    assign Clock_Reset_0_clock_75MHz_to_Kvazaar_QSYS_0_clock_75MHzCLK = Clock_Reset_0_outclk_1;
    assign Clock_Reset_0_clock_33MHz_to_LTP_Controller_0_clock_33MHzCLK = Clock_Reset_0_outclk_2;
    assign Clock_Reset_0_clock_camera_to_Kvazaar_QSYS_0_clock_cameraCLK = Clock_Reset_0_outclk_3;
    assign Clock_Reset_0_refclk = Clock_Reset_0_clock_50MHz_ref_to_clock_50MHzCLK;
    assign Clock_Reset_0_clock_25MHz_to_clock_25MHzRST_N = Clock_Reset_0_rst_n_0;
    assign Clock_Reset_0_clock_75MHz_to_Kvazaar_QSYS_0_clock_75MHzRST_N = Clock_Reset_0_rst_n_1;
    assign Clock_Reset_0_clock_33MHz_to_LTP_Controller_0_clock_33MHzRST_N = Clock_Reset_0_rst_n_2;
    assign Clock_Reset_0_clock_camera_to_Kvazaar_QSYS_0_clock_cameraRST_N = Clock_Reset_0_rst_n_3;
    // IP_SAD_Accelerator_0 assignments:
    assign IP_SAD_Accelerator_0_arst_n = Clock_Reset_0_clock_75MHz_to_Kvazaar_QSYS_0_clock_75MHzRST_N;
    assign Kvazaar_QSYS_0_axi_dma_orig_block_clear_fifo_export_to_IP_SAD_Accelerator_0_clear_orig_fifo = IP_SAD_Accelerator_0_clear_orig_fifo;
    assign Kvazaar_QSYS_0_axi_dma_unfiltered1_clear_fifo_export_to_IP_SAD_Accelerator_0_clear_unfilt1_fifo = IP_SAD_Accelerator_0_clear_unfilt1_fifo;
    assign Kvazaar_QSYS_0_axi_dma_unfiltered2_clear_fifo_export_to_IP_SAD_Accelerator_0_clear_unfilt2_fifo = IP_SAD_Accelerator_0_clear_unfilt2_fifo;
    assign IP_SAD_Accelerator_0_clk = Clock_Reset_0_clock_75MHz_to_Kvazaar_QSYS_0_clock_75MHzCLK;
    assign Kvazaar_QSYS_0_config_channel_to_IP_SAD_Accelerator_0_config_channelCHANNEL_VZ = IP_SAD_Accelerator_0_ip_config_in_lz;
    assign IP_SAD_Accelerator_0_ip_config_in_vz = Kvazaar_QSYS_0_config_channel_to_IP_SAD_Accelerator_0_config_channelCHANNEL_LZ;
    assign IP_SAD_Accelerator_0_ip_config_in_z[31:0] = Kvazaar_QSYS_0_config_channel_to_IP_SAD_Accelerator_0_config_channelCHANNEL_DATA[31:0];
    assign Kvazaar_QSYS_0_lambda_loaded_external_connection_export_to_IP_SAD_Accelerator_0_lambda_loaded = IP_SAD_Accelerator_0_lambda_loaded;
    assign Kvazaar_QSYS_0_lcu_loaded_external_connection_export_to_IP_SAD_Accelerator_0_lcu_loaded = IP_SAD_Accelerator_0_lcu_loaded;
    assign Kvazaar_QSYS_0_orig_channel_to_IP_SAD_Accelerator_0_orig_channelCHANNEL_VZ = IP_SAD_Accelerator_0_orig_block_data_in_lz;
    assign IP_SAD_Accelerator_0_orig_block_data_in_vz = Kvazaar_QSYS_0_orig_channel_to_IP_SAD_Accelerator_0_orig_channelCHANNEL_LZ;
    assign IP_SAD_Accelerator_0_orig_block_data_in_z[31:0] = Kvazaar_QSYS_0_orig_channel_to_IP_SAD_Accelerator_0_orig_channelCHANNEL_DATA[31:0];
    assign Kvazaar_QSYS_0_result_ready_external_connection_export_to_IP_SAD_Accelerator_0_result_ready[1:0] = IP_SAD_Accelerator_0_result_ready[1:0];
    assign Kvazaar_QSYS_0_sad_result_to_IP_SAD_Accelerator_0_sad_resultSAD_RESULT[63:0] = IP_SAD_Accelerator_0_sad_result[63:0];
    assign Kvazaar_QSYS_0_top_ref_channel_to_IP_SAD_Accelerator_0_top_ref_channelCHANNEL_VZ = IP_SAD_Accelerator_0_unfiltered1_lz;
    assign IP_SAD_Accelerator_0_unfiltered1_vz = Kvazaar_QSYS_0_top_ref_channel_to_IP_SAD_Accelerator_0_top_ref_channelCHANNEL_LZ;
    assign IP_SAD_Accelerator_0_unfiltered1_z[15:0] = Kvazaar_QSYS_0_top_ref_channel_to_IP_SAD_Accelerator_0_top_ref_channelCHANNEL_DATA[15:0];
    assign Kvazaar_QSYS_0_left_ref_channel_to_IP_SAD_Accelerator_0_left_ref_channelCHANNEL_VZ = IP_SAD_Accelerator_0_unfiltered2_lz;
    assign IP_SAD_Accelerator_0_unfiltered2_vz = Kvazaar_QSYS_0_left_ref_channel_to_IP_SAD_Accelerator_0_left_ref_channelCHANNEL_LZ;
    assign IP_SAD_Accelerator_0_unfiltered2_z[15:0] = Kvazaar_QSYS_0_left_ref_channel_to_IP_SAD_Accelerator_0_left_ref_channelCHANNEL_DATA[15:0];
    // Kvazaar_QSYS_0 assignments:
    assign Kvazaar_QSYS_0_config_channel_to_IP_SAD_Accelerator_0_config_channelCHANNEL_DATA[31:0] = Kvazaar_QSYS_0_acc_config_channel_data[31:0];
    assign Kvazaar_QSYS_0_config_channel_to_IP_SAD_Accelerator_0_config_channelCHANNEL_LZ = Kvazaar_QSYS_0_acc_config_channel_lz;
    assign Kvazaar_QSYS_0_acc_config_channel_vz = Kvazaar_QSYS_0_config_channel_to_IP_SAD_Accelerator_0_config_channelCHANNEL_VZ;
    assign Kvazaar_QSYS_0_orig_channel_to_IP_SAD_Accelerator_0_orig_channelCHANNEL_DATA[31:0] = Kvazaar_QSYS_0_axi_dma_orig_block_channel_data_export[31:0];
    assign Kvazaar_QSYS_0_orig_channel_to_IP_SAD_Accelerator_0_orig_channelCHANNEL_LZ = Kvazaar_QSYS_0_axi_dma_orig_block_channel_lz_export;
    assign Kvazaar_QSYS_0_axi_dma_orig_block_channel_vz_export = Kvazaar_QSYS_0_orig_channel_to_IP_SAD_Accelerator_0_orig_channelCHANNEL_VZ;
    assign Kvazaar_QSYS_0_axi_dma_orig_block_clear_fifo_export = Kvazaar_QSYS_0_axi_dma_orig_block_clear_fifo_export_to_IP_SAD_Accelerator_0_clear_orig_fifo;
    assign Kvazaar_QSYS_0_top_ref_channel_to_IP_SAD_Accelerator_0_top_ref_channelCHANNEL_DATA[15:0] = Kvazaar_QSYS_0_axi_dma_unfiltered1_channel_data_export[15:0];
    assign Kvazaar_QSYS_0_top_ref_channel_to_IP_SAD_Accelerator_0_top_ref_channelCHANNEL_LZ = Kvazaar_QSYS_0_axi_dma_unfiltered1_channel_lz_export;
    assign Kvazaar_QSYS_0_axi_dma_unfiltered1_channel_vz_export = Kvazaar_QSYS_0_top_ref_channel_to_IP_SAD_Accelerator_0_top_ref_channelCHANNEL_VZ;
    assign Kvazaar_QSYS_0_axi_dma_unfiltered1_clear_fifo_export = Kvazaar_QSYS_0_axi_dma_unfiltered1_clear_fifo_export_to_IP_SAD_Accelerator_0_clear_unfilt1_fifo;
    assign Kvazaar_QSYS_0_left_ref_channel_to_IP_SAD_Accelerator_0_left_ref_channelCHANNEL_DATA[15:0] = Kvazaar_QSYS_0_axi_dma_unfiltered2_channel_data_export[15:0];
    assign Kvazaar_QSYS_0_left_ref_channel_to_IP_SAD_Accelerator_0_left_ref_channelCHANNEL_LZ = Kvazaar_QSYS_0_axi_dma_unfiltered2_channel_lz_export;
    assign Kvazaar_QSYS_0_axi_dma_unfiltered2_channel_vz_export = Kvazaar_QSYS_0_left_ref_channel_to_IP_SAD_Accelerator_0_left_ref_channelCHANNEL_VZ;
    assign Kvazaar_QSYS_0_axi_dma_unfiltered2_clear_fifo_export = Kvazaar_QSYS_0_axi_dma_unfiltered2_clear_fifo_export_to_IP_SAD_Accelerator_0_clear_unfilt2_fifo;
    assign Kvazaar_QSYS_0_camera_control_oc_s2_address[5:0] = CCD_Configer_0_camera_config_to_Kvazaar_QSYS_0_camera_configCAMERA_CONTROL_OC_S2_ADDRESS[5:0];
    assign Kvazaar_QSYS_0_camera_control_oc_s2_byteenable[1:0] = 3;
    assign Kvazaar_QSYS_0_camera_control_oc_s2_chipselect = 1;
    assign Kvazaar_QSYS_0_camera_control_oc_s2_clken = 1;
    assign CCD_Configer_0_camera_config_to_Kvazaar_QSYS_0_camera_configCAMERA_CONTROL_OC_S2_READDATA[15:0] = Kvazaar_QSYS_0_camera_control_oc_s2_readdata[15:0];
    assign Kvazaar_QSYS_0_camera_control_oc_s2_write = 0;
    assign Kvazaar_QSYS_0_camera_control_oc_s2_writedata[15:0] = 0;
    assign Kvazaar_QSYS_0_clk_clk = Clock_Reset_0_clock_75MHz_to_Kvazaar_QSYS_0_clock_75MHzCLK;
    assign Kvazaar_QSYS_0_camera_start_config_to_CCD_Configer_0_camera_start_configCONFIGURE_CAMERA_EXTERNAL_CONNECTION_EXPORT = Kvazaar_QSYS_0_configure_camera_external_connection_export;
    assign Kvazaar_QSYS_0_dma_yuv_fifo_clk_clk = Clock_Reset_0_clock_camera_to_Kvazaar_QSYS_0_clock_cameraCLK;
    assign Kvazaar_QSYS_0_u_channel_to_RGB_to_YUV_0_u_channelCHANNEL_VZ = Kvazaar_QSYS_0_dma_yuv_yuv_input_u_data_in_lz;
    assign Kvazaar_QSYS_0_dma_yuv_yuv_input_u_data_in_vz = Kvazaar_QSYS_0_u_channel_to_RGB_to_YUV_0_u_channelCHANNEL_LZ;
    assign Kvazaar_QSYS_0_dma_yuv_yuv_input_u_data_in_z[7:0] = Kvazaar_QSYS_0_u_channel_to_RGB_to_YUV_0_u_channelCHANNEL_DATA[7:0];
    assign Kvazaar_QSYS_0_v_channel_to_RGB_to_YUV_0_v_channelCHANNEL_VZ = Kvazaar_QSYS_0_dma_yuv_yuv_input_v_data_in_lz;
    assign Kvazaar_QSYS_0_dma_yuv_yuv_input_v_data_in_vz = Kvazaar_QSYS_0_v_channel_to_RGB_to_YUV_0_v_channelCHANNEL_LZ;
    assign Kvazaar_QSYS_0_dma_yuv_yuv_input_v_data_in_z[7:0] = Kvazaar_QSYS_0_v_channel_to_RGB_to_YUV_0_v_channelCHANNEL_DATA[7:0];
    assign Kvazaar_QSYS_0_y_channel_to_RGB_to_YUV_0_y_channelCHANNEL_VZ = Kvazaar_QSYS_0_dma_yuv_yuv_input_y_data_in_lz;
    assign Kvazaar_QSYS_0_dma_yuv_yuv_input_y_data_in_vz = Kvazaar_QSYS_0_y_channel_to_RGB_to_YUV_0_y_channelCHANNEL_LZ;
    assign Kvazaar_QSYS_0_dma_yuv_yuv_input_y_data_in_z[7:0] = Kvazaar_QSYS_0_y_channel_to_RGB_to_YUV_0_y_channelCHANNEL_DATA[7:0];
    assign Kvazaar_QSYS_0_hps_0_f2h_stm_hw_events_stm_hwevents[9:6] = Kvazaar_QSYS_0_dip_switch_to_dip_switchUSER_DIPSW_FPGA[3:0];
    assign Kvazaar_QSYS_0_hps_0_f2h_stm_hw_events_stm_hwevents[1:0] = Clock_Reset_0_push_buttons_to_push_buttonsUSER_PB_FPGA[1:0];
    assign Kvazaar_QSYS_0_hps_0_hps_io_hps_io_can0_inst_RX = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_CAN0_INST_RX;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_CAN0_INST_TX = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_can0_inst_TX;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_MDC = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_MDC;
    assign Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_RXD0 = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_RXD0;
    assign Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_RXD1 = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_RXD1;
    assign Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_RXD2 = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_RXD2;
    assign Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_RXD3 = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_RXD3;
    assign Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_RX_CLK = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_RX_CLK;
    assign Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_RX_CTL = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_RX_CTL;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_TXD0 = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_TXD0;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_TXD1 = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_TXD1;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_TXD2 = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_TXD2;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_TXD3 = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_TXD3;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_TX_CLK = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_TX_CLK;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_EMAC1_INST_TX_CTL = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_TX_CTL;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_QSPI_INST_CLK = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_qspi_inst_CLK;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_QSPI_INST_SS0 = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_qspi_inst_SS0;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_SDIO_INST_CLK = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_sdio_inst_CLK;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_SPIM0_INST_CLK = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_spim0_inst_CLK;
    assign Kvazaar_QSYS_0_hps_0_hps_io_hps_io_spim0_inst_MISO = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_SPIM0_INST_MISO;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_SPIM0_INST_MOSI = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_spim0_inst_MOSI;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_SPIM0_INST_SS0 = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_spim0_inst_SS0;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_CLK = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_CLK;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D0 = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D0;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D1 = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D1;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D2 = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D2;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D3 = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D3;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D4 = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D4;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D5 = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D5;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D6 = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D6;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_TRACE_INST_D7 = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D7;
    assign Kvazaar_QSYS_0_hps_0_hps_io_hps_io_uart0_inst_RX = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_UART0_INST_RX;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_UART0_INST_TX = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_uart0_inst_TX;
    assign Kvazaar_QSYS_0_hps_0_hps_io_hps_io_usb1_inst_CLK = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_USB1_INST_CLK;
    assign Kvazaar_QSYS_0_hps_0_hps_io_hps_io_usb1_inst_DIR = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_USB1_INST_DIR;
    assign Kvazaar_QSYS_0_hps_0_hps_io_hps_io_usb1_inst_NXT = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_USB1_INST_NXT;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionHPS_0_HPS_IO_HPS_IO_USB1_INST_STP = Kvazaar_QSYS_0_hps_0_hps_io_hps_io_usb1_inst_STP;
    assign Kvazaar_QSYS_0_lambda_loaded_external_connection_export = Kvazaar_QSYS_0_lambda_loaded_external_connection_export_to_IP_SAD_Accelerator_0_lambda_loaded;
    assign Kvazaar_QSYS_0_lcu_loaded_external_connection_export = Kvazaar_QSYS_0_lcu_loaded_external_connection_export_to_IP_SAD_Accelerator_0_lcu_loaded;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_A[14:0] = Kvazaar_QSYS_0_memory_mem_a[14:0];
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_BA[2:0] = Kvazaar_QSYS_0_memory_mem_ba[2:0];
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_CAS_N = Kvazaar_QSYS_0_memory_mem_cas_n;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_CK = Kvazaar_QSYS_0_memory_mem_ck;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_CK_N = Kvazaar_QSYS_0_memory_mem_ck_n;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_CKE = Kvazaar_QSYS_0_memory_mem_cke;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_CS_N = Kvazaar_QSYS_0_memory_mem_cs_n;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_DM[4:0] = Kvazaar_QSYS_0_memory_mem_dm[4:0];
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_ODT = Kvazaar_QSYS_0_memory_mem_odt;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_RAS_N = Kvazaar_QSYS_0_memory_mem_ras_n;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_RESET_N = Kvazaar_QSYS_0_memory_mem_reset_n;
    assign Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_MEM_WE_N = Kvazaar_QSYS_0_memory_mem_we_n;
    assign Kvazaar_QSYS_0_memory_oct_rzqin = Kvazaar_QSYS_0_HPS_connection_to_HPS_connectionMEMORY_OCT_RZQIN;
    assign Kvazaar_QSYS_0_reset_reset_n = Clock_Reset_0_clock_75MHz_to_Kvazaar_QSYS_0_clock_75MHzRST_N;
    assign Kvazaar_QSYS_0_result_ready_external_connection_export[1:0] = Kvazaar_QSYS_0_result_ready_external_connection_export_to_IP_SAD_Accelerator_0_result_ready[1:0];
    assign Kvazaar_QSYS_0_sad_result_high_external_connection_export[31:0] = Kvazaar_QSYS_0_sad_result_to_IP_SAD_Accelerator_0_sad_resultSAD_RESULT[63:32];
    assign Kvazaar_QSYS_0_sad_result_low_external_connection_export[31:0] = Kvazaar_QSYS_0_sad_result_to_IP_SAD_Accelerator_0_sad_resultSAD_RESULT[31:0];
    assign Kvazaar_QSYS_0_yuv_ctrl_to_RGB_to_YUV_0_yuv_ctrlctrl[3:0] = Kvazaar_QSYS_0_yuv_ctrl_external_connection_export[3:0];
    assign Kvazaar_QSYS_0_yuv_status_external_connection_export = Kvazaar_QSYS_0_yuv_ctrl_to_RGB_to_YUV_0_yuv_ctrldone;
    // LTP_Controller_0 assignments:
    assign LTP_Controller_0_LCD_to_LCDLCD_B[7:0] = LTP_Controller_0_LCD_blue[7:0];
    assign LTP_Controller_0_LCD_to_LCDLCD_DCLK = LTP_Controller_0_LCD_clock;
    assign LTP_Controller_0_LCD_to_LCDLCD_DIM = LTP_Controller_0_LCD_dim;
    assign LTP_Controller_0_LCD_to_LCDLCD_G[7:0] = LTP_Controller_0_LCD_green[7:0];
    assign LTP_Controller_0_LCD_to_LCDLCD_MODE = LTP_Controller_0_LCD_mode;
    assign LTP_Controller_0_LCD_to_LCDLCD_POWER_CTL = LTP_Controller_0_LCD_power_ctl;
    assign LTP_Controller_0_LCD_to_LCDLCD_R[7:0] = LTP_Controller_0_LCD_red[7:0];
    assign LTP_Controller_0_LCD_to_LCDLCD_RSTB = LTP_Controller_0_LCD_rstb;
    assign LTP_Controller_0_LCD_to_LCDLCD_SHLR = LTP_Controller_0_LCD_shlr;
    assign LTP_Controller_0_LCD_to_LCDLCD_UPDN = LTP_Controller_0_LCD_updn;
    assign LTP_Controller_0_blue_in[7:0] = RAW_to_RGB_0_RGB_data_to_LTP_Controller_0_RGB_dataOBLUE[11:4];
    assign LTP_Controller_0_clk = Clock_Reset_0_clock_33MHz_to_LTP_Controller_0_clock_33MHzCLK;
    assign LTP_Controller_0_fifo_in_clk = Clock_Reset_0_clock_camera_to_Kvazaar_QSYS_0_clock_cameraCLK;
    assign LTP_Controller_0_fifo_write = RAW_to_RGB_0_RGB_data_to_LTP_Controller_0_RGB_dataODVAL;
    assign LTP_Controller_0_green_in[7:0] = RAW_to_RGB_0_RGB_data_to_LTP_Controller_0_RGB_dataOGREEN[11:4];
    assign LTP_Controller_0_LCD_to_LCDLCD_HSD = LTP_Controller_0_horizontal_sync;
    assign LTP_Controller_0_red_in[7:0] = RAW_to_RGB_0_RGB_data_to_LTP_Controller_0_RGB_dataORED[11:4];
    assign LTP_Controller_0_rst_n = Clock_Reset_0_clock_33MHz_to_LTP_Controller_0_clock_33MHzRST_N;
    assign LTP_Controller_0_LCD_to_LCDLCD_VSD = LTP_Controller_0_vertical_sync;
    // RAW_to_RGB_0 assignments:
    assign RAW_to_RGB_0_iCLK = Clock_Reset_0_clock_camera_to_Kvazaar_QSYS_0_clock_cameraCLK;
    assign RAW_to_RGB_0_iData[11:0] = RAW_to_RGB_0_RAW_data_to_CCD_Capture_0_RAW_dataIDATA[11:0];
    assign RAW_to_RGB_0_iDval = RAW_to_RGB_0_RAW_data_to_CCD_Capture_0_RAW_dataIDVAL;
    assign RAW_to_RGB_0_iMIRROR = Kvazaar_QSYS_0_dip_switch_to_dip_switchUSER_DIPSW_FPGA[3];
    assign RAW_to_RGB_0_iRST_n = Clock_Reset_0_clock_camera_to_Kvazaar_QSYS_0_clock_cameraRST_N;
    assign RAW_to_RGB_0_iX_Cont[15:0] = RAW_to_RGB_0_RAW_data_to_CCD_Capture_0_RAW_dataIX_CONT[15:0];
    assign RAW_to_RGB_0_iY_Cont[15:0] = RAW_to_RGB_0_RAW_data_to_CCD_Capture_0_RAW_dataIY_CONT[15:0];
    assign RAW_to_RGB_0_RGB_data_to_LTP_Controller_0_RGB_dataOBLUE[11:0] = RAW_to_RGB_0_oBlue[11:0];
    assign RAW_to_RGB_0_RGB_data_to_LTP_Controller_0_RGB_dataODVAL = RAW_to_RGB_0_oDval;
    assign RAW_to_RGB_0_RGB_data_to_LTP_Controller_0_RGB_dataOGREEN[11:0] = RAW_to_RGB_0_oGreen[11:0];
    assign RAW_to_RGB_0_RGB_data_to_LTP_Controller_0_RGB_dataORED[11:0] = RAW_to_RGB_0_oRed[11:0];
    // RGB_to_YUV_0 assignments:
    assign RGB_to_YUV_0_clk = Clock_Reset_0_clock_camera_to_Kvazaar_QSYS_0_clock_cameraCLK;
    assign RGB_to_YUV_0_frame_valid = CCD_Capture_0_CCD_data_to_CCD_dataIFVAL;
    assign RGB_to_YUV_0_iBlue_z[7:0] = RAW_to_RGB_0_RGB_data_to_LTP_Controller_0_RGB_dataOBLUE[11:4];
    assign RGB_to_YUV_0_iDval_z = RAW_to_RGB_0_RGB_data_to_LTP_Controller_0_RGB_dataODVAL;
    assign RGB_to_YUV_0_iGreen_z[7:0] = RAW_to_RGB_0_RGB_data_to_LTP_Controller_0_RGB_dataOGREEN[11:4];
    assign RGB_to_YUV_0_iRed_z[7:0] = RAW_to_RGB_0_RGB_data_to_LTP_Controller_0_RGB_dataORED[11:4];
    assign Kvazaar_QSYS_0_u_channel_to_RGB_to_YUV_0_u_channelCHANNEL_LZ = RGB_to_YUV_0_oU_lz;
    assign RGB_to_YUV_0_oU_vz = Kvazaar_QSYS_0_u_channel_to_RGB_to_YUV_0_u_channelCHANNEL_VZ;
    assign Kvazaar_QSYS_0_u_channel_to_RGB_to_YUV_0_u_channelCHANNEL_DATA[7:0] = RGB_to_YUV_0_oU_z[7:0];
    assign Kvazaar_QSYS_0_v_channel_to_RGB_to_YUV_0_v_channelCHANNEL_LZ = RGB_to_YUV_0_oV_lz;
    assign RGB_to_YUV_0_oV_vz = Kvazaar_QSYS_0_v_channel_to_RGB_to_YUV_0_v_channelCHANNEL_VZ;
    assign Kvazaar_QSYS_0_v_channel_to_RGB_to_YUV_0_v_channelCHANNEL_DATA[7:0] = RGB_to_YUV_0_oV_z[7:0];
    assign Kvazaar_QSYS_0_y_channel_to_RGB_to_YUV_0_y_channelCHANNEL_LZ = RGB_to_YUV_0_oY_lz;
    assign RGB_to_YUV_0_oY_vz = Kvazaar_QSYS_0_y_channel_to_RGB_to_YUV_0_y_channelCHANNEL_VZ;
    assign Kvazaar_QSYS_0_y_channel_to_RGB_to_YUV_0_y_channelCHANNEL_DATA[7:0] = RGB_to_YUV_0_oY_z[7:0];
    assign RGB_to_YUV_0_rst_n = Clock_Reset_0_clock_camera_to_Kvazaar_QSYS_0_clock_cameraRST_N;
    assign Kvazaar_QSYS_0_yuv_ctrl_to_RGB_to_YUV_0_yuv_ctrldone = RGB_to_YUV_0_write_done;
    assign RGB_to_YUV_0_yuv_ctrl[3:0] = Kvazaar_QSYS_0_yuv_ctrl_to_RGB_to_YUV_0_yuv_ctrlctrl[3:0];

    // IP-XACT VLNV: TUNI.fi:ip.hw:CCD_Capture:1.0
    CCD_Capture     CCD_Capture_0(
        // Interface: CCD_data
        .iDATA               (CCD_Capture_0_iDATA),
        .iFVAL               (CCD_Capture_0_iFVAL),
        .iLVAL               (CCD_Capture_0_iLVAL),
        // Interface: RAW_data
        .oDATA               (CCD_Capture_0_oDATA),
        .oDVAL               (CCD_Capture_0_oDVAL),
        .oX_Cont             (CCD_Capture_0_oX_Cont),
        .oY_Cont             (CCD_Capture_0_oY_Cont),
        // Interface: clock_camera
        .iCLK                (CCD_Capture_0_iCLK),
        .iRST                (CCD_Capture_0_iRST),
        // These ports are not in any interface
        .iEND                (0),
        .iSTART              (0),
        .oFrame_Cont         ());

    // IP-XACT VLNV: TUNI.fi:ip.hw:CCD_Configer:1.0
    CCD_Configer     CCD_Configer_0(
        // Interface: CCD_config
        .blue_gain           (CCD_Configer_0_blue_gain),
        .green1_gain         (CCD_Configer_0_green1_gain),
        .green2_gain         (CCD_Configer_0_green2_gain),
        .red_gain            (CCD_Configer_0_red_gain),
        .sensor_column_mode  (CCD_Configer_0_sensor_column_mode),
        .sensor_column_size  (CCD_Configer_0_sensor_column_size),
        .sensor_exposure     (CCD_Configer_0_sensor_exposure),
        .sensor_row_mode     (CCD_Configer_0_sensor_row_mode),
        .sensor_row_size     (CCD_Configer_0_sensor_row_size),
        .sensor_start_column (CCD_Configer_0_sensor_start_column),
        .sensor_start_row    (CCD_Configer_0_sensor_start_row),
        .set_conf            (CCD_Configer_0_set_conf),
        // Interface: camera_config
        .camera_control_oc_data_in(CCD_Configer_0_camera_control_oc_data_in),
        .camera_control_oc_address(CCD_Configer_0_camera_control_oc_address),
        // Interface: camera_start_config
        .read_confs          (CCD_Configer_0_read_confs),
        // Interface: clock_75MHz
        .clk                 (CCD_Configer_0_clk),
        .rst_n               (CCD_Configer_0_rst_n),
        // Interface: push_buttons
        .exposure_less       (CCD_Configer_0_exposure_less),
        .exposure_more       (CCD_Configer_0_exposure_more));

    // IP-XACT VLNV: TUNI.fi:ip.hw:CCD_Configer_I2C:1.0
    CCD_Configer_I2C #(
        .CLK_Freq            (75000000))
    CCD_Configer_I2C_0(
        // Interface: CCD_config
        .iblue_gain          (CCD_Configer_I2C_0_iblue_gain),
        .igreen1_gain        (CCD_Configer_I2C_0_igreen1_gain),
        .igreen2_gain        (CCD_Configer_I2C_0_igreen2_gain),
        .ired_gain           (CCD_Configer_I2C_0_ired_gain),
        .iSetConf            (CCD_Configer_I2C_0_iSetConf),
        .sensor_column_mode  (CCD_Configer_I2C_0_sensor_column_mode),
        .sensor_column_size  (CCD_Configer_I2C_0_sensor_column_size),
        .sensor_exposure     (CCD_Configer_I2C_0_sensor_exposure),
        .sensor_row_mode     (CCD_Configer_I2C_0_sensor_row_mode),
        .sensor_row_size     (CCD_Configer_I2C_0_sensor_row_size),
        .sensor_start_column (CCD_Configer_I2C_0_sensor_start_column),
        .sensor_start_row    (CCD_Configer_I2C_0_sensor_start_row),
        // Interface: I2C_data
        .I2C_SCLK            (CCD_Configer_I2C_0_I2C_SCLK),
        .I2C_SDAT            (CAMERA_SDATA),
        // Interface: clock_75MHz
        .iCLK                (CCD_Configer_I2C_0_iCLK),
        .iRST_N              (CCD_Configer_I2C_0_iRST_N),
        // Interface: dip_switch
        .iMIRROR_SW          (CCD_Configer_I2C_0_iMIRROR_SW));

    // IP-XACT VLNV: TUNI.fi:ip.hw:Clock_Reset:1.0
    Clock_Reset Clock_Reset_0(
        // Interface: clock_25MHz
        .outclk_0            (Clock_Reset_0_outclk_0),
        .rst_n_0             (Clock_Reset_0_rst_n_0),
        // Interface: clock_33MHz
        .outclk_2            (Clock_Reset_0_outclk_2),
        .rst_n_2             (Clock_Reset_0_rst_n_2),
        // Interface: clock_50MHz_ref
        .refclk              (Clock_Reset_0_refclk),
        // Interface: clock_75MHz
        .outclk_1            (Clock_Reset_0_outclk_1),
        .rst_n_1             (Clock_Reset_0_rst_n_1),
        // Interface: clock_camera
        .outclk_3            (Clock_Reset_0_outclk_3),
        .rst_n_3             (Clock_Reset_0_rst_n_3),
        // Interface: clock_camera_ref
        .cameraclk           (Clock_Reset_0_cameraclk),
        // Interface: push_buttons
        .fpga_pb_1           (Clock_Reset_0_fpga_pb_1),
        .fpga_pb_2           (Clock_Reset_0_fpga_pb_2));

    // IP-XACT VLNV: TUNI.fi:ip.hw:IP_SAD_Accelerator:1.0
    IP_SAD_Accelerator     IP_SAD_Accelerator_0(
        // Interface: clock_75MHz
        .arst_n              (IP_SAD_Accelerator_0_arst_n),
        .clk                 (IP_SAD_Accelerator_0_clk),
        // Interface: config_channel
        .ip_config_in_vz     (IP_SAD_Accelerator_0_ip_config_in_vz),
        .ip_config_in_z      (IP_SAD_Accelerator_0_ip_config_in_z),
        .ip_config_in_lz     (IP_SAD_Accelerator_0_ip_config_in_lz),
        // Interface: left_ref_channel
        .unfiltered2_vz      (IP_SAD_Accelerator_0_unfiltered2_vz),
        .unfiltered2_z       (IP_SAD_Accelerator_0_unfiltered2_z),
        .unfiltered2_lz      (IP_SAD_Accelerator_0_unfiltered2_lz),
        // Interface: orig_channel
        .orig_block_data_in_vz(IP_SAD_Accelerator_0_orig_block_data_in_vz),
        .orig_block_data_in_z(IP_SAD_Accelerator_0_orig_block_data_in_z),
        .orig_block_data_in_lz(IP_SAD_Accelerator_0_orig_block_data_in_lz),
        // Interface: sad_result
        .sad_result          (IP_SAD_Accelerator_0_sad_result),
        // Interface: top_ref_channel
        .unfiltered1_vz      (IP_SAD_Accelerator_0_unfiltered1_vz),
        .unfiltered1_z       (IP_SAD_Accelerator_0_unfiltered1_z),
        .unfiltered1_lz      (IP_SAD_Accelerator_0_unfiltered1_lz),
        // These ports are not in any interface
        .clear_orig_fifo     (IP_SAD_Accelerator_0_clear_orig_fifo),
        .clear_unfilt1_fifo  (IP_SAD_Accelerator_0_clear_unfilt1_fifo),
        .clear_unfilt2_fifo  (IP_SAD_Accelerator_0_clear_unfilt2_fifo),
        .lambda_loaded       (IP_SAD_Accelerator_0_lambda_loaded),
        .lcu_loaded          (IP_SAD_Accelerator_0_lcu_loaded),
        .result_ready        (IP_SAD_Accelerator_0_result_ready));

    // IP-XACT VLNV: TUNI.fi:ip.hw:Kvazaar_QSYS:1.0_student
    Kvazaar_QSYS Kvazaar_QSYS_0(
        // Interface: HPS_connection
        .hps_0_hps_io_hps_io_can0_inst_RX(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_can0_inst_RX),
        .hps_0_hps_io_hps_io_emac1_inst_RX_CLK(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_RX_CLK),
        .hps_0_hps_io_hps_io_emac1_inst_RX_CTL(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_RX_CTL),
        .hps_0_hps_io_hps_io_emac1_inst_RXD0(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_RXD0),
        .hps_0_hps_io_hps_io_emac1_inst_RXD1(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_RXD1),
        .hps_0_hps_io_hps_io_emac1_inst_RXD2(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_RXD2),
        .hps_0_hps_io_hps_io_emac1_inst_RXD3(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_RXD3),
        .hps_0_hps_io_hps_io_spim0_inst_MISO(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_spim0_inst_MISO),
        .hps_0_hps_io_hps_io_uart0_inst_RX(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_uart0_inst_RX),
        .hps_0_hps_io_hps_io_usb1_inst_CLK(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_usb1_inst_CLK),
        .hps_0_hps_io_hps_io_usb1_inst_DIR(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_usb1_inst_DIR),
        .hps_0_hps_io_hps_io_usb1_inst_NXT(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_usb1_inst_NXT),
        .memory_oct_rzqin    (Kvazaar_QSYS_0_memory_oct_rzqin),
        .hps_0_hps_io_hps_io_can0_inst_TX(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_can0_inst_TX),
        .hps_0_hps_io_hps_io_emac1_inst_MDC(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_MDC),
        .hps_0_hps_io_hps_io_emac1_inst_TX_CLK(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_TX_CLK),
        .hps_0_hps_io_hps_io_emac1_inst_TX_CTL(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_TX_CTL),
        .hps_0_hps_io_hps_io_emac1_inst_TXD0(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_TXD0),
        .hps_0_hps_io_hps_io_emac1_inst_TXD1(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_TXD1),
        .hps_0_hps_io_hps_io_emac1_inst_TXD2(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_TXD2),
        .hps_0_hps_io_hps_io_emac1_inst_TXD3(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_emac1_inst_TXD3),
        .hps_0_hps_io_hps_io_qspi_inst_CLK(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_qspi_inst_CLK),
        .hps_0_hps_io_hps_io_qspi_inst_SS0(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_qspi_inst_SS0),
        .hps_0_hps_io_hps_io_sdio_inst_CLK(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_sdio_inst_CLK),
        .hps_0_hps_io_hps_io_spim0_inst_CLK(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_spim0_inst_CLK),
        .hps_0_hps_io_hps_io_spim0_inst_MOSI(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_spim0_inst_MOSI),
        .hps_0_hps_io_hps_io_spim0_inst_SS0(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_spim0_inst_SS0),
        .hps_0_hps_io_hps_io_trace_inst_CLK(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_CLK),
        .hps_0_hps_io_hps_io_trace_inst_D0(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D0),
        .hps_0_hps_io_hps_io_trace_inst_D1(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D1),
        .hps_0_hps_io_hps_io_trace_inst_D2(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D2),
        .hps_0_hps_io_hps_io_trace_inst_D3(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D3),
        .hps_0_hps_io_hps_io_trace_inst_D4(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D4),
        .hps_0_hps_io_hps_io_trace_inst_D5(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D5),
        .hps_0_hps_io_hps_io_trace_inst_D6(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D6),
        .hps_0_hps_io_hps_io_trace_inst_D7(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_trace_inst_D7),
        .hps_0_hps_io_hps_io_uart0_inst_TX(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_uart0_inst_TX),
        .hps_0_hps_io_hps_io_usb1_inst_STP(Kvazaar_QSYS_0_hps_0_hps_io_hps_io_usb1_inst_STP),
        .memory_mem_a        (Kvazaar_QSYS_0_memory_mem_a),
        .memory_mem_ba       (Kvazaar_QSYS_0_memory_mem_ba),
        .memory_mem_cas_n    (Kvazaar_QSYS_0_memory_mem_cas_n),
        .memory_mem_ck       (Kvazaar_QSYS_0_memory_mem_ck),
        .memory_mem_ck_n     (Kvazaar_QSYS_0_memory_mem_ck_n),
        .memory_mem_cke      (Kvazaar_QSYS_0_memory_mem_cke),
        .memory_mem_cs_n     (Kvazaar_QSYS_0_memory_mem_cs_n),
        .memory_mem_dm       (Kvazaar_QSYS_0_memory_mem_dm),
        .memory_mem_odt      (Kvazaar_QSYS_0_memory_mem_odt),
        .memory_mem_ras_n    (Kvazaar_QSYS_0_memory_mem_ras_n),
        .memory_mem_reset_n  (Kvazaar_QSYS_0_memory_mem_reset_n),
        .memory_mem_we_n     (Kvazaar_QSYS_0_memory_mem_we_n),
        .hps_0_hps_io_hps_io_emac1_inst_MDIO(enet_hps_mdio),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO09(gpio09),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO35(enet_hps_intn),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO41(user_led_hps[3]),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO42(user_led_hps[2]),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO43(user_led_hps[1]),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO44(user_led_hps[0]),
        .hps_0_hps_io_hps_io_i2c0_inst_SCL(i2c_scl_hps),
        .hps_0_hps_io_hps_io_i2c0_inst_SDA(i2c_sda_hps),
        .hps_0_hps_io_hps_io_qspi_inst_IO0(qspi_io[0]),
        .hps_0_hps_io_hps_io_qspi_inst_IO1(qspi_io[1]),
        .hps_0_hps_io_hps_io_qspi_inst_IO2(qspi_io[2]),
        .hps_0_hps_io_hps_io_qspi_inst_IO3(qspi_io[3]),
        .hps_0_hps_io_hps_io_sdio_inst_CMD(sd_cmd),
        .hps_0_hps_io_hps_io_sdio_inst_D0(sd_dat[0]),
        .hps_0_hps_io_hps_io_sdio_inst_D1(sd_dat[1]),
        .hps_0_hps_io_hps_io_sdio_inst_D2(sd_dat[2]),
        .hps_0_hps_io_hps_io_sdio_inst_D3(sd_dat[3]),
        .hps_0_hps_io_hps_io_usb1_inst_D0(usb_data[0]),
        .hps_0_hps_io_hps_io_usb1_inst_D1(usb_data[1]),
        .hps_0_hps_io_hps_io_usb1_inst_D2(usb_data[2]),
        .hps_0_hps_io_hps_io_usb1_inst_D3(usb_data[3]),
        .hps_0_hps_io_hps_io_usb1_inst_D4(usb_data[4]),
        .hps_0_hps_io_hps_io_usb1_inst_D5(usb_data[5]),
        .hps_0_hps_io_hps_io_usb1_inst_D6(usb_data[6]),
        .hps_0_hps_io_hps_io_usb1_inst_D7(usb_data[7]),
        .memory_mem_dq       (ddr3_hps_dq[39:0]),
        .memory_mem_dqs      (ddr3_hps_dqs_p[4:0]),
        .memory_mem_dqs_n    (ddr3_hps_dqs_n[4:0]),
        // Interface: camera_config
        .camera_control_oc_s2_address(Kvazaar_QSYS_0_camera_control_oc_s2_address),
        .camera_control_oc_s2_byteenable(Kvazaar_QSYS_0_camera_control_oc_s2_byteenable),
        .camera_control_oc_s2_chipselect(Kvazaar_QSYS_0_camera_control_oc_s2_chipselect),
        .camera_control_oc_s2_clken(Kvazaar_QSYS_0_camera_control_oc_s2_clken),
        .camera_control_oc_s2_write(Kvazaar_QSYS_0_camera_control_oc_s2_write),
        .camera_control_oc_s2_writedata(Kvazaar_QSYS_0_camera_control_oc_s2_writedata),
        .camera_control_oc_s2_readdata(Kvazaar_QSYS_0_camera_control_oc_s2_readdata),
        // Interface: camera_start_config
        .configure_camera_external_connection_export(Kvazaar_QSYS_0_configure_camera_external_connection_export),
        // Interface: clock_75MHz
        .clk_clk             (Kvazaar_QSYS_0_clk_clk),
        .reset_reset_n       (Kvazaar_QSYS_0_reset_reset_n),
        // Interface: clock_camera
        .dma_yuv_fifo_clk_clk(Kvazaar_QSYS_0_dma_yuv_fifo_clk_clk),
        // Interface: config_channel
        .acc_config_channel_vz(Kvazaar_QSYS_0_acc_config_channel_vz),
        .acc_config_channel_data(Kvazaar_QSYS_0_acc_config_channel_data),
        .acc_config_channel_lz(Kvazaar_QSYS_0_acc_config_channel_lz),
        // Interface: left_ref_channel
        .axi_dma_unfiltered2_channel_vz_export(Kvazaar_QSYS_0_axi_dma_unfiltered2_channel_vz_export),
        .axi_dma_unfiltered2_channel_data_export(Kvazaar_QSYS_0_axi_dma_unfiltered2_channel_data_export),
        .axi_dma_unfiltered2_channel_lz_export(Kvazaar_QSYS_0_axi_dma_unfiltered2_channel_lz_export),
        // Interface: orig_channel
        .axi_dma_orig_block_channel_vz_export(Kvazaar_QSYS_0_axi_dma_orig_block_channel_vz_export),
        .axi_dma_orig_block_channel_data_export(Kvazaar_QSYS_0_axi_dma_orig_block_channel_data_export),
        .axi_dma_orig_block_channel_lz_export(Kvazaar_QSYS_0_axi_dma_orig_block_channel_lz_export),
        // Interface: sad_result
        .sad_result_high_external_connection_export(Kvazaar_QSYS_0_sad_result_high_external_connection_export),
        .sad_result_low_external_connection_export(Kvazaar_QSYS_0_sad_result_low_external_connection_export),
        // Interface: top_ref_channel
        .axi_dma_unfiltered1_channel_vz_export(Kvazaar_QSYS_0_axi_dma_unfiltered1_channel_vz_export),
        .axi_dma_unfiltered1_channel_data_export(Kvazaar_QSYS_0_axi_dma_unfiltered1_channel_data_export),
        .axi_dma_unfiltered1_channel_lz_export(Kvazaar_QSYS_0_axi_dma_unfiltered1_channel_lz_export),
        // Interface: u_channel
        .dma_yuv_yuv_input_u_data_in_vz(Kvazaar_QSYS_0_dma_yuv_yuv_input_u_data_in_vz),
        .dma_yuv_yuv_input_u_data_in_z(Kvazaar_QSYS_0_dma_yuv_yuv_input_u_data_in_z),
        .dma_yuv_yuv_input_u_data_in_lz(Kvazaar_QSYS_0_dma_yuv_yuv_input_u_data_in_lz),
        // Interface: v_channel
        .dma_yuv_yuv_input_v_data_in_vz(Kvazaar_QSYS_0_dma_yuv_yuv_input_v_data_in_vz),
        .dma_yuv_yuv_input_v_data_in_z(Kvazaar_QSYS_0_dma_yuv_yuv_input_v_data_in_z),
        .dma_yuv_yuv_input_v_data_in_lz(Kvazaar_QSYS_0_dma_yuv_yuv_input_v_data_in_lz),
        // Interface: y_channel
        .dma_yuv_yuv_input_y_data_in_vz(Kvazaar_QSYS_0_dma_yuv_yuv_input_y_data_in_vz),
        .dma_yuv_yuv_input_y_data_in_z(Kvazaar_QSYS_0_dma_yuv_yuv_input_y_data_in_z),
        .dma_yuv_yuv_input_y_data_in_lz(Kvazaar_QSYS_0_dma_yuv_yuv_input_y_data_in_lz),
        // Interface: yuv_ctrl
        .yuv_status_external_connection_export(Kvazaar_QSYS_0_yuv_status_external_connection_export),
        .yuv_ctrl_external_connection_export(Kvazaar_QSYS_0_yuv_ctrl_external_connection_export),
        // There ports are contained in many interfaces
        .hps_0_f2h_stm_hw_events_stm_hwevents(Kvazaar_QSYS_0_hps_0_f2h_stm_hw_events_stm_hwevents),
        // These ports are not in any interface
        .axi_dma_orig_block_clear_fifo_export(Kvazaar_QSYS_0_axi_dma_orig_block_clear_fifo_export),
        .axi_dma_unfiltered1_clear_fifo_export(Kvazaar_QSYS_0_axi_dma_unfiltered1_clear_fifo_export),
        .axi_dma_unfiltered2_clear_fifo_export(Kvazaar_QSYS_0_axi_dma_unfiltered2_clear_fifo_export),
        .dma_yuv_yuv_input_clear_dma_and_fifo(0),
        .hps_0_f2h_cold_reset_req_reset_n(1),
        .hps_0_f2h_debug_reset_req_reset_n(1),
        .hps_0_f2h_warm_reset_req_reset_n(1),
        .lambda_loaded_external_connection_export(Kvazaar_QSYS_0_lambda_loaded_external_connection_export),
        .lcu_loaded_external_connection_export(Kvazaar_QSYS_0_lcu_loaded_external_connection_export),
        .result_ready_external_connection_export(Kvazaar_QSYS_0_result_ready_external_connection_export));

    // IP-XACT VLNV: TUNI.fi:ip.hw:LTP_Controller:1.0
    LTP_Controller LTP_Controller_0(
        // Interface: LCD
        .horizontal_sync     (LTP_Controller_0_horizontal_sync),
        .LCD_blue            (LTP_Controller_0_LCD_blue),
        .LCD_clock           (LTP_Controller_0_LCD_clock),
        .LCD_dim             (LTP_Controller_0_LCD_dim),
        .LCD_green           (LTP_Controller_0_LCD_green),
        .LCD_mode            (LTP_Controller_0_LCD_mode),
        .LCD_power_ctl       (LTP_Controller_0_LCD_power_ctl),
        .LCD_red             (LTP_Controller_0_LCD_red),
        .LCD_rstb            (LTP_Controller_0_LCD_rstb),
        .LCD_shlr            (LTP_Controller_0_LCD_shlr),
        .LCD_updn            (LTP_Controller_0_LCD_updn),
        .vertical_sync       (LTP_Controller_0_vertical_sync),
        // Interface: RGB_data
        .blue_in             (LTP_Controller_0_blue_in),
        .fifo_write          (LTP_Controller_0_fifo_write),
        .green_in            (LTP_Controller_0_green_in),
        .red_in              (LTP_Controller_0_red_in),
        // Interface: clock_33MHz
        .clk                 (LTP_Controller_0_clk),
        .rst_n               (LTP_Controller_0_rst_n),
        // Interface: clock_camera
        .fifo_in_clk         (LTP_Controller_0_fifo_in_clk),
        // These ports are not in any interface
        .clear_lcd           (0));

    // IP-XACT VLNV: TUNI.fi:ip.hw:RAW_to_RGB:1.0
    RAW_to_RGB RAW_to_RGB_0(
        // Interface: RAW_data
        .iData               (RAW_to_RGB_0_iData),
        .iDval               (RAW_to_RGB_0_iDval),
        .iX_Cont             (RAW_to_RGB_0_iX_Cont),
        .iY_Cont             (RAW_to_RGB_0_iY_Cont),
        // Interface: RGB_data
        .oBlue               (RAW_to_RGB_0_oBlue),
        .oDval               (RAW_to_RGB_0_oDval),
        .oGreen              (RAW_to_RGB_0_oGreen),
        .oRed                (RAW_to_RGB_0_oRed),
        // Interface: clock_camera
        .iCLK                (RAW_to_RGB_0_iCLK),
        .iRST_n              (RAW_to_RGB_0_iRST_n),
        // Interface: dip_switch
        .iMIRROR             (RAW_to_RGB_0_iMIRROR),
        // These ports are not in any interface
        .iNext               (0));

    // IP-XACT VLNV: TUNI.fi:ip.hw:RGB_to_YUV:1.0
    RGB_to_YUV RGB_to_YUV_0(
        // Interface: CCD_data
        .frame_valid         (RGB_to_YUV_0_frame_valid),
        // Interface: RGB_data
        .iBlue_z             (RGB_to_YUV_0_iBlue_z),
        .iDval_z             (RGB_to_YUV_0_iDval_z),
        .iGreen_z            (RGB_to_YUV_0_iGreen_z),
        .iRed_z              (RGB_to_YUV_0_iRed_z),
        // Interface: clock_camera
        .clk                 (RGB_to_YUV_0_clk),
        .rst_n               (RGB_to_YUV_0_rst_n),
        // Interface: u_channel
        .oU_vz               (RGB_to_YUV_0_oU_vz),
        .oU_lz               (RGB_to_YUV_0_oU_lz),
        .oU_z                (RGB_to_YUV_0_oU_z),
        // Interface: v_channel
        .oV_vz               (RGB_to_YUV_0_oV_vz),
        .oV_lz               (RGB_to_YUV_0_oV_lz),
        .oV_z                (RGB_to_YUV_0_oV_z),
        // Interface: y_channel
        .oY_vz               (RGB_to_YUV_0_oY_vz),
        .oY_lz               (RGB_to_YUV_0_oY_lz),
        .oY_z                (RGB_to_YUV_0_oY_z),
        // Interface: yuv_ctrl
        .yuv_ctrl            (RGB_to_YUV_0_yuv_ctrl),
        .write_done          (RGB_to_YUV_0_write_done),
        // These ports are not in any interface
        .x_pixels            (800),
        .y_pixels            (480));


endmodule
