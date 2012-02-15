-- DE1 ADC DAC interface
-- top-level module
-- References:  
-- 1.  DE1 User's manual
-- 2.  DE1 Reference Designs (specifically, DE1_Default)
-- 3.  Digital Differential Analyzer: http://courses.cit.cornell.edu/ece576/DDA/index.htm
-- Bharathwaj Muthuswamy
-- EECS 3921 Fall 2010
-- muthuswamy@msoe.edu

-- This design is a VHDL interface to the audio codec on the DE1 board
-- Placing SW(0) in the UP position runs the design
-- SW(9) is down means a sine wave (if SW(8) is down) of 1 KHz is output on line out 
-- SW(9) is down but SW(8) is up means a square wave of 1 KHz is output on line out
-- (sine wave and square wave ROM are inside adc_dac_controller module below)
-- SW(9) in up position is ADC to DAC loopback
-- The codec is configured for 16-bit 48 KHz sampling frequency.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DE1_Audio_AdcDac is port
	(
		-- LCD ports                
		LCD_ON  :  out std_logic;
                LCD_BLON :      out std_logic;
                LCD_EN  :       out std_logic;
                LCD_RS  :       out std_logic;
                LCD_RW  :       out std_logic;
                LCD_DATA        :       inout   std_logic_vector (7 downto 0);

                -- DRAM ports
                DRAM_CLK, DRAM_CKE : OUT STD_LOGIC;
                DRAM_ADDR : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
                DRAM_BA_1, DRAM_BA_0 : BUFFER STD_LOGIC;
                DRAM_CS_N, DRAM_CAS_N, DRAM_RAS_N, DRAM_WE_N : OUT STD_LOGIC;
                DRAM_DQ : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
                DRAM_UDQM, DRAM_LDQM : BUFFER STD_LOGIC ;

		CLOCK_50 : in std_logic;
		CLOCK_27 : in std_logic_vector(1 downto 0);
		KEY : in std_logic_vector(0 downto 0);
		SW : in std_logic_vector(9 downto 0);
		AUD_ADCLRCK : out std_logic;
		AUD_ADCDAT : in std_logic;
		AUD_DACLRCK : out std_logic;
		AUD_DACDAT : out std_logic;
		AUD_XCK : out std_logic;
		AUD_BCLK : out std_logic;
		I2C_SCLK : out std_logic; -- master (our module) drives i2c clock
		I2C_SDAT : inout std_logic;
		GPIO_1 : inout std_logic_vector(35 downto 0);
		HEX0,HEX1,HEX2,HEX3 : out std_logic_vector(6 downto 0)
	);
end DE1_Audio_AdcDac;
	
architecture topLevel of DE1_Audio_AdcDac is
	
	component SOPC_File is port 
	(
                 -- 1) global signals:
                    signal altpll_0_c0_out : OUT STD_LOGIC;
                    signal altpll_0_c1_out : OUT STD_LOGIC;
                    signal clk_0 : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- the_altpll_0
                    signal locked_from_the_altpll_0 : OUT STD_LOGIC;
                    signal phasedone_from_the_altpll_0 : OUT STD_LOGIC;

                 -- the_char_lcd
                    signal LCD_E_from_the_char_lcd : OUT STD_LOGIC;
                    signal LCD_RS_from_the_char_lcd : OUT STD_LOGIC;
                    signal LCD_RW_from_the_char_lcd : OUT STD_LOGIC;
                    signal LCD_data_to_and_from_the_char_lcd : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);

                 -- the_sdram_0
                    signal zs_addr_from_the_sdram_0 : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
                    signal zs_ba_from_the_sdram_0 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal zs_cas_n_from_the_sdram_0 : OUT STD_LOGIC;
                    signal zs_cke_from_the_sdram_0 : OUT STD_LOGIC;
                    signal zs_cs_n_from_the_sdram_0 : OUT STD_LOGIC;
                    signal zs_dq_to_and_from_the_sdram_0 : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal zs_dqm_from_the_sdram_0 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal zs_ras_n_from_the_sdram_0 : OUT STD_LOGIC;
                    signal zs_we_n_from_the_sdram_0 : OUT STD_LOGIC
        );
	end component SOPC_File;

	component audio_codec_controller is port
	(
		reset : in std_logic;
		clock : in std_logic;
		scl : out std_logic;
		sda : inout std_logic;
		stateOut : out integer range 0 to 7);
	end component;
	
	component delayCounter is port 
	(
		reset : in std_logic;
		clock : in std_logic;
		resetAdc : out std_logic);
	end component;
	
	
	component clockBuffer IS
	PORT
	(
		areset : IN STD_LOGIC := '0';
		inclk0 : IN STD_LOGIC := '0';
		c0 : OUT STD_LOGIC );
	END component;
	
	component audioPLL IS
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC);
	END component;

	component adc_dac_controller is port 
	(
		reset : in std_logic;
		waveSelect : in std_logic; -- connected to SW(8), default (down) means sine, else square
		dataSelect : in std_logic; -- connected to SW(9), default (down) means sine on lineout.  up is ADC-DAC loopback
		audioClock : in std_logic; -- 18.432 MHz sample clock
		bitClock : out std_logic;
		adcLRSelect : out std_logic;
		dacLRSelect : out std_logic;
		adcData : in std_logic;
		dacData : out std_logic);
	end component;
	
	signal i2cClock,audioClock,clock50MHz : std_logic := '0';
	signal stateOut : integer range 0 to 7;
	signal resetAdcDac : std_logic := '0';
	
	signal adcLRC,bitClock,adcdat,dacLRC,dacDat : std_logic := '0';

        signal BA : STD_LOGIC_VECTOR (1 downto 0);
        signal DQM : STD_LOGIC_VECTOR (1 downto 0);

        signal pll_c1:STD_LOGIC;
        signal pll_locked:STD_LOGIC;
        signal pll_phase: STD_LOGIC;
	
begin

        LCD_ON <= '1';


        DRAM_BA_1 <= BA(1);
        DRAM_BA_0 <= BA(0);
        DRAM_UDQM <= DQM(1);
        DRAM_LDQM <= DQM(0);
	
	mainSystem: SOPC_File port map
	(
		DRAM_CLK, pll_c1, CLOCK_50 , KEY(0),pll_locked,pll_phase,
		LCD_EN, LCD_RS, LCD_RW, LCD_DATA,DRAM_ADDR, BA, DRAM_CAS_N, DRAM_CKE, DRAM_CS_N,DRAM_DQ, DQM, DRAM_RAS_N, DRAM_WE_N
	);

	-- clock buffer to avoid clock skews
	clock50Mhz<=CLOCK_50;
	-- clockBuffer50MHz : clockBuffer port map(not SW(0),CLOCK_50,clock50MHz);
	
	audioCodecController : audio_codec_controller port map (SW(0),clock50MHz,i2cClock,I2C_SDAT,stateOut);
	-- we only start the audio controller below long (40 ms) after we reset the system
	-- the reason is that transmitting all the i2c data takes at least 19 ms (20 KHz clock)
	adcDacControllerStartDelay : delayCounter port map (SW(0),clock50MHz,resetAdcDac);
	
	-- we will use a PLL to generate the necessary 18.432 MHz Audio Control clock
	audioPllClockGen : audioPLL port map (not resetAdcDac,CLOCK_27(0),audioClock);
	
	adcDacController : adc_dac_controller port map (resetAdcDac,SW(8),SW(9),audioClock,bitClock,adcLRC,AUD_DACLRCK,adcDat,dacDat);
	-- send out the clocks
	I2C_SCLK <= i2cClock;
	AUD_BCLK <= bitClock;
	AUD_XCK <= audioClock;
	
	-- input from adc
	adcDat <= AUD_ADCDAT;
	
	-- output assignments
	AUD_ADCLRCK <= adcLRC;
	AUD_DACDAT <= dacDat;
	 
	-- debug connections to GPIO 1.
	-- You **should** use an external logic analyzer (or SignalTap)
	-- to understand timing in this design.  I use an external
	-- logic analyzer because it is so much quicker and I have only
	-- 7 signals to look at.
	GPIO_1(0) <= i2cClock;
	GPIO_1(1) <= I2C_SDAT;
	GPIO_1(3) <= audioClock; 
	GPIO_1(5) <= adcLRC; 
	GPIO_1(7) <= bitClock; 
	GPIO_1(9) <= dacDat; 
	GPIO_1(11) <= adcDat; 
	
	HEX3 <= "1111111";
	HEX2 <= "1111111";
	HEX1 <= "1111111";
	with stateOut select
		HEX0 <= "1000000" when 0, -- resetState
				  "1111100" when 1, -- transmit
				  "0100100" when 2, -- checkAcknowledge
				  "0110000" when 3, -- turnOffi2cControl
				  "0011001" when 4, -- incrementMuxSelectBits
				  "0010010" when 5, -- stop
				  "1111111" when others; -- should not occur
	
		
end topLevel;

