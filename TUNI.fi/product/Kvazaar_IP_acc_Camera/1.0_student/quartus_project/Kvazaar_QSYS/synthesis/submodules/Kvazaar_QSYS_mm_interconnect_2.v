// Kvazaar_QSYS_mm_interconnect_2.v

// This file was auto-generated from altera_mm_interconnect_hw.tcl.  If you edit it your changes
// will probably be lost.
// 
// Generated using ACDS version 16.0 211

`timescale 1 ps / 1 ps
module Kvazaar_QSYS_mm_interconnect_2 (
		input  wire [6:0]  axi_dma_unfiltered1_altera_axi_master_awid,                                         //                                        axi_dma_unfiltered1_altera_axi_master.awid
		input  wire [31:0] axi_dma_unfiltered1_altera_axi_master_awaddr,                                       //                                                                             .awaddr
		input  wire [3:0]  axi_dma_unfiltered1_altera_axi_master_awlen,                                        //                                                                             .awlen
		input  wire [2:0]  axi_dma_unfiltered1_altera_axi_master_awsize,                                       //                                                                             .awsize
		input  wire [1:0]  axi_dma_unfiltered1_altera_axi_master_awburst,                                      //                                                                             .awburst
		input  wire [1:0]  axi_dma_unfiltered1_altera_axi_master_awlock,                                       //                                                                             .awlock
		input  wire [3:0]  axi_dma_unfiltered1_altera_axi_master_awcache,                                      //                                                                             .awcache
		input  wire [2:0]  axi_dma_unfiltered1_altera_axi_master_awprot,                                       //                                                                             .awprot
		input  wire        axi_dma_unfiltered1_altera_axi_master_awvalid,                                      //                                                                             .awvalid
		output wire        axi_dma_unfiltered1_altera_axi_master_awready,                                      //                                                                             .awready
		input  wire [6:0]  axi_dma_unfiltered1_altera_axi_master_wid,                                          //                                                                             .wid
		input  wire [63:0] axi_dma_unfiltered1_altera_axi_master_wdata,                                        //                                                                             .wdata
		input  wire [7:0]  axi_dma_unfiltered1_altera_axi_master_wstrb,                                        //                                                                             .wstrb
		input  wire        axi_dma_unfiltered1_altera_axi_master_wlast,                                        //                                                                             .wlast
		input  wire        axi_dma_unfiltered1_altera_axi_master_wvalid,                                       //                                                                             .wvalid
		output wire        axi_dma_unfiltered1_altera_axi_master_wready,                                       //                                                                             .wready
		output wire [6:0]  axi_dma_unfiltered1_altera_axi_master_bid,                                          //                                                                             .bid
		output wire [1:0]  axi_dma_unfiltered1_altera_axi_master_bresp,                                        //                                                                             .bresp
		output wire        axi_dma_unfiltered1_altera_axi_master_bvalid,                                       //                                                                             .bvalid
		input  wire        axi_dma_unfiltered1_altera_axi_master_bready,                                       //                                                                             .bready
		input  wire [6:0]  axi_dma_unfiltered1_altera_axi_master_arid,                                         //                                                                             .arid
		input  wire [31:0] axi_dma_unfiltered1_altera_axi_master_araddr,                                       //                                                                             .araddr
		input  wire [3:0]  axi_dma_unfiltered1_altera_axi_master_arlen,                                        //                                                                             .arlen
		input  wire [2:0]  axi_dma_unfiltered1_altera_axi_master_arsize,                                       //                                                                             .arsize
		input  wire [1:0]  axi_dma_unfiltered1_altera_axi_master_arburst,                                      //                                                                             .arburst
		input  wire [1:0]  axi_dma_unfiltered1_altera_axi_master_arlock,                                       //                                                                             .arlock
		input  wire [3:0]  axi_dma_unfiltered1_altera_axi_master_arcache,                                      //                                                                             .arcache
		input  wire [2:0]  axi_dma_unfiltered1_altera_axi_master_arprot,                                       //                                                                             .arprot
		input  wire        axi_dma_unfiltered1_altera_axi_master_arvalid,                                      //                                                                             .arvalid
		output wire        axi_dma_unfiltered1_altera_axi_master_arready,                                      //                                                                             .arready
		output wire [6:0]  axi_dma_unfiltered1_altera_axi_master_rid,                                          //                                                                             .rid
		output wire [63:0] axi_dma_unfiltered1_altera_axi_master_rdata,                                        //                                                                             .rdata
		output wire [1:0]  axi_dma_unfiltered1_altera_axi_master_rresp,                                        //                                                                             .rresp
		output wire        axi_dma_unfiltered1_altera_axi_master_rlast,                                        //                                                                             .rlast
		output wire        axi_dma_unfiltered1_altera_axi_master_rvalid,                                       //                                                                             .rvalid
		input  wire        axi_dma_unfiltered1_altera_axi_master_rready,                                       //                                                                             .rready
		output wire [7:0]  hps_0_f2h_sdram2_data_awid,                                                         //                                                        hps_0_f2h_sdram2_data.awid
		output wire [31:0] hps_0_f2h_sdram2_data_awaddr,                                                       //                                                                             .awaddr
		output wire [3:0]  hps_0_f2h_sdram2_data_awlen,                                                        //                                                                             .awlen
		output wire [2:0]  hps_0_f2h_sdram2_data_awsize,                                                       //                                                                             .awsize
		output wire [1:0]  hps_0_f2h_sdram2_data_awburst,                                                      //                                                                             .awburst
		output wire [1:0]  hps_0_f2h_sdram2_data_awlock,                                                       //                                                                             .awlock
		output wire [3:0]  hps_0_f2h_sdram2_data_awcache,                                                      //                                                                             .awcache
		output wire [2:0]  hps_0_f2h_sdram2_data_awprot,                                                       //                                                                             .awprot
		output wire        hps_0_f2h_sdram2_data_awvalid,                                                      //                                                                             .awvalid
		input  wire        hps_0_f2h_sdram2_data_awready,                                                      //                                                                             .awready
		output wire [7:0]  hps_0_f2h_sdram2_data_wid,                                                          //                                                                             .wid
		output wire [63:0] hps_0_f2h_sdram2_data_wdata,                                                        //                                                                             .wdata
		output wire [7:0]  hps_0_f2h_sdram2_data_wstrb,                                                        //                                                                             .wstrb
		output wire        hps_0_f2h_sdram2_data_wlast,                                                        //                                                                             .wlast
		output wire        hps_0_f2h_sdram2_data_wvalid,                                                       //                                                                             .wvalid
		input  wire        hps_0_f2h_sdram2_data_wready,                                                       //                                                                             .wready
		input  wire [7:0]  hps_0_f2h_sdram2_data_bid,                                                          //                                                                             .bid
		input  wire [1:0]  hps_0_f2h_sdram2_data_bresp,                                                        //                                                                             .bresp
		input  wire        hps_0_f2h_sdram2_data_bvalid,                                                       //                                                                             .bvalid
		output wire        hps_0_f2h_sdram2_data_bready,                                                       //                                                                             .bready
		output wire [7:0]  hps_0_f2h_sdram2_data_arid,                                                         //                                                                             .arid
		output wire [31:0] hps_0_f2h_sdram2_data_araddr,                                                       //                                                                             .araddr
		output wire [3:0]  hps_0_f2h_sdram2_data_arlen,                                                        //                                                                             .arlen
		output wire [2:0]  hps_0_f2h_sdram2_data_arsize,                                                       //                                                                             .arsize
		output wire [1:0]  hps_0_f2h_sdram2_data_arburst,                                                      //                                                                             .arburst
		output wire [1:0]  hps_0_f2h_sdram2_data_arlock,                                                       //                                                                             .arlock
		output wire [3:0]  hps_0_f2h_sdram2_data_arcache,                                                      //                                                                             .arcache
		output wire [2:0]  hps_0_f2h_sdram2_data_arprot,                                                       //                                                                             .arprot
		output wire        hps_0_f2h_sdram2_data_arvalid,                                                      //                                                                             .arvalid
		input  wire        hps_0_f2h_sdram2_data_arready,                                                      //                                                                             .arready
		input  wire [7:0]  hps_0_f2h_sdram2_data_rid,                                                          //                                                                             .rid
		input  wire [63:0] hps_0_f2h_sdram2_data_rdata,                                                        //                                                                             .rdata
		input  wire [1:0]  hps_0_f2h_sdram2_data_rresp,                                                        //                                                                             .rresp
		input  wire        hps_0_f2h_sdram2_data_rlast,                                                        //                                                                             .rlast
		input  wire        hps_0_f2h_sdram2_data_rvalid,                                                       //                                                                             .rvalid
		output wire        hps_0_f2h_sdram2_data_rready,                                                       //                                                                             .rready
		input  wire        clk_0_clk_clk,                                                                      //                                                                    clk_0_clk.clk
		input  wire        axi_dma_unfiltered1_altera_axi_master_id_pad_clk_reset_reset_bridge_in_reset_reset, // axi_dma_unfiltered1_altera_axi_master_id_pad_clk_reset_reset_bridge_in_reset.reset
		input  wire        axi_dma_unfiltered1_reset_sink_reset_bridge_in_reset_reset                          //                         axi_dma_unfiltered1_reset_sink_reset_bridge_in_reset.reset
	);

	altera_merlin_axi_translator #(
		.USE_S0_AWID                       (1),
		.USE_S0_AWREGION                   (0),
		.USE_M0_AWREGION                   (1),
		.USE_S0_AWLEN                      (1),
		.USE_S0_AWSIZE                     (1),
		.USE_S0_AWBURST                    (1),
		.USE_S0_AWLOCK                     (1),
		.USE_M0_AWLOCK                     (1),
		.USE_S0_AWCACHE                    (1),
		.USE_M0_AWCACHE                    (1),
		.USE_M0_AWPROT                     (1),
		.USE_S0_AWQOS                      (0),
		.USE_M0_AWQOS                      (1),
		.USE_S0_WSTRB                      (1),
		.USE_M0_WLAST                      (1),
		.USE_S0_BID                        (1),
		.USE_S0_BRESP                      (1),
		.USE_M0_BRESP                      (1),
		.USE_S0_ARID                       (1),
		.USE_S0_ARREGION                   (0),
		.USE_M0_ARREGION                   (1),
		.USE_S0_ARLEN                      (1),
		.USE_S0_ARSIZE                     (1),
		.USE_S0_ARBURST                    (1),
		.USE_S0_ARLOCK                     (1),
		.USE_M0_ARLOCK                     (1),
		.USE_M0_ARCACHE                    (1),
		.USE_M0_ARQOS                      (1),
		.USE_M0_ARPROT                     (1),
		.USE_S0_ARCACHE                    (1),
		.USE_S0_ARQOS                      (0),
		.USE_S0_RID                        (1),
		.USE_S0_RRESP                      (1),
		.USE_M0_RRESP                      (1),
		.USE_S0_RLAST                      (1),
		.M0_ID_WIDTH                       (8),
		.DATA_WIDTH                        (64),
		.S0_ID_WIDTH                       (7),
		.M0_ADDR_WIDTH                     (32),
		.S0_WRITE_ADDR_USER_WIDTH          (1),
		.S0_READ_ADDR_USER_WIDTH           (1),
		.M0_WRITE_ADDR_USER_WIDTH          (1),
		.M0_READ_ADDR_USER_WIDTH           (1),
		.S0_WRITE_DATA_USER_WIDTH          (1),
		.S0_WRITE_RESPONSE_DATA_USER_WIDTH (1),
		.S0_READ_DATA_USER_WIDTH           (1),
		.M0_WRITE_DATA_USER_WIDTH          (1),
		.M0_WRITE_RESPONSE_DATA_USER_WIDTH (1),
		.M0_READ_DATA_USER_WIDTH           (1),
		.S0_ADDR_WIDTH                     (32),
		.USE_S0_AWUSER                     (0),
		.USE_S0_ARUSER                     (0),
		.USE_S0_WUSER                      (0),
		.USE_S0_RUSER                      (0),
		.USE_S0_BUSER                      (0),
		.USE_M0_AWUSER                     (0),
		.USE_M0_ARUSER                     (0),
		.USE_M0_WUSER                      (0),
		.USE_M0_RUSER                      (0),
		.USE_M0_BUSER                      (0),
		.M0_AXI_VERSION                    ("AXI3"),
		.M0_BURST_LENGTH_WIDTH             (4),
		.S0_BURST_LENGTH_WIDTH             (4),
		.M0_LOCK_WIDTH                     (2),
		.S0_LOCK_WIDTH                     (2),
		.S0_AXI_VERSION                    ("AXI3")
	) axi_dma_unfiltered1_altera_axi_master_id_pad (
		.aclk        (clk_0_clk_clk),                                                                       //       clk.clk
		.aresetn     (~axi_dma_unfiltered1_altera_axi_master_id_pad_clk_reset_reset_bridge_in_reset_reset), // clk_reset.reset_n
		.m0_awid     (hps_0_f2h_sdram2_data_awid),                                                          //        m0.awid
		.m0_awaddr   (hps_0_f2h_sdram2_data_awaddr),                                                        //          .awaddr
		.m0_awlen    (hps_0_f2h_sdram2_data_awlen),                                                         //          .awlen
		.m0_awsize   (hps_0_f2h_sdram2_data_awsize),                                                        //          .awsize
		.m0_awburst  (hps_0_f2h_sdram2_data_awburst),                                                       //          .awburst
		.m0_awlock   (hps_0_f2h_sdram2_data_awlock),                                                        //          .awlock
		.m0_awcache  (hps_0_f2h_sdram2_data_awcache),                                                       //          .awcache
		.m0_awprot   (hps_0_f2h_sdram2_data_awprot),                                                        //          .awprot
		.m0_awvalid  (hps_0_f2h_sdram2_data_awvalid),                                                       //          .awvalid
		.m0_awready  (hps_0_f2h_sdram2_data_awready),                                                       //          .awready
		.m0_wid      (hps_0_f2h_sdram2_data_wid),                                                           //          .wid
		.m0_wdata    (hps_0_f2h_sdram2_data_wdata),                                                         //          .wdata
		.m0_wstrb    (hps_0_f2h_sdram2_data_wstrb),                                                         //          .wstrb
		.m0_wlast    (hps_0_f2h_sdram2_data_wlast),                                                         //          .wlast
		.m0_wvalid   (hps_0_f2h_sdram2_data_wvalid),                                                        //          .wvalid
		.m0_wready   (hps_0_f2h_sdram2_data_wready),                                                        //          .wready
		.m0_bid      (hps_0_f2h_sdram2_data_bid),                                                           //          .bid
		.m0_bresp    (hps_0_f2h_sdram2_data_bresp),                                                         //          .bresp
		.m0_bvalid   (hps_0_f2h_sdram2_data_bvalid),                                                        //          .bvalid
		.m0_bready   (hps_0_f2h_sdram2_data_bready),                                                        //          .bready
		.m0_arid     (hps_0_f2h_sdram2_data_arid),                                                          //          .arid
		.m0_araddr   (hps_0_f2h_sdram2_data_araddr),                                                        //          .araddr
		.m0_arlen    (hps_0_f2h_sdram2_data_arlen),                                                         //          .arlen
		.m0_arsize   (hps_0_f2h_sdram2_data_arsize),                                                        //          .arsize
		.m0_arburst  (hps_0_f2h_sdram2_data_arburst),                                                       //          .arburst
		.m0_arlock   (hps_0_f2h_sdram2_data_arlock),                                                        //          .arlock
		.m0_arcache  (hps_0_f2h_sdram2_data_arcache),                                                       //          .arcache
		.m0_arprot   (hps_0_f2h_sdram2_data_arprot),                                                        //          .arprot
		.m0_arvalid  (hps_0_f2h_sdram2_data_arvalid),                                                       //          .arvalid
		.m0_arready  (hps_0_f2h_sdram2_data_arready),                                                       //          .arready
		.m0_rid      (hps_0_f2h_sdram2_data_rid),                                                           //          .rid
		.m0_rdata    (hps_0_f2h_sdram2_data_rdata),                                                         //          .rdata
		.m0_rresp    (hps_0_f2h_sdram2_data_rresp),                                                         //          .rresp
		.m0_rlast    (hps_0_f2h_sdram2_data_rlast),                                                         //          .rlast
		.m0_rvalid   (hps_0_f2h_sdram2_data_rvalid),                                                        //          .rvalid
		.m0_rready   (hps_0_f2h_sdram2_data_rready),                                                        //          .rready
		.s0_awid     (axi_dma_unfiltered1_altera_axi_master_awid),                                          //        s0.awid
		.s0_awaddr   (axi_dma_unfiltered1_altera_axi_master_awaddr),                                        //          .awaddr
		.s0_awlen    (axi_dma_unfiltered1_altera_axi_master_awlen),                                         //          .awlen
		.s0_awsize   (axi_dma_unfiltered1_altera_axi_master_awsize),                                        //          .awsize
		.s0_awburst  (axi_dma_unfiltered1_altera_axi_master_awburst),                                       //          .awburst
		.s0_awlock   (axi_dma_unfiltered1_altera_axi_master_awlock),                                        //          .awlock
		.s0_awcache  (axi_dma_unfiltered1_altera_axi_master_awcache),                                       //          .awcache
		.s0_awprot   (axi_dma_unfiltered1_altera_axi_master_awprot),                                        //          .awprot
		.s0_awvalid  (axi_dma_unfiltered1_altera_axi_master_awvalid),                                       //          .awvalid
		.s0_awready  (axi_dma_unfiltered1_altera_axi_master_awready),                                       //          .awready
		.s0_wid      (axi_dma_unfiltered1_altera_axi_master_wid),                                           //          .wid
		.s0_wdata    (axi_dma_unfiltered1_altera_axi_master_wdata),                                         //          .wdata
		.s0_wstrb    (axi_dma_unfiltered1_altera_axi_master_wstrb),                                         //          .wstrb
		.s0_wlast    (axi_dma_unfiltered1_altera_axi_master_wlast),                                         //          .wlast
		.s0_wvalid   (axi_dma_unfiltered1_altera_axi_master_wvalid),                                        //          .wvalid
		.s0_wready   (axi_dma_unfiltered1_altera_axi_master_wready),                                        //          .wready
		.s0_bid      (axi_dma_unfiltered1_altera_axi_master_bid),                                           //          .bid
		.s0_bresp    (axi_dma_unfiltered1_altera_axi_master_bresp),                                         //          .bresp
		.s0_bvalid   (axi_dma_unfiltered1_altera_axi_master_bvalid),                                        //          .bvalid
		.s0_bready   (axi_dma_unfiltered1_altera_axi_master_bready),                                        //          .bready
		.s0_arid     (axi_dma_unfiltered1_altera_axi_master_arid),                                          //          .arid
		.s0_araddr   (axi_dma_unfiltered1_altera_axi_master_araddr),                                        //          .araddr
		.s0_arlen    (axi_dma_unfiltered1_altera_axi_master_arlen),                                         //          .arlen
		.s0_arsize   (axi_dma_unfiltered1_altera_axi_master_arsize),                                        //          .arsize
		.s0_arburst  (axi_dma_unfiltered1_altera_axi_master_arburst),                                       //          .arburst
		.s0_arlock   (axi_dma_unfiltered1_altera_axi_master_arlock),                                        //          .arlock
		.s0_arcache  (axi_dma_unfiltered1_altera_axi_master_arcache),                                       //          .arcache
		.s0_arprot   (axi_dma_unfiltered1_altera_axi_master_arprot),                                        //          .arprot
		.s0_arvalid  (axi_dma_unfiltered1_altera_axi_master_arvalid),                                       //          .arvalid
		.s0_arready  (axi_dma_unfiltered1_altera_axi_master_arready),                                       //          .arready
		.s0_rid      (axi_dma_unfiltered1_altera_axi_master_rid),                                           //          .rid
		.s0_rdata    (axi_dma_unfiltered1_altera_axi_master_rdata),                                         //          .rdata
		.s0_rresp    (axi_dma_unfiltered1_altera_axi_master_rresp),                                         //          .rresp
		.s0_rlast    (axi_dma_unfiltered1_altera_axi_master_rlast),                                         //          .rlast
		.s0_rvalid   (axi_dma_unfiltered1_altera_axi_master_rvalid),                                        //          .rvalid
		.s0_rready   (axi_dma_unfiltered1_altera_axi_master_rready),                                        //          .rready
		.m0_awuser   (),                                                                                    // (terminated)
		.m0_aruser   (),                                                                                    // (terminated)
		.s0_awuser   (1'b0),                                                                                // (terminated)
		.s0_aruser   (1'b0),                                                                                // (terminated)
		.s0_awqos    (4'b0000),                                                                             // (terminated)
		.s0_arqos    (4'b0000),                                                                             // (terminated)
		.s0_awregion (4'b0000),                                                                             // (terminated)
		.s0_arregion (4'b0000),                                                                             // (terminated)
		.s0_wuser    (64'b0000000000000000000000000000000000000000000000000000000000000000),                // (terminated)
		.s0_ruser    (),                                                                                    // (terminated)
		.s0_buser    (),                                                                                    // (terminated)
		.m0_awqos    (),                                                                                    // (terminated)
		.m0_arqos    (),                                                                                    // (terminated)
		.m0_awregion (),                                                                                    // (terminated)
		.m0_arregion (),                                                                                    // (terminated)
		.m0_wuser    (),                                                                                    // (terminated)
		.m0_ruser    (64'b0000000000000000000000000000000000000000000000000000000000000000),                // (terminated)
		.m0_buser    (64'b0000000000000000000000000000000000000000000000000000000000000000)                 // (terminated)
	);

endmodule
