
# Paths to source and testbench files
SRC_DIR = src
TB_DIR = tb

# List of source files to compile
SRC_FILES = \
    $(SRC_DIR)/sha256_w_mem.v \
    $(SRC_DIR)/sha256_k_constants.v \
    $(SRC_DIR)/sha256_core.v \
    $(SRC_DIR)/sha256d.v


# List of testbench files to compile
TB_FILES = \
    $(TB_DIR)/tb_sha256d.v


# Name of the top-level testbench
TOP_LEVEL = tb_sha256d

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

