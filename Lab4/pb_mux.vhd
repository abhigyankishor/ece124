library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity pb_mux is
	port(
			pb			:	in	 	std_logic; --3 button input
			INPUT1	:	in		std_logic_vector(3 downto 0); -- when button 3 pressed
			INPUT2	:	in 	std_logic_vector(3 downto 0);
			OUTPUT	:	out	std_logic_vector(3 downto 0)
			
			
		);
end entity pb_mux;


architecture logic of pb_mux is




begin 
	OUTPUT<=INPUT1 when (pb='1') else INPUT2; -- output input1 when button 3 pressed else input2
	
end architecture logic;