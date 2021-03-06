// megafunction wizard: %Shift register (RAM-based)%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: ALTSHIFT_TAPS 

// ============================================================
// File Name: Line_Buffer.v
// Megafunction Name(s):
// 			ALTSHIFT_TAPS
//
// Simulation Library Files(s):
// 			altera_mf
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 10.0 Build 262 08/18/2010 SP 1 SJ Full Version
// ************************************************************


//Copyright (C) 1991-2010 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module Line_Buffer (
	clken,
	clock,
	shiftin,
	shiftout,
	taps);

	input	  clken;
	input	  clock;
	input	[11:0]  shiftin;
	output	[11:0]  shiftout;
	output	[23:0]  taps;

	wire [11:0] sub_wire0;
	wire [23:0] sub_wire1;
	wire [11:0] shiftout = sub_wire0[11:0];
	wire [23:0] taps = sub_wire1[23:0];

	altshift_taps	ALTSHIFT_TAPS_component (
				.clock (clock),
				.clken (clken),
				.shiftin (shiftin),
				.shiftout (sub_wire0),
				.taps (sub_wire1)
				// synopsys translate_off
				,
				.aclr ()
				// synopsys translate_on
				);
	defparam
		ALTSHIFT_TAPS_component.lpm_hint = "RAM_BLOCK_TYPE=M4K",
		ALTSHIFT_TAPS_component.lpm_type = "altshift_taps",
		ALTSHIFT_TAPS_component.number_of_taps = 2,
		ALTSHIFT_TAPS_component.power_up_state = "CLEARED",
		ALTSHIFT_TAPS_component.tap_distance = 800,
		//ALTSHIFT_TAPS_component.tap_distance = 400,
		ALTSHIFT_TAPS_component.width = 12;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
// Retrieval info: CONSTANT: LPM_HINT STRING "RAM_BLOCK_TYPE=M4K"
// Retrieval info: CONSTANT: LPM_TYPE STRING "altshift_taps"
// Retrieval info: CONSTANT: NUMBER_OF_TAPS NUMERIC "2"
// Retrieval info: CONSTANT: POWER_UP_STATE STRING "CLEARED"
// Retrieval info: CONSTANT: TAP_DISTANCE NUMERIC "800"
// Retrieval info: CONSTANT: WIDTH NUMERIC "12"
// Retrieval info: USED_PORT: clken 0 0 0 0 INPUT NODEFVAL "clken"
// Retrieval info: CONNECT: @clken 0 0 0 0 clken 0 0 0 0
// Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL "clock"
// Retrieval info: CONNECT: @clock 0 0 0 0 clock 0 0 0 0
// Retrieval info: USED_PORT: shiftin 0 0 12 0 INPUT NODEFVAL "shiftin[11..0]"
// Retrieval info: CONNECT: @shiftin 0 0 12 0 shiftin 0 0 12 0
// Retrieval info: USED_PORT: shiftout 0 0 12 0 OUTPUT NODEFVAL "shiftout[11..0]"
// Retrieval info: CONNECT: shiftout 0 0 12 0 @shiftout 0 0 12 0
// Retrieval info: USED_PORT: taps 0 0 24 0 OUTPUT NODEFVAL "taps[23..0]"
// Retrieval info: CONNECT: taps 0 0 24 0 @taps 0 0 24 0
// Retrieval info: GEN_FILE: TYPE_NORMAL Line_Buffer.v TRUE FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Line_Buffer.qip TRUE FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Line_Buffer.bsf TRUE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL Line_Buffer_inst.v FALSE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL Line_Buffer_bb.v FALSE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL Line_Buffer.inc FALSE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL Line_Buffer.cmp FALSE TRUE
// Retrieval info: LIB_FILE: altera_mf
