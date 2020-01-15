library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.user_pkg.all;
 
entity add_gen is
    port(
        clk     	: in std_logic;
        rst         : in std_logic;
		start 		: in std_logic;
		size		: in std_logic_vector(RAM0_RD_SIZE_RANGE);
		startadd	: in std_logic_vector(C_RAM0_ADDR_WIDTH-1 downto 0);
        raddr       : out std_logic_vector(C_RAM0_ADDR_WIDTH-1 downto 0);
		ack         : out std_logic;
		clear       : in std_logic;
		valid       : out std_logic;
		stall       : in std_logic;
		flush       : out std_logic
        );
end add_gen;
 
architecture rtl of add_gen is
  type state_type is (S_INIT, S_EXECUTE,S_DONE);
  signal state, next_state : state_type;
  signal current, next : unsigned(RAM0_RD_SIZE_RANGE);
  signal address, next_address     : std_logic_vector(C_RAM0_ADDR_WIDTH-1 downto 0);

begin

  process (clk, rst)

begin
    if (rst = '1') then
      address   <= (others => '0');
      current <= (others => '0');
      state    <= S_INIT;

elsif (rising_edge(clk)) then
      address   <= next_address;
      current <= next;
      state    <= next_state;
    end if;
  end process;

  process(address, current, size, state, start, stall)
  begin

    next_state    <= state;
    next_address  <= address;
    next <= current;
	flush    <= '0';
	valid    <= '0';
	ack       <= '0';
    case state is
      when S_INIT =>
        next_address <= startadd;
        if (start = '1') then
          next <= unsigned(size)+ unsigned(startadd)+to_unsigned(1,C_RAM0_ADDR_WIDTH);
          next_state    <= S_EXECUTE;
		  ack       <='1';
        end if;
		if clear = '1' then 
			flush <= '1';
		end if;
      when S_EXECUTE =>
        valid <= '1';
        if (unsigned(address) = (current/2)-1) then
          next_state  <= S_DONE;
        elsif (stall = '0') then
          next_address <= std_logic_vector(unsigned(address)+1);
        elsif (stall = '1') then
         valid <= '0';
        end if;
	  WHEN S_DONE =>
		if clear = '1' then 
			flush <= '1';
			next_state <= S_INIT;
		end if;
      when others => null;
    end case;
  end process;
  
  raddr <= address(C_RAM0_ADDR_WIDTH-1 downto 0);
end rtl;