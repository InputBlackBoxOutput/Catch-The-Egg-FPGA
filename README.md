# Catch the Egg FPGA

Catch the Egg is a simple game with the objective to catch all the falling eggs in a basket. If you miss an egg, you lose the game. This repository contains an implmentation of the game on an FPGA

<div align="center">
  <img height="300" src="https://github.com/user-attachments/assets/a207e3f4-a579-4ac4-afdd-11260fb188c9" />
</div>


## Implementation details
- The 4x8 LED matrix shows the basket using 2 consecutive LEDs on the bottom row and an egg using 1 LED in the first 3 rows.
- The top-left button moves the basket to the left and the top-right button moves the basket to the right
- The bottom-left button resets the game

<div align="center">
  <img height="300" alt="image" src="https://github.com/user-attachments/assets/d838275e-f73a-4687-9f30-ab15c0bc2e6b" />
</div>

## Simulation
```
# Run simulation using Icarus Verilog
make sim

# Run simulation and view the waveform using GTKWave
make wave
```

## Bitstream generation
```
# Generate the FPGA bitstream
make bitstream

# Genrate bitstream and burn it onto the FPGA
chmod +x iceFUNprog
make burn
```

## Future development
- Seed LFSR using random ADC value collected using USART
- Sound effects using the buzzer
- Game over screen using the LED matrix
