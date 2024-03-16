# Paths to source and testbench files
SRC_DIR = .
TB_DIR = .

# List of source files to compile
V_SRC_FILES = $(SRC_DIR)/AES256/src/aes_ks.v \
						$(SRC_DIR)/AES256/src/aes_sbox.v \
						$(SRC_DIR)/AES256/src/aes_core.v 


VHDL_SRC_FILES = $(SRC_DIR)/counter.vhd \
								 $(SRC_DIR)/fortuna_core.vhd 

# List of testbench files to compile
TB_FILES = $(TB_DIR)/tb_fortuna_core.vhd

# Name of the top-level testbench
TOP_LEVEL = tb_fortuna_core

VLIB = vlib
VCOM = vcom
VLOG = vlog
VSIM = vsim

# Default target (runs compilation and simulation)
all: compile run

# Compile source and testbench files
compile:
		$(VLIB) work
		$(VLOG) $(V_SRC_FILES)
		$(VCOM) $(VHDL_SRC_FILES) $(TB_FILES)

# Run ModelSim simulation
run:
		$(VSIM) -c -do "run -all; quit -f" work.$(TOP_LEVEL)

# Clean generated files
clean:
		rm -rf work transcript vsim.wlf

