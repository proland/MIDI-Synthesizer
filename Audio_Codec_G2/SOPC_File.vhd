--megafunction wizard: %Altera SOPC Builder%
--GENERATION: STANDARD
--VERSION: WM1.0


--Legal Notice: (C)2012 Altera Corporation. All rights reserved.  Your
--use of Altera Corporation's design tools, logic functions and other
--software and tools, and its AMPP partner logic functions, and any
--output files any of the foregoing (including device programming or
--simulation files), and any associated documentation or information are
--expressly subject to the terms and conditions of the Altera Program
--License Subscription Agreement or other applicable license agreement,
--including, without limitation, that your use is for the sole purpose
--of programming logic devices manufactured by Altera and sold by Altera
--or its authorized distributors.  Please refer to the applicable
--agreement for further details.


-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity LEDG_s1_arbitrator is 
        port (
              -- inputs:
                 signal LEDG_s1_readdata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal LEDG_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal LEDG_s1_chipselect : OUT STD_LOGIC;
                 signal LEDG_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal LEDG_s1_reset_n : OUT STD_LOGIC;
                 signal LEDG_s1_write_n : OUT STD_LOGIC;
                 signal LEDG_s1_writedata : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal cpu_0_data_master_granted_LEDG_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_LEDG_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_LEDG_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_LEDG_s1 : OUT STD_LOGIC;
                 signal d1_LEDG_s1_end_xfer : OUT STD_LOGIC
              );
end entity LEDG_s1_arbitrator;


architecture europa of LEDG_s1_arbitrator is
                signal LEDG_s1_allgrants :  STD_LOGIC;
                signal LEDG_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal LEDG_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal LEDG_s1_any_continuerequest :  STD_LOGIC;
                signal LEDG_s1_arb_counter_enable :  STD_LOGIC;
                signal LEDG_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal LEDG_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal LEDG_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal LEDG_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal LEDG_s1_begins_xfer :  STD_LOGIC;
                signal LEDG_s1_end_xfer :  STD_LOGIC;
                signal LEDG_s1_firsttransfer :  STD_LOGIC;
                signal LEDG_s1_grant_vector :  STD_LOGIC;
                signal LEDG_s1_in_a_read_cycle :  STD_LOGIC;
                signal LEDG_s1_in_a_write_cycle :  STD_LOGIC;
                signal LEDG_s1_master_qreq_vector :  STD_LOGIC;
                signal LEDG_s1_non_bursting_master_requests :  STD_LOGIC;
                signal LEDG_s1_pretend_byte_enable :  STD_LOGIC;
                signal LEDG_s1_reg_firsttransfer :  STD_LOGIC;
                signal LEDG_s1_slavearbiterlockenable :  STD_LOGIC;
                signal LEDG_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal LEDG_s1_unreg_firsttransfer :  STD_LOGIC;
                signal LEDG_s1_waits_for_read :  STD_LOGIC;
                signal LEDG_s1_waits_for_write :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_LEDG_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_LEDG_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_LEDG_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_LEDG_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_LEDG_s1 :  STD_LOGIC;
                signal shifted_address_to_LEDG_s1_from_cpu_0_data_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal wait_for_LEDG_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT LEDG_s1_end_xfer;
    end if;

  end process;

  LEDG_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_LEDG_s1);
  --assign LEDG_s1_readdata_from_sa = LEDG_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  LEDG_s1_readdata_from_sa <= LEDG_s1_readdata;
  internal_cpu_0_data_master_requests_LEDG_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(24 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("1000000000101000001100000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --LEDG_s1_arb_share_counter set values, which is an e_mux
  LEDG_s1_arb_share_set_values <= std_logic_vector'("01");
  --LEDG_s1_non_bursting_master_requests mux, which is an e_mux
  LEDG_s1_non_bursting_master_requests <= internal_cpu_0_data_master_requests_LEDG_s1;
  --LEDG_s1_any_bursting_master_saved_grant mux, which is an e_mux
  LEDG_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --LEDG_s1_arb_share_counter_next_value assignment, which is an e_assign
  LEDG_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(LEDG_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (LEDG_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(LEDG_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (LEDG_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --LEDG_s1_allgrants all slave grants, which is an e_mux
  LEDG_s1_allgrants <= LEDG_s1_grant_vector;
  --LEDG_s1_end_xfer assignment, which is an e_assign
  LEDG_s1_end_xfer <= NOT ((LEDG_s1_waits_for_read OR LEDG_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_LEDG_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_LEDG_s1 <= LEDG_s1_end_xfer AND (((NOT LEDG_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --LEDG_s1_arb_share_counter arbitration counter enable, which is an e_assign
  LEDG_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_LEDG_s1 AND LEDG_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_LEDG_s1 AND NOT LEDG_s1_non_bursting_master_requests));
  --LEDG_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      LEDG_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(LEDG_s1_arb_counter_enable) = '1' then 
        LEDG_s1_arb_share_counter <= LEDG_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --LEDG_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      LEDG_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((LEDG_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_LEDG_s1)) OR ((end_xfer_arb_share_counter_term_LEDG_s1 AND NOT LEDG_s1_non_bursting_master_requests)))) = '1' then 
        LEDG_s1_slavearbiterlockenable <= or_reduce(LEDG_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master LEDG/s1 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= LEDG_s1_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --LEDG_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  LEDG_s1_slavearbiterlockenable2 <= or_reduce(LEDG_s1_arb_share_counter_next_value);
  --cpu_0/data_master LEDG/s1 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= LEDG_s1_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --LEDG_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  LEDG_s1_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_LEDG_s1 <= internal_cpu_0_data_master_requests_LEDG_s1 AND NOT (((NOT cpu_0_data_master_waitrequest) AND cpu_0_data_master_write));
  --LEDG_s1_writedata mux, which is an e_mux
  LEDG_s1_writedata <= cpu_0_data_master_writedata (7 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_0_data_master_granted_LEDG_s1 <= internal_cpu_0_data_master_qualified_request_LEDG_s1;
  --cpu_0/data_master saved-grant LEDG/s1, which is an e_assign
  cpu_0_data_master_saved_grant_LEDG_s1 <= internal_cpu_0_data_master_requests_LEDG_s1;
  --allow new arb cycle for LEDG/s1, which is an e_assign
  LEDG_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  LEDG_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  LEDG_s1_master_qreq_vector <= std_logic'('1');
  --LEDG_s1_reset_n assignment, which is an e_assign
  LEDG_s1_reset_n <= reset_n;
  LEDG_s1_chipselect <= internal_cpu_0_data_master_granted_LEDG_s1;
  --LEDG_s1_firsttransfer first transaction, which is an e_assign
  LEDG_s1_firsttransfer <= A_WE_StdLogic((std_logic'(LEDG_s1_begins_xfer) = '1'), LEDG_s1_unreg_firsttransfer, LEDG_s1_reg_firsttransfer);
  --LEDG_s1_unreg_firsttransfer first transaction, which is an e_assign
  LEDG_s1_unreg_firsttransfer <= NOT ((LEDG_s1_slavearbiterlockenable AND LEDG_s1_any_continuerequest));
  --LEDG_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      LEDG_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(LEDG_s1_begins_xfer) = '1' then 
        LEDG_s1_reg_firsttransfer <= LEDG_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --LEDG_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  LEDG_s1_beginbursttransfer_internal <= LEDG_s1_begins_xfer;
  --~LEDG_s1_write_n assignment, which is an e_mux
  LEDG_s1_write_n <= NOT ((((internal_cpu_0_data_master_granted_LEDG_s1 AND cpu_0_data_master_write)) AND LEDG_s1_pretend_byte_enable));
  shifted_address_to_LEDG_s1_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --LEDG_s1_address mux, which is an e_mux
  LEDG_s1_address <= A_EXT (A_SRL(shifted_address_to_LEDG_s1_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_LEDG_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_LEDG_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_LEDG_s1_end_xfer <= LEDG_s1_end_xfer;
    end if;

  end process;

  --LEDG_s1_waits_for_read in a cycle, which is an e_mux
  LEDG_s1_waits_for_read <= LEDG_s1_in_a_read_cycle AND LEDG_s1_begins_xfer;
  --LEDG_s1_in_a_read_cycle assignment, which is an e_assign
  LEDG_s1_in_a_read_cycle <= internal_cpu_0_data_master_granted_LEDG_s1 AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= LEDG_s1_in_a_read_cycle;
  --LEDG_s1_waits_for_write in a cycle, which is an e_mux
  LEDG_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(LEDG_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --LEDG_s1_in_a_write_cycle assignment, which is an e_assign
  LEDG_s1_in_a_write_cycle <= internal_cpu_0_data_master_granted_LEDG_s1 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= LEDG_s1_in_a_write_cycle;
  wait_for_LEDG_s1_counter <= std_logic'('0');
  --LEDG_s1_pretend_byte_enable byte enable port mux, which is an e_mux
  LEDG_s1_pretend_byte_enable <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_LEDG_s1)) = '1'), (std_logic_vector'("0000000000000000000000000000") & (cpu_0_data_master_byteenable)), -SIGNED(std_logic_vector'("00000000000000000000000000000001"))));
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_LEDG_s1 <= internal_cpu_0_data_master_granted_LEDG_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_LEDG_s1 <= internal_cpu_0_data_master_qualified_request_LEDG_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_LEDG_s1 <= internal_cpu_0_data_master_requests_LEDG_s1;
--synthesis translate_off
    --LEDG/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity LEDR_s1_arbitrator is 
        port (
              -- inputs:
                 signal LEDR_s1_readdata : IN STD_LOGIC_VECTOR (17 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal LEDR_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal LEDR_s1_chipselect : OUT STD_LOGIC;
                 signal LEDR_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                 signal LEDR_s1_reset_n : OUT STD_LOGIC;
                 signal LEDR_s1_write_n : OUT STD_LOGIC;
                 signal LEDR_s1_writedata : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                 signal cpu_0_data_master_granted_LEDR_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_LEDR_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_LEDR_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_LEDR_s1 : OUT STD_LOGIC;
                 signal d1_LEDR_s1_end_xfer : OUT STD_LOGIC
              );
end entity LEDR_s1_arbitrator;


architecture europa of LEDR_s1_arbitrator is
                signal LEDR_s1_allgrants :  STD_LOGIC;
                signal LEDR_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal LEDR_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal LEDR_s1_any_continuerequest :  STD_LOGIC;
                signal LEDR_s1_arb_counter_enable :  STD_LOGIC;
                signal LEDR_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal LEDR_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal LEDR_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal LEDR_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal LEDR_s1_begins_xfer :  STD_LOGIC;
                signal LEDR_s1_end_xfer :  STD_LOGIC;
                signal LEDR_s1_firsttransfer :  STD_LOGIC;
                signal LEDR_s1_grant_vector :  STD_LOGIC;
                signal LEDR_s1_in_a_read_cycle :  STD_LOGIC;
                signal LEDR_s1_in_a_write_cycle :  STD_LOGIC;
                signal LEDR_s1_master_qreq_vector :  STD_LOGIC;
                signal LEDR_s1_non_bursting_master_requests :  STD_LOGIC;
                signal LEDR_s1_reg_firsttransfer :  STD_LOGIC;
                signal LEDR_s1_slavearbiterlockenable :  STD_LOGIC;
                signal LEDR_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal LEDR_s1_unreg_firsttransfer :  STD_LOGIC;
                signal LEDR_s1_waits_for_read :  STD_LOGIC;
                signal LEDR_s1_waits_for_write :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_LEDR_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_LEDR_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_LEDR_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_LEDR_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_LEDR_s1 :  STD_LOGIC;
                signal shifted_address_to_LEDR_s1_from_cpu_0_data_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal wait_for_LEDR_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT LEDR_s1_end_xfer;
    end if;

  end process;

  LEDR_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_LEDR_s1);
  --assign LEDR_s1_readdata_from_sa = LEDR_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  LEDR_s1_readdata_from_sa <= LEDR_s1_readdata;
  internal_cpu_0_data_master_requests_LEDR_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(24 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("1000000000101000001110000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --LEDR_s1_arb_share_counter set values, which is an e_mux
  LEDR_s1_arb_share_set_values <= std_logic_vector'("01");
  --LEDR_s1_non_bursting_master_requests mux, which is an e_mux
  LEDR_s1_non_bursting_master_requests <= internal_cpu_0_data_master_requests_LEDR_s1;
  --LEDR_s1_any_bursting_master_saved_grant mux, which is an e_mux
  LEDR_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --LEDR_s1_arb_share_counter_next_value assignment, which is an e_assign
  LEDR_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(LEDR_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (LEDR_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(LEDR_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (LEDR_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --LEDR_s1_allgrants all slave grants, which is an e_mux
  LEDR_s1_allgrants <= LEDR_s1_grant_vector;
  --LEDR_s1_end_xfer assignment, which is an e_assign
  LEDR_s1_end_xfer <= NOT ((LEDR_s1_waits_for_read OR LEDR_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_LEDR_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_LEDR_s1 <= LEDR_s1_end_xfer AND (((NOT LEDR_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --LEDR_s1_arb_share_counter arbitration counter enable, which is an e_assign
  LEDR_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_LEDR_s1 AND LEDR_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_LEDR_s1 AND NOT LEDR_s1_non_bursting_master_requests));
  --LEDR_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      LEDR_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(LEDR_s1_arb_counter_enable) = '1' then 
        LEDR_s1_arb_share_counter <= LEDR_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --LEDR_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      LEDR_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((LEDR_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_LEDR_s1)) OR ((end_xfer_arb_share_counter_term_LEDR_s1 AND NOT LEDR_s1_non_bursting_master_requests)))) = '1' then 
        LEDR_s1_slavearbiterlockenable <= or_reduce(LEDR_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master LEDR/s1 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= LEDR_s1_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --LEDR_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  LEDR_s1_slavearbiterlockenable2 <= or_reduce(LEDR_s1_arb_share_counter_next_value);
  --cpu_0/data_master LEDR/s1 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= LEDR_s1_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --LEDR_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  LEDR_s1_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_LEDR_s1 <= internal_cpu_0_data_master_requests_LEDR_s1 AND NOT (((NOT cpu_0_data_master_waitrequest) AND cpu_0_data_master_write));
  --LEDR_s1_writedata mux, which is an e_mux
  LEDR_s1_writedata <= cpu_0_data_master_writedata (17 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_0_data_master_granted_LEDR_s1 <= internal_cpu_0_data_master_qualified_request_LEDR_s1;
  --cpu_0/data_master saved-grant LEDR/s1, which is an e_assign
  cpu_0_data_master_saved_grant_LEDR_s1 <= internal_cpu_0_data_master_requests_LEDR_s1;
  --allow new arb cycle for LEDR/s1, which is an e_assign
  LEDR_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  LEDR_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  LEDR_s1_master_qreq_vector <= std_logic'('1');
  --LEDR_s1_reset_n assignment, which is an e_assign
  LEDR_s1_reset_n <= reset_n;
  LEDR_s1_chipselect <= internal_cpu_0_data_master_granted_LEDR_s1;
  --LEDR_s1_firsttransfer first transaction, which is an e_assign
  LEDR_s1_firsttransfer <= A_WE_StdLogic((std_logic'(LEDR_s1_begins_xfer) = '1'), LEDR_s1_unreg_firsttransfer, LEDR_s1_reg_firsttransfer);
  --LEDR_s1_unreg_firsttransfer first transaction, which is an e_assign
  LEDR_s1_unreg_firsttransfer <= NOT ((LEDR_s1_slavearbiterlockenable AND LEDR_s1_any_continuerequest));
  --LEDR_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      LEDR_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(LEDR_s1_begins_xfer) = '1' then 
        LEDR_s1_reg_firsttransfer <= LEDR_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --LEDR_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  LEDR_s1_beginbursttransfer_internal <= LEDR_s1_begins_xfer;
  --~LEDR_s1_write_n assignment, which is an e_mux
  LEDR_s1_write_n <= NOT ((internal_cpu_0_data_master_granted_LEDR_s1 AND cpu_0_data_master_write));
  shifted_address_to_LEDR_s1_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --LEDR_s1_address mux, which is an e_mux
  LEDR_s1_address <= A_EXT (A_SRL(shifted_address_to_LEDR_s1_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_LEDR_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_LEDR_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_LEDR_s1_end_xfer <= LEDR_s1_end_xfer;
    end if;

  end process;

  --LEDR_s1_waits_for_read in a cycle, which is an e_mux
  LEDR_s1_waits_for_read <= LEDR_s1_in_a_read_cycle AND LEDR_s1_begins_xfer;
  --LEDR_s1_in_a_read_cycle assignment, which is an e_assign
  LEDR_s1_in_a_read_cycle <= internal_cpu_0_data_master_granted_LEDR_s1 AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= LEDR_s1_in_a_read_cycle;
  --LEDR_s1_waits_for_write in a cycle, which is an e_mux
  LEDR_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(LEDR_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --LEDR_s1_in_a_write_cycle assignment, which is an e_assign
  LEDR_s1_in_a_write_cycle <= internal_cpu_0_data_master_granted_LEDR_s1 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= LEDR_s1_in_a_write_cycle;
  wait_for_LEDR_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_LEDR_s1 <= internal_cpu_0_data_master_granted_LEDR_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_LEDR_s1 <= internal_cpu_0_data_master_qualified_request_LEDR_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_LEDR_s1 <= internal_cpu_0_data_master_requests_LEDR_s1;
--synthesis translate_off
    --LEDR/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity altpll_0_pll_slave_arbitrator is 
        port (
              -- inputs:
                 signal altpll_0_pll_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal altpll_0_pll_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal altpll_0_pll_slave_read : OUT STD_LOGIC;
                 signal altpll_0_pll_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal altpll_0_pll_slave_reset : OUT STD_LOGIC;
                 signal altpll_0_pll_slave_write : OUT STD_LOGIC;
                 signal altpll_0_pll_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_data_master_granted_altpll_0_pll_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_altpll_0_pll_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_altpll_0_pll_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_altpll_0_pll_slave : OUT STD_LOGIC;
                 signal d1_altpll_0_pll_slave_end_xfer : OUT STD_LOGIC
              );
end entity altpll_0_pll_slave_arbitrator;


architecture europa of altpll_0_pll_slave_arbitrator is
                signal altpll_0_pll_slave_allgrants :  STD_LOGIC;
                signal altpll_0_pll_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal altpll_0_pll_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal altpll_0_pll_slave_any_continuerequest :  STD_LOGIC;
                signal altpll_0_pll_slave_arb_counter_enable :  STD_LOGIC;
                signal altpll_0_pll_slave_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal altpll_0_pll_slave_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal altpll_0_pll_slave_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal altpll_0_pll_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal altpll_0_pll_slave_begins_xfer :  STD_LOGIC;
                signal altpll_0_pll_slave_end_xfer :  STD_LOGIC;
                signal altpll_0_pll_slave_firsttransfer :  STD_LOGIC;
                signal altpll_0_pll_slave_grant_vector :  STD_LOGIC;
                signal altpll_0_pll_slave_in_a_read_cycle :  STD_LOGIC;
                signal altpll_0_pll_slave_in_a_write_cycle :  STD_LOGIC;
                signal altpll_0_pll_slave_master_qreq_vector :  STD_LOGIC;
                signal altpll_0_pll_slave_non_bursting_master_requests :  STD_LOGIC;
                signal altpll_0_pll_slave_reg_firsttransfer :  STD_LOGIC;
                signal altpll_0_pll_slave_slavearbiterlockenable :  STD_LOGIC;
                signal altpll_0_pll_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal altpll_0_pll_slave_unreg_firsttransfer :  STD_LOGIC;
                signal altpll_0_pll_slave_waits_for_read :  STD_LOGIC;
                signal altpll_0_pll_slave_waits_for_write :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_altpll_0_pll_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_altpll_0_pll_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_altpll_0_pll_slave :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_altpll_0_pll_slave :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_altpll_0_pll_slave :  STD_LOGIC;
                signal shifted_address_to_altpll_0_pll_slave_from_cpu_0_data_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal wait_for_altpll_0_pll_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT altpll_0_pll_slave_end_xfer;
    end if;

  end process;

  altpll_0_pll_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_altpll_0_pll_slave);
  --assign altpll_0_pll_slave_readdata_from_sa = altpll_0_pll_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  altpll_0_pll_slave_readdata_from_sa <= altpll_0_pll_slave_readdata;
  internal_cpu_0_data_master_requests_altpll_0_pll_slave <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(24 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("1000000000101000001010000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --altpll_0_pll_slave_arb_share_counter set values, which is an e_mux
  altpll_0_pll_slave_arb_share_set_values <= std_logic_vector'("01");
  --altpll_0_pll_slave_non_bursting_master_requests mux, which is an e_mux
  altpll_0_pll_slave_non_bursting_master_requests <= internal_cpu_0_data_master_requests_altpll_0_pll_slave;
  --altpll_0_pll_slave_any_bursting_master_saved_grant mux, which is an e_mux
  altpll_0_pll_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --altpll_0_pll_slave_arb_share_counter_next_value assignment, which is an e_assign
  altpll_0_pll_slave_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(altpll_0_pll_slave_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (altpll_0_pll_slave_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(altpll_0_pll_slave_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (altpll_0_pll_slave_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --altpll_0_pll_slave_allgrants all slave grants, which is an e_mux
  altpll_0_pll_slave_allgrants <= altpll_0_pll_slave_grant_vector;
  --altpll_0_pll_slave_end_xfer assignment, which is an e_assign
  altpll_0_pll_slave_end_xfer <= NOT ((altpll_0_pll_slave_waits_for_read OR altpll_0_pll_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_altpll_0_pll_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_altpll_0_pll_slave <= altpll_0_pll_slave_end_xfer AND (((NOT altpll_0_pll_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --altpll_0_pll_slave_arb_share_counter arbitration counter enable, which is an e_assign
  altpll_0_pll_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_altpll_0_pll_slave AND altpll_0_pll_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_altpll_0_pll_slave AND NOT altpll_0_pll_slave_non_bursting_master_requests));
  --altpll_0_pll_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      altpll_0_pll_slave_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(altpll_0_pll_slave_arb_counter_enable) = '1' then 
        altpll_0_pll_slave_arb_share_counter <= altpll_0_pll_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --altpll_0_pll_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      altpll_0_pll_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((altpll_0_pll_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_altpll_0_pll_slave)) OR ((end_xfer_arb_share_counter_term_altpll_0_pll_slave AND NOT altpll_0_pll_slave_non_bursting_master_requests)))) = '1' then 
        altpll_0_pll_slave_slavearbiterlockenable <= or_reduce(altpll_0_pll_slave_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master altpll_0/pll_slave arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= altpll_0_pll_slave_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --altpll_0_pll_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  altpll_0_pll_slave_slavearbiterlockenable2 <= or_reduce(altpll_0_pll_slave_arb_share_counter_next_value);
  --cpu_0/data_master altpll_0/pll_slave arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= altpll_0_pll_slave_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --altpll_0_pll_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  altpll_0_pll_slave_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_altpll_0_pll_slave <= internal_cpu_0_data_master_requests_altpll_0_pll_slave AND NOT ((((cpu_0_data_master_read AND (NOT cpu_0_data_master_waitrequest))) OR (((NOT cpu_0_data_master_waitrequest) AND cpu_0_data_master_write))));
  --altpll_0_pll_slave_writedata mux, which is an e_mux
  altpll_0_pll_slave_writedata <= cpu_0_data_master_writedata;
  --master is always granted when requested
  internal_cpu_0_data_master_granted_altpll_0_pll_slave <= internal_cpu_0_data_master_qualified_request_altpll_0_pll_slave;
  --cpu_0/data_master saved-grant altpll_0/pll_slave, which is an e_assign
  cpu_0_data_master_saved_grant_altpll_0_pll_slave <= internal_cpu_0_data_master_requests_altpll_0_pll_slave;
  --allow new arb cycle for altpll_0/pll_slave, which is an e_assign
  altpll_0_pll_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  altpll_0_pll_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  altpll_0_pll_slave_master_qreq_vector <= std_logic'('1');
  --~altpll_0_pll_slave_reset assignment, which is an e_assign
  altpll_0_pll_slave_reset <= NOT reset_n;
  --altpll_0_pll_slave_firsttransfer first transaction, which is an e_assign
  altpll_0_pll_slave_firsttransfer <= A_WE_StdLogic((std_logic'(altpll_0_pll_slave_begins_xfer) = '1'), altpll_0_pll_slave_unreg_firsttransfer, altpll_0_pll_slave_reg_firsttransfer);
  --altpll_0_pll_slave_unreg_firsttransfer first transaction, which is an e_assign
  altpll_0_pll_slave_unreg_firsttransfer <= NOT ((altpll_0_pll_slave_slavearbiterlockenable AND altpll_0_pll_slave_any_continuerequest));
  --altpll_0_pll_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      altpll_0_pll_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(altpll_0_pll_slave_begins_xfer) = '1' then 
        altpll_0_pll_slave_reg_firsttransfer <= altpll_0_pll_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --altpll_0_pll_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  altpll_0_pll_slave_beginbursttransfer_internal <= altpll_0_pll_slave_begins_xfer;
  --altpll_0_pll_slave_read assignment, which is an e_mux
  altpll_0_pll_slave_read <= internal_cpu_0_data_master_granted_altpll_0_pll_slave AND cpu_0_data_master_read;
  --altpll_0_pll_slave_write assignment, which is an e_mux
  altpll_0_pll_slave_write <= internal_cpu_0_data_master_granted_altpll_0_pll_slave AND cpu_0_data_master_write;
  shifted_address_to_altpll_0_pll_slave_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --altpll_0_pll_slave_address mux, which is an e_mux
  altpll_0_pll_slave_address <= A_EXT (A_SRL(shifted_address_to_altpll_0_pll_slave_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_altpll_0_pll_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_altpll_0_pll_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_altpll_0_pll_slave_end_xfer <= altpll_0_pll_slave_end_xfer;
    end if;

  end process;

  --altpll_0_pll_slave_waits_for_read in a cycle, which is an e_mux
  altpll_0_pll_slave_waits_for_read <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(altpll_0_pll_slave_in_a_read_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --altpll_0_pll_slave_in_a_read_cycle assignment, which is an e_assign
  altpll_0_pll_slave_in_a_read_cycle <= internal_cpu_0_data_master_granted_altpll_0_pll_slave AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= altpll_0_pll_slave_in_a_read_cycle;
  --altpll_0_pll_slave_waits_for_write in a cycle, which is an e_mux
  altpll_0_pll_slave_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(altpll_0_pll_slave_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --altpll_0_pll_slave_in_a_write_cycle assignment, which is an e_assign
  altpll_0_pll_slave_in_a_write_cycle <= internal_cpu_0_data_master_granted_altpll_0_pll_slave AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= altpll_0_pll_slave_in_a_write_cycle;
  wait_for_altpll_0_pll_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_altpll_0_pll_slave <= internal_cpu_0_data_master_granted_altpll_0_pll_slave;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_altpll_0_pll_slave <= internal_cpu_0_data_master_qualified_request_altpll_0_pll_slave;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_altpll_0_pll_slave <= internal_cpu_0_data_master_requests_altpll_0_pll_slave;
--synthesis translate_off
    --altpll_0/pll_slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity char_lcd_control_slave_arbitrator is 
        port (
              -- inputs:
                 signal char_lcd_control_slave_readdata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal char_lcd_control_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal char_lcd_control_slave_begintransfer : OUT STD_LOGIC;
                 signal char_lcd_control_slave_read : OUT STD_LOGIC;
                 signal char_lcd_control_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal char_lcd_control_slave_wait_counter_eq_0 : OUT STD_LOGIC;
                 signal char_lcd_control_slave_wait_counter_eq_1 : OUT STD_LOGIC;
                 signal char_lcd_control_slave_write : OUT STD_LOGIC;
                 signal char_lcd_control_slave_writedata : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal cpu_0_data_master_granted_char_lcd_control_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_char_lcd_control_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_char_lcd_control_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_char_lcd_control_slave : OUT STD_LOGIC;
                 signal d1_char_lcd_control_slave_end_xfer : OUT STD_LOGIC
              );
end entity char_lcd_control_slave_arbitrator;


architecture europa of char_lcd_control_slave_arbitrator is
                signal char_lcd_control_slave_allgrants :  STD_LOGIC;
                signal char_lcd_control_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal char_lcd_control_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal char_lcd_control_slave_any_continuerequest :  STD_LOGIC;
                signal char_lcd_control_slave_arb_counter_enable :  STD_LOGIC;
                signal char_lcd_control_slave_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal char_lcd_control_slave_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal char_lcd_control_slave_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal char_lcd_control_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal char_lcd_control_slave_begins_xfer :  STD_LOGIC;
                signal char_lcd_control_slave_counter_load_value :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal char_lcd_control_slave_end_xfer :  STD_LOGIC;
                signal char_lcd_control_slave_firsttransfer :  STD_LOGIC;
                signal char_lcd_control_slave_grant_vector :  STD_LOGIC;
                signal char_lcd_control_slave_in_a_read_cycle :  STD_LOGIC;
                signal char_lcd_control_slave_in_a_write_cycle :  STD_LOGIC;
                signal char_lcd_control_slave_master_qreq_vector :  STD_LOGIC;
                signal char_lcd_control_slave_non_bursting_master_requests :  STD_LOGIC;
                signal char_lcd_control_slave_pretend_byte_enable :  STD_LOGIC;
                signal char_lcd_control_slave_reg_firsttransfer :  STD_LOGIC;
                signal char_lcd_control_slave_slavearbiterlockenable :  STD_LOGIC;
                signal char_lcd_control_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal char_lcd_control_slave_unreg_firsttransfer :  STD_LOGIC;
                signal char_lcd_control_slave_wait_counter :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal char_lcd_control_slave_waits_for_read :  STD_LOGIC;
                signal char_lcd_control_slave_waits_for_write :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_char_lcd_control_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_char_lcd_control_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_char_lcd_control_slave_wait_counter_eq_0 :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_char_lcd_control_slave :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_char_lcd_control_slave :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_char_lcd_control_slave :  STD_LOGIC;
                signal shifted_address_to_char_lcd_control_slave_from_cpu_0_data_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal wait_for_char_lcd_control_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT char_lcd_control_slave_end_xfer;
    end if;

  end process;

  char_lcd_control_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_char_lcd_control_slave);
  --assign char_lcd_control_slave_readdata_from_sa = char_lcd_control_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  char_lcd_control_slave_readdata_from_sa <= char_lcd_control_slave_readdata;
  internal_cpu_0_data_master_requests_char_lcd_control_slave <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(24 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("1000000000101000001000000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --char_lcd_control_slave_arb_share_counter set values, which is an e_mux
  char_lcd_control_slave_arb_share_set_values <= std_logic_vector'("01");
  --char_lcd_control_slave_non_bursting_master_requests mux, which is an e_mux
  char_lcd_control_slave_non_bursting_master_requests <= internal_cpu_0_data_master_requests_char_lcd_control_slave;
  --char_lcd_control_slave_any_bursting_master_saved_grant mux, which is an e_mux
  char_lcd_control_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --char_lcd_control_slave_arb_share_counter_next_value assignment, which is an e_assign
  char_lcd_control_slave_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(char_lcd_control_slave_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (char_lcd_control_slave_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(char_lcd_control_slave_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (char_lcd_control_slave_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --char_lcd_control_slave_allgrants all slave grants, which is an e_mux
  char_lcd_control_slave_allgrants <= char_lcd_control_slave_grant_vector;
  --char_lcd_control_slave_end_xfer assignment, which is an e_assign
  char_lcd_control_slave_end_xfer <= NOT ((char_lcd_control_slave_waits_for_read OR char_lcd_control_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_char_lcd_control_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_char_lcd_control_slave <= char_lcd_control_slave_end_xfer AND (((NOT char_lcd_control_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --char_lcd_control_slave_arb_share_counter arbitration counter enable, which is an e_assign
  char_lcd_control_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_char_lcd_control_slave AND char_lcd_control_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_char_lcd_control_slave AND NOT char_lcd_control_slave_non_bursting_master_requests));
  --char_lcd_control_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      char_lcd_control_slave_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(char_lcd_control_slave_arb_counter_enable) = '1' then 
        char_lcd_control_slave_arb_share_counter <= char_lcd_control_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --char_lcd_control_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      char_lcd_control_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((char_lcd_control_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_char_lcd_control_slave)) OR ((end_xfer_arb_share_counter_term_char_lcd_control_slave AND NOT char_lcd_control_slave_non_bursting_master_requests)))) = '1' then 
        char_lcd_control_slave_slavearbiterlockenable <= or_reduce(char_lcd_control_slave_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master char_lcd/control_slave arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= char_lcd_control_slave_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --char_lcd_control_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  char_lcd_control_slave_slavearbiterlockenable2 <= or_reduce(char_lcd_control_slave_arb_share_counter_next_value);
  --cpu_0/data_master char_lcd/control_slave arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= char_lcd_control_slave_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --char_lcd_control_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  char_lcd_control_slave_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_char_lcd_control_slave <= internal_cpu_0_data_master_requests_char_lcd_control_slave;
  --char_lcd_control_slave_writedata mux, which is an e_mux
  char_lcd_control_slave_writedata <= cpu_0_data_master_writedata (7 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_0_data_master_granted_char_lcd_control_slave <= internal_cpu_0_data_master_qualified_request_char_lcd_control_slave;
  --cpu_0/data_master saved-grant char_lcd/control_slave, which is an e_assign
  cpu_0_data_master_saved_grant_char_lcd_control_slave <= internal_cpu_0_data_master_requests_char_lcd_control_slave;
  --allow new arb cycle for char_lcd/control_slave, which is an e_assign
  char_lcd_control_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  char_lcd_control_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  char_lcd_control_slave_master_qreq_vector <= std_logic'('1');
  char_lcd_control_slave_begintransfer <= char_lcd_control_slave_begins_xfer;
  --char_lcd_control_slave_firsttransfer first transaction, which is an e_assign
  char_lcd_control_slave_firsttransfer <= A_WE_StdLogic((std_logic'(char_lcd_control_slave_begins_xfer) = '1'), char_lcd_control_slave_unreg_firsttransfer, char_lcd_control_slave_reg_firsttransfer);
  --char_lcd_control_slave_unreg_firsttransfer first transaction, which is an e_assign
  char_lcd_control_slave_unreg_firsttransfer <= NOT ((char_lcd_control_slave_slavearbiterlockenable AND char_lcd_control_slave_any_continuerequest));
  --char_lcd_control_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      char_lcd_control_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(char_lcd_control_slave_begins_xfer) = '1' then 
        char_lcd_control_slave_reg_firsttransfer <= char_lcd_control_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --char_lcd_control_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  char_lcd_control_slave_beginbursttransfer_internal <= char_lcd_control_slave_begins_xfer;
  --char_lcd_control_slave_read assignment, which is an e_mux
  char_lcd_control_slave_read <= (((internal_cpu_0_data_master_granted_char_lcd_control_slave AND cpu_0_data_master_read)) AND NOT char_lcd_control_slave_begins_xfer) AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (char_lcd_control_slave_wait_counter))<std_logic_vector'("00000000000000000000000000001101"))));
  --char_lcd_control_slave_write assignment, which is an e_mux
  char_lcd_control_slave_write <= (((((internal_cpu_0_data_master_granted_char_lcd_control_slave AND cpu_0_data_master_write)) AND NOT char_lcd_control_slave_begins_xfer) AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (char_lcd_control_slave_wait_counter))>=std_logic_vector'("00000000000000000000000000001101"))))) AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (char_lcd_control_slave_wait_counter))<std_logic_vector'("00000000000000000000000000011010"))))) AND char_lcd_control_slave_pretend_byte_enable;
  shifted_address_to_char_lcd_control_slave_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --char_lcd_control_slave_address mux, which is an e_mux
  char_lcd_control_slave_address <= A_EXT (A_SRL(shifted_address_to_char_lcd_control_slave_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_char_lcd_control_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_char_lcd_control_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_char_lcd_control_slave_end_xfer <= char_lcd_control_slave_end_xfer;
    end if;

  end process;

  --char_lcd_control_slave_wait_counter_eq_1 assignment, which is an e_assign
  char_lcd_control_slave_wait_counter_eq_1 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (char_lcd_control_slave_wait_counter)) = std_logic_vector'("00000000000000000000000000000001")));
  --char_lcd_control_slave_waits_for_read in a cycle, which is an e_mux
  char_lcd_control_slave_waits_for_read <= char_lcd_control_slave_in_a_read_cycle AND wait_for_char_lcd_control_slave_counter;
  --char_lcd_control_slave_in_a_read_cycle assignment, which is an e_assign
  char_lcd_control_slave_in_a_read_cycle <= internal_cpu_0_data_master_granted_char_lcd_control_slave AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= char_lcd_control_slave_in_a_read_cycle;
  --char_lcd_control_slave_waits_for_write in a cycle, which is an e_mux
  char_lcd_control_slave_waits_for_write <= char_lcd_control_slave_in_a_write_cycle AND wait_for_char_lcd_control_slave_counter;
  --char_lcd_control_slave_in_a_write_cycle assignment, which is an e_assign
  char_lcd_control_slave_in_a_write_cycle <= internal_cpu_0_data_master_granted_char_lcd_control_slave AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= char_lcd_control_slave_in_a_write_cycle;
  internal_char_lcd_control_slave_wait_counter_eq_0 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (char_lcd_control_slave_wait_counter)) = std_logic_vector'("00000000000000000000000000000000")));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      char_lcd_control_slave_wait_counter <= std_logic_vector'("000000");
    elsif clk'event and clk = '1' then
      char_lcd_control_slave_wait_counter <= char_lcd_control_slave_counter_load_value;
    end if;

  end process;

  char_lcd_control_slave_counter_load_value <= A_EXT (A_WE_StdLogicVector((std_logic'(((char_lcd_control_slave_in_a_read_cycle AND char_lcd_control_slave_begins_xfer))) = '1'), std_logic_vector'("000000000000000000000000000011000"), A_WE_StdLogicVector((std_logic'(((char_lcd_control_slave_in_a_write_cycle AND char_lcd_control_slave_begins_xfer))) = '1'), std_logic_vector'("000000000000000000000000000100101"), A_WE_StdLogicVector((std_logic'((NOT internal_char_lcd_control_slave_wait_counter_eq_0)) = '1'), ((std_logic_vector'("000000000000000000000000000") & (char_lcd_control_slave_wait_counter)) - std_logic_vector'("000000000000000000000000000000001")), std_logic_vector'("000000000000000000000000000000000")))), 6);
  wait_for_char_lcd_control_slave_counter <= char_lcd_control_slave_begins_xfer OR NOT internal_char_lcd_control_slave_wait_counter_eq_0;
  --char_lcd_control_slave_pretend_byte_enable byte enable port mux, which is an e_mux
  char_lcd_control_slave_pretend_byte_enable <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_char_lcd_control_slave)) = '1'), (std_logic_vector'("0000000000000000000000000000") & (cpu_0_data_master_byteenable)), -SIGNED(std_logic_vector'("00000000000000000000000000000001"))));
  --vhdl renameroo for output signals
  char_lcd_control_slave_wait_counter_eq_0 <= internal_char_lcd_control_slave_wait_counter_eq_0;
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_char_lcd_control_slave <= internal_cpu_0_data_master_granted_char_lcd_control_slave;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_char_lcd_control_slave <= internal_cpu_0_data_master_qualified_request_char_lcd_control_slave;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_char_lcd_control_slave <= internal_cpu_0_data_master_requests_char_lcd_control_slave;
--synthesis translate_off
    --char_lcd/control_slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity cpu_0_jtag_debug_module_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_0_data_master_debugaccess : IN STD_LOGIC;
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_instruction_master_read : IN STD_LOGIC;
                 signal cpu_0_jtag_debug_module_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_jtag_debug_module_resetrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_granted_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_granted_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_requests_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_address : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
                 signal cpu_0_jtag_debug_module_begintransfer : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_0_jtag_debug_module_chipselect : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_debugaccess : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_jtag_debug_module_reset_n : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_resetrequest_from_sa : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_write : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_cpu_0_jtag_debug_module_end_xfer : OUT STD_LOGIC
              );
end entity cpu_0_jtag_debug_module_arbitrator;


architecture europa of cpu_0_jtag_debug_module_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_instruction_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_instruction_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_instruction_master_continuerequest :  STD_LOGIC;
                signal cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_allgrants :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_allow_new_arb_cycle :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_any_bursting_master_saved_grant :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_any_continuerequest :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_arb_addend :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_arb_counter_enable :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_arb_winner :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_arbitration_holdoff_internal :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_beginbursttransfer_internal :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_begins_xfer :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_chosen_master_double_vector :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_0_jtag_debug_module_chosen_master_rot_left :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_end_xfer :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_firsttransfer :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_grant_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_in_a_read_cycle :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_in_a_write_cycle :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_master_qreq_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_non_bursting_master_requests :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_reg_firsttransfer :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_saved_chosen_master_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_slavearbiterlockenable :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_slavearbiterlockenable2 :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_unreg_firsttransfer :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_waits_for_read :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_waits_for_write :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_granted_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_data_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_instruction_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal wait_for_cpu_0_jtag_debug_module_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT cpu_0_jtag_debug_module_end_xfer;
    end if;

  end process;

  cpu_0_jtag_debug_module_begins_xfer <= NOT d1_reasons_to_wait AND ((internal_cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module OR internal_cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module));
  --assign cpu_0_jtag_debug_module_readdata_from_sa = cpu_0_jtag_debug_module_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  cpu_0_jtag_debug_module_readdata_from_sa <= cpu_0_jtag_debug_module_readdata;
  internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(24 DOWNTO 11) & std_logic_vector'("00000000000")) = std_logic_vector'("1000000000100100000000000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --cpu_0_jtag_debug_module_arb_share_counter set values, which is an e_mux
  cpu_0_jtag_debug_module_arb_share_set_values <= std_logic_vector'("01");
  --cpu_0_jtag_debug_module_non_bursting_master_requests mux, which is an e_mux
  cpu_0_jtag_debug_module_non_bursting_master_requests <= ((internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module OR internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module) OR internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module) OR internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  --cpu_0_jtag_debug_module_any_bursting_master_saved_grant mux, which is an e_mux
  cpu_0_jtag_debug_module_any_bursting_master_saved_grant <= std_logic'('0');
  --cpu_0_jtag_debug_module_arb_share_counter_next_value assignment, which is an e_assign
  cpu_0_jtag_debug_module_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(cpu_0_jtag_debug_module_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (cpu_0_jtag_debug_module_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(cpu_0_jtag_debug_module_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (cpu_0_jtag_debug_module_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --cpu_0_jtag_debug_module_allgrants all slave grants, which is an e_mux
  cpu_0_jtag_debug_module_allgrants <= (((or_reduce(cpu_0_jtag_debug_module_grant_vector)) OR (or_reduce(cpu_0_jtag_debug_module_grant_vector))) OR (or_reduce(cpu_0_jtag_debug_module_grant_vector))) OR (or_reduce(cpu_0_jtag_debug_module_grant_vector));
  --cpu_0_jtag_debug_module_end_xfer assignment, which is an e_assign
  cpu_0_jtag_debug_module_end_xfer <= NOT ((cpu_0_jtag_debug_module_waits_for_read OR cpu_0_jtag_debug_module_waits_for_write));
  --end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module <= cpu_0_jtag_debug_module_end_xfer AND (((NOT cpu_0_jtag_debug_module_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --cpu_0_jtag_debug_module_arb_share_counter arbitration counter enable, which is an e_assign
  cpu_0_jtag_debug_module_arb_counter_enable <= ((end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module AND cpu_0_jtag_debug_module_allgrants)) OR ((end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module AND NOT cpu_0_jtag_debug_module_non_bursting_master_requests));
  --cpu_0_jtag_debug_module_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_jtag_debug_module_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_0_jtag_debug_module_arb_counter_enable) = '1' then 
        cpu_0_jtag_debug_module_arb_share_counter <= cpu_0_jtag_debug_module_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu_0_jtag_debug_module_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_jtag_debug_module_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((or_reduce(cpu_0_jtag_debug_module_master_qreq_vector) AND end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module)) OR ((end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module AND NOT cpu_0_jtag_debug_module_non_bursting_master_requests)))) = '1' then 
        cpu_0_jtag_debug_module_slavearbiterlockenable <= or_reduce(cpu_0_jtag_debug_module_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master cpu_0/jtag_debug_module arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= cpu_0_jtag_debug_module_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --cpu_0_jtag_debug_module_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  cpu_0_jtag_debug_module_slavearbiterlockenable2 <= or_reduce(cpu_0_jtag_debug_module_arb_share_counter_next_value);
  --cpu_0/data_master cpu_0/jtag_debug_module arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= cpu_0_jtag_debug_module_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --cpu_0/instruction_master cpu_0/jtag_debug_module arbiterlock, which is an e_assign
  cpu_0_instruction_master_arbiterlock <= cpu_0_jtag_debug_module_slavearbiterlockenable AND cpu_0_instruction_master_continuerequest;
  --cpu_0/instruction_master cpu_0/jtag_debug_module arbiterlock2, which is an e_assign
  cpu_0_instruction_master_arbiterlock2 <= cpu_0_jtag_debug_module_slavearbiterlockenable2 AND cpu_0_instruction_master_continuerequest;
  --cpu_0/instruction_master granted cpu_0/jtag_debug_module last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((cpu_0_jtag_debug_module_arbitration_holdoff_internal OR NOT internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module))))));
    end if;

  end process;

  --cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  cpu_0_instruction_master_continuerequest <= last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module AND internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  --cpu_0_jtag_debug_module_any_continuerequest at least one master continues requesting, which is an e_mux
  cpu_0_jtag_debug_module_any_continuerequest <= cpu_0_instruction_master_continuerequest OR cpu_0_data_master_continuerequest;
  internal_cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module <= internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module AND NOT (((((NOT cpu_0_data_master_waitrequest) AND cpu_0_data_master_write)) OR cpu_0_instruction_master_arbiterlock));
  --cpu_0_jtag_debug_module_writedata mux, which is an e_mux
  cpu_0_jtag_debug_module_writedata <= cpu_0_data_master_writedata;
  internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module <= ((to_std_logic(((Std_Logic_Vector'(cpu_0_instruction_master_address_to_slave(24 DOWNTO 11) & std_logic_vector'("00000000000")) = std_logic_vector'("1000000000100100000000000")))) AND (cpu_0_instruction_master_read))) AND cpu_0_instruction_master_read;
  --cpu_0/data_master granted cpu_0/jtag_debug_module last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((cpu_0_jtag_debug_module_arbitration_holdoff_internal OR NOT internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module))))));
    end if;

  end process;

  --cpu_0_data_master_continuerequest continued request, which is an e_mux
  cpu_0_data_master_continuerequest <= last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module AND internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  internal_cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module <= internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module AND NOT (cpu_0_data_master_arbiterlock);
  --allow new arb cycle for cpu_0/jtag_debug_module, which is an e_assign
  cpu_0_jtag_debug_module_allow_new_arb_cycle <= NOT cpu_0_data_master_arbiterlock AND NOT cpu_0_instruction_master_arbiterlock;
  --cpu_0/instruction_master assignment into master qualified-requests vector for cpu_0/jtag_debug_module, which is an e_assign
  cpu_0_jtag_debug_module_master_qreq_vector(0) <= internal_cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  --cpu_0/instruction_master grant cpu_0/jtag_debug_module, which is an e_assign
  internal_cpu_0_instruction_master_granted_cpu_0_jtag_debug_module <= cpu_0_jtag_debug_module_grant_vector(0);
  --cpu_0/instruction_master saved-grant cpu_0/jtag_debug_module, which is an e_assign
  cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module <= cpu_0_jtag_debug_module_arb_winner(0) AND internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  --cpu_0/data_master assignment into master qualified-requests vector for cpu_0/jtag_debug_module, which is an e_assign
  cpu_0_jtag_debug_module_master_qreq_vector(1) <= internal_cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  --cpu_0/data_master grant cpu_0/jtag_debug_module, which is an e_assign
  internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module <= cpu_0_jtag_debug_module_grant_vector(1);
  --cpu_0/data_master saved-grant cpu_0/jtag_debug_module, which is an e_assign
  cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module <= cpu_0_jtag_debug_module_arb_winner(1) AND internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  --cpu_0/jtag_debug_module chosen-master double-vector, which is an e_assign
  cpu_0_jtag_debug_module_chosen_master_double_vector <= A_EXT (((std_logic_vector'("0") & ((cpu_0_jtag_debug_module_master_qreq_vector & cpu_0_jtag_debug_module_master_qreq_vector))) AND (((std_logic_vector'("0") & (Std_Logic_Vector'(NOT cpu_0_jtag_debug_module_master_qreq_vector & NOT cpu_0_jtag_debug_module_master_qreq_vector))) + (std_logic_vector'("000") & (cpu_0_jtag_debug_module_arb_addend))))), 4);
  --stable onehot encoding of arb winner
  cpu_0_jtag_debug_module_arb_winner <= A_WE_StdLogicVector((std_logic'(((cpu_0_jtag_debug_module_allow_new_arb_cycle AND or_reduce(cpu_0_jtag_debug_module_grant_vector)))) = '1'), cpu_0_jtag_debug_module_grant_vector, cpu_0_jtag_debug_module_saved_chosen_master_vector);
  --saved cpu_0_jtag_debug_module_grant_vector, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_jtag_debug_module_saved_chosen_master_vector <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_0_jtag_debug_module_allow_new_arb_cycle) = '1' then 
        cpu_0_jtag_debug_module_saved_chosen_master_vector <= A_WE_StdLogicVector((std_logic'(or_reduce(cpu_0_jtag_debug_module_grant_vector)) = '1'), cpu_0_jtag_debug_module_grant_vector, cpu_0_jtag_debug_module_saved_chosen_master_vector);
      end if;
    end if;

  end process;

  --onehot encoding of chosen master
  cpu_0_jtag_debug_module_grant_vector <= Std_Logic_Vector'(A_ToStdLogicVector(((cpu_0_jtag_debug_module_chosen_master_double_vector(1) OR cpu_0_jtag_debug_module_chosen_master_double_vector(3)))) & A_ToStdLogicVector(((cpu_0_jtag_debug_module_chosen_master_double_vector(0) OR cpu_0_jtag_debug_module_chosen_master_double_vector(2)))));
  --cpu_0/jtag_debug_module chosen master rotated left, which is an e_assign
  cpu_0_jtag_debug_module_chosen_master_rot_left <= A_EXT (A_WE_StdLogicVector((((A_SLL(cpu_0_jtag_debug_module_arb_winner,std_logic_vector'("00000000000000000000000000000001")))) /= std_logic_vector'("00")), (std_logic_vector'("000000000000000000000000000000") & ((A_SLL(cpu_0_jtag_debug_module_arb_winner,std_logic_vector'("00000000000000000000000000000001"))))), std_logic_vector'("00000000000000000000000000000001")), 2);
  --cpu_0/jtag_debug_module's addend for next-master-grant
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_jtag_debug_module_arb_addend <= std_logic_vector'("01");
    elsif clk'event and clk = '1' then
      if std_logic'(or_reduce(cpu_0_jtag_debug_module_grant_vector)) = '1' then 
        cpu_0_jtag_debug_module_arb_addend <= A_WE_StdLogicVector((std_logic'(cpu_0_jtag_debug_module_end_xfer) = '1'), cpu_0_jtag_debug_module_chosen_master_rot_left, cpu_0_jtag_debug_module_grant_vector);
      end if;
    end if;

  end process;

  cpu_0_jtag_debug_module_begintransfer <= cpu_0_jtag_debug_module_begins_xfer;
  --cpu_0_jtag_debug_module_reset_n assignment, which is an e_assign
  cpu_0_jtag_debug_module_reset_n <= reset_n;
  --assign cpu_0_jtag_debug_module_resetrequest_from_sa = cpu_0_jtag_debug_module_resetrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  cpu_0_jtag_debug_module_resetrequest_from_sa <= cpu_0_jtag_debug_module_resetrequest;
  cpu_0_jtag_debug_module_chipselect <= internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module OR internal_cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  --cpu_0_jtag_debug_module_firsttransfer first transaction, which is an e_assign
  cpu_0_jtag_debug_module_firsttransfer <= A_WE_StdLogic((std_logic'(cpu_0_jtag_debug_module_begins_xfer) = '1'), cpu_0_jtag_debug_module_unreg_firsttransfer, cpu_0_jtag_debug_module_reg_firsttransfer);
  --cpu_0_jtag_debug_module_unreg_firsttransfer first transaction, which is an e_assign
  cpu_0_jtag_debug_module_unreg_firsttransfer <= NOT ((cpu_0_jtag_debug_module_slavearbiterlockenable AND cpu_0_jtag_debug_module_any_continuerequest));
  --cpu_0_jtag_debug_module_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_jtag_debug_module_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_0_jtag_debug_module_begins_xfer) = '1' then 
        cpu_0_jtag_debug_module_reg_firsttransfer <= cpu_0_jtag_debug_module_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --cpu_0_jtag_debug_module_beginbursttransfer_internal begin burst transfer, which is an e_assign
  cpu_0_jtag_debug_module_beginbursttransfer_internal <= cpu_0_jtag_debug_module_begins_xfer;
  --cpu_0_jtag_debug_module_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  cpu_0_jtag_debug_module_arbitration_holdoff_internal <= cpu_0_jtag_debug_module_begins_xfer AND cpu_0_jtag_debug_module_firsttransfer;
  --cpu_0_jtag_debug_module_write assignment, which is an e_mux
  cpu_0_jtag_debug_module_write <= internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module AND cpu_0_data_master_write;
  shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --cpu_0_jtag_debug_module_address mux, which is an e_mux
  cpu_0_jtag_debug_module_address <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module)) = '1'), (A_SRL(shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010"))), (A_SRL(shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_instruction_master,std_logic_vector'("00000000000000000000000000000010")))), 9);
  shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_instruction_master <= cpu_0_instruction_master_address_to_slave;
  --d1_cpu_0_jtag_debug_module_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_cpu_0_jtag_debug_module_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_cpu_0_jtag_debug_module_end_xfer <= cpu_0_jtag_debug_module_end_xfer;
    end if;

  end process;

  --cpu_0_jtag_debug_module_waits_for_read in a cycle, which is an e_mux
  cpu_0_jtag_debug_module_waits_for_read <= cpu_0_jtag_debug_module_in_a_read_cycle AND cpu_0_jtag_debug_module_begins_xfer;
  --cpu_0_jtag_debug_module_in_a_read_cycle assignment, which is an e_assign
  cpu_0_jtag_debug_module_in_a_read_cycle <= ((internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module AND cpu_0_data_master_read)) OR ((internal_cpu_0_instruction_master_granted_cpu_0_jtag_debug_module AND cpu_0_instruction_master_read));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= cpu_0_jtag_debug_module_in_a_read_cycle;
  --cpu_0_jtag_debug_module_waits_for_write in a cycle, which is an e_mux
  cpu_0_jtag_debug_module_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_jtag_debug_module_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --cpu_0_jtag_debug_module_in_a_write_cycle assignment, which is an e_assign
  cpu_0_jtag_debug_module_in_a_write_cycle <= internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= cpu_0_jtag_debug_module_in_a_write_cycle;
  wait_for_cpu_0_jtag_debug_module_counter <= std_logic'('0');
  --cpu_0_jtag_debug_module_byteenable byte enable port mux, which is an e_mux
  cpu_0_jtag_debug_module_byteenable <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module)) = '1'), (std_logic_vector'("0000000000000000000000000000") & (cpu_0_data_master_byteenable)), -SIGNED(std_logic_vector'("00000000000000000000000000000001"))), 4);
  --debugaccess mux, which is an e_mux
  cpu_0_jtag_debug_module_debugaccess <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module)) = '1'), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_debugaccess))), std_logic_vector'("00000000000000000000000000000000")));
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_cpu_0_jtag_debug_module <= internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module <= internal_cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_cpu_0_jtag_debug_module <= internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_granted_cpu_0_jtag_debug_module <= internal_cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module <= internal_cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_requests_cpu_0_jtag_debug_module <= internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
--synthesis translate_off
    --cpu_0/jtag_debug_module enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_0_instruction_master_granted_cpu_0_jtag_debug_module))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line, now);
          write(write_line, string'(": "));
          write(write_line, string'("> 1 of grant signals are active simultaneously"));
          write(output, write_line.all);
          deallocate (write_line);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --saved_grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line1 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line1, now);
          write(write_line1, string'(": "));
          write(write_line1, string'("> 1 of saved_grant signals are active simultaneously"));
          write(output, write_line1.all);
          deallocate (write_line1);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity cpu_0_data_master_arbitrator is 
        port (
              -- inputs:
                 signal LEDG_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal LEDR_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (17 DOWNTO 0);
                 signal altpll_0_pll_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal char_lcd_control_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal char_lcd_control_slave_wait_counter_eq_0 : IN STD_LOGIC;
                 signal char_lcd_control_slave_wait_counter_eq_1 : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_data_master_byteenable_sdram_0_s1 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_data_master_granted_LEDG_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_LEDR_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_altpll_0_pll_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_char_lcd_control_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_note_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_note_1_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_note_2_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_note_3_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_note_4_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_note_5_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_onchip_memory2_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_sdram_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_sysid_control_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_uC_timer_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_uart_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_LEDG_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_LEDR_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_altpll_0_pll_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_char_lcd_control_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_note_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_note_1_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_note_2_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_note_3_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_note_4_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_note_5_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_onchip_memory2_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_sdram_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_sysid_control_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_uC_timer_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_uart_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_LEDG_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_LEDR_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_altpll_0_pll_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_char_lcd_control_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_note_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_note_1_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_note_2_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_note_3_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_note_4_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_note_5_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sdram_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sysid_control_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_uC_timer_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_uart_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_LEDG_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_LEDR_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_altpll_0_pll_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_char_lcd_control_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_note_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_note_1_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_note_2_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_note_3_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_note_4_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_note_5_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_onchip_memory2_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_sdram_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_sysid_control_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_uC_timer_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_uart_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_LEDG_s1_end_xfer : IN STD_LOGIC;
                 signal d1_LEDR_s1_end_xfer : IN STD_LOGIC;
                 signal d1_altpll_0_pll_slave_end_xfer : IN STD_LOGIC;
                 signal d1_char_lcd_control_slave_end_xfer : IN STD_LOGIC;
                 signal d1_cpu_0_jtag_debug_module_end_xfer : IN STD_LOGIC;
                 signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer : IN STD_LOGIC;
                 signal d1_note_0_s1_end_xfer : IN STD_LOGIC;
                 signal d1_note_1_s1_end_xfer : IN STD_LOGIC;
                 signal d1_note_2_s1_end_xfer : IN STD_LOGIC;
                 signal d1_note_3_s1_end_xfer : IN STD_LOGIC;
                 signal d1_note_4_s1_end_xfer : IN STD_LOGIC;
                 signal d1_note_5_s1_end_xfer : IN STD_LOGIC;
                 signal d1_onchip_memory2_0_s1_end_xfer : IN STD_LOGIC;
                 signal d1_sdram_0_s1_end_xfer : IN STD_LOGIC;
                 signal d1_sysid_control_slave_end_xfer : IN STD_LOGIC;
                 signal d1_uC_timer_s1_end_xfer : IN STD_LOGIC;
                 signal d1_uart_0_s1_end_xfer : IN STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_irq_from_sa : IN STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal note_0_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                 signal note_1_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                 signal note_2_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                 signal note_3_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                 signal note_4_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                 signal note_5_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                 signal onchip_memory2_0_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal registered_cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sdram_0_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sdram_0_s1_waitrequest_from_sa : IN STD_LOGIC;
                 signal sysid_control_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal uC_timer_s1_irq_from_sa : IN STD_LOGIC;
                 signal uC_timer_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal uart_0_s1_irq_from_sa : IN STD_LOGIC;
                 signal uart_0_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

              -- outputs:
                 signal cpu_0_data_master_address_to_slave : OUT STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_data_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_data_master_dbs_write_16 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal cpu_0_data_master_irq : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_data_master_no_byte_enables_and_last_term : OUT STD_LOGIC;
                 signal cpu_0_data_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_data_master_waitrequest : OUT STD_LOGIC
              );
end entity cpu_0_data_master_arbitrator;


architecture europa of cpu_0_data_master_arbitrator is
                signal cpu_0_data_master_dbs_increment :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_data_master_run :  STD_LOGIC;
                signal dbs_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal dbs_count_enable :  STD_LOGIC;
                signal dbs_counter_overflow :  STD_LOGIC;
                signal internal_cpu_0_data_master_address_to_slave :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal internal_cpu_0_data_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_cpu_0_data_master_no_byte_enables_and_last_term :  STD_LOGIC;
                signal internal_cpu_0_data_master_waitrequest :  STD_LOGIC;
                signal last_dbs_term_and_run :  STD_LOGIC;
                signal next_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p1_dbs_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal p1_registered_cpu_0_data_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal pre_dbs_count_enable :  STD_LOGIC;
                signal r_0 :  STD_LOGIC;
                signal r_1 :  STD_LOGIC;
                signal r_2 :  STD_LOGIC;
                signal r_3 :  STD_LOGIC;
                signal registered_cpu_0_data_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);

begin

  --r_0 master_run cascaded wait assignment, which is an e_assign
  r_0 <= Vector_To_Std_Logic((((((((((((((((((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_LEDG_s1 OR NOT cpu_0_data_master_requests_LEDG_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_LEDG_s1 OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_LEDG_s1 OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_LEDR_s1 OR NOT cpu_0_data_master_requests_LEDR_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_LEDR_s1 OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_LEDR_s1 OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_altpll_0_pll_slave OR NOT cpu_0_data_master_requests_altpll_0_pll_slave)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_altpll_0_pll_slave OR NOT ((cpu_0_data_master_read OR cpu_0_data_master_write)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_read OR cpu_0_data_master_write)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_altpll_0_pll_slave OR NOT ((cpu_0_data_master_read OR cpu_0_data_master_write)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_read OR cpu_0_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_char_lcd_control_slave OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(char_lcd_control_slave_wait_counter_eq_1)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_char_lcd_control_slave OR NOT cpu_0_data_master_write)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(char_lcd_control_slave_wait_counter_eq_1)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module OR NOT cpu_0_data_master_requests_cpu_0_jtag_debug_module)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_granted_cpu_0_jtag_debug_module OR NOT cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))));
  --cascaded wait assignment, which is an e_assign
  cpu_0_data_master_run <= ((r_0 AND r_1) AND r_2) AND r_3;
  --r_1 master_run cascaded wait assignment, which is an e_assign
  r_1 <= Vector_To_Std_Logic((((((((((((((((((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave OR NOT cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave OR NOT ((cpu_0_data_master_read OR cpu_0_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_read OR cpu_0_data_master_write)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave OR NOT ((cpu_0_data_master_read OR cpu_0_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_read OR cpu_0_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_note_0_s1 OR NOT cpu_0_data_master_requests_note_0_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_note_0_s1 OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_note_0_s1 OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_note_1_s1 OR NOT cpu_0_data_master_requests_note_1_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_note_1_s1 OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_note_1_s1 OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_note_2_s1 OR NOT cpu_0_data_master_requests_note_2_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_note_2_s1 OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_note_2_s1 OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_note_3_s1 OR NOT cpu_0_data_master_requests_note_3_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_note_3_s1 OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_note_3_s1 OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))));
  --r_2 master_run cascaded wait assignment, which is an e_assign
  r_2 <= Vector_To_Std_Logic((((((((((((((((((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_note_4_s1 OR NOT cpu_0_data_master_requests_note_4_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_note_4_s1 OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_note_4_s1 OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_note_5_s1 OR NOT cpu_0_data_master_requests_note_5_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_note_5_s1 OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_note_5_s1 OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_0_data_master_qualified_request_onchip_memory2_0_s1 OR registered_cpu_0_data_master_read_data_valid_onchip_memory2_0_s1) OR NOT cpu_0_data_master_requests_onchip_memory2_0_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_granted_onchip_memory2_0_s1 OR NOT cpu_0_data_master_qualified_request_onchip_memory2_0_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_0_data_master_qualified_request_onchip_memory2_0_s1 OR NOT cpu_0_data_master_read) OR ((registered_cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 AND cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_onchip_memory2_0_s1 OR NOT ((cpu_0_data_master_read OR cpu_0_data_master_write)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_read OR cpu_0_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((((cpu_0_data_master_qualified_request_sdram_0_s1 OR ((cpu_0_data_master_read_data_valid_sdram_0_s1 AND internal_cpu_0_data_master_dbs_address(1)))) OR (((cpu_0_data_master_write AND NOT(or_reduce(cpu_0_data_master_byteenable_sdram_0_s1))) AND internal_cpu_0_data_master_dbs_address(1)))) OR NOT cpu_0_data_master_requests_sdram_0_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_granted_sdram_0_s1 OR NOT cpu_0_data_master_qualified_request_sdram_0_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_0_data_master_qualified_request_sdram_0_s1 OR NOT cpu_0_data_master_read) OR (((cpu_0_data_master_read_data_valid_sdram_0_s1 AND (internal_cpu_0_data_master_dbs_address(1))) AND cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_sdram_0_s1 OR NOT cpu_0_data_master_write)))) OR ((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT sdram_0_s1_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_0_data_master_dbs_address(1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_sysid_control_slave OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))));
  --r_3 master_run cascaded wait assignment, which is an e_assign
  r_3 <= Vector_To_Std_Logic(((((((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_sysid_control_slave OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_uC_timer_s1 OR NOT cpu_0_data_master_requests_uC_timer_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_uC_timer_s1 OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_uC_timer_s1 OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_uart_0_s1 OR NOT ((cpu_0_data_master_read OR cpu_0_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_read OR cpu_0_data_master_write)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_uart_0_s1 OR NOT ((cpu_0_data_master_read OR cpu_0_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_read OR cpu_0_data_master_write)))))))))));
  --optimize select-logic by passing only those address bits which matter.
  internal_cpu_0_data_master_address_to_slave <= cpu_0_data_master_address(24 DOWNTO 0);
  --cpu_0/data_master readdata mux, which is an e_mux
  cpu_0_data_master_readdata <= (((((((((((((((((A_REP(NOT cpu_0_data_master_requests_LEDG_s1, 32) OR (std_logic_vector'("000000000000000000000000") & (LEDG_s1_readdata_from_sa)))) AND ((A_REP(NOT cpu_0_data_master_requests_LEDR_s1, 32) OR (std_logic_vector'("00000000000000") & (LEDR_s1_readdata_from_sa))))) AND ((A_REP(NOT cpu_0_data_master_requests_altpll_0_pll_slave, 32) OR registered_cpu_0_data_master_readdata))) AND ((A_REP(NOT cpu_0_data_master_requests_char_lcd_control_slave, 32) OR (std_logic_vector'("000000000000000000000000") & (char_lcd_control_slave_readdata_from_sa))))) AND ((A_REP(NOT cpu_0_data_master_requests_cpu_0_jtag_debug_module, 32) OR cpu_0_jtag_debug_module_readdata_from_sa))) AND ((A_REP(NOT cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave, 32) OR registered_cpu_0_data_master_readdata))) AND ((A_REP(NOT cpu_0_data_master_requests_note_0_s1, 32) OR (std_logic_vector'("000000000000") & (note_0_s1_readdata_from_sa))))) AND ((A_REP(NOT cpu_0_data_master_requests_note_1_s1, 32) OR (std_logic_vector'("000000000000") & (note_1_s1_readdata_from_sa))))) AND ((A_REP(NOT cpu_0_data_master_requests_note_2_s1, 32) OR (std_logic_vector'("000000000000") & (note_2_s1_readdata_from_sa))))) AND ((A_REP(NOT cpu_0_data_master_requests_note_3_s1, 32) OR (std_logic_vector'("000000000000") & (note_3_s1_readdata_from_sa))))) AND ((A_REP(NOT cpu_0_data_master_requests_note_4_s1, 32) OR (std_logic_vector'("000000000000") & (note_4_s1_readdata_from_sa))))) AND ((A_REP(NOT cpu_0_data_master_requests_note_5_s1, 32) OR (std_logic_vector'("000000000000") & (note_5_s1_readdata_from_sa))))) AND ((A_REP(NOT cpu_0_data_master_requests_onchip_memory2_0_s1, 32) OR onchip_memory2_0_s1_readdata_from_sa))) AND ((A_REP(NOT cpu_0_data_master_requests_sdram_0_s1, 32) OR registered_cpu_0_data_master_readdata))) AND ((A_REP(NOT cpu_0_data_master_requests_sysid_control_slave, 32) OR sysid_control_slave_readdata_from_sa))) AND ((A_REP(NOT cpu_0_data_master_requests_uC_timer_s1, 32) OR (std_logic_vector'("0000000000000000") & (uC_timer_s1_readdata_from_sa))))) AND ((A_REP(NOT cpu_0_data_master_requests_uart_0_s1, 32) OR (std_logic_vector'("0000000000000000") & (uart_0_s1_readdata_from_sa))));
  --actual waitrequest port, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_0_data_master_waitrequest <= Vector_To_Std_Logic(NOT std_logic_vector'("00000000000000000000000000000000"));
    elsif clk'event and clk = '1' then
      internal_cpu_0_data_master_waitrequest <= Vector_To_Std_Logic(NOT (A_WE_StdLogicVector((std_logic'((NOT ((cpu_0_data_master_read OR cpu_0_data_master_write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_run AND internal_cpu_0_data_master_waitrequest))))))));
    end if;

  end process;

  --unpredictable registered wait state incoming data, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      registered_cpu_0_data_master_readdata <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      registered_cpu_0_data_master_readdata <= p1_registered_cpu_0_data_master_readdata;
    end if;

  end process;

  --registered readdata mux, which is an e_mux
  p1_registered_cpu_0_data_master_readdata <= (((A_REP(NOT cpu_0_data_master_requests_altpll_0_pll_slave, 32) OR altpll_0_pll_slave_readdata_from_sa)) AND ((A_REP(NOT cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave, 32) OR jtag_uart_0_avalon_jtag_slave_readdata_from_sa))) AND ((A_REP(NOT cpu_0_data_master_requests_sdram_0_s1, 32) OR Std_Logic_Vector'(sdram_0_s1_readdata_from_sa(15 DOWNTO 0) & dbs_16_reg_segment_0)));
  --irq assign, which is an e_assign
  cpu_0_data_master_irq <= Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(uart_0_s1_irq_from_sa) & A_ToStdLogicVector(jtag_uart_0_avalon_jtag_slave_irq_from_sa) & A_ToStdLogicVector(uC_timer_s1_irq_from_sa));
  --no_byte_enables_and_last_term, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_0_data_master_no_byte_enables_and_last_term <= std_logic'('0');
    elsif clk'event and clk = '1' then
      internal_cpu_0_data_master_no_byte_enables_and_last_term <= last_dbs_term_and_run;
    end if;

  end process;

  --compute the last dbs term, which is an e_mux
  last_dbs_term_and_run <= (to_std_logic(((internal_cpu_0_data_master_dbs_address = std_logic_vector'("10")))) AND cpu_0_data_master_write) AND NOT(or_reduce(cpu_0_data_master_byteenable_sdram_0_s1));
  --pre dbs count enable, which is an e_mux
  pre_dbs_count_enable <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((((((NOT internal_cpu_0_data_master_no_byte_enables_and_last_term) AND cpu_0_data_master_requests_sdram_0_s1) AND cpu_0_data_master_write) AND NOT(or_reduce(cpu_0_data_master_byteenable_sdram_0_s1)))) OR cpu_0_data_master_read_data_valid_sdram_0_s1)))) OR (((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_0_data_master_granted_sdram_0_s1 AND cpu_0_data_master_write)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT sdram_0_s1_waitrequest_from_sa)))))));
  --input to dbs-16 stored 0, which is an e_mux
  p1_dbs_16_reg_segment_0 <= sdram_0_s1_readdata_from_sa;
  --dbs register for dbs-16 segment 0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dbs_16_reg_segment_0 <= std_logic_vector'("0000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((dbs_count_enable AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_0_data_master_dbs_address(1))))) = std_logic_vector'("00000000000000000000000000000000")))))) = '1' then 
        dbs_16_reg_segment_0 <= p1_dbs_16_reg_segment_0;
      end if;
    end if;

  end process;

  --mux write dbs 1, which is an e_mux
  cpu_0_data_master_dbs_write_16 <= A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_dbs_address(1))) = '1'), cpu_0_data_master_writedata(31 DOWNTO 16), cpu_0_data_master_writedata(15 DOWNTO 0));
  --dbs count increment, which is an e_mux
  cpu_0_data_master_dbs_increment <= A_EXT (A_WE_StdLogicVector((std_logic'((cpu_0_data_master_requests_sdram_0_s1)) = '1'), std_logic_vector'("00000000000000000000000000000010"), std_logic_vector'("00000000000000000000000000000000")), 2);
  --dbs counter overflow, which is an e_assign
  dbs_counter_overflow <= internal_cpu_0_data_master_dbs_address(1) AND NOT((next_dbs_address(1)));
  --next master address, which is an e_assign
  next_dbs_address <= A_EXT (((std_logic_vector'("0") & (internal_cpu_0_data_master_dbs_address)) + (std_logic_vector'("0") & (cpu_0_data_master_dbs_increment))), 2);
  --dbs count enable, which is an e_mux
  dbs_count_enable <= pre_dbs_count_enable AND (NOT ((cpu_0_data_master_requests_sdram_0_s1 AND NOT internal_cpu_0_data_master_waitrequest)));
  --dbs counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_0_data_master_dbs_address <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(dbs_count_enable) = '1' then 
        internal_cpu_0_data_master_dbs_address <= next_dbs_address;
      end if;
    end if;

  end process;

  --vhdl renameroo for output signals
  cpu_0_data_master_address_to_slave <= internal_cpu_0_data_master_address_to_slave;
  --vhdl renameroo for output signals
  cpu_0_data_master_dbs_address <= internal_cpu_0_data_master_dbs_address;
  --vhdl renameroo for output signals
  cpu_0_data_master_no_byte_enables_and_last_term <= internal_cpu_0_data_master_no_byte_enables_and_last_term;
  --vhdl renameroo for output signals
  cpu_0_data_master_waitrequest <= internal_cpu_0_data_master_waitrequest;

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity cpu_0_instruction_master_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_instruction_master_address : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_instruction_master_granted_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_instruction_master_granted_onchip_memory2_0_s1 : IN STD_LOGIC;
                 signal cpu_0_instruction_master_granted_sdram_0_s1 : IN STD_LOGIC;
                 signal cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1 : IN STD_LOGIC;
                 signal cpu_0_instruction_master_qualified_request_sdram_0_s1 : IN STD_LOGIC;
                 signal cpu_0_instruction_master_read : IN STD_LOGIC;
                 signal cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1 : IN STD_LOGIC;
                 signal cpu_0_instruction_master_read_data_valid_sdram_0_s1 : IN STD_LOGIC;
                 signal cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                 signal cpu_0_instruction_master_requests_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_instruction_master_requests_onchip_memory2_0_s1 : IN STD_LOGIC;
                 signal cpu_0_instruction_master_requests_sdram_0_s1 : IN STD_LOGIC;
                 signal cpu_0_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_cpu_0_jtag_debug_module_end_xfer : IN STD_LOGIC;
                 signal d1_onchip_memory2_0_s1_end_xfer : IN STD_LOGIC;
                 signal d1_sdram_0_s1_end_xfer : IN STD_LOGIC;
                 signal onchip_memory2_0_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;
                 signal sdram_0_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sdram_0_s1_waitrequest_from_sa : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_instruction_master_address_to_slave : OUT STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_instruction_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_instruction_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_instruction_master_waitrequest : OUT STD_LOGIC
              );
end entity cpu_0_instruction_master_arbitrator;


architecture europa of cpu_0_instruction_master_arbitrator is
                signal active_and_waiting_last_time :  STD_LOGIC;
                signal cpu_0_instruction_master_address_last_time :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal cpu_0_instruction_master_dbs_increment :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_instruction_master_read_last_time :  STD_LOGIC;
                signal cpu_0_instruction_master_run :  STD_LOGIC;
                signal dbs_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal dbs_count_enable :  STD_LOGIC;
                signal dbs_counter_overflow :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_address_to_slave :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal internal_cpu_0_instruction_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_cpu_0_instruction_master_waitrequest :  STD_LOGIC;
                signal next_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p1_dbs_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal pre_dbs_count_enable :  STD_LOGIC;
                signal r_0 :  STD_LOGIC;
                signal r_2 :  STD_LOGIC;

begin

  --r_0 master_run cascaded wait assignment, which is an e_assign
  r_0 <= Vector_To_Std_Logic((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module OR NOT cpu_0_instruction_master_requests_cpu_0_jtag_debug_module)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_instruction_master_granted_cpu_0_jtag_debug_module OR NOT cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module OR NOT cpu_0_instruction_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_cpu_0_jtag_debug_module_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_instruction_master_read)))))))));
  --cascaded wait assignment, which is an e_assign
  cpu_0_instruction_master_run <= r_0 AND r_2;
  --r_2 master_run cascaded wait assignment, which is an e_assign
  r_2 <= Vector_To_Std_Logic((((((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1 OR cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1) OR NOT cpu_0_instruction_master_requests_onchip_memory2_0_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_instruction_master_granted_onchip_memory2_0_s1 OR NOT cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1 OR NOT cpu_0_instruction_master_read) OR ((cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1 AND cpu_0_instruction_master_read)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_0_instruction_master_qualified_request_sdram_0_s1 OR ((cpu_0_instruction_master_read_data_valid_sdram_0_s1 AND internal_cpu_0_instruction_master_dbs_address(1)))) OR NOT cpu_0_instruction_master_requests_sdram_0_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_instruction_master_granted_sdram_0_s1 OR NOT cpu_0_instruction_master_qualified_request_sdram_0_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_0_instruction_master_qualified_request_sdram_0_s1 OR NOT cpu_0_instruction_master_read) OR (((cpu_0_instruction_master_read_data_valid_sdram_0_s1 AND (internal_cpu_0_instruction_master_dbs_address(1))) AND cpu_0_instruction_master_read)))))))));
  --optimize select-logic by passing only those address bits which matter.
  internal_cpu_0_instruction_master_address_to_slave <= cpu_0_instruction_master_address(24 DOWNTO 0);
  --cpu_0/instruction_master readdata mux, which is an e_mux
  cpu_0_instruction_master_readdata <= (((A_REP(NOT cpu_0_instruction_master_requests_cpu_0_jtag_debug_module, 32) OR cpu_0_jtag_debug_module_readdata_from_sa)) AND ((A_REP(NOT cpu_0_instruction_master_requests_onchip_memory2_0_s1, 32) OR onchip_memory2_0_s1_readdata_from_sa))) AND ((A_REP(NOT cpu_0_instruction_master_requests_sdram_0_s1, 32) OR Std_Logic_Vector'(sdram_0_s1_readdata_from_sa(15 DOWNTO 0) & dbs_16_reg_segment_0)));
  --actual waitrequest port, which is an e_assign
  internal_cpu_0_instruction_master_waitrequest <= NOT cpu_0_instruction_master_run;
  --input to dbs-16 stored 0, which is an e_mux
  p1_dbs_16_reg_segment_0 <= sdram_0_s1_readdata_from_sa;
  --dbs register for dbs-16 segment 0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dbs_16_reg_segment_0 <= std_logic_vector'("0000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((dbs_count_enable AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_0_instruction_master_dbs_address(1))))) = std_logic_vector'("00000000000000000000000000000000")))))) = '1' then 
        dbs_16_reg_segment_0 <= p1_dbs_16_reg_segment_0;
      end if;
    end if;

  end process;

  --dbs count increment, which is an e_mux
  cpu_0_instruction_master_dbs_increment <= A_EXT (A_WE_StdLogicVector((std_logic'((cpu_0_instruction_master_requests_sdram_0_s1)) = '1'), std_logic_vector'("00000000000000000000000000000010"), std_logic_vector'("00000000000000000000000000000000")), 2);
  --dbs counter overflow, which is an e_assign
  dbs_counter_overflow <= internal_cpu_0_instruction_master_dbs_address(1) AND NOT((next_dbs_address(1)));
  --next master address, which is an e_assign
  next_dbs_address <= A_EXT (((std_logic_vector'("0") & (internal_cpu_0_instruction_master_dbs_address)) + (std_logic_vector'("0") & (cpu_0_instruction_master_dbs_increment))), 2);
  --dbs count enable, which is an e_mux
  dbs_count_enable <= pre_dbs_count_enable;
  --dbs counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_0_instruction_master_dbs_address <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(dbs_count_enable) = '1' then 
        internal_cpu_0_instruction_master_dbs_address <= next_dbs_address;
      end if;
    end if;

  end process;

  --pre dbs count enable, which is an e_mux
  pre_dbs_count_enable <= cpu_0_instruction_master_read_data_valid_sdram_0_s1;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_address_to_slave <= internal_cpu_0_instruction_master_address_to_slave;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_dbs_address <= internal_cpu_0_instruction_master_dbs_address;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_waitrequest <= internal_cpu_0_instruction_master_waitrequest;
--synthesis translate_off
    --cpu_0_instruction_master_address check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        cpu_0_instruction_master_address_last_time <= std_logic_vector'("0000000000000000000000000");
      elsif clk'event and clk = '1' then
        cpu_0_instruction_master_address_last_time <= cpu_0_instruction_master_address;
      end if;

    end process;

    --cpu_0/instruction_master waited last time, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        active_and_waiting_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        active_and_waiting_last_time <= internal_cpu_0_instruction_master_waitrequest AND (cpu_0_instruction_master_read);
      end if;

    end process;

    --cpu_0_instruction_master_address matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line2 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((cpu_0_instruction_master_address /= cpu_0_instruction_master_address_last_time))))) = '1' then 
          write(write_line2, now);
          write(write_line2, string'(": "));
          write(write_line2, string'("cpu_0_instruction_master_address did not heed wait!!!"));
          write(output, write_line2.all);
          deallocate (write_line2);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --cpu_0_instruction_master_read check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        cpu_0_instruction_master_read_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        cpu_0_instruction_master_read_last_time <= cpu_0_instruction_master_read;
      end if;

    end process;

    --cpu_0_instruction_master_read matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line3 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((std_logic'(cpu_0_instruction_master_read) /= std_logic'(cpu_0_instruction_master_read_last_time)))))) = '1' then 
          write(write_line3, now);
          write(write_line3, string'(": "));
          write(write_line3, string'("cpu_0_instruction_master_read did not heed wait!!!"));
          write(output, write_line3.all);
          deallocate (write_line3);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity jtag_uart_0_avalon_jtag_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_0_avalon_jtag_slave_dataavailable : IN STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_irq : IN STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_0_avalon_jtag_slave_readyfordata : IN STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                 signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_address : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_chipselect : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_irq_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_read_n : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_reset_n : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_write_n : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity jtag_uart_0_avalon_jtag_slave_arbitrator;


architecture europa of jtag_uart_0_avalon_jtag_slave_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_allgrants :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_any_continuerequest :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_arb_counter_enable :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal jtag_uart_0_avalon_jtag_slave_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_begins_xfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_end_xfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_firsttransfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_grant_vector :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_in_a_read_cycle :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_in_a_write_cycle :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_master_qreq_vector :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_reg_firsttransfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_waits_for_read :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_jtag_uart_0_avalon_jtag_slave_from_cpu_0_data_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal wait_for_jtag_uart_0_avalon_jtag_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT jtag_uart_0_avalon_jtag_slave_end_xfer;
    end if;

  end process;

  jtag_uart_0_avalon_jtag_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave);
  --assign jtag_uart_0_avalon_jtag_slave_readdata_from_sa = jtag_uart_0_avalon_jtag_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_readdata_from_sa <= jtag_uart_0_avalon_jtag_slave_readdata;
  internal_cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(24 DOWNTO 3) & std_logic_vector'("000")) = std_logic_vector'("1000000000101000100001000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --assign jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_0_avalon_jtag_slave_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa <= jtag_uart_0_avalon_jtag_slave_dataavailable;
  --assign jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_0_avalon_jtag_slave_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa <= jtag_uart_0_avalon_jtag_slave_readyfordata;
  --assign jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_0_avalon_jtag_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa <= jtag_uart_0_avalon_jtag_slave_waitrequest;
  --jtag_uart_0_avalon_jtag_slave_arb_share_counter set values, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_arb_share_set_values <= std_logic_vector'("01");
  --jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests mux, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests <= internal_cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  --jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant mux, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(jtag_uart_0_avalon_jtag_slave_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (jtag_uart_0_avalon_jtag_slave_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(jtag_uart_0_avalon_jtag_slave_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (jtag_uart_0_avalon_jtag_slave_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --jtag_uart_0_avalon_jtag_slave_allgrants all slave grants, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_allgrants <= jtag_uart_0_avalon_jtag_slave_grant_vector;
  --jtag_uart_0_avalon_jtag_slave_end_xfer assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_end_xfer <= NOT ((jtag_uart_0_avalon_jtag_slave_waits_for_read OR jtag_uart_0_avalon_jtag_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave <= jtag_uart_0_avalon_jtag_slave_end_xfer AND (((NOT jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --jtag_uart_0_avalon_jtag_slave_arb_share_counter arbitration counter enable, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave AND jtag_uart_0_avalon_jtag_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave AND NOT jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests));
  --jtag_uart_0_avalon_jtag_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_0_avalon_jtag_slave_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(jtag_uart_0_avalon_jtag_slave_arb_counter_enable) = '1' then 
        jtag_uart_0_avalon_jtag_slave_arb_share_counter <= jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((jtag_uart_0_avalon_jtag_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave)) OR ((end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave AND NOT jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests)))) = '1' then 
        jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable <= or_reduce(jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master jtag_uart_0/avalon_jtag_slave arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 <= or_reduce(jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value);
  --cpu_0/data_master jtag_uart_0/avalon_jtag_slave arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --jtag_uart_0_avalon_jtag_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave <= internal_cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave AND NOT ((((cpu_0_data_master_read AND (NOT cpu_0_data_master_waitrequest))) OR (((NOT cpu_0_data_master_waitrequest) AND cpu_0_data_master_write))));
  --jtag_uart_0_avalon_jtag_slave_writedata mux, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_writedata <= cpu_0_data_master_writedata;
  --master is always granted when requested
  internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave <= internal_cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;
  --cpu_0/data_master saved-grant jtag_uart_0/avalon_jtag_slave, which is an e_assign
  cpu_0_data_master_saved_grant_jtag_uart_0_avalon_jtag_slave <= internal_cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  --allow new arb cycle for jtag_uart_0/avalon_jtag_slave, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  jtag_uart_0_avalon_jtag_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  jtag_uart_0_avalon_jtag_slave_master_qreq_vector <= std_logic'('1');
  --jtag_uart_0_avalon_jtag_slave_reset_n assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_reset_n <= reset_n;
  jtag_uart_0_avalon_jtag_slave_chipselect <= internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  --jtag_uart_0_avalon_jtag_slave_firsttransfer first transaction, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_firsttransfer <= A_WE_StdLogic((std_logic'(jtag_uart_0_avalon_jtag_slave_begins_xfer) = '1'), jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer, jtag_uart_0_avalon_jtag_slave_reg_firsttransfer);
  --jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer first transaction, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer <= NOT ((jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable AND jtag_uart_0_avalon_jtag_slave_any_continuerequest));
  --jtag_uart_0_avalon_jtag_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_0_avalon_jtag_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(jtag_uart_0_avalon_jtag_slave_begins_xfer) = '1' then 
        jtag_uart_0_avalon_jtag_slave_reg_firsttransfer <= jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal <= jtag_uart_0_avalon_jtag_slave_begins_xfer;
  --~jtag_uart_0_avalon_jtag_slave_read_n assignment, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_read_n <= NOT ((internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave AND cpu_0_data_master_read));
  --~jtag_uart_0_avalon_jtag_slave_write_n assignment, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_write_n <= NOT ((internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave AND cpu_0_data_master_write));
  shifted_address_to_jtag_uart_0_avalon_jtag_slave_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --jtag_uart_0_avalon_jtag_slave_address mux, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_address <= Vector_To_Std_Logic(A_SRL(shifted_address_to_jtag_uart_0_avalon_jtag_slave_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")));
  --d1_jtag_uart_0_avalon_jtag_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_jtag_uart_0_avalon_jtag_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_jtag_uart_0_avalon_jtag_slave_end_xfer <= jtag_uart_0_avalon_jtag_slave_end_xfer;
    end if;

  end process;

  --jtag_uart_0_avalon_jtag_slave_waits_for_read in a cycle, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_waits_for_read <= jtag_uart_0_avalon_jtag_slave_in_a_read_cycle AND internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  --jtag_uart_0_avalon_jtag_slave_in_a_read_cycle assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_in_a_read_cycle <= internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= jtag_uart_0_avalon_jtag_slave_in_a_read_cycle;
  --jtag_uart_0_avalon_jtag_slave_waits_for_write in a cycle, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_waits_for_write <= jtag_uart_0_avalon_jtag_slave_in_a_write_cycle AND internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  --jtag_uart_0_avalon_jtag_slave_in_a_write_cycle assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_in_a_write_cycle <= internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= jtag_uart_0_avalon_jtag_slave_in_a_write_cycle;
  wait_for_jtag_uart_0_avalon_jtag_slave_counter <= std_logic'('0');
  --assign jtag_uart_0_avalon_jtag_slave_irq_from_sa = jtag_uart_0_avalon_jtag_slave_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_irq_from_sa <= jtag_uart_0_avalon_jtag_slave_irq;
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave <= internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave <= internal_cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave <= internal_cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  --vhdl renameroo for output signals
  jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa <= internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
--synthesis translate_off
    --jtag_uart_0/avalon_jtag_slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity note_0_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal note_0_s1_readdata : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_granted_note_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_note_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_note_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_note_0_s1 : OUT STD_LOGIC;
                 signal d1_note_0_s1_end_xfer : OUT STD_LOGIC;
                 signal note_0_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal note_0_s1_chipselect : OUT STD_LOGIC;
                 signal note_0_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
                 signal note_0_s1_reset_n : OUT STD_LOGIC;
                 signal note_0_s1_write_n : OUT STD_LOGIC;
                 signal note_0_s1_writedata : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
              );
end entity note_0_s1_arbitrator;


architecture europa of note_0_s1_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_note_0_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_note_0_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_note_0_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_note_0_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_note_0_s1 :  STD_LOGIC;
                signal note_0_s1_allgrants :  STD_LOGIC;
                signal note_0_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal note_0_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal note_0_s1_any_continuerequest :  STD_LOGIC;
                signal note_0_s1_arb_counter_enable :  STD_LOGIC;
                signal note_0_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_0_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_0_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_0_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal note_0_s1_begins_xfer :  STD_LOGIC;
                signal note_0_s1_end_xfer :  STD_LOGIC;
                signal note_0_s1_firsttransfer :  STD_LOGIC;
                signal note_0_s1_grant_vector :  STD_LOGIC;
                signal note_0_s1_in_a_read_cycle :  STD_LOGIC;
                signal note_0_s1_in_a_write_cycle :  STD_LOGIC;
                signal note_0_s1_master_qreq_vector :  STD_LOGIC;
                signal note_0_s1_non_bursting_master_requests :  STD_LOGIC;
                signal note_0_s1_reg_firsttransfer :  STD_LOGIC;
                signal note_0_s1_slavearbiterlockenable :  STD_LOGIC;
                signal note_0_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal note_0_s1_unreg_firsttransfer :  STD_LOGIC;
                signal note_0_s1_waits_for_read :  STD_LOGIC;
                signal note_0_s1_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_note_0_s1_from_cpu_0_data_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal wait_for_note_0_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT note_0_s1_end_xfer;
    end if;

  end process;

  note_0_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_note_0_s1);
  --assign note_0_s1_readdata_from_sa = note_0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  note_0_s1_readdata_from_sa <= note_0_s1_readdata;
  internal_cpu_0_data_master_requests_note_0_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(24 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("1000000000101000010000000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --note_0_s1_arb_share_counter set values, which is an e_mux
  note_0_s1_arb_share_set_values <= std_logic_vector'("01");
  --note_0_s1_non_bursting_master_requests mux, which is an e_mux
  note_0_s1_non_bursting_master_requests <= internal_cpu_0_data_master_requests_note_0_s1;
  --note_0_s1_any_bursting_master_saved_grant mux, which is an e_mux
  note_0_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --note_0_s1_arb_share_counter_next_value assignment, which is an e_assign
  note_0_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(note_0_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (note_0_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(note_0_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (note_0_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --note_0_s1_allgrants all slave grants, which is an e_mux
  note_0_s1_allgrants <= note_0_s1_grant_vector;
  --note_0_s1_end_xfer assignment, which is an e_assign
  note_0_s1_end_xfer <= NOT ((note_0_s1_waits_for_read OR note_0_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_note_0_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_note_0_s1 <= note_0_s1_end_xfer AND (((NOT note_0_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --note_0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  note_0_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_note_0_s1 AND note_0_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_note_0_s1 AND NOT note_0_s1_non_bursting_master_requests));
  --note_0_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      note_0_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(note_0_s1_arb_counter_enable) = '1' then 
        note_0_s1_arb_share_counter <= note_0_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --note_0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      note_0_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((note_0_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_note_0_s1)) OR ((end_xfer_arb_share_counter_term_note_0_s1 AND NOT note_0_s1_non_bursting_master_requests)))) = '1' then 
        note_0_s1_slavearbiterlockenable <= or_reduce(note_0_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master note_0/s1 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= note_0_s1_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --note_0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  note_0_s1_slavearbiterlockenable2 <= or_reduce(note_0_s1_arb_share_counter_next_value);
  --cpu_0/data_master note_0/s1 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= note_0_s1_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --note_0_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  note_0_s1_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_note_0_s1 <= internal_cpu_0_data_master_requests_note_0_s1 AND NOT (((NOT cpu_0_data_master_waitrequest) AND cpu_0_data_master_write));
  --note_0_s1_writedata mux, which is an e_mux
  note_0_s1_writedata <= cpu_0_data_master_writedata (19 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_0_data_master_granted_note_0_s1 <= internal_cpu_0_data_master_qualified_request_note_0_s1;
  --cpu_0/data_master saved-grant note_0/s1, which is an e_assign
  cpu_0_data_master_saved_grant_note_0_s1 <= internal_cpu_0_data_master_requests_note_0_s1;
  --allow new arb cycle for note_0/s1, which is an e_assign
  note_0_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  note_0_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  note_0_s1_master_qreq_vector <= std_logic'('1');
  --note_0_s1_reset_n assignment, which is an e_assign
  note_0_s1_reset_n <= reset_n;
  note_0_s1_chipselect <= internal_cpu_0_data_master_granted_note_0_s1;
  --note_0_s1_firsttransfer first transaction, which is an e_assign
  note_0_s1_firsttransfer <= A_WE_StdLogic((std_logic'(note_0_s1_begins_xfer) = '1'), note_0_s1_unreg_firsttransfer, note_0_s1_reg_firsttransfer);
  --note_0_s1_unreg_firsttransfer first transaction, which is an e_assign
  note_0_s1_unreg_firsttransfer <= NOT ((note_0_s1_slavearbiterlockenable AND note_0_s1_any_continuerequest));
  --note_0_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      note_0_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(note_0_s1_begins_xfer) = '1' then 
        note_0_s1_reg_firsttransfer <= note_0_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --note_0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  note_0_s1_beginbursttransfer_internal <= note_0_s1_begins_xfer;
  --~note_0_s1_write_n assignment, which is an e_mux
  note_0_s1_write_n <= NOT ((internal_cpu_0_data_master_granted_note_0_s1 AND cpu_0_data_master_write));
  shifted_address_to_note_0_s1_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --note_0_s1_address mux, which is an e_mux
  note_0_s1_address <= A_EXT (A_SRL(shifted_address_to_note_0_s1_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_note_0_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_note_0_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_note_0_s1_end_xfer <= note_0_s1_end_xfer;
    end if;

  end process;

  --note_0_s1_waits_for_read in a cycle, which is an e_mux
  note_0_s1_waits_for_read <= note_0_s1_in_a_read_cycle AND note_0_s1_begins_xfer;
  --note_0_s1_in_a_read_cycle assignment, which is an e_assign
  note_0_s1_in_a_read_cycle <= internal_cpu_0_data_master_granted_note_0_s1 AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= note_0_s1_in_a_read_cycle;
  --note_0_s1_waits_for_write in a cycle, which is an e_mux
  note_0_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(note_0_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --note_0_s1_in_a_write_cycle assignment, which is an e_assign
  note_0_s1_in_a_write_cycle <= internal_cpu_0_data_master_granted_note_0_s1 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= note_0_s1_in_a_write_cycle;
  wait_for_note_0_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_note_0_s1 <= internal_cpu_0_data_master_granted_note_0_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_note_0_s1 <= internal_cpu_0_data_master_qualified_request_note_0_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_note_0_s1 <= internal_cpu_0_data_master_requests_note_0_s1;
--synthesis translate_off
    --note_0/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity note_1_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal note_1_s1_readdata : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_granted_note_1_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_note_1_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_note_1_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_note_1_s1 : OUT STD_LOGIC;
                 signal d1_note_1_s1_end_xfer : OUT STD_LOGIC;
                 signal note_1_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal note_1_s1_chipselect : OUT STD_LOGIC;
                 signal note_1_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
                 signal note_1_s1_reset_n : OUT STD_LOGIC;
                 signal note_1_s1_write_n : OUT STD_LOGIC;
                 signal note_1_s1_writedata : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
              );
end entity note_1_s1_arbitrator;


architecture europa of note_1_s1_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_note_1_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_note_1_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_note_1_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_note_1_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_note_1_s1 :  STD_LOGIC;
                signal note_1_s1_allgrants :  STD_LOGIC;
                signal note_1_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal note_1_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal note_1_s1_any_continuerequest :  STD_LOGIC;
                signal note_1_s1_arb_counter_enable :  STD_LOGIC;
                signal note_1_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_1_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_1_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_1_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal note_1_s1_begins_xfer :  STD_LOGIC;
                signal note_1_s1_end_xfer :  STD_LOGIC;
                signal note_1_s1_firsttransfer :  STD_LOGIC;
                signal note_1_s1_grant_vector :  STD_LOGIC;
                signal note_1_s1_in_a_read_cycle :  STD_LOGIC;
                signal note_1_s1_in_a_write_cycle :  STD_LOGIC;
                signal note_1_s1_master_qreq_vector :  STD_LOGIC;
                signal note_1_s1_non_bursting_master_requests :  STD_LOGIC;
                signal note_1_s1_reg_firsttransfer :  STD_LOGIC;
                signal note_1_s1_slavearbiterlockenable :  STD_LOGIC;
                signal note_1_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal note_1_s1_unreg_firsttransfer :  STD_LOGIC;
                signal note_1_s1_waits_for_read :  STD_LOGIC;
                signal note_1_s1_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_note_1_s1_from_cpu_0_data_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal wait_for_note_1_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT note_1_s1_end_xfer;
    end if;

  end process;

  note_1_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_note_1_s1);
  --assign note_1_s1_readdata_from_sa = note_1_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  note_1_s1_readdata_from_sa <= note_1_s1_readdata;
  internal_cpu_0_data_master_requests_note_1_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(24 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("1000000000101000010010000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --note_1_s1_arb_share_counter set values, which is an e_mux
  note_1_s1_arb_share_set_values <= std_logic_vector'("01");
  --note_1_s1_non_bursting_master_requests mux, which is an e_mux
  note_1_s1_non_bursting_master_requests <= internal_cpu_0_data_master_requests_note_1_s1;
  --note_1_s1_any_bursting_master_saved_grant mux, which is an e_mux
  note_1_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --note_1_s1_arb_share_counter_next_value assignment, which is an e_assign
  note_1_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(note_1_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (note_1_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(note_1_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (note_1_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --note_1_s1_allgrants all slave grants, which is an e_mux
  note_1_s1_allgrants <= note_1_s1_grant_vector;
  --note_1_s1_end_xfer assignment, which is an e_assign
  note_1_s1_end_xfer <= NOT ((note_1_s1_waits_for_read OR note_1_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_note_1_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_note_1_s1 <= note_1_s1_end_xfer AND (((NOT note_1_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --note_1_s1_arb_share_counter arbitration counter enable, which is an e_assign
  note_1_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_note_1_s1 AND note_1_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_note_1_s1 AND NOT note_1_s1_non_bursting_master_requests));
  --note_1_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      note_1_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(note_1_s1_arb_counter_enable) = '1' then 
        note_1_s1_arb_share_counter <= note_1_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --note_1_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      note_1_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((note_1_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_note_1_s1)) OR ((end_xfer_arb_share_counter_term_note_1_s1 AND NOT note_1_s1_non_bursting_master_requests)))) = '1' then 
        note_1_s1_slavearbiterlockenable <= or_reduce(note_1_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master note_1/s1 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= note_1_s1_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --note_1_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  note_1_s1_slavearbiterlockenable2 <= or_reduce(note_1_s1_arb_share_counter_next_value);
  --cpu_0/data_master note_1/s1 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= note_1_s1_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --note_1_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  note_1_s1_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_note_1_s1 <= internal_cpu_0_data_master_requests_note_1_s1 AND NOT (((NOT cpu_0_data_master_waitrequest) AND cpu_0_data_master_write));
  --note_1_s1_writedata mux, which is an e_mux
  note_1_s1_writedata <= cpu_0_data_master_writedata (19 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_0_data_master_granted_note_1_s1 <= internal_cpu_0_data_master_qualified_request_note_1_s1;
  --cpu_0/data_master saved-grant note_1/s1, which is an e_assign
  cpu_0_data_master_saved_grant_note_1_s1 <= internal_cpu_0_data_master_requests_note_1_s1;
  --allow new arb cycle for note_1/s1, which is an e_assign
  note_1_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  note_1_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  note_1_s1_master_qreq_vector <= std_logic'('1');
  --note_1_s1_reset_n assignment, which is an e_assign
  note_1_s1_reset_n <= reset_n;
  note_1_s1_chipselect <= internal_cpu_0_data_master_granted_note_1_s1;
  --note_1_s1_firsttransfer first transaction, which is an e_assign
  note_1_s1_firsttransfer <= A_WE_StdLogic((std_logic'(note_1_s1_begins_xfer) = '1'), note_1_s1_unreg_firsttransfer, note_1_s1_reg_firsttransfer);
  --note_1_s1_unreg_firsttransfer first transaction, which is an e_assign
  note_1_s1_unreg_firsttransfer <= NOT ((note_1_s1_slavearbiterlockenable AND note_1_s1_any_continuerequest));
  --note_1_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      note_1_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(note_1_s1_begins_xfer) = '1' then 
        note_1_s1_reg_firsttransfer <= note_1_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --note_1_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  note_1_s1_beginbursttransfer_internal <= note_1_s1_begins_xfer;
  --~note_1_s1_write_n assignment, which is an e_mux
  note_1_s1_write_n <= NOT ((internal_cpu_0_data_master_granted_note_1_s1 AND cpu_0_data_master_write));
  shifted_address_to_note_1_s1_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --note_1_s1_address mux, which is an e_mux
  note_1_s1_address <= A_EXT (A_SRL(shifted_address_to_note_1_s1_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_note_1_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_note_1_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_note_1_s1_end_xfer <= note_1_s1_end_xfer;
    end if;

  end process;

  --note_1_s1_waits_for_read in a cycle, which is an e_mux
  note_1_s1_waits_for_read <= note_1_s1_in_a_read_cycle AND note_1_s1_begins_xfer;
  --note_1_s1_in_a_read_cycle assignment, which is an e_assign
  note_1_s1_in_a_read_cycle <= internal_cpu_0_data_master_granted_note_1_s1 AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= note_1_s1_in_a_read_cycle;
  --note_1_s1_waits_for_write in a cycle, which is an e_mux
  note_1_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(note_1_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --note_1_s1_in_a_write_cycle assignment, which is an e_assign
  note_1_s1_in_a_write_cycle <= internal_cpu_0_data_master_granted_note_1_s1 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= note_1_s1_in_a_write_cycle;
  wait_for_note_1_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_note_1_s1 <= internal_cpu_0_data_master_granted_note_1_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_note_1_s1 <= internal_cpu_0_data_master_qualified_request_note_1_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_note_1_s1 <= internal_cpu_0_data_master_requests_note_1_s1;
--synthesis translate_off
    --note_1/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity note_2_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal note_2_s1_readdata : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_granted_note_2_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_note_2_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_note_2_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_note_2_s1 : OUT STD_LOGIC;
                 signal d1_note_2_s1_end_xfer : OUT STD_LOGIC;
                 signal note_2_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal note_2_s1_chipselect : OUT STD_LOGIC;
                 signal note_2_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
                 signal note_2_s1_reset_n : OUT STD_LOGIC;
                 signal note_2_s1_write_n : OUT STD_LOGIC;
                 signal note_2_s1_writedata : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
              );
end entity note_2_s1_arbitrator;


architecture europa of note_2_s1_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_note_2_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_note_2_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_note_2_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_note_2_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_note_2_s1 :  STD_LOGIC;
                signal note_2_s1_allgrants :  STD_LOGIC;
                signal note_2_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal note_2_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal note_2_s1_any_continuerequest :  STD_LOGIC;
                signal note_2_s1_arb_counter_enable :  STD_LOGIC;
                signal note_2_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_2_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_2_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_2_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal note_2_s1_begins_xfer :  STD_LOGIC;
                signal note_2_s1_end_xfer :  STD_LOGIC;
                signal note_2_s1_firsttransfer :  STD_LOGIC;
                signal note_2_s1_grant_vector :  STD_LOGIC;
                signal note_2_s1_in_a_read_cycle :  STD_LOGIC;
                signal note_2_s1_in_a_write_cycle :  STD_LOGIC;
                signal note_2_s1_master_qreq_vector :  STD_LOGIC;
                signal note_2_s1_non_bursting_master_requests :  STD_LOGIC;
                signal note_2_s1_reg_firsttransfer :  STD_LOGIC;
                signal note_2_s1_slavearbiterlockenable :  STD_LOGIC;
                signal note_2_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal note_2_s1_unreg_firsttransfer :  STD_LOGIC;
                signal note_2_s1_waits_for_read :  STD_LOGIC;
                signal note_2_s1_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_note_2_s1_from_cpu_0_data_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal wait_for_note_2_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT note_2_s1_end_xfer;
    end if;

  end process;

  note_2_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_note_2_s1);
  --assign note_2_s1_readdata_from_sa = note_2_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  note_2_s1_readdata_from_sa <= note_2_s1_readdata;
  internal_cpu_0_data_master_requests_note_2_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(24 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("1000000000101000010100000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --note_2_s1_arb_share_counter set values, which is an e_mux
  note_2_s1_arb_share_set_values <= std_logic_vector'("01");
  --note_2_s1_non_bursting_master_requests mux, which is an e_mux
  note_2_s1_non_bursting_master_requests <= internal_cpu_0_data_master_requests_note_2_s1;
  --note_2_s1_any_bursting_master_saved_grant mux, which is an e_mux
  note_2_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --note_2_s1_arb_share_counter_next_value assignment, which is an e_assign
  note_2_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(note_2_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (note_2_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(note_2_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (note_2_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --note_2_s1_allgrants all slave grants, which is an e_mux
  note_2_s1_allgrants <= note_2_s1_grant_vector;
  --note_2_s1_end_xfer assignment, which is an e_assign
  note_2_s1_end_xfer <= NOT ((note_2_s1_waits_for_read OR note_2_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_note_2_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_note_2_s1 <= note_2_s1_end_xfer AND (((NOT note_2_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --note_2_s1_arb_share_counter arbitration counter enable, which is an e_assign
  note_2_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_note_2_s1 AND note_2_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_note_2_s1 AND NOT note_2_s1_non_bursting_master_requests));
  --note_2_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      note_2_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(note_2_s1_arb_counter_enable) = '1' then 
        note_2_s1_arb_share_counter <= note_2_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --note_2_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      note_2_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((note_2_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_note_2_s1)) OR ((end_xfer_arb_share_counter_term_note_2_s1 AND NOT note_2_s1_non_bursting_master_requests)))) = '1' then 
        note_2_s1_slavearbiterlockenable <= or_reduce(note_2_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master note_2/s1 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= note_2_s1_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --note_2_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  note_2_s1_slavearbiterlockenable2 <= or_reduce(note_2_s1_arb_share_counter_next_value);
  --cpu_0/data_master note_2/s1 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= note_2_s1_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --note_2_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  note_2_s1_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_note_2_s1 <= internal_cpu_0_data_master_requests_note_2_s1 AND NOT (((NOT cpu_0_data_master_waitrequest) AND cpu_0_data_master_write));
  --note_2_s1_writedata mux, which is an e_mux
  note_2_s1_writedata <= cpu_0_data_master_writedata (19 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_0_data_master_granted_note_2_s1 <= internal_cpu_0_data_master_qualified_request_note_2_s1;
  --cpu_0/data_master saved-grant note_2/s1, which is an e_assign
  cpu_0_data_master_saved_grant_note_2_s1 <= internal_cpu_0_data_master_requests_note_2_s1;
  --allow new arb cycle for note_2/s1, which is an e_assign
  note_2_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  note_2_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  note_2_s1_master_qreq_vector <= std_logic'('1');
  --note_2_s1_reset_n assignment, which is an e_assign
  note_2_s1_reset_n <= reset_n;
  note_2_s1_chipselect <= internal_cpu_0_data_master_granted_note_2_s1;
  --note_2_s1_firsttransfer first transaction, which is an e_assign
  note_2_s1_firsttransfer <= A_WE_StdLogic((std_logic'(note_2_s1_begins_xfer) = '1'), note_2_s1_unreg_firsttransfer, note_2_s1_reg_firsttransfer);
  --note_2_s1_unreg_firsttransfer first transaction, which is an e_assign
  note_2_s1_unreg_firsttransfer <= NOT ((note_2_s1_slavearbiterlockenable AND note_2_s1_any_continuerequest));
  --note_2_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      note_2_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(note_2_s1_begins_xfer) = '1' then 
        note_2_s1_reg_firsttransfer <= note_2_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --note_2_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  note_2_s1_beginbursttransfer_internal <= note_2_s1_begins_xfer;
  --~note_2_s1_write_n assignment, which is an e_mux
  note_2_s1_write_n <= NOT ((internal_cpu_0_data_master_granted_note_2_s1 AND cpu_0_data_master_write));
  shifted_address_to_note_2_s1_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --note_2_s1_address mux, which is an e_mux
  note_2_s1_address <= A_EXT (A_SRL(shifted_address_to_note_2_s1_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_note_2_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_note_2_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_note_2_s1_end_xfer <= note_2_s1_end_xfer;
    end if;

  end process;

  --note_2_s1_waits_for_read in a cycle, which is an e_mux
  note_2_s1_waits_for_read <= note_2_s1_in_a_read_cycle AND note_2_s1_begins_xfer;
  --note_2_s1_in_a_read_cycle assignment, which is an e_assign
  note_2_s1_in_a_read_cycle <= internal_cpu_0_data_master_granted_note_2_s1 AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= note_2_s1_in_a_read_cycle;
  --note_2_s1_waits_for_write in a cycle, which is an e_mux
  note_2_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(note_2_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --note_2_s1_in_a_write_cycle assignment, which is an e_assign
  note_2_s1_in_a_write_cycle <= internal_cpu_0_data_master_granted_note_2_s1 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= note_2_s1_in_a_write_cycle;
  wait_for_note_2_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_note_2_s1 <= internal_cpu_0_data_master_granted_note_2_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_note_2_s1 <= internal_cpu_0_data_master_qualified_request_note_2_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_note_2_s1 <= internal_cpu_0_data_master_requests_note_2_s1;
--synthesis translate_off
    --note_2/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity note_3_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal note_3_s1_readdata : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_granted_note_3_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_note_3_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_note_3_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_note_3_s1 : OUT STD_LOGIC;
                 signal d1_note_3_s1_end_xfer : OUT STD_LOGIC;
                 signal note_3_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal note_3_s1_chipselect : OUT STD_LOGIC;
                 signal note_3_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
                 signal note_3_s1_reset_n : OUT STD_LOGIC;
                 signal note_3_s1_write_n : OUT STD_LOGIC;
                 signal note_3_s1_writedata : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
              );
end entity note_3_s1_arbitrator;


architecture europa of note_3_s1_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_note_3_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_note_3_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_note_3_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_note_3_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_note_3_s1 :  STD_LOGIC;
                signal note_3_s1_allgrants :  STD_LOGIC;
                signal note_3_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal note_3_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal note_3_s1_any_continuerequest :  STD_LOGIC;
                signal note_3_s1_arb_counter_enable :  STD_LOGIC;
                signal note_3_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_3_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_3_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_3_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal note_3_s1_begins_xfer :  STD_LOGIC;
                signal note_3_s1_end_xfer :  STD_LOGIC;
                signal note_3_s1_firsttransfer :  STD_LOGIC;
                signal note_3_s1_grant_vector :  STD_LOGIC;
                signal note_3_s1_in_a_read_cycle :  STD_LOGIC;
                signal note_3_s1_in_a_write_cycle :  STD_LOGIC;
                signal note_3_s1_master_qreq_vector :  STD_LOGIC;
                signal note_3_s1_non_bursting_master_requests :  STD_LOGIC;
                signal note_3_s1_reg_firsttransfer :  STD_LOGIC;
                signal note_3_s1_slavearbiterlockenable :  STD_LOGIC;
                signal note_3_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal note_3_s1_unreg_firsttransfer :  STD_LOGIC;
                signal note_3_s1_waits_for_read :  STD_LOGIC;
                signal note_3_s1_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_note_3_s1_from_cpu_0_data_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal wait_for_note_3_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT note_3_s1_end_xfer;
    end if;

  end process;

  note_3_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_note_3_s1);
  --assign note_3_s1_readdata_from_sa = note_3_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  note_3_s1_readdata_from_sa <= note_3_s1_readdata;
  internal_cpu_0_data_master_requests_note_3_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(24 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("1000000000101000010110000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --note_3_s1_arb_share_counter set values, which is an e_mux
  note_3_s1_arb_share_set_values <= std_logic_vector'("01");
  --note_3_s1_non_bursting_master_requests mux, which is an e_mux
  note_3_s1_non_bursting_master_requests <= internal_cpu_0_data_master_requests_note_3_s1;
  --note_3_s1_any_bursting_master_saved_grant mux, which is an e_mux
  note_3_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --note_3_s1_arb_share_counter_next_value assignment, which is an e_assign
  note_3_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(note_3_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (note_3_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(note_3_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (note_3_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --note_3_s1_allgrants all slave grants, which is an e_mux
  note_3_s1_allgrants <= note_3_s1_grant_vector;
  --note_3_s1_end_xfer assignment, which is an e_assign
  note_3_s1_end_xfer <= NOT ((note_3_s1_waits_for_read OR note_3_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_note_3_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_note_3_s1 <= note_3_s1_end_xfer AND (((NOT note_3_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --note_3_s1_arb_share_counter arbitration counter enable, which is an e_assign
  note_3_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_note_3_s1 AND note_3_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_note_3_s1 AND NOT note_3_s1_non_bursting_master_requests));
  --note_3_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      note_3_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(note_3_s1_arb_counter_enable) = '1' then 
        note_3_s1_arb_share_counter <= note_3_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --note_3_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      note_3_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((note_3_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_note_3_s1)) OR ((end_xfer_arb_share_counter_term_note_3_s1 AND NOT note_3_s1_non_bursting_master_requests)))) = '1' then 
        note_3_s1_slavearbiterlockenable <= or_reduce(note_3_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master note_3/s1 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= note_3_s1_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --note_3_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  note_3_s1_slavearbiterlockenable2 <= or_reduce(note_3_s1_arb_share_counter_next_value);
  --cpu_0/data_master note_3/s1 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= note_3_s1_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --note_3_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  note_3_s1_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_note_3_s1 <= internal_cpu_0_data_master_requests_note_3_s1 AND NOT (((NOT cpu_0_data_master_waitrequest) AND cpu_0_data_master_write));
  --note_3_s1_writedata mux, which is an e_mux
  note_3_s1_writedata <= cpu_0_data_master_writedata (19 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_0_data_master_granted_note_3_s1 <= internal_cpu_0_data_master_qualified_request_note_3_s1;
  --cpu_0/data_master saved-grant note_3/s1, which is an e_assign
  cpu_0_data_master_saved_grant_note_3_s1 <= internal_cpu_0_data_master_requests_note_3_s1;
  --allow new arb cycle for note_3/s1, which is an e_assign
  note_3_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  note_3_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  note_3_s1_master_qreq_vector <= std_logic'('1');
  --note_3_s1_reset_n assignment, which is an e_assign
  note_3_s1_reset_n <= reset_n;
  note_3_s1_chipselect <= internal_cpu_0_data_master_granted_note_3_s1;
  --note_3_s1_firsttransfer first transaction, which is an e_assign
  note_3_s1_firsttransfer <= A_WE_StdLogic((std_logic'(note_3_s1_begins_xfer) = '1'), note_3_s1_unreg_firsttransfer, note_3_s1_reg_firsttransfer);
  --note_3_s1_unreg_firsttransfer first transaction, which is an e_assign
  note_3_s1_unreg_firsttransfer <= NOT ((note_3_s1_slavearbiterlockenable AND note_3_s1_any_continuerequest));
  --note_3_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      note_3_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(note_3_s1_begins_xfer) = '1' then 
        note_3_s1_reg_firsttransfer <= note_3_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --note_3_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  note_3_s1_beginbursttransfer_internal <= note_3_s1_begins_xfer;
  --~note_3_s1_write_n assignment, which is an e_mux
  note_3_s1_write_n <= NOT ((internal_cpu_0_data_master_granted_note_3_s1 AND cpu_0_data_master_write));
  shifted_address_to_note_3_s1_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --note_3_s1_address mux, which is an e_mux
  note_3_s1_address <= A_EXT (A_SRL(shifted_address_to_note_3_s1_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_note_3_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_note_3_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_note_3_s1_end_xfer <= note_3_s1_end_xfer;
    end if;

  end process;

  --note_3_s1_waits_for_read in a cycle, which is an e_mux
  note_3_s1_waits_for_read <= note_3_s1_in_a_read_cycle AND note_3_s1_begins_xfer;
  --note_3_s1_in_a_read_cycle assignment, which is an e_assign
  note_3_s1_in_a_read_cycle <= internal_cpu_0_data_master_granted_note_3_s1 AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= note_3_s1_in_a_read_cycle;
  --note_3_s1_waits_for_write in a cycle, which is an e_mux
  note_3_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(note_3_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --note_3_s1_in_a_write_cycle assignment, which is an e_assign
  note_3_s1_in_a_write_cycle <= internal_cpu_0_data_master_granted_note_3_s1 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= note_3_s1_in_a_write_cycle;
  wait_for_note_3_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_note_3_s1 <= internal_cpu_0_data_master_granted_note_3_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_note_3_s1 <= internal_cpu_0_data_master_qualified_request_note_3_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_note_3_s1 <= internal_cpu_0_data_master_requests_note_3_s1;
--synthesis translate_off
    --note_3/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity note_4_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal note_4_s1_readdata : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_granted_note_4_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_note_4_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_note_4_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_note_4_s1 : OUT STD_LOGIC;
                 signal d1_note_4_s1_end_xfer : OUT STD_LOGIC;
                 signal note_4_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal note_4_s1_chipselect : OUT STD_LOGIC;
                 signal note_4_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
                 signal note_4_s1_reset_n : OUT STD_LOGIC;
                 signal note_4_s1_write_n : OUT STD_LOGIC;
                 signal note_4_s1_writedata : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
              );
end entity note_4_s1_arbitrator;


architecture europa of note_4_s1_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_note_4_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_note_4_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_note_4_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_note_4_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_note_4_s1 :  STD_LOGIC;
                signal note_4_s1_allgrants :  STD_LOGIC;
                signal note_4_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal note_4_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal note_4_s1_any_continuerequest :  STD_LOGIC;
                signal note_4_s1_arb_counter_enable :  STD_LOGIC;
                signal note_4_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_4_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_4_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_4_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal note_4_s1_begins_xfer :  STD_LOGIC;
                signal note_4_s1_end_xfer :  STD_LOGIC;
                signal note_4_s1_firsttransfer :  STD_LOGIC;
                signal note_4_s1_grant_vector :  STD_LOGIC;
                signal note_4_s1_in_a_read_cycle :  STD_LOGIC;
                signal note_4_s1_in_a_write_cycle :  STD_LOGIC;
                signal note_4_s1_master_qreq_vector :  STD_LOGIC;
                signal note_4_s1_non_bursting_master_requests :  STD_LOGIC;
                signal note_4_s1_reg_firsttransfer :  STD_LOGIC;
                signal note_4_s1_slavearbiterlockenable :  STD_LOGIC;
                signal note_4_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal note_4_s1_unreg_firsttransfer :  STD_LOGIC;
                signal note_4_s1_waits_for_read :  STD_LOGIC;
                signal note_4_s1_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_note_4_s1_from_cpu_0_data_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal wait_for_note_4_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT note_4_s1_end_xfer;
    end if;

  end process;

  note_4_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_note_4_s1);
  --assign note_4_s1_readdata_from_sa = note_4_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  note_4_s1_readdata_from_sa <= note_4_s1_readdata;
  internal_cpu_0_data_master_requests_note_4_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(24 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("1000000000101000011000000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --note_4_s1_arb_share_counter set values, which is an e_mux
  note_4_s1_arb_share_set_values <= std_logic_vector'("01");
  --note_4_s1_non_bursting_master_requests mux, which is an e_mux
  note_4_s1_non_bursting_master_requests <= internal_cpu_0_data_master_requests_note_4_s1;
  --note_4_s1_any_bursting_master_saved_grant mux, which is an e_mux
  note_4_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --note_4_s1_arb_share_counter_next_value assignment, which is an e_assign
  note_4_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(note_4_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (note_4_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(note_4_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (note_4_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --note_4_s1_allgrants all slave grants, which is an e_mux
  note_4_s1_allgrants <= note_4_s1_grant_vector;
  --note_4_s1_end_xfer assignment, which is an e_assign
  note_4_s1_end_xfer <= NOT ((note_4_s1_waits_for_read OR note_4_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_note_4_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_note_4_s1 <= note_4_s1_end_xfer AND (((NOT note_4_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --note_4_s1_arb_share_counter arbitration counter enable, which is an e_assign
  note_4_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_note_4_s1 AND note_4_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_note_4_s1 AND NOT note_4_s1_non_bursting_master_requests));
  --note_4_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      note_4_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(note_4_s1_arb_counter_enable) = '1' then 
        note_4_s1_arb_share_counter <= note_4_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --note_4_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      note_4_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((note_4_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_note_4_s1)) OR ((end_xfer_arb_share_counter_term_note_4_s1 AND NOT note_4_s1_non_bursting_master_requests)))) = '1' then 
        note_4_s1_slavearbiterlockenable <= or_reduce(note_4_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master note_4/s1 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= note_4_s1_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --note_4_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  note_4_s1_slavearbiterlockenable2 <= or_reduce(note_4_s1_arb_share_counter_next_value);
  --cpu_0/data_master note_4/s1 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= note_4_s1_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --note_4_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  note_4_s1_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_note_4_s1 <= internal_cpu_0_data_master_requests_note_4_s1 AND NOT (((NOT cpu_0_data_master_waitrequest) AND cpu_0_data_master_write));
  --note_4_s1_writedata mux, which is an e_mux
  note_4_s1_writedata <= cpu_0_data_master_writedata (19 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_0_data_master_granted_note_4_s1 <= internal_cpu_0_data_master_qualified_request_note_4_s1;
  --cpu_0/data_master saved-grant note_4/s1, which is an e_assign
  cpu_0_data_master_saved_grant_note_4_s1 <= internal_cpu_0_data_master_requests_note_4_s1;
  --allow new arb cycle for note_4/s1, which is an e_assign
  note_4_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  note_4_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  note_4_s1_master_qreq_vector <= std_logic'('1');
  --note_4_s1_reset_n assignment, which is an e_assign
  note_4_s1_reset_n <= reset_n;
  note_4_s1_chipselect <= internal_cpu_0_data_master_granted_note_4_s1;
  --note_4_s1_firsttransfer first transaction, which is an e_assign
  note_4_s1_firsttransfer <= A_WE_StdLogic((std_logic'(note_4_s1_begins_xfer) = '1'), note_4_s1_unreg_firsttransfer, note_4_s1_reg_firsttransfer);
  --note_4_s1_unreg_firsttransfer first transaction, which is an e_assign
  note_4_s1_unreg_firsttransfer <= NOT ((note_4_s1_slavearbiterlockenable AND note_4_s1_any_continuerequest));
  --note_4_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      note_4_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(note_4_s1_begins_xfer) = '1' then 
        note_4_s1_reg_firsttransfer <= note_4_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --note_4_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  note_4_s1_beginbursttransfer_internal <= note_4_s1_begins_xfer;
  --~note_4_s1_write_n assignment, which is an e_mux
  note_4_s1_write_n <= NOT ((internal_cpu_0_data_master_granted_note_4_s1 AND cpu_0_data_master_write));
  shifted_address_to_note_4_s1_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --note_4_s1_address mux, which is an e_mux
  note_4_s1_address <= A_EXT (A_SRL(shifted_address_to_note_4_s1_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_note_4_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_note_4_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_note_4_s1_end_xfer <= note_4_s1_end_xfer;
    end if;

  end process;

  --note_4_s1_waits_for_read in a cycle, which is an e_mux
  note_4_s1_waits_for_read <= note_4_s1_in_a_read_cycle AND note_4_s1_begins_xfer;
  --note_4_s1_in_a_read_cycle assignment, which is an e_assign
  note_4_s1_in_a_read_cycle <= internal_cpu_0_data_master_granted_note_4_s1 AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= note_4_s1_in_a_read_cycle;
  --note_4_s1_waits_for_write in a cycle, which is an e_mux
  note_4_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(note_4_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --note_4_s1_in_a_write_cycle assignment, which is an e_assign
  note_4_s1_in_a_write_cycle <= internal_cpu_0_data_master_granted_note_4_s1 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= note_4_s1_in_a_write_cycle;
  wait_for_note_4_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_note_4_s1 <= internal_cpu_0_data_master_granted_note_4_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_note_4_s1 <= internal_cpu_0_data_master_qualified_request_note_4_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_note_4_s1 <= internal_cpu_0_data_master_requests_note_4_s1;
--synthesis translate_off
    --note_4/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity note_5_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal note_5_s1_readdata : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_granted_note_5_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_note_5_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_note_5_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_note_5_s1 : OUT STD_LOGIC;
                 signal d1_note_5_s1_end_xfer : OUT STD_LOGIC;
                 signal note_5_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal note_5_s1_chipselect : OUT STD_LOGIC;
                 signal note_5_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
                 signal note_5_s1_reset_n : OUT STD_LOGIC;
                 signal note_5_s1_write_n : OUT STD_LOGIC;
                 signal note_5_s1_writedata : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
              );
end entity note_5_s1_arbitrator;


architecture europa of note_5_s1_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_note_5_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_note_5_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_note_5_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_note_5_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_note_5_s1 :  STD_LOGIC;
                signal note_5_s1_allgrants :  STD_LOGIC;
                signal note_5_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal note_5_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal note_5_s1_any_continuerequest :  STD_LOGIC;
                signal note_5_s1_arb_counter_enable :  STD_LOGIC;
                signal note_5_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_5_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_5_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_5_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal note_5_s1_begins_xfer :  STD_LOGIC;
                signal note_5_s1_end_xfer :  STD_LOGIC;
                signal note_5_s1_firsttransfer :  STD_LOGIC;
                signal note_5_s1_grant_vector :  STD_LOGIC;
                signal note_5_s1_in_a_read_cycle :  STD_LOGIC;
                signal note_5_s1_in_a_write_cycle :  STD_LOGIC;
                signal note_5_s1_master_qreq_vector :  STD_LOGIC;
                signal note_5_s1_non_bursting_master_requests :  STD_LOGIC;
                signal note_5_s1_reg_firsttransfer :  STD_LOGIC;
                signal note_5_s1_slavearbiterlockenable :  STD_LOGIC;
                signal note_5_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal note_5_s1_unreg_firsttransfer :  STD_LOGIC;
                signal note_5_s1_waits_for_read :  STD_LOGIC;
                signal note_5_s1_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_note_5_s1_from_cpu_0_data_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal wait_for_note_5_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT note_5_s1_end_xfer;
    end if;

  end process;

  note_5_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_note_5_s1);
  --assign note_5_s1_readdata_from_sa = note_5_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  note_5_s1_readdata_from_sa <= note_5_s1_readdata;
  internal_cpu_0_data_master_requests_note_5_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(24 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("1000000000101000011010000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --note_5_s1_arb_share_counter set values, which is an e_mux
  note_5_s1_arb_share_set_values <= std_logic_vector'("01");
  --note_5_s1_non_bursting_master_requests mux, which is an e_mux
  note_5_s1_non_bursting_master_requests <= internal_cpu_0_data_master_requests_note_5_s1;
  --note_5_s1_any_bursting_master_saved_grant mux, which is an e_mux
  note_5_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --note_5_s1_arb_share_counter_next_value assignment, which is an e_assign
  note_5_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(note_5_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (note_5_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(note_5_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (note_5_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --note_5_s1_allgrants all slave grants, which is an e_mux
  note_5_s1_allgrants <= note_5_s1_grant_vector;
  --note_5_s1_end_xfer assignment, which is an e_assign
  note_5_s1_end_xfer <= NOT ((note_5_s1_waits_for_read OR note_5_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_note_5_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_note_5_s1 <= note_5_s1_end_xfer AND (((NOT note_5_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --note_5_s1_arb_share_counter arbitration counter enable, which is an e_assign
  note_5_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_note_5_s1 AND note_5_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_note_5_s1 AND NOT note_5_s1_non_bursting_master_requests));
  --note_5_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      note_5_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(note_5_s1_arb_counter_enable) = '1' then 
        note_5_s1_arb_share_counter <= note_5_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --note_5_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      note_5_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((note_5_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_note_5_s1)) OR ((end_xfer_arb_share_counter_term_note_5_s1 AND NOT note_5_s1_non_bursting_master_requests)))) = '1' then 
        note_5_s1_slavearbiterlockenable <= or_reduce(note_5_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master note_5/s1 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= note_5_s1_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --note_5_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  note_5_s1_slavearbiterlockenable2 <= or_reduce(note_5_s1_arb_share_counter_next_value);
  --cpu_0/data_master note_5/s1 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= note_5_s1_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --note_5_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  note_5_s1_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_note_5_s1 <= internal_cpu_0_data_master_requests_note_5_s1 AND NOT (((NOT cpu_0_data_master_waitrequest) AND cpu_0_data_master_write));
  --note_5_s1_writedata mux, which is an e_mux
  note_5_s1_writedata <= cpu_0_data_master_writedata (19 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_0_data_master_granted_note_5_s1 <= internal_cpu_0_data_master_qualified_request_note_5_s1;
  --cpu_0/data_master saved-grant note_5/s1, which is an e_assign
  cpu_0_data_master_saved_grant_note_5_s1 <= internal_cpu_0_data_master_requests_note_5_s1;
  --allow new arb cycle for note_5/s1, which is an e_assign
  note_5_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  note_5_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  note_5_s1_master_qreq_vector <= std_logic'('1');
  --note_5_s1_reset_n assignment, which is an e_assign
  note_5_s1_reset_n <= reset_n;
  note_5_s1_chipselect <= internal_cpu_0_data_master_granted_note_5_s1;
  --note_5_s1_firsttransfer first transaction, which is an e_assign
  note_5_s1_firsttransfer <= A_WE_StdLogic((std_logic'(note_5_s1_begins_xfer) = '1'), note_5_s1_unreg_firsttransfer, note_5_s1_reg_firsttransfer);
  --note_5_s1_unreg_firsttransfer first transaction, which is an e_assign
  note_5_s1_unreg_firsttransfer <= NOT ((note_5_s1_slavearbiterlockenable AND note_5_s1_any_continuerequest));
  --note_5_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      note_5_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(note_5_s1_begins_xfer) = '1' then 
        note_5_s1_reg_firsttransfer <= note_5_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --note_5_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  note_5_s1_beginbursttransfer_internal <= note_5_s1_begins_xfer;
  --~note_5_s1_write_n assignment, which is an e_mux
  note_5_s1_write_n <= NOT ((internal_cpu_0_data_master_granted_note_5_s1 AND cpu_0_data_master_write));
  shifted_address_to_note_5_s1_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --note_5_s1_address mux, which is an e_mux
  note_5_s1_address <= A_EXT (A_SRL(shifted_address_to_note_5_s1_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_note_5_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_note_5_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_note_5_s1_end_xfer <= note_5_s1_end_xfer;
    end if;

  end process;

  --note_5_s1_waits_for_read in a cycle, which is an e_mux
  note_5_s1_waits_for_read <= note_5_s1_in_a_read_cycle AND note_5_s1_begins_xfer;
  --note_5_s1_in_a_read_cycle assignment, which is an e_assign
  note_5_s1_in_a_read_cycle <= internal_cpu_0_data_master_granted_note_5_s1 AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= note_5_s1_in_a_read_cycle;
  --note_5_s1_waits_for_write in a cycle, which is an e_mux
  note_5_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(note_5_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --note_5_s1_in_a_write_cycle assignment, which is an e_assign
  note_5_s1_in_a_write_cycle <= internal_cpu_0_data_master_granted_note_5_s1 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= note_5_s1_in_a_write_cycle;
  wait_for_note_5_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_note_5_s1 <= internal_cpu_0_data_master_granted_note_5_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_note_5_s1 <= internal_cpu_0_data_master_qualified_request_note_5_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_note_5_s1 <= internal_cpu_0_data_master_requests_note_5_s1;
--synthesis translate_off
    --note_5/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity onchip_memory2_0_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_instruction_master_read : IN STD_LOGIC;
                 signal onchip_memory2_0_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_granted_onchip_memory2_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_onchip_memory2_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_onchip_memory2_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_granted_onchip_memory2_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_requests_onchip_memory2_0_s1 : OUT STD_LOGIC;
                 signal d1_onchip_memory2_0_s1_end_xfer : OUT STD_LOGIC;
                 signal onchip_memory2_0_s1_address : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
                 signal onchip_memory2_0_s1_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal onchip_memory2_0_s1_chipselect : OUT STD_LOGIC;
                 signal onchip_memory2_0_s1_clken : OUT STD_LOGIC;
                 signal onchip_memory2_0_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal onchip_memory2_0_s1_reset : OUT STD_LOGIC;
                 signal onchip_memory2_0_s1_write : OUT STD_LOGIC;
                 signal onchip_memory2_0_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal registered_cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 : OUT STD_LOGIC
              );
end entity onchip_memory2_0_s1_arbitrator;


architecture europa of onchip_memory2_0_s1_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register_in :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_onchip_memory2_0_s1 :  STD_LOGIC;
                signal cpu_0_instruction_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_instruction_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_instruction_master_continuerequest :  STD_LOGIC;
                signal cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register :  STD_LOGIC;
                signal cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register_in :  STD_LOGIC;
                signal cpu_0_instruction_master_saved_grant_onchip_memory2_0_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_onchip_memory2_0_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_onchip_memory2_0_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_onchip_memory2_0_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_onchip_memory2_0_s1 :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_granted_onchip_memory2_0_s1 :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1 :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_requests_onchip_memory2_0_s1 :  STD_LOGIC;
                signal last_cycle_cpu_0_data_master_granted_slave_onchip_memory2_0_s1 :  STD_LOGIC;
                signal last_cycle_cpu_0_instruction_master_granted_slave_onchip_memory2_0_s1 :  STD_LOGIC;
                signal onchip_memory2_0_s1_allgrants :  STD_LOGIC;
                signal onchip_memory2_0_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal onchip_memory2_0_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal onchip_memory2_0_s1_any_continuerequest :  STD_LOGIC;
                signal onchip_memory2_0_s1_arb_addend :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal onchip_memory2_0_s1_arb_counter_enable :  STD_LOGIC;
                signal onchip_memory2_0_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal onchip_memory2_0_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal onchip_memory2_0_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal onchip_memory2_0_s1_arb_winner :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal onchip_memory2_0_s1_arbitration_holdoff_internal :  STD_LOGIC;
                signal onchip_memory2_0_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal onchip_memory2_0_s1_begins_xfer :  STD_LOGIC;
                signal onchip_memory2_0_s1_chosen_master_double_vector :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal onchip_memory2_0_s1_chosen_master_rot_left :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal onchip_memory2_0_s1_end_xfer :  STD_LOGIC;
                signal onchip_memory2_0_s1_firsttransfer :  STD_LOGIC;
                signal onchip_memory2_0_s1_grant_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal onchip_memory2_0_s1_in_a_read_cycle :  STD_LOGIC;
                signal onchip_memory2_0_s1_in_a_write_cycle :  STD_LOGIC;
                signal onchip_memory2_0_s1_master_qreq_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal onchip_memory2_0_s1_non_bursting_master_requests :  STD_LOGIC;
                signal onchip_memory2_0_s1_reg_firsttransfer :  STD_LOGIC;
                signal onchip_memory2_0_s1_saved_chosen_master_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal onchip_memory2_0_s1_slavearbiterlockenable :  STD_LOGIC;
                signal onchip_memory2_0_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal onchip_memory2_0_s1_unreg_firsttransfer :  STD_LOGIC;
                signal onchip_memory2_0_s1_waits_for_read :  STD_LOGIC;
                signal onchip_memory2_0_s1_waits_for_write :  STD_LOGIC;
                signal p1_cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register :  STD_LOGIC;
                signal p1_cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register :  STD_LOGIC;
                signal shifted_address_to_onchip_memory2_0_s1_from_cpu_0_data_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal shifted_address_to_onchip_memory2_0_s1_from_cpu_0_instruction_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal wait_for_onchip_memory2_0_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT onchip_memory2_0_s1_end_xfer;
    end if;

  end process;

  onchip_memory2_0_s1_begins_xfer <= NOT d1_reasons_to_wait AND ((internal_cpu_0_data_master_qualified_request_onchip_memory2_0_s1 OR internal_cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1));
  --assign onchip_memory2_0_s1_readdata_from_sa = onchip_memory2_0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  onchip_memory2_0_s1_readdata_from_sa <= onchip_memory2_0_s1_readdata;
  internal_cpu_0_data_master_requests_onchip_memory2_0_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(24 DOWNTO 13) & std_logic_vector'("0000000000000")) = std_logic_vector'("1000000000010000000000000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --registered rdv signal_name registered_cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 assignment, which is an e_assign
  registered_cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 <= cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register_in;
  --onchip_memory2_0_s1_arb_share_counter set values, which is an e_mux
  onchip_memory2_0_s1_arb_share_set_values <= std_logic_vector'("01");
  --onchip_memory2_0_s1_non_bursting_master_requests mux, which is an e_mux
  onchip_memory2_0_s1_non_bursting_master_requests <= ((internal_cpu_0_data_master_requests_onchip_memory2_0_s1 OR internal_cpu_0_instruction_master_requests_onchip_memory2_0_s1) OR internal_cpu_0_data_master_requests_onchip_memory2_0_s1) OR internal_cpu_0_instruction_master_requests_onchip_memory2_0_s1;
  --onchip_memory2_0_s1_any_bursting_master_saved_grant mux, which is an e_mux
  onchip_memory2_0_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --onchip_memory2_0_s1_arb_share_counter_next_value assignment, which is an e_assign
  onchip_memory2_0_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(onchip_memory2_0_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (onchip_memory2_0_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(onchip_memory2_0_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (onchip_memory2_0_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --onchip_memory2_0_s1_allgrants all slave grants, which is an e_mux
  onchip_memory2_0_s1_allgrants <= (((or_reduce(onchip_memory2_0_s1_grant_vector)) OR (or_reduce(onchip_memory2_0_s1_grant_vector))) OR (or_reduce(onchip_memory2_0_s1_grant_vector))) OR (or_reduce(onchip_memory2_0_s1_grant_vector));
  --onchip_memory2_0_s1_end_xfer assignment, which is an e_assign
  onchip_memory2_0_s1_end_xfer <= NOT ((onchip_memory2_0_s1_waits_for_read OR onchip_memory2_0_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_onchip_memory2_0_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_onchip_memory2_0_s1 <= onchip_memory2_0_s1_end_xfer AND (((NOT onchip_memory2_0_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --onchip_memory2_0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  onchip_memory2_0_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_onchip_memory2_0_s1 AND onchip_memory2_0_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_onchip_memory2_0_s1 AND NOT onchip_memory2_0_s1_non_bursting_master_requests));
  --onchip_memory2_0_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      onchip_memory2_0_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(onchip_memory2_0_s1_arb_counter_enable) = '1' then 
        onchip_memory2_0_s1_arb_share_counter <= onchip_memory2_0_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --onchip_memory2_0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      onchip_memory2_0_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((or_reduce(onchip_memory2_0_s1_master_qreq_vector) AND end_xfer_arb_share_counter_term_onchip_memory2_0_s1)) OR ((end_xfer_arb_share_counter_term_onchip_memory2_0_s1 AND NOT onchip_memory2_0_s1_non_bursting_master_requests)))) = '1' then 
        onchip_memory2_0_s1_slavearbiterlockenable <= or_reduce(onchip_memory2_0_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master onchip_memory2_0/s1 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= onchip_memory2_0_s1_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --onchip_memory2_0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  onchip_memory2_0_s1_slavearbiterlockenable2 <= or_reduce(onchip_memory2_0_s1_arb_share_counter_next_value);
  --cpu_0/data_master onchip_memory2_0/s1 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= onchip_memory2_0_s1_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --cpu_0/instruction_master onchip_memory2_0/s1 arbiterlock, which is an e_assign
  cpu_0_instruction_master_arbiterlock <= onchip_memory2_0_s1_slavearbiterlockenable AND cpu_0_instruction_master_continuerequest;
  --cpu_0/instruction_master onchip_memory2_0/s1 arbiterlock2, which is an e_assign
  cpu_0_instruction_master_arbiterlock2 <= onchip_memory2_0_s1_slavearbiterlockenable2 AND cpu_0_instruction_master_continuerequest;
  --cpu_0/instruction_master granted onchip_memory2_0/s1 last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_0_instruction_master_granted_slave_onchip_memory2_0_s1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_0_instruction_master_granted_slave_onchip_memory2_0_s1 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_0_instruction_master_saved_grant_onchip_memory2_0_s1) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((onchip_memory2_0_s1_arbitration_holdoff_internal OR NOT internal_cpu_0_instruction_master_requests_onchip_memory2_0_s1))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_0_instruction_master_granted_slave_onchip_memory2_0_s1))))));
    end if;

  end process;

  --cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  cpu_0_instruction_master_continuerequest <= last_cycle_cpu_0_instruction_master_granted_slave_onchip_memory2_0_s1 AND internal_cpu_0_instruction_master_requests_onchip_memory2_0_s1;
  --onchip_memory2_0_s1_any_continuerequest at least one master continues requesting, which is an e_mux
  onchip_memory2_0_s1_any_continuerequest <= cpu_0_instruction_master_continuerequest OR cpu_0_data_master_continuerequest;
  internal_cpu_0_data_master_qualified_request_onchip_memory2_0_s1 <= internal_cpu_0_data_master_requests_onchip_memory2_0_s1 AND NOT (((((cpu_0_data_master_read AND (cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register))) OR (((NOT cpu_0_data_master_waitrequest) AND cpu_0_data_master_write))) OR cpu_0_instruction_master_arbiterlock));
  --cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register_in <= ((internal_cpu_0_data_master_granted_onchip_memory2_0_s1 AND cpu_0_data_master_read) AND NOT onchip_memory2_0_s1_waits_for_read) AND NOT (cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register);
  --shift register p1 cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  p1_cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register <= Vector_To_Std_Logic(Std_Logic_Vector'(A_ToStdLogicVector(cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register) & A_ToStdLogicVector(cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register_in)));
  --cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register <= std_logic'('0');
    elsif clk'event and clk = '1' then
      cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register <= p1_cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register;
    end if;

  end process;

  --local readdatavalid cpu_0_data_master_read_data_valid_onchip_memory2_0_s1, which is an e_mux
  cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 <= cpu_0_data_master_read_data_valid_onchip_memory2_0_s1_shift_register;
  --onchip_memory2_0_s1_writedata mux, which is an e_mux
  onchip_memory2_0_s1_writedata <= cpu_0_data_master_writedata;
  --mux onchip_memory2_0_s1_clken, which is an e_mux
  onchip_memory2_0_s1_clken <= std_logic'('1');
  internal_cpu_0_instruction_master_requests_onchip_memory2_0_s1 <= ((to_std_logic(((Std_Logic_Vector'(cpu_0_instruction_master_address_to_slave(24 DOWNTO 13) & std_logic_vector'("0000000000000")) = std_logic_vector'("1000000000010000000000000")))) AND (cpu_0_instruction_master_read))) AND cpu_0_instruction_master_read;
  --cpu_0/data_master granted onchip_memory2_0/s1 last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_0_data_master_granted_slave_onchip_memory2_0_s1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_0_data_master_granted_slave_onchip_memory2_0_s1 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_0_data_master_saved_grant_onchip_memory2_0_s1) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((onchip_memory2_0_s1_arbitration_holdoff_internal OR NOT internal_cpu_0_data_master_requests_onchip_memory2_0_s1))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_0_data_master_granted_slave_onchip_memory2_0_s1))))));
    end if;

  end process;

  --cpu_0_data_master_continuerequest continued request, which is an e_mux
  cpu_0_data_master_continuerequest <= last_cycle_cpu_0_data_master_granted_slave_onchip_memory2_0_s1 AND internal_cpu_0_data_master_requests_onchip_memory2_0_s1;
  internal_cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1 <= internal_cpu_0_instruction_master_requests_onchip_memory2_0_s1 AND NOT ((((cpu_0_instruction_master_read AND (cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register))) OR cpu_0_data_master_arbiterlock));
  --cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register_in <= ((internal_cpu_0_instruction_master_granted_onchip_memory2_0_s1 AND cpu_0_instruction_master_read) AND NOT onchip_memory2_0_s1_waits_for_read) AND NOT (cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register);
  --shift register p1 cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  p1_cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register <= Vector_To_Std_Logic(Std_Logic_Vector'(A_ToStdLogicVector(cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register) & A_ToStdLogicVector(cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register_in)));
  --cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register <= std_logic'('0');
    elsif clk'event and clk = '1' then
      cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register <= p1_cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register;
    end if;

  end process;

  --local readdatavalid cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1, which is an e_mux
  cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1 <= cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1_shift_register;
  --allow new arb cycle for onchip_memory2_0/s1, which is an e_assign
  onchip_memory2_0_s1_allow_new_arb_cycle <= NOT cpu_0_data_master_arbiterlock AND NOT cpu_0_instruction_master_arbiterlock;
  --cpu_0/instruction_master assignment into master qualified-requests vector for onchip_memory2_0/s1, which is an e_assign
  onchip_memory2_0_s1_master_qreq_vector(0) <= internal_cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1;
  --cpu_0/instruction_master grant onchip_memory2_0/s1, which is an e_assign
  internal_cpu_0_instruction_master_granted_onchip_memory2_0_s1 <= onchip_memory2_0_s1_grant_vector(0);
  --cpu_0/instruction_master saved-grant onchip_memory2_0/s1, which is an e_assign
  cpu_0_instruction_master_saved_grant_onchip_memory2_0_s1 <= onchip_memory2_0_s1_arb_winner(0) AND internal_cpu_0_instruction_master_requests_onchip_memory2_0_s1;
  --cpu_0/data_master assignment into master qualified-requests vector for onchip_memory2_0/s1, which is an e_assign
  onchip_memory2_0_s1_master_qreq_vector(1) <= internal_cpu_0_data_master_qualified_request_onchip_memory2_0_s1;
  --cpu_0/data_master grant onchip_memory2_0/s1, which is an e_assign
  internal_cpu_0_data_master_granted_onchip_memory2_0_s1 <= onchip_memory2_0_s1_grant_vector(1);
  --cpu_0/data_master saved-grant onchip_memory2_0/s1, which is an e_assign
  cpu_0_data_master_saved_grant_onchip_memory2_0_s1 <= onchip_memory2_0_s1_arb_winner(1) AND internal_cpu_0_data_master_requests_onchip_memory2_0_s1;
  --onchip_memory2_0/s1 chosen-master double-vector, which is an e_assign
  onchip_memory2_0_s1_chosen_master_double_vector <= A_EXT (((std_logic_vector'("0") & ((onchip_memory2_0_s1_master_qreq_vector & onchip_memory2_0_s1_master_qreq_vector))) AND (((std_logic_vector'("0") & (Std_Logic_Vector'(NOT onchip_memory2_0_s1_master_qreq_vector & NOT onchip_memory2_0_s1_master_qreq_vector))) + (std_logic_vector'("000") & (onchip_memory2_0_s1_arb_addend))))), 4);
  --stable onehot encoding of arb winner
  onchip_memory2_0_s1_arb_winner <= A_WE_StdLogicVector((std_logic'(((onchip_memory2_0_s1_allow_new_arb_cycle AND or_reduce(onchip_memory2_0_s1_grant_vector)))) = '1'), onchip_memory2_0_s1_grant_vector, onchip_memory2_0_s1_saved_chosen_master_vector);
  --saved onchip_memory2_0_s1_grant_vector, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      onchip_memory2_0_s1_saved_chosen_master_vector <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(onchip_memory2_0_s1_allow_new_arb_cycle) = '1' then 
        onchip_memory2_0_s1_saved_chosen_master_vector <= A_WE_StdLogicVector((std_logic'(or_reduce(onchip_memory2_0_s1_grant_vector)) = '1'), onchip_memory2_0_s1_grant_vector, onchip_memory2_0_s1_saved_chosen_master_vector);
      end if;
    end if;

  end process;

  --onehot encoding of chosen master
  onchip_memory2_0_s1_grant_vector <= Std_Logic_Vector'(A_ToStdLogicVector(((onchip_memory2_0_s1_chosen_master_double_vector(1) OR onchip_memory2_0_s1_chosen_master_double_vector(3)))) & A_ToStdLogicVector(((onchip_memory2_0_s1_chosen_master_double_vector(0) OR onchip_memory2_0_s1_chosen_master_double_vector(2)))));
  --onchip_memory2_0/s1 chosen master rotated left, which is an e_assign
  onchip_memory2_0_s1_chosen_master_rot_left <= A_EXT (A_WE_StdLogicVector((((A_SLL(onchip_memory2_0_s1_arb_winner,std_logic_vector'("00000000000000000000000000000001")))) /= std_logic_vector'("00")), (std_logic_vector'("000000000000000000000000000000") & ((A_SLL(onchip_memory2_0_s1_arb_winner,std_logic_vector'("00000000000000000000000000000001"))))), std_logic_vector'("00000000000000000000000000000001")), 2);
  --onchip_memory2_0/s1's addend for next-master-grant
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      onchip_memory2_0_s1_arb_addend <= std_logic_vector'("01");
    elsif clk'event and clk = '1' then
      if std_logic'(or_reduce(onchip_memory2_0_s1_grant_vector)) = '1' then 
        onchip_memory2_0_s1_arb_addend <= A_WE_StdLogicVector((std_logic'(onchip_memory2_0_s1_end_xfer) = '1'), onchip_memory2_0_s1_chosen_master_rot_left, onchip_memory2_0_s1_grant_vector);
      end if;
    end if;

  end process;

  --~onchip_memory2_0_s1_reset assignment, which is an e_assign
  onchip_memory2_0_s1_reset <= NOT reset_n;
  onchip_memory2_0_s1_chipselect <= internal_cpu_0_data_master_granted_onchip_memory2_0_s1 OR internal_cpu_0_instruction_master_granted_onchip_memory2_0_s1;
  --onchip_memory2_0_s1_firsttransfer first transaction, which is an e_assign
  onchip_memory2_0_s1_firsttransfer <= A_WE_StdLogic((std_logic'(onchip_memory2_0_s1_begins_xfer) = '1'), onchip_memory2_0_s1_unreg_firsttransfer, onchip_memory2_0_s1_reg_firsttransfer);
  --onchip_memory2_0_s1_unreg_firsttransfer first transaction, which is an e_assign
  onchip_memory2_0_s1_unreg_firsttransfer <= NOT ((onchip_memory2_0_s1_slavearbiterlockenable AND onchip_memory2_0_s1_any_continuerequest));
  --onchip_memory2_0_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      onchip_memory2_0_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(onchip_memory2_0_s1_begins_xfer) = '1' then 
        onchip_memory2_0_s1_reg_firsttransfer <= onchip_memory2_0_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --onchip_memory2_0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  onchip_memory2_0_s1_beginbursttransfer_internal <= onchip_memory2_0_s1_begins_xfer;
  --onchip_memory2_0_s1_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  onchip_memory2_0_s1_arbitration_holdoff_internal <= onchip_memory2_0_s1_begins_xfer AND onchip_memory2_0_s1_firsttransfer;
  --onchip_memory2_0_s1_write assignment, which is an e_mux
  onchip_memory2_0_s1_write <= internal_cpu_0_data_master_granted_onchip_memory2_0_s1 AND cpu_0_data_master_write;
  shifted_address_to_onchip_memory2_0_s1_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --onchip_memory2_0_s1_address mux, which is an e_mux
  onchip_memory2_0_s1_address <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_onchip_memory2_0_s1)) = '1'), (A_SRL(shifted_address_to_onchip_memory2_0_s1_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010"))), (A_SRL(shifted_address_to_onchip_memory2_0_s1_from_cpu_0_instruction_master,std_logic_vector'("00000000000000000000000000000010")))), 11);
  shifted_address_to_onchip_memory2_0_s1_from_cpu_0_instruction_master <= cpu_0_instruction_master_address_to_slave;
  --d1_onchip_memory2_0_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_onchip_memory2_0_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_onchip_memory2_0_s1_end_xfer <= onchip_memory2_0_s1_end_xfer;
    end if;

  end process;

  --onchip_memory2_0_s1_waits_for_read in a cycle, which is an e_mux
  onchip_memory2_0_s1_waits_for_read <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(onchip_memory2_0_s1_in_a_read_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --onchip_memory2_0_s1_in_a_read_cycle assignment, which is an e_assign
  onchip_memory2_0_s1_in_a_read_cycle <= ((internal_cpu_0_data_master_granted_onchip_memory2_0_s1 AND cpu_0_data_master_read)) OR ((internal_cpu_0_instruction_master_granted_onchip_memory2_0_s1 AND cpu_0_instruction_master_read));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= onchip_memory2_0_s1_in_a_read_cycle;
  --onchip_memory2_0_s1_waits_for_write in a cycle, which is an e_mux
  onchip_memory2_0_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(onchip_memory2_0_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --onchip_memory2_0_s1_in_a_write_cycle assignment, which is an e_assign
  onchip_memory2_0_s1_in_a_write_cycle <= internal_cpu_0_data_master_granted_onchip_memory2_0_s1 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= onchip_memory2_0_s1_in_a_write_cycle;
  wait_for_onchip_memory2_0_s1_counter <= std_logic'('0');
  --onchip_memory2_0_s1_byteenable byte enable port mux, which is an e_mux
  onchip_memory2_0_s1_byteenable <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_onchip_memory2_0_s1)) = '1'), (std_logic_vector'("0000000000000000000000000000") & (cpu_0_data_master_byteenable)), -SIGNED(std_logic_vector'("00000000000000000000000000000001"))), 4);
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_onchip_memory2_0_s1 <= internal_cpu_0_data_master_granted_onchip_memory2_0_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_onchip_memory2_0_s1 <= internal_cpu_0_data_master_qualified_request_onchip_memory2_0_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_onchip_memory2_0_s1 <= internal_cpu_0_data_master_requests_onchip_memory2_0_s1;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_granted_onchip_memory2_0_s1 <= internal_cpu_0_instruction_master_granted_onchip_memory2_0_s1;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1 <= internal_cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_requests_onchip_memory2_0_s1 <= internal_cpu_0_instruction_master_requests_onchip_memory2_0_s1;
--synthesis translate_off
    --onchip_memory2_0/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line4 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_0_data_master_granted_onchip_memory2_0_s1))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_0_instruction_master_granted_onchip_memory2_0_s1))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line4, now);
          write(write_line4, string'(": "));
          write(write_line4, string'("> 1 of grant signals are active simultaneously"));
          write(output, write_line4.all);
          deallocate (write_line4);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --saved_grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line5 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_saved_grant_onchip_memory2_0_s1))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_0_instruction_master_saved_grant_onchip_memory2_0_s1))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line5, now);
          write(write_line5, string'(": "));
          write(write_line5, string'("> 1 of saved_grant signals are active simultaneously"));
          write(output, write_line5.all);
          deallocate (write_line5);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1_module;


architecture europa of rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal full_2 :  STD_LOGIC;
                signal full_3 :  STD_LOGIC;
                signal full_4 :  STD_LOGIC;
                signal full_5 :  STD_LOGIC;
                signal full_6 :  STD_LOGIC;
                signal full_7 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal p1_full_1 :  STD_LOGIC;
                signal p1_stage_1 :  STD_LOGIC;
                signal p2_full_2 :  STD_LOGIC;
                signal p2_stage_2 :  STD_LOGIC;
                signal p3_full_3 :  STD_LOGIC;
                signal p3_stage_3 :  STD_LOGIC;
                signal p4_full_4 :  STD_LOGIC;
                signal p4_stage_4 :  STD_LOGIC;
                signal p5_full_5 :  STD_LOGIC;
                signal p5_stage_5 :  STD_LOGIC;
                signal p6_full_6 :  STD_LOGIC;
                signal p6_stage_6 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal stage_1 :  STD_LOGIC;
                signal stage_2 :  STD_LOGIC;
                signal stage_3 :  STD_LOGIC;
                signal stage_4 :  STD_LOGIC;
                signal stage_5 :  STD_LOGIC;
                signal stage_6 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (3 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_6;
  empty <= NOT(full_0);
  full_7 <= std_logic'('0');
  --data_6, which is an e_mux
  p6_stage_6 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_7 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_6, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_6 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_6))))) = '1' then 
        if std_logic'(((sync_reset AND full_6) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_7))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_6 <= std_logic'('0');
        else
          stage_6 <= p6_stage_6;
        end if;
      end if;
    end if;

  end process;

  --control_6, which is an e_mux
  p6_full_6 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_5))), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_6, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_6 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_6 <= std_logic'('0');
        else
          full_6 <= p6_full_6;
        end if;
      end if;
    end if;

  end process;

  --data_5, which is an e_mux
  p5_stage_5 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_6 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_6);
  --data_reg_5, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_5 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_5))))) = '1' then 
        if std_logic'(((sync_reset AND full_5) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_6))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_5 <= std_logic'('0');
        else
          stage_5 <= p5_stage_5;
        end if;
      end if;
    end if;

  end process;

  --control_5, which is an e_mux
  p5_full_5 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_4, full_6);
  --control_reg_5, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_5 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_5 <= std_logic'('0');
        else
          full_5 <= p5_full_5;
        end if;
      end if;
    end if;

  end process;

  --data_4, which is an e_mux
  p4_stage_4 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_5 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_5);
  --data_reg_4, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_4 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_4))))) = '1' then 
        if std_logic'(((sync_reset AND full_4) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_5))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_4 <= std_logic'('0');
        else
          stage_4 <= p4_stage_4;
        end if;
      end if;
    end if;

  end process;

  --control_4, which is an e_mux
  p4_full_4 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_3, full_5);
  --control_reg_4, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_4 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_4 <= std_logic'('0');
        else
          full_4 <= p4_full_4;
        end if;
      end if;
    end if;

  end process;

  --data_3, which is an e_mux
  p3_stage_3 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_4 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_4);
  --data_reg_3, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_3 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_3))))) = '1' then 
        if std_logic'(((sync_reset AND full_3) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_4))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_3 <= std_logic'('0');
        else
          stage_3 <= p3_stage_3;
        end if;
      end if;
    end if;

  end process;

  --control_3, which is an e_mux
  p3_full_3 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_2, full_4);
  --control_reg_3, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_3 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_3 <= std_logic'('0');
        else
          full_3 <= p3_full_3;
        end if;
      end if;
    end if;

  end process;

  --data_2, which is an e_mux
  p2_stage_2 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_3 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_3);
  --data_reg_2, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_2))))) = '1' then 
        if std_logic'(((sync_reset AND full_2) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_3))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_2 <= std_logic'('0');
        else
          stage_2 <= p2_stage_2;
        end if;
      end if;
    end if;

  end process;

  --control_2, which is an e_mux
  p2_full_2 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_1, full_3);
  --control_reg_2, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_2 <= std_logic'('0');
        else
          full_2 <= p2_full_2;
        end if;
      end if;
    end if;

  end process;

  --data_1, which is an e_mux
  p1_stage_1 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_2 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_2);
  --data_reg_1, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_1))))) = '1' then 
        if std_logic'(((sync_reset AND full_1) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_2))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_1 <= std_logic'('0');
        else
          stage_1 <= p1_stage_1;
        end if;
      end if;
    end if;

  end process;

  --control_1, which is an e_mux
  p1_full_1 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_0, full_2);
  --control_reg_1, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_1 <= std_logic'('0');
        else
          full_1 <= p1_full_1;
        end if;
      end if;
    end if;

  end process;

  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_1);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1)))));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("00000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 4);
  one_count_minus_one <= A_EXT (((std_logic_vector'("00000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 4);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("000") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 4);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("0000");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1_module;


architecture europa of rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal full_2 :  STD_LOGIC;
                signal full_3 :  STD_LOGIC;
                signal full_4 :  STD_LOGIC;
                signal full_5 :  STD_LOGIC;
                signal full_6 :  STD_LOGIC;
                signal full_7 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal p1_full_1 :  STD_LOGIC;
                signal p1_stage_1 :  STD_LOGIC;
                signal p2_full_2 :  STD_LOGIC;
                signal p2_stage_2 :  STD_LOGIC;
                signal p3_full_3 :  STD_LOGIC;
                signal p3_stage_3 :  STD_LOGIC;
                signal p4_full_4 :  STD_LOGIC;
                signal p4_stage_4 :  STD_LOGIC;
                signal p5_full_5 :  STD_LOGIC;
                signal p5_stage_5 :  STD_LOGIC;
                signal p6_full_6 :  STD_LOGIC;
                signal p6_stage_6 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal stage_1 :  STD_LOGIC;
                signal stage_2 :  STD_LOGIC;
                signal stage_3 :  STD_LOGIC;
                signal stage_4 :  STD_LOGIC;
                signal stage_5 :  STD_LOGIC;
                signal stage_6 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (3 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_6;
  empty <= NOT(full_0);
  full_7 <= std_logic'('0');
  --data_6, which is an e_mux
  p6_stage_6 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_7 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_6, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_6 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_6))))) = '1' then 
        if std_logic'(((sync_reset AND full_6) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_7))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_6 <= std_logic'('0');
        else
          stage_6 <= p6_stage_6;
        end if;
      end if;
    end if;

  end process;

  --control_6, which is an e_mux
  p6_full_6 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_5))), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_6, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_6 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_6 <= std_logic'('0');
        else
          full_6 <= p6_full_6;
        end if;
      end if;
    end if;

  end process;

  --data_5, which is an e_mux
  p5_stage_5 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_6 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_6);
  --data_reg_5, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_5 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_5))))) = '1' then 
        if std_logic'(((sync_reset AND full_5) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_6))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_5 <= std_logic'('0');
        else
          stage_5 <= p5_stage_5;
        end if;
      end if;
    end if;

  end process;

  --control_5, which is an e_mux
  p5_full_5 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_4, full_6);
  --control_reg_5, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_5 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_5 <= std_logic'('0');
        else
          full_5 <= p5_full_5;
        end if;
      end if;
    end if;

  end process;

  --data_4, which is an e_mux
  p4_stage_4 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_5 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_5);
  --data_reg_4, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_4 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_4))))) = '1' then 
        if std_logic'(((sync_reset AND full_4) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_5))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_4 <= std_logic'('0');
        else
          stage_4 <= p4_stage_4;
        end if;
      end if;
    end if;

  end process;

  --control_4, which is an e_mux
  p4_full_4 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_3, full_5);
  --control_reg_4, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_4 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_4 <= std_logic'('0');
        else
          full_4 <= p4_full_4;
        end if;
      end if;
    end if;

  end process;

  --data_3, which is an e_mux
  p3_stage_3 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_4 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_4);
  --data_reg_3, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_3 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_3))))) = '1' then 
        if std_logic'(((sync_reset AND full_3) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_4))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_3 <= std_logic'('0');
        else
          stage_3 <= p3_stage_3;
        end if;
      end if;
    end if;

  end process;

  --control_3, which is an e_mux
  p3_full_3 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_2, full_4);
  --control_reg_3, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_3 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_3 <= std_logic'('0');
        else
          full_3 <= p3_full_3;
        end if;
      end if;
    end if;

  end process;

  --data_2, which is an e_mux
  p2_stage_2 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_3 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_3);
  --data_reg_2, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_2))))) = '1' then 
        if std_logic'(((sync_reset AND full_2) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_3))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_2 <= std_logic'('0');
        else
          stage_2 <= p2_stage_2;
        end if;
      end if;
    end if;

  end process;

  --control_2, which is an e_mux
  p2_full_2 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_1, full_3);
  --control_reg_2, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_2 <= std_logic'('0');
        else
          full_2 <= p2_full_2;
        end if;
      end if;
    end if;

  end process;

  --data_1, which is an e_mux
  p1_stage_1 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_2 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_2);
  --data_reg_1, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_1))))) = '1' then 
        if std_logic'(((sync_reset AND full_1) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_2))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_1 <= std_logic'('0');
        else
          stage_1 <= p1_stage_1;
        end if;
      end if;
    end if;

  end process;

  --control_1, which is an e_mux
  p1_full_1 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_0, full_2);
  --control_reg_1, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_1 <= std_logic'('0');
        else
          full_1 <= p1_full_1;
        end if;
      end if;
    end if;

  end process;

  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_1);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1)))));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("00000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 4);
  one_count_minus_one <= A_EXT (((std_logic_vector'("00000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 4);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("000") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 4);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("0000");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity sdram_0_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_0_data_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_data_master_dbs_write_16 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal cpu_0_data_master_no_byte_enables_and_last_term : IN STD_LOGIC;
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_instruction_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_instruction_master_read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sdram_0_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sdram_0_s1_readdatavalid : IN STD_LOGIC;
                 signal sdram_0_s1_waitrequest : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_byteenable_sdram_0_s1 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_data_master_granted_sdram_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_sdram_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sdram_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_sdram_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_granted_sdram_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_qualified_request_sdram_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_read_data_valid_sdram_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_requests_sdram_0_s1 : OUT STD_LOGIC;
                 signal d1_sdram_0_s1_end_xfer : OUT STD_LOGIC;
                 signal sdram_0_s1_address : OUT STD_LOGIC_VECTOR (21 DOWNTO 0);
                 signal sdram_0_s1_byteenable_n : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal sdram_0_s1_chipselect : OUT STD_LOGIC;
                 signal sdram_0_s1_read_n : OUT STD_LOGIC;
                 signal sdram_0_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sdram_0_s1_reset_n : OUT STD_LOGIC;
                 signal sdram_0_s1_waitrequest_from_sa : OUT STD_LOGIC;
                 signal sdram_0_s1_write_n : OUT STD_LOGIC;
                 signal sdram_0_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
              );
end entity sdram_0_s1_arbitrator;


architecture europa of sdram_0_s1_arbitrator is
component rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1_module;

component rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1_module;

                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_byteenable_sdram_0_s1_segment_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_data_master_byteenable_sdram_0_s1_segment_1 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_rdv_fifo_empty_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_rdv_fifo_output_from_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_instruction_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_instruction_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_instruction_master_continuerequest :  STD_LOGIC;
                signal cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_instruction_master_rdv_fifo_output_from_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_instruction_master_saved_grant_sdram_0_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_sdram_0_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_byteenable_sdram_0_s1 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_cpu_0_data_master_granted_sdram_0_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_sdram_0_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_sdram_0_s1 :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_granted_sdram_0_s1 :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_qualified_request_sdram_0_s1 :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_requests_sdram_0_s1 :  STD_LOGIC;
                signal internal_sdram_0_s1_waitrequest_from_sa :  STD_LOGIC;
                signal last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 :  STD_LOGIC;
                signal last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 :  STD_LOGIC;
                signal module_input :  STD_LOGIC;
                signal module_input1 :  STD_LOGIC;
                signal module_input2 :  STD_LOGIC;
                signal module_input3 :  STD_LOGIC;
                signal module_input4 :  STD_LOGIC;
                signal module_input5 :  STD_LOGIC;
                signal sdram_0_s1_allgrants :  STD_LOGIC;
                signal sdram_0_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal sdram_0_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal sdram_0_s1_any_continuerequest :  STD_LOGIC;
                signal sdram_0_s1_arb_addend :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_arb_counter_enable :  STD_LOGIC;
                signal sdram_0_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_arb_winner :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_arbitration_holdoff_internal :  STD_LOGIC;
                signal sdram_0_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal sdram_0_s1_begins_xfer :  STD_LOGIC;
                signal sdram_0_s1_chosen_master_double_vector :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal sdram_0_s1_chosen_master_rot_left :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_end_xfer :  STD_LOGIC;
                signal sdram_0_s1_firsttransfer :  STD_LOGIC;
                signal sdram_0_s1_grant_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_in_a_read_cycle :  STD_LOGIC;
                signal sdram_0_s1_in_a_write_cycle :  STD_LOGIC;
                signal sdram_0_s1_master_qreq_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_move_on_to_next_transaction :  STD_LOGIC;
                signal sdram_0_s1_non_bursting_master_requests :  STD_LOGIC;
                signal sdram_0_s1_readdatavalid_from_sa :  STD_LOGIC;
                signal sdram_0_s1_reg_firsttransfer :  STD_LOGIC;
                signal sdram_0_s1_saved_chosen_master_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_slavearbiterlockenable :  STD_LOGIC;
                signal sdram_0_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal sdram_0_s1_unreg_firsttransfer :  STD_LOGIC;
                signal sdram_0_s1_waits_for_read :  STD_LOGIC;
                signal sdram_0_s1_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_sdram_0_s1_from_cpu_0_data_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal shifted_address_to_sdram_0_s1_from_cpu_0_instruction_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal wait_for_sdram_0_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT sdram_0_s1_end_xfer;
    end if;

  end process;

  sdram_0_s1_begins_xfer <= NOT d1_reasons_to_wait AND ((internal_cpu_0_data_master_qualified_request_sdram_0_s1 OR internal_cpu_0_instruction_master_qualified_request_sdram_0_s1));
  --assign sdram_0_s1_readdata_from_sa = sdram_0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  sdram_0_s1_readdata_from_sa <= sdram_0_s1_readdata;
  internal_cpu_0_data_master_requests_sdram_0_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(24 DOWNTO 23) & std_logic_vector'("00000000000000000000000")) = std_logic_vector'("0100000000000000000000000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --assign sdram_0_s1_waitrequest_from_sa = sdram_0_s1_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_sdram_0_s1_waitrequest_from_sa <= sdram_0_s1_waitrequest;
  --assign sdram_0_s1_readdatavalid_from_sa = sdram_0_s1_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  sdram_0_s1_readdatavalid_from_sa <= sdram_0_s1_readdatavalid;
  --sdram_0_s1_arb_share_counter set values, which is an e_mux
  sdram_0_s1_arb_share_set_values <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_sdram_0_s1)) = '1'), std_logic_vector'("00000000000000000000000000000010"), A_WE_StdLogicVector((std_logic'((internal_cpu_0_instruction_master_granted_sdram_0_s1)) = '1'), std_logic_vector'("00000000000000000000000000000010"), A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_sdram_0_s1)) = '1'), std_logic_vector'("00000000000000000000000000000010"), A_WE_StdLogicVector((std_logic'((internal_cpu_0_instruction_master_granted_sdram_0_s1)) = '1'), std_logic_vector'("00000000000000000000000000000010"), std_logic_vector'("00000000000000000000000000000001"))))), 2);
  --sdram_0_s1_non_bursting_master_requests mux, which is an e_mux
  sdram_0_s1_non_bursting_master_requests <= ((internal_cpu_0_data_master_requests_sdram_0_s1 OR internal_cpu_0_instruction_master_requests_sdram_0_s1) OR internal_cpu_0_data_master_requests_sdram_0_s1) OR internal_cpu_0_instruction_master_requests_sdram_0_s1;
  --sdram_0_s1_any_bursting_master_saved_grant mux, which is an e_mux
  sdram_0_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --sdram_0_s1_arb_share_counter_next_value assignment, which is an e_assign
  sdram_0_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(sdram_0_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (sdram_0_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(sdram_0_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (sdram_0_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --sdram_0_s1_allgrants all slave grants, which is an e_mux
  sdram_0_s1_allgrants <= (((or_reduce(sdram_0_s1_grant_vector)) OR (or_reduce(sdram_0_s1_grant_vector))) OR (or_reduce(sdram_0_s1_grant_vector))) OR (or_reduce(sdram_0_s1_grant_vector));
  --sdram_0_s1_end_xfer assignment, which is an e_assign
  sdram_0_s1_end_xfer <= NOT ((sdram_0_s1_waits_for_read OR sdram_0_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_sdram_0_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_sdram_0_s1 <= sdram_0_s1_end_xfer AND (((NOT sdram_0_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --sdram_0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  sdram_0_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_sdram_0_s1 AND sdram_0_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_sdram_0_s1 AND NOT sdram_0_s1_non_bursting_master_requests));
  --sdram_0_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sdram_0_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(sdram_0_s1_arb_counter_enable) = '1' then 
        sdram_0_s1_arb_share_counter <= sdram_0_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --sdram_0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sdram_0_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((or_reduce(sdram_0_s1_master_qreq_vector) AND end_xfer_arb_share_counter_term_sdram_0_s1)) OR ((end_xfer_arb_share_counter_term_sdram_0_s1 AND NOT sdram_0_s1_non_bursting_master_requests)))) = '1' then 
        sdram_0_s1_slavearbiterlockenable <= or_reduce(sdram_0_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master sdram_0/s1 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= sdram_0_s1_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --sdram_0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  sdram_0_s1_slavearbiterlockenable2 <= or_reduce(sdram_0_s1_arb_share_counter_next_value);
  --cpu_0/data_master sdram_0/s1 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= sdram_0_s1_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --cpu_0/instruction_master sdram_0/s1 arbiterlock, which is an e_assign
  cpu_0_instruction_master_arbiterlock <= sdram_0_s1_slavearbiterlockenable AND cpu_0_instruction_master_continuerequest;
  --cpu_0/instruction_master sdram_0/s1 arbiterlock2, which is an e_assign
  cpu_0_instruction_master_arbiterlock2 <= sdram_0_s1_slavearbiterlockenable2 AND cpu_0_instruction_master_continuerequest;
  --cpu_0/instruction_master granted sdram_0/s1 last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_0_instruction_master_saved_grant_sdram_0_s1) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((sdram_0_s1_arbitration_holdoff_internal OR NOT internal_cpu_0_instruction_master_requests_sdram_0_s1))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1))))));
    end if;

  end process;

  --cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  cpu_0_instruction_master_continuerequest <= last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 AND internal_cpu_0_instruction_master_requests_sdram_0_s1;
  --sdram_0_s1_any_continuerequest at least one master continues requesting, which is an e_mux
  sdram_0_s1_any_continuerequest <= cpu_0_instruction_master_continuerequest OR cpu_0_data_master_continuerequest;
  internal_cpu_0_data_master_qualified_request_sdram_0_s1 <= internal_cpu_0_data_master_requests_sdram_0_s1 AND NOT (((((cpu_0_data_master_read AND ((NOT cpu_0_data_master_waitrequest OR (internal_cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register))))) OR (((((NOT cpu_0_data_master_waitrequest OR cpu_0_data_master_no_byte_enables_and_last_term) OR NOT(or_reduce(internal_cpu_0_data_master_byteenable_sdram_0_s1)))) AND cpu_0_data_master_write))) OR cpu_0_instruction_master_arbiterlock));
  --unique name for sdram_0_s1_move_on_to_next_transaction, which is an e_assign
  sdram_0_s1_move_on_to_next_transaction <= sdram_0_s1_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1 : rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1_module
    port map(
      data_out => cpu_0_data_master_rdv_fifo_output_from_sdram_0_s1,
      empty => open,
      fifo_contains_ones_n => cpu_0_data_master_rdv_fifo_empty_sdram_0_s1,
      full => open,
      clear_fifo => module_input,
      clk => clk,
      data_in => internal_cpu_0_data_master_granted_sdram_0_s1,
      read => sdram_0_s1_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input1,
      write => module_input2
    );

  module_input <= std_logic'('0');
  module_input1 <= std_logic'('0');
  module_input2 <= in_a_read_cycle AND NOT sdram_0_s1_waits_for_read;

  internal_cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register <= NOT cpu_0_data_master_rdv_fifo_empty_sdram_0_s1;
  --local readdatavalid cpu_0_data_master_read_data_valid_sdram_0_s1, which is an e_mux
  cpu_0_data_master_read_data_valid_sdram_0_s1 <= ((sdram_0_s1_readdatavalid_from_sa AND cpu_0_data_master_rdv_fifo_output_from_sdram_0_s1)) AND NOT cpu_0_data_master_rdv_fifo_empty_sdram_0_s1;
  --sdram_0_s1_writedata mux, which is an e_mux
  sdram_0_s1_writedata <= cpu_0_data_master_dbs_write_16;
  internal_cpu_0_instruction_master_requests_sdram_0_s1 <= ((to_std_logic(((Std_Logic_Vector'(cpu_0_instruction_master_address_to_slave(24 DOWNTO 23) & std_logic_vector'("00000000000000000000000")) = std_logic_vector'("0100000000000000000000000")))) AND (cpu_0_instruction_master_read))) AND cpu_0_instruction_master_read;
  --cpu_0/data_master granted sdram_0/s1 last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_0_data_master_saved_grant_sdram_0_s1) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((sdram_0_s1_arbitration_holdoff_internal OR NOT internal_cpu_0_data_master_requests_sdram_0_s1))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1))))));
    end if;

  end process;

  --cpu_0_data_master_continuerequest continued request, which is an e_mux
  cpu_0_data_master_continuerequest <= last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 AND internal_cpu_0_data_master_requests_sdram_0_s1;
  internal_cpu_0_instruction_master_qualified_request_sdram_0_s1 <= internal_cpu_0_instruction_master_requests_sdram_0_s1 AND NOT ((((cpu_0_instruction_master_read AND (internal_cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register))) OR cpu_0_data_master_arbiterlock));
  --rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1 : rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1_module
    port map(
      data_out => cpu_0_instruction_master_rdv_fifo_output_from_sdram_0_s1,
      empty => open,
      fifo_contains_ones_n => cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1,
      full => open,
      clear_fifo => module_input3,
      clk => clk,
      data_in => internal_cpu_0_instruction_master_granted_sdram_0_s1,
      read => sdram_0_s1_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input4,
      write => module_input5
    );

  module_input3 <= std_logic'('0');
  module_input4 <= std_logic'('0');
  module_input5 <= in_a_read_cycle AND NOT sdram_0_s1_waits_for_read;

  internal_cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register <= NOT cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1;
  --local readdatavalid cpu_0_instruction_master_read_data_valid_sdram_0_s1, which is an e_mux
  cpu_0_instruction_master_read_data_valid_sdram_0_s1 <= ((sdram_0_s1_readdatavalid_from_sa AND cpu_0_instruction_master_rdv_fifo_output_from_sdram_0_s1)) AND NOT cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1;
  --allow new arb cycle for sdram_0/s1, which is an e_assign
  sdram_0_s1_allow_new_arb_cycle <= NOT cpu_0_data_master_arbiterlock AND NOT cpu_0_instruction_master_arbiterlock;
  --cpu_0/instruction_master assignment into master qualified-requests vector for sdram_0/s1, which is an e_assign
  sdram_0_s1_master_qreq_vector(0) <= internal_cpu_0_instruction_master_qualified_request_sdram_0_s1;
  --cpu_0/instruction_master grant sdram_0/s1, which is an e_assign
  internal_cpu_0_instruction_master_granted_sdram_0_s1 <= sdram_0_s1_grant_vector(0);
  --cpu_0/instruction_master saved-grant sdram_0/s1, which is an e_assign
  cpu_0_instruction_master_saved_grant_sdram_0_s1 <= sdram_0_s1_arb_winner(0) AND internal_cpu_0_instruction_master_requests_sdram_0_s1;
  --cpu_0/data_master assignment into master qualified-requests vector for sdram_0/s1, which is an e_assign
  sdram_0_s1_master_qreq_vector(1) <= internal_cpu_0_data_master_qualified_request_sdram_0_s1;
  --cpu_0/data_master grant sdram_0/s1, which is an e_assign
  internal_cpu_0_data_master_granted_sdram_0_s1 <= sdram_0_s1_grant_vector(1);
  --cpu_0/data_master saved-grant sdram_0/s1, which is an e_assign
  cpu_0_data_master_saved_grant_sdram_0_s1 <= sdram_0_s1_arb_winner(1) AND internal_cpu_0_data_master_requests_sdram_0_s1;
  --sdram_0/s1 chosen-master double-vector, which is an e_assign
  sdram_0_s1_chosen_master_double_vector <= A_EXT (((std_logic_vector'("0") & ((sdram_0_s1_master_qreq_vector & sdram_0_s1_master_qreq_vector))) AND (((std_logic_vector'("0") & (Std_Logic_Vector'(NOT sdram_0_s1_master_qreq_vector & NOT sdram_0_s1_master_qreq_vector))) + (std_logic_vector'("000") & (sdram_0_s1_arb_addend))))), 4);
  --stable onehot encoding of arb winner
  sdram_0_s1_arb_winner <= A_WE_StdLogicVector((std_logic'(((sdram_0_s1_allow_new_arb_cycle AND or_reduce(sdram_0_s1_grant_vector)))) = '1'), sdram_0_s1_grant_vector, sdram_0_s1_saved_chosen_master_vector);
  --saved sdram_0_s1_grant_vector, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sdram_0_s1_saved_chosen_master_vector <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(sdram_0_s1_allow_new_arb_cycle) = '1' then 
        sdram_0_s1_saved_chosen_master_vector <= A_WE_StdLogicVector((std_logic'(or_reduce(sdram_0_s1_grant_vector)) = '1'), sdram_0_s1_grant_vector, sdram_0_s1_saved_chosen_master_vector);
      end if;
    end if;

  end process;

  --onehot encoding of chosen master
  sdram_0_s1_grant_vector <= Std_Logic_Vector'(A_ToStdLogicVector(((sdram_0_s1_chosen_master_double_vector(1) OR sdram_0_s1_chosen_master_double_vector(3)))) & A_ToStdLogicVector(((sdram_0_s1_chosen_master_double_vector(0) OR sdram_0_s1_chosen_master_double_vector(2)))));
  --sdram_0/s1 chosen master rotated left, which is an e_assign
  sdram_0_s1_chosen_master_rot_left <= A_EXT (A_WE_StdLogicVector((((A_SLL(sdram_0_s1_arb_winner,std_logic_vector'("00000000000000000000000000000001")))) /= std_logic_vector'("00")), (std_logic_vector'("000000000000000000000000000000") & ((A_SLL(sdram_0_s1_arb_winner,std_logic_vector'("00000000000000000000000000000001"))))), std_logic_vector'("00000000000000000000000000000001")), 2);
  --sdram_0/s1's addend for next-master-grant
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sdram_0_s1_arb_addend <= std_logic_vector'("01");
    elsif clk'event and clk = '1' then
      if std_logic'(or_reduce(sdram_0_s1_grant_vector)) = '1' then 
        sdram_0_s1_arb_addend <= A_WE_StdLogicVector((std_logic'(sdram_0_s1_end_xfer) = '1'), sdram_0_s1_chosen_master_rot_left, sdram_0_s1_grant_vector);
      end if;
    end if;

  end process;

  --sdram_0_s1_reset_n assignment, which is an e_assign
  sdram_0_s1_reset_n <= reset_n;
  sdram_0_s1_chipselect <= internal_cpu_0_data_master_granted_sdram_0_s1 OR internal_cpu_0_instruction_master_granted_sdram_0_s1;
  --sdram_0_s1_firsttransfer first transaction, which is an e_assign
  sdram_0_s1_firsttransfer <= A_WE_StdLogic((std_logic'(sdram_0_s1_begins_xfer) = '1'), sdram_0_s1_unreg_firsttransfer, sdram_0_s1_reg_firsttransfer);
  --sdram_0_s1_unreg_firsttransfer first transaction, which is an e_assign
  sdram_0_s1_unreg_firsttransfer <= NOT ((sdram_0_s1_slavearbiterlockenable AND sdram_0_s1_any_continuerequest));
  --sdram_0_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sdram_0_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(sdram_0_s1_begins_xfer) = '1' then 
        sdram_0_s1_reg_firsttransfer <= sdram_0_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --sdram_0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  sdram_0_s1_beginbursttransfer_internal <= sdram_0_s1_begins_xfer;
  --sdram_0_s1_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  sdram_0_s1_arbitration_holdoff_internal <= sdram_0_s1_begins_xfer AND sdram_0_s1_firsttransfer;
  --~sdram_0_s1_read_n assignment, which is an e_mux
  sdram_0_s1_read_n <= NOT ((((internal_cpu_0_data_master_granted_sdram_0_s1 AND cpu_0_data_master_read)) OR ((internal_cpu_0_instruction_master_granted_sdram_0_s1 AND cpu_0_instruction_master_read))));
  --~sdram_0_s1_write_n assignment, which is an e_mux
  sdram_0_s1_write_n <= NOT ((internal_cpu_0_data_master_granted_sdram_0_s1 AND cpu_0_data_master_write));
  shifted_address_to_sdram_0_s1_from_cpu_0_data_master <= A_EXT (Std_Logic_Vector'(A_SRL(cpu_0_data_master_address_to_slave,std_logic_vector'("00000000000000000000000000000010")) & A_ToStdLogicVector(cpu_0_data_master_dbs_address(1)) & A_ToStdLogicVector(std_logic'('0'))), 25);
  --sdram_0_s1_address mux, which is an e_mux
  sdram_0_s1_address <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_sdram_0_s1)) = '1'), (A_SRL(shifted_address_to_sdram_0_s1_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000001"))), (A_SRL(shifted_address_to_sdram_0_s1_from_cpu_0_instruction_master,std_logic_vector'("00000000000000000000000000000001")))), 22);
  shifted_address_to_sdram_0_s1_from_cpu_0_instruction_master <= A_EXT (Std_Logic_Vector'(A_SRL(cpu_0_instruction_master_address_to_slave,std_logic_vector'("00000000000000000000000000000010")) & A_ToStdLogicVector(cpu_0_instruction_master_dbs_address(1)) & A_ToStdLogicVector(std_logic'('0'))), 25);
  --d1_sdram_0_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_sdram_0_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_sdram_0_s1_end_xfer <= sdram_0_s1_end_xfer;
    end if;

  end process;

  --sdram_0_s1_waits_for_read in a cycle, which is an e_mux
  sdram_0_s1_waits_for_read <= sdram_0_s1_in_a_read_cycle AND internal_sdram_0_s1_waitrequest_from_sa;
  --sdram_0_s1_in_a_read_cycle assignment, which is an e_assign
  sdram_0_s1_in_a_read_cycle <= ((internal_cpu_0_data_master_granted_sdram_0_s1 AND cpu_0_data_master_read)) OR ((internal_cpu_0_instruction_master_granted_sdram_0_s1 AND cpu_0_instruction_master_read));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= sdram_0_s1_in_a_read_cycle;
  --sdram_0_s1_waits_for_write in a cycle, which is an e_mux
  sdram_0_s1_waits_for_write <= sdram_0_s1_in_a_write_cycle AND internal_sdram_0_s1_waitrequest_from_sa;
  --sdram_0_s1_in_a_write_cycle assignment, which is an e_assign
  sdram_0_s1_in_a_write_cycle <= internal_cpu_0_data_master_granted_sdram_0_s1 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= sdram_0_s1_in_a_write_cycle;
  wait_for_sdram_0_s1_counter <= std_logic'('0');
  --~sdram_0_s1_byteenable_n byte enable port mux, which is an e_mux
  sdram_0_s1_byteenable_n <= A_EXT (NOT (A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_sdram_0_s1)) = '1'), (std_logic_vector'("000000000000000000000000000000") & (internal_cpu_0_data_master_byteenable_sdram_0_s1)), -SIGNED(std_logic_vector'("00000000000000000000000000000001")))), 2);
  (cpu_0_data_master_byteenable_sdram_0_s1_segment_1(1), cpu_0_data_master_byteenable_sdram_0_s1_segment_1(0), cpu_0_data_master_byteenable_sdram_0_s1_segment_0(1), cpu_0_data_master_byteenable_sdram_0_s1_segment_0(0)) <= cpu_0_data_master_byteenable;
  internal_cpu_0_data_master_byteenable_sdram_0_s1 <= A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_dbs_address(1)))) = std_logic_vector'("00000000000000000000000000000000"))), cpu_0_data_master_byteenable_sdram_0_s1_segment_0, cpu_0_data_master_byteenable_sdram_0_s1_segment_1);
  --vhdl renameroo for output signals
  cpu_0_data_master_byteenable_sdram_0_s1 <= internal_cpu_0_data_master_byteenable_sdram_0_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_sdram_0_s1 <= internal_cpu_0_data_master_granted_sdram_0_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_sdram_0_s1 <= internal_cpu_0_data_master_qualified_request_sdram_0_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register <= internal_cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_sdram_0_s1 <= internal_cpu_0_data_master_requests_sdram_0_s1;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_granted_sdram_0_s1 <= internal_cpu_0_instruction_master_granted_sdram_0_s1;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_qualified_request_sdram_0_s1 <= internal_cpu_0_instruction_master_qualified_request_sdram_0_s1;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register <= internal_cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_requests_sdram_0_s1 <= internal_cpu_0_instruction_master_requests_sdram_0_s1;
  --vhdl renameroo for output signals
  sdram_0_s1_waitrequest_from_sa <= internal_sdram_0_s1_waitrequest_from_sa;
--synthesis translate_off
    --sdram_0/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line6 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_0_data_master_granted_sdram_0_s1))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_0_instruction_master_granted_sdram_0_s1))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line6, now);
          write(write_line6, string'(": "));
          write(write_line6, string'("> 1 of grant signals are active simultaneously"));
          write(output, write_line6.all);
          deallocate (write_line6);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --saved_grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line7 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_saved_grant_sdram_0_s1))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_0_instruction_master_saved_grant_sdram_0_s1))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line7, now);
          write(write_line7, string'(": "));
          write(write_line7, string'("> 1 of saved_grant signals are active simultaneously"));
          write(output, write_line7.all);
          deallocate (write_line7);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity sysid_control_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sysid_control_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal cpu_0_data_master_granted_sysid_control_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_sysid_control_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sysid_control_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_sysid_control_slave : OUT STD_LOGIC;
                 signal d1_sysid_control_slave_end_xfer : OUT STD_LOGIC;
                 signal sysid_control_slave_address : OUT STD_LOGIC;
                 signal sysid_control_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal sysid_control_slave_reset_n : OUT STD_LOGIC
              );
end entity sysid_control_slave_arbitrator;


architecture europa of sysid_control_slave_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_sysid_control_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_sysid_control_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_sysid_control_slave :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_sysid_control_slave :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_sysid_control_slave :  STD_LOGIC;
                signal shifted_address_to_sysid_control_slave_from_cpu_0_data_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal sysid_control_slave_allgrants :  STD_LOGIC;
                signal sysid_control_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal sysid_control_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal sysid_control_slave_any_continuerequest :  STD_LOGIC;
                signal sysid_control_slave_arb_counter_enable :  STD_LOGIC;
                signal sysid_control_slave_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sysid_control_slave_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sysid_control_slave_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sysid_control_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal sysid_control_slave_begins_xfer :  STD_LOGIC;
                signal sysid_control_slave_end_xfer :  STD_LOGIC;
                signal sysid_control_slave_firsttransfer :  STD_LOGIC;
                signal sysid_control_slave_grant_vector :  STD_LOGIC;
                signal sysid_control_slave_in_a_read_cycle :  STD_LOGIC;
                signal sysid_control_slave_in_a_write_cycle :  STD_LOGIC;
                signal sysid_control_slave_master_qreq_vector :  STD_LOGIC;
                signal sysid_control_slave_non_bursting_master_requests :  STD_LOGIC;
                signal sysid_control_slave_reg_firsttransfer :  STD_LOGIC;
                signal sysid_control_slave_slavearbiterlockenable :  STD_LOGIC;
                signal sysid_control_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal sysid_control_slave_unreg_firsttransfer :  STD_LOGIC;
                signal sysid_control_slave_waits_for_read :  STD_LOGIC;
                signal sysid_control_slave_waits_for_write :  STD_LOGIC;
                signal wait_for_sysid_control_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT sysid_control_slave_end_xfer;
    end if;

  end process;

  sysid_control_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_sysid_control_slave);
  --assign sysid_control_slave_readdata_from_sa = sysid_control_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  sysid_control_slave_readdata_from_sa <= sysid_control_slave_readdata;
  internal_cpu_0_data_master_requests_sysid_control_slave <= ((to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(24 DOWNTO 3) & std_logic_vector'("000")) = std_logic_vector'("1000000000101000100000000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write)))) AND cpu_0_data_master_read;
  --sysid_control_slave_arb_share_counter set values, which is an e_mux
  sysid_control_slave_arb_share_set_values <= std_logic_vector'("01");
  --sysid_control_slave_non_bursting_master_requests mux, which is an e_mux
  sysid_control_slave_non_bursting_master_requests <= internal_cpu_0_data_master_requests_sysid_control_slave;
  --sysid_control_slave_any_bursting_master_saved_grant mux, which is an e_mux
  sysid_control_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --sysid_control_slave_arb_share_counter_next_value assignment, which is an e_assign
  sysid_control_slave_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(sysid_control_slave_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (sysid_control_slave_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(sysid_control_slave_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (sysid_control_slave_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --sysid_control_slave_allgrants all slave grants, which is an e_mux
  sysid_control_slave_allgrants <= sysid_control_slave_grant_vector;
  --sysid_control_slave_end_xfer assignment, which is an e_assign
  sysid_control_slave_end_xfer <= NOT ((sysid_control_slave_waits_for_read OR sysid_control_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_sysid_control_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_sysid_control_slave <= sysid_control_slave_end_xfer AND (((NOT sysid_control_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --sysid_control_slave_arb_share_counter arbitration counter enable, which is an e_assign
  sysid_control_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_sysid_control_slave AND sysid_control_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_sysid_control_slave AND NOT sysid_control_slave_non_bursting_master_requests));
  --sysid_control_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sysid_control_slave_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(sysid_control_slave_arb_counter_enable) = '1' then 
        sysid_control_slave_arb_share_counter <= sysid_control_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --sysid_control_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sysid_control_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((sysid_control_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_sysid_control_slave)) OR ((end_xfer_arb_share_counter_term_sysid_control_slave AND NOT sysid_control_slave_non_bursting_master_requests)))) = '1' then 
        sysid_control_slave_slavearbiterlockenable <= or_reduce(sysid_control_slave_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master sysid/control_slave arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= sysid_control_slave_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --sysid_control_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  sysid_control_slave_slavearbiterlockenable2 <= or_reduce(sysid_control_slave_arb_share_counter_next_value);
  --cpu_0/data_master sysid/control_slave arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= sysid_control_slave_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --sysid_control_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  sysid_control_slave_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_sysid_control_slave <= internal_cpu_0_data_master_requests_sysid_control_slave;
  --master is always granted when requested
  internal_cpu_0_data_master_granted_sysid_control_slave <= internal_cpu_0_data_master_qualified_request_sysid_control_slave;
  --cpu_0/data_master saved-grant sysid/control_slave, which is an e_assign
  cpu_0_data_master_saved_grant_sysid_control_slave <= internal_cpu_0_data_master_requests_sysid_control_slave;
  --allow new arb cycle for sysid/control_slave, which is an e_assign
  sysid_control_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  sysid_control_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  sysid_control_slave_master_qreq_vector <= std_logic'('1');
  --sysid_control_slave_reset_n assignment, which is an e_assign
  sysid_control_slave_reset_n <= reset_n;
  --sysid_control_slave_firsttransfer first transaction, which is an e_assign
  sysid_control_slave_firsttransfer <= A_WE_StdLogic((std_logic'(sysid_control_slave_begins_xfer) = '1'), sysid_control_slave_unreg_firsttransfer, sysid_control_slave_reg_firsttransfer);
  --sysid_control_slave_unreg_firsttransfer first transaction, which is an e_assign
  sysid_control_slave_unreg_firsttransfer <= NOT ((sysid_control_slave_slavearbiterlockenable AND sysid_control_slave_any_continuerequest));
  --sysid_control_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sysid_control_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(sysid_control_slave_begins_xfer) = '1' then 
        sysid_control_slave_reg_firsttransfer <= sysid_control_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --sysid_control_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  sysid_control_slave_beginbursttransfer_internal <= sysid_control_slave_begins_xfer;
  shifted_address_to_sysid_control_slave_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --sysid_control_slave_address mux, which is an e_mux
  sysid_control_slave_address <= Vector_To_Std_Logic(A_SRL(shifted_address_to_sysid_control_slave_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")));
  --d1_sysid_control_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_sysid_control_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_sysid_control_slave_end_xfer <= sysid_control_slave_end_xfer;
    end if;

  end process;

  --sysid_control_slave_waits_for_read in a cycle, which is an e_mux
  sysid_control_slave_waits_for_read <= sysid_control_slave_in_a_read_cycle AND sysid_control_slave_begins_xfer;
  --sysid_control_slave_in_a_read_cycle assignment, which is an e_assign
  sysid_control_slave_in_a_read_cycle <= internal_cpu_0_data_master_granted_sysid_control_slave AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= sysid_control_slave_in_a_read_cycle;
  --sysid_control_slave_waits_for_write in a cycle, which is an e_mux
  sysid_control_slave_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sysid_control_slave_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --sysid_control_slave_in_a_write_cycle assignment, which is an e_assign
  sysid_control_slave_in_a_write_cycle <= internal_cpu_0_data_master_granted_sysid_control_slave AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= sysid_control_slave_in_a_write_cycle;
  wait_for_sysid_control_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_sysid_control_slave <= internal_cpu_0_data_master_granted_sysid_control_slave;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_sysid_control_slave <= internal_cpu_0_data_master_qualified_request_sysid_control_slave;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_sysid_control_slave <= internal_cpu_0_data_master_requests_sysid_control_slave;
--synthesis translate_off
    --sysid/control_slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity uC_timer_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;
                 signal uC_timer_s1_irq : IN STD_LOGIC;
                 signal uC_timer_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

              -- outputs:
                 signal cpu_0_data_master_granted_uC_timer_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_uC_timer_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_uC_timer_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_uC_timer_s1 : OUT STD_LOGIC;
                 signal d1_uC_timer_s1_end_xfer : OUT STD_LOGIC;
                 signal uC_timer_s1_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal uC_timer_s1_chipselect : OUT STD_LOGIC;
                 signal uC_timer_s1_irq_from_sa : OUT STD_LOGIC;
                 signal uC_timer_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal uC_timer_s1_reset_n : OUT STD_LOGIC;
                 signal uC_timer_s1_write_n : OUT STD_LOGIC;
                 signal uC_timer_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
              );
end entity uC_timer_s1_arbitrator;


architecture europa of uC_timer_s1_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_uC_timer_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_uC_timer_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_uC_timer_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_uC_timer_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_uC_timer_s1 :  STD_LOGIC;
                signal shifted_address_to_uC_timer_s1_from_cpu_0_data_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal uC_timer_s1_allgrants :  STD_LOGIC;
                signal uC_timer_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal uC_timer_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal uC_timer_s1_any_continuerequest :  STD_LOGIC;
                signal uC_timer_s1_arb_counter_enable :  STD_LOGIC;
                signal uC_timer_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal uC_timer_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal uC_timer_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal uC_timer_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal uC_timer_s1_begins_xfer :  STD_LOGIC;
                signal uC_timer_s1_end_xfer :  STD_LOGIC;
                signal uC_timer_s1_firsttransfer :  STD_LOGIC;
                signal uC_timer_s1_grant_vector :  STD_LOGIC;
                signal uC_timer_s1_in_a_read_cycle :  STD_LOGIC;
                signal uC_timer_s1_in_a_write_cycle :  STD_LOGIC;
                signal uC_timer_s1_master_qreq_vector :  STD_LOGIC;
                signal uC_timer_s1_non_bursting_master_requests :  STD_LOGIC;
                signal uC_timer_s1_reg_firsttransfer :  STD_LOGIC;
                signal uC_timer_s1_slavearbiterlockenable :  STD_LOGIC;
                signal uC_timer_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal uC_timer_s1_unreg_firsttransfer :  STD_LOGIC;
                signal uC_timer_s1_waits_for_read :  STD_LOGIC;
                signal uC_timer_s1_waits_for_write :  STD_LOGIC;
                signal wait_for_uC_timer_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT uC_timer_s1_end_xfer;
    end if;

  end process;

  uC_timer_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_uC_timer_s1);
  --assign uC_timer_s1_readdata_from_sa = uC_timer_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  uC_timer_s1_readdata_from_sa <= uC_timer_s1_readdata;
  internal_cpu_0_data_master_requests_uC_timer_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(24 DOWNTO 5) & std_logic_vector'("00000")) = std_logic_vector'("1000000000101000000000000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --uC_timer_s1_arb_share_counter set values, which is an e_mux
  uC_timer_s1_arb_share_set_values <= std_logic_vector'("01");
  --uC_timer_s1_non_bursting_master_requests mux, which is an e_mux
  uC_timer_s1_non_bursting_master_requests <= internal_cpu_0_data_master_requests_uC_timer_s1;
  --uC_timer_s1_any_bursting_master_saved_grant mux, which is an e_mux
  uC_timer_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --uC_timer_s1_arb_share_counter_next_value assignment, which is an e_assign
  uC_timer_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(uC_timer_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (uC_timer_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(uC_timer_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (uC_timer_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --uC_timer_s1_allgrants all slave grants, which is an e_mux
  uC_timer_s1_allgrants <= uC_timer_s1_grant_vector;
  --uC_timer_s1_end_xfer assignment, which is an e_assign
  uC_timer_s1_end_xfer <= NOT ((uC_timer_s1_waits_for_read OR uC_timer_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_uC_timer_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_uC_timer_s1 <= uC_timer_s1_end_xfer AND (((NOT uC_timer_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --uC_timer_s1_arb_share_counter arbitration counter enable, which is an e_assign
  uC_timer_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_uC_timer_s1 AND uC_timer_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_uC_timer_s1 AND NOT uC_timer_s1_non_bursting_master_requests));
  --uC_timer_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      uC_timer_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(uC_timer_s1_arb_counter_enable) = '1' then 
        uC_timer_s1_arb_share_counter <= uC_timer_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --uC_timer_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      uC_timer_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((uC_timer_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_uC_timer_s1)) OR ((end_xfer_arb_share_counter_term_uC_timer_s1 AND NOT uC_timer_s1_non_bursting_master_requests)))) = '1' then 
        uC_timer_s1_slavearbiterlockenable <= or_reduce(uC_timer_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master uC_timer/s1 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= uC_timer_s1_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --uC_timer_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  uC_timer_s1_slavearbiterlockenable2 <= or_reduce(uC_timer_s1_arb_share_counter_next_value);
  --cpu_0/data_master uC_timer/s1 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= uC_timer_s1_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --uC_timer_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  uC_timer_s1_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_uC_timer_s1 <= internal_cpu_0_data_master_requests_uC_timer_s1 AND NOT (((NOT cpu_0_data_master_waitrequest) AND cpu_0_data_master_write));
  --uC_timer_s1_writedata mux, which is an e_mux
  uC_timer_s1_writedata <= cpu_0_data_master_writedata (15 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_0_data_master_granted_uC_timer_s1 <= internal_cpu_0_data_master_qualified_request_uC_timer_s1;
  --cpu_0/data_master saved-grant uC_timer/s1, which is an e_assign
  cpu_0_data_master_saved_grant_uC_timer_s1 <= internal_cpu_0_data_master_requests_uC_timer_s1;
  --allow new arb cycle for uC_timer/s1, which is an e_assign
  uC_timer_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  uC_timer_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  uC_timer_s1_master_qreq_vector <= std_logic'('1');
  --uC_timer_s1_reset_n assignment, which is an e_assign
  uC_timer_s1_reset_n <= reset_n;
  uC_timer_s1_chipselect <= internal_cpu_0_data_master_granted_uC_timer_s1;
  --uC_timer_s1_firsttransfer first transaction, which is an e_assign
  uC_timer_s1_firsttransfer <= A_WE_StdLogic((std_logic'(uC_timer_s1_begins_xfer) = '1'), uC_timer_s1_unreg_firsttransfer, uC_timer_s1_reg_firsttransfer);
  --uC_timer_s1_unreg_firsttransfer first transaction, which is an e_assign
  uC_timer_s1_unreg_firsttransfer <= NOT ((uC_timer_s1_slavearbiterlockenable AND uC_timer_s1_any_continuerequest));
  --uC_timer_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      uC_timer_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(uC_timer_s1_begins_xfer) = '1' then 
        uC_timer_s1_reg_firsttransfer <= uC_timer_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --uC_timer_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  uC_timer_s1_beginbursttransfer_internal <= uC_timer_s1_begins_xfer;
  --~uC_timer_s1_write_n assignment, which is an e_mux
  uC_timer_s1_write_n <= NOT ((internal_cpu_0_data_master_granted_uC_timer_s1 AND cpu_0_data_master_write));
  shifted_address_to_uC_timer_s1_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --uC_timer_s1_address mux, which is an e_mux
  uC_timer_s1_address <= A_EXT (A_SRL(shifted_address_to_uC_timer_s1_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")), 3);
  --d1_uC_timer_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_uC_timer_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_uC_timer_s1_end_xfer <= uC_timer_s1_end_xfer;
    end if;

  end process;

  --uC_timer_s1_waits_for_read in a cycle, which is an e_mux
  uC_timer_s1_waits_for_read <= uC_timer_s1_in_a_read_cycle AND uC_timer_s1_begins_xfer;
  --uC_timer_s1_in_a_read_cycle assignment, which is an e_assign
  uC_timer_s1_in_a_read_cycle <= internal_cpu_0_data_master_granted_uC_timer_s1 AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= uC_timer_s1_in_a_read_cycle;
  --uC_timer_s1_waits_for_write in a cycle, which is an e_mux
  uC_timer_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(uC_timer_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --uC_timer_s1_in_a_write_cycle assignment, which is an e_assign
  uC_timer_s1_in_a_write_cycle <= internal_cpu_0_data_master_granted_uC_timer_s1 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= uC_timer_s1_in_a_write_cycle;
  wait_for_uC_timer_s1_counter <= std_logic'('0');
  --assign uC_timer_s1_irq_from_sa = uC_timer_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  uC_timer_s1_irq_from_sa <= uC_timer_s1_irq;
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_uC_timer_s1 <= internal_cpu_0_data_master_granted_uC_timer_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_uC_timer_s1 <= internal_cpu_0_data_master_qualified_request_uC_timer_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_uC_timer_s1 <= internal_cpu_0_data_master_requests_uC_timer_s1;
--synthesis translate_off
    --uC_timer/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity uart_0_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;
                 signal uart_0_s1_dataavailable : IN STD_LOGIC;
                 signal uart_0_s1_irq : IN STD_LOGIC;
                 signal uart_0_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal uart_0_s1_readyfordata : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_granted_uart_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_uart_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_uart_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_uart_0_s1 : OUT STD_LOGIC;
                 signal d1_uart_0_s1_end_xfer : OUT STD_LOGIC;
                 signal uart_0_s1_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal uart_0_s1_begintransfer : OUT STD_LOGIC;
                 signal uart_0_s1_chipselect : OUT STD_LOGIC;
                 signal uart_0_s1_dataavailable_from_sa : OUT STD_LOGIC;
                 signal uart_0_s1_irq_from_sa : OUT STD_LOGIC;
                 signal uart_0_s1_read_n : OUT STD_LOGIC;
                 signal uart_0_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal uart_0_s1_readyfordata_from_sa : OUT STD_LOGIC;
                 signal uart_0_s1_reset_n : OUT STD_LOGIC;
                 signal uart_0_s1_write_n : OUT STD_LOGIC;
                 signal uart_0_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
              );
end entity uart_0_s1_arbitrator;


architecture europa of uart_0_s1_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_uart_0_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_uart_0_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_uart_0_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_uart_0_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_uart_0_s1 :  STD_LOGIC;
                signal shifted_address_to_uart_0_s1_from_cpu_0_data_master :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal uart_0_s1_allgrants :  STD_LOGIC;
                signal uart_0_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal uart_0_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal uart_0_s1_any_continuerequest :  STD_LOGIC;
                signal uart_0_s1_arb_counter_enable :  STD_LOGIC;
                signal uart_0_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal uart_0_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal uart_0_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal uart_0_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal uart_0_s1_begins_xfer :  STD_LOGIC;
                signal uart_0_s1_end_xfer :  STD_LOGIC;
                signal uart_0_s1_firsttransfer :  STD_LOGIC;
                signal uart_0_s1_grant_vector :  STD_LOGIC;
                signal uart_0_s1_in_a_read_cycle :  STD_LOGIC;
                signal uart_0_s1_in_a_write_cycle :  STD_LOGIC;
                signal uart_0_s1_master_qreq_vector :  STD_LOGIC;
                signal uart_0_s1_non_bursting_master_requests :  STD_LOGIC;
                signal uart_0_s1_reg_firsttransfer :  STD_LOGIC;
                signal uart_0_s1_slavearbiterlockenable :  STD_LOGIC;
                signal uart_0_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal uart_0_s1_unreg_firsttransfer :  STD_LOGIC;
                signal uart_0_s1_waits_for_read :  STD_LOGIC;
                signal uart_0_s1_waits_for_write :  STD_LOGIC;
                signal wait_for_uart_0_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT uart_0_s1_end_xfer;
    end if;

  end process;

  uart_0_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_uart_0_s1);
  --assign uart_0_s1_readdata_from_sa = uart_0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  uart_0_s1_readdata_from_sa <= uart_0_s1_readdata;
  internal_cpu_0_data_master_requests_uart_0_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(24 DOWNTO 5) & std_logic_vector'("00000")) = std_logic_vector'("1000000000101000000100000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --assign uart_0_s1_dataavailable_from_sa = uart_0_s1_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  uart_0_s1_dataavailable_from_sa <= uart_0_s1_dataavailable;
  --assign uart_0_s1_readyfordata_from_sa = uart_0_s1_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  uart_0_s1_readyfordata_from_sa <= uart_0_s1_readyfordata;
  --uart_0_s1_arb_share_counter set values, which is an e_mux
  uart_0_s1_arb_share_set_values <= std_logic_vector'("01");
  --uart_0_s1_non_bursting_master_requests mux, which is an e_mux
  uart_0_s1_non_bursting_master_requests <= internal_cpu_0_data_master_requests_uart_0_s1;
  --uart_0_s1_any_bursting_master_saved_grant mux, which is an e_mux
  uart_0_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --uart_0_s1_arb_share_counter_next_value assignment, which is an e_assign
  uart_0_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(uart_0_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (uart_0_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(uart_0_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (uart_0_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --uart_0_s1_allgrants all slave grants, which is an e_mux
  uart_0_s1_allgrants <= uart_0_s1_grant_vector;
  --uart_0_s1_end_xfer assignment, which is an e_assign
  uart_0_s1_end_xfer <= NOT ((uart_0_s1_waits_for_read OR uart_0_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_uart_0_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_uart_0_s1 <= uart_0_s1_end_xfer AND (((NOT uart_0_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --uart_0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  uart_0_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_uart_0_s1 AND uart_0_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_uart_0_s1 AND NOT uart_0_s1_non_bursting_master_requests));
  --uart_0_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      uart_0_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(uart_0_s1_arb_counter_enable) = '1' then 
        uart_0_s1_arb_share_counter <= uart_0_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --uart_0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      uart_0_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((uart_0_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_uart_0_s1)) OR ((end_xfer_arb_share_counter_term_uart_0_s1 AND NOT uart_0_s1_non_bursting_master_requests)))) = '1' then 
        uart_0_s1_slavearbiterlockenable <= or_reduce(uart_0_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master uart_0/s1 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= uart_0_s1_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --uart_0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  uart_0_s1_slavearbiterlockenable2 <= or_reduce(uart_0_s1_arb_share_counter_next_value);
  --cpu_0/data_master uart_0/s1 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= uart_0_s1_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --uart_0_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  uart_0_s1_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_uart_0_s1 <= internal_cpu_0_data_master_requests_uart_0_s1;
  --uart_0_s1_writedata mux, which is an e_mux
  uart_0_s1_writedata <= cpu_0_data_master_writedata (15 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_0_data_master_granted_uart_0_s1 <= internal_cpu_0_data_master_qualified_request_uart_0_s1;
  --cpu_0/data_master saved-grant uart_0/s1, which is an e_assign
  cpu_0_data_master_saved_grant_uart_0_s1 <= internal_cpu_0_data_master_requests_uart_0_s1;
  --allow new arb cycle for uart_0/s1, which is an e_assign
  uart_0_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  uart_0_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  uart_0_s1_master_qreq_vector <= std_logic'('1');
  uart_0_s1_begintransfer <= uart_0_s1_begins_xfer;
  --uart_0_s1_reset_n assignment, which is an e_assign
  uart_0_s1_reset_n <= reset_n;
  uart_0_s1_chipselect <= internal_cpu_0_data_master_granted_uart_0_s1;
  --uart_0_s1_firsttransfer first transaction, which is an e_assign
  uart_0_s1_firsttransfer <= A_WE_StdLogic((std_logic'(uart_0_s1_begins_xfer) = '1'), uart_0_s1_unreg_firsttransfer, uart_0_s1_reg_firsttransfer);
  --uart_0_s1_unreg_firsttransfer first transaction, which is an e_assign
  uart_0_s1_unreg_firsttransfer <= NOT ((uart_0_s1_slavearbiterlockenable AND uart_0_s1_any_continuerequest));
  --uart_0_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      uart_0_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(uart_0_s1_begins_xfer) = '1' then 
        uart_0_s1_reg_firsttransfer <= uart_0_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --uart_0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  uart_0_s1_beginbursttransfer_internal <= uart_0_s1_begins_xfer;
  --~uart_0_s1_read_n assignment, which is an e_mux
  uart_0_s1_read_n <= NOT ((internal_cpu_0_data_master_granted_uart_0_s1 AND cpu_0_data_master_read));
  --~uart_0_s1_write_n assignment, which is an e_mux
  uart_0_s1_write_n <= NOT ((internal_cpu_0_data_master_granted_uart_0_s1 AND cpu_0_data_master_write));
  shifted_address_to_uart_0_s1_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --uart_0_s1_address mux, which is an e_mux
  uart_0_s1_address <= A_EXT (A_SRL(shifted_address_to_uart_0_s1_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")), 3);
  --d1_uart_0_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_uart_0_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_uart_0_s1_end_xfer <= uart_0_s1_end_xfer;
    end if;

  end process;

  --uart_0_s1_waits_for_read in a cycle, which is an e_mux
  uart_0_s1_waits_for_read <= uart_0_s1_in_a_read_cycle AND uart_0_s1_begins_xfer;
  --uart_0_s1_in_a_read_cycle assignment, which is an e_assign
  uart_0_s1_in_a_read_cycle <= internal_cpu_0_data_master_granted_uart_0_s1 AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= uart_0_s1_in_a_read_cycle;
  --uart_0_s1_waits_for_write in a cycle, which is an e_mux
  uart_0_s1_waits_for_write <= uart_0_s1_in_a_write_cycle AND uart_0_s1_begins_xfer;
  --uart_0_s1_in_a_write_cycle assignment, which is an e_assign
  uart_0_s1_in_a_write_cycle <= internal_cpu_0_data_master_granted_uart_0_s1 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= uart_0_s1_in_a_write_cycle;
  wait_for_uart_0_s1_counter <= std_logic'('0');
  --assign uart_0_s1_irq_from_sa = uart_0_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  uart_0_s1_irq_from_sa <= uart_0_s1_irq;
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_uart_0_s1 <= internal_cpu_0_data_master_granted_uart_0_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_uart_0_s1 <= internal_cpu_0_data_master_qualified_request_uart_0_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_uart_0_s1 <= internal_cpu_0_data_master_requests_uart_0_s1;
--synthesis translate_off
    --uart_0/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity SOPC_File_reset_clk_0_domain_synch_module is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC
              );
end entity SOPC_File_reset_clk_0_domain_synch_module;


architecture europa of SOPC_File_reset_clk_0_domain_synch_module is
                signal data_in_d1 :  STD_LOGIC;
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of data_in_d1 : signal is "{-from ""*""} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of data_out : signal is "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101";

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      data_in_d1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      data_in_d1 <= data_in;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      data_out <= std_logic'('0');
    elsif clk'event and clk = '1' then
      data_out <= data_in_d1;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity SOPC_File is 
        port (
              -- 1) global signals:
                 signal altpll_0_c0_out : OUT STD_LOGIC;
                 signal altpll_0_c1_out : OUT STD_LOGIC;
                 signal clk_0 : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- the_LEDG
                 signal out_port_from_the_LEDG : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);

              -- the_LEDR
                 signal out_port_from_the_LEDR : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);

              -- the_altpll_0
                 signal locked_from_the_altpll_0 : OUT STD_LOGIC;
                 signal phasedone_from_the_altpll_0 : OUT STD_LOGIC;

              -- the_char_lcd
                 signal LCD_E_from_the_char_lcd : OUT STD_LOGIC;
                 signal LCD_RS_from_the_char_lcd : OUT STD_LOGIC;
                 signal LCD_RW_from_the_char_lcd : OUT STD_LOGIC;
                 signal LCD_data_to_and_from_the_char_lcd : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);

              -- the_note_0
                 signal out_port_from_the_note_0 : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);

              -- the_note_1
                 signal out_port_from_the_note_1 : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);

              -- the_note_2
                 signal out_port_from_the_note_2 : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);

              -- the_note_3
                 signal out_port_from_the_note_3 : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);

              -- the_note_4
                 signal out_port_from_the_note_4 : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);

              -- the_note_5
                 signal out_port_from_the_note_5 : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);

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
                 signal txd_from_the_uart_0 : OUT STD_LOGIC
              );
end entity SOPC_File;


architecture europa of SOPC_File is
component LEDG_s1_arbitrator is 
           port (
                 -- inputs:
                    signal LEDG_s1_readdata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal LEDG_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal LEDG_s1_chipselect : OUT STD_LOGIC;
                    signal LEDG_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal LEDG_s1_reset_n : OUT STD_LOGIC;
                    signal LEDG_s1_write_n : OUT STD_LOGIC;
                    signal LEDG_s1_writedata : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal cpu_0_data_master_granted_LEDG_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_LEDG_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_LEDG_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_LEDG_s1 : OUT STD_LOGIC;
                    signal d1_LEDG_s1_end_xfer : OUT STD_LOGIC
                 );
end component LEDG_s1_arbitrator;

component LEDG is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal readdata : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
                 );
end component LEDG;

component LEDR_s1_arbitrator is 
           port (
                 -- inputs:
                    signal LEDR_s1_readdata : IN STD_LOGIC_VECTOR (17 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal LEDR_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal LEDR_s1_chipselect : OUT STD_LOGIC;
                    signal LEDR_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                    signal LEDR_s1_reset_n : OUT STD_LOGIC;
                    signal LEDR_s1_write_n : OUT STD_LOGIC;
                    signal LEDR_s1_writedata : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                    signal cpu_0_data_master_granted_LEDR_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_LEDR_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_LEDR_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_LEDR_s1 : OUT STD_LOGIC;
                    signal d1_LEDR_s1_end_xfer : OUT STD_LOGIC
                 );
end component LEDR_s1_arbitrator;

component LEDR is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (17 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                    signal readdata : OUT STD_LOGIC_VECTOR (17 DOWNTO 0)
                 );
end component LEDR;

component altpll_0_pll_slave_arbitrator is 
           port (
                 -- inputs:
                    signal altpll_0_pll_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal altpll_0_pll_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal altpll_0_pll_slave_read : OUT STD_LOGIC;
                    signal altpll_0_pll_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal altpll_0_pll_slave_reset : OUT STD_LOGIC;
                    signal altpll_0_pll_slave_write : OUT STD_LOGIC;
                    signal altpll_0_pll_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_data_master_granted_altpll_0_pll_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_altpll_0_pll_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_altpll_0_pll_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_altpll_0_pll_slave : OUT STD_LOGIC;
                    signal d1_altpll_0_pll_slave_end_xfer : OUT STD_LOGIC
                 );
end component altpll_0_pll_slave_arbitrator;

component altpll_0 is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal c0 : OUT STD_LOGIC;
                    signal c1 : OUT STD_LOGIC;
                    signal locked : OUT STD_LOGIC;
                    signal phasedone : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component altpll_0;

component char_lcd_control_slave_arbitrator is 
           port (
                 -- inputs:
                    signal char_lcd_control_slave_readdata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal char_lcd_control_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal char_lcd_control_slave_begintransfer : OUT STD_LOGIC;
                    signal char_lcd_control_slave_read : OUT STD_LOGIC;
                    signal char_lcd_control_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal char_lcd_control_slave_wait_counter_eq_0 : OUT STD_LOGIC;
                    signal char_lcd_control_slave_wait_counter_eq_1 : OUT STD_LOGIC;
                    signal char_lcd_control_slave_write : OUT STD_LOGIC;
                    signal char_lcd_control_slave_writedata : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal cpu_0_data_master_granted_char_lcd_control_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_char_lcd_control_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_char_lcd_control_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_char_lcd_control_slave : OUT STD_LOGIC;
                    signal d1_char_lcd_control_slave_end_xfer : OUT STD_LOGIC
                 );
end component char_lcd_control_slave_arbitrator;

component char_lcd is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal begintransfer : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);

                 -- outputs:
                    signal LCD_E : OUT STD_LOGIC;
                    signal LCD_RS : OUT STD_LOGIC;
                    signal LCD_RW : OUT STD_LOGIC;
                    signal LCD_data : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal readdata : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
                 );
end component char_lcd;

component cpu_0_jtag_debug_module_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_0_data_master_debugaccess : IN STD_LOGIC;
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_instruction_master_read : IN STD_LOGIC;
                    signal cpu_0_jtag_debug_module_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_jtag_debug_module_resetrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_granted_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_granted_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_requests_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_address : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal cpu_0_jtag_debug_module_begintransfer : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_0_jtag_debug_module_chipselect : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_debugaccess : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_jtag_debug_module_reset_n : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_resetrequest_from_sa : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_write : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_cpu_0_jtag_debug_module_end_xfer : OUT STD_LOGIC
                 );
end component cpu_0_jtag_debug_module_arbitrator;

component cpu_0_data_master_arbitrator is 
           port (
                 -- inputs:
                    signal LEDG_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal LEDR_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (17 DOWNTO 0);
                    signal altpll_0_pll_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal char_lcd_control_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal char_lcd_control_slave_wait_counter_eq_0 : IN STD_LOGIC;
                    signal char_lcd_control_slave_wait_counter_eq_1 : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_data_master_byteenable_sdram_0_s1 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_data_master_granted_LEDG_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_LEDR_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_altpll_0_pll_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_char_lcd_control_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_note_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_note_1_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_note_2_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_note_3_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_note_4_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_note_5_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_onchip_memory2_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_sdram_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_sysid_control_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_uC_timer_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_uart_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_LEDG_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_LEDR_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_altpll_0_pll_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_char_lcd_control_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_note_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_note_1_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_note_2_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_note_3_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_note_4_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_note_5_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_onchip_memory2_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_sdram_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_sysid_control_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_uC_timer_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_uart_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_LEDG_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_LEDR_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_altpll_0_pll_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_char_lcd_control_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_note_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_note_1_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_note_2_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_note_3_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_note_4_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_note_5_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sdram_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sysid_control_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_uC_timer_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_uart_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_LEDG_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_LEDR_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_altpll_0_pll_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_char_lcd_control_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_note_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_note_1_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_note_2_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_note_3_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_note_4_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_note_5_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_onchip_memory2_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_sdram_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_sysid_control_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_uC_timer_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_uart_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_LEDG_s1_end_xfer : IN STD_LOGIC;
                    signal d1_LEDR_s1_end_xfer : IN STD_LOGIC;
                    signal d1_altpll_0_pll_slave_end_xfer : IN STD_LOGIC;
                    signal d1_char_lcd_control_slave_end_xfer : IN STD_LOGIC;
                    signal d1_cpu_0_jtag_debug_module_end_xfer : IN STD_LOGIC;
                    signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer : IN STD_LOGIC;
                    signal d1_note_0_s1_end_xfer : IN STD_LOGIC;
                    signal d1_note_1_s1_end_xfer : IN STD_LOGIC;
                    signal d1_note_2_s1_end_xfer : IN STD_LOGIC;
                    signal d1_note_3_s1_end_xfer : IN STD_LOGIC;
                    signal d1_note_4_s1_end_xfer : IN STD_LOGIC;
                    signal d1_note_5_s1_end_xfer : IN STD_LOGIC;
                    signal d1_onchip_memory2_0_s1_end_xfer : IN STD_LOGIC;
                    signal d1_sdram_0_s1_end_xfer : IN STD_LOGIC;
                    signal d1_sysid_control_slave_end_xfer : IN STD_LOGIC;
                    signal d1_uC_timer_s1_end_xfer : IN STD_LOGIC;
                    signal d1_uart_0_s1_end_xfer : IN STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_irq_from_sa : IN STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal note_0_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal note_1_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal note_2_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal note_3_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal note_4_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal note_5_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal onchip_memory2_0_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal registered_cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sdram_0_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sdram_0_s1_waitrequest_from_sa : IN STD_LOGIC;
                    signal sysid_control_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal uC_timer_s1_irq_from_sa : IN STD_LOGIC;
                    signal uC_timer_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal uart_0_s1_irq_from_sa : IN STD_LOGIC;
                    signal uart_0_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal cpu_0_data_master_address_to_slave : OUT STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_data_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_data_master_dbs_write_16 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal cpu_0_data_master_irq : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_data_master_no_byte_enables_and_last_term : OUT STD_LOGIC;
                    signal cpu_0_data_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_data_master_waitrequest : OUT STD_LOGIC
                 );
end component cpu_0_data_master_arbitrator;

component cpu_0_instruction_master_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_instruction_master_address : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_instruction_master_granted_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_instruction_master_granted_onchip_memory2_0_s1 : IN STD_LOGIC;
                    signal cpu_0_instruction_master_granted_sdram_0_s1 : IN STD_LOGIC;
                    signal cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1 : IN STD_LOGIC;
                    signal cpu_0_instruction_master_qualified_request_sdram_0_s1 : IN STD_LOGIC;
                    signal cpu_0_instruction_master_read : IN STD_LOGIC;
                    signal cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1 : IN STD_LOGIC;
                    signal cpu_0_instruction_master_read_data_valid_sdram_0_s1 : IN STD_LOGIC;
                    signal cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                    signal cpu_0_instruction_master_requests_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_instruction_master_requests_onchip_memory2_0_s1 : IN STD_LOGIC;
                    signal cpu_0_instruction_master_requests_sdram_0_s1 : IN STD_LOGIC;
                    signal cpu_0_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_cpu_0_jtag_debug_module_end_xfer : IN STD_LOGIC;
                    signal d1_onchip_memory2_0_s1_end_xfer : IN STD_LOGIC;
                    signal d1_sdram_0_s1_end_xfer : IN STD_LOGIC;
                    signal onchip_memory2_0_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal sdram_0_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sdram_0_s1_waitrequest_from_sa : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_instruction_master_address_to_slave : OUT STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_instruction_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_instruction_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_instruction_master_waitrequest : OUT STD_LOGIC
                 );
end component cpu_0_instruction_master_arbitrator;

component cpu_0 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal d_irq : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d_waitrequest : IN STD_LOGIC;
                    signal i_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal i_waitrequest : IN STD_LOGIC;
                    signal jtag_debug_module_address : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal jtag_debug_module_begintransfer : IN STD_LOGIC;
                    signal jtag_debug_module_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal jtag_debug_module_debugaccess : IN STD_LOGIC;
                    signal jtag_debug_module_select : IN STD_LOGIC;
                    signal jtag_debug_module_write : IN STD_LOGIC;
                    signal jtag_debug_module_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal d_address : OUT STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal d_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal d_read : OUT STD_LOGIC;
                    signal d_write : OUT STD_LOGIC;
                    signal d_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal i_address : OUT STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal i_read : OUT STD_LOGIC;
                    signal jtag_debug_module_debugaccess_to_roms : OUT STD_LOGIC;
                    signal jtag_debug_module_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_debug_module_resetrequest : OUT STD_LOGIC
                 );
end component cpu_0;

component jtag_uart_0_avalon_jtag_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_0_avalon_jtag_slave_dataavailable : IN STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_irq : IN STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_0_avalon_jtag_slave_readyfordata : IN STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                    signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_address : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_chipselect : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_irq_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_read_n : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_reset_n : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_write_n : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component jtag_uart_0_avalon_jtag_slave_arbitrator;

component jtag_uart_0 is 
           port (
                 -- inputs:
                    signal av_address : IN STD_LOGIC;
                    signal av_chipselect : IN STD_LOGIC;
                    signal av_read_n : IN STD_LOGIC;
                    signal av_write_n : IN STD_LOGIC;
                    signal av_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal rst_n : IN STD_LOGIC;

                 -- outputs:
                    signal av_irq : OUT STD_LOGIC;
                    signal av_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal av_waitrequest : OUT STD_LOGIC;
                    signal dataavailable : OUT STD_LOGIC;
                    signal readyfordata : OUT STD_LOGIC
                 );
end component jtag_uart_0;

component note_0_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal note_0_s1_readdata : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_granted_note_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_note_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_note_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_note_0_s1 : OUT STD_LOGIC;
                    signal d1_note_0_s1_end_xfer : OUT STD_LOGIC;
                    signal note_0_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal note_0_s1_chipselect : OUT STD_LOGIC;
                    signal note_0_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal note_0_s1_reset_n : OUT STD_LOGIC;
                    signal note_0_s1_write_n : OUT STD_LOGIC;
                    signal note_0_s1_writedata : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
                 );
end component note_0_s1_arbitrator;

component note_0 is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (19 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal readdata : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
                 );
end component note_0;

component note_1_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal note_1_s1_readdata : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_granted_note_1_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_note_1_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_note_1_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_note_1_s1 : OUT STD_LOGIC;
                    signal d1_note_1_s1_end_xfer : OUT STD_LOGIC;
                    signal note_1_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal note_1_s1_chipselect : OUT STD_LOGIC;
                    signal note_1_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal note_1_s1_reset_n : OUT STD_LOGIC;
                    signal note_1_s1_write_n : OUT STD_LOGIC;
                    signal note_1_s1_writedata : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
                 );
end component note_1_s1_arbitrator;

component note_1 is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (19 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal readdata : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
                 );
end component note_1;

component note_2_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal note_2_s1_readdata : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_granted_note_2_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_note_2_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_note_2_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_note_2_s1 : OUT STD_LOGIC;
                    signal d1_note_2_s1_end_xfer : OUT STD_LOGIC;
                    signal note_2_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal note_2_s1_chipselect : OUT STD_LOGIC;
                    signal note_2_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal note_2_s1_reset_n : OUT STD_LOGIC;
                    signal note_2_s1_write_n : OUT STD_LOGIC;
                    signal note_2_s1_writedata : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
                 );
end component note_2_s1_arbitrator;

component note_2 is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (19 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal readdata : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
                 );
end component note_2;

component note_3_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal note_3_s1_readdata : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_granted_note_3_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_note_3_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_note_3_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_note_3_s1 : OUT STD_LOGIC;
                    signal d1_note_3_s1_end_xfer : OUT STD_LOGIC;
                    signal note_3_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal note_3_s1_chipselect : OUT STD_LOGIC;
                    signal note_3_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal note_3_s1_reset_n : OUT STD_LOGIC;
                    signal note_3_s1_write_n : OUT STD_LOGIC;
                    signal note_3_s1_writedata : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
                 );
end component note_3_s1_arbitrator;

component note_3 is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (19 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal readdata : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
                 );
end component note_3;

component note_4_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal note_4_s1_readdata : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_granted_note_4_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_note_4_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_note_4_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_note_4_s1 : OUT STD_LOGIC;
                    signal d1_note_4_s1_end_xfer : OUT STD_LOGIC;
                    signal note_4_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal note_4_s1_chipselect : OUT STD_LOGIC;
                    signal note_4_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal note_4_s1_reset_n : OUT STD_LOGIC;
                    signal note_4_s1_write_n : OUT STD_LOGIC;
                    signal note_4_s1_writedata : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
                 );
end component note_4_s1_arbitrator;

component note_4 is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (19 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal readdata : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
                 );
end component note_4;

component note_5_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal note_5_s1_readdata : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_granted_note_5_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_note_5_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_note_5_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_note_5_s1 : OUT STD_LOGIC;
                    signal d1_note_5_s1_end_xfer : OUT STD_LOGIC;
                    signal note_5_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal note_5_s1_chipselect : OUT STD_LOGIC;
                    signal note_5_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal note_5_s1_reset_n : OUT STD_LOGIC;
                    signal note_5_s1_write_n : OUT STD_LOGIC;
                    signal note_5_s1_writedata : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
                 );
end component note_5_s1_arbitrator;

component note_5 is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (19 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
                    signal readdata : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
                 );
end component note_5;

component onchip_memory2_0_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_instruction_master_read : IN STD_LOGIC;
                    signal onchip_memory2_0_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_granted_onchip_memory2_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_onchip_memory2_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_onchip_memory2_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_granted_onchip_memory2_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_requests_onchip_memory2_0_s1 : OUT STD_LOGIC;
                    signal d1_onchip_memory2_0_s1_end_xfer : OUT STD_LOGIC;
                    signal onchip_memory2_0_s1_address : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
                    signal onchip_memory2_0_s1_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal onchip_memory2_0_s1_chipselect : OUT STD_LOGIC;
                    signal onchip_memory2_0_s1_clken : OUT STD_LOGIC;
                    signal onchip_memory2_0_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal onchip_memory2_0_s1_reset : OUT STD_LOGIC;
                    signal onchip_memory2_0_s1_write : OUT STD_LOGIC;
                    signal onchip_memory2_0_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal registered_cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 : OUT STD_LOGIC
                 );
end component onchip_memory2_0_s1_arbitrator;

component onchip_memory2_0 is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
                    signal byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal clken : IN STD_LOGIC;
                    signal reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component onchip_memory2_0;

component sdram_0_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_0_data_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_data_master_dbs_write_16 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal cpu_0_data_master_no_byte_enables_and_last_term : IN STD_LOGIC;
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_instruction_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_instruction_master_read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sdram_0_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sdram_0_s1_readdatavalid : IN STD_LOGIC;
                    signal sdram_0_s1_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_byteenable_sdram_0_s1 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_data_master_granted_sdram_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_sdram_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sdram_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_sdram_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_granted_sdram_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_qualified_request_sdram_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_read_data_valid_sdram_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_requests_sdram_0_s1 : OUT STD_LOGIC;
                    signal d1_sdram_0_s1_end_xfer : OUT STD_LOGIC;
                    signal sdram_0_s1_address : OUT STD_LOGIC_VECTOR (21 DOWNTO 0);
                    signal sdram_0_s1_byteenable_n : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal sdram_0_s1_chipselect : OUT STD_LOGIC;
                    signal sdram_0_s1_read_n : OUT STD_LOGIC;
                    signal sdram_0_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sdram_0_s1_reset_n : OUT STD_LOGIC;
                    signal sdram_0_s1_waitrequest_from_sa : OUT STD_LOGIC;
                    signal sdram_0_s1_write_n : OUT STD_LOGIC;
                    signal sdram_0_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component sdram_0_s1_arbitrator;

component sdram_0 is 
           port (
                 -- inputs:
                    signal az_addr : IN STD_LOGIC_VECTOR (21 DOWNTO 0);
                    signal az_be_n : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal az_cs : IN STD_LOGIC;
                    signal az_data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal az_rd_n : IN STD_LOGIC;
                    signal az_wr_n : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal za_data : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal za_valid : OUT STD_LOGIC;
                    signal za_waitrequest : OUT STD_LOGIC;
                    signal zs_addr : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
                    signal zs_ba : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal zs_cas_n : OUT STD_LOGIC;
                    signal zs_cke : OUT STD_LOGIC;
                    signal zs_cs_n : OUT STD_LOGIC;
                    signal zs_dq : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal zs_dqm : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal zs_ras_n : OUT STD_LOGIC;
                    signal zs_we_n : OUT STD_LOGIC
                 );
end component sdram_0;

component sysid_control_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sysid_control_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal cpu_0_data_master_granted_sysid_control_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_sysid_control_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sysid_control_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_sysid_control_slave : OUT STD_LOGIC;
                    signal d1_sysid_control_slave_end_xfer : OUT STD_LOGIC;
                    signal sysid_control_slave_address : OUT STD_LOGIC;
                    signal sysid_control_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal sysid_control_slave_reset_n : OUT STD_LOGIC
                 );
end component sysid_control_slave_arbitrator;

component sysid is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC;
                    signal clock : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component sysid;

component uC_timer_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal uC_timer_s1_irq : IN STD_LOGIC;
                    signal uC_timer_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal cpu_0_data_master_granted_uC_timer_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_uC_timer_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_uC_timer_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_uC_timer_s1 : OUT STD_LOGIC;
                    signal d1_uC_timer_s1_end_xfer : OUT STD_LOGIC;
                    signal uC_timer_s1_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal uC_timer_s1_chipselect : OUT STD_LOGIC;
                    signal uC_timer_s1_irq_from_sa : OUT STD_LOGIC;
                    signal uC_timer_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal uC_timer_s1_reset_n : OUT STD_LOGIC;
                    signal uC_timer_s1_write_n : OUT STD_LOGIC;
                    signal uC_timer_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component uC_timer_s1_arbitrator;

component uC_timer is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal irq : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component uC_timer;

component uart_0_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (24 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal uart_0_s1_dataavailable : IN STD_LOGIC;
                    signal uart_0_s1_irq : IN STD_LOGIC;
                    signal uart_0_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal uart_0_s1_readyfordata : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_granted_uart_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_uart_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_uart_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_uart_0_s1 : OUT STD_LOGIC;
                    signal d1_uart_0_s1_end_xfer : OUT STD_LOGIC;
                    signal uart_0_s1_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal uart_0_s1_begintransfer : OUT STD_LOGIC;
                    signal uart_0_s1_chipselect : OUT STD_LOGIC;
                    signal uart_0_s1_dataavailable_from_sa : OUT STD_LOGIC;
                    signal uart_0_s1_irq_from_sa : OUT STD_LOGIC;
                    signal uart_0_s1_read_n : OUT STD_LOGIC;
                    signal uart_0_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal uart_0_s1_readyfordata_from_sa : OUT STD_LOGIC;
                    signal uart_0_s1_reset_n : OUT STD_LOGIC;
                    signal uart_0_s1_write_n : OUT STD_LOGIC;
                    signal uart_0_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component uart_0_s1_arbitrator;

component uart_0 is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal begintransfer : IN STD_LOGIC;
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal read_n : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal rxd : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal dataavailable : OUT STD_LOGIC;
                    signal irq : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal readyfordata : OUT STD_LOGIC;
                    signal txd : OUT STD_LOGIC
                 );
end component uart_0;

component SOPC_File_reset_clk_0_domain_synch_module is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC
                 );
end component SOPC_File_reset_clk_0_domain_synch_module;

                signal LEDG_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal LEDG_s1_chipselect :  STD_LOGIC;
                signal LEDG_s1_readdata :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal LEDG_s1_readdata_from_sa :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal LEDG_s1_reset_n :  STD_LOGIC;
                signal LEDG_s1_write_n :  STD_LOGIC;
                signal LEDG_s1_writedata :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal LEDR_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal LEDR_s1_chipselect :  STD_LOGIC;
                signal LEDR_s1_readdata :  STD_LOGIC_VECTOR (17 DOWNTO 0);
                signal LEDR_s1_readdata_from_sa :  STD_LOGIC_VECTOR (17 DOWNTO 0);
                signal LEDR_s1_reset_n :  STD_LOGIC;
                signal LEDR_s1_write_n :  STD_LOGIC;
                signal LEDR_s1_writedata :  STD_LOGIC_VECTOR (17 DOWNTO 0);
                signal altpll_0_pll_slave_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal altpll_0_pll_slave_read :  STD_LOGIC;
                signal altpll_0_pll_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal altpll_0_pll_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal altpll_0_pll_slave_reset :  STD_LOGIC;
                signal altpll_0_pll_slave_write :  STD_LOGIC;
                signal altpll_0_pll_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal char_lcd_control_slave_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal char_lcd_control_slave_begintransfer :  STD_LOGIC;
                signal char_lcd_control_slave_read :  STD_LOGIC;
                signal char_lcd_control_slave_readdata :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal char_lcd_control_slave_readdata_from_sa :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal char_lcd_control_slave_wait_counter_eq_0 :  STD_LOGIC;
                signal char_lcd_control_slave_wait_counter_eq_1 :  STD_LOGIC;
                signal char_lcd_control_slave_write :  STD_LOGIC;
                signal char_lcd_control_slave_writedata :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal clk_0_reset_n :  STD_LOGIC;
                signal cpu_0_data_master_address :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal cpu_0_data_master_address_to_slave :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal cpu_0_data_master_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_0_data_master_byteenable_sdram_0_s1 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_data_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_data_master_dbs_write_16 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal cpu_0_data_master_debugaccess :  STD_LOGIC;
                signal cpu_0_data_master_granted_LEDG_s1 :  STD_LOGIC;
                signal cpu_0_data_master_granted_LEDR_s1 :  STD_LOGIC;
                signal cpu_0_data_master_granted_altpll_0_pll_slave :  STD_LOGIC;
                signal cpu_0_data_master_granted_char_lcd_control_slave :  STD_LOGIC;
                signal cpu_0_data_master_granted_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_0_data_master_granted_note_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_granted_note_1_s1 :  STD_LOGIC;
                signal cpu_0_data_master_granted_note_2_s1 :  STD_LOGIC;
                signal cpu_0_data_master_granted_note_3_s1 :  STD_LOGIC;
                signal cpu_0_data_master_granted_note_4_s1 :  STD_LOGIC;
                signal cpu_0_data_master_granted_note_5_s1 :  STD_LOGIC;
                signal cpu_0_data_master_granted_onchip_memory2_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_granted_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_granted_sysid_control_slave :  STD_LOGIC;
                signal cpu_0_data_master_granted_uC_timer_s1 :  STD_LOGIC;
                signal cpu_0_data_master_granted_uart_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_irq :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_0_data_master_no_byte_enables_and_last_term :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_LEDG_s1 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_LEDR_s1 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_altpll_0_pll_slave :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_char_lcd_control_slave :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_note_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_note_1_s1 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_note_2_s1 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_note_3_s1 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_note_4_s1 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_note_5_s1 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_onchip_memory2_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_sysid_control_slave :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_uC_timer_s1 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_uart_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_read :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_LEDG_s1 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_LEDR_s1 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_altpll_0_pll_slave :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_char_lcd_control_slave :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_note_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_note_1_s1 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_note_2_s1 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_note_3_s1 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_note_4_s1 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_note_5_s1 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_sysid_control_slave :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_uC_timer_s1 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_uart_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_0_data_master_requests_LEDG_s1 :  STD_LOGIC;
                signal cpu_0_data_master_requests_LEDR_s1 :  STD_LOGIC;
                signal cpu_0_data_master_requests_altpll_0_pll_slave :  STD_LOGIC;
                signal cpu_0_data_master_requests_char_lcd_control_slave :  STD_LOGIC;
                signal cpu_0_data_master_requests_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_0_data_master_requests_note_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_requests_note_1_s1 :  STD_LOGIC;
                signal cpu_0_data_master_requests_note_2_s1 :  STD_LOGIC;
                signal cpu_0_data_master_requests_note_3_s1 :  STD_LOGIC;
                signal cpu_0_data_master_requests_note_4_s1 :  STD_LOGIC;
                signal cpu_0_data_master_requests_note_5_s1 :  STD_LOGIC;
                signal cpu_0_data_master_requests_onchip_memory2_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_requests_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_requests_sysid_control_slave :  STD_LOGIC;
                signal cpu_0_data_master_requests_uC_timer_s1 :  STD_LOGIC;
                signal cpu_0_data_master_requests_uart_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_waitrequest :  STD_LOGIC;
                signal cpu_0_data_master_write :  STD_LOGIC;
                signal cpu_0_data_master_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_0_instruction_master_address :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal cpu_0_instruction_master_address_to_slave :  STD_LOGIC_VECTOR (24 DOWNTO 0);
                signal cpu_0_instruction_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_instruction_master_granted_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_instruction_master_granted_onchip_memory2_0_s1 :  STD_LOGIC;
                signal cpu_0_instruction_master_granted_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1 :  STD_LOGIC;
                signal cpu_0_instruction_master_qualified_request_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_instruction_master_read :  STD_LOGIC;
                signal cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1 :  STD_LOGIC;
                signal cpu_0_instruction_master_read_data_valid_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register :  STD_LOGIC;
                signal cpu_0_instruction_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_0_instruction_master_requests_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_instruction_master_requests_onchip_memory2_0_s1 :  STD_LOGIC;
                signal cpu_0_instruction_master_requests_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_instruction_master_waitrequest :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_address :  STD_LOGIC_VECTOR (8 DOWNTO 0);
                signal cpu_0_jtag_debug_module_begintransfer :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_0_jtag_debug_module_chipselect :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_debugaccess :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_0_jtag_debug_module_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_0_jtag_debug_module_reset_n :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_resetrequest :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_resetrequest_from_sa :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_write :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal d1_LEDG_s1_end_xfer :  STD_LOGIC;
                signal d1_LEDR_s1_end_xfer :  STD_LOGIC;
                signal d1_altpll_0_pll_slave_end_xfer :  STD_LOGIC;
                signal d1_char_lcd_control_slave_end_xfer :  STD_LOGIC;
                signal d1_cpu_0_jtag_debug_module_end_xfer :  STD_LOGIC;
                signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer :  STD_LOGIC;
                signal d1_note_0_s1_end_xfer :  STD_LOGIC;
                signal d1_note_1_s1_end_xfer :  STD_LOGIC;
                signal d1_note_2_s1_end_xfer :  STD_LOGIC;
                signal d1_note_3_s1_end_xfer :  STD_LOGIC;
                signal d1_note_4_s1_end_xfer :  STD_LOGIC;
                signal d1_note_5_s1_end_xfer :  STD_LOGIC;
                signal d1_onchip_memory2_0_s1_end_xfer :  STD_LOGIC;
                signal d1_sdram_0_s1_end_xfer :  STD_LOGIC;
                signal d1_sysid_control_slave_end_xfer :  STD_LOGIC;
                signal d1_uC_timer_s1_end_xfer :  STD_LOGIC;
                signal d1_uart_0_s1_end_xfer :  STD_LOGIC;
                signal internal_LCD_E_from_the_char_lcd :  STD_LOGIC;
                signal internal_LCD_RS_from_the_char_lcd :  STD_LOGIC;
                signal internal_LCD_RW_from_the_char_lcd :  STD_LOGIC;
                signal internal_locked_from_the_altpll_0 :  STD_LOGIC;
                signal internal_out_port_from_the_LEDG :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal internal_out_port_from_the_LEDR :  STD_LOGIC_VECTOR (17 DOWNTO 0);
                signal internal_out_port_from_the_note_0 :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal internal_out_port_from_the_note_1 :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal internal_out_port_from_the_note_2 :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal internal_out_port_from_the_note_3 :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal internal_out_port_from_the_note_4 :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal internal_out_port_from_the_note_5 :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal internal_phasedone_from_the_altpll_0 :  STD_LOGIC;
                signal internal_txd_from_the_uart_0 :  STD_LOGIC;
                signal internal_zs_addr_from_the_sdram_0 :  STD_LOGIC_VECTOR (11 DOWNTO 0);
                signal internal_zs_ba_from_the_sdram_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_zs_cas_n_from_the_sdram_0 :  STD_LOGIC;
                signal internal_zs_cke_from_the_sdram_0 :  STD_LOGIC;
                signal internal_zs_cs_n_from_the_sdram_0 :  STD_LOGIC;
                signal internal_zs_dqm_from_the_sdram_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_zs_ras_n_from_the_sdram_0 :  STD_LOGIC;
                signal internal_zs_we_n_from_the_sdram_0 :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_address :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_chipselect :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_dataavailable :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_irq :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_irq_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_read_n :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal jtag_uart_0_avalon_jtag_slave_readyfordata :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_reset_n :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_waitrequest :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_write_n :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal module_input6 :  STD_LOGIC;
                signal note_0_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_0_s1_chipselect :  STD_LOGIC;
                signal note_0_s1_readdata :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal note_0_s1_readdata_from_sa :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal note_0_s1_reset_n :  STD_LOGIC;
                signal note_0_s1_write_n :  STD_LOGIC;
                signal note_0_s1_writedata :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal note_1_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_1_s1_chipselect :  STD_LOGIC;
                signal note_1_s1_readdata :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal note_1_s1_readdata_from_sa :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal note_1_s1_reset_n :  STD_LOGIC;
                signal note_1_s1_write_n :  STD_LOGIC;
                signal note_1_s1_writedata :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal note_2_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_2_s1_chipselect :  STD_LOGIC;
                signal note_2_s1_readdata :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal note_2_s1_readdata_from_sa :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal note_2_s1_reset_n :  STD_LOGIC;
                signal note_2_s1_write_n :  STD_LOGIC;
                signal note_2_s1_writedata :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal note_3_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_3_s1_chipselect :  STD_LOGIC;
                signal note_3_s1_readdata :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal note_3_s1_readdata_from_sa :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal note_3_s1_reset_n :  STD_LOGIC;
                signal note_3_s1_write_n :  STD_LOGIC;
                signal note_3_s1_writedata :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal note_4_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_4_s1_chipselect :  STD_LOGIC;
                signal note_4_s1_readdata :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal note_4_s1_readdata_from_sa :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal note_4_s1_reset_n :  STD_LOGIC;
                signal note_4_s1_write_n :  STD_LOGIC;
                signal note_4_s1_writedata :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal note_5_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal note_5_s1_chipselect :  STD_LOGIC;
                signal note_5_s1_readdata :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal note_5_s1_readdata_from_sa :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal note_5_s1_reset_n :  STD_LOGIC;
                signal note_5_s1_write_n :  STD_LOGIC;
                signal note_5_s1_writedata :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal onchip_memory2_0_s1_address :  STD_LOGIC_VECTOR (10 DOWNTO 0);
                signal onchip_memory2_0_s1_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal onchip_memory2_0_s1_chipselect :  STD_LOGIC;
                signal onchip_memory2_0_s1_clken :  STD_LOGIC;
                signal onchip_memory2_0_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal onchip_memory2_0_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal onchip_memory2_0_s1_reset :  STD_LOGIC;
                signal onchip_memory2_0_s1_write :  STD_LOGIC;
                signal onchip_memory2_0_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal out_clk_altpll_0_c0 :  STD_LOGIC;
                signal out_clk_altpll_0_c1 :  STD_LOGIC;
                signal registered_cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 :  STD_LOGIC;
                signal reset_n_sources :  STD_LOGIC;
                signal sdram_0_s1_address :  STD_LOGIC_VECTOR (21 DOWNTO 0);
                signal sdram_0_s1_byteenable_n :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_chipselect :  STD_LOGIC;
                signal sdram_0_s1_read_n :  STD_LOGIC;
                signal sdram_0_s1_readdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal sdram_0_s1_readdata_from_sa :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal sdram_0_s1_readdatavalid :  STD_LOGIC;
                signal sdram_0_s1_reset_n :  STD_LOGIC;
                signal sdram_0_s1_waitrequest :  STD_LOGIC;
                signal sdram_0_s1_waitrequest_from_sa :  STD_LOGIC;
                signal sdram_0_s1_write_n :  STD_LOGIC;
                signal sdram_0_s1_writedata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal sysid_control_slave_address :  STD_LOGIC;
                signal sysid_control_slave_clock :  STD_LOGIC;
                signal sysid_control_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal sysid_control_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal sysid_control_slave_reset_n :  STD_LOGIC;
                signal uC_timer_s1_address :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal uC_timer_s1_chipselect :  STD_LOGIC;
                signal uC_timer_s1_irq :  STD_LOGIC;
                signal uC_timer_s1_irq_from_sa :  STD_LOGIC;
                signal uC_timer_s1_readdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal uC_timer_s1_readdata_from_sa :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal uC_timer_s1_reset_n :  STD_LOGIC;
                signal uC_timer_s1_write_n :  STD_LOGIC;
                signal uC_timer_s1_writedata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal uart_0_s1_address :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal uart_0_s1_begintransfer :  STD_LOGIC;
                signal uart_0_s1_chipselect :  STD_LOGIC;
                signal uart_0_s1_dataavailable :  STD_LOGIC;
                signal uart_0_s1_dataavailable_from_sa :  STD_LOGIC;
                signal uart_0_s1_irq :  STD_LOGIC;
                signal uart_0_s1_irq_from_sa :  STD_LOGIC;
                signal uart_0_s1_read_n :  STD_LOGIC;
                signal uart_0_s1_readdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal uart_0_s1_readdata_from_sa :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal uart_0_s1_readyfordata :  STD_LOGIC;
                signal uart_0_s1_readyfordata_from_sa :  STD_LOGIC;
                signal uart_0_s1_reset_n :  STD_LOGIC;
                signal uart_0_s1_write_n :  STD_LOGIC;
                signal uart_0_s1_writedata :  STD_LOGIC_VECTOR (15 DOWNTO 0);

begin

  --the_LEDG_s1, which is an e_instance
  the_LEDG_s1 : LEDG_s1_arbitrator
    port map(
      LEDG_s1_address => LEDG_s1_address,
      LEDG_s1_chipselect => LEDG_s1_chipselect,
      LEDG_s1_readdata_from_sa => LEDG_s1_readdata_from_sa,
      LEDG_s1_reset_n => LEDG_s1_reset_n,
      LEDG_s1_write_n => LEDG_s1_write_n,
      LEDG_s1_writedata => LEDG_s1_writedata,
      cpu_0_data_master_granted_LEDG_s1 => cpu_0_data_master_granted_LEDG_s1,
      cpu_0_data_master_qualified_request_LEDG_s1 => cpu_0_data_master_qualified_request_LEDG_s1,
      cpu_0_data_master_read_data_valid_LEDG_s1 => cpu_0_data_master_read_data_valid_LEDG_s1,
      cpu_0_data_master_requests_LEDG_s1 => cpu_0_data_master_requests_LEDG_s1,
      d1_LEDG_s1_end_xfer => d1_LEDG_s1_end_xfer,
      LEDG_s1_readdata => LEDG_s1_readdata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_byteenable => cpu_0_data_master_byteenable,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      reset_n => clk_0_reset_n
    );


  --the_LEDG, which is an e_ptf_instance
  the_LEDG : LEDG
    port map(
      out_port => internal_out_port_from_the_LEDG,
      readdata => LEDG_s1_readdata,
      address => LEDG_s1_address,
      chipselect => LEDG_s1_chipselect,
      clk => clk_0,
      reset_n => LEDG_s1_reset_n,
      write_n => LEDG_s1_write_n,
      writedata => LEDG_s1_writedata
    );


  --the_LEDR_s1, which is an e_instance
  the_LEDR_s1 : LEDR_s1_arbitrator
    port map(
      LEDR_s1_address => LEDR_s1_address,
      LEDR_s1_chipselect => LEDR_s1_chipselect,
      LEDR_s1_readdata_from_sa => LEDR_s1_readdata_from_sa,
      LEDR_s1_reset_n => LEDR_s1_reset_n,
      LEDR_s1_write_n => LEDR_s1_write_n,
      LEDR_s1_writedata => LEDR_s1_writedata,
      cpu_0_data_master_granted_LEDR_s1 => cpu_0_data_master_granted_LEDR_s1,
      cpu_0_data_master_qualified_request_LEDR_s1 => cpu_0_data_master_qualified_request_LEDR_s1,
      cpu_0_data_master_read_data_valid_LEDR_s1 => cpu_0_data_master_read_data_valid_LEDR_s1,
      cpu_0_data_master_requests_LEDR_s1 => cpu_0_data_master_requests_LEDR_s1,
      d1_LEDR_s1_end_xfer => d1_LEDR_s1_end_xfer,
      LEDR_s1_readdata => LEDR_s1_readdata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      reset_n => clk_0_reset_n
    );


  --the_LEDR, which is an e_ptf_instance
  the_LEDR : LEDR
    port map(
      out_port => internal_out_port_from_the_LEDR,
      readdata => LEDR_s1_readdata,
      address => LEDR_s1_address,
      chipselect => LEDR_s1_chipselect,
      clk => clk_0,
      reset_n => LEDR_s1_reset_n,
      write_n => LEDR_s1_write_n,
      writedata => LEDR_s1_writedata
    );


  --the_altpll_0_pll_slave, which is an e_instance
  the_altpll_0_pll_slave : altpll_0_pll_slave_arbitrator
    port map(
      altpll_0_pll_slave_address => altpll_0_pll_slave_address,
      altpll_0_pll_slave_read => altpll_0_pll_slave_read,
      altpll_0_pll_slave_readdata_from_sa => altpll_0_pll_slave_readdata_from_sa,
      altpll_0_pll_slave_reset => altpll_0_pll_slave_reset,
      altpll_0_pll_slave_write => altpll_0_pll_slave_write,
      altpll_0_pll_slave_writedata => altpll_0_pll_slave_writedata,
      cpu_0_data_master_granted_altpll_0_pll_slave => cpu_0_data_master_granted_altpll_0_pll_slave,
      cpu_0_data_master_qualified_request_altpll_0_pll_slave => cpu_0_data_master_qualified_request_altpll_0_pll_slave,
      cpu_0_data_master_read_data_valid_altpll_0_pll_slave => cpu_0_data_master_read_data_valid_altpll_0_pll_slave,
      cpu_0_data_master_requests_altpll_0_pll_slave => cpu_0_data_master_requests_altpll_0_pll_slave,
      d1_altpll_0_pll_slave_end_xfer => d1_altpll_0_pll_slave_end_xfer,
      altpll_0_pll_slave_readdata => altpll_0_pll_slave_readdata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      reset_n => clk_0_reset_n
    );


  --altpll_0_c0_out out_clk assignment, which is an e_assign
  altpll_0_c0_out <= out_clk_altpll_0_c0;
  --altpll_0_c1_out out_clk assignment, which is an e_assign
  altpll_0_c1_out <= out_clk_altpll_0_c1;
  --the_altpll_0, which is an e_ptf_instance
  the_altpll_0 : altpll_0
    port map(
      c0 => out_clk_altpll_0_c0,
      c1 => out_clk_altpll_0_c1,
      locked => internal_locked_from_the_altpll_0,
      phasedone => internal_phasedone_from_the_altpll_0,
      readdata => altpll_0_pll_slave_readdata,
      address => altpll_0_pll_slave_address,
      clk => clk_0,
      read => altpll_0_pll_slave_read,
      reset => altpll_0_pll_slave_reset,
      write => altpll_0_pll_slave_write,
      writedata => altpll_0_pll_slave_writedata
    );


  --the_char_lcd_control_slave, which is an e_instance
  the_char_lcd_control_slave : char_lcd_control_slave_arbitrator
    port map(
      char_lcd_control_slave_address => char_lcd_control_slave_address,
      char_lcd_control_slave_begintransfer => char_lcd_control_slave_begintransfer,
      char_lcd_control_slave_read => char_lcd_control_slave_read,
      char_lcd_control_slave_readdata_from_sa => char_lcd_control_slave_readdata_from_sa,
      char_lcd_control_slave_wait_counter_eq_0 => char_lcd_control_slave_wait_counter_eq_0,
      char_lcd_control_slave_wait_counter_eq_1 => char_lcd_control_slave_wait_counter_eq_1,
      char_lcd_control_slave_write => char_lcd_control_slave_write,
      char_lcd_control_slave_writedata => char_lcd_control_slave_writedata,
      cpu_0_data_master_granted_char_lcd_control_slave => cpu_0_data_master_granted_char_lcd_control_slave,
      cpu_0_data_master_qualified_request_char_lcd_control_slave => cpu_0_data_master_qualified_request_char_lcd_control_slave,
      cpu_0_data_master_read_data_valid_char_lcd_control_slave => cpu_0_data_master_read_data_valid_char_lcd_control_slave,
      cpu_0_data_master_requests_char_lcd_control_slave => cpu_0_data_master_requests_char_lcd_control_slave,
      d1_char_lcd_control_slave_end_xfer => d1_char_lcd_control_slave_end_xfer,
      char_lcd_control_slave_readdata => char_lcd_control_slave_readdata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_byteenable => cpu_0_data_master_byteenable,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      reset_n => clk_0_reset_n
    );


  --the_char_lcd, which is an e_ptf_instance
  the_char_lcd : char_lcd
    port map(
      LCD_E => internal_LCD_E_from_the_char_lcd,
      LCD_RS => internal_LCD_RS_from_the_char_lcd,
      LCD_RW => internal_LCD_RW_from_the_char_lcd,
      LCD_data => LCD_data_to_and_from_the_char_lcd,
      readdata => char_lcd_control_slave_readdata,
      address => char_lcd_control_slave_address,
      begintransfer => char_lcd_control_slave_begintransfer,
      read => char_lcd_control_slave_read,
      write => char_lcd_control_slave_write,
      writedata => char_lcd_control_slave_writedata
    );


  --the_cpu_0_jtag_debug_module, which is an e_instance
  the_cpu_0_jtag_debug_module : cpu_0_jtag_debug_module_arbitrator
    port map(
      cpu_0_data_master_granted_cpu_0_jtag_debug_module => cpu_0_data_master_granted_cpu_0_jtag_debug_module,
      cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module => cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module,
      cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module => cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module,
      cpu_0_data_master_requests_cpu_0_jtag_debug_module => cpu_0_data_master_requests_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_granted_cpu_0_jtag_debug_module => cpu_0_instruction_master_granted_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module => cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module => cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_requests_cpu_0_jtag_debug_module => cpu_0_instruction_master_requests_cpu_0_jtag_debug_module,
      cpu_0_jtag_debug_module_address => cpu_0_jtag_debug_module_address,
      cpu_0_jtag_debug_module_begintransfer => cpu_0_jtag_debug_module_begintransfer,
      cpu_0_jtag_debug_module_byteenable => cpu_0_jtag_debug_module_byteenable,
      cpu_0_jtag_debug_module_chipselect => cpu_0_jtag_debug_module_chipselect,
      cpu_0_jtag_debug_module_debugaccess => cpu_0_jtag_debug_module_debugaccess,
      cpu_0_jtag_debug_module_readdata_from_sa => cpu_0_jtag_debug_module_readdata_from_sa,
      cpu_0_jtag_debug_module_reset_n => cpu_0_jtag_debug_module_reset_n,
      cpu_0_jtag_debug_module_resetrequest_from_sa => cpu_0_jtag_debug_module_resetrequest_from_sa,
      cpu_0_jtag_debug_module_write => cpu_0_jtag_debug_module_write,
      cpu_0_jtag_debug_module_writedata => cpu_0_jtag_debug_module_writedata,
      d1_cpu_0_jtag_debug_module_end_xfer => d1_cpu_0_jtag_debug_module_end_xfer,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_byteenable => cpu_0_data_master_byteenable,
      cpu_0_data_master_debugaccess => cpu_0_data_master_debugaccess,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      cpu_0_instruction_master_address_to_slave => cpu_0_instruction_master_address_to_slave,
      cpu_0_instruction_master_read => cpu_0_instruction_master_read,
      cpu_0_jtag_debug_module_readdata => cpu_0_jtag_debug_module_readdata,
      cpu_0_jtag_debug_module_resetrequest => cpu_0_jtag_debug_module_resetrequest,
      reset_n => clk_0_reset_n
    );


  --the_cpu_0_data_master, which is an e_instance
  the_cpu_0_data_master : cpu_0_data_master_arbitrator
    port map(
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_dbs_address => cpu_0_data_master_dbs_address,
      cpu_0_data_master_dbs_write_16 => cpu_0_data_master_dbs_write_16,
      cpu_0_data_master_irq => cpu_0_data_master_irq,
      cpu_0_data_master_no_byte_enables_and_last_term => cpu_0_data_master_no_byte_enables_and_last_term,
      cpu_0_data_master_readdata => cpu_0_data_master_readdata,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      LEDG_s1_readdata_from_sa => LEDG_s1_readdata_from_sa,
      LEDR_s1_readdata_from_sa => LEDR_s1_readdata_from_sa,
      altpll_0_pll_slave_readdata_from_sa => altpll_0_pll_slave_readdata_from_sa,
      char_lcd_control_slave_readdata_from_sa => char_lcd_control_slave_readdata_from_sa,
      char_lcd_control_slave_wait_counter_eq_0 => char_lcd_control_slave_wait_counter_eq_0,
      char_lcd_control_slave_wait_counter_eq_1 => char_lcd_control_slave_wait_counter_eq_1,
      clk => clk_0,
      cpu_0_data_master_address => cpu_0_data_master_address,
      cpu_0_data_master_byteenable_sdram_0_s1 => cpu_0_data_master_byteenable_sdram_0_s1,
      cpu_0_data_master_granted_LEDG_s1 => cpu_0_data_master_granted_LEDG_s1,
      cpu_0_data_master_granted_LEDR_s1 => cpu_0_data_master_granted_LEDR_s1,
      cpu_0_data_master_granted_altpll_0_pll_slave => cpu_0_data_master_granted_altpll_0_pll_slave,
      cpu_0_data_master_granted_char_lcd_control_slave => cpu_0_data_master_granted_char_lcd_control_slave,
      cpu_0_data_master_granted_cpu_0_jtag_debug_module => cpu_0_data_master_granted_cpu_0_jtag_debug_module,
      cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_granted_note_0_s1 => cpu_0_data_master_granted_note_0_s1,
      cpu_0_data_master_granted_note_1_s1 => cpu_0_data_master_granted_note_1_s1,
      cpu_0_data_master_granted_note_2_s1 => cpu_0_data_master_granted_note_2_s1,
      cpu_0_data_master_granted_note_3_s1 => cpu_0_data_master_granted_note_3_s1,
      cpu_0_data_master_granted_note_4_s1 => cpu_0_data_master_granted_note_4_s1,
      cpu_0_data_master_granted_note_5_s1 => cpu_0_data_master_granted_note_5_s1,
      cpu_0_data_master_granted_onchip_memory2_0_s1 => cpu_0_data_master_granted_onchip_memory2_0_s1,
      cpu_0_data_master_granted_sdram_0_s1 => cpu_0_data_master_granted_sdram_0_s1,
      cpu_0_data_master_granted_sysid_control_slave => cpu_0_data_master_granted_sysid_control_slave,
      cpu_0_data_master_granted_uC_timer_s1 => cpu_0_data_master_granted_uC_timer_s1,
      cpu_0_data_master_granted_uart_0_s1 => cpu_0_data_master_granted_uart_0_s1,
      cpu_0_data_master_qualified_request_LEDG_s1 => cpu_0_data_master_qualified_request_LEDG_s1,
      cpu_0_data_master_qualified_request_LEDR_s1 => cpu_0_data_master_qualified_request_LEDR_s1,
      cpu_0_data_master_qualified_request_altpll_0_pll_slave => cpu_0_data_master_qualified_request_altpll_0_pll_slave,
      cpu_0_data_master_qualified_request_char_lcd_control_slave => cpu_0_data_master_qualified_request_char_lcd_control_slave,
      cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module => cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module,
      cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_qualified_request_note_0_s1 => cpu_0_data_master_qualified_request_note_0_s1,
      cpu_0_data_master_qualified_request_note_1_s1 => cpu_0_data_master_qualified_request_note_1_s1,
      cpu_0_data_master_qualified_request_note_2_s1 => cpu_0_data_master_qualified_request_note_2_s1,
      cpu_0_data_master_qualified_request_note_3_s1 => cpu_0_data_master_qualified_request_note_3_s1,
      cpu_0_data_master_qualified_request_note_4_s1 => cpu_0_data_master_qualified_request_note_4_s1,
      cpu_0_data_master_qualified_request_note_5_s1 => cpu_0_data_master_qualified_request_note_5_s1,
      cpu_0_data_master_qualified_request_onchip_memory2_0_s1 => cpu_0_data_master_qualified_request_onchip_memory2_0_s1,
      cpu_0_data_master_qualified_request_sdram_0_s1 => cpu_0_data_master_qualified_request_sdram_0_s1,
      cpu_0_data_master_qualified_request_sysid_control_slave => cpu_0_data_master_qualified_request_sysid_control_slave,
      cpu_0_data_master_qualified_request_uC_timer_s1 => cpu_0_data_master_qualified_request_uC_timer_s1,
      cpu_0_data_master_qualified_request_uart_0_s1 => cpu_0_data_master_qualified_request_uart_0_s1,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_read_data_valid_LEDG_s1 => cpu_0_data_master_read_data_valid_LEDG_s1,
      cpu_0_data_master_read_data_valid_LEDR_s1 => cpu_0_data_master_read_data_valid_LEDR_s1,
      cpu_0_data_master_read_data_valid_altpll_0_pll_slave => cpu_0_data_master_read_data_valid_altpll_0_pll_slave,
      cpu_0_data_master_read_data_valid_char_lcd_control_slave => cpu_0_data_master_read_data_valid_char_lcd_control_slave,
      cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module => cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module,
      cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_read_data_valid_note_0_s1 => cpu_0_data_master_read_data_valid_note_0_s1,
      cpu_0_data_master_read_data_valid_note_1_s1 => cpu_0_data_master_read_data_valid_note_1_s1,
      cpu_0_data_master_read_data_valid_note_2_s1 => cpu_0_data_master_read_data_valid_note_2_s1,
      cpu_0_data_master_read_data_valid_note_3_s1 => cpu_0_data_master_read_data_valid_note_3_s1,
      cpu_0_data_master_read_data_valid_note_4_s1 => cpu_0_data_master_read_data_valid_note_4_s1,
      cpu_0_data_master_read_data_valid_note_5_s1 => cpu_0_data_master_read_data_valid_note_5_s1,
      cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 => cpu_0_data_master_read_data_valid_onchip_memory2_0_s1,
      cpu_0_data_master_read_data_valid_sdram_0_s1 => cpu_0_data_master_read_data_valid_sdram_0_s1,
      cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register => cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
      cpu_0_data_master_read_data_valid_sysid_control_slave => cpu_0_data_master_read_data_valid_sysid_control_slave,
      cpu_0_data_master_read_data_valid_uC_timer_s1 => cpu_0_data_master_read_data_valid_uC_timer_s1,
      cpu_0_data_master_read_data_valid_uart_0_s1 => cpu_0_data_master_read_data_valid_uart_0_s1,
      cpu_0_data_master_requests_LEDG_s1 => cpu_0_data_master_requests_LEDG_s1,
      cpu_0_data_master_requests_LEDR_s1 => cpu_0_data_master_requests_LEDR_s1,
      cpu_0_data_master_requests_altpll_0_pll_slave => cpu_0_data_master_requests_altpll_0_pll_slave,
      cpu_0_data_master_requests_char_lcd_control_slave => cpu_0_data_master_requests_char_lcd_control_slave,
      cpu_0_data_master_requests_cpu_0_jtag_debug_module => cpu_0_data_master_requests_cpu_0_jtag_debug_module,
      cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_requests_note_0_s1 => cpu_0_data_master_requests_note_0_s1,
      cpu_0_data_master_requests_note_1_s1 => cpu_0_data_master_requests_note_1_s1,
      cpu_0_data_master_requests_note_2_s1 => cpu_0_data_master_requests_note_2_s1,
      cpu_0_data_master_requests_note_3_s1 => cpu_0_data_master_requests_note_3_s1,
      cpu_0_data_master_requests_note_4_s1 => cpu_0_data_master_requests_note_4_s1,
      cpu_0_data_master_requests_note_5_s1 => cpu_0_data_master_requests_note_5_s1,
      cpu_0_data_master_requests_onchip_memory2_0_s1 => cpu_0_data_master_requests_onchip_memory2_0_s1,
      cpu_0_data_master_requests_sdram_0_s1 => cpu_0_data_master_requests_sdram_0_s1,
      cpu_0_data_master_requests_sysid_control_slave => cpu_0_data_master_requests_sysid_control_slave,
      cpu_0_data_master_requests_uC_timer_s1 => cpu_0_data_master_requests_uC_timer_s1,
      cpu_0_data_master_requests_uart_0_s1 => cpu_0_data_master_requests_uart_0_s1,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      cpu_0_jtag_debug_module_readdata_from_sa => cpu_0_jtag_debug_module_readdata_from_sa,
      d1_LEDG_s1_end_xfer => d1_LEDG_s1_end_xfer,
      d1_LEDR_s1_end_xfer => d1_LEDR_s1_end_xfer,
      d1_altpll_0_pll_slave_end_xfer => d1_altpll_0_pll_slave_end_xfer,
      d1_char_lcd_control_slave_end_xfer => d1_char_lcd_control_slave_end_xfer,
      d1_cpu_0_jtag_debug_module_end_xfer => d1_cpu_0_jtag_debug_module_end_xfer,
      d1_jtag_uart_0_avalon_jtag_slave_end_xfer => d1_jtag_uart_0_avalon_jtag_slave_end_xfer,
      d1_note_0_s1_end_xfer => d1_note_0_s1_end_xfer,
      d1_note_1_s1_end_xfer => d1_note_1_s1_end_xfer,
      d1_note_2_s1_end_xfer => d1_note_2_s1_end_xfer,
      d1_note_3_s1_end_xfer => d1_note_3_s1_end_xfer,
      d1_note_4_s1_end_xfer => d1_note_4_s1_end_xfer,
      d1_note_5_s1_end_xfer => d1_note_5_s1_end_xfer,
      d1_onchip_memory2_0_s1_end_xfer => d1_onchip_memory2_0_s1_end_xfer,
      d1_sdram_0_s1_end_xfer => d1_sdram_0_s1_end_xfer,
      d1_sysid_control_slave_end_xfer => d1_sysid_control_slave_end_xfer,
      d1_uC_timer_s1_end_xfer => d1_uC_timer_s1_end_xfer,
      d1_uart_0_s1_end_xfer => d1_uart_0_s1_end_xfer,
      jtag_uart_0_avalon_jtag_slave_irq_from_sa => jtag_uart_0_avalon_jtag_slave_irq_from_sa,
      jtag_uart_0_avalon_jtag_slave_readdata_from_sa => jtag_uart_0_avalon_jtag_slave_readdata_from_sa,
      jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa => jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa,
      note_0_s1_readdata_from_sa => note_0_s1_readdata_from_sa,
      note_1_s1_readdata_from_sa => note_1_s1_readdata_from_sa,
      note_2_s1_readdata_from_sa => note_2_s1_readdata_from_sa,
      note_3_s1_readdata_from_sa => note_3_s1_readdata_from_sa,
      note_4_s1_readdata_from_sa => note_4_s1_readdata_from_sa,
      note_5_s1_readdata_from_sa => note_5_s1_readdata_from_sa,
      onchip_memory2_0_s1_readdata_from_sa => onchip_memory2_0_s1_readdata_from_sa,
      registered_cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 => registered_cpu_0_data_master_read_data_valid_onchip_memory2_0_s1,
      reset_n => clk_0_reset_n,
      sdram_0_s1_readdata_from_sa => sdram_0_s1_readdata_from_sa,
      sdram_0_s1_waitrequest_from_sa => sdram_0_s1_waitrequest_from_sa,
      sysid_control_slave_readdata_from_sa => sysid_control_slave_readdata_from_sa,
      uC_timer_s1_irq_from_sa => uC_timer_s1_irq_from_sa,
      uC_timer_s1_readdata_from_sa => uC_timer_s1_readdata_from_sa,
      uart_0_s1_irq_from_sa => uart_0_s1_irq_from_sa,
      uart_0_s1_readdata_from_sa => uart_0_s1_readdata_from_sa
    );


  --the_cpu_0_instruction_master, which is an e_instance
  the_cpu_0_instruction_master : cpu_0_instruction_master_arbitrator
    port map(
      cpu_0_instruction_master_address_to_slave => cpu_0_instruction_master_address_to_slave,
      cpu_0_instruction_master_dbs_address => cpu_0_instruction_master_dbs_address,
      cpu_0_instruction_master_readdata => cpu_0_instruction_master_readdata,
      cpu_0_instruction_master_waitrequest => cpu_0_instruction_master_waitrequest,
      clk => clk_0,
      cpu_0_instruction_master_address => cpu_0_instruction_master_address,
      cpu_0_instruction_master_granted_cpu_0_jtag_debug_module => cpu_0_instruction_master_granted_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_granted_onchip_memory2_0_s1 => cpu_0_instruction_master_granted_onchip_memory2_0_s1,
      cpu_0_instruction_master_granted_sdram_0_s1 => cpu_0_instruction_master_granted_sdram_0_s1,
      cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module => cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1 => cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1,
      cpu_0_instruction_master_qualified_request_sdram_0_s1 => cpu_0_instruction_master_qualified_request_sdram_0_s1,
      cpu_0_instruction_master_read => cpu_0_instruction_master_read,
      cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module => cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1 => cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1,
      cpu_0_instruction_master_read_data_valid_sdram_0_s1 => cpu_0_instruction_master_read_data_valid_sdram_0_s1,
      cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register => cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
      cpu_0_instruction_master_requests_cpu_0_jtag_debug_module => cpu_0_instruction_master_requests_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_requests_onchip_memory2_0_s1 => cpu_0_instruction_master_requests_onchip_memory2_0_s1,
      cpu_0_instruction_master_requests_sdram_0_s1 => cpu_0_instruction_master_requests_sdram_0_s1,
      cpu_0_jtag_debug_module_readdata_from_sa => cpu_0_jtag_debug_module_readdata_from_sa,
      d1_cpu_0_jtag_debug_module_end_xfer => d1_cpu_0_jtag_debug_module_end_xfer,
      d1_onchip_memory2_0_s1_end_xfer => d1_onchip_memory2_0_s1_end_xfer,
      d1_sdram_0_s1_end_xfer => d1_sdram_0_s1_end_xfer,
      onchip_memory2_0_s1_readdata_from_sa => onchip_memory2_0_s1_readdata_from_sa,
      reset_n => clk_0_reset_n,
      sdram_0_s1_readdata_from_sa => sdram_0_s1_readdata_from_sa,
      sdram_0_s1_waitrequest_from_sa => sdram_0_s1_waitrequest_from_sa
    );


  --the_cpu_0, which is an e_ptf_instance
  the_cpu_0 : cpu_0
    port map(
      d_address => cpu_0_data_master_address,
      d_byteenable => cpu_0_data_master_byteenable,
      d_read => cpu_0_data_master_read,
      d_write => cpu_0_data_master_write,
      d_writedata => cpu_0_data_master_writedata,
      i_address => cpu_0_instruction_master_address,
      i_read => cpu_0_instruction_master_read,
      jtag_debug_module_debugaccess_to_roms => cpu_0_data_master_debugaccess,
      jtag_debug_module_readdata => cpu_0_jtag_debug_module_readdata,
      jtag_debug_module_resetrequest => cpu_0_jtag_debug_module_resetrequest,
      clk => clk_0,
      d_irq => cpu_0_data_master_irq,
      d_readdata => cpu_0_data_master_readdata,
      d_waitrequest => cpu_0_data_master_waitrequest,
      i_readdata => cpu_0_instruction_master_readdata,
      i_waitrequest => cpu_0_instruction_master_waitrequest,
      jtag_debug_module_address => cpu_0_jtag_debug_module_address,
      jtag_debug_module_begintransfer => cpu_0_jtag_debug_module_begintransfer,
      jtag_debug_module_byteenable => cpu_0_jtag_debug_module_byteenable,
      jtag_debug_module_debugaccess => cpu_0_jtag_debug_module_debugaccess,
      jtag_debug_module_select => cpu_0_jtag_debug_module_chipselect,
      jtag_debug_module_write => cpu_0_jtag_debug_module_write,
      jtag_debug_module_writedata => cpu_0_jtag_debug_module_writedata,
      reset_n => cpu_0_jtag_debug_module_reset_n
    );


  --the_jtag_uart_0_avalon_jtag_slave, which is an e_instance
  the_jtag_uart_0_avalon_jtag_slave : jtag_uart_0_avalon_jtag_slave_arbitrator
    port map(
      cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave,
      d1_jtag_uart_0_avalon_jtag_slave_end_xfer => d1_jtag_uart_0_avalon_jtag_slave_end_xfer,
      jtag_uart_0_avalon_jtag_slave_address => jtag_uart_0_avalon_jtag_slave_address,
      jtag_uart_0_avalon_jtag_slave_chipselect => jtag_uart_0_avalon_jtag_slave_chipselect,
      jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa => jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa,
      jtag_uart_0_avalon_jtag_slave_irq_from_sa => jtag_uart_0_avalon_jtag_slave_irq_from_sa,
      jtag_uart_0_avalon_jtag_slave_read_n => jtag_uart_0_avalon_jtag_slave_read_n,
      jtag_uart_0_avalon_jtag_slave_readdata_from_sa => jtag_uart_0_avalon_jtag_slave_readdata_from_sa,
      jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa => jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa,
      jtag_uart_0_avalon_jtag_slave_reset_n => jtag_uart_0_avalon_jtag_slave_reset_n,
      jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa => jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa,
      jtag_uart_0_avalon_jtag_slave_write_n => jtag_uart_0_avalon_jtag_slave_write_n,
      jtag_uart_0_avalon_jtag_slave_writedata => jtag_uart_0_avalon_jtag_slave_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      jtag_uart_0_avalon_jtag_slave_dataavailable => jtag_uart_0_avalon_jtag_slave_dataavailable,
      jtag_uart_0_avalon_jtag_slave_irq => jtag_uart_0_avalon_jtag_slave_irq,
      jtag_uart_0_avalon_jtag_slave_readdata => jtag_uart_0_avalon_jtag_slave_readdata,
      jtag_uart_0_avalon_jtag_slave_readyfordata => jtag_uart_0_avalon_jtag_slave_readyfordata,
      jtag_uart_0_avalon_jtag_slave_waitrequest => jtag_uart_0_avalon_jtag_slave_waitrequest,
      reset_n => clk_0_reset_n
    );


  --the_jtag_uart_0, which is an e_ptf_instance
  the_jtag_uart_0 : jtag_uart_0
    port map(
      av_irq => jtag_uart_0_avalon_jtag_slave_irq,
      av_readdata => jtag_uart_0_avalon_jtag_slave_readdata,
      av_waitrequest => jtag_uart_0_avalon_jtag_slave_waitrequest,
      dataavailable => jtag_uart_0_avalon_jtag_slave_dataavailable,
      readyfordata => jtag_uart_0_avalon_jtag_slave_readyfordata,
      av_address => jtag_uart_0_avalon_jtag_slave_address,
      av_chipselect => jtag_uart_0_avalon_jtag_slave_chipselect,
      av_read_n => jtag_uart_0_avalon_jtag_slave_read_n,
      av_write_n => jtag_uart_0_avalon_jtag_slave_write_n,
      av_writedata => jtag_uart_0_avalon_jtag_slave_writedata,
      clk => clk_0,
      rst_n => jtag_uart_0_avalon_jtag_slave_reset_n
    );


  --the_note_0_s1, which is an e_instance
  the_note_0_s1 : note_0_s1_arbitrator
    port map(
      cpu_0_data_master_granted_note_0_s1 => cpu_0_data_master_granted_note_0_s1,
      cpu_0_data_master_qualified_request_note_0_s1 => cpu_0_data_master_qualified_request_note_0_s1,
      cpu_0_data_master_read_data_valid_note_0_s1 => cpu_0_data_master_read_data_valid_note_0_s1,
      cpu_0_data_master_requests_note_0_s1 => cpu_0_data_master_requests_note_0_s1,
      d1_note_0_s1_end_xfer => d1_note_0_s1_end_xfer,
      note_0_s1_address => note_0_s1_address,
      note_0_s1_chipselect => note_0_s1_chipselect,
      note_0_s1_readdata_from_sa => note_0_s1_readdata_from_sa,
      note_0_s1_reset_n => note_0_s1_reset_n,
      note_0_s1_write_n => note_0_s1_write_n,
      note_0_s1_writedata => note_0_s1_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      note_0_s1_readdata => note_0_s1_readdata,
      reset_n => clk_0_reset_n
    );


  --the_note_0, which is an e_ptf_instance
  the_note_0 : note_0
    port map(
      out_port => internal_out_port_from_the_note_0,
      readdata => note_0_s1_readdata,
      address => note_0_s1_address,
      chipselect => note_0_s1_chipselect,
      clk => clk_0,
      reset_n => note_0_s1_reset_n,
      write_n => note_0_s1_write_n,
      writedata => note_0_s1_writedata
    );


  --the_note_1_s1, which is an e_instance
  the_note_1_s1 : note_1_s1_arbitrator
    port map(
      cpu_0_data_master_granted_note_1_s1 => cpu_0_data_master_granted_note_1_s1,
      cpu_0_data_master_qualified_request_note_1_s1 => cpu_0_data_master_qualified_request_note_1_s1,
      cpu_0_data_master_read_data_valid_note_1_s1 => cpu_0_data_master_read_data_valid_note_1_s1,
      cpu_0_data_master_requests_note_1_s1 => cpu_0_data_master_requests_note_1_s1,
      d1_note_1_s1_end_xfer => d1_note_1_s1_end_xfer,
      note_1_s1_address => note_1_s1_address,
      note_1_s1_chipselect => note_1_s1_chipselect,
      note_1_s1_readdata_from_sa => note_1_s1_readdata_from_sa,
      note_1_s1_reset_n => note_1_s1_reset_n,
      note_1_s1_write_n => note_1_s1_write_n,
      note_1_s1_writedata => note_1_s1_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      note_1_s1_readdata => note_1_s1_readdata,
      reset_n => clk_0_reset_n
    );


  --the_note_1, which is an e_ptf_instance
  the_note_1 : note_1
    port map(
      out_port => internal_out_port_from_the_note_1,
      readdata => note_1_s1_readdata,
      address => note_1_s1_address,
      chipselect => note_1_s1_chipselect,
      clk => clk_0,
      reset_n => note_1_s1_reset_n,
      write_n => note_1_s1_write_n,
      writedata => note_1_s1_writedata
    );


  --the_note_2_s1, which is an e_instance
  the_note_2_s1 : note_2_s1_arbitrator
    port map(
      cpu_0_data_master_granted_note_2_s1 => cpu_0_data_master_granted_note_2_s1,
      cpu_0_data_master_qualified_request_note_2_s1 => cpu_0_data_master_qualified_request_note_2_s1,
      cpu_0_data_master_read_data_valid_note_2_s1 => cpu_0_data_master_read_data_valid_note_2_s1,
      cpu_0_data_master_requests_note_2_s1 => cpu_0_data_master_requests_note_2_s1,
      d1_note_2_s1_end_xfer => d1_note_2_s1_end_xfer,
      note_2_s1_address => note_2_s1_address,
      note_2_s1_chipselect => note_2_s1_chipselect,
      note_2_s1_readdata_from_sa => note_2_s1_readdata_from_sa,
      note_2_s1_reset_n => note_2_s1_reset_n,
      note_2_s1_write_n => note_2_s1_write_n,
      note_2_s1_writedata => note_2_s1_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      note_2_s1_readdata => note_2_s1_readdata,
      reset_n => clk_0_reset_n
    );


  --the_note_2, which is an e_ptf_instance
  the_note_2 : note_2
    port map(
      out_port => internal_out_port_from_the_note_2,
      readdata => note_2_s1_readdata,
      address => note_2_s1_address,
      chipselect => note_2_s1_chipselect,
      clk => clk_0,
      reset_n => note_2_s1_reset_n,
      write_n => note_2_s1_write_n,
      writedata => note_2_s1_writedata
    );


  --the_note_3_s1, which is an e_instance
  the_note_3_s1 : note_3_s1_arbitrator
    port map(
      cpu_0_data_master_granted_note_3_s1 => cpu_0_data_master_granted_note_3_s1,
      cpu_0_data_master_qualified_request_note_3_s1 => cpu_0_data_master_qualified_request_note_3_s1,
      cpu_0_data_master_read_data_valid_note_3_s1 => cpu_0_data_master_read_data_valid_note_3_s1,
      cpu_0_data_master_requests_note_3_s1 => cpu_0_data_master_requests_note_3_s1,
      d1_note_3_s1_end_xfer => d1_note_3_s1_end_xfer,
      note_3_s1_address => note_3_s1_address,
      note_3_s1_chipselect => note_3_s1_chipselect,
      note_3_s1_readdata_from_sa => note_3_s1_readdata_from_sa,
      note_3_s1_reset_n => note_3_s1_reset_n,
      note_3_s1_write_n => note_3_s1_write_n,
      note_3_s1_writedata => note_3_s1_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      note_3_s1_readdata => note_3_s1_readdata,
      reset_n => clk_0_reset_n
    );


  --the_note_3, which is an e_ptf_instance
  the_note_3 : note_3
    port map(
      out_port => internal_out_port_from_the_note_3,
      readdata => note_3_s1_readdata,
      address => note_3_s1_address,
      chipselect => note_3_s1_chipselect,
      clk => clk_0,
      reset_n => note_3_s1_reset_n,
      write_n => note_3_s1_write_n,
      writedata => note_3_s1_writedata
    );


  --the_note_4_s1, which is an e_instance
  the_note_4_s1 : note_4_s1_arbitrator
    port map(
      cpu_0_data_master_granted_note_4_s1 => cpu_0_data_master_granted_note_4_s1,
      cpu_0_data_master_qualified_request_note_4_s1 => cpu_0_data_master_qualified_request_note_4_s1,
      cpu_0_data_master_read_data_valid_note_4_s1 => cpu_0_data_master_read_data_valid_note_4_s1,
      cpu_0_data_master_requests_note_4_s1 => cpu_0_data_master_requests_note_4_s1,
      d1_note_4_s1_end_xfer => d1_note_4_s1_end_xfer,
      note_4_s1_address => note_4_s1_address,
      note_4_s1_chipselect => note_4_s1_chipselect,
      note_4_s1_readdata_from_sa => note_4_s1_readdata_from_sa,
      note_4_s1_reset_n => note_4_s1_reset_n,
      note_4_s1_write_n => note_4_s1_write_n,
      note_4_s1_writedata => note_4_s1_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      note_4_s1_readdata => note_4_s1_readdata,
      reset_n => clk_0_reset_n
    );


  --the_note_4, which is an e_ptf_instance
  the_note_4 : note_4
    port map(
      out_port => internal_out_port_from_the_note_4,
      readdata => note_4_s1_readdata,
      address => note_4_s1_address,
      chipselect => note_4_s1_chipselect,
      clk => clk_0,
      reset_n => note_4_s1_reset_n,
      write_n => note_4_s1_write_n,
      writedata => note_4_s1_writedata
    );


  --the_note_5_s1, which is an e_instance
  the_note_5_s1 : note_5_s1_arbitrator
    port map(
      cpu_0_data_master_granted_note_5_s1 => cpu_0_data_master_granted_note_5_s1,
      cpu_0_data_master_qualified_request_note_5_s1 => cpu_0_data_master_qualified_request_note_5_s1,
      cpu_0_data_master_read_data_valid_note_5_s1 => cpu_0_data_master_read_data_valid_note_5_s1,
      cpu_0_data_master_requests_note_5_s1 => cpu_0_data_master_requests_note_5_s1,
      d1_note_5_s1_end_xfer => d1_note_5_s1_end_xfer,
      note_5_s1_address => note_5_s1_address,
      note_5_s1_chipselect => note_5_s1_chipselect,
      note_5_s1_readdata_from_sa => note_5_s1_readdata_from_sa,
      note_5_s1_reset_n => note_5_s1_reset_n,
      note_5_s1_write_n => note_5_s1_write_n,
      note_5_s1_writedata => note_5_s1_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      note_5_s1_readdata => note_5_s1_readdata,
      reset_n => clk_0_reset_n
    );


  --the_note_5, which is an e_ptf_instance
  the_note_5 : note_5
    port map(
      out_port => internal_out_port_from_the_note_5,
      readdata => note_5_s1_readdata,
      address => note_5_s1_address,
      chipselect => note_5_s1_chipselect,
      clk => clk_0,
      reset_n => note_5_s1_reset_n,
      write_n => note_5_s1_write_n,
      writedata => note_5_s1_writedata
    );


  --the_onchip_memory2_0_s1, which is an e_instance
  the_onchip_memory2_0_s1 : onchip_memory2_0_s1_arbitrator
    port map(
      cpu_0_data_master_granted_onchip_memory2_0_s1 => cpu_0_data_master_granted_onchip_memory2_0_s1,
      cpu_0_data_master_qualified_request_onchip_memory2_0_s1 => cpu_0_data_master_qualified_request_onchip_memory2_0_s1,
      cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 => cpu_0_data_master_read_data_valid_onchip_memory2_0_s1,
      cpu_0_data_master_requests_onchip_memory2_0_s1 => cpu_0_data_master_requests_onchip_memory2_0_s1,
      cpu_0_instruction_master_granted_onchip_memory2_0_s1 => cpu_0_instruction_master_granted_onchip_memory2_0_s1,
      cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1 => cpu_0_instruction_master_qualified_request_onchip_memory2_0_s1,
      cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1 => cpu_0_instruction_master_read_data_valid_onchip_memory2_0_s1,
      cpu_0_instruction_master_requests_onchip_memory2_0_s1 => cpu_0_instruction_master_requests_onchip_memory2_0_s1,
      d1_onchip_memory2_0_s1_end_xfer => d1_onchip_memory2_0_s1_end_xfer,
      onchip_memory2_0_s1_address => onchip_memory2_0_s1_address,
      onchip_memory2_0_s1_byteenable => onchip_memory2_0_s1_byteenable,
      onchip_memory2_0_s1_chipselect => onchip_memory2_0_s1_chipselect,
      onchip_memory2_0_s1_clken => onchip_memory2_0_s1_clken,
      onchip_memory2_0_s1_readdata_from_sa => onchip_memory2_0_s1_readdata_from_sa,
      onchip_memory2_0_s1_reset => onchip_memory2_0_s1_reset,
      onchip_memory2_0_s1_write => onchip_memory2_0_s1_write,
      onchip_memory2_0_s1_writedata => onchip_memory2_0_s1_writedata,
      registered_cpu_0_data_master_read_data_valid_onchip_memory2_0_s1 => registered_cpu_0_data_master_read_data_valid_onchip_memory2_0_s1,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_byteenable => cpu_0_data_master_byteenable,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      cpu_0_instruction_master_address_to_slave => cpu_0_instruction_master_address_to_slave,
      cpu_0_instruction_master_read => cpu_0_instruction_master_read,
      onchip_memory2_0_s1_readdata => onchip_memory2_0_s1_readdata,
      reset_n => clk_0_reset_n
    );


  --the_onchip_memory2_0, which is an e_ptf_instance
  the_onchip_memory2_0 : onchip_memory2_0
    port map(
      readdata => onchip_memory2_0_s1_readdata,
      address => onchip_memory2_0_s1_address,
      byteenable => onchip_memory2_0_s1_byteenable,
      chipselect => onchip_memory2_0_s1_chipselect,
      clk => clk_0,
      clken => onchip_memory2_0_s1_clken,
      reset => onchip_memory2_0_s1_reset,
      write => onchip_memory2_0_s1_write,
      writedata => onchip_memory2_0_s1_writedata
    );


  --the_sdram_0_s1, which is an e_instance
  the_sdram_0_s1 : sdram_0_s1_arbitrator
    port map(
      cpu_0_data_master_byteenable_sdram_0_s1 => cpu_0_data_master_byteenable_sdram_0_s1,
      cpu_0_data_master_granted_sdram_0_s1 => cpu_0_data_master_granted_sdram_0_s1,
      cpu_0_data_master_qualified_request_sdram_0_s1 => cpu_0_data_master_qualified_request_sdram_0_s1,
      cpu_0_data_master_read_data_valid_sdram_0_s1 => cpu_0_data_master_read_data_valid_sdram_0_s1,
      cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register => cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
      cpu_0_data_master_requests_sdram_0_s1 => cpu_0_data_master_requests_sdram_0_s1,
      cpu_0_instruction_master_granted_sdram_0_s1 => cpu_0_instruction_master_granted_sdram_0_s1,
      cpu_0_instruction_master_qualified_request_sdram_0_s1 => cpu_0_instruction_master_qualified_request_sdram_0_s1,
      cpu_0_instruction_master_read_data_valid_sdram_0_s1 => cpu_0_instruction_master_read_data_valid_sdram_0_s1,
      cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register => cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
      cpu_0_instruction_master_requests_sdram_0_s1 => cpu_0_instruction_master_requests_sdram_0_s1,
      d1_sdram_0_s1_end_xfer => d1_sdram_0_s1_end_xfer,
      sdram_0_s1_address => sdram_0_s1_address,
      sdram_0_s1_byteenable_n => sdram_0_s1_byteenable_n,
      sdram_0_s1_chipselect => sdram_0_s1_chipselect,
      sdram_0_s1_read_n => sdram_0_s1_read_n,
      sdram_0_s1_readdata_from_sa => sdram_0_s1_readdata_from_sa,
      sdram_0_s1_reset_n => sdram_0_s1_reset_n,
      sdram_0_s1_waitrequest_from_sa => sdram_0_s1_waitrequest_from_sa,
      sdram_0_s1_write_n => sdram_0_s1_write_n,
      sdram_0_s1_writedata => sdram_0_s1_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_byteenable => cpu_0_data_master_byteenable,
      cpu_0_data_master_dbs_address => cpu_0_data_master_dbs_address,
      cpu_0_data_master_dbs_write_16 => cpu_0_data_master_dbs_write_16,
      cpu_0_data_master_no_byte_enables_and_last_term => cpu_0_data_master_no_byte_enables_and_last_term,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_instruction_master_address_to_slave => cpu_0_instruction_master_address_to_slave,
      cpu_0_instruction_master_dbs_address => cpu_0_instruction_master_dbs_address,
      cpu_0_instruction_master_read => cpu_0_instruction_master_read,
      reset_n => clk_0_reset_n,
      sdram_0_s1_readdata => sdram_0_s1_readdata,
      sdram_0_s1_readdatavalid => sdram_0_s1_readdatavalid,
      sdram_0_s1_waitrequest => sdram_0_s1_waitrequest
    );


  --the_sdram_0, which is an e_ptf_instance
  the_sdram_0 : sdram_0
    port map(
      za_data => sdram_0_s1_readdata,
      za_valid => sdram_0_s1_readdatavalid,
      za_waitrequest => sdram_0_s1_waitrequest,
      zs_addr => internal_zs_addr_from_the_sdram_0,
      zs_ba => internal_zs_ba_from_the_sdram_0,
      zs_cas_n => internal_zs_cas_n_from_the_sdram_0,
      zs_cke => internal_zs_cke_from_the_sdram_0,
      zs_cs_n => internal_zs_cs_n_from_the_sdram_0,
      zs_dq => zs_dq_to_and_from_the_sdram_0,
      zs_dqm => internal_zs_dqm_from_the_sdram_0,
      zs_ras_n => internal_zs_ras_n_from_the_sdram_0,
      zs_we_n => internal_zs_we_n_from_the_sdram_0,
      az_addr => sdram_0_s1_address,
      az_be_n => sdram_0_s1_byteenable_n,
      az_cs => sdram_0_s1_chipselect,
      az_data => sdram_0_s1_writedata,
      az_rd_n => sdram_0_s1_read_n,
      az_wr_n => sdram_0_s1_write_n,
      clk => clk_0,
      reset_n => sdram_0_s1_reset_n
    );


  --the_sysid_control_slave, which is an e_instance
  the_sysid_control_slave : sysid_control_slave_arbitrator
    port map(
      cpu_0_data_master_granted_sysid_control_slave => cpu_0_data_master_granted_sysid_control_slave,
      cpu_0_data_master_qualified_request_sysid_control_slave => cpu_0_data_master_qualified_request_sysid_control_slave,
      cpu_0_data_master_read_data_valid_sysid_control_slave => cpu_0_data_master_read_data_valid_sysid_control_slave,
      cpu_0_data_master_requests_sysid_control_slave => cpu_0_data_master_requests_sysid_control_slave,
      d1_sysid_control_slave_end_xfer => d1_sysid_control_slave_end_xfer,
      sysid_control_slave_address => sysid_control_slave_address,
      sysid_control_slave_readdata_from_sa => sysid_control_slave_readdata_from_sa,
      sysid_control_slave_reset_n => sysid_control_slave_reset_n,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_write => cpu_0_data_master_write,
      reset_n => clk_0_reset_n,
      sysid_control_slave_readdata => sysid_control_slave_readdata
    );


  --the_sysid, which is an e_ptf_instance
  the_sysid : sysid
    port map(
      readdata => sysid_control_slave_readdata,
      address => sysid_control_slave_address,
      clock => sysid_control_slave_clock,
      reset_n => sysid_control_slave_reset_n
    );


  --the_uC_timer_s1, which is an e_instance
  the_uC_timer_s1 : uC_timer_s1_arbitrator
    port map(
      cpu_0_data_master_granted_uC_timer_s1 => cpu_0_data_master_granted_uC_timer_s1,
      cpu_0_data_master_qualified_request_uC_timer_s1 => cpu_0_data_master_qualified_request_uC_timer_s1,
      cpu_0_data_master_read_data_valid_uC_timer_s1 => cpu_0_data_master_read_data_valid_uC_timer_s1,
      cpu_0_data_master_requests_uC_timer_s1 => cpu_0_data_master_requests_uC_timer_s1,
      d1_uC_timer_s1_end_xfer => d1_uC_timer_s1_end_xfer,
      uC_timer_s1_address => uC_timer_s1_address,
      uC_timer_s1_chipselect => uC_timer_s1_chipselect,
      uC_timer_s1_irq_from_sa => uC_timer_s1_irq_from_sa,
      uC_timer_s1_readdata_from_sa => uC_timer_s1_readdata_from_sa,
      uC_timer_s1_reset_n => uC_timer_s1_reset_n,
      uC_timer_s1_write_n => uC_timer_s1_write_n,
      uC_timer_s1_writedata => uC_timer_s1_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      reset_n => clk_0_reset_n,
      uC_timer_s1_irq => uC_timer_s1_irq,
      uC_timer_s1_readdata => uC_timer_s1_readdata
    );


  --the_uC_timer, which is an e_ptf_instance
  the_uC_timer : uC_timer
    port map(
      irq => uC_timer_s1_irq,
      readdata => uC_timer_s1_readdata,
      address => uC_timer_s1_address,
      chipselect => uC_timer_s1_chipselect,
      clk => clk_0,
      reset_n => uC_timer_s1_reset_n,
      write_n => uC_timer_s1_write_n,
      writedata => uC_timer_s1_writedata
    );


  --the_uart_0_s1, which is an e_instance
  the_uart_0_s1 : uart_0_s1_arbitrator
    port map(
      cpu_0_data_master_granted_uart_0_s1 => cpu_0_data_master_granted_uart_0_s1,
      cpu_0_data_master_qualified_request_uart_0_s1 => cpu_0_data_master_qualified_request_uart_0_s1,
      cpu_0_data_master_read_data_valid_uart_0_s1 => cpu_0_data_master_read_data_valid_uart_0_s1,
      cpu_0_data_master_requests_uart_0_s1 => cpu_0_data_master_requests_uart_0_s1,
      d1_uart_0_s1_end_xfer => d1_uart_0_s1_end_xfer,
      uart_0_s1_address => uart_0_s1_address,
      uart_0_s1_begintransfer => uart_0_s1_begintransfer,
      uart_0_s1_chipselect => uart_0_s1_chipselect,
      uart_0_s1_dataavailable_from_sa => uart_0_s1_dataavailable_from_sa,
      uart_0_s1_irq_from_sa => uart_0_s1_irq_from_sa,
      uart_0_s1_read_n => uart_0_s1_read_n,
      uart_0_s1_readdata_from_sa => uart_0_s1_readdata_from_sa,
      uart_0_s1_readyfordata_from_sa => uart_0_s1_readyfordata_from_sa,
      uart_0_s1_reset_n => uart_0_s1_reset_n,
      uart_0_s1_write_n => uart_0_s1_write_n,
      uart_0_s1_writedata => uart_0_s1_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      reset_n => clk_0_reset_n,
      uart_0_s1_dataavailable => uart_0_s1_dataavailable,
      uart_0_s1_irq => uart_0_s1_irq,
      uart_0_s1_readdata => uart_0_s1_readdata,
      uart_0_s1_readyfordata => uart_0_s1_readyfordata
    );


  --the_uart_0, which is an e_ptf_instance
  the_uart_0 : uart_0
    port map(
      dataavailable => uart_0_s1_dataavailable,
      irq => uart_0_s1_irq,
      readdata => uart_0_s1_readdata,
      readyfordata => uart_0_s1_readyfordata,
      txd => internal_txd_from_the_uart_0,
      address => uart_0_s1_address,
      begintransfer => uart_0_s1_begintransfer,
      chipselect => uart_0_s1_chipselect,
      clk => clk_0,
      read_n => uart_0_s1_read_n,
      reset_n => uart_0_s1_reset_n,
      rxd => rxd_to_the_uart_0,
      write_n => uart_0_s1_write_n,
      writedata => uart_0_s1_writedata
    );


  --reset is asserted asynchronously and deasserted synchronously
  SOPC_File_reset_clk_0_domain_synch : SOPC_File_reset_clk_0_domain_synch_module
    port map(
      data_out => clk_0_reset_n,
      clk => clk_0,
      data_in => module_input6,
      reset_n => reset_n_sources
    );

  module_input6 <= std_logic'('1');

  --reset sources mux, which is an e_mux
  reset_n_sources <= Vector_To_Std_Logic(NOT (((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT reset_n))) OR std_logic_vector'("00000000000000000000000000000000")) OR (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_jtag_debug_module_resetrequest_from_sa)))) OR (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_jtag_debug_module_resetrequest_from_sa))))));
  --sysid_control_slave_clock of type clock does not connect to anything so wire it to default (0)
  sysid_control_slave_clock <= std_logic'('0');
  --vhdl renameroo for output signals
  LCD_E_from_the_char_lcd <= internal_LCD_E_from_the_char_lcd;
  --vhdl renameroo for output signals
  LCD_RS_from_the_char_lcd <= internal_LCD_RS_from_the_char_lcd;
  --vhdl renameroo for output signals
  LCD_RW_from_the_char_lcd <= internal_LCD_RW_from_the_char_lcd;
  --vhdl renameroo for output signals
  locked_from_the_altpll_0 <= internal_locked_from_the_altpll_0;
  --vhdl renameroo for output signals
  out_port_from_the_LEDG <= internal_out_port_from_the_LEDG;
  --vhdl renameroo for output signals
  out_port_from_the_LEDR <= internal_out_port_from_the_LEDR;
  --vhdl renameroo for output signals
  out_port_from_the_note_0 <= internal_out_port_from_the_note_0;
  --vhdl renameroo for output signals
  out_port_from_the_note_1 <= internal_out_port_from_the_note_1;
  --vhdl renameroo for output signals
  out_port_from_the_note_2 <= internal_out_port_from_the_note_2;
  --vhdl renameroo for output signals
  out_port_from_the_note_3 <= internal_out_port_from_the_note_3;
  --vhdl renameroo for output signals
  out_port_from_the_note_4 <= internal_out_port_from_the_note_4;
  --vhdl renameroo for output signals
  out_port_from_the_note_5 <= internal_out_port_from_the_note_5;
  --vhdl renameroo for output signals
  phasedone_from_the_altpll_0 <= internal_phasedone_from_the_altpll_0;
  --vhdl renameroo for output signals
  txd_from_the_uart_0 <= internal_txd_from_the_uart_0;
  --vhdl renameroo for output signals
  zs_addr_from_the_sdram_0 <= internal_zs_addr_from_the_sdram_0;
  --vhdl renameroo for output signals
  zs_ba_from_the_sdram_0 <= internal_zs_ba_from_the_sdram_0;
  --vhdl renameroo for output signals
  zs_cas_n_from_the_sdram_0 <= internal_zs_cas_n_from_the_sdram_0;
  --vhdl renameroo for output signals
  zs_cke_from_the_sdram_0 <= internal_zs_cke_from_the_sdram_0;
  --vhdl renameroo for output signals
  zs_cs_n_from_the_sdram_0 <= internal_zs_cs_n_from_the_sdram_0;
  --vhdl renameroo for output signals
  zs_dqm_from_the_sdram_0 <= internal_zs_dqm_from_the_sdram_0;
  --vhdl renameroo for output signals
  zs_ras_n_from_the_sdram_0 <= internal_zs_ras_n_from_the_sdram_0;
  --vhdl renameroo for output signals
  zs_we_n_from_the_sdram_0 <= internal_zs_we_n_from_the_sdram_0;

end europa;


--synthesis translate_off

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add your libraries here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>

entity test_bench is 
end entity test_bench;


architecture europa of test_bench is
component SOPC_File is 
           port (
                 -- 1) global signals:
                    signal altpll_0_c0_out : OUT STD_LOGIC;
                    signal altpll_0_c1_out : OUT STD_LOGIC;
                    signal clk_0 : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- the_LEDG
                    signal out_port_from_the_LEDG : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);

                 -- the_LEDR
                    signal out_port_from_the_LEDR : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);

                 -- the_altpll_0
                    signal locked_from_the_altpll_0 : OUT STD_LOGIC;
                    signal phasedone_from_the_altpll_0 : OUT STD_LOGIC;

                 -- the_char_lcd
                    signal LCD_E_from_the_char_lcd : OUT STD_LOGIC;
                    signal LCD_RS_from_the_char_lcd : OUT STD_LOGIC;
                    signal LCD_RW_from_the_char_lcd : OUT STD_LOGIC;
                    signal LCD_data_to_and_from_the_char_lcd : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);

                 -- the_note_0
                    signal out_port_from_the_note_0 : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);

                 -- the_note_1
                    signal out_port_from_the_note_1 : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);

                 -- the_note_2
                    signal out_port_from_the_note_2 : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);

                 -- the_note_3
                    signal out_port_from_the_note_3 : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);

                 -- the_note_4
                    signal out_port_from_the_note_4 : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);

                 -- the_note_5
                    signal out_port_from_the_note_5 : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);

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
                    signal txd_from_the_uart_0 : OUT STD_LOGIC
                 );
end component SOPC_File;

                signal LCD_E_from_the_char_lcd :  STD_LOGIC;
                signal LCD_RS_from_the_char_lcd :  STD_LOGIC;
                signal LCD_RW_from_the_char_lcd :  STD_LOGIC;
                signal LCD_data_to_and_from_the_char_lcd :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal altpll_0_c0_out :  STD_LOGIC;
                signal altpll_0_c1_out :  STD_LOGIC;
                signal clk :  STD_LOGIC;
                signal clk_0 :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa :  STD_LOGIC;
                signal locked_from_the_altpll_0 :  STD_LOGIC;
                signal out_port_from_the_LEDG :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal out_port_from_the_LEDR :  STD_LOGIC_VECTOR (17 DOWNTO 0);
                signal out_port_from_the_note_0 :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal out_port_from_the_note_1 :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal out_port_from_the_note_2 :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal out_port_from_the_note_3 :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal out_port_from_the_note_4 :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal out_port_from_the_note_5 :  STD_LOGIC_VECTOR (19 DOWNTO 0);
                signal phasedone_from_the_altpll_0 :  STD_LOGIC;
                signal reset_n :  STD_LOGIC;
                signal rxd_to_the_uart_0 :  STD_LOGIC;
                signal sysid_control_slave_clock :  STD_LOGIC;
                signal txd_from_the_uart_0 :  STD_LOGIC;
                signal uart_0_s1_dataavailable_from_sa :  STD_LOGIC;
                signal uart_0_s1_readyfordata_from_sa :  STD_LOGIC;
                signal zs_addr_from_the_sdram_0 :  STD_LOGIC_VECTOR (11 DOWNTO 0);
                signal zs_ba_from_the_sdram_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal zs_cas_n_from_the_sdram_0 :  STD_LOGIC;
                signal zs_cke_from_the_sdram_0 :  STD_LOGIC;
                signal zs_cs_n_from_the_sdram_0 :  STD_LOGIC;
                signal zs_dq_to_and_from_the_sdram_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal zs_dqm_from_the_sdram_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal zs_ras_n_from_the_sdram_0 :  STD_LOGIC;
                signal zs_we_n_from_the_sdram_0 :  STD_LOGIC;


-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add your component and signal declaration here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>


begin

  --Set us up the Dut
  DUT : SOPC_File
    port map(
      LCD_E_from_the_char_lcd => LCD_E_from_the_char_lcd,
      LCD_RS_from_the_char_lcd => LCD_RS_from_the_char_lcd,
      LCD_RW_from_the_char_lcd => LCD_RW_from_the_char_lcd,
      LCD_data_to_and_from_the_char_lcd => LCD_data_to_and_from_the_char_lcd,
      altpll_0_c0_out => altpll_0_c0_out,
      altpll_0_c1_out => altpll_0_c1_out,
      locked_from_the_altpll_0 => locked_from_the_altpll_0,
      out_port_from_the_LEDG => out_port_from_the_LEDG,
      out_port_from_the_LEDR => out_port_from_the_LEDR,
      out_port_from_the_note_0 => out_port_from_the_note_0,
      out_port_from_the_note_1 => out_port_from_the_note_1,
      out_port_from_the_note_2 => out_port_from_the_note_2,
      out_port_from_the_note_3 => out_port_from_the_note_3,
      out_port_from_the_note_4 => out_port_from_the_note_4,
      out_port_from_the_note_5 => out_port_from_the_note_5,
      phasedone_from_the_altpll_0 => phasedone_from_the_altpll_0,
      txd_from_the_uart_0 => txd_from_the_uart_0,
      zs_addr_from_the_sdram_0 => zs_addr_from_the_sdram_0,
      zs_ba_from_the_sdram_0 => zs_ba_from_the_sdram_0,
      zs_cas_n_from_the_sdram_0 => zs_cas_n_from_the_sdram_0,
      zs_cke_from_the_sdram_0 => zs_cke_from_the_sdram_0,
      zs_cs_n_from_the_sdram_0 => zs_cs_n_from_the_sdram_0,
      zs_dq_to_and_from_the_sdram_0 => zs_dq_to_and_from_the_sdram_0,
      zs_dqm_from_the_sdram_0 => zs_dqm_from_the_sdram_0,
      zs_ras_n_from_the_sdram_0 => zs_ras_n_from_the_sdram_0,
      zs_we_n_from_the_sdram_0 => zs_we_n_from_the_sdram_0,
      clk_0 => clk_0,
      reset_n => reset_n,
      rxd_to_the_uart_0 => rxd_to_the_uart_0
    );


  process
  begin
    clk_0 <= '0';
    loop
       wait for 10 ns;
       clk_0 <= not clk_0;
    end loop;
  end process;
  PROCESS
    BEGIN
       reset_n <= '0';
       wait for 200 ns;
       reset_n <= '1'; 
    WAIT;
  END PROCESS;


-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add additional architecture here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>


end europa;



--synthesis translate_on
