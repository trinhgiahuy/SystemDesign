library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity LTP_Controller is
	port (
	fifo_in_clk : in std_logic; 								-- FIFO in clock
	clk : in std_logic; 											-- LCD display clock
	rst_n : in std_logic; 										-- system reset
	clear_lcd : in std_logic;
	--clock_enable : out std_logic;							-- LCD clock_enable
	red_in : in std_logic_vector(7 downto 0); 			-- R   color data
	green_in : in std_logic_vector(7 downto 0); 			--  G  color data
	blue_in : in std_logic_vector(7 downto 0); 			--   B color data
	fifo_write : in std_logic;									-- FIFO write enable
	--fifo_used : in std_logic_vector(13 downto 0);		-- FIFO data available
	horizontal_sync : out std_logic;							-- LCD Horizontal sync 
	vertical_sync : out std_logic;							-- LCD Vertical sync 	
	LCD_red : out std_logic_vector(7 downto 0);			-- LCD Red color data 
	LCD_green : out std_logic_vector(7 downto 0);   	-- LCD Green color data  
	LCD_blue : out std_logic_vector(7 downto 0);     	-- LCD Blue color data
	
	-- LCD setup signals
	LCD_mode : out std_logic;
	LCD_rstb : out std_logic;
	LCD_shlr : out std_logic;
	LCD_updn : out std_logic;
	LCD_dim : out std_logic;
	LCD_power_ctl : out std_logic;
	LCD_clock : out std_logic
	);
end entity LTP_Controller;

architecture rtl of LTP_Controller is

--LCD horizontal and vertical timings
constant h_line_c  : integer := 1056;
constant h_valid_c : integer := 800;
constant h_pulse_c : integer := 30;
constant h_back_c : integer := 16;
constant h_front_c  : integer := 210;

constant v_line_c  : integer := 525;
constant v_valid_c : integer := 480;
constant v_pulse_c : integer := 13;
constant v_back_c : integer := 10;
constant v_front_c  : integer := 22;

--state machine states
type states is (pulse,front_invalid,no_display,display,back_invalid);
signal state : states;

signal h : integer range 0 to 1056;
signal v : integer range 0 to 525;

--signals
signal fifo_read_s : std_logic;

signal clock_enable_s : std_logic;
signal clock_enable_delay_s : std_logic;

signal horizontal_sync_s : std_logic;
signal vertical_sync_s : std_logic;
signal LCD_red_s : std_logic_vector(7 downto 0);
signal LCD_green_s : std_logic_vector(7 downto 0);
signal LCD_blue_s : std_logic_vector(7 downto 0);

--registers
signal LCD_red_next_r : std_logic_vector(7 downto 0);
signal LCD_green_next_r : std_logic_vector(7 downto 0);
signal LCD_blue_next_r : std_logic_vector(7 downto 0);

signal next_set_r : std_logic;

signal fifo_data_in : std_logic_vector(23 downto 0); 	-- RGB color data
signal fifo_data_out : std_logic_vector(23 downto 0); 	-- RGB color data
signal fifo_read : std_logic;						-- FIFO read enable
signal fifo_used : std_logic_vector(13 downto 0);	-- FIFO data available

signal reset : std_logic;

COMPONENT dcfifo
	GENERIC (
		intended_device_family		: STRING;
		lpm_numwords		: NATURAL;
		lpm_showahead		: STRING;
		lpm_type		: STRING;
		lpm_width		: NATURAL;
		lpm_widthu		: NATURAL;
		overflow_checking		: STRING;
		rdsync_delaypipe		: NATURAL;
		underflow_checking		: STRING;
		use_eab		: STRING;
		wrsync_delaypipe		: NATURAL;
		read_aclr_synch : STRING;
		write_aclr_synch : STRING
	);
	PORT (
			data	: IN STD_LOGIC_VECTOR (23 DOWNTO 0);
			rdclk	: IN STD_LOGIC ;
			rdreq	: IN STD_LOGIC ;
			rdusedw	: OUT STD_LOGIC_VECTOR (13 DOWNTO 0);
			q	: OUT STD_LOGIC_VECTOR (23 DOWNTO 0);
			wrclk	: IN STD_LOGIC ;
			wrreq	: IN STD_LOGIC; 
			aclr  : IN STD_LOGIC
	);
	END COMPONENT;

begin

	reset <= rst_n and not(clear_lcd);

	fifo_data_in(7 downto 0) <= red_in;
	fifo_data_in(15 downto 8) <= green_in;
	fifo_data_in(23 downto 16) <= blue_in;

	dcfifo_component : dcfifo
	GENERIC MAP (
		intended_device_family => "Cyclone V",
		lpm_numwords => 12288,
		lpm_showahead => "ON",
		lpm_type => "dcfifo",
		lpm_width => 24,
		lpm_widthu => 14,
		overflow_checking => "ON",
		rdsync_delaypipe => 5,
		underflow_checking => "ON",
		use_eab => "ON",
		wrsync_delaypipe => 5,
		read_aclr_synch => "ON",
		write_aclr_synch => "ON"
	)
	PORT MAP (
		data => fifo_data_in,
		rdclk => clk,
		rdreq => fifo_read,
		wrclk => fifo_in_clk,
		wrreq => fifo_write,
		rdusedw => fifo_used,
		q => fifo_data_out,
		aclr => not(reset)
	);

	ltp_control	 : process(clk,reset)
	begin
		if reset = '0' then
			
			state <= no_display;
			
			h <= 0;
			v <= 0;
			
			fifo_read_s <= '0';
			
			clock_enable_s <= '0';
			clock_enable_delay_s <= '0';
			
			horizontal_sync_s <= '0';
			vertical_sync_s <= '0';
			
			LCD_red_s <= (others=>'0');
			LCD_green_s <= (others=>'0');
			LCD_blue_s <= (others=>'0');
			
			LCD_red_next_r <= (others=>'0');
			LCD_green_next_r <= (others=>'0');
			LCD_blue_next_r <= (others=>'0');
			
			next_set_r <= '0';
			
		elsif clk'event and clk = '1' then
		
			h <= h;
			v <= v;
		
			fifo_read_s <= '0';
			clock_enable_s <= '0';
			
			vertical_sync_s <= vertical_sync_s;
			horizontal_sync_s <= horizontal_sync_s;
		
			LCD_red_s <= LCD_red_s;
			LCD_green_s <= LCD_green_s;
			LCD_blue_s <= LCD_blue_s;
			
			LCD_red_next_r <= LCD_red_next_r;
			LCD_green_next_r <= LCD_green_next_r;
			LCD_blue_next_r <= LCD_blue_next_r;
			
			next_set_r <= next_set_r;
			
			case state is
				
				--activate horizontal and vertical sync at right time
				when pulse =>
					clock_enable_s <= '1';
					state <= pulse;
					h <= h+1;
					--horizontal sync
					if h = h_pulse_c-1 then
						horizontal_sync_s <= '1';
						state <= back_invalid;
						LCD_red_s <= (others=>'0');
						LCD_green_s <= (others=>'0');
						LCD_blue_s <= (others=>'0');
					end if;
					
					--vertical sync
					if v = v_pulse_c then
						vertical_sync_s <= '1';
					end if;
				
				--fill back with zeros
				when back_invalid =>
					--enable LCD clock
					clock_enable_s	<= '1';
					--horizontal back filled
					if h = h_pulse_c+h_back_c-1 then
						--if more than vertical back and less than vertical front
						if v > (v_pulse_c+v_back_c-1) and v < (v_line_c - v_front_c) then
							state <= display;
							--if enough data in fifo
							if unsigned(fifo_used) > 4 then
								h <= h+1;
								fifo_read_s <= '1';
								--after the first time, set the pixels from memory
								if next_set_r = '1' then
									LCD_red_s <= LCD_red_next_r;
									LCD_green_s <= LCD_green_next_r;
									LCD_blue_s <= LCD_blue_next_r;
								--for the first pass, get data straight from the fifo
								else
									LCD_red_s <= fifo_data_out(7 downto 0);
									LCD_green_s <= fifo_data_out(15 downto 8);
									LCD_blue_s <= fifo_data_out(23 downto 16);
								end if;
							--else disable LCD clock
							else
								clock_enable_s	<= '0';
							end if;
						-- if vertical back or front go to no_display
						else
							state <= no_display;
						end if;
					else
						state <= back_invalid;
						h <= h+1;
					end if;
					
				when no_display =>
					clock_enable_s	<= '1';
					h <= h+1;
					--if horizontal valid filled go to front_invalid
					if h = h_pulse_c+h_back_c+h_valid_c-1 then
						state <= front_invalid;
					else
						state <= no_display;
					end if;
					
				when display =>
					--data from fifo
					LCD_red_s <= fifo_data_out(7 downto 0);
					LCD_green_s <= fifo_data_out(15 downto 8);
					LCD_blue_s <= fifo_data_out(23 downto 16);
				
					--if horizontal valid filled go to front_invalid
					if h = h_pulse_c+h_back_c+h_valid_c-1 then
						h <= h+1;
						state <= front_invalid;
						clock_enable_s <= '1';
						
						--save data from fifo to memory
						LCD_red_next_r <= fifo_data_out(7 downto 0);
						LCD_green_next_r <= fifo_data_out(15 downto 8);
						LCD_blue_next_r <= fifo_data_out(23 downto 16);
						
						next_set_r <= '1';

						LCD_red_s <= (others=>'0');
						LCD_green_s <= (others=>'0');
						LCD_blue_s <= (others=>'0');
					else
						state <= display;
						if unsigned(fifo_used) > 4 then
							fifo_read_s <= '1';
						end if;
					end if;
				
				when front_invalid =>
					clock_enable_s	<= '1';
					h <= h+1;
					--if horizontal front filled set the pulse for horizontal or/and vertical
					if h = h_line_c-1 then
						if v = v_line_c-1 then
							v <= 0;
							vertical_sync_s <= '0';
						else
							v <= v+1;
						end if;
						horizontal_sync_s <= '0';
						h <= 0;
						state <= pulse;
					else
						state <= front_invalid;
					end if;
			end case;
			
			--delay fifo read to clock enable
			clock_enable_delay_s <= fifo_read_s;
			--increase horizontal counter when fifo read
			if fifo_read_s = '1' then
				h <= h+1;
			end if;
			
		end if;
	end process ltp_control;
	
	--assign signals to ports
	horizontal_sync <= horizontal_sync_s;
	vertical_sync <= vertical_sync_s;
	LCD_red <= LCD_red_s;
	LCD_green <= LCD_green_s;
	LCD_blue <= LCD_blue_s;
	--clock_enable <= clock_enable_delay_s or clock_enable_s;
	fifo_read <= fifo_read_s;
	
	LCD_mode <= '0'; --HSD/VSD mode
	LCD_rstb <= '1'; --NO RESET
	LCD_shlr <= '0'; --LEFT->RIGHT
	LCD_updn <= '0'; --UP->DOWN
	LCD_dim <= '1';
	LCD_power_ctl <= '1';
	LCD_clock <= clk and (clock_enable_delay_s or clock_enable_s);

end architecture rtl;