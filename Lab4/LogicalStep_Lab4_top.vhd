
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
   clkin_50		: in	std_logic;
	rst_n			: in	std_logic;
	pb				: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out std_logic_vector(7 downto 0);	-- for displaying the switch content
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	);
END LogicalStep_Lab4_top;


ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS
	
----------------------------------------------------------------------------------------------------
	CONSTANT	SIM							:  boolean := FALSE; 	-- set to TRUE for simulation runs otherwise keep at 0.
   CONSTANT CLK_DIV_SIZE				: 	INTEGER := 26;    -- size of vectors for the counters

   SIGNAL 	Main_CLK						:  STD_LOGIC; 			-- main clock to drive sequencing of State Machine

	SIGNAL 	bin_counter					:  UNSIGNED(CLK_DIV_SIZE-1 downto 0); -- := to_unsigned(0,CLK_DIV_SIZE); -- reset binary counter to zero
	
----------------------------------------------------------------------------------------------------

	component Bidir_shift_reg port(
	
	
		CLK			: in std_logic :='0';
		RESET_n		: in std_logic :='0';
		CLK_EN		: in std_logic :='0';
		LEFT0_RIGHT1	: in std_logic	:='0';
		REG_BITS		:out std_logic_vector(3 downto 0)
		
	);
	end component;


	component Bin_Counter4bit port
		(
	
		Main_clk 		:	in	std_logic :='0';
		rst_n				:	in std_logic :='0';
		clk_en			:	in std_logic :='0';
		up1_down0		:	in std_logic :='0';
		counter_bits	:	out std_logic_vector(3 downto 0)
	);
	end component;

	component Moore_ss port
		(
		 clk_input, rst_n, extenderToggle, extender_en					: IN std_logic;
		 currentPos																	: IN std_logic_vector(3 downto 0);
		 clk_en, leftright, grappler_en, extender_out					: OUT std_logic
	);
	end component;
	
	
	component Moore_ss2 port
		(
		clk_input, rst_n	: IN std_logic;										
		pb0, grappler_en	: IN std_logic;
		led3					: OUT std_logic
	);
	end component;
	
	
	component Mealy_State_Machine port
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
		movementLED 		: 	out std_logic
	
		);
	end component;

		
	component segment7_mux port
		(
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	
			 DIN1 		: in  std_logic_vector(6 downto 0);
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
       );
	end component;
	
	component SevenSegment port
		(
   
		hex	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   
		sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
		); 
	
	end component;
	
	
	component Compx4 port
		(
		--Two four bit numbers
		hexA : in std_logic_vector(3 downto 0);
		hexB : in std_logic_vector(3 downto 0);
		
		--All possible values from magnitude comparision
		aGb : out std_logic;
		aLb : out std_logic;
		aEb : out std_logic
		);
	end component;
	
	component pb_mux port
		(
			pb			:	in	 	std_logic; --3 button input
			INPUT1	:	in		std_logic_vector(3 downto 0); -- when button 3 pressed
			INPUT2	:	in 	std_logic_vector(3 downto 0);
			OUTPUT	:	out	std_logic_vector(3 downto 0)
			
		);
	end component;
	
	
	component mux7 port 
		(
			num1, num2 	: in 	std_logic_vector(6 downto 0);	-- Inputs to be mutexed
			mux_select	: in 	std_logic;						-- Mutex select between inputs
			num_out 	: out 	std_logic_vector(6 downto 0)	-- Output selected mutex
		);
	end component;
	
	signal shift_enable	:	std_logic;
	signal shift_dirout	:	std_logic;
	
	
	signal E_EN		:	std_logic;
	signal E_OUT	:	std_logic;
	
	
	signal seg7_A	:	std_logic_vector(6 downto 0);
	signal seg7_B	:	std_logic_vector(6 downto 0);
	
	signal extender_out	:	std_logic := '0';
	signal extender_en 	: 	std_logic := '0';
	signal extenderToggle:	std_logic := '0';
	
	signal grappler_en	:	std_logic;
	signal grapplerToggle:	std_logic := '0';
	
	signal tarX		:	std_logic_vector(3 downto 0);
	signal currX	:	std_logic_vector(3 downto 0) :="0000";
	
	signal x_input	:	std_logic;
	signal outX		:	std_logic_vector(3 downto 0);
	
	signal xGT		:	std_logic;
	signal xLT		:	std_logic;
	signal xEQ		:	std_logic;
	signal x_clock	:	std_logic;
	signal x_up_d	:	std_logic;
	
	
	signal tarY		:	std_logic_vector(3 downto 0);
	signal currY	:	std_logic_vector(3 downto 0) :="0000";
	
	signal extenderPos : std_logic_vector(3 downto 0) := "0000";
	signal ext_clk : std_logic := '0';
	
	signal l_r		: std_logic;
	
	signal y_input	:	std_logic;
	signal outY		:	std_logic_vector(3 downto 0);
	
	signal yGT		:	std_logic;
	signal yLT		:	std_logic;
	signal yEQ		:	std_logic;
	
	signal y_clock	:	std_logic;
	signal y_up_d	:	std_logic;
	
	signal error	:	std_logic;
	signal erro		:	std_logic;
	signal movement: 	std_logic;


	signal chosenX :	std_logic_vector(3 downto 0);
	signal chosenY :	std_logic_vector(3 downto 0);
	signal dispA, dispB	:	std_logic_vector(3 downto 0);
	signal seg7out_A, seg7out_B: std_logic_vector(6 downto 0);

		
BEGIN



-- CLOCKING GENERATOR WHICH DIVIDES THE INPUT CLOCK DOWN TO A LOWER FREQUENCY

BinCLK: PROCESS(clkin_50, rst_n) is
   BEGIN
		IF (rising_edge(clkin_50)) THEN -- binary counter increments on rising clock edge
         bin_counter <= bin_counter + 1;
      END IF;
   END PROCESS;

Clock_Source:
				Main_Clk <= 
				clkin_50 when sim = TRUE else				-- for simulations only
				std_logic(bin_counter(23));								-- for real FPGA operation
					
---------------------------------------------------------------------------------------------------
--INITIALIZING
tarX <= sw(7 downto 4);
tarY <= sw(3 downto 0);

x_input <= NOT(pb(3));
y_input <= NOT(pb(2));

grapplerToggle <= NOT(pb(0));

leds(7 downto 4) <= extenderPos;

extenderToggle <= NOT(pb(1));

--4 BIT COMPARISIONS
comp1: Compx4 port map(currX, tarX, xGT, xLT, xEQ);
comp2: Compx4 port map(currY, tarY, yGT, yLT, yEQ);

--MEALY
mealy: Mealy_State_Machine port map(Main_CLK, rst_n, x_input, y_input, xEQ, xGT, xLT, yEQ, yGT, yLT, extender_out, extender_en, x_clock, x_up_d, y_clock, y_up_d,error, leds(1));

--UP DOWN X AND Y
upDown1: Bin_Counter4bit port map(Main_CLK, rst_n, x_clock, x_up_d, currX);  
upDown2: Bin_Counter4bit port map(Main_CLK, rst_n, y_clock, y_up_d, currY);  


--MOORE 1 EXTENDER
moore1: 	Moore_ss port map(Main_CLK, rst_n, extenderToggle, extender_en, extenderPos, ext_clk, l_r, grappler_en, extender_out);
biDir:	Bidir_shift_reg port map(Main_CLK, rst_n, ext_clk, l_r, extenderPos);


moore2: Moore_ss2 port map(Main_CLK, rst_n, grapplerToggle, grappler_en, leds(3)); 




mux1: pb_mux port map(x_input, currX, tarX, chosenX); 
sevenSeg1: SevenSegment port map(chosenX, seg7_A);



mux2: pb_mux port map(y_input, currY, tarY, chosenY); 
sevenSeg2: SevenSegment port map(chosenY, seg7_B);


leds(0) <=error;
	
FLASHMUX1: mux7 port map("0000000", seg7_A, error AND bin_counter(24), seg7out_A);
FLASHMUX2: mux7 port map("0000000", seg7_B, error AND bin_counter(24), seg7out_B);
	
SEGMUX: segment7_mux port map(clkin_50, seg7out_B, seg7out_A, seg7_data, seg7_char2, seg7_char1);

	
END SimpleCircuit;
