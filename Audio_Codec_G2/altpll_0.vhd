--altpll_avalon avalon_use_separate_sysclk="NO" CBX_SINGLE_OUTPUT_FILE="ON" CBX_SUBMODULE_USED_PORTS="altpll:areset,clk,locked,inclk" address c0 c1 clk locked phasedone read readdata reset write writedata clk0_divide_by=1 clk0_duty_cycle=50 clk0_multiply_by=1 clk0_phase_shift="-167" clk1_divide_by=1 clk1_duty_cycle=50 clk1_multiply_by=1 clk1_phase_shift="0" compensate_clock="CLK0" device_family="CYCLONEII" inclk0_input_frequency=20000 intended_device_family="Cyclone II" operation_mode="normal" port_clk0="PORT_USED" port_clk1="PORT_USED" port_clk2="PORT_UNUSED" port_clk3="PORT_UNUSED" port_clk4="PORT_UNUSED" port_clk5="PORT_UNUSED" port_extclk0="PORT_UNUSED" port_extclk1="PORT_UNUSED" port_extclk2="PORT_UNUSED" port_extclk3="PORT_UNUSED" port_inclk1="PORT_UNUSED" port_phasecounterselect="PORT_UNUSED" port_phasedone="PORT_UNUSED" port_scandata="PORT_UNUSED" port_scandataout="PORT_UNUSED"
--VERSION_BEGIN 10.1SP1 cbx_altclkbuf 2011:01:19:21:23:40:SJ cbx_altiobuf_bidir 2011:01:19:21:23:41:SJ cbx_altiobuf_in 2011:01:19:21:23:41:SJ cbx_altiobuf_out 2011:01:19:21:23:41:SJ cbx_altpll 2011:01:19:21:23:41:SJ cbx_altpll_avalon 2011:01:19:21:23:41:SJ cbx_cycloneii 2011:01:19:21:23:41:SJ cbx_lpm_add_sub 2011:01:19:21:23:41:SJ cbx_lpm_compare 2011:01:19:21:23:41:SJ cbx_lpm_decode 2011:01:19:21:23:41:SJ cbx_lpm_mux 2011:01:19:21:23:41:SJ cbx_lpm_shiftreg 2011:01:19:21:23:41:SJ cbx_mgl 2011:01:19:21:24:50:SJ cbx_stratix 2011:01:19:21:23:41:SJ cbx_stratixii 2011:01:19:21:23:41:SJ cbx_stratixiii 2011:01:19:21:23:41:SJ cbx_stratixv 2011:01:19:21:23:41:SJ cbx_util_mgl 2011:01:19:21:23:41:SJ  VERSION_END


-- Copyright (C) 1991-2011 Altera Corporation
--  Your use of Altera Corporation's design tools, logic functions 
--  and other software and tools, and its AMPP partner logic 
--  functions, and any output files from any of the foregoing 
--  (including device programming or simulation files), and any 
--  associated documentation or information are expressly subject 
--  to the terms and conditions of the Altera Program License 
--  Subscription Agreement, Altera MegaCore Function License 
--  Agreement, or other applicable license agreement, including, 
--  without limitation, that your use is for the sole purpose of 
--  programming logic devices manufactured by Altera and sold by 
--  Altera or its authorized distributors.  Please refer to the 
--  applicable agreement for further details.




--altera_std_synchronizer CBX_SINGLE_OUTPUT_FILE="ON" clk din dout reset_n
--VERSION_BEGIN 10.1SP1 cbx_mgl 2011:01:19:21:24:50:SJ cbx_stratixii 2011:01:19:21:23:41:SJ cbx_util_mgl 2011:01:19:21:23:41:SJ  VERSION_END


--dffpipe CBX_SINGLE_OUTPUT_FILE="ON" DELAY=3 WIDTH=1 clock clrn d q ALTERA_INTERNAL_OPTIONS=AUTO_SHIFT_REGISTER_RECOGNITION=OFF
--VERSION_BEGIN 10.1SP1 cbx_mgl 2011:01:19:21:24:50:SJ cbx_stratixii 2011:01:19:21:23:41:SJ cbx_util_mgl 2011:01:19:21:23:41:SJ  VERSION_END

--synthesis_resources = reg 3 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  altpll_0_dffpipe_l2c IS 
	 PORT 
	 ( 
		 clock	:	IN  STD_LOGIC := '0';
		 clrn	:	IN  STD_LOGIC := '1';
		 d	:	IN  STD_LOGIC_VECTOR (0 DOWNTO 0);
		 q	:	OUT  STD_LOGIC_VECTOR (0 DOWNTO 0)
	 ); 
 END altpll_0_dffpipe_l2c;

 ARCHITECTURE RTL OF altpll_0_dffpipe_l2c IS

	 ATTRIBUTE synthesis_clearbox : natural;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS 1;
	 ATTRIBUTE ALTERA_ATTRIBUTE : string;
	 ATTRIBUTE ALTERA_ATTRIBUTE OF RTL : ARCHITECTURE IS "AUTO_SHIFT_REGISTER_RECOGNITION=OFF";

	 SIGNAL	 dffe4a	:	STD_LOGIC_VECTOR(0 DOWNTO 0)
	 -- synopsys translate_off
	  := (OTHERS => '0')
	 -- synopsys translate_on
	 ;
	 SIGNAL	 dffe5a	:	STD_LOGIC_VECTOR(0 DOWNTO 0)
	 -- synopsys translate_off
	  := (OTHERS => '0')
	 -- synopsys translate_on
	 ;
	 SIGNAL	 dffe6a	:	STD_LOGIC_VECTOR(0 DOWNTO 0)
	 -- synopsys translate_off
	  := (OTHERS => '0')
	 -- synopsys translate_on
	 ;
	 SIGNAL  wire_dffpipe3_w_lg_sclr31w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  ena	:	STD_LOGIC;
	 SIGNAL  prn	:	STD_LOGIC;
	 SIGNAL  sclr	:	STD_LOGIC;
 BEGIN

	wire_dffpipe3_w_lg_sclr31w(0) <= NOT sclr;
	ena <= '1';
	prn <= '1';
	q <= dffe6a;
	sclr <= '0';
	PROCESS (clock, prn, clrn)
	BEGIN
		IF (prn = '0') THEN dffe4a <= (OTHERS => '1');
		ELSIF (clrn = '0') THEN dffe4a <= (OTHERS => '0');
		ELSIF (clock = '1' AND clock'event) THEN 
			IF (ena = '1') THEN dffe4a(0) <= (d(0) AND wire_dffpipe3_w_lg_sclr31w(0));
			END IF;
		END IF;
	END PROCESS;
	PROCESS (clock, prn, clrn)
	BEGIN
		IF (prn = '0') THEN dffe5a <= (OTHERS => '1');
		ELSIF (clrn = '0') THEN dffe5a <= (OTHERS => '0');
		ELSIF (clock = '1' AND clock'event) THEN 
			IF (ena = '1') THEN dffe5a(0) <= (dffe4a(0) AND wire_dffpipe3_w_lg_sclr31w(0));
			END IF;
		END IF;
	END PROCESS;
	PROCESS (clock, prn, clrn)
	BEGIN
		IF (prn = '0') THEN dffe6a <= (OTHERS => '1');
		ELSIF (clrn = '0') THEN dffe6a <= (OTHERS => '0');
		ELSIF (clock = '1' AND clock'event) THEN 
			IF (ena = '1') THEN dffe6a(0) <= (dffe5a(0) AND wire_dffpipe3_w_lg_sclr31w(0));
			END IF;
		END IF;
	END PROCESS;

 END RTL; --altpll_0_dffpipe_l2c

--synthesis_resources = reg 3 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  altpll_0_stdsync_sv6 IS 
	 PORT 
	 ( 
		 clk	:	IN  STD_LOGIC;
		 din	:	IN  STD_LOGIC;
		 dout	:	OUT  STD_LOGIC;
		 reset_n	:	IN  STD_LOGIC
	 ); 
 END altpll_0_stdsync_sv6;

 ARCHITECTURE RTL OF altpll_0_stdsync_sv6 IS

	 ATTRIBUTE synthesis_clearbox : natural;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS 1;
	 SIGNAL  wire_dffpipe3_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 COMPONENT  altpll_0_dffpipe_l2c
	 PORT
	 ( 
		clock	:	IN  STD_LOGIC := '0';
		clrn	:	IN  STD_LOGIC := '1';
		d	:	IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
		q	:	OUT  STD_LOGIC_VECTOR(0 DOWNTO 0)
	 ); 
	 END COMPONENT;
 BEGIN

	dout <= wire_dffpipe3_q(0);
	dffpipe3 :  altpll_0_dffpipe_l2c
	  PORT MAP ( 
		clock => clk,
		clrn => reset_n,
		d(0) => din,
		q => wire_dffpipe3_q
	  );

 END RTL; --altpll_0_stdsync_sv6


--altpll CBX_SINGLE_OUTPUT_FILE="ON" clk0_divide_by=1 clk0_duty_cycle=50 clk0_multiply_by=1 clk0_phase_shift="-167" clk1_divide_by=1 clk1_duty_cycle=50 clk1_multiply_by=1 clk1_phase_shift="0" compensate_clock="CLK0" device_family="CYCLONEII" inclk0_input_frequency=20000 intended_device_family="Cyclone II" operation_mode="normal" port_clk0="PORT_USED" port_clk1="PORT_USED" port_clk2="PORT_UNUSED" port_clk3="PORT_UNUSED" port_clk4="PORT_UNUSED" port_clk5="PORT_UNUSED" port_extclk0="PORT_UNUSED" port_extclk1="PORT_UNUSED" port_extclk2="PORT_UNUSED" port_extclk3="PORT_UNUSED" port_inclk1="PORT_UNUSED" port_phasecounterselect="PORT_UNUSED" port_phasedone="PORT_UNUSED" port_scandata="PORT_UNUSED" port_scandataout="PORT_UNUSED" areset clk inclk locked
--VERSION_BEGIN 10.1SP1 cbx_altclkbuf 2011:01:19:21:23:40:SJ cbx_altiobuf_bidir 2011:01:19:21:23:41:SJ cbx_altiobuf_in 2011:01:19:21:23:41:SJ cbx_altiobuf_out 2011:01:19:21:23:41:SJ cbx_altpll 2011:01:19:21:23:41:SJ cbx_cycloneii 2011:01:19:21:23:41:SJ cbx_lpm_add_sub 2011:01:19:21:23:41:SJ cbx_lpm_compare 2011:01:19:21:23:41:SJ cbx_lpm_decode 2011:01:19:21:23:41:SJ cbx_lpm_mux 2011:01:19:21:23:41:SJ cbx_mgl 2011:01:19:21:24:50:SJ cbx_stratix 2011:01:19:21:23:41:SJ cbx_stratixii 2011:01:19:21:23:41:SJ cbx_stratixiii 2011:01:19:21:23:41:SJ cbx_stratixv 2011:01:19:21:23:41:SJ cbx_util_mgl 2011:01:19:21:23:41:SJ  VERSION_END

 LIBRARY altera_mf;
 USE altera_mf.all;

--synthesis_resources = altpll 1 reg 5 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  altpll_0 IS 
	 PORT 
	 ( 
		 address	:	IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
		 c0	:	OUT  STD_LOGIC;
		 c1	:	OUT  STD_LOGIC;
		 clk	:	IN  STD_LOGIC;
		 locked	:	OUT  STD_LOGIC;
		 phasedone	:	OUT  STD_LOGIC;
		 read	:	IN  STD_LOGIC;
		 readdata	:	OUT  STD_LOGIC_VECTOR (31 DOWNTO 0);
		 reset	:	IN  STD_LOGIC;
		 write	:	IN  STD_LOGIC;
		 writedata	:	IN  STD_LOGIC_VECTOR (31 DOWNTO 0)
	 ); 
 END altpll_0;

 ARCHITECTURE RTL OF altpll_0 IS

	 ATTRIBUTE synthesis_clearbox : natural;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS 1;
	 ATTRIBUTE ALTERA_ATTRIBUTE : string;
	 SIGNAL  wire_stdsync2_dout	:	STD_LOGIC;
	 SIGNAL  wire_stdsync2_reset_n	:	STD_LOGIC;
	 SIGNAL  wire_sd1_clk	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_sd1_inclk	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_sd1_locked	:	STD_LOGIC;
	 SIGNAL	 pfdena_reg	:	STD_LOGIC
	 -- synopsys translate_off
	  := '1'
	 -- synopsys translate_on
	 ;
	 ATTRIBUTE ALTERA_ATTRIBUTE OF pfdena_reg : SIGNAL IS "POWER_UP_LEVEL=HIGH";

	 SIGNAL	 wire_pfdena_reg_ena	:	STD_LOGIC;
	 SIGNAL	 prev_reset	:	STD_LOGIC
	 -- synopsys translate_off
	  := '0'
	 -- synopsys translate_on
	 ;
	 SIGNAL  wire_w_lg_read16w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_read22w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_select_control14w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_select_control20w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_select_status19w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_select_status13w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_reset11w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_address_range1w2w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_select_control14w15w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_select_control20w21w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  w_locked :	STD_LOGIC;
	 SIGNAL  w_pfdena :	STD_LOGIC;
	 SIGNAL  w_phasedone :	STD_LOGIC;
	 SIGNAL  w_pll_areset_in :	STD_LOGIC;
	 SIGNAL  w_reset :	STD_LOGIC;
	 SIGNAL  w_select_control :	STD_LOGIC;
	 SIGNAL  w_select_status :	STD_LOGIC;
	 SIGNAL  wire_w_address_range1w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_address_range3w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 COMPONENT  altpll_0_stdsync_sv6
	 PORT
	 ( 
		clk	:	IN  STD_LOGIC;
		din	:	IN  STD_LOGIC;
		dout	:	OUT  STD_LOGIC;
		reset_n	:	IN  STD_LOGIC
	 ); 
	 END COMPONENT;
	 COMPONENT  altpll
	 GENERIC 
	 (
		clk0_divide_by	:	NATURAL := 1;
		clk0_duty_cycle	:	NATURAL := 50;
		clk0_multiply_by	:	NATURAL := 1;
		clk0_phase_shift	:	STRING := "0";
		clk1_divide_by	:	NATURAL := 1;
		clk1_duty_cycle	:	NATURAL := 50;
		clk1_multiply_by	:	NATURAL := 1;
		clk1_phase_shift	:	STRING := "0";
		compensate_clock	:	STRING := "CLK0";
		inclk0_input_frequency	:	NATURAL := 0;
		operation_mode	:	STRING := "normal";
		port_clk0	:	STRING := "PORT_CONNECTIVITY";
		port_clk1	:	STRING := "PORT_CONNECTIVITY";
		port_clk2	:	STRING := "PORT_CONNECTIVITY";
		port_clk3	:	STRING := "PORT_CONNECTIVITY";
		port_clk4	:	STRING := "PORT_CONNECTIVITY";
		port_clk5	:	STRING := "PORT_CONNECTIVITY";
		port_extclk0	:	STRING := "PORT_CONNECTIVITY";
		port_extclk1	:	STRING := "PORT_CONNECTIVITY";
		port_extclk2	:	STRING := "PORT_CONNECTIVITY";
		port_extclk3	:	STRING := "PORT_CONNECTIVITY";
		port_inclk1	:	STRING := "PORT_CONNECTIVITY";
		port_phasecounterselect	:	STRING := "PORT_CONNECTIVITY";
		port_phasedone	:	STRING := "PORT_CONNECTIVITY";
		port_scandata	:	STRING := "PORT_CONNECTIVITY";
		port_scandataout	:	STRING := "PORT_CONNECTIVITY";
		INTENDED_DEVICE_FAMILY	:	STRING := "Cyclone II"
	 );
	 PORT
	 ( 
		areset	:	IN  STD_LOGIC := '0';
		clk	:	OUT  STD_LOGIC_VECTOR(5 DOWNTO 0);
		inclk	:	IN  STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
		locked	:	OUT  STD_LOGIC
	 ); 
	 END COMPONENT;
 BEGIN

	wire_w_lg_read16w(0) <= read AND wire_w_lg_w_lg_w_select_control14w15w(0);
	wire_w_lg_read22w(0) <= read AND wire_w_lg_w_lg_w_select_control20w21w(0);
	wire_w_lg_w_select_control14w(0) <= w_select_control AND w_pfdena;
	wire_w_lg_w_select_control20w(0) <= w_select_control AND w_pll_areset_in;
	wire_w_lg_w_select_status19w(0) <= w_select_status AND w_locked;
	wire_w_lg_w_select_status13w(0) <= w_select_status AND w_phasedone;
	wire_w_lg_reset11w(0) <= NOT reset;
	wire_w_lg_w_address_range1w2w(0) <= NOT wire_w_address_range1w(0);
	wire_w_lg_w_lg_w_select_control14w15w(0) <= wire_w_lg_w_select_control14w(0) OR wire_w_lg_w_select_status13w(0);
	wire_w_lg_w_lg_w_select_control20w21w(0) <= wire_w_lg_w_select_control20w(0) OR wire_w_lg_w_select_status19w(0);
	c0 <= wire_sd1_clk(0);
	c1 <= wire_sd1_clk(1);
	locked <= wire_sd1_locked;
	phasedone <= '0';
	readdata <= ( "000000000000000000000000000000" & wire_w_lg_read16w & wire_w_lg_read22w);
	w_locked <= wire_stdsync2_dout;
	w_pfdena <= pfdena_reg;
	w_phasedone <= '1';
	w_pll_areset_in <= prev_reset;
	w_reset <= ((write AND w_select_control) AND writedata(0));
	w_select_control <= ((NOT address(1)) AND address(0));
	w_select_status <= ((NOT address(1)) AND wire_w_lg_w_address_range1w2w(0));
	wire_w_address_range1w(0) <= address(0);
	wire_w_address_range3w(0) <= address(1);
	wire_stdsync2_reset_n <= wire_w_lg_reset11w(0);
	stdsync2 :  altpll_0_stdsync_sv6
	  PORT MAP ( 
		clk => clk,
		din => wire_sd1_locked,
		dout => wire_stdsync2_dout,
		reset_n => wire_stdsync2_reset_n
	  );
	wire_sd1_inclk <= ( "0" & clk);
	sd1 :  altpll
	  GENERIC MAP (
		clk0_divide_by => 1,
		clk0_duty_cycle => 50,
		clk0_multiply_by => 1,
		clk0_phase_shift => "-167",
		clk1_divide_by => 1,
		clk1_duty_cycle => 50,
		clk1_multiply_by => 1,
		clk1_phase_shift => "0",
		compensate_clock => "CLK0",
		inclk0_input_frequency => 20000,
		operation_mode => "normal",
		port_clk0 => "PORT_USED",
		port_clk1 => "PORT_USED",
		port_clk2 => "PORT_UNUSED",
		port_clk3 => "PORT_UNUSED",
		port_clk4 => "PORT_UNUSED",
		port_clk5 => "PORT_UNUSED",
		port_extclk0 => "PORT_UNUSED",
		port_extclk1 => "PORT_UNUSED",
		port_extclk2 => "PORT_UNUSED",
		port_extclk3 => "PORT_UNUSED",
		port_inclk1 => "PORT_UNUSED",
		port_phasecounterselect => "PORT_UNUSED",
		port_phasedone => "PORT_UNUSED",
		port_scandata => "PORT_UNUSED",
		port_scandataout => "PORT_UNUSED",
		INTENDED_DEVICE_FAMILY => "Cyclone II"
	  )
	  PORT MAP ( 
		areset => w_pll_areset_in,
		clk => wire_sd1_clk,
		inclk => wire_sd1_inclk,
		locked => wire_sd1_locked
	  );
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN pfdena_reg <= '1';
		ELSIF (clk = '1' AND clk'event) THEN 
			IF (wire_pfdena_reg_ena = '1') THEN pfdena_reg <= writedata(1);
			END IF;
		END IF;
	END PROCESS;
	wire_pfdena_reg_ena <= (write AND w_select_control);
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN prev_reset <= '0';
		ELSIF (clk = '1' AND clk'event) THEN prev_reset <= w_reset;
		END IF;
	END PROCESS;

 END RTL; --altpll_0
--VALID FILE
