library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity Compx1 is port(
	--Two one bit numbers
	a	: in std_logic;
	b	: in std_logic;

	--All possible conditions of magnitude comparision
	agb : out std_logic;
	alb : out std_logic;
	aeb : out std_logic
	
);

end Compx1;

architecture Behavioral of Compx1 is

--Temporary signals for comparision values
signal g : std_logic;
signal l : std_logic;



begin 

	--Checking if bit a is greater than bit b
	g <= a AND (NOT(b));
	
	--Checking if bit b is greater than bit a
	l <= b AND (NOT(a));
	
	agb <= g;
	alb <= l;
	aeb <= g NOR l;

end architecture Behavioral;