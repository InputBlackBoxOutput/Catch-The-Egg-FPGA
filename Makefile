.PHONY: burn clean

all:
	$(info Please specify operation)

# Generate the FPGA bitstream
bitstream:
	# Synthesize using Yosys
	yosys -p "synth_ice40 -top game -json yosys-opt.json" design.v
	
	# Place and route using nextpnr
	nextpnr-ice40 -r --hx8k --json yosys-opt.json --package cb132 --asc nextpnr-opt.asc --opt-timing --pcf constraint.pcf

	# Convert to bitstream using IcePack
	icepack nextpnr-opt.asc design.bin

# Burn the design onto the FPGA
burn: clean bitstream
	sudo ./iceFUNprog design.bin

# Simulate the design using Icarus Verilog
sim: clean
	iverilog -o  design_tb.vvp  design_tb.v
	/usr/bin/vvp  design_tb.vvp

# Load the waveform viewer to see simulation results
wave: sim
	gtkwave dump.vcd

# Clean up generated files
clean:
	rm -rf *.asc *.bin *blif *.json
	rm -rf *.vvp dump.vcd