-----------------------------------------------------
-- Creator  -- Panu Sjövall					       --
-- Email	-- panu.sjovall@tut.fi			       --
-- Created  -- 19.09.2014					       --
-- Modified -- 20.04.2015					       --
-- File     -- axi3_dma_write_chromas.vhd		   --
-----------------------------------------------------
-- Desc.  	-- DMA for axi 3 protocol 		       --
--			-- Design for Kvazaar HW Accelerators  --
-----------------------------------------------------

-----------------------------------------------------
-- Offset   -- Register name --  W..16 15..3 2 1 0 --
-----------------------------------------------------
--   0x00 	-- 0 = write mem --  xxxxx xxxxL A S S --
--			-- 1 = read mem  --					   --
--			-- 2 = !aligned  --					   --
--          -- 3 = loop read --                    --
--   0x01 	-- 0 = write ok  --  xxxxx xxxxx x R R --
--			-- 1 = read ok	 -- 				   --
--   0x02 	-- Address Y     --       address      --
--   0x03 	-- Address U     --       address      --
--   0x04 	-- Address V     --       address      --
--   0x05 	-- Width         --  xxxxx xxxxx width --
--   0x06   -- Luma Length   --       length       --
--   0x07   -- Chroma Length --       length       --
-----------------------------------------------------
-- 	 Notes 	-- +After startbit keep data valid	   --
--			--	until ready status				   --
-----------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.pre_calc_pkg.all;

LIBRARY altera_mf;
USE altera_mf.all;


entity axi3_dma_write_yuv is
	generic(
		slave_data_width_g : integer := 32;
		slave_address_width_g : integer := 8;
		slave_id_width_g : integer := 12;
		master_data_width_g : integer := 64;
		master_address_width_g : integer := 32;
		master_id_width_g : integer := 8;
		write_id_g : integer := 0;
		y_fifo_size_g : integer := 512;
		u_fifo_size_g : integer := 256;
		v_fifo_size_g : integer := 256;
		channel_width_g : integer := 8
	);
	port (
---------------------------------------AXI_SLAVE-------------------------------------
		-- Write Address Channel Signals
		axi_slave_awid		: in  std_logic_vector(slave_id_width_g-1 downto 0);
		axi_slave_awaddr	: in  std_logic_vector(slave_address_width_g-1 downto 0);
		axi_slave_awlen		: in  std_logic_vector(3 downto 0);
		axi_slave_awsize	: in  std_logic_vector(2 downto 0);
		axi_slave_awburst	: in  std_logic_vector(1 downto 0);
		axi_slave_awlock	: in std_logic_vector(1 downto 0);
		axi_slave_awcache	: in std_logic_vector(3 downto 0);
		axi_slave_awprot	: in std_logic_vector(2 downto 0);
		axi_slave_awvalid	: in  std_logic;
		axi_slave_awready 	: out std_logic;
		-- Write Data Channel Signals
		axi_slave_wid		: in std_logic_vector(slave_id_width_g-1 downto 0);
		axi_slave_wdata		: in std_logic_vector(slave_data_width_g-1 downto 0);
		axi_slave_wstrb		: in std_logic_vector((slave_data_width_g / 8)-1 downto 0);
		axi_slave_wlast		: in std_logic;
		axi_slave_wvalid	: in  std_logic;
		axi_slave_wready	: out std_logic;
		-- Writer Response Channel Signals
		axi_slave_bid		: out std_logic_vector(slave_id_width_g-1 downto 0);
		axi_slave_bresp		: out std_logic_vector(1 downto 0);
		axi_slave_bvalid	: out std_logic;
		axi_slave_bready	: in  std_logic;
		-- Read Address Channel Signals
		axi_slave_arid		: in  std_logic_vector(slave_id_width_g-1 downto 0);
		axi_slave_araddr	: in  std_logic_vector(slave_address_width_g-1 downto 0);
		axi_slave_arlen		: in  std_logic_vector(3 downto 0);
		axi_slave_arsize	: in  std_logic_vector(2 downto 0);
		axi_slave_arburst	: in  std_logic_vector(1 downto 0);
		axi_slave_arlock	: in  std_logic_vector(1 downto 0);
		axi_slave_arcache	: in  std_logic_vector(3 downto 0);
		axi_slave_arprot   	: in  std_logic_vector(2 downto 0);
		axi_slave_arvalid	: in  std_logic;
		axi_slave_arready	: out std_logic;
		-- Read Data Channel Signals
		axi_slave_rid		: out std_logic_vector(slave_id_width_g-1 downto 0);
		axi_slave_rdata		: out std_logic_vector(slave_data_width_g-1 downto 0);
		axi_slave_rresp		: out std_logic_vector(1 downto 0);
		axi_slave_rlast		: out std_logic;
		axi_slave_rvalid	: out std_logic;
		axi_slave_rready	: in  std_logic;
-------------------------------------------------------------------------------------
---------------------------------------AXI_MASTER------------------------------------
		-- Write Address Channel Signals
		axi_master_awid		: out  std_logic_vector(master_id_width_g-1 downto 0);
		axi_master_awaddr	: out  std_logic_vector(master_address_width_g-1 downto 0);
		axi_master_awlen	: out  std_logic_vector(3 downto 0);
		axi_master_awsize	: out  std_logic_vector(2 downto 0);
		axi_master_awburst	: out  std_logic_vector(1 downto 0);
		axi_master_awlock	: out std_logic_vector(1 downto 0);
		axi_master_awcache	: out std_logic_vector(3 downto 0);
		axi_master_awprot	: out std_logic_vector(2 downto 0);
		axi_master_awvalid	: out  std_logic;
		axi_master_awready 	: in std_logic;
		-- Write Data Channel Signals
		axi_master_wid		: out std_logic_vector(master_id_width_g-1 downto 0);
		axi_master_wdata	: out std_logic_vector(master_data_width_g-1 downto 0);
		axi_master_wstrb	: out std_logic_vector((master_data_width_g / 8)-1 downto 0);
		axi_master_wlast	: out std_logic;
		axi_master_wvalid	: out  std_logic;
		axi_master_wready	: in std_logic;
		-- Writer Response Channel Signals
		axi_master_bid		: in std_logic_vector(master_id_width_g-1 downto 0);
		axi_master_bresp	: in std_logic_vector(1 downto 0);
		axi_master_bvalid	: in std_logic;
		axi_master_bready	: out  std_logic;
		-- Read Address Channel Signals
		axi_master_arid		: out  std_logic_vector(master_id_width_g-1 downto 0);
		axi_master_araddr	: out  std_logic_vector(master_address_width_g-1 downto 0);
		axi_master_arlen	: out  std_logic_vector(3 downto 0);
		axi_master_arsize	: out  std_logic_vector(2 downto 0);
		axi_master_arburst	: out  std_logic_vector(1 downto 0);
		axi_master_arlock	: out  std_logic_vector(1 downto 0);
		axi_master_arcache	: out  std_logic_vector(3 downto 0);
		axi_master_arprot   : out  std_logic_vector(2 downto 0);
		axi_master_arvalid	: out  std_logic;
		axi_master_arready	: in std_logic;
		-- Read Data Channel Signals
		axi_master_rid		: in std_logic_vector(master_id_width_g-1 downto 0);
		axi_master_rdata	: in std_logic_vector(master_data_width_g-1 downto 0);
		axi_master_rresp	: in std_logic_vector(1 downto 0);
		axi_master_rlast	: in std_logic;
		axi_master_rvalid	: in std_logic;
		axi_master_rready	: out  std_logic;
-------------------------------------------------------------------------------------
		y_data_in_lz		: out std_logic;
		y_data_in_vz		: in std_logic;
		y_data_in_z			: in std_logic_vector(channel_width_g-1 downto 0);

		u_data_in_lz		: out std_logic;
		u_data_in_vz		: in std_logic;
		u_data_in_z			: in std_logic_vector(channel_width_g-1 downto 0);
		
		v_data_in_lz		: out std_logic;
		v_data_in_vz		: in std_logic;
		v_data_in_z			: in std_logic_vector(channel_width_g-1 downto 0);
		
		clk		: in  std_logic;
		fifo_clk		: in  std_logic;
		clear_dma_and_fifo 	: in std_logic;
		rst_n		: in  std_logic
	);
end entity axi3_dma_write_yuv;

architecture rtl of axi3_dma_write_yuv is

constant loops_c : integer := (slave_data_width_g/8)-1;
constant bits_c : integer := log2(slave_data_width_g);

constant bytes_in_master_c : integer := master_data_width_g/8;
constant master_beat_default_c : integer := log2(bytes_in_master_c);

constant memory_stride_c : integer := 64;

type internal_reg is array (0 to 7) of std_logic_vector(slave_data_width_g-1 downto 0);
signal regs : internal_reg;

-------------------------------SLAVE-------------------------------------
type slave_write_states is (wait_valid,read_data,delay,respond);
type slave_read_states is (wait_valid,write_data);
signal slave_write_state : slave_write_states;
signal slave_read_state : slave_read_states;

signal awready_r : std_logic;
signal wready_r	 : std_logic;
signal bid_r	 : std_logic_vector(slave_id_width_g-1 downto 0);
signal bresp_r	 : std_logic_vector(1 downto 0);
signal bvalid_r	 : std_logic;
signal arready_r : std_logic;
signal rid_r	 : std_logic_vector(slave_id_width_g-1 downto 0);
signal rdata_r	 : std_logic_vector(slave_data_width_g-1 downto 0);
signal rresp_r	 : std_logic_vector(1 downto 0);
signal rlast_r	 : std_logic;
signal rvalid_r	 : std_logic;

signal write_address_s : unsigned(slave_address_width_g-1 downto 0);
signal write_id_s		 : std_logic_vector(slave_id_width_g-1 downto 0);
signal write_len_s : integer range 0 to 16;
signal write_size_s : unsigned(7 downto 0);

signal read_address_s : unsigned(slave_address_width_g-1 downto 0);
signal read_id_s		 : std_logic_vector(slave_id_width_g-1 downto 0);
signal read_len_s : integer range 0 to 16;
signal read_size_s : unsigned(7 downto 0);
-------------------------------------------------------------------------

-------------------------------MASTER------------------------------------
type master_write_states is (idle,read_fifo,write_address,write_data,wait_respond);
signal master_write_state : master_write_states;

signal awid_r		: std_logic_vector(master_id_width_g-1 downto 0);
signal awaddr_r		: std_logic_vector(master_address_width_g-1 downto 0);
signal awlen_r		: integer range 0 to 16;
signal awsize_r		: std_logic_vector(2 downto 0);
signal awburst_r	: std_logic_vector(1 downto 0);
signal awlock_r		: std_logic_vector(1 downto 0);
signal awcache_r	: std_logic_vector(3 downto 0);
signal awprot_r		: std_logic_vector(2 downto 0);
signal awvalid_r	: std_logic;
-- Write Data Channel Signals
signal wid_r		: std_logic_vector(master_id_width_g-1 downto 0);
signal wdata_r		: std_logic_vector(master_data_width_g-1 downto 0);
signal wstrb_r		: std_logic_vector((master_data_width_g/8)-1 downto 0);
signal wlast_r		: std_logic;
signal wvalid_r		: std_logic;
-- Writer Response Channel Signals
signal bready_r		: std_logic;
-- Read Address Channel Signals
signal arid_r		: std_logic_vector(master_id_width_g-1 downto 0);
signal araddr_r		: std_logic_vector(master_address_width_g-1 downto 0);
signal arlen_r		: integer range 0 to 16;
signal arsize_r		: std_logic_vector(2 downto 0);
signal arburst_r	: std_logic_vector(1 downto 0);
signal arlock_r		: std_logic_vector(1 downto 0);
signal arcache_r	: std_logic_vector(3 downto 0);
signal arprot_r   	: std_logic_vector(2 downto 0);
signal arvalid_r	: std_logic;
-- Read Data Channel Signals
signal rready_r		: std_logic;

-------------------------------------------------------------------------

-----------------------------FIFO Y----------------------------------------
signal y_fifo_data_in_s : std_logic_vector(channel_width_g-1 downto 0);
signal y_fifo_data_out_s : std_logic_vector(master_data_width_g-1 downto 0);
signal y_fifo_read_s : std_logic;
signal y_fifo_write_s : std_logic;
signal y_fifo_full_s : std_logic;
signal y_fifo_empty_s : std_logic;
signal y_fifo_one_left_s : std_logic;
signal y_channel_lz_r : std_logic;
-------------------------------------------------------------------------

-----------------------------FIFO U----------------------------------------
signal u_fifo_data_in_s : std_logic_vector(channel_width_g-1 downto 0);
signal u_fifo_data_out_s : std_logic_vector(master_data_width_g-1 downto 0);
signal u_fifo_read_s : std_logic;
signal u_fifo_write_s : std_logic;
signal u_fifo_full_s : std_logic;
signal u_fifo_empty_s : std_logic;
signal u_fifo_one_left_s : std_logic;
signal u_channel_lz_r : std_logic;
-------------------------------------------------------------------------

-----------------------------FIFO V--------------------------------------
signal v_fifo_data_in_s : std_logic_vector(channel_width_g-1 downto 0);
signal v_fifo_data_out_s : std_logic_vector(master_data_width_g-1 downto 0);
signal v_fifo_read_s : std_logic;
signal v_fifo_write_s : std_logic;
signal v_fifo_full_s : std_logic;
signal v_fifo_empty_s : std_logic;
signal v_fifo_one_left_s : std_logic;
signal v_channel_lz_r : std_logic;
-------------------------------------------------------------------------

signal restart_dma_and_fifo_r : std_logic;
type turns is (Y,U,V);
signal turn : turns;
signal y_offset_s	 : integer range 0 to 48000;
signal u_offset_s	 : integer range 0 to 12000;
signal v_offset_s	 : integer range 0 to 12000;
signal y_writes_s	 : integer range 0 to 384000;
signal u_writes_s	 : integer range 0 to 96000;
signal v_writes_s	 : integer range 0 to 96000;
 
 COMPONENT dcfifo_mixed_widths
	GENERIC (
		intended_device_family	: STRING;
		lpm_numwords			: NATURAL;
		lpm_showahead			: STRING;
		lpm_type				: STRING;
		lpm_width				: NATURAL;
		lpm_width_r				: NATURAL;
		overflow_checking		: STRING;
		rdsync_delaypipe		: NATURAL;
		underflow_checking		: STRING;
		use_eab					: STRING;
		wrsync_delaypipe		: NATURAL;
		read_aclr_synch			: STRING;
		write_aclr_synch		: STRING
	);
	PORT (
			aclr    : IN STD_LOGIC;
			data	: IN STD_LOGIC_VECTOR (channel_width_g-1 DOWNTO 0);
			rdclk	: IN STD_LOGIC ;
			rdreq	: IN STD_LOGIC ;
			wrfull	: OUT STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (master_data_width_g-1 DOWNTO 0);
			rdempty	: OUT STD_LOGIC ;
			wrclk	: IN STD_LOGIC ;
			wrreq	: IN STD_LOGIC
	);
END COMPONENT;
 
begin

	luma_y : dcfifo_mixed_widths
	GENERIC MAP (
		intended_device_family => "Cyclone V",
		lpm_numwords => y_fifo_size_g,
		lpm_showahead => "ON",
		lpm_type => "dcfifo_mixed_widths",
		lpm_width => channel_width_g,
		lpm_width_r => master_data_width_g,
		overflow_checking => "ON",
		rdsync_delaypipe => 5,
		underflow_checking => "ON",
		use_eab => "ON",
		wrsync_delaypipe => 5,
		read_aclr_synch => "ON",
		write_aclr_synch => "ON"
	)
	PORT MAP (
		aclr => not(rst_n) or restart_dma_and_fifo_r,
		data => y_fifo_data_in_s,
		rdclk => clk,
		rdreq => y_fifo_read_s,
		wrclk => fifo_clk,
		wrreq => y_fifo_write_s,
		wrfull => y_fifo_full_s,
		q => y_fifo_data_out_s,
		rdempty => y_fifo_empty_s
	);

	chroma_u : dcfifo_mixed_widths
	GENERIC MAP (
		intended_device_family => "Cyclone V",
		lpm_numwords => u_fifo_size_g,
		lpm_showahead => "ON",
		lpm_type => "dcfifo_mixed_widths",
		lpm_width => channel_width_g,
		lpm_width_r => master_data_width_g,
		overflow_checking => "ON",
		rdsync_delaypipe => 5,
		underflow_checking => "ON",
		use_eab => "ON",
		wrsync_delaypipe => 5,
		read_aclr_synch => "ON",
		write_aclr_synch => "ON"
	)
	PORT MAP (
		aclr => not(rst_n) or restart_dma_and_fifo_r,
		data => u_fifo_data_in_s,
		rdclk => clk,
		rdreq => u_fifo_read_s,
		wrclk => fifo_clk,
		wrreq => u_fifo_write_s,
		wrfull => u_fifo_full_s,
		q => u_fifo_data_out_s,
		rdempty => u_fifo_empty_s
	);
	
	chroma_v : dcfifo_mixed_widths
	GENERIC MAP (
		intended_device_family => "Cyclone V",
		lpm_numwords => v_fifo_size_g,
		lpm_showahead => "ON",
		lpm_type => "dcfifo_mixed_widths",
		lpm_width => channel_width_g,
		lpm_width_r => master_data_width_g,
		overflow_checking => "ON",
		rdsync_delaypipe => 5,
		underflow_checking => "ON",
		use_eab => "ON",
		wrsync_delaypipe => 5,
		read_aclr_synch => "ON",
		write_aclr_synch => "ON"
	)
	PORT MAP (
		aclr => not(rst_n) or restart_dma_and_fifo_r,
		data => v_fifo_data_in_s,
		rdclk => clk,
		rdreq => v_fifo_read_s,
		wrclk => fifo_clk,
		wrreq => v_fifo_write_s,
		wrfull => v_fifo_full_s,
		q => v_fifo_data_out_s,
		rdempty => v_fifo_empty_s
	);
	
---------------------SLAVE-----------------------------------------------
	slave_write	 : process(clk,rst_n)
	begin
		if rst_n = '0' then
			slave_write_state <= wait_valid;
 			awready_r <= '0';
			wready_r <= '0';
			bid_r <= (others=>'0');
			bresp_r <= (others=>'0');
			bvalid_r <= '0';
			write_address_s <= (others => '0');
			regs(0) <= (others => '0');
			regs(1) <= (others => '0');
			regs(2) <= (others => '0');
            regs(3) <= (others => '0');
            regs(4) <= (others => '0');
			regs(5) <= std_logic_vector(to_unsigned(master_beat_default_c,slave_data_width_g));
            regs(6) <= (others => '0');
            regs(7) <= (others => '0');
			write_len_s <= 0;
			write_size_s <= (others => '0');
		elsif clk'event and clk = '1' then
			awready_r <= '0';
			wready_r <= '0';
			bresp_r <= "00";
			bvalid_r <= '0';
			bid_r <= (others=>'0');
			write_id_s <= write_id_s;
			regs <= regs;
			write_address_s <= write_address_s;
			write_len_s <= write_len_s;
			write_size_s <= write_size_s;
			
			if master_write_state /= idle then
				regs(1)(0) <= '0';
				regs(0)(0) <= '0';
			else
				regs(1)(0) <= '1';
                regs(0)(4) <= '0';
			end if;
			
			case slave_write_state is
				when wait_valid =>
					if axi_slave_awvalid = '1' then
						awready_r <= '1';
						--translate address
						--(address * (bytes in data width)) >> (log2(data width))
						write_address_s <= unsigned(axi_slave_awaddr);
						write_id_s <= axi_slave_awid;
						write_len_s <= to_integer(unsigned(axi_slave_awlen));
						write_size_s <= to_unsigned(1,8) sll to_integer(unsigned(axi_slave_awsize));
						slave_write_state <= delay;
					else
						slave_write_state <= wait_valid;
					end if;
				when delay =>
					wready_r <= '1';
					slave_write_state <= read_data;
				when read_data =>
					wready_r <= '1';
					if axi_slave_wvalid = '1' then
						--save bytes according to byte enable
						for i in 0 to loops_c loop
							if axi_slave_wstrb(i) = '1' then
								regs(to_integer((write_address_s*8) srl bits_c))((8*(i+1))-1 downto (8*i)) <= axi_slave_wdata((8*(i+1))-1 downto (8*i));
							end if;
						end loop;
						
						if axi_slave_wlast = '1' then
							wready_r <= '0';
							if axi_slave_bready = '1' then
								bid_r <= write_id_s;
								bresp_r <= "00";
								bvalid_r <= '1';
								slave_write_state <= wait_valid;
							else
								slave_write_state <= respond;
							end if;
						else
							write_address_s <= write_address_s+write_size_s;
							slave_write_state <= read_data;
						end if;
					else
						slave_write_state <= read_data;
					end if;
				when respond =>
					if axi_slave_bready = '1' then
						bid_r <= write_id_s;
						bresp_r <= "00";
						bvalid_r <= '1';
						slave_write_state <= wait_valid;
					else
						slave_write_state <= respond;
					end if;
			end case;
		end if;
	end process slave_write;

	slave_read	 : process(clk,rst_n)
	begin
		if rst_n = '0' then
			slave_read_state <= wait_valid;
			arready_r <= '0';
			rid_r <= (others=>'0');
			rdata_r <= (others=>'0');
			rresp_r <= (others=>'0');	 
			rlast_r <= '0';	 
			rvalid_r <= '0';
			read_len_s <= 0;
			read_size_s <= (others => '0');
		elsif clk'event and clk = '1' then
			arready_r <= '0';
			rresp_r <= "00";
			rvalid_r <= '0';
			rid_r <= (others=>'0');
			rlast_r <= '0';
			read_id_s <= read_id_s;
			read_address_s <= read_address_s;
			read_len_s <= read_len_s;
			read_size_s <= read_size_s;
			case slave_read_state is
				when wait_valid =>
					if axi_slave_arvalid = '1' then
						arready_r <= '1';
						--translate address
						--(address * (bytes in data width)) >> (log2(data width))
						read_address_s <= unsigned(axi_slave_araddr);
						read_id_s <= axi_slave_arid;
						read_len_s <= to_integer(unsigned(axi_slave_arlen));
						read_size_s <= to_unsigned(1,8) sll to_integer(unsigned(axi_slave_arsize));
						slave_read_state <= write_data;
					else
						slave_read_state <= wait_valid;
					end if;
				when write_data =>
					rid_r <= read_id_s;
					rdata_r <= regs(to_integer((read_address_s*8) srl bits_c));
					if read_len_s = 0 then
						rlast_r <= '1';
					end if;
					rvalid_r <= '1';
					if axi_slave_rready = '1' then
						if read_len_s = 0 then
							slave_read_state <= wait_valid;
						else
							read_address_s <= read_address_s + read_size_s;
							read_len_s <= read_len_s-1;
							slave_read_state <= write_data;
						end if;
					else
						slave_read_state <= write_data;
					end if;
			end case;
		end if;
	end process slave_read;
	
---------------------MASTER----------------------------------------------
	master_write : process(clk,rst_n)
	begin
		if rst_n = '0' then
			master_write_state <= idle;
			arid_r <= (others =>'0');
			araddr_r <= (others =>'0');
			arlen_r <= 0;
			arsize_r <= (others =>'0');
			arburst_r <= (others =>'0');
			arlock_r <= (others =>'0');
			arcache_r <= (others =>'0');
			arprot_r <= (others =>'0');
			arvalid_r <= '0';
			rready_r <= '0';
			
			y_fifo_read_s <= '0';
			u_fifo_read_s <= '0';
			v_fifo_read_s <= '0';
			
			awid_r <= (others =>'0');
			awaddr_r <= (others =>'0');
			awlen_r <= 0;
			awsize_r <= (others =>'0');
			awburst_r <= (others =>'0');
			awlock_r <= (others =>'0');
			awcache_r <= (others =>'0');
			awprot_r <= (others =>'0');
			awvalid_r <= '0';
			
			bready_r <= '0';
			
			wid_r <= (others =>'0');
			wdata_r <= (others =>'0');
			wstrb_r <= (others =>'0');
			wlast_r <= '0';
			wvalid_r <= '0';
			
			restart_dma_and_fifo_r <= '0';
			
			turn <= Y;
			
			y_writes_s <= 0;
			u_writes_s <= 0;
			v_writes_s <= 0;
			
			y_offset_s <= 1;
			u_offset_s <= 0;
			v_offset_s <= 0;
			
		elsif clk'event and clk = '1' then
			
			arid_r <= (others =>'0');
			araddr_r <= (others =>'0');
			arlen_r <= 0;
			arsize_r <= (others =>'0');
			arburst_r <= (others =>'0');
			arlock_r <= (others =>'0');
			arcache_r <= (others =>'0');
			arprot_r <= (others =>'0');
			arvalid_r <= '0';
			rready_r <= '0';
			
			awid_r <= awid_r;
			awaddr_r <= awaddr_r;
			awlen_r <= awlen_r;
			awsize_r <= awsize_r;
			awburst_r <= awburst_r;
			awlock_r <= (others =>'0');
			awcache_r <= (others =>'0');
			awprot_r <= (others =>'0');
			awvalid_r <= '0';
			
			bready_r <= '0';
			
			wid_r <= wid_r;
			wdata_r <= wdata_r;
			wstrb_r <= wstrb_r;
			wlast_r <= '0';
			wvalid_r <= wvalid_r;
			awlen_r <= awlen_r;
			
			y_fifo_read_s <= '0';
			u_fifo_read_s <= '0';
			v_fifo_read_s <= '0';
			
			turn <= turn;
			
			y_writes_s <= y_writes_s;
			u_writes_s <= u_writes_s;
			v_writes_s <= v_writes_s;
			
			y_offset_s <= y_offset_s;
			u_offset_s <= u_offset_s;
			v_offset_s <= v_offset_s;
			
			if (clear_dma_and_fifo = '1' or regs(0)(4) = '1') and master_write_state /= idle then
				restart_dma_and_fifo_r <= '1';
			else
				restart_dma_and_fifo_r <= restart_dma_and_fifo_r;
			end if;
			
			case master_write_state is
				when idle =>
					--start reading
					if regs(0)(0) = '1' or regs(0)(3) = '1' then
						awvalid_r <= '1';
						awid_r <= std_logic_vector(to_unsigned(write_id_g,master_id_width_g));
						wid_r <= std_logic_vector(to_unsigned(write_id_g,master_id_width_g));
						wstrb_r <= (others =>'1');
						awaddr_r <= regs(2)(master_address_width_g-1 downto 0);
						master_write_state <= write_address;
						awsize_r <= regs(5)(2 downto 0);
						awburst_r <= "01";
						awlen_r <= 0;
						y_writes_s <= to_integer(unsigned(regs(6)));
						u_writes_s <= to_integer(unsigned(regs(7)));
						v_writes_s <= to_integer(unsigned(regs(7)));
						master_write_state <= write_address;
					else
						master_write_state <= idle;
					end if;
				when write_address =>
					awvalid_r <= '1';
					if axi_master_awready = '1' then
						awvalid_r <= '0';
						master_write_state <= read_fifo;
					else
						master_write_state <= write_address;
					end if;
				when read_fifo =>
                    
                    if restart_dma_and_fifo_r = '1' then
                        wdata_r <= (others => '0');
                        master_write_state <= write_data;
                    elsif turn = Y then
						if y_fifo_empty_s /= '1' then
							wdata_r <= y_fifo_data_out_s;
							y_fifo_read_s <= '1';
							if awlen_r = 0 then
								wlast_r <= '1';
							end if;
							wvalid_r <= '1';
							master_write_state <= write_data;
							y_writes_s <= y_writes_s - bytes_in_master_c;
						else
							master_write_state <= read_fifo;
						end if;
					elsif turn = U then
						if u_fifo_empty_s /= '1' then
							wdata_r <= u_fifo_data_out_s;
							u_fifo_read_s <= '1';
							if awlen_r = 0 then
								wlast_r <= '1';
							end if;
							wvalid_r <= '1';
							master_write_state <= write_data;
							u_writes_s <= u_writes_s - bytes_in_master_c;
						else
							master_write_state <= read_fifo;
						end if;
					elsif turn = V then
						if v_fifo_empty_s /= '1' then
							wdata_r <= v_fifo_data_out_s;
							v_fifo_read_s <= '1';
							if awlen_r = 0 then
								wlast_r <= '1';
							end if;
							wvalid_r <= '1';
							master_write_state <= write_data;
							v_writes_s <= v_writes_s - bytes_in_master_c;
						else
							master_write_state <= read_fifo;
						end if;
					else
						master_write_state <= idle;
					end if;
					
				when write_data =>
					
					wvalid_r <= '1';
					
					if axi_master_wready = '1' and wvalid_r = '1' then
						if awlen_r = 0 then
							wvalid_r <= '0';
							wlast_r <= '0';
							bready_r <= '1';
							master_write_state <= wait_respond;
						else
							wvalid_r <= '0';
							awlen_r <= awlen_r-1;
							if awlen_r-1 = 0 then
								wlast_r <= '1';
							end if;
							master_write_state <= read_fifo;
						end if;
					else
						if awlen_r = 0 then
							wlast_r <= '1';
						end if;
						master_write_state <= write_data;
					end if;
				when wait_respond =>
					bready_r <= '1';
					if axi_master_bid = std_logic_vector(to_unsigned(write_id_g,master_id_width_g)) and axi_master_bresp = "00" and axi_master_bvalid = '1' then
						bready_r <= '0';
						if ((y_writes_s = 0 and u_writes_s = 0 and v_writes_s = 0) or restart_dma_and_fifo_r = '1') then
							turn <= Y;
							y_offset_s <= 1;
							u_offset_s <= 0;
							v_offset_s <= 0;
							master_write_state <= idle;
                            restart_dma_and_fifo_r <= '0';
						else
							awvalid_r <= '1';
							awlen_r <= 0;
							if y_fifo_empty_s /= '1' and y_writes_s /= 0 then
								turn <= Y;
								awaddr_r <= std_logic_vector(unsigned(regs(2)(slave_data_width_g-1 downto 0)) + bytes_in_master_c*y_offset_s);
								y_offset_s <= y_offset_s +1;
							elsif u_fifo_empty_s /= '1' and u_writes_s /= 0 then
								turn <= U;
								awaddr_r <= std_logic_vector(unsigned(regs(3)(slave_data_width_g-1 downto 0)) + bytes_in_master_c*u_offset_s);
								u_offset_s <= u_offset_s + 1;
							elsif v_fifo_empty_s /= '1' and v_writes_s /= 0 then
								turn <= V;
								awaddr_r <= std_logic_vector(unsigned(regs(4)(slave_data_width_g-1 downto 0)) + bytes_in_master_c*v_offset_s);
								v_offset_s <= v_offset_s + 1;
							else
								turn <= Y;
								awaddr_r <= std_logic_vector(unsigned(regs(2)(slave_data_width_g-1 downto 0)) + bytes_in_master_c*y_offset_s);
								y_offset_s <= y_offset_s +1;
							end if;
							master_write_state <= write_address;
						end if;
					else
						master_write_state <= wait_respond;
					end if;
			end case;
		end if;
	end process master_write;

---------------------FIFO Y------------------------------------------------
	y_fifo_in	 : process(fifo_clk,rst_n)
	begin
		if rst_n = '0' then
			y_channel_lz_r <= '0';
			y_fifo_write_s <= '0';
		elsif fifo_clk'event and fifo_clk = '1' then
			y_fifo_write_s <= '0';
			y_channel_lz_r <= '1';
			if y_fifo_full_s /= '1' and y_data_in_vz = '1' and y_channel_lz_r = '1'then
				y_fifo_data_in_s <= y_data_in_z;
				y_fifo_write_s <= '1';
			end if;
			if y_fifo_full_s = '1' then
				y_channel_lz_r <= '0';
			end if;
		end if;
	end process y_fifo_in;
-------------------------------------------------------------------------
	
---------------------FIFO U------------------------------------------------
	u_fifo_in	 : process(fifo_clk,rst_n)
	begin
		if rst_n = '0' then
			u_channel_lz_r <= '0';
			u_fifo_write_s <= '0';
		elsif fifo_clk'event and fifo_clk = '1' then
			u_fifo_write_s <= '0';
			u_channel_lz_r <= '1';
			if u_fifo_full_s /= '1' and u_data_in_vz = '1' and u_channel_lz_r = '1'then
				u_fifo_data_in_s <= u_data_in_z;
				u_fifo_write_s <= '1';
			end if;
			if u_fifo_full_s = '1' then
				u_channel_lz_r <= '0';
			end if;
		end if;
	end process u_fifo_in;
-------------------------------------------------------------------------
---------------------FIFO V------------------------------------------------
	v_fifo_in	 : process(fifo_clk,rst_n)
	begin
		if rst_n = '0' then
			v_channel_lz_r <= '0';
			v_fifo_write_s <= '0';
		elsif fifo_clk'event and fifo_clk = '1' then
			v_fifo_write_s <= '0';
			v_channel_lz_r <= '1';
			if v_fifo_full_s /= '1' and v_data_in_vz = '1' and v_channel_lz_r = '1'then
				v_fifo_data_in_s <= v_data_in_z;
				v_fifo_write_s <= '1';
			end if;
			if v_fifo_full_s = '1' then
				v_channel_lz_r <= '0';
			end if;
		end if;
	end process v_fifo_in;
-------------------------------------------------------------------------
	
	-------------SLAVE-------------
	axi_slave_awready <= awready_r;
	axi_slave_wready <= wready_r;
	axi_slave_bid <= bid_r;
	axi_slave_bresp <= bresp_r;
	axi_slave_bvalid <= bvalid_r;
	axi_slave_arready <= arready_r;
	axi_slave_rid <= rid_r;
	axi_slave_rdata <= rdata_r;
	axi_slave_rresp <= rresp_r;
	axi_slave_rlast <= rlast_r;
	axi_slave_rvalid <= rvalid_r;
	-------------------------------
	------------MASTER-------------
	axi_master_awid <= awid_r;
	axi_master_awaddr <= awaddr_r;
	axi_master_awlen <= std_logic_vector(to_unsigned(awlen_r,4));
	axi_master_awsize <= awsize_r;
	axi_master_awburst <= awburst_r;
	axi_master_awlock <= awlock_r;
	axi_master_awcache <= awcache_r;
	axi_master_awprot <= awprot_r;
	axi_master_awvalid <= awvalid_r;
	axi_master_wid <= wid_r;
	axi_master_wdata <= wdata_r;
	axi_master_wstrb <= wstrb_r;
	axi_master_wlast <= wlast_r;
	axi_master_wvalid <= wvalid_r;
	axi_master_bready <= bready_r;
	axi_master_arid <= arid_r;
	axi_master_araddr <= araddr_r;
	axi_master_arlen <= std_logic_vector(to_unsigned(arlen_r,4));
	axi_master_arsize <= arsize_r;
	axi_master_arburst <= arburst_r;
	axi_master_arlock <= arlock_r;
	axi_master_arcache <= arcache_r;
	axi_master_arprot <= arprot_r;
	axi_master_arvalid <= arvalid_r;
	axi_master_rready <= rready_r;
	------------------------------
	----------CHANNEL-------------
	y_data_in_lz <= y_channel_lz_r;
	u_data_in_lz <= u_channel_lz_r;
	v_data_in_lz <= v_channel_lz_r;
	------------------------------

end architecture rtl;
