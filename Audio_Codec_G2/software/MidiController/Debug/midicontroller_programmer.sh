#!/bin/sh
#
# This file was automatically generated by the Nios II IDE Flash Programmer.
#
# It will be overwritten when the flash programmer options change.
#

cd /afs/ualberta.ca/home/e/l/elunty/CMPE490/MidiSynth/software/MidiController/Debug

# Creating .flash file for the project
"$SOPC_KIT_NIOS2/bin/elf2flash" --base=0x01400000 --end=0x17fffff --reset=0x1400000 --input="MidiController.elf" --output="cfi_flash_0.flash" --boot="/opt/altera/10.1sp1/ip/altera/nios2_ip/altera_nios2/boot_loader_cfi.srec"

# Programming flash with the project
"$SOPC_KIT_NIOS2/bin/nios2-flash-programmer" --base=0x01400000 --sidp=0x018050f0 --id=0 --timestamp=1334177553  "cfi_flash_0.flash"

