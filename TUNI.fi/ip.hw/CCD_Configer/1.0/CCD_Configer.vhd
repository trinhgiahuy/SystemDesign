library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity CCD_Configer is
generic(
	clk_freq_g : integer := 75000000
	);
port(
	clk : in std_logic;
	rst_n : in std_logic;
	green1_gain : out std_logic_vector(15 downto 0);
	blue_gain : out std_logic_vector(15 downto 0);
	red_gain : out std_logic_vector(15 downto 0);
	green2_gain : out std_logic_vector(15 downto 0);
	--read_mode1 : out std_logic_vector(15 downto 0);
	
	exposure_more : in std_logic;
	exposure_less : in std_logic;
	
	sensor_exposure  : out std_logic_vector(15 downto 0);
	sensor_start_row : out std_logic_vector(15 downto 0);
	sensor_start_column : out std_logic_vector(15 downto 0);
	sensor_row_size : out std_logic_vector(15 downto 0);
	sensor_column_size : out std_logic_vector(15 downto 0);
	sensor_row_mode : out std_logic_vector(15 downto 0);
	sensor_column_mode : out std_logic_vector(15 downto 0);
	
	camera_control_oc_address : out std_logic_vector(5 downto 0);
	camera_control_oc_data_in : in std_logic_vector(15 downto 0);
	
	read_confs : in std_logic;
	set_conf : out std_logic
);
end entity CCD_Configer;

architecture rtl of CCD_Configer is

signal green1_gain_s : std_logic_vector(15 downto 0);
signal blue_gain_s : std_logic_vector(15 downto 0);
signal red_gain_s : std_logic_vector(15 downto 0);
signal green2_gain_s : std_logic_vector(15 downto 0);
--signal read_mode1_s : std_logic_vector(15 downto 0);

signal sensor_start_row_s : std_logic_vector(15 downto 0);
signal sensor_start_column_s : std_logic_vector(15 downto 0);
signal sensor_row_size_s : std_logic_vector(15 downto 0);
signal sensor_column_size_s : std_logic_vector(15 downto 0);
signal sensor_row_mode_s : std_logic_vector(15 downto 0);
signal sensor_column_mode_s : std_logic_vector(15 downto 0);

signal read_confs_s : std_logic;
signal read_confs_old_s : std_logic;
signal set_conf_s : std_logic;
signal config_iter : integer range 0 to 9;

signal camera_control_oc_address_s : std_logic_vector(5 downto 0);


type states is (idle,conf);

signal configer_state : states;

constant default_exposure 		 : integer := 1024;
constant exposure_change_value : integer := 32;
constant exposure_max 			 : integer := 2304;
constant exposure_min 			 : integer := 128;

signal set_conf_exp_s : std_logic;

signal sensor_exposure_s : integer;

signal exposure_more_reg : std_logic_vector(2 downto 0);
signal exposure_less_reg : std_logic_vector(2 downto 0);

signal more 	: std_logic;
signal more_d 	: std_logic;
signal less 	: std_logic;
signal less_d 	: std_logic;

constant clk_div_limit : integer := clk_freq_g/200;
signal clk_div_counter : integer;
signal divided_clock : std_logic;

begin

	configer	 : process(clk,rst_n)
	begin
		if rst_n = '0' then
			green1_gain_s <= x"000F";
			blue_gain_s <= x"020F";
			red_gain_s <= x"020F";
			green2_gain_s <= x"0008";
			--read_mode1_s <= x"4006";
			
			sensor_start_row_s <= x"01E0";
			sensor_start_column_s <= x"0212";
			sensor_row_size_s <= x"03BF";
			sensor_column_size_s <= x"063F";
			sensor_row_mode_s <= x"0011";
			sensor_column_mode_s <= x"0011";

			set_conf_s <= '0';
			
			config_iter <= 0;
			
			configer_state <= idle;
		elsif clk'event and clk = '1' then
			
			read_confs_old_s <= read_confs;
			
			green1_gain_s <= green1_gain_s;
			blue_gain_s <= blue_gain_s;
			red_gain_s <= red_gain_s;
			green2_gain_s <= green2_gain_s;
			--read_mode1_s <= read_mode1_s;
			
			sensor_start_row_s <= sensor_start_row_s;
			sensor_start_column_s <= sensor_start_column_s;
			sensor_row_size_s <= sensor_row_size_s;
			sensor_column_size_s <= sensor_column_size_s;
			sensor_row_mode_s <= sensor_row_mode_s;
			sensor_column_mode_s <= sensor_column_mode_s;
			
			set_conf_s <= '0';
			
			config_iter <= config_iter;
			
			
			case configer_state is
				when idle =>
					-- rising edge
					if read_confs = '1' and read_confs_old_s = '0' then
						configer_state <= conf;
						camera_control_oc_address_s <= std_logic_vector(to_unsigned(1,6));
					else
						configer_state <= idle;
					end if;
				
				when conf =>
					case config_iter is
						when 0  => green1_gain_s <= camera_control_oc_data_in;
						when 1  => blue_gain_s <= camera_control_oc_data_in;
						when 2  => red_gain_s <= camera_control_oc_data_in;
						when 3  => green2_gain_s <= camera_control_oc_data_in;
						--when 4  => read_mode1_s <= camera_control_oc_data_in;
						
						when 4  => sensor_start_row_s <= camera_control_oc_data_in;
						when 5  => sensor_start_column_s <= camera_control_oc_data_in;
						when 6  => sensor_row_size_s <= camera_control_oc_data_in;
						when 7  => sensor_column_size_s <= camera_control_oc_data_in;
						when 8  => sensor_row_mode_s <= camera_control_oc_data_in;
						when 9 => sensor_column_mode_s <= camera_control_oc_data_in;
					end case;
					
					if config_iter = 9 then
						config_iter <= 0;
						set_conf_s <= '1';
						camera_control_oc_address_s <= std_logic_vector(to_unsigned(0,6));
						configer_state <= idle;
					else
						camera_control_oc_address_s <= std_logic_vector(unsigned(camera_control_oc_address_s)+1);
						config_iter <= config_iter + 1;
						configer_state <= conf;
					end if;
			end case;
		end if;
	end process configer;
	
	green1_gain <= green1_gain_s;
	blue_gain <= blue_gain_s;
	red_gain <= red_gain_s;
	green2_gain <= green2_gain_s;
	--read_mode1 <= read_mode1_s;
	
	sensor_start_row <= sensor_start_row_s;
	sensor_start_column <= sensor_start_column_s;
	sensor_row_size <= sensor_row_size_s;
	sensor_column_size <= sensor_column_size_s;
	sensor_row_mode <= sensor_row_mode_s;
   sensor_column_mode <= sensor_column_mode_s;
	
	camera_control_oc_address <= camera_control_oc_address_s;
	
	clk_divider : process(clk,rst_n)
	begin
		if rst_n = '0' then
			clk_div_counter <= 0;
			divided_clock <= '0';
		elsif clk'event and clk = '1' then
			clk_div_counter <= clk_div_counter+1;
			divided_clock <= divided_clock;
			if clk_div_counter = clk_div_limit/2 then
				divided_clock <= '1';
			elsif clk_div_counter = clk_div_limit then
				divided_clock <= '0';
				clk_div_counter <= 0;
			end if;
		end if;
	end process clk_divider;
	
	debouncer : process(divided_clock,rst_n)
	begin
		if rst_n = '0' then
			exposure_more_reg <= (others => '1');
			exposure_less_reg <= (others => '1');
		elsif divided_clock'event and divided_clock = '1' then
			
			exposure_more_reg(0) <= exposure_more;
			exposure_more_reg(1) <= exposure_more_reg(0);
			exposure_more_reg(2) <= exposure_more_reg(1);
			
			exposure_less_reg(0) <= exposure_less;
			exposure_less_reg(1) <= exposure_less_reg(0);
			exposure_less_reg(2) <= exposure_less_reg(1);
			
		end if;
	end process debouncer;
	
	exposurer : process(clk,rst_n)
	begin
		if rst_n = '0' then
			
			more <= '1';
			more_d <= '1';
			less <= '1';
			less_d <= '1';
			set_conf_exp_s <= '0';
			sensor_exposure_s <= default_exposure;
		
		elsif clk'event and clk = '1' then
			
			more <= exposure_more_reg(0) or exposure_more_reg(1) or exposure_more_reg(2);
			less <= exposure_less_reg(0) or exposure_less_reg(1) or exposure_less_reg(2);
			
			more_d <= more;
			less_d <= less;
			
			sensor_exposure_s <= sensor_exposure_s;
			set_conf_exp_s <= '0';
			
			if more = '0' and more_d = '1' then
				if sensor_exposure_s+exposure_change_value >= exposure_max	then
					sensor_exposure_s <= exposure_max;
				else
					sensor_exposure_s <= sensor_exposure_s+exposure_change_value;
				end if;
				set_conf_exp_s <= '1';
			elsif less = '0' and less_d = '1' then
				if sensor_exposure_s-exposure_change_value <= exposure_min then
					sensor_exposure_s <= exposure_min;
				else
					sensor_exposure_s <= sensor_exposure_s-exposure_change_value;
				end if;
				set_conf_exp_s <= '1';
			end if;
		end if;
	end process exposurer;
	
	sensor_exposure <= std_logic_vector(to_unsigned(sensor_exposure_s,16));
	
	set_conf <= (set_conf_s or set_conf_exp_s);
	
end architecture rtl;