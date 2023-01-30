.PHONY: burn clean

all: burn

burn: clean
	# Synthesize using Yosys
	yosys -p "synth_ice40 -top design -json yosys-opt.json" design.v
	
	# Place and route using nextpnr
	nextpnr-ice40 -r --hx8k --json yosys-opt.json --package cb132 --asc nextpnr-opt.asc --opt-timing --pcf iceFUN.pcf

	# Convert to bitstream using IcePack
	icepack nextpnr-opt.asc design.bin

	sudo iceFUNprog design.bin

clean:
	rm -rf *.asc *.bin *blif *.json