library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;




entity Compx4 is port (
	--Two four bit numbers
	hexA : in std_logic_vector(3 downto 0);
	hexB : in std_logic_vector(3 downto 0);
	
	--All possible values from magnitude comparision
	aGb : out std_logic;
	aLb : out std_logic;
	aEb : out std_logic
	
	
	
);
end Compx4;



architecture Behavioral of Compx4 is



	--One Bit comparator

	component Compx1 port(
	
		a	: std_logic;
		b	: std_logic;
		
		agb	: out std_logic;
		alb	: out std_logic;
		aeb	: out std_logic
	
	);
	end component;

	--Stored values for all one bit comparisions
	signal agb0, agb1, agb2, agb3, alb0, alb1, alb2, alb3, aeb0, aeb1, aeb2, aeb3 : std_logic;
	
	--Greater than and less than values
	signal g : std_logic;
	signal l : std_logic;
	
	
begin

	--Performing one bit comparisions on all corresponding bits
	INST1 : Compx1 port map (hexA(0) , hexB(0) , agb0, alb0, aeb0);
	INST2 : Compx1 port map (hexA(1) , hexB(1) , agb1, alb1, aeb1);
	INST3 : Compx1 port map (hexA(2) , hexB(2) , agb2, alb2, aeb2);
	INST4 : Compx1 port map (hexA(3) , hexB(3) , agb3, alb3, aeb3);
	
	
	--Equations for greater than and less than
	g <= agb3 OR (aeb3 AND agb2) OR (aeb3 AND aeb2 AND agb1) OR (aeb3 AND aeb2 AND aeb1 AND agb0);	--only compare a bit if all bits before it were equal
	l <= alb3 OR (aeb3 AND alb2) OR (aeb3 AND aeb2 AND alb1) OR (aeb3 AND aeb2 AND aeb1 AND alb0);
	
	aGb <= g;
	aLb <= l;
	aEb <= g NOR l;	--Equality is the only condition left if neither number is greater or less than the other
	
end Behavioral;