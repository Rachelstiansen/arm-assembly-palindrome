# ARM Assembly Palindrome Finder

A palindrome detector written in ARM Assembly as part of the course
TDT4258 – Low-Level Programming at NTNU.

The program analyzes an input string and determines whether it is a
palindrome. It was developed for the ARMv7 architecture and can be run
using the CPUlator ARMv7 DE1-SoC simulator.

## Features

The palindrome checker:

- Compares characters from both ends of the input string
- Ignores spaces
- Performs case-insensitive comparisons
- Supports `?` and `%` as wildcard characters
- Requires an input of at least four characters
- Outputs the result using memory-mapped I/O

When a palindrome is detected, the five rightmost LEDs are activated.
Otherwise, the five leftmost LEDs are activated.

The result is also written to the JTAG UART.

## Running the program

The program can be simulated using
[CPUlator ARMv7 DE1-SoC](https://cpulator.01xz.net/?sys=arm-de1soc).

1. Open the CPUlator ARMv7 DE1-SoC simulator.
2. Copy the contents of `palinfinder.s` into the editor.
3. Modify the input string near the bottom of the file:

```asm
input: .asciz "Grav ned den varg"
```

4. Click **Compile and Load (F5)**.
5. Run the program using **Continue**.
6. Inspect the simulated LEDs and JTAG UART output for the result.

## Example

```text
Input:
Grav ned den varg

Output:
Palindrome detected
```

## Implementation

The program uses two indices that move from opposite ends of the string
towards the center. Spaces are skipped before characters are compared.

Uppercase ASCII characters are converted to lowercase before comparison,
allowing the palindrome check to be case-insensitive.

The program communicates directly with the simulated DE1-SoC peripherals
using memory-mapped I/O:

- Red LEDs: `0xFF200000`
- JTAG UART: `0xFF201000`

## Technologies

- ARM Assembly
- ARMv7
- Memory-mapped I/O
- JTAG UART
- CPUlator / DE1-SoC

## Background

This program was developed as part of a lab exercise in TDT4258 at NTNU.

The exercise provided practical experience with ARM Assembly, registers,
branching, memory access, ASCII manipulation and memory-mapped I/O.