# Paths to source and testbench files
SRC_DIR = .
TB_DIR = .

# List of source files to compile
SRC_FILES = $(SRC_DIR)/counter.vhd

# List of testbench files to compile
TB_FILES = $(TB_DIR)/tb_counter.vhd

# Name of the top-level testbench
TOP_LEVEL = tb_counter

VLIB = vlib
VCOM = vcom
VLOG = vlog
VSIM = vsim

# Default target (runs compilation and simulation)
all: compile run

# Compile source and testbench files
compile:
		$(VLIB) work
		$(VCOM) $(SRC_FILES) $(TB_FILES)

# Run ModelSim simulation
run:
		$(VSIM) -c -do "run -all; quit -f" work.$(TOP_LEVEL)

# Clean generated files
clean:
		rm -rf work transcript vsim.wlf

