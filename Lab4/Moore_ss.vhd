library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity Moore_ss IS Port
(
 clk_input, rst_n, extenderToggle, extender_en					: IN std_logic;
 currentPos																	: IN std_logic_vector(3 downto 0);
 clk_en, leftright, grappler_en, extender_out					: OUT std_logic
 );
END ENTITY;
 

 Architecture SM of Moore_ss is
 
--R =RETRACTED
--E = EXTENDED
--ED = EXTENDED DOWN
--FullyExtended = FULLY EXTENDED
 
 TYPE STATE_NAMES IS (stationary, extending, retracting, fullyExtended);   -- list all the STATE_NAMES values

 
 SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES


  BEGIN
 
 --------------------------------------------------------------------------------
 --State Machine:
 --------------------------------------------------------------------------------

 -- REGISTER_LOGIC PROCESS:
 
Register_Section: PROCESS (clk_input, rst_n, next_state)  -- this process synchronizes the activity to a clock
BEGIN
	IF (rst_n = '0') THEN
		current_state <= stationary;
	ELSIF(rising_edge(clk_input)) THEN
		current_state <= next_state;
	END IF;
END PROCESS;	



-- TRANSITION LOGIC PROCESS

Transition_Section: PROCESS (current_state, extenderToggle, extender_en) 

BEGIN
     CASE current_state IS
			WHEN stationary =>
				IF((extender_en AND extenderToggle) = '1') THEN
					next_state <= extending;
				ELSE
					next_state <= stationary;
					
				END IF;
				
			WHEN extending =>
					
				IF(currentPos = "1111") THEN
					next_state <= fullyExtended;
					
					
				ELSE
					IF(extenderToggle = '0') THEN
						next_state <= retracting;
						
					ELSE
						next_state <= extending;
					
					END IF;
				END IF;
			
			WHEN retracting =>
				IF(currentPos = "0000") THEN
					next_state <= stationary;
					
				ELSE
					IF(extenderToggle = '1') THEN
						next_state <= extending;
						
					ELSE
						next_state <= retracting;
						
					END IF;
					
				END IF;
					
			WHEN fullyExtended =>
			
				IF(extenderToggle = '1') THEN
					next_state <= fullyExtended;
					
				ELSE
					next_state <= retracting;
					
				END IF;
			
 		END CASE;
 END PROCESS;

-- DECODER SECTION PROCESS

Decoder_Section: PROCESS (current_state) 

BEGIN
     CASE current_state IS
         WHEN stationary =>		
				clk_en <= '0'; 
				leftright <= '0';	--Doesn't matter
				grappler_en <= '0';
				extender_out <= '0';
			
			WHEN extending =>
				clk_en <= '1'; 
				leftright <= '1';	
				grappler_en <= '0';
				extender_out <= '1';
				
			WHEN retracting =>
				clk_en <= '1'; 
				leftright <= '0';	
				grappler_en <= '0';
				extender_out <= '1';
				
			WHEN fullyExtended =>
				clk_en <= '0'; 
				leftright <= '0';	--Doesn't matter
				grappler_en <= '1';
				extender_out <= '1';
				
				
	  END CASE;
 END PROCESS;

 END ARCHITECTURE SM;
