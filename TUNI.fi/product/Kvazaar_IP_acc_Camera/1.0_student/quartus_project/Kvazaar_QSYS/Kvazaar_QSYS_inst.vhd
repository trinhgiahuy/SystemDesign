	component Kvazaar_QSYS is
		port (
			memory_mem_a                                : out   std_logic_vector(14 downto 0);                    -- mem_a
			memory_mem_ba                               : out   std_logic_vector(2 downto 0);                     -- mem_ba
			memory_mem_ck                               : out   std_logic;                                        -- mem_ck
			memory_mem_ck_n                             : out   std_logic;                                        -- mem_ck_n
			memory_mem_cke                              : out   std_logic;                                        -- mem_cke
			memory_mem_cs_n                             : out   std_logic;                                        -- mem_cs_n
			memory_mem_ras_n                            : out   std_logic;                                        -- mem_ras_n
			memory_mem_cas_n                            : out   std_logic;                                        -- mem_cas_n
			memory_mem_we_n                             : out   std_logic;                                        -- mem_we_n
			memory_mem_reset_n                          : out   std_logic;                                        -- mem_reset_n
			memory_mem_dq                               : inout std_logic_vector(39 downto 0) := (others => 'X'); -- mem_dq
			memory_mem_dqs                              : inout std_logic_vector(4 downto 0)  := (others => 'X'); -- mem_dqs
			memory_mem_dqs_n                            : inout std_logic_vector(4 downto 0)  := (others => 'X'); -- mem_dqs_n
			memory_mem_odt                              : out   std_logic;                                        -- mem_odt
			memory_mem_dm                               : out   std_logic_vector(4 downto 0);                     -- mem_dm
			memory_oct_rzqin                            : in    std_logic                     := 'X';             -- oct_rzqin
			clk_clk                                     : in    std_logic                     := 'X';             -- clk
			reset_reset_n                               : in    std_logic                     := 'X';             -- reset_n
			hps_0_hps_io_hps_io_emac1_inst_TX_CLK       : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
			hps_0_hps_io_hps_io_emac1_inst_TXD0         : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
			hps_0_hps_io_hps_io_emac1_inst_TXD1         : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
			hps_0_hps_io_hps_io_emac1_inst_TXD2         : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
			hps_0_hps_io_hps_io_emac1_inst_TXD3         : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
			hps_0_hps_io_hps_io_emac1_inst_RXD0         : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
			hps_0_hps_io_hps_io_emac1_inst_MDIO         : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
			hps_0_hps_io_hps_io_emac1_inst_MDC          : out   std_logic;                                        -- hps_io_emac1_inst_MDC
			hps_0_hps_io_hps_io_emac1_inst_RX_CTL       : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
			hps_0_hps_io_hps_io_emac1_inst_TX_CTL       : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
			hps_0_hps_io_hps_io_emac1_inst_RX_CLK       : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
			hps_0_hps_io_hps_io_emac1_inst_RXD1         : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
			hps_0_hps_io_hps_io_emac1_inst_RXD2         : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
			hps_0_hps_io_hps_io_emac1_inst_RXD3         : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
			hps_0_hps_io_hps_io_qspi_inst_IO0           : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO0
			hps_0_hps_io_hps_io_qspi_inst_IO1           : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO1
			hps_0_hps_io_hps_io_qspi_inst_IO2           : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO2
			hps_0_hps_io_hps_io_qspi_inst_IO3           : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO3
			hps_0_hps_io_hps_io_qspi_inst_SS0           : out   std_logic;                                        -- hps_io_qspi_inst_SS0
			hps_0_hps_io_hps_io_qspi_inst_CLK           : out   std_logic;                                        -- hps_io_qspi_inst_CLK
			hps_0_hps_io_hps_io_sdio_inst_CMD           : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
			hps_0_hps_io_hps_io_sdio_inst_D0            : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
			hps_0_hps_io_hps_io_sdio_inst_D1            : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
			hps_0_hps_io_hps_io_sdio_inst_CLK           : out   std_logic;                                        -- hps_io_sdio_inst_CLK
			hps_0_hps_io_hps_io_sdio_inst_D2            : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
			hps_0_hps_io_hps_io_sdio_inst_D3            : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D0            : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
			hps_0_hps_io_hps_io_usb1_inst_D1            : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
			hps_0_hps_io_hps_io_usb1_inst_D2            : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
			hps_0_hps_io_hps_io_usb1_inst_D3            : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D4            : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
			hps_0_hps_io_hps_io_usb1_inst_D5            : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
			hps_0_hps_io_hps_io_usb1_inst_D6            : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
			hps_0_hps_io_hps_io_usb1_inst_D7            : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
			hps_0_hps_io_hps_io_usb1_inst_CLK           : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
			hps_0_hps_io_hps_io_usb1_inst_STP           : out   std_logic;                                        -- hps_io_usb1_inst_STP
			hps_0_hps_io_hps_io_usb1_inst_DIR           : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
			hps_0_hps_io_hps_io_usb1_inst_NXT           : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
			hps_0_hps_io_hps_io_spim0_inst_CLK          : out   std_logic;                                        -- hps_io_spim0_inst_CLK
			hps_0_hps_io_hps_io_spim0_inst_MOSI         : out   std_logic;                                        -- hps_io_spim0_inst_MOSI
			hps_0_hps_io_hps_io_spim0_inst_MISO         : in    std_logic                     := 'X';             -- hps_io_spim0_inst_MISO
			hps_0_hps_io_hps_io_spim0_inst_SS0          : out   std_logic;                                        -- hps_io_spim0_inst_SS0
			hps_0_hps_io_hps_io_uart0_inst_RX           : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
			hps_0_hps_io_hps_io_uart0_inst_TX           : out   std_logic;                                        -- hps_io_uart0_inst_TX
			hps_0_hps_io_hps_io_i2c0_inst_SDA           : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SDA
			hps_0_hps_io_hps_io_i2c0_inst_SCL           : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SCL
			hps_0_hps_io_hps_io_can0_inst_RX            : in    std_logic                     := 'X';             -- hps_io_can0_inst_RX
			hps_0_hps_io_hps_io_can0_inst_TX            : out   std_logic;                                        -- hps_io_can0_inst_TX
			hps_0_hps_io_hps_io_trace_inst_CLK          : out   std_logic;                                        -- hps_io_trace_inst_CLK
			hps_0_hps_io_hps_io_trace_inst_D0           : out   std_logic;                                        -- hps_io_trace_inst_D0
			hps_0_hps_io_hps_io_trace_inst_D1           : out   std_logic;                                        -- hps_io_trace_inst_D1
			hps_0_hps_io_hps_io_trace_inst_D2           : out   std_logic;                                        -- hps_io_trace_inst_D2
			hps_0_hps_io_hps_io_trace_inst_D3           : out   std_logic;                                        -- hps_io_trace_inst_D3
			hps_0_hps_io_hps_io_trace_inst_D4           : out   std_logic;                                        -- hps_io_trace_inst_D4
			hps_0_hps_io_hps_io_trace_inst_D5           : out   std_logic;                                        -- hps_io_trace_inst_D5
			hps_0_hps_io_hps_io_trace_inst_D6           : out   std_logic;                                        -- hps_io_trace_inst_D6
			hps_0_hps_io_hps_io_trace_inst_D7           : out   std_logic;                                        -- hps_io_trace_inst_D7
			hps_0_hps_io_hps_io_gpio_inst_GPIO09        : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO09
			hps_0_hps_io_hps_io_gpio_inst_GPIO35        : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO35
			hps_0_hps_io_hps_io_gpio_inst_GPIO41        : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO41
			hps_0_hps_io_hps_io_gpio_inst_GPIO42        : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO42
			hps_0_hps_io_hps_io_gpio_inst_GPIO43        : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO43
			hps_0_hps_io_hps_io_gpio_inst_GPIO44        : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO44
			hps_0_f2h_stm_hw_events_stm_hwevents        : in    std_logic_vector(27 downto 0) := (others => 'X'); -- stm_hwevents
			hps_0_f2h_cold_reset_req_reset_n            : in    std_logic                     := 'X';             -- reset_n
			hps_0_f2h_debug_reset_req_reset_n           : in    std_logic                     := 'X';             -- reset_n
			hps_0_f2h_warm_reset_req_reset_n            : in    std_logic                     := 'X';             -- reset_n
			hps_0_h2f_reset_reset_n                     : out   std_logic;                                        -- reset_n
			sad_result_low_external_connection_export   : in    std_logic_vector(31 downto 0) := (others => 'X'); -- export
			hps_0_f2h_sdram0_clock_clk                  : in    std_logic                     := 'X';             -- clk
			sad_result_high_external_connection_export  : in    std_logic_vector(31 downto 0) := (others => 'X'); -- export
			acc_config_channel_vz                       : in    std_logic                     := 'X';             -- vz
			acc_config_channel_data                     : out   std_logic_vector(31 downto 0);                    -- data
			acc_config_channel_lz                       : out   std_logic;                                        -- lz
			result_ready_external_connection_export     : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- export
			lcu_loaded_external_connection_export       : in    std_logic                     := 'X';             -- export
			lambda_loaded_external_connection_export    : in    std_logic                     := 'X';             -- export
			axi_dma_unfiltered1_channel_lz_export       : out   std_logic;                                        -- export
			axi_dma_unfiltered1_channel_vz_export       : in    std_logic                     := 'X';             -- export
			axi_dma_unfiltered1_channel_data_export     : out   std_logic_vector(15 downto 0);                    -- export
			axi_dma_unfiltered1_clear_fifo_export       : in    std_logic                     := 'X';             -- export
			axi_dma_unfiltered2_channel_lz_export       : out   std_logic;                                        -- export
			axi_dma_unfiltered2_channel_vz_export       : in    std_logic                     := 'X';             -- export
			axi_dma_unfiltered2_channel_data_export     : out   std_logic_vector(15 downto 0);                    -- export
			axi_dma_unfiltered2_clear_fifo_export       : in    std_logic                     := 'X';             -- export
			axi_dma_orig_block_channel_lz_export        : out   std_logic;                                        -- export
			axi_dma_orig_block_channel_vz_export        : in    std_logic                     := 'X';             -- export
			axi_dma_orig_block_channel_data_export      : out   std_logic_vector(31 downto 0);                    -- export
			axi_dma_orig_block_clear_fifo_export        : in    std_logic                     := 'X';             -- export
			dma_yuv_fifo_clk_clk                        : in    std_logic                     := 'X';             -- clk
			dma_yuv_yuv_input_u_data_in_z               : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- u_data_in_z
			dma_yuv_yuv_input_v_data_in_lz              : out   std_logic;                                        -- v_data_in_lz
			dma_yuv_yuv_input_v_data_in_vz              : in    std_logic                     := 'X';             -- v_data_in_vz
			dma_yuv_yuv_input_v_data_in_z               : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- v_data_in_z
			dma_yuv_yuv_input_y_data_in_vz              : in    std_logic                     := 'X';             -- y_data_in_vz
			dma_yuv_yuv_input_y_data_in_z               : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- y_data_in_z
			dma_yuv_yuv_input_y_data_in_lz              : out   std_logic;                                        -- y_data_in_lz
			dma_yuv_yuv_input_clear_dma_and_fifo        : in    std_logic                     := 'X';             -- clear_dma_and_fifo
			dma_yuv_yuv_input_u_data_in_vz              : in    std_logic                     := 'X';             -- u_data_in_vz
			dma_yuv_yuv_input_u_data_in_lz              : out   std_logic;                                        -- u_data_in_lz
			camera_control_oc_s2_address                : in    std_logic_vector(5 downto 0)  := (others => 'X'); -- address
			camera_control_oc_s2_chipselect             : in    std_logic                     := 'X';             -- chipselect
			camera_control_oc_s2_clken                  : in    std_logic                     := 'X';             -- clken
			camera_control_oc_s2_write                  : in    std_logic                     := 'X';             -- write
			camera_control_oc_s2_readdata               : out   std_logic_vector(15 downto 0);                    -- readdata
			camera_control_oc_s2_writedata              : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			camera_control_oc_s2_byteenable             : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			configure_camera_external_connection_export : out   std_logic;                                        -- export
			yuv_ctrl_external_connection_export         : out   std_logic_vector(3 downto 0);                     -- export
			yuv_status_external_connection_export       : in    std_logic                     := 'X'              -- export
		);
	end component Kvazaar_QSYS;

	u0 : component Kvazaar_QSYS
		port map (
			memory_mem_a                                => CONNECTED_TO_memory_mem_a,                                --                               memory.mem_a
			memory_mem_ba                               => CONNECTED_TO_memory_mem_ba,                               --                                     .mem_ba
			memory_mem_ck                               => CONNECTED_TO_memory_mem_ck,                               --                                     .mem_ck
			memory_mem_ck_n                             => CONNECTED_TO_memory_mem_ck_n,                             --                                     .mem_ck_n
			memory_mem_cke                              => CONNECTED_TO_memory_mem_cke,                              --                                     .mem_cke
			memory_mem_cs_n                             => CONNECTED_TO_memory_mem_cs_n,                             --                                     .mem_cs_n
			memory_mem_ras_n                            => CONNECTED_TO_memory_mem_ras_n,                            --                                     .mem_ras_n
			memory_mem_cas_n                            => CONNECTED_TO_memory_mem_cas_n,                            --                                     .mem_cas_n
			memory_mem_we_n                             => CONNECTED_TO_memory_mem_we_n,                             --                                     .mem_we_n
			memory_mem_reset_n                          => CONNECTED_TO_memory_mem_reset_n,                          --                                     .mem_reset_n
			memory_mem_dq                               => CONNECTED_TO_memory_mem_dq,                               --                                     .mem_dq
			memory_mem_dqs                              => CONNECTED_TO_memory_mem_dqs,                              --                                     .mem_dqs
			memory_mem_dqs_n                            => CONNECTED_TO_memory_mem_dqs_n,                            --                                     .mem_dqs_n
			memory_mem_odt                              => CONNECTED_TO_memory_mem_odt,                              --                                     .mem_odt
			memory_mem_dm                               => CONNECTED_TO_memory_mem_dm,                               --                                     .mem_dm
			memory_oct_rzqin                            => CONNECTED_TO_memory_oct_rzqin,                            --                                     .oct_rzqin
			clk_clk                                     => CONNECTED_TO_clk_clk,                                     --                                  clk.clk
			reset_reset_n                               => CONNECTED_TO_reset_reset_n,                               --                                reset.reset_n
			hps_0_hps_io_hps_io_emac1_inst_TX_CLK       => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TX_CLK,       --                         hps_0_hps_io.hps_io_emac1_inst_TX_CLK
			hps_0_hps_io_hps_io_emac1_inst_TXD0         => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD0,         --                                     .hps_io_emac1_inst_TXD0
			hps_0_hps_io_hps_io_emac1_inst_TXD1         => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD1,         --                                     .hps_io_emac1_inst_TXD1
			hps_0_hps_io_hps_io_emac1_inst_TXD2         => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD2,         --                                     .hps_io_emac1_inst_TXD2
			hps_0_hps_io_hps_io_emac1_inst_TXD3         => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD3,         --                                     .hps_io_emac1_inst_TXD3
			hps_0_hps_io_hps_io_emac1_inst_RXD0         => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD0,         --                                     .hps_io_emac1_inst_RXD0
			hps_0_hps_io_hps_io_emac1_inst_MDIO         => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_MDIO,         --                                     .hps_io_emac1_inst_MDIO
			hps_0_hps_io_hps_io_emac1_inst_MDC          => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_MDC,          --                                     .hps_io_emac1_inst_MDC
			hps_0_hps_io_hps_io_emac1_inst_RX_CTL       => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RX_CTL,       --                                     .hps_io_emac1_inst_RX_CTL
			hps_0_hps_io_hps_io_emac1_inst_TX_CTL       => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TX_CTL,       --                                     .hps_io_emac1_inst_TX_CTL
			hps_0_hps_io_hps_io_emac1_inst_RX_CLK       => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RX_CLK,       --                                     .hps_io_emac1_inst_RX_CLK
			hps_0_hps_io_hps_io_emac1_inst_RXD1         => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD1,         --                                     .hps_io_emac1_inst_RXD1
			hps_0_hps_io_hps_io_emac1_inst_RXD2         => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD2,         --                                     .hps_io_emac1_inst_RXD2
			hps_0_hps_io_hps_io_emac1_inst_RXD3         => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD3,         --                                     .hps_io_emac1_inst_RXD3
			hps_0_hps_io_hps_io_qspi_inst_IO0           => CONNECTED_TO_hps_0_hps_io_hps_io_qspi_inst_IO0,           --                                     .hps_io_qspi_inst_IO0
			hps_0_hps_io_hps_io_qspi_inst_IO1           => CONNECTED_TO_hps_0_hps_io_hps_io_qspi_inst_IO1,           --                                     .hps_io_qspi_inst_IO1
			hps_0_hps_io_hps_io_qspi_inst_IO2           => CONNECTED_TO_hps_0_hps_io_hps_io_qspi_inst_IO2,           --                                     .hps_io_qspi_inst_IO2
			hps_0_hps_io_hps_io_qspi_inst_IO3           => CONNECTED_TO_hps_0_hps_io_hps_io_qspi_inst_IO3,           --                                     .hps_io_qspi_inst_IO3
			hps_0_hps_io_hps_io_qspi_inst_SS0           => CONNECTED_TO_hps_0_hps_io_hps_io_qspi_inst_SS0,           --                                     .hps_io_qspi_inst_SS0
			hps_0_hps_io_hps_io_qspi_inst_CLK           => CONNECTED_TO_hps_0_hps_io_hps_io_qspi_inst_CLK,           --                                     .hps_io_qspi_inst_CLK
			hps_0_hps_io_hps_io_sdio_inst_CMD           => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_CMD,           --                                     .hps_io_sdio_inst_CMD
			hps_0_hps_io_hps_io_sdio_inst_D0            => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D0,            --                                     .hps_io_sdio_inst_D0
			hps_0_hps_io_hps_io_sdio_inst_D1            => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D1,            --                                     .hps_io_sdio_inst_D1
			hps_0_hps_io_hps_io_sdio_inst_CLK           => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_CLK,           --                                     .hps_io_sdio_inst_CLK
			hps_0_hps_io_hps_io_sdio_inst_D2            => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D2,            --                                     .hps_io_sdio_inst_D2
			hps_0_hps_io_hps_io_sdio_inst_D3            => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D3,            --                                     .hps_io_sdio_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D0            => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D0,            --                                     .hps_io_usb1_inst_D0
			hps_0_hps_io_hps_io_usb1_inst_D1            => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D1,            --                                     .hps_io_usb1_inst_D1
			hps_0_hps_io_hps_io_usb1_inst_D2            => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D2,            --                                     .hps_io_usb1_inst_D2
			hps_0_hps_io_hps_io_usb1_inst_D3            => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D3,            --                                     .hps_io_usb1_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D4            => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D4,            --                                     .hps_io_usb1_inst_D4
			hps_0_hps_io_hps_io_usb1_inst_D5            => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D5,            --                                     .hps_io_usb1_inst_D5
			hps_0_hps_io_hps_io_usb1_inst_D6            => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D6,            --                                     .hps_io_usb1_inst_D6
			hps_0_hps_io_hps_io_usb1_inst_D7            => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D7,            --                                     .hps_io_usb1_inst_D7
			hps_0_hps_io_hps_io_usb1_inst_CLK           => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_CLK,           --                                     .hps_io_usb1_inst_CLK
			hps_0_hps_io_hps_io_usb1_inst_STP           => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_STP,           --                                     .hps_io_usb1_inst_STP
			hps_0_hps_io_hps_io_usb1_inst_DIR           => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_DIR,           --                                     .hps_io_usb1_inst_DIR
			hps_0_hps_io_hps_io_usb1_inst_NXT           => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_NXT,           --                                     .hps_io_usb1_inst_NXT
			hps_0_hps_io_hps_io_spim0_inst_CLK          => CONNECTED_TO_hps_0_hps_io_hps_io_spim0_inst_CLK,          --                                     .hps_io_spim0_inst_CLK
			hps_0_hps_io_hps_io_spim0_inst_MOSI         => CONNECTED_TO_hps_0_hps_io_hps_io_spim0_inst_MOSI,         --                                     .hps_io_spim0_inst_MOSI
			hps_0_hps_io_hps_io_spim0_inst_MISO         => CONNECTED_TO_hps_0_hps_io_hps_io_spim0_inst_MISO,         --                                     .hps_io_spim0_inst_MISO
			hps_0_hps_io_hps_io_spim0_inst_SS0          => CONNECTED_TO_hps_0_hps_io_hps_io_spim0_inst_SS0,          --                                     .hps_io_spim0_inst_SS0
			hps_0_hps_io_hps_io_uart0_inst_RX           => CONNECTED_TO_hps_0_hps_io_hps_io_uart0_inst_RX,           --                                     .hps_io_uart0_inst_RX
			hps_0_hps_io_hps_io_uart0_inst_TX           => CONNECTED_TO_hps_0_hps_io_hps_io_uart0_inst_TX,           --                                     .hps_io_uart0_inst_TX
			hps_0_hps_io_hps_io_i2c0_inst_SDA           => CONNECTED_TO_hps_0_hps_io_hps_io_i2c0_inst_SDA,           --                                     .hps_io_i2c0_inst_SDA
			hps_0_hps_io_hps_io_i2c0_inst_SCL           => CONNECTED_TO_hps_0_hps_io_hps_io_i2c0_inst_SCL,           --                                     .hps_io_i2c0_inst_SCL
			hps_0_hps_io_hps_io_can0_inst_RX            => CONNECTED_TO_hps_0_hps_io_hps_io_can0_inst_RX,            --                                     .hps_io_can0_inst_RX
			hps_0_hps_io_hps_io_can0_inst_TX            => CONNECTED_TO_hps_0_hps_io_hps_io_can0_inst_TX,            --                                     .hps_io_can0_inst_TX
			hps_0_hps_io_hps_io_trace_inst_CLK          => CONNECTED_TO_hps_0_hps_io_hps_io_trace_inst_CLK,          --                                     .hps_io_trace_inst_CLK
			hps_0_hps_io_hps_io_trace_inst_D0           => CONNECTED_TO_hps_0_hps_io_hps_io_trace_inst_D0,           --                                     .hps_io_trace_inst_D0
			hps_0_hps_io_hps_io_trace_inst_D1           => CONNECTED_TO_hps_0_hps_io_hps_io_trace_inst_D1,           --                                     .hps_io_trace_inst_D1
			hps_0_hps_io_hps_io_trace_inst_D2           => CONNECTED_TO_hps_0_hps_io_hps_io_trace_inst_D2,           --                                     .hps_io_trace_inst_D2
			hps_0_hps_io_hps_io_trace_inst_D3           => CONNECTED_TO_hps_0_hps_io_hps_io_trace_inst_D3,           --                                     .hps_io_trace_inst_D3
			hps_0_hps_io_hps_io_trace_inst_D4           => CONNECTED_TO_hps_0_hps_io_hps_io_trace_inst_D4,           --                                     .hps_io_trace_inst_D4
			hps_0_hps_io_hps_io_trace_inst_D5           => CONNECTED_TO_hps_0_hps_io_hps_io_trace_inst_D5,           --                                     .hps_io_trace_inst_D5
			hps_0_hps_io_hps_io_trace_inst_D6           => CONNECTED_TO_hps_0_hps_io_hps_io_trace_inst_D6,           --                                     .hps_io_trace_inst_D6
			hps_0_hps_io_hps_io_trace_inst_D7           => CONNECTED_TO_hps_0_hps_io_hps_io_trace_inst_D7,           --                                     .hps_io_trace_inst_D7
			hps_0_hps_io_hps_io_gpio_inst_GPIO09        => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO09,        --                                     .hps_io_gpio_inst_GPIO09
			hps_0_hps_io_hps_io_gpio_inst_GPIO35        => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO35,        --                                     .hps_io_gpio_inst_GPIO35
			hps_0_hps_io_hps_io_gpio_inst_GPIO41        => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO41,        --                                     .hps_io_gpio_inst_GPIO41
			hps_0_hps_io_hps_io_gpio_inst_GPIO42        => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO42,        --                                     .hps_io_gpio_inst_GPIO42
			hps_0_hps_io_hps_io_gpio_inst_GPIO43        => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO43,        --                                     .hps_io_gpio_inst_GPIO43
			hps_0_hps_io_hps_io_gpio_inst_GPIO44        => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO44,        --                                     .hps_io_gpio_inst_GPIO44
			hps_0_f2h_stm_hw_events_stm_hwevents        => CONNECTED_TO_hps_0_f2h_stm_hw_events_stm_hwevents,        --              hps_0_f2h_stm_hw_events.stm_hwevents
			hps_0_f2h_cold_reset_req_reset_n            => CONNECTED_TO_hps_0_f2h_cold_reset_req_reset_n,            --             hps_0_f2h_cold_reset_req.reset_n
			hps_0_f2h_debug_reset_req_reset_n           => CONNECTED_TO_hps_0_f2h_debug_reset_req_reset_n,           --            hps_0_f2h_debug_reset_req.reset_n
			hps_0_f2h_warm_reset_req_reset_n            => CONNECTED_TO_hps_0_f2h_warm_reset_req_reset_n,            --             hps_0_f2h_warm_reset_req.reset_n
			hps_0_h2f_reset_reset_n                     => CONNECTED_TO_hps_0_h2f_reset_reset_n,                     --                      hps_0_h2f_reset.reset_n
			sad_result_low_external_connection_export   => CONNECTED_TO_sad_result_low_external_connection_export,   --   sad_result_low_external_connection.export
			hps_0_f2h_sdram0_clock_clk                  => CONNECTED_TO_hps_0_f2h_sdram0_clock_clk,                  --               hps_0_f2h_sdram0_clock.clk
			sad_result_high_external_connection_export  => CONNECTED_TO_sad_result_high_external_connection_export,  --  sad_result_high_external_connection.export
			acc_config_channel_vz                       => CONNECTED_TO_acc_config_channel_vz,                       --                   acc_config_channel.vz
			acc_config_channel_data                     => CONNECTED_TO_acc_config_channel_data,                     --                                     .data
			acc_config_channel_lz                       => CONNECTED_TO_acc_config_channel_lz,                       --                                     .lz
			result_ready_external_connection_export     => CONNECTED_TO_result_ready_external_connection_export,     --     result_ready_external_connection.export
			lcu_loaded_external_connection_export       => CONNECTED_TO_lcu_loaded_external_connection_export,       --       lcu_loaded_external_connection.export
			lambda_loaded_external_connection_export    => CONNECTED_TO_lambda_loaded_external_connection_export,    --    lambda_loaded_external_connection.export
			axi_dma_unfiltered1_channel_lz_export       => CONNECTED_TO_axi_dma_unfiltered1_channel_lz_export,       --       axi_dma_unfiltered1_channel_lz.export
			axi_dma_unfiltered1_channel_vz_export       => CONNECTED_TO_axi_dma_unfiltered1_channel_vz_export,       --       axi_dma_unfiltered1_channel_vz.export
			axi_dma_unfiltered1_channel_data_export     => CONNECTED_TO_axi_dma_unfiltered1_channel_data_export,     --     axi_dma_unfiltered1_channel_data.export
			axi_dma_unfiltered1_clear_fifo_export       => CONNECTED_TO_axi_dma_unfiltered1_clear_fifo_export,       --       axi_dma_unfiltered1_clear_fifo.export
			axi_dma_unfiltered2_channel_lz_export       => CONNECTED_TO_axi_dma_unfiltered2_channel_lz_export,       --       axi_dma_unfiltered2_channel_lz.export
			axi_dma_unfiltered2_channel_vz_export       => CONNECTED_TO_axi_dma_unfiltered2_channel_vz_export,       --       axi_dma_unfiltered2_channel_vz.export
			axi_dma_unfiltered2_channel_data_export     => CONNECTED_TO_axi_dma_unfiltered2_channel_data_export,     --     axi_dma_unfiltered2_channel_data.export
			axi_dma_unfiltered2_clear_fifo_export       => CONNECTED_TO_axi_dma_unfiltered2_clear_fifo_export,       --       axi_dma_unfiltered2_clear_fifo.export
			axi_dma_orig_block_channel_lz_export        => CONNECTED_TO_axi_dma_orig_block_channel_lz_export,        --        axi_dma_orig_block_channel_lz.export
			axi_dma_orig_block_channel_vz_export        => CONNECTED_TO_axi_dma_orig_block_channel_vz_export,        --        axi_dma_orig_block_channel_vz.export
			axi_dma_orig_block_channel_data_export      => CONNECTED_TO_axi_dma_orig_block_channel_data_export,      --      axi_dma_orig_block_channel_data.export
			axi_dma_orig_block_clear_fifo_export        => CONNECTED_TO_axi_dma_orig_block_clear_fifo_export,        --        axi_dma_orig_block_clear_fifo.export
			dma_yuv_fifo_clk_clk                        => CONNECTED_TO_dma_yuv_fifo_clk_clk,                        --                     dma_yuv_fifo_clk.clk
			dma_yuv_yuv_input_u_data_in_z               => CONNECTED_TO_dma_yuv_yuv_input_u_data_in_z,               --                    dma_yuv_yuv_input.u_data_in_z
			dma_yuv_yuv_input_v_data_in_lz              => CONNECTED_TO_dma_yuv_yuv_input_v_data_in_lz,              --                                     .v_data_in_lz
			dma_yuv_yuv_input_v_data_in_vz              => CONNECTED_TO_dma_yuv_yuv_input_v_data_in_vz,              --                                     .v_data_in_vz
			dma_yuv_yuv_input_v_data_in_z               => CONNECTED_TO_dma_yuv_yuv_input_v_data_in_z,               --                                     .v_data_in_z
			dma_yuv_yuv_input_y_data_in_vz              => CONNECTED_TO_dma_yuv_yuv_input_y_data_in_vz,              --                                     .y_data_in_vz
			dma_yuv_yuv_input_y_data_in_z               => CONNECTED_TO_dma_yuv_yuv_input_y_data_in_z,               --                                     .y_data_in_z
			dma_yuv_yuv_input_y_data_in_lz              => CONNECTED_TO_dma_yuv_yuv_input_y_data_in_lz,              --                                     .y_data_in_lz
			dma_yuv_yuv_input_clear_dma_and_fifo        => CONNECTED_TO_dma_yuv_yuv_input_clear_dma_and_fifo,        --                                     .clear_dma_and_fifo
			dma_yuv_yuv_input_u_data_in_vz              => CONNECTED_TO_dma_yuv_yuv_input_u_data_in_vz,              --                                     .u_data_in_vz
			dma_yuv_yuv_input_u_data_in_lz              => CONNECTED_TO_dma_yuv_yuv_input_u_data_in_lz,              --                                     .u_data_in_lz
			camera_control_oc_s2_address                => CONNECTED_TO_camera_control_oc_s2_address,                --                 camera_control_oc_s2.address
			camera_control_oc_s2_chipselect             => CONNECTED_TO_camera_control_oc_s2_chipselect,             --                                     .chipselect
			camera_control_oc_s2_clken                  => CONNECTED_TO_camera_control_oc_s2_clken,                  --                                     .clken
			camera_control_oc_s2_write                  => CONNECTED_TO_camera_control_oc_s2_write,                  --                                     .write
			camera_control_oc_s2_readdata               => CONNECTED_TO_camera_control_oc_s2_readdata,               --                                     .readdata
			camera_control_oc_s2_writedata              => CONNECTED_TO_camera_control_oc_s2_writedata,              --                                     .writedata
			camera_control_oc_s2_byteenable             => CONNECTED_TO_camera_control_oc_s2_byteenable,             --                                     .byteenable
			configure_camera_external_connection_export => CONNECTED_TO_configure_camera_external_connection_export, -- configure_camera_external_connection.export
			yuv_ctrl_external_connection_export         => CONNECTED_TO_yuv_ctrl_external_connection_export,         --         yuv_ctrl_external_connection.export
			yuv_status_external_connection_export       => CONNECTED_TO_yuv_status_external_connection_export        --       yuv_status_external_connection.export
		);

