.PHONY: burn clean

all:
	$(info Please specify operation)

# Generate the FPGA bitstream
bitstream: clean
	# Synthesize using Yosys
	yosys -p "synth_ice40 -top game -json bitstream/yosys-opt.json" design.v debounce.v counter.v lfsr.v display.v
	
	# Place and route using nextpnr
	nextpnr-ice40 -r --hx8k --json bitstream/yosys-opt.json --package cb132 --asc bitstream/nextpnr-opt.asc --opt-timing --pcf bitstream/constraint.pcf

	# Convert to bitstream using IcePack
	icepack bitstream/nextpnr-opt.asc bitstream/design.bin

# Burn the design onto the FPGA
burn: bitstream
	sudo ./bitstream/iceFUNprog bitstream/design.bin

# Simulate the design using Icarus Verilog
sim: clean
	iverilog -D SIM -o simulation/design_tb.vvp  -f simulation/flist.txt
	/usr/bin/vvp  simulation/design_tb.vvp

# Load the waveform viewer to see simulation results
wave: sim
	gtkwave simulation/dump.vcd --save simulation/wave.gtkw

# Clean up generated files
clean:
	rm -rf simulation/*.vvp simulation/*.vcd
	rm -rf bitstream/*.asc bitstream/*.bin bitstream/*blif bitstream/*.json