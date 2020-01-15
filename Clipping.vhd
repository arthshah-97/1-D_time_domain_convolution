library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
--use work.math_custom.all;
entity Clipping is
generic (
    num_inputs   : positive := 2;
    input1_width : positive := 9;
    input2_width : positive := 9);
port (
  clk          : in  std_logic;
  rst         : in  std_logic;
  en          : in std_logic;
  input         : in std_logic_vector(38 downto 0);
  output         : out std_logic_vector(15 downto 0)
  );
end Clipping;
architecture rtl of Clipping is
begin
process(clk,rst)
variable out1 : std_logic_vector(38 downto 0);
variable flag : integer := 0;
begin
if(rst='1') then
	out1 := (others => '0');
	output <= (others => '0');
elsif(rising_edge(clk)) then
	if en = '1' then
	out1 := input;
	for i in 16 to 38 loop
	if (out1(i) = '1') then
		flag := 1;
	end if;
	end loop;
	if flag = 1 then
		output <= (others => '1');
		flag := 0;
	else
		output <= input(15 downto 0);
		flag := 0;
	end if;
	end if;
end if;
end process;
end rtl;
