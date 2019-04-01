--VHDL for 1 bit comparator
library ieee;
use iee.std_logic__1164.all;

entity comparator1 is

  port (g,e,l,a,b : std_logic;
        Gout,Eout,Lout     : std_logic);
end comparator1;

architecture prototype of comparator1 is
  begin
    G <= g or ((a and not(b)) and e);
    E <= not (a xor b);
    L <= l or (e and (not(a) and b));
end prototype;
