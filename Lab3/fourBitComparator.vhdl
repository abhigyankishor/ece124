-- VHDL for a 4-bit comparator built from 1-bit comparators
library ieee;
use ieee.std_logic_1164.all;

entity fourBitComparator is
  port(x, y        : in std_logic_vector(3 downto 0);
       gin,ein,lin : in std_logic;
       G, E, L     : out std_logic);
end fourBitComparator;

architecture prototype of fourBitComparator is
  -- declaring the component for 1 bit comparator
  component comparator1
    port (g, e, l, a, b        : in std_logic;
          Gout, Eout, Lout     : out std_logic);
  end component;
  --temporary signals required to connect things
  signal G1, G2, G3, E1, E2, E3, L1, L2, L3 : std_logic;
  begin
    bit3: comparator1
      port map(a => x(3), b => y(3), g => gin, e => ein, l => lin, Gout => G1, Eout => E1, Lout => L1);
    bit2: comparator1
      port map(a => x(2), b => y(2), g => G1, e => E1, l => L1, Gout => G2, Eout => E2, Lout => L2);
    bit1: comparator1
      port map(a => x(1), b => y(1), g => G2, e => E2, l => L2, Gout => G3, Eout => E3, Lout => L3);
    bit0: comparator1
      port map(a => x(0), b => y(0), g => G3, e => E3, l => L3, Gout => G, Eout => E, Lout => L);
end prototype;
