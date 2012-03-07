-----------------------------------------------------------
--  Ver  :| Original Author   		:| Additional Author :| 
--  V1.0 :| Bharathwaj Muthuswamy   :| Eric Lunty        :| 
-----------------------------------------------------------
--	  Minor code tweaks + glue code added                 :|
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adc_dac_controller is port 
(
		clk : in std_logic;
		noteButton : in std_logic;
		noteToggle : in std_logic;
		noteButton2 : in std_logic;
		noteToggle2 : in std_logic;
		instrumentButton : in std_logic;
		reset : in std_logic;
		audioClock : in std_logic; -- 18.432 MHz sample clock
		bitClock : out std_logic;
		dacLRSelect : out std_logic;
		dacData : out std_logic
);
end entity;

architecture behavioral of adc_dac_controller is

	--All array types are defined here
	type table is array (0 to 127) of integer range 0 to 1200000000;
	type demo is array (0 to 25) of integer range 60 to 69;
	type keyOnType is array (9 downto 0) of integer range 0 to 1;
	type harmonicArray is array (9 downto 0,5 downto 0) of std_logic_vector(11 downto 0);
	type HarmonicType is array (9 downto 0) of integer;
	type noteType is array (9 downto 0) of integer range 0 to 127;
	type velocityValueType is array (9 downto 0) of std_logic_vector(11 downto 0);

	signal internalBitClock : std_logic := '0';
	signal bitClockCounter : integer range 0 to 255;

	signal internalLRSelect,dataCount : std_logic := '0';
	signal LRCounter : integer range 0 to 31; 
	signal leftOutCounter,rightOutCounter : integer range 0 to 15;
	
	-- DAC data registers
	signal dacDataLeftChannelRegister ,dacDataRightChannelRegister : std_logic_vector(15 downto 0);
			
	-- wave counter and output data
	signal waveCounter : integer range 0 to 47;
	signal waveFromGenerator : integer range -32768 to 32767;
	
	signal  temp : std_logic_vector(11 downto 0);
	
	signal  SH1 : integer;
	signal  SH2 : integer;
	signal  SH3 : integer;
	signal  SH4 : integer;
	signal  SH5 : integer;
	signal  SH6 : integer;
	signal  totalKeys : integer range 1 to 10;
	signal  keyOn : keyOnType;

	signal sinHarmonic : harmonicArray;
	signal adsrHarmonic : harmonicArray;
	signal velocityValue: velocityValueType;
	signal note: noteType;
	
	signal index: integer range -1 to 25 := -1;
	signal instrumentType: integer range 0 to 2 :=0;
	
	signal phase : table :=(715828 ,715828 ,805306 ,805306 ,894785 ,894785 ,984263,1073742 ,1073742 ,1163220 ,1252699 ,1342177 ,1431656 ,1521134 ,1610613 ,1700091 ,1789570 ,1879048 ,2058005 ,2147484 ,2236962 ,2415919  ,2594876  ,2684355 ,2863312,3042269 ,3221226 ,3400183 ,3668618  ,3847575 ,4116010 ,4294968 ,4563403  ,4921317 ,5189752  ,5458188 ,5816102 ,6174016 ,6531930 ,6889844 ,7337236  ,7784628  ,8232021 ,8679413  ,9216284  ,9842633  ,10379504  ,11005854  ,11632203  ,12348031  ,13063859  ,13869165  ,14674472  ,15569256  ,16464041  ,17448304  ,18522046  ,19685266  ,20848488  ,22011708  ,23353884  ,24785540  ,26217196  ,27827808  ,29438422  ,31227992  ,33017562  ,34986088  ,37133572  ,39370532  ,41696976  ,44112892  ,46797248  ,49571080  ,52523872  ,55655616  ,58966320  ,62455984  ,66124600  ,70061656  ,74267144  ,78741064  ,83393952  ,88315264  ,93594496  ,99142160  ,105047744  ,111311232  ,117932640  ,124911968  ,132338680  ,140212784  ,148623760  ,157482128  ,166787904  ,176720016  ,187278464  ,198373808  ,210184960  ,222711952  ,235954768  ,249913408  ,264766832  ,280515040  ,297247520  ,314964256  ,333665280  ,353529504  ,374556928  ,396747616  ,420369920  ,445423904  ,471909536  ,499916288  ,529623168  ,561119552  ,594495040  ,629928512  ,667330560  ,707059008  ,749113856  ,793584704  ,840829312  ,890847808 ,943819072 ,999922048 ,1059335808 ,1122328704);
	
	signal demo_1 : demo := 
	(
	64,62,60,62,64,64,64,62,62,62,64,67,67,
	64,62,60,62,64,64,64,64,62,62,64,62,60
	);

	component waveform_gen is port 
	(
  -- system signals
  clk         : in  std_logic;
  reset       : in  std_logic;
  
  -- clock-enable
  en          : in  std_logic;
  
  -- NCO frequency control
  phase_inc1   : in  std_logic_vector(31 downto 0);
  phase_inc2   : in  std_logic_vector(31 downto 0);
  phase_inc3   : in  std_logic_vector(31 downto 0);
  phase_inc4   : in  std_logic_vector(31 downto 0);
  phase_inc5   : in  std_logic_vector(31 downto 0);
  phase_inc6   : in  std_logic_vector(31 downto 0);
  phase_inc7   : in  std_logic_vector(31 downto 0);
  phase_inc8   : in  std_logic_vector(31 downto 0);
  phase_inc9   : in  std_logic_vector(31 downto 0);
  phase_inc10   : in  std_logic_vector(31 downto 0);
  
  -- Output waveforms
  sin_out1     : out std_logic_vector(11 downto 0);
  sin_out2     : out std_logic_vector(11 downto 0);
  sin_out3     : out std_logic_vector(11 downto 0);
  sin_out4     : out std_logic_vector(11 downto 0);
  sin_out5     : out std_logic_vector(11 downto 0);
  sin_out6     : out std_logic_vector(11 downto 0);
  sin_out7     : out std_logic_vector(11 downto 0);
  sin_out8     : out std_logic_vector(11 downto 0);
  sin_out9     : out std_logic_vector(11 downto 0);
  sin_out10     : out std_logic_vector(11 downto 0);
  
  squ_out1     : out std_logic_vector(11 downto 0);
  squ_out2     : out std_logic_vector(11 downto 0);
  squ_out3     : out std_logic_vector(11 downto 0);
  squ_out4     : out std_logic_vector(11 downto 0);
  squ_out5     : out std_logic_vector(11 downto 0);
  squ_out6     : out std_logic_vector(11 downto 0);
  squ_out7     : out std_logic_vector(11 downto 0);
  squ_out8     : out std_logic_vector(11 downto 0);
  squ_out9     : out std_logic_vector(11 downto 0);
  squ_out10     : out std_logic_vector(11 downto 0)
  	);
	end component;
	
	component adsr is port
	(
		reset : in std_logic;
		clk : in std_logic;
		attackTime : in std_logic_vector(7 downto 0);
		decayTime : in std_logic_vector(7 downto 0);
		sustainLevel : in std_logic_vector(11 downto 0);
		releaseTime : in std_logic_vector(7 downto 0);
		velocity : in std_logic_vector(11 downto 0);
		input : in std_logic_vector(11 downto 0);
		output : out std_logic_vector(11 downto 0)
	);
	end component;
	
	
begin
		
	--Demo Control: (key 3)	
	demoProcess: process(noteButton)
	begin	
		if rising_edge(noteButton) then
				velocityValue(0) <= "000000000000";
				
				if index = 25 then
					index <= 0;
				elsif index = -1 then
					index <= 0;
				else
					index <= index + 1;
				end if;
				
				note(0) <= demo_1(index);
				velocityValue(0) <= "011111111111";
		end if;	
	end process;	
		
	--Instrument control: key(1)
	changeWave: process(instrumentButton)
	begin	
		if rising_edge(instrumentButton) then
			if instrumentType = 2 then
				instrumentType <= 0;
			else
				instrumentType <= instrumentType + 1;
			end if;
		end if;	
	end process;
	
--	--Note control: sw(17) + key(3)
--	changeNote: process(noteToggle,noteButton)
--	begin	
--		if rising_edge(noteButton) then
--			if velocityValue(0) = "011111111111" then
--				velocityValue(0) <= "000000000000";
--				keyOn(0) <= 0;
--			else
--				if noteToggle='1' then
--					if note(0) = 127 then
--						note(0) <= 127;
--					else
--						note(0) <= note(0) + 1;
--
--					end if;
--				elsif noteToggle='0' then
--					if note(0) = 0 then
--						note(0) <=0;
--					else
--						note(0) <= note(0) -1;
--					end if;
--				end if;
--				velocityValue(0) <= "011111111111";
--				keyOn(0) <= 1;
--			end if;
--		end if;	
--	end process;
--	
--	--Note control: sw(17) + key(3)
--	changeNote2: process(noteToggle2,noteButton2)
--	begin	
--		if rising_edge(noteButton2) then
--			if velocityValue(1) = "011111111111" then
--				velocityValue(1) <= "000000000000";
--				keyOn(1) <= 0;
--			else
--				if noteToggle2='1' then
--					if note(1) = 127 then
--						note(1) <= 127;
--					else
--						note(1) <= note(1) + 1;
--
--					end if;
--				elsif noteToggle2='0' then
--					if note(1) = 0 then
--						note(1) <=0;
--					else
--						note(1) <= note(1) -1;
--					end if;
--				end if;
--				velocityValue(1) <= "011111111111";
--				keyOn(1) <= 1;
--			end if;
--		end if;	
--	end process;
	
	--Generate bit clock
	--We have an 18.432 MHz reference clock (refer to audio codec datasheet, this is the required frequency)
	--We need to shift out 16 bits, 2 channels at 48 KHz.  Hence, the count value for flipping the clock bit is
	--Count = 18.432e6/(48000*16*2) - 1 = 11 (approx)
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
	

	
	--Generate LeftRight select signals 
	--Flip every 16 bits, starting on NEGATIVE edge
	process(internalBitClock,reset)
	begin
		if reset = '0' then					
			dacDataLeftChannelRegister <= X"0000";
			dacDataRightChannelRegister <= X"0000";
			LRCounter <= 0;
			internalLRSelect <= '0'; --Starts at low, fig. 26 on p. 33 of audio codec datasheet
			dataCount <= '0';
			leftOutCounter <= 15;
			rightOutCounter <= 15;
		else
			if internalBitClock'event and internalBitClock = '0' then -- flip on negative edge								
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
						--This is where the left/right channels are filled with values
						dacDataLeftChannelRegister <= std_logic_vector(to_signed(waveFromGenerator,16));
						dacDataRightChannelRegister <= std_logic_vector(to_signed(waveFromGenerator,16));					
					end if;									
				end if;
			end if;
		end if;
	end process;

	dacLRSelect <= internalLRSelect;
	
	--dacData output
	process(internalBitClock,reset,internalLRSelect)
	begin
		if reset = '0' then
			 dacData <= '0';			 
		else
			-- start on falling edge of bit clock
			if internalBitClock'event and internalBitClock = '0' then 
				--data is sent to dacData, which will eventually connect to the pin AUD_DACDAT
				if internalLRSelect = '1' then		
						dacData <= dacDataLeftChannelRegister(leftOutCounter);			
				else
						dacData <= dacDataRightChannelRegister(rightOutCounter);			
				end if;
			end if;
		end if;
	 end process;
	 
	--Wave generator
	
	GenerateWave:
		for i in 0 to 5 generate
			waveGen : waveform_gen port map 
			(
			
			--General Inputs
			dataCount,'1','1',
			
			--Phase Inputs
			std_logic_vector(to_unsigned(phase(note(0))*(i+1),32)),
			std_logic_vector(to_unsigned(phase(note(1))*(i+1),32)),
			std_logic_vector(to_unsigned(phase(note(2))*(i+1),32)),
			std_logic_vector(to_unsigned(phase(note(3))*(i+1),32)),
			std_logic_vector(to_unsigned(phase(note(4))*(i+1),32)),
			std_logic_vector(to_unsigned(phase(note(5))*(i+1),32)),
			std_logic_vector(to_unsigned(phase(note(6))*(i+1),32)),
			std_logic_vector(to_unsigned(phase(note(7))*(i+1),32)),
			std_logic_vector(to_unsigned(phase(note(8))*(i+1),32)),
			std_logic_vector(to_unsigned(phase(note(9))*(i+1),32)),
			
			--Sine Outputs
			sinHarmonic(0,i),
			sinHarmonic(1,i),
			sinHarmonic(2,i),
			sinHarmonic(3,i),
			sinHarmonic(4,i),
			sinHarmonic(5,i),
			sinHarmonic(6,i),
			sinHarmonic(7,i),
			sinHarmonic(8,i),
			sinHarmonic(9,i),
			
			--Square outputs
			temp,
			temp,
			temp,
			temp,
			temp,
			temp,
			temp,
			temp,
			temp,
			temp
			
			);
			
			adsrGen1 : adsr port map ('0',clk,"00000010","01111111","011111111111","11111111",
			velocityValue(0),sinHarmonic(0,i),adsrHarmonic(0,i));
			
			adsrGen2 : adsr port map ('0',clk,"00000010","01111111","011111111111","11111111",
			velocityValue(1),sinHarmonic(1,i),adsrHarmonic(1,i));
			
			adsrGen3 : adsr port map ('0',clk,"00000010","01111111","011111111111","11111111",
			velocityValue(2),sinHarmonic(2,i),adsrHarmonic(2,i));
			
			adsrGen4 : adsr port map ('0',clk,"00000010","01111111","011111111111","11111111",
			velocityValue(3),sinHarmonic(3,i),adsrHarmonic(3,i));
			
			adsrGen5 : adsr port map ('0',clk,"00000010","01111111","011111111111","11111111",
			velocityValue(4),sinHarmonic(4,i),adsrHarmonic(4,i));
			
			adsrGen6 : adsr port map ('0',clk,"00000010","01111111","011111111111","11111111",
			velocityValue(5),sinHarmonic(5,i),adsrHarmonic(5,i));
			
			adsrGen7 : adsr port map ('0',clk,"00000010","01111111","011111111111","11111111",
			velocityValue(6),sinHarmonic(6,i),adsrHarmonic(6,i));
			
			adsrGen8 : adsr port map ('0',clk,"00000010","01111111","011111111111","11111111",
			velocityValue(7),sinHarmonic(7,i),adsrHarmonic(7,i));
			
			adsrGen9 : adsr port map ('0',clk,"00000010","01111111","011111111111","11111111",
			velocityValue(8),sinHarmonic(8,i),adsrHarmonic(8,i));
			
			adsrGen10 : adsr port map ('0',clk,"00000010","01111111","011111111111","11111111",
			velocityValue(9),sinHarmonic(9,i),adsrHarmonic(9,i));
			
		end generate;
	
	totalKeys <= 1;
	
	SH1 <= 
	to_integer(signed(adsrHarmonic(0,0))) + 
	to_integer(signed(adsrHarmonic(1,0))) + 
	to_integer(signed(adsrHarmonic(2,0))) + 
	to_integer(signed(adsrHarmonic(3,0))) + 
	to_integer(signed(adsrHarmonic(4,0))) + 
	to_integer(signed(adsrHarmonic(5,0))) + 
	to_integer(signed(adsrHarmonic(6,0))) + 
	to_integer(signed(adsrHarmonic(7,0))) + 
	to_integer(signed(adsrHarmonic(8,0))) + 
	to_integer(signed(adsrHarmonic(9,0))) / totalKeys;
	
	SH2 <= to_integer(signed(adsrHarmonic(0,1)));
	SH3 <= to_integer(signed(adsrHarmonic(0,2)));
	SH4 <= to_integer(signed(adsrHarmonic(0,3)));
	SH5 <= to_integer(signed(adsrHarmonic(0,4)));
	SH6 <= to_integer(signed(adsrHarmonic(0,5)));
	
	--dacData output
	process(instrumentType)
	begin
		--Piano
		if instrumentType = 0 then		
			waveFromGenerator <= SH1;
		
		--Bassoon
		elsif instrumentType = 1 then
			waveFromGenerator <= (SH1*32 + SH2*128 + SH3*32)/128;
		
		--Saxaphone
		elsif instrumentType = 2 then
			waveFromGenerator <= (SH1*128 + SH2*64)/128;
			
		end if;
	 end process;

end behavioral;
