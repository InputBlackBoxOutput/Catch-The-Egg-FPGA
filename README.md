# Catch the Egg FPGA

'Catch the Egg' is a simple yet fun game. The objective of the game is to catch all the eggs which are falling from the sky in our basket. If you are unable to catch an egg, you lose the game. This is an implementation of the Catch-The-Egg game on an FPGA.

![image](https://user-images.githubusercontent.com/53337979/215928646-b8963c02-3a7a-4d82-81b4-fc32eac45305.png)

## Implementation details
- The 4x8 LED matrix shows the basket using 2 consecutive LEDs on the bottom row and an egg using 1 LED in the first 3 rows.
- The top-left button moves the basket to the left and the top-right button moves the basket to the right
- The bottom-left button resets the game

![image](https://user-images.githubusercontent.com/53337979/215928973-cb32a23e-d5d2-4eee-bb6e-e6c8b51495e3.png)

## Future development
- True random number generation using LFSR with ADC value as seed
- Sound effects using the buzzer

### Made with lots of ⏱️, 📚 and ☕ by InputBlackBoxOutput
