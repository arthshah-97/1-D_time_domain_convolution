library ieee;
use ieee.std_logic_1164.all;
entity counter is
port (
  clk          : in  std_logic;
  rst         : in  std_logic;
  size        : in std_logic_vector(31 downto 0);
  rd_en       : in std_logic;
  done       : out std_logic;
  en           : in std_logic);
end counter;
architecture rtl of counter is

begin

process(clk,rst)
variable count : integer := 0;
 begin
 if rst = '1' then
 done <= '0';

 elsif (clk'event and clk='1') then
 if rd_en = '1' then
  count := count + 1;
  if (count = unsigned(size)) then
	done <= '1';      
  end if;
 end if;
 end if;    
 end process;
 end rtl;