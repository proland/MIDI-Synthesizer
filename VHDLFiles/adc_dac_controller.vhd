-- DE1 ADC DAC interface
-- adc, dac data interface
-- References:  
-- 1.  DE1 Reference designs (specifically, DE1_Default on DE1 System CD)
-- Bharathwaj Muthuswamy
-- EECS 3921 Fall 2010
-- muthuswamy@msoe.edu

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adc_dac_controller is port (
		reset : in std_logic;
		waveSelect : in std_logic; -- connected to SW(8), default (down) means sine, else square
		dataSelect : in std_logic; -- connected to SW(9), default (down) means sine on lineout.  up is ADC-DAC loopback
		audioClock : in std_logic; -- 18.432 MHz sample clock
		bitClock : out std_logic;
		adcLRSelect : out std_logic;
		dacLRSelect : out std_logic;
		adcData : in std_logic;
		dacData : out std_logic) ;
end entity;

architecture behavioral of adc_dac_controller is
	signal internalBitClock : std_logic := '0';
	signal bitClockCounter : integer range 0 to 255;
	
	signal internalLRSelect,dataCount : std_logic := '0';
	signal LRCounter : integer range 0 to 31; 
	signal leftOutCounter,rightOutCounter : integer range 0 to 15;
	
	-- ADC,DAC data registers
	signal adcDataLeftChannelRegister, adcDataRightChannelRegister: std_logic_vector(15 downto 0);
	signal dacDataLeftChannelRegister ,dacDataRightChannelRegister : std_logic_vector(15 downto 0);
			
	-- for sine and square
	signal waveCounter : integer range 0 to 47;
	signal sineWave, squareWave : integer range -32768 to 32767;
	
	
begin
	-- generate bit clock
	-- we have an 18.432 MHz reference clock (refer to audio codec datasheet, this is the required frequency)
	-- we need to shift out 16 bits, 2 channels at 48 KHz.  Hence, the count value for flipping the clock bit is
	-- count = 18.432e6/(48000*16*2) - 1 = 11 (approx)
	
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
	

	
	-- generate LeftRight select signals 
	-- flip every 16 bits, starting on NEGATIVE edge
	process(internalBitClock,reset)
	begin
		if reset = '0' then					
			dacDataLeftChannelRegister <= X"0000";
			dacDataRightChannelRegister <= X"0000";
			LRCounter <= 0;
			internalLRSelect <= '0'; -- should start at low, fig. 26 on p. 33 of audio codec datasheet
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
						-- select between square and sine
						if waveSelect = '1' then
							dacDataLeftChannelRegister <= std_logic_vector(to_signed(squareWave,16));
							dacDataRightChannelRegister <= std_logic_vector(to_signed(squareWave,16));
						else
							dacDataLeftChannelRegister <= std_logic_vector(to_signed(sineWave,16));
							dacDataRightChannelRegister <= std_logic_vector(to_signed(sineWave,16));
						end if;						
					end if;									
				end if;
			end if;
		end if;
	end process;

	adcLRSelect <= internalLRSelect;
	dacLRSelect <= internalLRSelect;
	
	-- sample adc data
	process(internalBitClock,reset,internalLRSelect)
	begin
		if reset = '0' then
			adcDataLeftChannelRegister <= X"0000";
			adcDataRightChannelRegister <= X"0000";
		else
			if internalBitClock'event and internalBitClock = '1' then
				if internalLRSelect = '1' then
					adcDataLeftChannelRegister(15 downto 0) <= adcDataLeftChannelRegister(14 downto 0) & adcData;
				else
					adcDataRightChannelRegister(15 downto 0) <= adcDataRightChannelRegister(14 downto 0) & adcData;
				end if;
			end if;
		end if;
	end process;
	
	
	-- dac data output
	process(internalBitClock,reset,internalLRSelect)
	begin
		if reset = '0' then
			 dacData <= '0';			 
		else
			-- start on falling edge of bit clock
			if internalBitClock'event and internalBitClock = '0' then 
				if internalLRSelect = '1' then		
					if dataSelect = '1' then
						-- remember, you need to send MSb first.  So, we start at bit 15
						dacData <= adcDataLeftChannelRegister(leftOutCounter);
					else
						dacData <= dacDataLeftChannelRegister(leftOutCounter);															
					end if;
				else
					if dataSelect = '1' then
						dacData <= adcDataLeftChannelRegister(rightOutCounter);
					else
						dacData <= dacDataRightChannelRegister(rightOutCounter);														
					end if;
				end if;
			end if;
		end if;
	 end process;
	 
--	
	--wave address generator
	process(dataCount,reset)
	begin
		if reset = '0' then
			waveCounter <= 0;
		else
			if dataCount'event and dataCount = '1' then
				if waveCounter >= 47 then
					waveCounter <= 0;
				else
					waveCounter <= waveCounter + 1;
				end if;
			end if;
		end if;
	end process;

-- square wave
with waveCounter select  
    squareWave       <=  -32768 when 0,
							 -32768 when 1,
							 -32768 when 2,
							 -32768 when 3,
    -32768 when 4,
    -32768 when 5,
    -32768 when 6,
    -32768 when 7,
    -32768 when 8,
    -32768 when 9,
    -32768 when 10,
    -32768 when 11,
    -32768 when 12,
    -32768 when 13,
    -32768 when 14,
    -32768 when 15,
    -32768 when 16,
    -32768 when 17,
    -32768 when 18,
    -32768 when 19,
    -32768 when 20,
    -32768 when 21,
    -32768 when 22,
    -32768 when 23,
    32767 when 24,
    32767 when 25,
    32767 when 26,
    32767 when 27,
    32767 when 28,
    32767 when 29,
    32767 when 30,
    32767 when 31,
    32767 when 32,
    32767 when 33,
    32767 when 34,
    32767 when 35,
    32767 when 36,
    32767 when 37,
    32767 when 38,
    32767 when 39,
    32767 when 40,
    32767 when 41,
    32767 when 42,
    32767 when 43,
    32767 when 44,
    32767 when 45,
    32767 when 46,
    32767 when 47;
	 
	
	-- sine table
	with waveCounter select  
    sineWave       <=  0 when 0,
							 4368 when 1,
							 8657 when 2,
							 12792 when 3,
    16699 when 4,
    20308 when 5,
    23554 when 6,
    26381 when 7,
    28736 when 8,
    30578 when 9,
    31875 when 10,
    32603 when 11,
    32750 when 12,
    32312 when 13,
    31297 when 14,
    29724 when 15,
    27620 when 16,
    25023 when 17,
    21980 when 18,
    18545 when 19,
    14779 when 20,
    10749 when 21,
    6527 when 22,
    2189  when 23,
    -2189 when 24,
    -6527 when 25,
    -10749 when 26,
    -14779 when 27,
    -18545 when 28,
    -21980 when 29,
    -25023 when 30,
    -27620 when 31,
    -29724 when 32,
    -31297 when 33,
    -32312 when 34,
    -32750 when 35,
    -32603 when 36,
    -31875 when 37,
    -30578 when 38,
    -28736 when 39,
    -26381 when 40,
    -23554 when 41,
    -20308 when 42,
    -16699 when 43,
    -12792 when 44,
    -8657 when 45,
    -4368 when 46,
    0 when 47;

end behavioral;