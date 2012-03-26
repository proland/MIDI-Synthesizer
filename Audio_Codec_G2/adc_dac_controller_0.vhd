-- adc_dac_controller_0.vhd

-- This file was auto-generated as part of a SOPC Builder generate operation.
-- If you edit it your changes will probably be lost.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adc_dac_controller_0 is
	port (
		clk              : in  std_logic                     := '0';             -- clock.clk
		reset            : in  std_logic                     := '0'             -- reset.reset
--		avs_s0_writedata : in  std_logic_vector(15 downto 0) := (others => '0'); --    s0.writedata
--		avs_s0_readdata  : out std_logic_vector(15 downto 0);                    --      .readdata
--		avs_s0_address   : in  std_logic_vector(7 downto 0)  := (others => '0'); --      .address
--		avs_s0_read      : in  std_logic                     := '0';             --      .read
--		avs_s0_write     : in  std_logic                     := '0'              --      .write
	);
end entity adc_dac_controller_0;

architecture rtl of adc_dac_controller_0 is
	component adc_dac_controller is
		port (
			clk              : in  std_logic                     := 'X';             -- clk
			reset            : in  std_logic                     := 'X'             -- reset
--			avs_s0_writedata : in  std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
--			avs_s0_readdata  : out std_logic_vector(15 downto 0);                    -- readdata
--			avs_s0_address   : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- address
--			avs_s0_read      : in  std_logic                     := 'X';             -- read
--			avs_s0_write     : in  std_logic                     := 'X'              -- write
		);
	end component adc_dac_controller;

begin

	adc_dac_controller_0 : component adc_dac_controller
		port map (
			clk              => clk,              -- clock.clk
			reset            => reset            -- reset.reset
--			avs_s0_writedata => avs_s0_writedata, --    s0.writedata
--			avs_s0_readdata  => avs_s0_readdata,  --      .readdata
--			avs_s0_address   => avs_s0_address,   --      .address
--			avs_s0_read      => avs_s0_read,      --      .read
--			avs_s0_write     => avs_s0_write      --      .write
		);

end architecture rtl; -- of adc_dac_controller_0
