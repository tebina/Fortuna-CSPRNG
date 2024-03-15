
# Paths to source and testbench files
SRC_DIR = src
TB_DIR = tb

# List of source files to compile
SRC_FILES = $(SRC_DIR)/aes_sbox.v \
    				$(SRC_DIR)/aes_ks.v \
    				$(SRC_DIR)/aes_core.v 

# List of testbench files to compile
TB_FILES = $(TB_DIR)/aes_core_tb.v

# Name of the top-level testbench
TOP_LEVEL = aes_core_tb

VLIB = vlib
VCOM = vcom
VLOG = vlog
VSIM = vsim

# Default target (runs compilation and simulation)
all: compile run

# Compile source and testbench files
compile:
		$(VLIB) work
		$(VLOG) $(SRC_FILES) $(TB_FILES)

# Run ModelSim simulation
run:
		$(VSIM) -c -do "run -all; quit -f" work.$(TOP_LEVEL)

# Clean generated files
clean:
		rm -rf work transcript vsim.wlf

