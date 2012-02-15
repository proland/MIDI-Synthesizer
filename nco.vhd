library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity nco is
  port (
    clk : in std_logic; -- System Clock
    rst : in std_logic; -- Reset
    en : in std_logic; --Enable
    wave_select : in std_logic_vector(1 downto 0);  --Select Sine, Square, Triangle, Sawtooth
    nco_inc : in std_logic_vector(31 downto 0); --The Freq Increment
    wave_out : out std_logic_vector(11 downto 0) --The Output Waveform
  );
end nco;

architecture arch of nco is
  component lut
    port (
      clk : in std_logic; --Clock
      addr : in std_logic_vector(11 downto 0); --Address in LUT
      waveform : out std_logic_vector(11 downto 0) --Value of Waveform
    );
  end component;

  signal accumulator : std_logic_vector(31 downto 0);
  signal lut_address : std_logic_vector(11 downto 0);
  signal lut_address_reg : std_logic_vector(11 downto 0);
  
  signal sin_wave : std_logic_vector(11 downto 0);
  signal square_wave : std_logic_vector(11 downto 0);
  signal tri_wave : std_logic_vector(11 downto 0);
  signal saw_wave : std_logic_vector(11 downto 0);
  
begin  -- arch
  lut_address <= accumulator(31 downto 20);  
  inc: process(clk, rst)
  begin
    if rst = '0' then
      accumulator <= x"00000000";
    elsif rising_edge(clk) then
      if en = '1' then
        accumulator = unsigned(accumulator) + unsigned(nco_inc);
      end if;
    end if;
  end process;

  with wave_select select
    wave_out <= sin_wave when '00',
                square_wave when '01',
                tri_wave when '10',
                saw_wave when '11';
    
  sin: sin_lut port map(
    clk => clk,
    addr => lut_address,
    waveform => sin_wave
  );

  delay_regs: process(clk)
  begin
    if clk'event and clk = '1' then
      if en = '1' then
        lut_addr_reg <= lut_addr;
      end if;
    end if;
  end process delay_regs;
  
  square_wave <= "011111111111" when lut_address(11) = '1' else "100000000000";

  tri_wave <= lut_address;
  saw_wave <= lut_address;
  
end arch;
