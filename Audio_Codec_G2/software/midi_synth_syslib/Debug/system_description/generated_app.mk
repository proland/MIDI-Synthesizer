# generated_app.mk
#
# Machine generated for a CPU named "cpu_0" as defined in:
# /afs/ualberta.ca/home/e/l/elunty/CMPE490/MidiSynth/software/midi_synth_syslib/../../SOPC_File.ptf
#
# Generated: 2012-03-19 16:47:05.911

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



all: delete_placeholder_warning hex sim

delete_placeholder_warning: do_delete_placeholder_warning
.PHONY: delete_placeholder_warning

hex: $(QUARTUS_PROJECT_DIR)/onchip_memory2_0.hex
.PHONY: hex

sim: $(SIMDIR)/dummy_file
.PHONY: sim

verifysysid: dummy_verifysysid_file
.PHONY: verifysysid

do_delete_placeholder_warning:
	rm -f $(SIMDIR)/contents_file_warning.txt
.PHONY: do_delete_placeholder_warning

$(QUARTUS_PROJECT_DIR)/onchip_memory2_0.hex: $(ELF)
	@echo Post-processing to create $(notdir $@)
	elf2hex $(ELF) 0x01002000 0x1003FFF --width=32 $(QUARTUS_PROJECT_DIR)/onchip_memory2_0.hex --create-lanes=0

$(SIMDIR)/dummy_file: $(ELF)
	if [ ! -d $(SIMDIR) ]; then mkdir $(SIMDIR) ; fi
	@echo Hardware simulation is not enabled for the target SOPC Builder system. Skipping creation of hardware simulation model contents and simulation symbol files. \(Note: This does not affect the instruction set simulator.\)
	touch $(SIMDIR)/dummy_file

dummy_verifysysid_file:
	nios2-download $(JTAG_CABLE)                                --sidp=0x010052a0 --id=0 --timestamp=1332197004
.PHONY: dummy_verifysysid_file


generated_app_clean:
	$(RM) $(QUARTUS_PROJECT_DIR)/onchip_memory2_0.hex
	$(RM) $(SIMDIR)/dummy_file
.PHONY: generated_app_clean
