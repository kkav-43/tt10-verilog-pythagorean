# Makefile
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

# Defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../src)
PROJECT_SOURCES = project.v

ifneq ($(wildcard $(SRC_DIR)/$(PROJECT_SOURCES)),)
VERILOG_SOURCES += $(SRC_DIR)/$(PROJECT_SOURCES)
else
$(error "Error: Source file $(SRC_DIR)/$(PROJECT_SOURCES) not found!")
endif

ifneq ($(GATES),yes)

# RTL simulation:
SIM_BUILD = sim_build/rtl

else

# Gate level simulation:
SIM_BUILD = sim_build/gl
COMPILE_ARGS    += -DGL_TEST -DFUNCTIONAL -DUSE_POWER_PINS -DSIM -DUNIT_DELAY=\#1
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v
VERILOG_SOURCES += $(PWD)/gate_level_netlist.v

endif

# Allow sharing configuration between design and testbench via include:
COMPILE_ARGS += -I$(SRC_DIR)

# Include the testbench sources:
VERILOG_SOURCES += $(PWD)/tb.v
TOPLEVEL = tt_um_rect_cyl

# MODULE is the basename of the Python test file
MODULE = test

# Generate the VCD dump file for waveform analysis
VCD_DUMP = test/tb.vcd

# GTKWave configuration
GTKW_FILE = test/tb.gtkw

# Include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

# Ensure required source files exist
.PHONY: check_sources
check_sources:
	@if [ ! -f $(SRC_DIR)/$(PROJECT_SOURCES) ]; then \
		echo "Error: Source file $(SRC_DIR)/$(PROJECT_SOURCES) not found!"; \
		exit 1; \
	fi

# Run simulation after checking sources
sim: check_sources

# Open waveform viewer
.PHONY: view_waveform
view_waveform: $(GTKW_FILE)
	gtkwave $(VCD_DUMP) $(GTKW_FILE)

# Clean up generated files
.PHONY: clean
clean:
	rm -rf sim_build/ test/__pycache__ *.vcd *.log
