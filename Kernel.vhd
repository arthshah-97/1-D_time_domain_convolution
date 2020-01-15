library ieee;
use ieee.std_logic_1164.all;
entity kernel_buffer is
port (
  clk          : in  std_logic;
  rst          : in  std_logic;
  load         : in std_logic;
  full         : out std_logic;
  input        : in  std_logic_vector(15 downto 0);
  output       : out std_logic_vector(2047 downto 0));
end kernel_buffer;


architecture rtl of kernel_buffer is
begin
process(clk,rst)
type t_sreg is array(0 to 127) of std_logic_vector(15 downto 0);
variable r_data               : t_sreg;
variable j : integer;
variable count : integer := 0;
variable flag : integer := 0;
begin

  if(rst='1') then
    r_data    := (others=>(others=>'0'));
    flag := 0;
    full <= '0';
  elsif(rising_edge(clk)) then
  if flag = 0 and load = '1' then
  count := count + 1;
  j := 127;
  for i in 1 to 127 loop
    r_data(j) := r_data(j-1);
    j := j -1;
  end loop;
  r_data(0) := input;
end if;
  if count = 128 then
    output <=  r_data(127) & r_data(126) & r_data(125) & r_data(124) & r_data(123) & r_data(122) & r_data(121) & r_data(120) & r_data(119) & r_data(118) & r_data(117) & r_data(116) & r_data(115) & r_data(114) & r_data(113) & r_data(112) & r_data(111) & r_data(110) & r_data(109) & r_data(108) & r_data(107) & r_data(106) & r_data(105) & r_data(104) & r_data(103) & r_data(102) & r_data(101) & r_data(100) & r_data(99) & r_data(98) & r_data(97) & r_data(96) & r_data(95) & r_data(94) & r_data(93) & r_data(92) & r_data(91) & r_data(90) & r_data(89) & r_data(88) & r_data(87) & r_data(86) & r_data(85) & r_data(84) & r_data(83) & r_data(82) & r_data(81) & r_data(80) & r_data(79) & r_data(78) & r_data(77) & r_data(76) & r_data(75) & r_data(74) & r_data(73) & r_data(72) & r_data(71) & r_data(70) & r_data(69) & r_data(68) & r_data(67) & r_data(66) & r_data(65) & r_data(64) & r_data(63) & r_data(62) & r_data(61) & r_data(60) & r_data(59) & r_data(58) & r_data(57) & r_data(56) & r_data(55) & r_data(54) & r_data(53) & r_data(52) & r_data(51) & r_data(50) & r_data(49) & r_data(48) & r_data(47) & r_data(46) & r_data(45) & r_data(44) & r_data(43) & r_data(42) & r_data(41) & r_data(40) & r_data(39) & r_data(38) & r_data(37) & r_data(36) & r_data(35) & r_data(34) & r_data(33) & r_data(32) & r_data(31) & r_data(30) & r_data(29) & r_data(28) & r_data(27) & r_data(26) & r_data(25) & r_data(24) & r_data(23) & r_data(22) & r_data(21) & r_data(20) & r_data(19) & r_data(18) & r_data(17) & r_data(16) & r_data(15) & r_data(14) & r_data(13) & r_data(12) & r_data(11) & r_data(10) & r_data(9) & r_data(8) & r_data(7) & r_data(6) & r_data(5) & r_data(4) & r_data(3) & r_data(2) & r_data(1) & r_data(0);
    flag := 1;
    full <= '1';
 end if;
 end if;
end process;
end rtl;