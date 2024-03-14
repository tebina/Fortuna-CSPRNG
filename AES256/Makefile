MODELSIM = /tools/intelFPGA_pro/20.1/modelsim_ase/bin

# Paths to source and testbench files
SRC_DIR = src
TB_DIR = tb

# List of source files to compile
SRC_FILES = $(SRC_DIR)/table.v \
    				$(SRC_DIR)/round.v \
    				$(SRC_DIR)/aes_256.v 

# List of testbench files to compile
TB_FILES = $(TB_DIR)/test_aes_256.v

# Name of the top-level testbench
TOP_LEVEL = test_aes_256

# Default target (runs compilation and simulation)
all: compile run

# Compile source and testbench files
compile:
		$(MODELSIM)/vlib work
		$(MODELSIM)/vlog $(SRC_FILES) $(TB_FILES)

# Run ModelSim simulation
run:
		$(MODELSIM)/vsim -c -do "run -all; quit -f" work.$(TOP_LEVEL)

# Clean generated files
clean:
		rm -rf work transcript vsim.wlf

