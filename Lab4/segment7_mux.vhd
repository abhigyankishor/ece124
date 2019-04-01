library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux7 is
port (
	num1, num2 	: in 	std_logic_vector(6 downto 0);	-- Inputs to be mutexed
	mux_select	: in 	std_logic;						-- Mutex select between inputs
	num_out 	: out 	std_logic_vector(6 downto 0)	-- Output selected mutex
);
end entity mux7;

architecture mux_logic of mux7 is

begin

with mux_select select
num_out <= 	num1 when '1',		-- Return first input if mutex_select is true, else return second input
				num2 when '0';
				
end mux_logic;