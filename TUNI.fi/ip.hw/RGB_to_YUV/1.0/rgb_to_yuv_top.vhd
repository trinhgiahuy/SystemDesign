library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

entity RGB_to_YUV is
port(
	clk 				: 	 IN std_logic;
	rst_n 			: 	 IN std_logic;
	iDval_z			:	 IN STD_LOGIC;
	iRed_z			:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	iGreen_z			:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	iBlue_z			:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	oY_z				:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	oY_vz				:	 IN STD_LOGIC;
	oY_lz				:	 OUT STD_LOGIC;
	oU_z				:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	oU_vz				:	 IN STD_LOGIC;
	oU_lz				:	 OUT STD_LOGIC;
	oV_z				:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	oV_vz				:	 IN STD_LOGIC;
	oV_lz				:	 OUT STD_LOGIC;
	x_pixels			:	 IN STD_LOGIC_VECTOR(11 DOWNTO 0);
	y_pixels			:	 IN STD_LOGIC_VECTOR(11 DOWNTO 0);
	write_done		:	 OUT STD_LOGIC;
	frame_valid		:	 IN STD_LOGIC;
	yuv_ctrl		:	 IN STD_LOGIC_VECTOR(3 DOWNTO 0)
);
end entity RGB_to_YUV;

architecture rtl of RGB_to_YUV is

signal R_addr			:	 STD_LOGIC_VECTOR(15 DOWNTO 0);
signal R_re				:	 STD_LOGIC;
signal R_data_out		:	 STD_LOGIC_VECTOR(7 DOWNTO 0);
signal G_addr			:	 STD_LOGIC_VECTOR(15 DOWNTO 0);
signal G_re				:	 STD_LOGIC;
signal G_data_out		:	 STD_LOGIC_VECTOR(7 DOWNTO 0);
signal B_addr			:	 STD_LOGIC_VECTOR(15 DOWNTO 0);
signal B_re				:	 STD_LOGIC;
signal B_data_out		:	 STD_LOGIC_VECTOR(7 DOWNTO 0);

COMPONENT rgb2yuv
	PORT
	(
		iDval_rsc_z		:	 IN STD_LOGIC;
		iRed_rsc_z		:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		iGreen_rsc_z		:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		iBlue_rsc_z		:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		oY_rsc_z		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		oY_rsc_vz		:	 IN STD_LOGIC;
		oY_rsc_lz		:	 OUT STD_LOGIC;
		oU_rsc_z		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		oU_rsc_vz		:	 IN STD_LOGIC;
		oU_rsc_lz		:	 OUT STD_LOGIC;
		oV_rsc_z		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		oV_rsc_vz		:	 IN STD_LOGIC;
		oV_rsc_lz		:	 OUT STD_LOGIC;
		x_pixels_rsc_z		:	 IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		y_pixels_rsc_z		:	 IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		write_done_rsc_z		:	 OUT STD_LOGIC;
		frame_valid_rsc_z		:	 IN STD_LOGIC;
		next_frame_rsc_z		:	 IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		R_rsc_addr		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		R_rsc_re		:	 OUT STD_LOGIC;
		R_rsc_data_out		:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		G_rsc_addr		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		G_rsc_re		:	 OUT STD_LOGIC;
		G_rsc_data_out		:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		B_rsc_addr		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		B_rsc_re		:	 OUT STD_LOGIC;
		B_rsc_data_out		:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		clk		:	 IN STD_LOGIC;
		arst_n		:	 IN STD_LOGIC
	);
END COMPONENT;


begin

	r_data : altsyncram
	GENERIC MAP (
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "R.hex",
		intended_device_family => "Cyclone V",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 52000,
		operation_mode => "SINGLE_PORT",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		power_up_uninitialized => "FALSE",
		read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
		widthad_a => 16,
		width_a => 8,
		width_byteena_a => 1
	)
	PORT MAP (
		address_a => R_addr,
		clock0 => clk,
		q_a => R_data_out
	);
	
	g_data : altsyncram
	GENERIC MAP (
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "G.hex",
		intended_device_family => "Cyclone V",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 52000,
		operation_mode => "SINGLE_PORT",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		power_up_uninitialized => "FALSE",
		read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
		widthad_a => 16,
		width_a => 8,
		width_byteena_a => 1
	)
	PORT MAP (
		address_a => G_addr,
		clock0 => clk,
		q_a => G_data_out
	);
	
	b_data : altsyncram
	GENERIC MAP (
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "B.hex",
		intended_device_family => "Cyclone V",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 52000,
		operation_mode => "SINGLE_PORT",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		power_up_uninitialized => "FALSE",
		read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
		widthad_a => 16,
		width_a => 8,
		width_byteena_a => 1
	)
	PORT MAP (
		address_a => B_addr,
		clock0 => clk,
		q_a => B_data_out
	);

rgb_to_yuv_inst : rgb2yuv
port map(
		iDval_rsc_z => iDval_z,
		iRed_rsc_z => iRed_z,
		iGreen_rsc_z => iGreen_z,
		iBlue_rsc_z => iBlue_z,
		oY_rsc_z => oY_z,
		oY_rsc_vz => oY_vz,
		oY_rsc_lz => oY_lz,
		oU_rsc_z => oU_z,
		oU_rsc_vz => oU_vz,
		oU_rsc_lz => oU_lz,
		oV_rsc_z => oV_z,
		oV_rsc_vz => oV_vz,
		oV_rsc_lz => oV_lz,
		x_pixels_rsc_z => x_pixels,
		y_pixels_rsc_z => y_pixels,
		write_done_rsc_z => write_done,
		frame_valid_rsc_z => frame_valid,
		next_frame_rsc_z => yuv_ctrl,
		R_rsc_addr => R_addr,
		--R_rsc_re => R_re,
		R_rsc_data_out => R_data_out,
		G_rsc_addr => G_addr,
		--G_rsc_re => G_re,
		G_rsc_data_out => G_data_out,
		B_rsc_addr => B_addr,
		--B_rsc_re => B_re,
		B_rsc_data_out => B_data_out,
		clk => clk,
		arst_n => rst_n
);

end architecture rtl;