library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity Moore_ss2 IS Port
(
 clk_input, rst_n	: IN std_logic;										
 pb0, grappler_en	: IN std_logic;
 led3					: OUT std_logic
 );
END ENTITY;
 

 Architecture SM of Moore_ss2 is
 

 
 TYPE STATE_NAMES IS (LIGHT_ON, LIGHT_OFF);   -- list all the STATE_NAMES values

 
 SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES


  BEGIN
 
 --------------------------------------------------------------------------------
 --State Machine:
 --------------------------------------------------------------------------------

 -- REGISTER_LOGIC PROCESS:
 
Register_Section: PROCESS (clk_input, rst_n, next_state)  -- this process synchronizes the activity to a clock
BEGIN
	IF (rst_n = '0') THEN
		current_state <= LIGHT_OFF;
	ELSIF(rising_edge(clk_input)) THEN
		current_state <= next_state;
	END IF;
END PROCESS;	

-- TRANSITION LOGIC PROCESS

Transition_Section: PROCESS (current_state, pb0, grappler_en) 

BEGIN
     CASE current_state IS
         WHEN LIGHT_OFF =>		
				IF(pb0 ='1' and grappler_en = '1') THEN
					next_state <= LIGHT_ON;
				ELSE
					next_state <= LIGHT_OFF;
				END IF;

         WHEN LIGHT_ON =>	
				IF(pb0 = '0' OR grappler_en = '0') THEN
					next_state <= LIGHT_OFF;
				ELSE 
					next_state <= LIGHT_ON;
				END IF;
			
 		END CASE;
 END PROCESS;

-- DECODER SECTION PROCESS

Decoder_Section: PROCESS (current_state) 

BEGIN
     CASE current_state IS
         WHEN LIGHT_OFF =>		
			led3 <= '0';
			
         WHEN LIGHT_ON =>		
			led3 <= '1';

				
	  END CASE;
 END PROCESS;

 END ARCHITECTURE SM;
