library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.user_pkg.all;
 
entity dma is
    port(
        dram_clk			: in std_logic;
		rst					: in std_logic;
		user_clk			: in std_logic;
		go 					: in std_logic;
		size				: in std_logic_vector(RAM0_RD_SIZE_RANGE);
		startadd			: in std_logic_vector(C_RAM0_ADDR_WIDTH-1 downto 0);
        clear			    : in std_logic;
        stall               : in std_logic;
        rd_en 				: in std_logic;
        dram_ready			: in std_logic;
        raddr       		: out std_logic_vector(C_RAM0_ADDR_WIDTH-1 downto 0);
        done 				: out STD_LOGIC;
		valid               : out std_logic;


--For DRAM interface

		dram_rd_en 			: out STD_LOGIC;
		dram_rd_flush 		: out STD_LOGIC;

		dram_rd_valid       : in std_logic;
		dram_rd_data        : in std_logic_vector(31 downto 0);
		dataout             : out std_logic_vector(15 downto 0)
        );
end dma;
 
architecture rtl of dma is 
signal delay_ack            : std_logic;
signal datain               : std_logic_vector(31 downto 0);
signal rcv                  : std_logic;
signal empty                : std_logic;
signal ack                  : std_logic;
signal startadd             : std_logic;
signal genstall             : std_logic;

component fifo_generator_0 is
  Port ( 
    rst : in STD_LOGIC;
    wr_clk : in STD_LOGIC;
    rd_clk : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    wr_en : in STD_LOGIC;
    rd_en : in STD_LOGIC;
    dout : out STD_LOGIC_VECTOR ( 15 downto 0 );
    full : out STD_LOGIC;
    empty : out STD_LOGIC;
    prog_full : out STD_LOGIC
  );
end component fifo_generator_0;


begin
	U_count_dram : entity work.counter_dram
	port map(
		clk			=> user_clk,
		rst			=> rst,
		clear       => clear,
		size		=> size,
		rd_en 		=> rd_en,
		done 		=> done
	);
	
	U_handshake : entity work.handshake
	port map (
		clk_src   => user_clk,
		clk_dest  => dram_clk,
		rst       => rst,
		delay_ack => delay_ack,
		go        => go,
		rcv       => rcv,
		ack       => ack
	);
	
	startadd <= rcv and dram_ready;
	
	U_add_gen : entity work.add_gen
	port map (
		clk	   		=> dram_clk,
		rst	   		=> rst,
		start  		=> startadd,
		size   		=> size,
		startadd	=> startadd,
        raddr  		=> raddr,
		ack     => delay_ack,
		clear  		=> clear,
		valid       => dram_rd_en,
        stall       => genstall,
		flush  => dram_rd_flush
	);      	
	
	
	U_FIFO: fifo_generator_0
	port map (
		rst 		=> rst,
		wr_clk 		=> dram_clk,
		rd_clk 		=> user_clk,
		din(15 DOWNTO 0) 		=> dram_rd_data(31 DOWNTO 16),
		din(31 DOWNTO 16) 		=> dram_rd_data(15 DOWNTO 0),
		wr_en 		=> dram_rd_valid,
		rd_en 		=> rd_en,
		dout        => dataout,
		full 		=> open,
		prog_full   => genstall,
		empty 		=> empty
	);

	valid <= not empty;
end rtl;