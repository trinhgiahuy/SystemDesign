library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IP_SAD_Accelerator is

generic(
	unfilt_width_g : integer := 16;
	ctrl_to_ip_units_width_g : integer := 32;
	ip_units_to_sad_width_g : integer := 16
	);
port(
clk: in std_logic;
arst_n: in std_logic;

ip_config_in_z				:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
ip_config_in_vz			:	 IN STD_LOGIC;
ip_config_in_lz			:	 OUT STD_LOGIC;

unfiltered1_z				:	 IN STD_LOGIC_VECTOR(unfilt_width_g-1 DOWNTO 0);
unfiltered1_vz				:	 IN STD_LOGIC;
unfiltered1_lz				:	 OUT STD_LOGIC;
unfiltered2_z				:	 IN STD_LOGIC_VECTOR(unfilt_width_g-1 DOWNTO 0);
unfiltered2_vz				:	 IN STD_LOGIC;
unfiltered2_lz				:	 OUT STD_LOGIC;

orig_block_data_in_z		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
orig_block_data_in_vz	:	 IN STD_LOGIC;
orig_block_data_in_lz	:	 OUT STD_LOGIC;
sad_result					:	 OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
result_ready				:	 OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
lcu_loaded					:	 OUT STD_LOGIC;
lambda_loaded				:	 OUT STD_LOGIC;
clear_unfilt1_fifo					:    OUT STD_LOGIC;
clear_unfilt2_fifo					:    OUT STD_LOGIC;
clear_orig_fifo					:    OUT STD_LOGIC
);
end IP_SAD_Accelerator;

architecture hierarchy of IP_SAD_Accelerator is

COMPONENT main_ip_config
	PORT
	(
		config_rsc_z		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		config_rsc_vz		:	 IN STD_LOGIC;
		config_rsc_lz		:	 OUT STD_LOGIC;
		ctrl_config_rsc_z		:	 OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		ctrl_config_rsc_vz		:	 IN STD_LOGIC;
		ctrl_config_rsc_lz		:	 OUT STD_LOGIC;
		sad_config_rsc_z		:	 OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		sad_config_rsc_vz		:	 IN STD_LOGIC;
		sad_config_rsc_lz		:	 OUT STD_LOGIC;
		clk		:	 IN STD_LOGIC;
		arst_n		:	 IN STD_LOGIC
	);
END COMPONENT;


COMPONENT main_ip_ctrl
	PORT
	(
		out1_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out1_rsc_vz		:	 IN STD_LOGIC;
		out1_rsc_lz		:	 OUT STD_LOGIC;
		out2_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out2_rsc_vz		:	 IN STD_LOGIC;
		out2_rsc_lz		:	 OUT STD_LOGIC;
		out3_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out3_rsc_vz		:	 IN STD_LOGIC;
		out3_rsc_lz		:	 OUT STD_LOGIC;
		out4_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out4_rsc_vz		:	 IN STD_LOGIC;
		out4_rsc_lz		:	 OUT STD_LOGIC;
		out5_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out5_rsc_vz		:	 IN STD_LOGIC;
		out5_rsc_lz		:	 OUT STD_LOGIC;
		out6_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out6_rsc_vz		:	 IN STD_LOGIC;
		out6_rsc_lz		:	 OUT STD_LOGIC;
		out7_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out7_rsc_vz		:	 IN STD_LOGIC;
		out7_rsc_lz		:	 OUT STD_LOGIC;
		out8_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out8_rsc_vz		:	 IN STD_LOGIC;
		out8_rsc_lz		:	 OUT STD_LOGIC;
		out9_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out9_rsc_vz		:	 IN STD_LOGIC;
		out9_rsc_lz		:	 OUT STD_LOGIC;
		out10_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out10_rsc_vz		:	 IN STD_LOGIC;
		out10_rsc_lz		:	 OUT STD_LOGIC;
		out11_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out11_rsc_vz		:	 IN STD_LOGIC;
		out11_rsc_lz		:	 OUT STD_LOGIC;
		out12_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out12_rsc_vz		:	 IN STD_LOGIC;
		out12_rsc_lz		:	 OUT STD_LOGIC;
		out13_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out13_rsc_vz		:	 IN STD_LOGIC;
		out13_rsc_lz		:	 OUT STD_LOGIC;
		out14_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out14_rsc_vz		:	 IN STD_LOGIC;
		out14_rsc_lz		:	 OUT STD_LOGIC;
		out15_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out15_rsc_vz		:	 IN STD_LOGIC;
		out15_rsc_lz		:	 OUT STD_LOGIC;
		out16_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out16_rsc_vz		:	 IN STD_LOGIC;
		out16_rsc_lz		:	 OUT STD_LOGIC;
		out17_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out17_rsc_vz		:	 IN STD_LOGIC;
		out17_rsc_lz		:	 OUT STD_LOGIC;
		out18_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out18_rsc_vz		:	 IN STD_LOGIC;
		out18_rsc_lz		:	 OUT STD_LOGIC;
		out19_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out19_rsc_vz		:	 IN STD_LOGIC;
		out19_rsc_lz		:	 OUT STD_LOGIC;
		out20_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out20_rsc_vz		:	 IN STD_LOGIC;
		out20_rsc_lz		:	 OUT STD_LOGIC;
		out21_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out21_rsc_vz		:	 IN STD_LOGIC;
		out21_rsc_lz		:	 OUT STD_LOGIC;
		out22_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out22_rsc_vz		:	 IN STD_LOGIC;
		out22_rsc_lz		:	 OUT STD_LOGIC;
		out23_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out23_rsc_vz		:	 IN STD_LOGIC;
		out23_rsc_lz		:	 OUT STD_LOGIC;
		out24_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out24_rsc_vz		:	 IN STD_LOGIC;
		out24_rsc_lz		:	 OUT STD_LOGIC;
		out25_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out25_rsc_vz		:	 IN STD_LOGIC;
		out25_rsc_lz		:	 OUT STD_LOGIC;
		out26_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out26_rsc_vz		:	 IN STD_LOGIC;
		out26_rsc_lz		:	 OUT STD_LOGIC;
		out27_rsc_z		:	 OUT STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		out27_rsc_vz		:	 IN STD_LOGIC;
		out27_rsc_lz		:	 OUT STD_LOGIC;
		config_rsc_z		:	 IN STD_LOGIC_VECTOR(32 DOWNTO 0);
		config_rsc_vz		:	 IN STD_LOGIC;
		config_rsc_lz		:	 OUT STD_LOGIC;
		--sad_config_rsc_z		:	 OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		--sad_config_rsc_vz		:	 IN STD_LOGIC;
		--sad_config_rsc_lz		:	 OUT STD_LOGIC;
		unfiltered1_rsc_z		:	 IN STD_LOGIC_VECTOR(unfilt_width_g-1 DOWNTO 0);
		unfiltered1_rsc_vz		:	 IN STD_LOGIC;
		unfiltered1_rsc_lz		:	 OUT STD_LOGIC;
		unfiltered2_rsc_z		:	 IN STD_LOGIC_VECTOR(unfilt_width_g-1 DOWNTO 0);
		unfiltered2_rsc_vz		:	 IN STD_LOGIC;
		unfiltered2_rsc_lz		:	 OUT STD_LOGIC;
		clk		:	 IN STD_LOGIC;
		arst_n		:	 IN STD_LOGIC
	);
END COMPONENT;

COMPONENT main_sad_parallel
	PORT
	(
		in1_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in1_rsc_vz		:	 IN STD_LOGIC;
		in1_rsc_lz		:	 OUT STD_LOGIC;
		in2_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in2_rsc_vz		:	 IN STD_LOGIC;
		in2_rsc_lz		:	 OUT STD_LOGIC;
		in3_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in3_rsc_vz		:	 IN STD_LOGIC;
		in3_rsc_lz		:	 OUT STD_LOGIC;
		in4_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in4_rsc_vz		:	 IN STD_LOGIC;
		in4_rsc_lz		:	 OUT STD_LOGIC;
		in5_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in5_rsc_vz		:	 IN STD_LOGIC;
		in5_rsc_lz		:	 OUT STD_LOGIC;
		in6_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in6_rsc_vz		:	 IN STD_LOGIC;
		in6_rsc_lz		:	 OUT STD_LOGIC;
		in7_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in7_rsc_vz		:	 IN STD_LOGIC;
		in7_rsc_lz		:	 OUT STD_LOGIC;
		in8_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in8_rsc_vz		:	 IN STD_LOGIC;
		in8_rsc_lz		:	 OUT STD_LOGIC;
		in9_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in9_rsc_vz		:	 IN STD_LOGIC;
		in9_rsc_lz		:	 OUT STD_LOGIC;
		in10_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in10_rsc_vz		:	 IN STD_LOGIC;
		in10_rsc_lz		:	 OUT STD_LOGIC;
		in11_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in11_rsc_vz		:	 IN STD_LOGIC;
		in11_rsc_lz		:	 OUT STD_LOGIC;
		in12_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in12_rsc_vz		:	 IN STD_LOGIC;
		in12_rsc_lz		:	 OUT STD_LOGIC;
		in13_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in13_rsc_vz		:	 IN STD_LOGIC;
		in13_rsc_lz		:	 OUT STD_LOGIC;
		in14_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in14_rsc_vz		:	 IN STD_LOGIC;
		in14_rsc_lz		:	 OUT STD_LOGIC;
		in15_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in15_rsc_vz		:	 IN STD_LOGIC;
		in15_rsc_lz		:	 OUT STD_LOGIC;
		in16_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in16_rsc_vz		:	 IN STD_LOGIC;
		in16_rsc_lz		:	 OUT STD_LOGIC;
		in17_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in17_rsc_vz		:	 IN STD_LOGIC;
		in17_rsc_lz		:	 OUT STD_LOGIC;
		in18_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in18_rsc_vz		:	 IN STD_LOGIC;
		in18_rsc_lz		:	 OUT STD_LOGIC;
		in19_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in19_rsc_vz		:	 IN STD_LOGIC;
		in19_rsc_lz		:	 OUT STD_LOGIC;
		in20_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in20_rsc_vz		:	 IN STD_LOGIC;
		in20_rsc_lz		:	 OUT STD_LOGIC;
		in21_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in21_rsc_vz		:	 IN STD_LOGIC;
		in21_rsc_lz		:	 OUT STD_LOGIC;
		in22_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in22_rsc_vz		:	 IN STD_LOGIC;
		in22_rsc_lz		:	 OUT STD_LOGIC;
		in23_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in23_rsc_vz		:	 IN STD_LOGIC;
		in23_rsc_lz		:	 OUT STD_LOGIC;
		in24_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in24_rsc_vz		:	 IN STD_LOGIC;
		in24_rsc_lz		:	 OUT STD_LOGIC;
		in25_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in25_rsc_vz		:	 IN STD_LOGIC;
		in25_rsc_lz		:	 OUT STD_LOGIC;
		in26_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in26_rsc_vz		:	 IN STD_LOGIC;
		in26_rsc_lz		:	 OUT STD_LOGIC;
		in27_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in27_rsc_vz		:	 IN STD_LOGIC;
		in27_rsc_lz		:	 OUT STD_LOGIC;
		in28_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in28_rsc_vz		:	 IN STD_LOGIC;
		in28_rsc_lz		:	 OUT STD_LOGIC;
		in29_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in29_rsc_vz		:	 IN STD_LOGIC;
		in29_rsc_lz		:	 OUT STD_LOGIC;
		in30_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in30_rsc_vz		:	 IN STD_LOGIC;
		in30_rsc_lz		:	 OUT STD_LOGIC;
		in31_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in31_rsc_vz		:	 IN STD_LOGIC;
		in31_rsc_lz		:	 OUT STD_LOGIC;
		in32_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in32_rsc_vz		:	 IN STD_LOGIC;
		in32_rsc_lz		:	 OUT STD_LOGIC;
		in33_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in33_rsc_vz		:	 IN STD_LOGIC;
		in33_rsc_lz		:	 OUT STD_LOGIC;
		in34_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in34_rsc_vz		:	 IN STD_LOGIC;
		in34_rsc_lz		:	 OUT STD_LOGIC;
		in35_rsc_z		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		in35_rsc_vz		:	 IN STD_LOGIC;
		in35_rsc_lz		:	 OUT STD_LOGIC;
		data_in_rsc_z		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_in_rsc_vz		:	 IN STD_LOGIC;
		data_in_rsc_lz		:	 OUT STD_LOGIC;
		sad_result_rsc_z		:	 OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
		config_rsc_z		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		config_rsc_vz		:	 IN STD_LOGIC;
		config_rsc_lz		:	 OUT STD_LOGIC;
		result_ready_rsc_z		:	 OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		lcu_loaded_rsc_z		:	 OUT STD_LOGIC;
		lambda_loaded_rsc_z		:	 OUT STD_LOGIC;
		clk		:	 IN STD_LOGIC;
		arst_n		:	 IN STD_LOGIC
	);
END COMPONENT;


COMPONENT main_ip_get_planar
PORT
(
data_in_rsc_z		:	 IN STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
data_in_rsc_vz		:	 IN STD_LOGIC;
data_in_rsc_lz		:	 OUT STD_LOGIC;
data_out_rsc_z		:	 OUT STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
data_out_rsc_vz		:	 IN STD_LOGIC;
data_out_rsc_lz		:	 OUT STD_LOGIC;
clk		:	 IN STD_LOGIC;
arst_n		:	 IN STD_LOGIC
);
END COMPONENT;

COMPONENT main_ip_get_dc
	PORT
	(
		data_in_rsc_z		:	 IN STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		data_in_rsc_vz		:	 IN STD_LOGIC;
		data_in_rsc_lz		:	 OUT STD_LOGIC;
		data_out_rsc_z		:	 OUT STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
		data_out_rsc_vz		:	 IN STD_LOGIC;
		data_out_rsc_lz		:	 OUT STD_LOGIC;
		clk		:	 IN STD_LOGIC;
		arst_n		:	 IN STD_LOGIC
	);
END COMPONENT;

COMPONENT main_ip_get_ang_neg
	PORT
	(
		data_in_rsc_z		:	 IN STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		data_in_rsc_vz		:	 IN STD_LOGIC;
		data_in_rsc_lz		:	 OUT STD_LOGIC;
		data_out_rsc_z		:	 OUT STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
		data_out_rsc_vz		:	 IN STD_LOGIC;
		data_out_rsc_lz		:	 OUT STD_LOGIC;
		clk		:	 IN STD_LOGIC;
		arst_n		:	 IN STD_LOGIC
	);
END COMPONENT;

COMPONENT main_ip_get_ang_pos
	PORT
	(
		data_in_rsc_z		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_in_rsc_vz		:	 IN STD_LOGIC;
		data_in_rsc_lz		:	 OUT STD_LOGIC;
		data_out_ver_rsc_z		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		data_out_ver_rsc_vz		:	 IN STD_LOGIC;
		data_out_ver_rsc_lz		:	 OUT STD_LOGIC;
		data_out_hor_rsc_z		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		data_out_hor_rsc_vz		:	 IN STD_LOGIC;
		data_out_hor_rsc_lz		:	 OUT STD_LOGIC;
		clk		:	 IN STD_LOGIC;
		arst_n		:	 IN STD_LOGIC
	);
END COMPONENT;


COMPONENT main_ip_get_ang_zero
	PORT
	(
		data_in_rsc_z		:	 IN STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
		data_in_rsc_vz		:	 IN STD_LOGIC;
		data_in_rsc_lz		:	 OUT STD_LOGIC;
		data_out_rsc_z		:	 OUT STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
		data_out_rsc_vz		:	 IN STD_LOGIC;
		data_out_rsc_lz		:	 OUT STD_LOGIC;
		clk		:	 IN STD_LOGIC;
		arst_n		:	 IN STD_LOGIC
	);
END COMPONENT;

signal in1_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in1_vz : STD_LOGIC;
signal in1_lz : STD_LOGIC;
signal in2_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in2_vz : STD_LOGIC;
signal in2_lz : STD_LOGIC;
signal in3_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in3_vz : STD_LOGIC;
signal in3_lz : STD_LOGIC;
signal in4_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in4_vz : STD_LOGIC;
signal in4_lz : STD_LOGIC;
signal in5_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in5_vz : STD_LOGIC;
signal in5_lz : STD_LOGIC;
signal in6_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in6_vz : STD_LOGIC;
signal in6_lz : STD_LOGIC;
signal in7_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in7_vz : STD_LOGIC;
signal in7_lz : STD_LOGIC;
signal in8_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in8_vz : STD_LOGIC;
signal in8_lz : STD_LOGIC;
signal in9_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in9_vz : STD_LOGIC;
signal in9_lz : STD_LOGIC;
signal in10_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in10_vz : STD_LOGIC;
signal in10_lz : STD_LOGIC;
signal in11_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in11_vz : STD_LOGIC;
signal in11_lz : STD_LOGIC;
signal in12_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in12_vz : STD_LOGIC;
signal in12_lz : STD_LOGIC;
signal in13_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in13_vz : STD_LOGIC;
signal in13_lz : STD_LOGIC;
signal in14_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in14_vz : STD_LOGIC;
signal in14_lz : STD_LOGIC;
signal in15_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in15_vz : STD_LOGIC;
signal in15_lz : STD_LOGIC;
signal in16_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in16_vz : STD_LOGIC;
signal in16_lz : STD_LOGIC;
signal in17_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in17_vz : STD_LOGIC;
signal in17_lz : STD_LOGIC;
signal in18_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in18_vz : STD_LOGIC;
signal in18_lz : STD_LOGIC;
signal in19_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in19_vz : STD_LOGIC;
signal in19_lz : STD_LOGIC;
signal in20_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in20_vz : STD_LOGIC;
signal in20_lz : STD_LOGIC;
signal in21_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in21_vz : STD_LOGIC;
signal in21_lz : STD_LOGIC;
signal in22_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in22_vz : STD_LOGIC;
signal in22_lz : STD_LOGIC;
signal in23_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in23_vz : STD_LOGIC;
signal in23_lz : STD_LOGIC;
signal in24_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in24_vz : STD_LOGIC;
signal in24_lz : STD_LOGIC;
signal in25_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in25_vz : STD_LOGIC;
signal in25_lz : STD_LOGIC;
signal in26_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in26_vz : STD_LOGIC;
signal in26_lz : STD_LOGIC;
signal in27_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in27_vz : STD_LOGIC;
signal in27_lz : STD_LOGIC;
signal in28_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in28_vz : STD_LOGIC;
signal in28_lz : STD_LOGIC;
signal in29_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in29_vz : STD_LOGIC;
signal in29_lz : STD_LOGIC;
signal in30_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in30_vz : STD_LOGIC;
signal in30_lz : STD_LOGIC;
signal in31_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in31_vz : STD_LOGIC;
signal in31_lz : STD_LOGIC;
signal in32_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in32_vz : STD_LOGIC;
signal in32_lz : STD_LOGIC;
signal in33_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in33_vz : STD_LOGIC;
signal in33_lz : STD_LOGIC;
signal in34_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in34_vz : STD_LOGIC;
signal in34_lz : STD_LOGIC;
signal in35_z : STD_LOGIC_VECTOR(ip_units_to_sad_width_g-1 DOWNTO 0);
signal in35_vz : STD_LOGIC;
signal in35_lz : STD_LOGIC;

signal out1_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out1_vz : STD_LOGIC;
signal out1_lz : STD_LOGIC;
signal out2_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out2_vz : STD_LOGIC;
signal out2_lz : STD_LOGIC;
signal out3_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out3_vz : STD_LOGIC;
signal out3_lz : STD_LOGIC;
signal out4_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out4_vz : STD_LOGIC;
signal out4_lz : STD_LOGIC;
signal out5_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out5_vz : STD_LOGIC;
signal out5_lz : STD_LOGIC;
signal out6_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out6_vz : STD_LOGIC;
signal out6_lz : STD_LOGIC;
signal out7_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out7_vz : STD_LOGIC;
signal out7_lz : STD_LOGIC;
signal out8_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out8_vz : STD_LOGIC;
signal out8_lz : STD_LOGIC;
signal out9_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out9_vz : STD_LOGIC;
signal out9_lz : STD_LOGIC;
signal out10_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out10_vz : STD_LOGIC;
signal out10_lz : STD_LOGIC;
signal out11_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out11_vz : STD_LOGIC;
signal out11_lz : STD_LOGIC;
signal out12_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out12_vz : STD_LOGIC;
signal out12_lz : STD_LOGIC;
signal out13_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out13_vz : STD_LOGIC;
signal out13_lz : STD_LOGIC;
signal out14_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out14_vz : STD_LOGIC;
signal out14_lz : STD_LOGIC;
signal out15_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out15_vz : STD_LOGIC;
signal out15_lz : STD_LOGIC;
signal out16_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out16_vz : STD_LOGIC;
signal out16_lz : STD_LOGIC;
signal out17_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out17_vz : STD_LOGIC;
signal out17_lz : STD_LOGIC;
signal out18_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out18_vz : STD_LOGIC;
signal out18_lz : STD_LOGIC;
signal out19_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out19_vz : STD_LOGIC;
signal out19_lz : STD_LOGIC;
signal out20_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out20_vz : STD_LOGIC;
signal out20_lz : STD_LOGIC;
signal out21_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out21_vz : STD_LOGIC;
signal out21_lz : STD_LOGIC;
signal out22_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out22_vz : STD_LOGIC;
signal out22_lz : STD_LOGIC;
signal out23_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out23_vz : STD_LOGIC;
signal out23_lz : STD_LOGIC;
signal out24_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out24_vz : STD_LOGIC;
signal out24_lz : STD_LOGIC;
signal out25_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out25_vz : STD_LOGIC;
signal out25_lz : STD_LOGIC;
signal out26_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out26_vz : STD_LOGIC;
signal out26_lz : STD_LOGIC;
signal out27_z : STD_LOGIC_VECTOR(ctrl_to_ip_units_width_g-1 DOWNTO 0);
signal out27_vz : STD_LOGIC;
signal out27_lz : STD_LOGIC;

signal ctrl_config_z		: STD_LOGIC_VECTOR(32 DOWNTO 0);
signal ctrl_config_vz	: STD_LOGIC;
signal ctrl_config_lz	: STD_LOGIC;

signal sad_config_z		: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal sad_config_vz	: STD_LOGIC;
signal sad_config_lz	: STD_LOGIC;

signal clock : STD_LOGIC;
signal reset : STD_LOGIC;

signal result_ready_s		: STD_LOGIC_VECTOR(1 DOWNTO 0);
signal lcu_loaded_s 		: STD_LOGIC;

begin

ip_config : main_ip_config
port map(
config_rsc_z => ip_config_in_z,
config_rsc_vz => ip_config_in_vz,
config_rsc_lz => ip_config_in_lz,
ctrl_config_rsc_z => ctrl_config_z(31 downto 0),
ctrl_config_rsc_vz => ctrl_config_vz,
ctrl_config_rsc_lz => ctrl_config_lz,
sad_config_rsc_z => sad_config_z,
sad_config_rsc_vz => sad_config_vz,
sad_config_rsc_lz => sad_config_lz,
clk => clock,
arst_n => reset
);

ip_control : main_ip_ctrl
port map(
out1_rsc_z => out1_z,		  
out1_rsc_vz => out1_vz,
out1_rsc_lz => out1_lz,		  
out2_rsc_z => out2_z, 
out2_rsc_vz => out2_vz, 
out2_rsc_lz => out2_lz,			  
out3_rsc_z => out3_z,			  
out3_rsc_vz => out3_vz,			  
out3_rsc_lz => out3_lz,			  
out4_rsc_z => out4_z,			  
out4_rsc_vz => out4_vz,			  
out4_rsc_lz => out4_lz,			  
out5_rsc_z => out5_z,			  
out5_rsc_vz => out5_vz,			  
out5_rsc_lz => out5_lz,			  
out6_rsc_z => out6_z,			  
out6_rsc_vz => out6_vz,			  
out6_rsc_lz => out6_lz,			  
out7_rsc_z => out7_z,			  
out7_rsc_vz => out7_vz,			  
out7_rsc_lz => out7_lz,			  
out8_rsc_z => out8_z,			  
out8_rsc_vz => out8_vz,			  
out8_rsc_lz => out8_lz,			  
out9_rsc_z => out9_z,			  
out9_rsc_vz => out9_vz,			  
out9_rsc_lz => out9_lz,			  
out10_rsc_z => out10_z,			  
out10_rsc_vz => out10_vz,			  
out10_rsc_lz => out10_lz,			  
out11_rsc_z => out11_z,			  
out11_rsc_vz => out11_vz,			  
out11_rsc_lz => out11_lz,			  
out12_rsc_z => out12_z,			  
out12_rsc_vz => out12_vz,			  
out12_rsc_lz => out12_lz,			  
out13_rsc_z => out13_z,			  
out13_rsc_vz => out13_vz,			  
out13_rsc_lz => out13_lz,			  
out14_rsc_z => out14_z,			  
out14_rsc_vz => out14_vz,			  
out14_rsc_lz => out14_lz,			  
out15_rsc_z => out15_z,			  
out15_rsc_vz => out15_vz,			  
out15_rsc_lz => out15_lz,			  
out16_rsc_z => out16_z,		  
out16_rsc_vz => out16_vz,			  
out16_rsc_lz => out16_lz,			  
out17_rsc_z => out17_z,			  
out17_rsc_vz => out17_vz,			  
out17_rsc_lz => out17_lz,		  
out18_rsc_z => out18_z,			  
out18_rsc_vz => out18_vz,			  
out18_rsc_lz => out18_lz,			  
out19_rsc_z => out19_z,			  
out19_rsc_vz => out19_vz,			  
out19_rsc_lz => out19_lz,			  
out20_rsc_z => out20_z,			  
out20_rsc_vz => out20_vz,			  
out20_rsc_lz => out20_lz,			  
out21_rsc_z => out21_z,			  
out21_rsc_vz => out21_vz,			  
out21_rsc_lz => out21_lz,			  
out22_rsc_z => out22_z,			  
out22_rsc_vz => out22_vz,			  
out22_rsc_lz => out22_lz,			  
out23_rsc_z => out23_z,			  
out23_rsc_vz => out23_vz,			  
out23_rsc_lz => out23_lz,			  
out24_rsc_z => out24_z,			  
out24_rsc_vz => out24_vz,			  
out24_rsc_lz => out24_lz,			  
out25_rsc_z => out25_z,			  
out25_rsc_vz => out25_vz,			  
out25_rsc_lz => out25_lz,			  
out26_rsc_z => out26_z,			  
out26_rsc_vz => out26_vz,			  
out26_rsc_lz => out26_lz,
out27_rsc_z => out27_z,			  
out27_rsc_vz => out27_vz,			  
out27_rsc_lz => out27_lz,		  
config_rsc_z => ctrl_config_z,
config_rsc_vz => ctrl_config_lz,
config_rsc_lz => ctrl_config_vz,
--sad_config_rsc_z	=> sad_config_z,
--sad_config_rsc_vz => sad_config_lz,
--sad_config_rsc_lz => sad_config_vz,
unfiltered1_rsc_z	=> unfiltered1_z,
unfiltered1_rsc_vz => unfiltered1_vz,
unfiltered1_rsc_lz => unfiltered1_lz,
unfiltered2_rsc_z => unfiltered2_z,
unfiltered2_rsc_vz => unfiltered2_vz,
unfiltered2_rsc_lz => unfiltered2_lz,
clk => clock,
arst_n => reset);

ip_get_planar : main_ip_get_planar
port map(
data_in_rsc_z => out1_z,
data_in_rsc_vz => out1_lz,
data_in_rsc_lz => out1_vz,
data_out_rsc_z => in1_z,
data_out_rsc_vz => in1_lz,
data_out_rsc_lz => in1_vz,
clk => clock,
arst_n => reset);

ip_get_dc : main_ip_get_dc
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out2_z,
data_in_rsc_vz => out2_lz,
data_in_rsc_lz => out2_vz,
data_out_rsc_z => in2_z,
data_out_rsc_vz => in2_lz,
data_out_rsc_lz => in2_vz,
clk => clock,
arst_n => reset);

ip_get_ang3 : main_ip_get_ang_pos
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out3_z,
data_in_rsc_vz => out3_lz,
data_in_rsc_lz => out3_vz,
data_out_ver_rsc_z => in35_z,
data_out_ver_rsc_vz => in35_lz,
data_out_ver_rsc_lz => in35_vz,
data_out_hor_rsc_z => in3_z,
data_out_hor_rsc_vz => in3_lz,
data_out_hor_rsc_lz => in3_vz,
clk => clock,
arst_n => reset);

ip_get_ang4 : main_ip_get_ang_pos
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out4_z,
data_in_rsc_vz => out4_lz,
data_in_rsc_lz => out4_vz,
data_out_ver_rsc_z => in34_z,
data_out_ver_rsc_vz => in34_lz,
data_out_ver_rsc_lz => in34_vz,
data_out_hor_rsc_z => in4_z,
data_out_hor_rsc_vz => in4_lz,
data_out_hor_rsc_lz => in4_vz,
clk => clock,
arst_n => reset);

ip_get_ang5 : main_ip_get_ang_pos
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out5_z,
data_in_rsc_vz => out5_lz,
data_in_rsc_lz => out5_vz,
data_out_ver_rsc_z => in33_z,
data_out_ver_rsc_vz => in33_lz,
data_out_ver_rsc_lz => in33_vz,
data_out_hor_rsc_z => in5_z,
data_out_hor_rsc_vz => in5_lz,
data_out_hor_rsc_lz => in5_vz,
clk => clock,
arst_n => reset);

ip_get_ang6 : main_ip_get_ang_pos
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out6_z,
data_in_rsc_vz => out6_lz,
data_in_rsc_lz => out6_vz,
data_out_ver_rsc_z => in32_z,
data_out_ver_rsc_vz => in32_lz,
data_out_ver_rsc_lz => in32_vz,
data_out_hor_rsc_z => in6_z,
data_out_hor_rsc_vz => in6_lz,
data_out_hor_rsc_lz => in6_vz,
clk => clock,
arst_n => reset);

ip_get_ang7 : main_ip_get_ang_pos
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out7_z,
data_in_rsc_vz => out7_lz,
data_in_rsc_lz => out7_vz,
data_out_ver_rsc_z => in31_z,
data_out_ver_rsc_vz => in31_lz,
data_out_ver_rsc_lz => in31_vz,
data_out_hor_rsc_z => in7_z,
data_out_hor_rsc_vz => in7_lz,
data_out_hor_rsc_lz => in7_vz,
clk => clock,
arst_n => reset);
ip_get_ang8 : main_ip_get_ang_pos
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out8_z,
data_in_rsc_vz => out8_lz,
data_in_rsc_lz => out8_vz,
data_out_ver_rsc_z => in30_z,
data_out_ver_rsc_vz => in30_lz,
data_out_ver_rsc_lz => in30_vz,
data_out_hor_rsc_z => in8_z,
data_out_hor_rsc_vz => in8_lz,
data_out_hor_rsc_lz => in8_vz,
clk => clock,
arst_n => reset);
ip_get_ang9 : main_ip_get_ang_pos
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out9_z,
data_in_rsc_vz => out9_lz,
data_in_rsc_lz => out9_vz,
data_out_ver_rsc_z => in29_z,
data_out_ver_rsc_vz => in29_lz,
data_out_ver_rsc_lz => in29_vz,
data_out_hor_rsc_z => in9_z,
data_out_hor_rsc_vz => in9_lz,
data_out_hor_rsc_lz => in9_vz,
clk => clock,
arst_n => reset);
ip_get_ang10 : main_ip_get_ang_pos
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out10_z,
data_in_rsc_vz => out10_lz,
data_in_rsc_lz => out10_vz,
data_out_ver_rsc_z => in28_z,
data_out_ver_rsc_vz => in28_lz,
data_out_ver_rsc_lz => in28_vz,
data_out_hor_rsc_z => in10_z,
data_out_hor_rsc_vz => in10_lz,
data_out_hor_rsc_lz => in10_vz,
clk => clock,
arst_n => reset);
ip_get_ang11 : main_ip_get_ang_zero
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out11_z,
data_in_rsc_vz => out11_lz,
data_in_rsc_lz => out11_vz,
data_out_rsc_z => in11_z,
data_out_rsc_vz => in11_lz,
data_out_rsc_lz => in11_vz,
clk => clock,
arst_n => reset);
ip_get_ang12 : main_ip_get_ang_neg
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out12_z,
data_in_rsc_vz => out12_lz,
data_in_rsc_lz => out12_vz,
data_out_rsc_z => in12_z,
data_out_rsc_vz => in12_lz,
data_out_rsc_lz => in12_vz,
clk => clock,
arst_n => reset);
ip_get_ang13 : main_ip_get_ang_neg
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out13_z,
data_in_rsc_vz => out13_lz,
data_in_rsc_lz => out13_vz,
data_out_rsc_z => in13_z,
data_out_rsc_vz => in13_lz,
data_out_rsc_lz => in13_vz,
clk => clock,
arst_n => reset);
ip_get_ang14 : main_ip_get_ang_neg
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out14_z,
data_in_rsc_vz => out14_lz,
data_in_rsc_lz => out14_vz,
data_out_rsc_z => in14_z,
data_out_rsc_vz => in14_lz,
data_out_rsc_lz => in14_vz,
clk => clock,
arst_n => reset);
ip_get_ang15 : main_ip_get_ang_neg
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out15_z,
data_in_rsc_vz => out15_lz,
data_in_rsc_lz => out15_vz,
data_out_rsc_z => in15_z,
data_out_rsc_vz => in15_lz,
data_out_rsc_lz => in15_vz,
clk => clock,
arst_n => reset);
ip_get_ang16 : main_ip_get_ang_neg
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out16_z,
data_in_rsc_vz => out16_lz,
data_in_rsc_lz => out16_vz,
data_out_rsc_z => in16_z,
data_out_rsc_vz => in16_lz,
data_out_rsc_lz => in16_vz,
clk => clock,
arst_n => reset);
ip_get_ang17 : main_ip_get_ang_neg
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out17_z,
data_in_rsc_vz => out17_lz,
data_in_rsc_lz => out17_vz,
data_out_rsc_z => in17_z,
data_out_rsc_vz => in17_lz,
data_out_rsc_lz => in17_vz,
clk => clock,
arst_n => reset);
ip_get_ang18 : main_ip_get_ang_neg
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out18_z,
data_in_rsc_vz => out18_lz,
data_in_rsc_lz => out18_vz,
data_out_rsc_z => in18_z,
data_out_rsc_vz => in18_lz,
data_out_rsc_lz => in18_vz,
clk => clock,
arst_n => reset);
ip_get_ang19 : main_ip_get_ang_neg
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out19_z,
data_in_rsc_vz => out19_lz,
data_in_rsc_lz => out19_vz,
data_out_rsc_z => in19_z,
data_out_rsc_vz => in19_lz,
data_out_rsc_lz => in19_vz,
clk => clock,
arst_n => reset);
ip_get_ang20 : main_ip_get_ang_neg
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out20_z,
data_in_rsc_vz => out20_lz,
data_in_rsc_lz => out20_vz,
data_out_rsc_z => in20_z,
data_out_rsc_vz => in20_lz,
data_out_rsc_lz => in20_vz,
clk => clock,
arst_n => reset);
ip_get_ang21 : main_ip_get_ang_neg
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out21_z,
data_in_rsc_vz => out21_lz,
data_in_rsc_lz => out21_vz,
data_out_rsc_z => in21_z,
data_out_rsc_vz => in21_lz,
data_out_rsc_lz => in21_vz,
clk => clock,
arst_n => reset);
ip_get_ang22 : main_ip_get_ang_neg
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out22_z,
data_in_rsc_vz => out22_lz,
data_in_rsc_lz => out22_vz,
data_out_rsc_z => in22_z,
data_out_rsc_vz => in22_lz,
data_out_rsc_lz => in22_vz,
clk => clock,
arst_n => reset);
ip_get_ang23 : main_ip_get_ang_neg
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out23_z,
data_in_rsc_vz => out23_lz,
data_in_rsc_lz => out23_vz,
data_out_rsc_z => in23_z,
data_out_rsc_vz => in23_lz,
data_out_rsc_lz => in23_vz,
clk => clock,
arst_n => reset);
ip_get_ang24 : main_ip_get_ang_neg
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out24_z,
data_in_rsc_vz => out24_lz,
data_in_rsc_lz => out24_vz,
data_out_rsc_z => in24_z,
data_out_rsc_vz => in24_lz,
data_out_rsc_lz => in24_vz,
clk => clock,
arst_n => reset);
ip_get_ang25 : main_ip_get_ang_neg
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out25_z,
data_in_rsc_vz => out25_lz,
data_in_rsc_lz => out25_vz,
data_out_rsc_z => in25_z,
data_out_rsc_vz => in25_lz,
data_out_rsc_lz => in25_vz,
clk => clock,
arst_n => reset);
ip_get_ang26 : main_ip_get_ang_neg
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out26_z,
data_in_rsc_vz => out26_lz,
data_in_rsc_lz => out26_vz,
data_out_rsc_z => in26_z,
data_out_rsc_vz => in26_lz,
data_out_rsc_lz => in26_vz,
clk => clock,
arst_n => reset);
ip_get_ang27 : main_ip_get_ang_zero
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
data_in_rsc_z => out27_z,
data_in_rsc_vz => out27_lz,
data_in_rsc_lz => out27_vz,
data_out_rsc_z => in27_z,
data_out_rsc_vz => in27_lz,
data_out_rsc_lz => in27_vz,
clk => clock,
arst_n => reset);

sad_parallel : main_sad_parallel
--GENERIC MAP(DESIGN_IS_RTL => "NO",
--INFF => "FALSE"
--)
port map(
in1_rsc_z => in1_z,		  
in1_rsc_vz => in1_vz,
in1_rsc_lz => in1_lz,		  
in2_rsc_z => in2_z, 
in2_rsc_vz => in2_vz, 
in2_rsc_lz => in2_lz,			  
in3_rsc_z => in3_z,			  
in3_rsc_vz => in3_vz,			  
in3_rsc_lz => in3_lz,			  
in4_rsc_z => in4_z,			  
in4_rsc_vz => in4_vz,			  
in4_rsc_lz => in4_lz,			  
in5_rsc_z => in5_z,			  
in5_rsc_vz => in5_vz,			  
in5_rsc_lz => in5_lz,			  
in6_rsc_z => in6_z,			  
in6_rsc_vz => in6_vz,			  
in6_rsc_lz => in6_lz,			  
in7_rsc_z => in7_z,			  
in7_rsc_vz => in7_vz,			  
in7_rsc_lz => in7_lz,			  
in8_rsc_z => in8_z,			  
in8_rsc_vz => in8_vz,			  
in8_rsc_lz => in8_lz,			  
in9_rsc_z => in9_z,			  
in9_rsc_vz => in9_vz,			  
in9_rsc_lz => in9_lz,			  
in10_rsc_z => in10_z,			  
in10_rsc_vz => in10_vz,			  
in10_rsc_lz => in10_lz,			  
in11_rsc_z => in11_z,			  
in11_rsc_vz => in11_vz,			  
in11_rsc_lz => in11_lz,			  
in12_rsc_z => in12_z,			  
in12_rsc_vz => in12_vz,			  
in12_rsc_lz => in12_lz,			  
in13_rsc_z => in13_z,			  
in13_rsc_vz => in13_vz,			  
in13_rsc_lz => in13_lz,			  
in14_rsc_z => in14_z,			  
in14_rsc_vz => in14_vz,			  
in14_rsc_lz => in14_lz,			  
in15_rsc_z => in15_z,			  
in15_rsc_vz => in15_vz,			  
in15_rsc_lz => in15_lz,			  
in16_rsc_z => in16_z,			  
in16_rsc_vz => in16_vz,			  
in16_rsc_lz => in16_lz,			  
in17_rsc_z => in17_z,			  
in17_rsc_vz => in17_vz,			  
in17_rsc_lz	=> in17_lz,		  
in18_rsc_z => in18_z,			  
in18_rsc_vz => in18_vz,			  
in18_rsc_lz => in18_lz,			  
in19_rsc_z => in19_z,			  
in19_rsc_vz => in19_vz,			  
in19_rsc_lz => in19_lz,			  
in20_rsc_z => in20_z,			  
in20_rsc_vz => in20_vz,			  
in20_rsc_lz => in20_lz,			  
in21_rsc_z => in21_z,			  
in21_rsc_vz => in21_vz,			  
in21_rsc_lz => in21_lz,			  
in22_rsc_z => in22_z,			  
in22_rsc_vz => in22_vz,			  
in22_rsc_lz => in22_lz,			  
in23_rsc_z => in23_z,			  
in23_rsc_vz => in23_vz,			  
in23_rsc_lz => in23_lz,			  
in24_rsc_z => in24_z,			  
in24_rsc_vz => in24_vz,			  
in24_rsc_lz => in24_lz,			  
in25_rsc_z => in25_z,			  
in25_rsc_vz => in25_vz,			  
in25_rsc_lz => in25_lz,			  
in26_rsc_z => in26_z,			  
in26_rsc_vz => in26_vz,			  
in26_rsc_lz => in26_lz,			  
in27_rsc_z => in27_z,			  
in27_rsc_vz => in27_vz,			  
in27_rsc_lz => in27_lz,			  
in28_rsc_z => in28_z,			  
in28_rsc_vz => in28_vz,			  
in28_rsc_lz => in28_lz,			  
in29_rsc_z => in29_z,			  
in29_rsc_vz => in29_vz,			  
in29_rsc_lz => in29_lz,			  
in30_rsc_z => in30_z,		  
in30_rsc_vz => in30_vz,			  
in30_rsc_lz => in30_lz,			  
in31_rsc_z => in31_z,			  
in31_rsc_vz => in31_vz,			  
in31_rsc_lz => in31_lz,			  
in32_rsc_z => in32_z,			  
in32_rsc_vz => in32_vz,			  
in32_rsc_lz => in32_lz,			  
in33_rsc_z => in33_z,			  
in33_rsc_vz => in33_vz,			  
in33_rsc_lz => in33_lz,			  
in34_rsc_z => in34_z,			  
in34_rsc_vz	=> in34_vz,		  
in34_rsc_lz	=> in34_lz,		  
in35_rsc_z => in35_z,			  
in35_rsc_vz => in35_vz,			  
in35_rsc_lz => in35_lz,
data_in_rsc_z	=> orig_block_data_in_z,
data_in_rsc_vz	=> orig_block_data_in_vz,
data_in_rsc_lz	=> orig_block_data_in_lz,
sad_result_rsc_z => sad_result,
--sads_rsc_data_in => sads_data_in,
--sads_rsc_addr => sads_addr,
--sads_rsc_we	=> sads_we,
config_rsc_z => sad_config_z,
config_rsc_vz => sad_config_lz,
config_rsc_lz => sad_config_vz,
result_ready_rsc_z => result_ready_s,
lcu_loaded_rsc_z => lcu_loaded_s,
lambda_loaded_rsc_z => lambda_loaded,
clk => clock,
arst_n => reset);

clock <= clk;
reset <= arst_n;

clear_unfilt1_fifo <= result_ready_s(0) or result_ready_s(1);
clear_unfilt2_fifo <= result_ready_s(0) or result_ready_s(1);
clear_orig_fifo <= lcu_loaded_s;
lcu_loaded <= lcu_loaded_s;

result_ready <= result_ready_s;

end hierarchy;

