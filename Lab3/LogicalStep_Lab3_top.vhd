library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LogicalStep_Lab3_top is port (
  clkin_50	: in	std_logic;
	pb				: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
  leds			: out std_logic_vector(7 downto 0);	-- for displaying the switch content
  seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors

);
end LogicalStep_Lab3_top;

architecture Energy_Monitor of LogicalStep_Lab3_top is
--
-- Components Used
component SevenSegment port(
  hex : in std_logic_vector(3 downto 0);
  sevenseg : out std_logic_vector(6 downto 0)
);
end component;
-------------------------------------------------------------------
component segment7_mux port(
  clk : in std_logic := '0';
  DIN2 : in std_logic_vector(6 downto 0);
  DIN1 : in std_logic_vector(6 downto 0);
  DOUT : out std_logic_vector(6 downto 0);
  DIG2 : out std_logic;
  DIG1 : out std_logic
);
end component;
------------------------------------------------------------------
component fourBitComparator port(
  x,y : in std_logic_vector(3 downto 0);
  gin,ein,lin : in std_logic;
  G, E, L     : out std_logic
);
end component;
-- Create any signals, or temporary variables to be used
signal hex_A : std_logic_vector(3 downto 0);
signal hex_B : std_logic_vector(3 downto 0);
signal seg7_A : std_logic_vector(6 downto 0);
signal seg7_B : std_logic_vector(6 downto 0);
signal g,e,l : std_logic;
-- Here the circuit begins

begin Energy_Monitor:
hex_A <= sw(3 downto 0);
hex_B <= sw(7 downto 4);
INST1 : SevenSegment port map(hex_A, seg7_A);
INST2 : SevenSegment port map(hex_B, seg7_B);
INST3 : segment7_muxport port map(clkin_50, seg7_A, seg7_B, seg7_data, seg7_char2, seg7_char1);
INST4 : fourBitComparator port map(hex_A, hex_B, '0', '0','0',g, e, l);
with g select
  leds <= "00001111" when '1';
          "11110000"  when '0';
end Energy_Monitor;
