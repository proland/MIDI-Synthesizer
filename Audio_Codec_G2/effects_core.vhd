-----------------------------------------------------------
--  Ver  :| Original Author   		:| Additional Author :| 
--  V1.0 :| Simon Doherty			   :| Eric Lunty        :| 
-----------------------------------------------------------
--	  Changed it to output up to 6 waveforms              :|
-----------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity effects_core is

port (
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
end entity;


architecture rtl of effects_core is


component sin_lut_effect

port 
	(
	clk      : in  std_logic;
	en       : in  std_logic;
	
	--Address inputs
	addr     : in  std_logic_vector(11 downto 0);
	
	--Sine outputs
	sin_out  : out std_logic_vector(11 downto 0)
	);
end component;


signal  phase_acc     : std_logic_vector(31 downto 0);
signal  lut_addr      : std_logic_vector(11 downto 0);
signal  lut_addr_reg  : std_logic_vector(11 downto 0);

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
    	phase_acc <= (others => '0');

  elsif clk'event and clk = '1' then
    if en = '1' then
      	phase_acc <= unsigned(phase_acc) + unsigned(phase_inc);  
    end if;
  end if;
end process phase_acc_reg;

---------------------------------------------------------------------
-- use top 12-bits of phase accumulator to address the SIN LUT --
---------------------------------------------------------------------

lut_addr <= phase_acc(31 downto 20);

----------------------------------------------------------------------
-- SIN LUT is 4096 by 12-bit ROM                                    --
-- 12-bit output allows sin amplitudes between 2047 and -2047       --
-- (-2048 not used to keep the output signal perfectly symmetrical) --
-- Phase resolution is 2Pi/4096 = 0.088 degrees                     --
----------------------------------------------------------------------

lut: sin_lut_effect

  port map
  (
    	clk       => clk,
    	en        => en, 
    	addr      => lut_addr,
		sin_out   => wave_out
  );

---------------------------------
-- Hide the latency of the LUT --
---------------------------------

delay_regs: process(clk)
begin
  if clk'event and clk = '1' then
    if en = '1' then
      	lut_addr_reg <= lut_addr;
    end if;
  end if;
end process delay_regs;

end rtl;