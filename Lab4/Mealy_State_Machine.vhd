library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity Mealy_State_Machine IS Port
(

	clk_input			: 	in std_logic;
	rst_n					:	in std_logic;


	xInput, yInput 	:	in std_logic;
	x_EQ, x_GT, x_LT 	:	in std_logic;
	y_EQ, y_GT, y_LT 	:	in std_logic;

	extender_out			:	in std_logic;

	extender_en				:	out std_logic;

	x_clk_en, x_up_down	:	out std_logic;
	y_clk_en, y_up_down	:	out std_logic;

	errorLED				:	out std_logic;
	movementLED			: 	out std_logic

);

END Entity;

Architecture MSM of Mealy_State_Machine is


--STATES
TYPE STATE_NAMES IS (stationary, motion, extending);

SIGNAL current_state, next_state	:  STATE_NAMES;

BEGIN



--REGISTER
Register_Section: PROCESS (clk_input, rst_n, next_state)  -- this process synchronizes the activity to a clock
BEGIN
	IF (rst_n = '0') THEN
		current_state <= stationary;
	ELSIF(rising_edge(clk_input)) THEN
		current_state <= next_State;
	END IF;
END PROCESS;


Transition_Section: PROCESS (xInput, yInput, x_EQ, y_EQ, extender_out, current_state) 

BEGIN
    CASE current_state IS

			--WHEN STATIONARY CHOOSING WHICH TYPE OF MOTION OR WHETHER WE ARE ALREADY THERE
			WHEN stationary =>

				IF((x_EQ ='1' AND y_EQ = '1') OR extender_out = '1') THEN
					next_state <= extending;

				ELSIF((NOT(x_EQ = '1') AND xInput = '1') OR (NOT(y_EQ = '1') AND yInput = '1')) THEN
					next_state <= motion;

				ELSE
					next_state <= stationary;
				END IF;



			WHEN motion =>


				IF(NOT(x_EQ = '1' AND y_EQ = '1') AND (xInput = '1' OR yInput = '1')) THEN
					next_state <= motion;

				ELSE
					next_state <= stationary;
				END IF;





			WHEN extending =>
				IF(extender_out = '0' AND (NOT(x_EQ = '1' AND y_EQ = '1'))) THEN

					IF(xInput = '1' OR yInput = '1') THEN
						next_state <= motion;

					ELSE
						next_state <= stationary;

					END IF;

				ELSE
					next_state <= extending;

				END IF;



			WHEN OTHERS =>
				next_state <= stationary;

		END CASE;
 END PROCESS;


Decoder_Section: PROCESS (xInput,yInput,x_EQ,x_GT,x_LT,y_EQ, y_GT, y_LT, extender_out,current_state)

BEGIN
	CASE current_state IS

		WHEN stationary =>
			extender_en <= (x_EQ AND y_EQ) OR extender_out;
			x_clk_en <= '0';
			x_up_down <= '0';	--doesn't matter
			y_clk_en <= '0';
			y_up_down <= '0'; --doesn't matter
			errorLED <= '0';
			movementLED <= '0';


		WHEN motion =>
			extender_en <= x_EQ AND y_EQ;

			x_clk_en <= NOT(x_EQ) and xInput;


			x_up_down <= x_LT; -- if it is a 1 and it is equal it wont matter because clock wont be enabled



			y_clk_en <= NOT(y_EQ) and yInput;


			y_up_down <= y_LT; -- if it is a 1 and it is equal it wont matter because clock wont be enabled

			errorLED <= '0';
			movementLED <= '0';


		WHEN extending =>

			errorLED <= extender_out AND (xInput or yInput);
			movementLED <= xInput or yInput;

			extender_en <= (x_EQ AND y_EQ) OR extender_out;
			x_clk_en <= '0';
			x_up_down <= '0';	--doesn't matter
			y_clk_en <= '0';
			y_up_down <= '0'; --doesn't matter


	END CASE;

END PROCESS;


END ARCHITECTURE MSM;
