library ieee;
use ieee.std_logic_1164.all;
entity counter_usr is
port (
  clk          : in  std_logic;
  rst         : in  std_logic;
  output       : out std_logic;
  en           : in std_logic);

end counter_usr;
architecture rtl of counter_usr is
--signal output : std_logic := '0';

begin

process(clk,rst)
variable count : integer := 0;
 begin
 if rst = '1' then
 output <= '0';

 elsif (clk'event and clk='1') then
 if en = '1' then
  count := count + 1;
  if (count = 9 ) then
	output <= '1';      
  end if;
 end if;
 end if;    
 end process;
 end rtl;