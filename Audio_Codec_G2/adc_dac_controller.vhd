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
		volumeButton : in std_logic;
		volumeToggle : in std_logic;
		noteButton : in std_logic;
		noteToggle : in std_logic;
		instrumentButton : in std_logic;
		reset : in std_logic;
		audioClock : in std_logic; -- 18.432 MHz sample clock
		bitClock : out std_logic;
		dacLRSelect : out std_logic;
		dacData : out std_logic
);
end entity;

architecture behavioral of adc_dac_controller is

	type table is array (0 to 127) of integer range 0 to 1200000000;

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
	
	signal  sinHarmonic1    : std_logic_vector(11 downto 0);
	signal  sinHarmonic2    : std_logic_vector(11 downto 0);
	signal  sinHarmonic3    : std_logic_vector(11 downto 0);
	signal  sinHarmonic4    : std_logic_vector(11 downto 0);
	signal  sinHarmonic5    : std_logic_vector(11 downto 0);
	signal  sinHarmonic6    : std_logic_vector(11 downto 0);

	signal  temp : std_logic_vector(11 downto 0);
	
	signal  SH1    : integer;
	signal  SH2    : integer;
	signal  SH3    : integer;
	signal  SH4    : integer;
	signal  SH5    : integer;
	signal  SH6    : integer;

	signal volumeMult: integer range 0 to 10 := 5;	
	signal note: integer range 0 to 127 := 63;
	signal instrumentType: integer range 0 to 4 :=0;
	
	signal phase : table :=(715828 ,715828 ,805306 ,805306 ,894785 ,894785 ,984263 ,1073742 ,1073742 ,1163220 ,1252699 ,1342177 ,1431656 ,1521134 ,1610613 ,1700091 ,1789570 ,1879048 ,2058005 ,2147484 ,2236962 ,2415919  ,2594876  ,2684355 ,2863312,3042269 ,3221226 ,3400183 ,3668618  ,3847575 ,4116010 ,4294968 ,4563403  ,4921317 ,5189752  ,5458188 ,5816102 ,6174016 ,6531930 ,6889844 ,7337236  ,7784628  ,8232021 ,8679413  ,9216284  ,9842633  ,10379504  ,11005854  ,11632203  ,12348031  ,13063859  ,13869165  ,14674472  ,15569256  ,16464041  ,17448304  ,18522046  ,19685266  ,20848488  ,22011708  ,23353884  ,24785540  ,26217196  ,27827808  ,29438422  ,31227992  ,33017562  ,34986088  ,37133572  ,39370532  ,41696976  ,44112892  ,46797248  ,49571080  ,52523872  ,55655616  ,58966320  ,62455984  ,66124600  ,70061656  ,74267144  ,78741064  ,83393952  ,88315264  ,93594496  ,99142160  ,105047744  ,111311232  ,117932640  ,124911968  ,132338680  ,140212784  ,148623760  ,157482128  ,166787904  ,176720016  ,187278464  ,198373808  ,210184960  ,222711952  ,235954768  ,249913408  ,264766832  ,280515040  ,297247520  ,314964256  ,333665280  ,353529504  ,374556928  ,396747616  ,420369920  ,445423904  ,471909536  ,499916288  ,529623168  ,561119552  ,594495040  ,629928512  ,667330560  ,707059008  ,749113856  ,793584704  ,840829312  ,890847808 ,943819072 ,999922048 ,1059335808 ,1122328704);

	component waveform_gen is port 
	(
  		-- system signals
  		clk         : in  std_logic;
  		reset       : in  std_logic;
  		-- clock-enable
  		en          : in  std_logic;
  		-- NCO frequency control
  		phase_inc   : in  std_logic_vector(31 downto 0);
  		-- Output waveforms
  		sin_out     : out std_logic_vector(11 downto 0);
  		squ_out     : out std_logic_vector(11 downto 0);
  		saw_out     : out std_logic_vector(11 downto 0) 
  	);
	end component;
	
	
begin
	
	--Volume control (sw(17) + key(3))
	Volume: process(volumeToggle,volumeButton)
	begin	
		if rising_edge(volumeButton) then
				if volumeToggle='0' then
					if volumeMult = 10 then
						volumeMult <= 10;
					else
						volumeMult <= volumeMult + 1;
					end if;
				elsif volumeToggle='1' then
					if volumeMult = 0 then
						volumeMult <=0;
					else
						volumeMult <= volumeMult -1;
					end if;
				end if;
		end if;	
	end process;
	
	--Instrument control (key(1))
	changeWave: process(instrumentButton)
	begin	
		if rising_edge(instrumentButton) then
			if instrumentType = 4 then
				instrumentType <= 0;
			else
				instrumentType <= instrumentType + 1;
			end if;
		end if;	
	end process;
	
	--Note control (sw(16) + key(2))
	changeNote: process(noteToggle,noteButton)
	begin	
		if rising_edge(noteButton) then
				if noteToggle='1' then
					if note = 127 then
						note <= 127;
					else
						note <= note + 1;
					end if;
				elsif noteToggle='0' then
					if note = 0 then
						note <=0;
					else
						note <= note -1;
					end if;
				end if;
		end if;	
	end process;

	
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
	wave1 : waveform_gen port map (dataCount,'1','1',std_logic_vector(to_unsigned(phase(note)*1,32)),sinHarmonic1,temp,temp);
	wave2 : waveform_gen port map (dataCount,'1','1',std_logic_vector(to_unsigned(phase(note)*2,32)),sinHarmonic2,temp,temp);
	wave3 : waveform_gen port map (dataCount,'1','1',std_logic_vector(to_unsigned(phase(note)*3,32)),sinHarmonic3,temp,temp);
	wave4 : waveform_gen port map (dataCount,'1','1',std_logic_vector(to_unsigned(phase(note)*4,32)),sinHarmonic4,temp,temp);
	wave5 : waveform_gen port map (dataCount,'1','1',std_logic_vector(to_unsigned(phase(note)*5,32)),sinHarmonic5,temp,temp);
	wave6 : waveform_gen port map (dataCount,'1','1',std_logic_vector(to_unsigned(phase(note)*6,32)),sinHarmonic6,temp,temp);
	
	SH1 <= to_integer(signed(sinHarmonic1));
	SH2 <= to_integer(signed(sinHarmonic2));
	SH3 <= to_integer(signed(sinHarmonic3));
	SH4 <= to_integer(signed(sinHarmonic4));
	SH5 <= to_integer(signed(sinHarmonic5));
	SH6 <= to_integer(signed(sinHarmonic6));
	
	--dacData output
	process(instrumentType)
	begin
		--Piano
		if instrumentType = 0 then		
			waveFromGenerator <= SH1;
		
		--Bassoon
		elsif instrumentType = 1 then
			waveFromGenerator <= (SH1*45 + SH2*100 + SH3*34)/200;
		
		--Saxaphone
		elsif instrumentType = 2 then
			waveFromGenerator <= (SH1*100 + SH2*81)/200;
		
		--Flute
		elsif instrumentType = 3 then
			waveFromGenerator <= (SH1*00 + SH2*61 + SH3*10 + SH4*24 + SH5*11 + SH6*10)/200;
		
		--Trombone
		elsif instrumentType = 4 then
			waveFromGenerator <= (SH1*73 + SH2*45 + SH3*100 + SH4*30 + SH5*25)/300;
		end if;
	 end process;

end behavioral;
