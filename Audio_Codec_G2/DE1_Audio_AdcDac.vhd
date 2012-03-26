-----------------------------------------------------------
--  Ver  :| Original Author   	    :| Additional Author :| 
--  V1.0 :| Bharathwaj Muthuswamy   :| Eric Lunty        :| 
-----------------------------------------------------------
--	  Minor code tweaks + glue code added            :|
-----------------------------------------------------------

-- This design is a VHDL interface to the audio codec on the DE2 board
-- Placing SW(0) in the UP position runs the design
-- SW(16) + Key(2) controls note up / down (toggled with switch)
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
	
	-- LEDs
	LEDG    : out std_logic_vector(7 downto 0);
	LEDR 	  : out std_logic_vector(17 downto 0);

	CLOCK_50 : in std_logic;
	CLOCK_27 : in std_logic;
	KEY : in std_logic_vector(3 downto 0);
	SW : in std_logic_vector(17 downto 0);
	AUD_DACLRCK : out std_logic;
	AUD_DACDAT : out std_logic;
	AUD_XCK : out std_logic;
	AUD_BCLK : out std_logic;
	I2C_SCLK : out std_logic; -- master (our module) drives i2c clock
	I2C_SDAT : inout std_logic;
	GPIO_1 : inout std_logic_vector(35 downto 0);
	HEX0,HEX1,HEX2,HEX3 : out std_logic_vector(6 downto 0);
	
	UART_RXD : in std_logic;
	UART_TXD : out std_logic
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
                    signal zs_we_n_from_the_sdram_0 : OUT STD_LOGIC;

                 -- the_uart_0
                    signal rxd_to_the_uart_0 : IN STD_LOGIC;
                    signal txd_from_the_uart_0 : OUT STD_LOGIC;
						  signal out_port_from_the_note_0 : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
						  signal out_port_from_the_note_1 : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
						  signal out_port_from_the_note_2 : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
						  signal out_port_from_the_note_3 : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
						  signal out_port_from_the_note_4 : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
						  signal out_port_from_the_note_5 : OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
						  --signal out_port_from_the_note_6 : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
						  --signal out_port_from_the_note_7 : OUT STD_LOGIC_VECTOR(19 DOWNTO 0)

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
		dacData : out std_logic;
		LEDG : out std_logic_vector(7 downto 0);
		LEDR : out std_logic_vector(17 downto 0);
		note_0 : in std_logic_vector(19 downto 0);
		note_1 : in std_logic_vector(19 downto 0);
		note_2 : in std_logic_vector(19 downto 0);
		note_3 : in std_logic_vector(19 downto 0);
		note_4 : in std_logic_vector(19 downto 0);
		note_5 : in std_logic_vector(19 downto 0)
		--note_6 : in std_logic_vector(19 downto 0);
		--note_7 : in std_logic_vector(19 downto 0)
	);
	end component;
	
	signal i2cClock,audioClock : std_logic := '0';
	signal temp : std_logic;
	signal stateOut : integer range 0 to 7;
	signal resetAdcDac : std_logic := '0';
	
	signal bitClock,dacLRC,dacDat : std_logic := '0';

        signal BA : STD_LOGIC_VECTOR (1 downto 0);
        signal DQM : STD_LOGIC_VECTOR (1 downto 0);

        signal pll_c1:STD_LOGIC;
        signal pll_locked:STD_LOGIC;
        signal pll_phase: STD_LOGIC;
		  signal note0 : STD_LOGIC_VECTOR(19 downto 0);
		  signal note1 : STD_LOGIC_VECTOR(19 downto 0);
		  signal note2 : STD_LOGIC_VECTOR(19 downto 0);
		  signal note3 : STD_LOGIC_VECTOR(19 downto 0);
		  signal note4 : STD_LOGIC_VECTOR(19 downto 0);
		  signal note5 : STD_LOGIC_VECTOR(19 downto 0);
		  --signal note6 : STD_LOGIC_VECTOR(19 downto 0);
		  --signal note7 : STD_LOGIC_VECTOR(19 downto 0);
	
begin

	--Tell the LCD screen to power up
        LCD_ON <= '1';

        DRAM_BA_1 <= BA(1);
        DRAM_BA_0 <= BA(0);
        DRAM_UDQM <= DQM(1);
        DRAM_LDQM <= DQM(0);
	
	mainSystem: SOPC_File port map
	(
		DRAM_CLK,
		pll_c1, 
		CLOCK_50,
		KEY(0),
		
		pll_locked,
		pll_phase,
		
		LCD_EN, 
		LCD_RS, 
		LCD_RW, 
		LCD_DATA,
		
		DRAM_ADDR, 
		BA, 
		DRAM_CAS_N, 
		DRAM_CKE,
		DRAM_CS_N,
		DRAM_DQ,
		DQM,
		DRAM_RAS_N,
		DRAM_WE_N,	
		
		UART_RXD, 
		UART_TXD, 
		
	  note0,
	  note1,
	  note2,
	  note3,
	  note4,
	  note5
	  --note6,
	  --note7
	);
						  
						  
	
	audioCodecController : audio_codec_controller port map (SW(0),CLOCK_50,i2cClock,I2C_SDAT,stateOut);
	
	-- we only start the audio controller below long (40 ms) after we reset the system
	-- the reason is that transmitting all the i2c data takes at least 19 ms (20 KHz clock)
	adcDacControllerStartDelay : delayCounter port map (SW(0),CLOCK_50,resetAdcDac);

	-- we will use a PLL to generate the necessary 18.432 MHz Audio Control clock
	audioPllClockGen : audioPLL port map (not resetAdcDac,CLOCK_27,audioClock);
	
	adcDacController : adc_dac_controller port map 
	(
		--Clk
		CLOCK_50,

		--Buttons/Switches
		Key(3),
		SW(17),
		Key(2),
		SW(16),
		Key(1),

		--Signals
		resetAdcDac,
		audioClock,
		bitClock,
		AUD_DACLRCK,
		dacDat,

		--LEDs
		LEDG,
		LEDR,

		note0,
		note1,
		note2,
		note3,
		note4,
		note5
		--note6,
		--note7
	);
	
	--Send these values to the pins for the codec
	I2C_SCLK <= i2cClock;
	AUD_BCLK <= bitClock;
	AUD_XCK <= audioClock;	
	
	--Output assignments
	AUD_DACDAT <= dacDat;
	
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

