-----------------------------------------------------
-- Creator  -- Panu Sjövall					       --
-- Email	-- panu.sjovall@tut.fi			       --
-- Created  -- 22.10.2014					       --
-- Modified -- 22.10.2014					       --
-- File     -- axi3_to_channel.vhd					       --
-----------------------------------------------------
-- Desc.  	-- AXI to catapult channel	       	   --
--			-- Design for Kvazaar HW Accelerators  --
-----------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.pre_calc_pkg.all;


entity axi3_to_channel is
	generic(
		slave_data_width_g : integer := 32;
		slave_address_width_g : integer := 8;
		slave_id_width_g : integer := 12;
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
		channel_lz			: out std_logic;
		channel_vz			: in std_logic;
		channel_data		: out std_logic_vector(channel_width_g-1 downto 0);
			
		clk		: in  std_logic;
		rst_n		: in  std_logic
	);
end entity axi3_to_channel;

architecture rtl of axi3_to_channel is

constant loops_c : integer := (slave_data_width_g/8)-1;
constant bits_c : integer := log2(slave_data_width_g);

signal regs : std_logic_vector(slave_data_width_g-1 downto 0);

-------------------------------SLAVE-------------------------------------
type slave_write_states is (wait_valid,read_data,delay,respond,channel_write);
signal slave_write_state : slave_write_states;


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
signal write_len_s : integer;
signal write_size_s : unsigned(7 downto 0);

signal read_address_s : unsigned(slave_address_width_g-1 downto 0);
signal read_id_s		 : std_logic_vector(slave_id_width_g-1 downto 0);
signal read_len_s : integer;
signal read_size_s : unsigned(7 downto 0);
-------------------------------------------------------------------------

-----------------------------CHANNEL-------------------------------------
signal channel_lz_r : std_logic;
signal channel_data_r : std_logic_vector(channel_width_g-1 downto 0);
signal channel_bytes_read_s : integer;
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
			regs <= (others => '0');
			write_len_s <= 0;
			write_size_s <= (others => '0');
			channel_lz_r <= '0';
			channel_data_r <= (others => '0');
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
			channel_data_r <= channel_data_r;
			channel_lz_r <= channel_lz_r;
			
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
								channel_data_r((8*(i+1))-1 downto (8*i)) <= axi_slave_wdata((8*(i+1))-1 downto (8*i));
								regs((8*(i+1))-1 downto (8*i)) <= axi_slave_wdata((8*(i+1))-1 downto (8*i));
							end if;
						end loop;
						
						if axi_slave_wlast = '1' then
							wready_r <= '0';
							if axi_slave_bready = '1' then
								bid_r <= write_id_s;
								bresp_r <= "00";
								bvalid_r <= '1';
								slave_write_state <= channel_write;
								channel_lz_r <= '1';
							else
								slave_write_state <= respond;
							end if;
						else
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
						slave_write_state <= channel_write;
						channel_data_r <= regs(channel_width_g-1 downto 0);
						channel_lz_r <= '1';
					else
						slave_write_state <= respond;
					end if;
				when channel_write =>
					if channel_vz = '1' and channel_lz_r = '1' then
						slave_write_state <= wait_valid;
						channel_lz_r <= '0';
					else
						slave_write_state <= channel_write;
					end if;
			end case;
		end if;
	end process slave_write;

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

	----------CHANNEL-------------
	channel_lz <= channel_lz_r;
	channel_data <= channel_data_r;
	------------------------------

end architecture rtl;
