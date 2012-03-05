-----------------------------------------------------
--  Ver  :| Original Author   :| Additional Author :| 
--  V1.0 :| Joe Yang          :| Eric Lunty        :| 
-----------------------------------------------------
--	Translated code to VHDL, + minor tweaks    :|
-----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c_controller is port
(
	clock50 : in std_logic;
	i2c_sclk : out std_logic;
	i2c_sdat : inout std_logic;
	i2c_data : in std_logic_vector(23 downto 0); 
	start : in std_logic;
	stop : out std_logic;
	ack : out std_logic;
	rst : in std_logic
);
end i2c_controller;

architecture behavioral of i2c_controller is
	
	signal sd_counter : integer;
	signal sd0 : std_logic;
	signal sd : std_logic_vector(23 downto 0);
	signal stop_out : std_logic;
	signal sclk : std_logic;
	signal ack1,ack2,ack3 : std_logic;
	signal sdat : std_logic;

begin

	sdat <= i2c_sdat;
	--i2c Counter
	process (clock50,rst)
	begin
		if rst='0' then
			sd_counter<=63;
		elsif rising_edge(clock50) then
			if start='0' then
				sd_counter<=0;
			else
				if sd_counter<=63 then
					sd_counter<=sd_counter+1;
				end if;
			end if;
		end if;
	end process;

	--i2c Controller
	process (clock50,rst)
	begin
	
	--WARNING: ACKs are currently disabled, big bug if you turn them on
	stop <= stop_out;
	ack <= '0';
	--ack <= ack1 or ack2 or ack3;
	
	if sd_counter >= 4 then
		if sd_counter <= 30 then
			i2c_sclk <= sclk or (not clock50);
		else
			i2c_sclk <= sclk or '0';
		end if;
	else
		i2c_sclk <= sclk or '0';
	end if;
	
	if sd0='1' then
		i2c_sdat <= 'Z';
	else
		i2c_sdat <= '0';
	end if;
 
		if rst='0' then
			sclk<='1';
			sd0<='1';
			ack1<='0';
			ack2<='0';
			ack3<='0';
			stop_out<='1';
		elsif rising_edge(clock50) then
			case sd_counter IS
    				when 0=> 
				ack1<='0';
				ack2<='0';
				ack3<='0';
				stop_out<='0';
				sd0<='1';
				sclk<='1';
    				when 1=>
				sd<=i2c_data;
				sd0<='0';
    				when 2=> 
				sclk<='0';
    				
				--Slave Address
				when 3=> sd0<=sd(23);
    				when 4=> sd0<=sd(22);
    				when 5=> sd0<=sd(21);
    				when 6=> sd0<=sd(20);
    				when 7=> sd0<=sd(19);
    				when 8=> sd0<=sd(18);
    				when 9=> sd0<=sd(17);
    				when 10=> sd0<=sd(16);
    				when 11=> sd0<='1';

				--Sub Address
    				when 12=> 
				sd0<=sd(15);
				ack1<=sdat;
    				when 13=> sd0<=sd(14);
    				when 14=> sd0<=sd(13);
    				when 15=> sd0<=sd(12);
    				when 16=> sd0<=sd(11);
    				when 17=> sd0<=sd(10);
    				when 18=> sd0<=sd(9);
    				when 19=> sd0<=sd(8);
    				when 20=> sd0<='1';
    				
				--Data
				when 21=> 
				sd0<=sd(7);
				ack2<=sdat;
    				when 22=> sd0<=sd(6);
    				when 23=> sd0<=sd(5);
    				when 24=> sd0<=sd(4);
    				when 25=> sd0<=sd(3);
    				when 26=> sd0<=sd(2);
    				when 27=> sd0<=sd(1);
    				when 28=> sd0<=sd(0);
    				when 29=> sd0<='1';

				--Stop Sending
    				when 30=> 
				sd0<='0';
				sclk<='0';
				ack3<=sdat;
    				when 31=> sclk<='1';		
				when 32=> 
				sd0<='1';
				stop_out<='1';
				
				--Needed to compile, will never actually occur
				when others=>
				sd0<='1';
			end case;
		end if;
	end process;
end behavioral;
