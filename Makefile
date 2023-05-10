.PHONY: burn clean

all:
	$(info Please specify operation)

burn: clean
	# Synthesize using Yosys
	yosys -p "synth_ice40 -top game -json yosys-opt.json" design.v
	
	# Place and route using nextpnr
	nextpnr-ice40 -r --hx8k --json yosys-opt.json --package cb132 --asc nextpnr-opt.asc --opt-timing --pcf iceFUN.pcf

	# Convert to bitstream using IcePack
	icepack nextpnr-opt.asc design.bin

	sudo iceFUNprog design.bin

sim: clean
	iverilog -o  design_tb.vvp  design_tb.v
	/usr/bin/vvp  design_tb.vvp
	gtkwave dump.vcd

clean:
	rm -rf *.asc *.bin *blif *.json
	rm -rf *.vvp dump.vcd