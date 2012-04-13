# generated_app.mk
#
# Machine generated for a CPU named "cpu_0" as defined in:
# /afs/ualberta.ca/home/e/l/elunty/CMPE490/MidiSynth/software/MidiController_syslib/../../SOPC_File.ptf
#
# Generated: 2012-04-11 15:13:16.75

# DO NOT MODIFY THIS FILE
#
#   Changing this file will have subtle consequences
#   which will almost certainly lead to a nonfunctioning
#   system. If you do modify this file, be aware that your
#   changes will be overwritten and lost when this file
#   is generated again.
#
# DO NOT MODIFY THIS FILE

# assuming the Quartus project directory is the same as the PTF directory
QUARTUS_PROJECT_DIR = /afs/ualberta.ca/home/e/l/elunty/CMPE490/MidiSynth

# the simulation directory is a subdirectory of the PTF directory
SIMDIR = $(QUARTUS_PROJECT_DIR)/SOPC_File_sim

DBL_QUOTE := "


# macros defined by/for cfi_flash_0
CFI_FLASH_0_FLASHTARGET_ALT_SIM_PREFIX = $(CFI_FLASH_0_FLASHTARGET_TMP1:0=)
CFI_FLASH_0_FLASHTARGET_TMP1 = $(ALT_SIM_OPTIMIZE:1=RUN_ON_HDL_SIMULATOR_ONLY_)
BOOT_COPIER = boot_loader_cfi.srec
CPU_CLASS = altera_nios2
CPU_RESET_ADDRESS = 0x1400000


all: delete_placeholder_warning hex sim flashfiles

delete_placeholder_warning: do_delete_placeholder_warning
.PHONY: delete_placeholder_warning

hex: $(QUARTUS_PROJECT_DIR)/onchip_memory2_0.hex
.PHONY: hex

sim: $(SIMDIR)/dummy_file
.PHONY: sim

verifysysid: dummy_verifysysid_file
.PHONY: verifysysid

flashfiles: $(CFI_FLASH_0_FLASHTARGET_ALT_SIM_PREFIX)cfi_flash_0.flash
.PHONY: flashfiles

do_delete_placeholder_warning:
	rm -f $(SIMDIR)/contents_file_warning.txt
.PHONY: do_delete_placeholder_warning

$(QUARTUS_PROJECT_DIR)/onchip_memory2_0.hex: $(ELF)
	@echo Post-processing to create $(notdir $@)
	elf2hex $(ELF) 0x01802000 0x1803FFF --width=32 $(QUARTUS_PROJECT_DIR)/onchip_memory2_0.hex --create-lanes=0

$(SIMDIR)/dummy_file: $(ELF)
	if [ ! -d $(SIMDIR) ]; then mkdir $(SIMDIR) ; fi
	@echo Hardware simulation is not enabled for the target SOPC Builder system. Skipping creation of hardware simulation model contents and simulation symbol files. \(Note: This does not affect the instruction set simulator.\)
	touch $(SIMDIR)/dummy_file

dummy_verifysysid_file:
	nios2-download $(JTAG_CABLE)                                --sidp=0x018050f0 --id=0 --timestamp=1334177553
.PHONY: dummy_verifysysid_file

$(CFI_FLASH_0_FLASHTARGET_ALT_SIM_PREFIX)cfi_flash_0.flash: $(ELF)
	@echo Post-processing to create $(notdir $@)
	elf2flash --input=$(ELF) --flash= --boot=$(DBL_QUOTE)$(shell $(DBL_QUOTE)$(QUARTUS_ROOTDIR)/sopc_builder/bin/find_sopc_component_dir$(DBL_QUOTE) $(CPU_CLASS) $(QUARTUS_PROJECT_DIR))/$(BOOT_COPIER)$(DBL_QUOTE) --outfile=$(CFI_FLASH_0_FLASHTARGET_ALT_SIM_PREFIX)cfi_flash_0.flash --sim_optimize=$(ALT_SIM_OPTIMIZE) --base=0x1400000 --end=0x17FFFFF --reset=$(CPU_RESET_ADDRESS)


generated_app_clean:
	$(RM) $(QUARTUS_PROJECT_DIR)/onchip_memory2_0.hex
	$(RM) $(SIMDIR)/dummy_file
	$(RM) $(CFI_FLASH_0_FLASHTARGET_ALT_SIM_PREFIX)cfi_flash_0.flash
.PHONY: generated_app_clean
