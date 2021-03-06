# TCL File Generated by Component Editor 10.1sp1
# Mon Mar 12 15:42:51 MDT 2012
# DO NOT MODIFY


# +-----------------------------------
# | 
# | adc_dac_controller "adc_dac_controller" v1.0
# | null 2012.03.12.15:42:51
# | 
# | 
# | /afs/ualberta.ca/home/e/l/elunty/CMPE490/MidiSynth/adc_dac_controller.vhd
# | 
# |    ./adc_dac_controller.vhd syn, sim
# | 
# +-----------------------------------

# +-----------------------------------
# | request TCL package from ACDS 10.1
# | 
package require -exact sopc 10.1
# | 
# +-----------------------------------

# +-----------------------------------
# | module adc_dac_controller
# | 
set_module_property NAME adc_dac_controller
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property DISPLAY_NAME adc_dac_controller
set_module_property TOP_LEVEL_HDL_FILE adc_dac_controller.vhd
set_module_property TOP_LEVEL_HDL_MODULE adc_dac_controller
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL TRUE
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file adc_dac_controller.vhd {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
# | 
# +-----------------------------------

# +-----------------------------------
# | display items
# | 
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clock
# | 
add_interface clock clock end
set_interface_property clock clockRate 0

set_interface_property clock ENABLED true

add_interface_port clock clk clk Input 1
# | 
# +-----------------------------------


# +-----------------------------------
# | connection point reset
# | 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT

set_interface_property reset ENABLED true

add_interface_port reset reset reset Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point s0
# | 
add_interface s0 avalon end
set_interface_property s0 addressAlignment DYNAMIC
set_interface_property s0 addressUnits WORDS
set_interface_property s0 associatedClock clock
set_interface_property s0 associatedReset reset
set_interface_property s0 burstOnBurstBoundariesOnly false
set_interface_property s0 explicitAddressSpan 0
set_interface_property s0 holdTime 0
set_interface_property s0 isMemoryDevice false
set_interface_property s0 isNonVolatileStorage false
set_interface_property s0 linewrapBursts false
set_interface_property s0 maximumPendingReadTransactions 0
set_interface_property s0 printableDevice false
set_interface_property s0 readLatency 0
set_interface_property s0 readWaitTime 1
set_interface_property s0 setupTime 0
set_interface_property s0 timingUnits Cycles
set_interface_property s0 writeWaitTime 0

set_interface_property s0 ENABLED true

add_interface_port s0 avs_s0_writedata writedata Input 16
add_interface_port s0 avs_s0_readdata readdata Output 16
add_interface_port s0 avs_s0_address address Input 7
add_interface_port s0 avs_s0_read read Input 1
add_interface_port s0 avs_s0_write write Input 1
# | 
# +-----------------------------------

