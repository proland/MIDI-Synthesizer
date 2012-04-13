-- DE1 ADC DAC interface
-- delay counter
-- A simple delay module to start the ADC/DAC data transfers 40 ms after SW(0) is pushed up
-- References:  
-- 1.  Digital Differential Analyzer: http://courses.cit.cornell.edu/ece576/DDA/index.htm
-- Bharathwaj Muthuswamy
-- EECS 3921 Fall 2010
-- muthuswamy@msoe.edu

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delayCounter is port (
		reset : in std_logic;
		clock : in std_logic;
		resetAdc : out std_logic);
end entity;

architecture delayCounterInside of delayCounter is
	signal delayCounterInternalCount : integer; -- 32-bit counter
begin
	process(clock,reset)
	begin
		if reset = '0' then
			delayCounterInternalCount <= 0;
			resetAdc <= '0'; -- reset ADC is active low
		else
			if clock'event and clock = '1' then
				if delayCounterInternalCount >= 2000000 then
					resetAdc <= '1';
					delayCounterInternalCount <= 2000000; -- stop counter
				else
					resetAdc <= '0';
					delayCounterInternalCount <= delayCounterInternalCount + 1;
				end if;
			end if;
		end if;
	end process;
	
end delayCounterInside;
	