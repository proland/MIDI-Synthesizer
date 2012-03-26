#!/bin/sh
#
# generated.sh - shell script fragment - not very useful on its own
#
# Machine generated for a CPU named "cpu_0" as defined in:
# /afs/ualberta.ca/home/e/l/elunty/CMPE490/MidiSynth/software/midi_synth_syslib/../../SOPC_File.ptf
#
# Generated: 2012-03-19 16:47:09.972

# DO NOT MODIFY THIS FILE
#
#   Changing this file will have subtle consequences
#   which will almost certainly lead to a nonfunctioning
#   system. If you do modify this file, be aware that your
#   changes will be overwritten and lost when this file
#   is generated again.
#
# DO NOT MODIFY THIS FILE

# This variable indicates where the PTF file for this design is located
ptf=/afs/ualberta.ca/home/e/l/elunty/CMPE490/MidiSynth/software/midi_synth_syslib/../../SOPC_File.ptf

# This variable indicates whether there is a CPU debug core
nios2_debug_core=yes

# This variable indicates how to connect to the CPU debug core
nios2_instance=0

# This variable indicates the CPU module name
nios2_cpu_name=cpu_0

# These variables indicate what the System ID peripheral should hold
sidp=0x010052a0
id=0u
timestamp=1332197004u

# Include operating system specific parameters, if they are supplied.

if test -f /opt/altera/10.1sp1/nios2eds/components/micrium_uc_osii/build/os.sh ; then
   . /opt/altera/10.1sp1/nios2eds/components/micrium_uc_osii/build/os.sh
fi
