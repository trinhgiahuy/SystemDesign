-----------------------------------------------------
-- Creator  -- Panu Sjövall					       --
-- Email	-- panu.sjovall@tut.fi			       --
-- Created  -- 19.09.2014					       --
-- Modified -- 20.04.2015					       --
-- File     -- axi3_dma_read.vhd				   --
-----------------------------------------------------
-- Desc.  	-- DMA for axi 3 protocol 		       --
--			-- Design for Kvazaar HW Accelerators  --
-----------------------------------------------------

-----------------------------------------------------
-- Offset   -- Register name --  W..16 15..3 2 1 0 --
-----------------------------------------------------
--   0x00 	-- 0 = write mem --  xxxxx xxxxx A S S --
--			-- 1 = read mem  --					   --
--			-- 2 = !aligned  --					   --
--   0x01 	-- 0 = write ok  --  xxxxx xxxxx x R x --
--			-- 1 = read ok	 -- 				   --
--   0x02 	-- Address       --       address      --
--   0x03 	-- Length/Width  -- length xxxxx width --
-----------------------------------------------------
-- 	 Notes 	-- +After startbit keep data valid	   --
--			--	until ready status				   --
--		  	-- +Allowed data lengths in bytes are  --
--			--	9,16,17,33,64,65,256,1024,4096	   --
--			-- +You need to choose alignment mode  --
--			--  (data in consecutive addresses	   --
--			--   or stride)						   --
-----------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.pre_calc_pkg.all;


entity axi3_dma_read is
	generic(
		slave_data_width_g : integer := 32;
		slave_address_width_g : integer := 8;
		slave_id_width_g : integer := 12;
		master_data_width_g : integer := 64;
		master_address_width_g : integer := 32;
		master_id_width_g : integer := 8;
		read_id_g : integer := 1;
		fifo_size_g : integer := 16;
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

		channel_lz			: out std_logic;
		channel_vz			: in std_logic;
		channel_data		: out std_logic_vector(channel_width_g-1 downto 0);
		clear_fifo			: in std_logic;
		clk		: in  std_logic;
		rst_n		: in  std_logic
	);
end entity axi3_dma_read;

architecture rtl of axi3_dma_read is

constant loops_c : integer := (slave_data_width_g/8)-1;
constant bits_c : integer := log2(slave_data_width_g);

constant bytes_in_master_c : integer := master_data_width_g/8;
constant master_beat_default_c : integer := log2(bytes_in_master_c);

constant memory_stride_c : integer := 64;

constant channel_bytes_c :integer := master_data_width_g/channel_width_g;

type internal_reg is array (0 to 3) of std_logic_vector(slave_data_width_g-1 downto 0);
signal regs : internal_reg;

type fifo_array is array (0 to fifo_size_g-1) of std_logic_vector(master_data_width_g-1 downto 0);
signal fifo : fifo_array;

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

signal read_ready_r : std_logic;
-------------------------------------------------------------------------

-------------------------------MASTER------------------------------------
type master_read_states is (idle,write_address,read_data);
signal master_read_state : master_read_states;

signal awid_r		: std_logic_vector(master_id_width_g-1 downto 0);
signal awaddr_r		: std_logic_vector(master_address_width_g-1 downto 0);
signal awlen_r		: integer range 0 to 16;
signal writes_s		: integer range 0 to 32;
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
-- Flag for remaining data
signal write_remaining_flag : std_logic;
-------------------------------------------------------------------------

-----------------------------FIFO----------------------------------------
signal fifo_read_index_s : integer range 0 to fifo_size_g;
signal fifo_data_in_s : std_logic_vector(master_data_width_g-1 downto 0);
signal fifo_write_s : std_logic;
signal fifo_write_index_s : integer range 0 to fifo_size_g;
signal fifo_full_s : std_logic;
signal fifo_empty_s : std_logic;
signal fifo_one_left_s : std_logic;
signal channel_lz_r : std_logic;
signal channel_data_r : std_logic_vector(channel_width_g-1 downto 0);
signal channel_bytes_read_s : integer range 0 to channel_bytes_c;
signal word_flag_s : std_logic;
-------------------------------------------------------------------------
 
begin

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
			regs(3) <= std_logic_vector(to_unsigned(master_beat_default_c,slave_data_width_g));
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
			
			if read_ready_r = '1' then
				regs(1)(1) <= '1';
			end if;
			
			if master_read_state /= idle then
				regs(0)(1) <= '0';
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

	master_read	 : process(clk,rst_n)
	begin
		if rst_n = '0' then
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
			master_read_state <= idle;
			writes_s <= 0;
			fifo_write_s <= '0';
			word_flag_s <= '0';
			write_remaining_flag <= '0';
			
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
			
			read_ready_r <= '0';
			
		elsif clk'event and clk = '1' then
		
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
		
			arvalid_r <= '0';
			arid_r <= arid_r;
			arlen_r <= arlen_r;
			araddr_r <= araddr_r;
			arsize_r <= arsize_r;
			arburst_r <= arburst_r;
			arlock_r <= (others =>'0');
			arcache_r <= (others =>'0');
			arprot_r <= (others =>'0');
			rready_r <= '0';
			writes_s <= writes_s;
			fifo_write_s <= '0';
			word_flag_s <= word_flag_s;
			write_remaining_flag <= write_remaining_flag;
			
			read_ready_r <= '0';
			
			case master_read_state is
				when idle =>
					-- start writing
					
					if write_remaining_flag = '1' and fifo_full_s /= '1'then
						fifo_write_s <= '1';
						write_remaining_flag <= '0';
					end if;
					
					if regs(0)(1) = '1' and write_remaining_flag = '0' then
						--get settings
						arvalid_r <= '1';
						arid_r <= std_logic_vector(to_unsigned(read_id_g,master_id_width_g));
						araddr_r <= regs(2)(master_address_width_g-1 downto 0);
						arsize_r <= regs(3)(2 downto 0);
						arburst_r <= "01";
						master_read_state <= write_address;
						--allowed data lengths
						if to_integer(unsigned(regs(3)(31 downto 16))) = 9 then
							writes_s <= 0;
							arlen_r <= 1;
						elsif to_integer(unsigned(regs(3)(31 downto 16))) = 16 then
							if regs(0)(2) = '1' then
								writes_s <= 3;
								arlen_r <= 0;
							else
								writes_s <= 0;
								arlen_r <= 1;
							end if;
						elsif to_integer(unsigned(regs(3)(31 downto 16))) = 17 then
							writes_s <= 0;
							arlen_r <= 2;
						elsif to_integer(unsigned(regs(3)(31 downto 16))) = 33 then
							writes_s <= 0;
							arlen_r <= 4;
						elsif to_integer(unsigned(regs(3)(31 downto 16))) = 64 then
							if regs(0)(2) = '1' then
								writes_s <= 7;
								arlen_r <= 0;
							else
								writes_s <= 0;
								arlen_r <= 7;
							end if;
						elsif to_integer(unsigned(regs(3)(31 downto 16))) = 65 then
							writes_s <= 0;
							arlen_r <= 8;
						elsif to_integer(unsigned(regs(3)(31 downto 16))) = 256 then
							if regs(0)(2) = '1' then
								writes_s <= 15;
								arlen_r <= 1;
							else
								writes_s <= 1;
								arlen_r <= 15;
							end if;
						elsif to_integer(unsigned(regs(3)(31 downto 16))) = 1024 then
							if regs(0)(2) = '1' then
								writes_s <= 31;
								arlen_r <= 3;
							else
								writes_s <= 7;
								arlen_r <= 15;
							end if;
						elsif to_integer(unsigned(regs(3)(31 downto 16))) = 4096 then
							writes_s <= 31;
							arlen_r <= 15;
						else
							master_read_state <= idle;
						end if;
						
					else
						master_read_state <= idle;
					end if;
				when write_address =>
					arvalid_r <= '1';
					if axi_master_arready = '1'then
						arvalid_r <= '0';
						master_read_state <= read_data;
						if fifo_one_left_s = '1' or fifo_full_s = '1' then
							rready_r <= '0';
						else
							rready_r <= '1';
							if write_remaining_flag = '1' then
								fifo_write_s <= '1';
								write_remaining_flag <= '0';
							end if;
						end if;
					else
						master_read_state <= write_address;
					end if;
				when read_data =>
					--if fifo full don't do anything and keep rready low
					if fifo_full_s = '1' then
						rready_r <= '0';
						master_read_state <= read_data;
					-- write data left after full
					elsif write_remaining_flag = '1' then
						fifo_write_s <= '1';
						if fifo_one_left_s = '1' and not((channel_vz = '1' and channel_lz_r = '1') and (channel_bytes_read_s+1 = channel_bytes_c)) then
							rready_r <= '0';
						else
							rready_r <= '1';
						end if;
						master_read_state <= read_data;
						write_remaining_flag <= '0';
					--handshake OK
					elsif rready_r = '1' and axi_master_rvalid = '1'  and axi_master_rid = std_logic_vector(to_unsigned(read_id_g,master_id_width_g)) then
						
						-- if data is not aligned and reading 4x4 block 64bit data read is not possible only 32 so do this
						if regs(0)(2) = '1' and to_integer(unsigned(regs(3)(31 downto 16))) = 16 then
							if word_flag_s = '0' then
								--check if lower or higher 32bit of 64bit bus is valid by checking if address is divisible with 8
								if regs(2)(2 downto 0) = "000" then
									fifo_data_in_s(31 downto 0) <= axi_master_rdata(31 downto 0);
								else
									fifo_data_in_s(31 downto 0) <= axi_master_rdata(63 downto 32);
								end if;
								word_flag_s <= '1';
							else
								if regs(2)(2 downto 0) = "000" then
									fifo_data_in_s(63 downto 32) <= axi_master_rdata(31 downto 0);
								else
									fifo_data_in_s(63 downto 32) <= axi_master_rdata(63 downto 32);
								end if;
								word_flag_s <= '0';
								fifo_write_s <= '1';
							end if;
						else
							fifo_data_in_s <= axi_master_rdata;
							fifo_write_s <= '1';
						end if;
						
						--if last burst data
						if arlen_r = 0 then
							--rready to low
							if fifo_one_left_s = '1' and not((channel_vz = '1' and channel_lz_r = '1') and (channel_bytes_read_s+1 = channel_bytes_c)) then
								fifo_write_s <= '0';
								write_remaining_flag <= '1';
							end if;
							rready_r <= '0';
							--start next burst if necessary
							if writes_s /= 0 then
								--write address
								arvalid_r <= '1';
								master_read_state <= write_address;
								--check burst settings
								if regs(0)(2) = '1' then
									araddr_r <= std_logic_vector(unsigned(araddr_r) + memory_stride_c);
									if to_integer(unsigned(regs(3)(31 downto 16))) = 16 then
										arlen_r <= 0;
									elsif to_integer(unsigned(regs(3)(31 downto 16))) = 64 then
										arlen_r <= 0;
									elsif to_integer(unsigned(regs(3)(31 downto 16))) = 256 then
										arlen_r <= 1;
									elsif to_integer(unsigned(regs(3)(31 downto 16))) = 1024 then
										arlen_r <= 3;
									else
										master_read_state <= idle;
										read_ready_r <= '1';
										arvalid_r <= '0';
									end if;
								else
									if to_integer(unsigned(regs(3)(31 downto 16))) = 256 
										or to_integer(unsigned(regs(3)(31 downto 16))) = 1024
										or to_integer(unsigned(regs(3)(31 downto 16))) = 4096 then
										araddr_r <= std_logic_vector(unsigned(araddr_r) + 8*(16));
										arlen_r <= 15;
									else
										master_read_state <= idle;
										read_ready_r <= '1';
										arvalid_r <= '0';
									end if;
								end if;
								writes_s <= writes_s-1;
							--if all writes done go waiting
							else
								master_read_state <= idle;
								read_ready_r <= '1';
							end if;
						-- write recived data to fifo
						else
							master_read_state <= read_data;
							-- fifo becomes full after this cycle => write after fifo not full
							if fifo_one_left_s = '1' and not((channel_vz = '1' and channel_lz_r = '1') and (channel_bytes_read_s+1 = channel_bytes_c)) then
								rready_r <= '0';
								fifo_write_s <= '0';
								write_remaining_flag <= '1';
							else
								rready_r <= '1';
							end if;
							arlen_r <= arlen_r-1;
						end if;
					elsif fifo_write_s = '1' then
						rready_r <= '0';
						master_read_state <= read_data;
					else
						rready_r <= '1';
						master_read_state <= read_data;
					end if;
			end case;
		end if;
	end process master_read;
---------------------FIFO------------------------------------------------
	fifo_out	 : process(clk,rst_n)
	begin
		if rst_n = '0' then
			fifo_read_index_s <= 0;
			fifo_write_index_s <= 0;
			fifo_full_s <= '0';
			fifo_empty_s <= '1';
			fifo <= (others => (others => '0'));
			channel_lz_r <= '0';
			channel_data_r <= (others => '0');
			channel_bytes_read_s <= 0;
			fifo_one_left_s <= '0';
		elsif clk'event and clk = '1' then
			fifo_full_s <= fifo_full_s;
			fifo_one_left_s <= fifo_one_left_s;
			fifo_write_index_s <= fifo_write_index_s;
			fifo_read_index_s <= fifo_read_index_s;
			channel_lz_r <= '0';
			channel_data_r <= channel_data_r;
			
			-- clear remaining unused data
			if clear_fifo = '1' then
				fifo_write_index_s <= 0;
				fifo_read_index_s <= 0;
				fifo_one_left_s <= '0';
				fifo_empty_s <= '1';
				fifo_full_s <= '0';
				channel_lz_r <= '0';
				channel_data_r <= (others => '0');
				channel_bytes_read_s <= 0;
			else
				--fifo write
				if fifo_write_s = '1' and fifo_full_s /= '1' then
					fifo_empty_s <= '0';
					fifo(fifo_write_index_s) <= fifo_data_in_s;
					--increase write index
					if fifo_write_index_s+1 = fifo_size_g then
						fifo_write_index_s <= 0;
					else
						fifo_write_index_s <= fifo_write_index_s + 1;
					end if;
					
					--if one left => full
					if fifo_one_left_s = '1' and not((channel_vz = '1' and channel_lz_r = '1' and channel_bytes_read_s+1 = channel_bytes_c)) then
						fifo_one_left_s <= '0';
						fifo_full_s <= '1';
					--else check if one left
					else
						if not((channel_vz = '1' and channel_lz_r = '1' and channel_bytes_read_s+1 = channel_bytes_c)) then
							if fifo_write_index_s+2 = fifo_read_index_s then
								fifo_one_left_s <= '1';
							elsif fifo_write_index_s+2 = fifo_size_g and fifo_read_index_s = 0 then
								fifo_one_left_s <= '1';
							elsif fifo_write_index_s+2 = fifo_size_g+1 and fifo_read_index_s = 1 then
								fifo_one_left_s <= '1';
							end if;
						end if;
					end if;
				end if;
				
				--fifo read
				if  fifo_empty_s /= '1' then
					channel_lz_r <= '1';
					channel_data_r <= fifo(fifo_read_index_s)(((channel_bytes_read_s+1)*channel_width_g)-1 downto channel_width_g*channel_bytes_read_s);
					--handshake OK
					if channel_vz = '1' and channel_lz_r = '1' then
						--check if last channel_bytes_read
						if channel_bytes_read_s+1 = channel_bytes_c then
							--if full => one left
							if fifo_full_s = '1' and fifo_write_s /= '1' then
								fifo_one_left_s <= '1';
								fifo_full_s <= '0';
							end if;
							--if one left => clear one left
							if fifo_one_left_s = '1' and fifo_write_s /= '1' then
								fifo_one_left_s <= '0';
							end if;
							channel_bytes_read_s <= 0;
							-- increase read index
							if fifo_read_index_s+1 = fifo_size_g then
								fifo_read_index_s <= 0;
							else
								fifo_read_index_s <= fifo_read_index_s + 1;
							end if;
							
							-- check if empty
							if fifo_read_index_s+1 = fifo_write_index_s and fifo_write_s /= '1' then
								fifo_empty_s <= '1';
								channel_lz_r <= '0';
							elsif fifo_read_index_s+1 = fifo_size_g and fifo_write_index_s = 0 and fifo_write_s /= '1' then
								fifo_empty_s <= '1';
								channel_lz_r <= '0';
							end if;
							
							if fifo_read_index_s+1 = fifo_write_index_s and fifo_write_s = '1' then
								channel_data_r <= fifo_data_in_s((channel_width_g)-1 downto 0);
							elsif fifo_read_index_s+1 = fifo_size_g and fifo_write_index_s = 0 and fifo_write_s = '1' then
								channel_data_r <= fifo_data_in_s((channel_width_g)-1 downto 0);
							else
								channel_data_r <= fifo(fifo_read_index_s+1)(channel_width_g-1 downto 0);
							end if;

						-- increase channel_bytes_read
						else
							channel_bytes_read_s <= channel_bytes_read_s+1;
							channel_data_r <= fifo(fifo_read_index_s)(((channel_bytes_read_s+2)*channel_width_g)-1 downto channel_width_g*(channel_bytes_read_s+1));
						end if;
					end if;
				end if;
			end if;
		end if;
	end process fifo_out;
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
	channel_lz <= channel_lz_r;
	channel_data <= channel_data_r;
	------------------------------

end architecture rtl;
