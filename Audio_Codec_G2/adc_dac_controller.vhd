-- Original Author : Bharathwaj Muthuswamy
-- Additional Authors : Eric Lunty, Kyle Brooks, Peter Roland

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adc_dac_controller is port 
(
		clk : in std_logic;
		demoButton : in std_logic;
		waveButton : in std_logic;
		effectButton : in std_logic;
		reset : in std_logic;
		audioClock : in std_logic;
		bitClock : out std_logic;
		dacLRSelect : out std_logic;
		dacData : out std_logic;
		
		LEDG : out std_logic_vector(7 downto 0);
		LEDR : out std_logic_vector(17 downto 0);
		
		note_0 : in std_logic_vector(19 downto 0);
		note_1 : in std_logic_vector(19 downto 0);
		note_2 : in std_logic_vector(19 downto 0);
		note_3 : in std_logic_vector(19 downto 0);
		note_4 : in std_logic_vector(19 downto 0);
		note_5 : in std_logic_vector(19 downto 0)
);
end entity;

architecture behavioral of adc_dac_controller is
	constant attack : std_logic_vector := "00110100";
	constant rls : std_logic_vector := "00100000";
	-- LUT for demo program and phase increments
	type table is array (0 to 127) of integer range 0 to 1200000000;
	type demo is array (0 to 25) of integer range 60 to 69;
	
	-- Array types for waveforms
	type waveArray is array (9 downto 0) of std_logic_vector(11 downto 0);
	type noteType is array (7 downto 0) of integer range 0 to 127;
	type velocityValueType is array (7 downto 0) of std_logic_vector(11 downto 0);

	-- Internally generated clocks and signals
	signal internalBitClock : std_logic := '0';
	signal bitClockCounter : integer range 0 to 255;
	signal internalLRSelect,dataCount : std_logic := '0';
	signal LRCounter : integer range 0 to 31; 
	signal leftOutCounter,rightOutCounter : integer range 0 to 15;
	
	-- DAC data registers
	signal dacDataLeftChannelRegister  : std_logic_vector(15 downto 0);
	signal dacDataRightChannelRegister : std_logic_vector(15 downto 0);
			
	-- Wave counter and output data
	signal waveCounter : integer range 0 to 47;
	signal waveFromGenerator : integer range -32768 to 32767;

	-- Waveform signals
	signal tempWave : std_logic_vector(23 downto 0);
	signal sinWave 	: waveArray;
	signal adsrWave : waveArray;
	signal squWave 	: waveArray;
	signal sawWave	: waveArray;
	signal waveform : waveArray;
	signal waveType: integer range 0 to 2 :=0;
	
	-- Velocity and note vectors
	signal velocityValue: velocityValueType;
	signal note: noteType;
	
	-- Index used for demo
	signal index: integer range -1 to 25 := -1;
	
	-- Waveform type
	signal instrumentType: integer range 0 to 2 :=0;
	
	-- Phase table for LUT
	signal phase : table :=(715828 ,715828 ,805306 ,805306 ,894785 ,894785 ,984263,1073742 ,1073742 ,1163220 ,1252699 ,1342177 ,1431656 ,1521134 ,1610613 ,1700091 ,1789570 ,1879048 ,2058005 ,2147484 ,2236962 ,2415919  ,2594876  ,2684355 ,2863312,3042269 ,3221226 ,3400183 ,3668618  ,3847575 ,4116010 ,4294968 ,4563403  ,4921317 ,5189752  ,5458188 ,5816102 ,6174016 ,6531930 ,6889844 ,7337236  ,7784628  ,8232021 ,8679413  ,9216284  ,9842633  ,10379504  ,11005854  ,11632203  ,12348031  ,13063859  ,13869165  ,14674472  ,15569256  ,16464041  ,17448304  ,18522046  ,19685266  ,20848488  ,22011708  ,23353884  ,24785540  ,26217196  ,27827808  ,29438422  ,31227992  ,33017562  ,34986088  ,37133572  ,39370532  ,41696976  ,44112892  ,46797248  ,49571080  ,52523872  ,55655616  ,58966320  ,62455984  ,66124600  ,70061656  ,74267144  ,78741064  ,83393952  ,88315264  ,93594496  ,99142160  ,105047744  ,111311232  ,117932640  ,124911968  ,132338680  ,140212784  ,148623760  ,157482128  ,166787904  ,176720016  ,187278464  ,198373808  ,210184960  ,222711952  ,235954768  ,249913408  ,264766832  ,280515040  ,297247520  ,314964256  ,333665280  ,353529504  ,374556928  ,396747616  ,420369920  ,445423904  ,471909536  ,499916288  ,529623168  ,561119552  ,594495040  ,629928512  ,667330560  ,707059008  ,749113856  ,793584704  ,840829312  ,890847808 ,943819072 ,999922048 ,1059335808 ,1122328704);

component effects_core is port 
(
  -- system signals
  clk         : in  std_logic;
  reset       : in  std_logic;
  
  -- clock-enable
  en          : in  std_logic;
  
  -- NCO frequency control
  phase_inc   : in  std_logic_vector(31 downto 0);
  
  -- Output waveform
  wave_out     : out std_logic_vector(11 downto 0)
);
end component;
	
component waveform_gen is port 
(
  -- System signals
  clk         : in  std_logic;
  reset       : in  std_logic;
  
  -- Clock-enable
  en          : in  std_logic;
  
  -- NCO frequency control
  phase_inc1   : in  std_logic_vector(31 downto 0);
  phase_inc2   : in  std_logic_vector(31 downto 0);
  phase_inc3   : in  std_logic_vector(31 downto 0);
  phase_inc4   : in  std_logic_vector(31 downto 0);
  phase_inc5   : in  std_logic_vector(31 downto 0);
  phase_inc6   : in  std_logic_vector(31 downto 0);
  
  -- Output waveforms
  sin_out1     : out std_logic_vector(11 downto 0);
  sin_out2     : out std_logic_vector(11 downto 0);
  sin_out3     : out std_logic_vector(11 downto 0);
  sin_out4     : out std_logic_vector(11 downto 0);
  sin_out5     : out std_logic_vector(11 downto 0);
  sin_out6     : out std_logic_vector(11 downto 0);
  
  squ_out1     : out std_logic_vector(11 downto 0);
  squ_out2     : out std_logic_vector(11 downto 0);
  squ_out3     : out std_logic_vector(11 downto 0);
  squ_out4     : out std_logic_vector(11 downto 0);
  squ_out5     : out std_logic_vector(11 downto 0);
  squ_out6     : out std_logic_vector(11 downto 0);
  
  saw_out1     : out std_logic_vector(11 downto 0);
  saw_out2     : out std_logic_vector(11 downto 0);
  saw_out3     : out std_logic_vector(11 downto 0);
  saw_out4     : out std_logic_vector(11 downto 0);
  saw_out5     : out std_logic_vector(11 downto 0);
  saw_out6     : out std_logic_vector(11 downto 0)  
  );
end component;
	
	component adsr is port
	(
		reset : in std_logic;
		clk : in std_logic;
		attackTime : in std_logic_vector(7 downto 0);
		sustainLevel : in std_logic_vector(11 downto 0);
		releaseTime : in std_logic_vector(7 downto 0);
		velocity : in std_logic_vector(11 downto 0);
		input : in std_logic_vector(11 downto 0);
		output : out std_logic_vector(11 downto 0)
	);
	end component;
	
	
begin	
	-- Turn tremelo on/off
	effectToggle : process(effectButton)
	begin
			if rising_edge(effectButton) then
				if tremeloOn = 1 then
					tremeloOn <= 0;
				else
					tremeloOn <= 1;
				end if;
			end if;
	end process;

	-- Waveform control (key 2)
	changeWave: process(waveButton)
	begin	
		if rising_edge(waveButton) then
			if waveType = 2 then
				waveType <= 0;
			else
				waveType <= waveType + 1;
			end if;
		end if;	
	end process;
	
--	-- Demo Control: (key 3)	
--	demoProcess: process(demoButton)
--	begin	
--		if rising_edge(demoButton) then
--				velocityValue(0) <= "000000000000";
--				
--				if index = 25 then
--					index <= 0;
--				elsif index = -1 then
--					index <= 0;
--				else
--					index <= index + 1;
--				end if;
--				
--				note(0) <= demo_1(index);
--				velocityValue(0) <= "011111111111";
--		end if;	
--	end process;	
		
	getValues: process(clk)
	begin
		if rising_edge(clk) then
			note(0) <= to_integer(unsigned(note_0(7 downto 0)));
			velocityValue(0) <= note_0(19 downto 8);
			note(1) <= to_integer(unsigned(note_1(7 downto 0)));
			velocityValue(1) <= note_1(19 downto 8);
			note(2) <= to_integer(unsigned(note_2(7 downto 0)));
			velocityValue(2) <= note_2(19 downto 8);
			note(3) <= to_integer(unsigned(note_3(7 downto 0)));
			velocityValue(3) <= note_3(19 downto 8);
			note(4) <= to_integer(unsigned(note_4(7 downto 0)));
			velocityValue(4) <= note_4(19 downto 8);
			note(5) <= to_integer(unsigned(note_5(7 downto 0)));
			velocityValue(5) <= note_5(19 downto 8);
		end if;
	end process;
	
	-- Test process to display the value and velocity of note zero
	ledProc : process(clk)
	begin
		if rising_edge(clk) then
			LEDG <= std_logic_vector(to_unsigned(note(0),8));
			LEDR <= "010101" & velocityValue(0);
		end if;
	end process;
	
	-- Generate bit clock to shift out 16 bits, 2 channels, at 48 KHz
	process(audioClock,reset)
	begin
		if reset = '0' then
			bitClockCounter <= 0;
			internalBitClock <= '0';
		else
			if audioClock'event and audioClock = '1' then
				if bitClockCounter < 5 then					
					internalBitClock <= '0'; 
					bitClockCounter <= bitClockCounter + 1;
				elsif bitClockCounter >= 5 and bitClockCounter < 11 then
					internalBitClock <= '1'; 
					bitClockCounter <= bitClockCounter + 1;
				else
					internalBitClock <= '0'; 
					bitClockCounter <= 0;
				end if;
			end if;
		end if;
	end process;
	bitClock <= internalBitClock;
	
	-- Generate LeftRight select signals 
	process(internalBitClock,reset)
	begin
		if reset = '0' then					
			dacDataLeftChannelRegister <= X"0000";
			dacDataRightChannelRegister <= X"0000";
			LRCounter <= 0;
			internalLRSelect <= '0'; 
			dataCount <= '0';
			leftOutCounter <= 15;
			rightOutCounter <= 15;
		else
			if internalBitClock'event and internalBitClock = '0' then 								
				if LRCounter < 16 then	
					internalLRSelect <= '1';
					LRCounter <= LRCounter + 1;
					leftOutCounter <= leftOutCounter - 1;
					rightOutCounter <= 15;
					dataCount <= '0';					
				elsif LRCounter >= 16 and LRCounter < 32 then
					internalLRSelect <= '0';
					LRCounter <= LRCounter + 1;
					dataCount <= '0';
					leftOutCounter <= 15;
					rightOutCounter <= rightOutCounter - 1;
					if LRCounter = 31 then
						LRCounter <= 0;
						dataCount <= '1';
						-- This is where the left/right channels are filled with values
						dacDataLeftChannelRegister <= std_logic_vector(to_signed(waveFromGenerator,16));
						dacDataRightChannelRegister <= std_logic_vector(to_signed(waveFromGenerator,16));					
					end if;									
				end if;
			end if;
		end if;
	end process;

	dacLRSelect <= internalLRSelect;
	
	-- dacData output
	process(internalBitClock,reset,internalLRSelect)
	begin
		if reset = '0' then
			 dacData <= '0';			 
		else
			-- Start on falling edge of bit clock
			if internalBitClock'event and internalBitClock = '0' then 
				-- Data is sent to dacData, which will eventually connect to the pin AUD_DACDAT
				if internalLRSelect = '1' then		
						dacData <= dacDataLeftChannelRegister(leftOutCounter);			
				else
						dacData <= dacDataRightChannelRegister(rightOutCounter);			
				end if;
			end if;
		end if;
	 end process;
	 
	-- Wave generator
	waveGen : waveform_gen port map 
			(
			
			-- General Inputs
			dataCount,'1','1',
			
			-- Phase Inputs
			std_logic_vector(to_unsigned(phase(note(0)),32)),
			std_logic_vector(to_unsigned(phase(note(1)),32)),
			std_logic_vector(to_unsigned(phase(note(2)),32)),
			std_logic_vector(to_unsigned(phase(note(3)),32)),
			std_logic_vector(to_unsigned(phase(note(4)),32)),
			std_logic_vector(to_unsigned(phase(note(5)),32)),
			
			-- Sine Outputs
			sinWave(0),
			sinWave(1),
			sinWave(2),
			sinWave(3),
			sinWave(4),
			sinWave(5),
			
			-- Square outputs
			squWave(0),
			squWave(1),
			squWave(2),
			squWave(3),
			squWave(4),
			squWave(5),
			
			sawWave(0),
			sawWave(1),
			sawWave(2),
			sawWave(3),
			sawWave(4),
			sawWave(5)
	);

	-- Process to decide which wave will be used
	process(waveType)

	begin
		if waveType = 0 then
			waveform(0) <= sinwave(0);
			waveform(1) <= sinwave(1);
			waveform(2) <= sinwave(2);
			waveform(3) <= sinwave(3);
			waveform(4) <= sinwave(4);
			waveform(5) <= sinwave(5);
		elsif waveType = 1 then
			waveform(0) <= squWave(0);
			waveform(1) <= squWave(1);
			waveform(2) <= squWave(2);
			waveform(3) <= squWave(3);
			waveform(4) <= squWave(4);
			waveform(5) <= squWave(5);
		elsif waveType = 2 then
			waveform(0) <= sawWave(0);
			waveform(1) <= sawWave(1);
			waveform(2) <= sawWave(2);
			waveform(3) <= sawWave(3);
			waveform(4) <= sawWave(4);
			waveform(5) <= sawWave(5);
		end if;
	end process;

	adsrGen0 : adsr port map ('0',clk,attack,velocityValue(0),rls,velocityValue(0),waveform(0),adsrWave(0));
	adsrGen1 : adsr port map ('0',clk,attack,velocityValue(1),rls,velocityValue(1),waveform(1),adsrWave(1));
	adsrGen2 : adsr port map ('0',clk,attack,velocityValue(2),rls,velocityValue(2),waveform(2),adsrWave(2));
	adsrGen3 : adsr port map ('0',clk,attack,velocityValue(3),rls,velocityValue(3),waveform(3),adsrWave(3));
	adsrGen4 : adsr port map ('0',clk,attack,velocityValue(4),rls,velocityValue(4),waveform(4),adsrWave(4));
	adsrGen5 : adsr port map ('0',clk,attack,velocityValue(5),rls,velocityValue(5),waveform(5),adsrWave(5));
		
	-- Turn on the tremelo when told to do so
	process(tremeloOn)
	begin
		if tremeloOn = 1 then
--			waveFromGenerator <=  
--				to_integer(signed(adsrWave(0))) * tremeloEffect;

		else
			waveFromGenerator <=  
			(to_integer(signed(adsrWave(0))) + to_integer(signed(adsrWave(1))) + 
			to_integer(signed(adsrWave(2))) + to_integer(signed(adsrWave(3))) + 
			to_integer(signed(adsrWave(4))) + to_integer(signed(adsrWave(5))));
		end if;
	end process;
	
end behavioral;
