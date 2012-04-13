-- Original Author : Simon Doherty
-- Additional Authors : Eric Lunty, Kyle Brooks, Peter Roland


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity waveform_gen is

port (

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
end entity;


architecture rtl of waveform_gen is


component sin_lut

port 
	(
	clk      : in  std_logic;
	en       : in  std_logic;
	
	--Address inputs
	addr1     : in  std_logic_vector(11 downto 0);
	addr2     : in  std_logic_vector(11 downto 0);
	addr3     : in  std_logic_vector(11 downto 0);
	addr4     : in  std_logic_vector(11 downto 0);
	addr5     : in  std_logic_vector(11 downto 0);
	addr6     : in  std_logic_vector(11 downto 0);
	
	--Sine outputs
	sin_out1  : out std_logic_vector(11 downto 0);
	sin_out2  : out std_logic_vector(11 downto 0);
	sin_out3  : out std_logic_vector(11 downto 0);
	sin_out4  : out std_logic_vector(11 downto 0);
	sin_out5  : out std_logic_vector(11 downto 0);
	sin_out6  : out std_logic_vector(11 downto 0)
	);
end component;


signal  phase_acc1     : std_logic_vector(31 downto 0);
signal  phase_acc2     : std_logic_vector(31 downto 0);
signal  phase_acc3     : std_logic_vector(31 downto 0);
signal  phase_acc4     : std_logic_vector(31 downto 0);
signal  phase_acc5     : std_logic_vector(31 downto 0);
signal  phase_acc6     : std_logic_vector(31 downto 0);

signal  lut_addr1      : std_logic_vector(11 downto 0);
signal  lut_addr2      : std_logic_vector(11 downto 0);
signal  lut_addr3      : std_logic_vector(11 downto 0);
signal  lut_addr4      : std_logic_vector(11 downto 0);
signal  lut_addr5      : std_logic_vector(11 downto 0);
signal  lut_addr6      : std_logic_vector(11 downto 0);

signal  lut_addr_reg1  : std_logic_vector(11 downto 0);
signal  lut_addr_reg2  : std_logic_vector(11 downto 0);
signal  lut_addr_reg3  : std_logic_vector(11 downto 0);
signal  lut_addr_reg4  : std_logic_vector(11 downto 0);
signal  lut_addr_reg5  : std_logic_vector(11 downto 0);
signal  lut_addr_reg6  : std_logic_vector(11 downto 0);

begin


--------------------------------------------------------------------------
-- Phase accumulator increments by 'phase_inc' every clock cycle        --
-- Output frequency determined by formula: Phase_inc = (Fout/Fclk)*2^32 --
-- E.g. Fout = 36MHz, Fclk = 100MHz,  Phase_inc = 36*2^32/100           --
-- Frequency resolution is 100MHz/2^32 = 0.00233Hz                      --
--------------------------------------------------------------------------

phase_acc_reg: process(clk, reset)
begin
  if reset = '0' then
    	phase_acc1 <= (others => '0');
	phase_acc2 <= (others => '0');
	phase_acc3 <= (others => '0');
	phase_acc4 <= (others => '0');
	phase_acc5 <= (others => '0');
	phase_acc6 <= (others => '0');

  elsif clk'event and clk = '1' then
    if en = '1' then
      	phase_acc1 <= unsigned(phase_acc1) + unsigned(phase_inc1); 
	phase_acc2 <= unsigned(phase_acc2) + unsigned(phase_inc2); 
	phase_acc3 <= unsigned(phase_acc3) + unsigned(phase_inc3); 
	phase_acc4 <= unsigned(phase_acc4) + unsigned(phase_inc4); 
	phase_acc5 <= unsigned(phase_acc5) + unsigned(phase_inc5); 
	phase_acc6 <= unsigned(phase_acc6) + unsigned(phase_inc6);  
    end if;
  end if;
end process phase_acc_reg;

---------------------------------------------------------------------
-- use top 12-bits of phase accumulator to address the SIN LUT --
---------------------------------------------------------------------

lut_addr1 <= phase_acc1(31 downto 20);
lut_addr2 <= phase_acc2(31 downto 20);
lut_addr3 <= phase_acc3(31 downto 20);
lut_addr4 <= phase_acc4(31 downto 20);
lut_addr5 <= phase_acc5(31 downto 20);
lut_addr6 <= phase_acc6(31 downto 20);

----------------------------------------------------------------------
-- SIN LUT is 4096 by 12-bit ROM                                    --
-- 12-bit output allows sin amplitudes between 2047 and -2047       --
-- (-2048 not used to keep the output signal perfectly symmetrical) --
-- Phase resolution is 2Pi/4096 = 0.088 degrees                     --
----------------------------------------------------------------------

lut: sin_lut

  port map
  (
    	clk       => clk,
    	en        => en,
	 
    	addr1      => lut_addr1,
	addr2      => lut_addr2,
	addr3      => lut_addr3,
	addr4      => lut_addr4,
	addr5      => lut_addr5,
	addr6      => lut_addr6,
	 
	sin_out1   => sin_out1,
	sin_out2   => sin_out2,
	sin_out3   => sin_out3,
	sin_out4   => sin_out4,
	sin_out5   => sin_out5,
	sin_out6   => sin_out6
  );

---------------------------------
-- Hide the latency of the LUT --
---------------------------------

delay_regs: process(clk)
begin
  if clk'event and clk = '1' then
    if en = '1' then
      	lut_addr_reg1 <= lut_addr1;
	lut_addr_reg2 <= lut_addr2;
	lut_addr_reg3 <= lut_addr3;
	lut_addr_reg4 <= lut_addr4;
	lut_addr_reg5 <= lut_addr5;
	lut_addr_reg6 <= lut_addr6;
    end if;
  end if;
end process delay_regs;

---------------------------------------------
-- Square output is msb of the accumulator --
---------------------------------------------

squ_out1 <= "001111111111" when lut_addr_reg1(11) = '1' else "110000000000";
squ_out2 <= "011111111111" when lut_addr_reg2(11) = '1' else "110000000000";
squ_out3 <= "011111111111" when lut_addr_reg3(11) = '1' else "110000000000";
squ_out4 <= "011111111111" when lut_addr_reg4(11) = '1' else "110000000000";
squ_out5 <= "011111111111" when lut_addr_reg5(11) = '1' else "110000000000";
squ_out6 <= "011111111111" when lut_addr_reg6(11) = '1' else "110000000000";

-------------------------------------------------------
-- Sawtooth output is top 12-bits of the accumulator --
-------------------------------------------------------

saw_out1 <= lut_addr_reg1(11 downto 0);
saw_out2 <= lut_addr_reg2(11 downto 0);
saw_out3 <= lut_addr_reg3(11 downto 0);
saw_out4 <= lut_addr_reg4(11 downto 0);
saw_out5 <= lut_addr_reg5(11 downto 0);
saw_out6 <= lut_addr_reg6(11 downto 0);


end rtl;
