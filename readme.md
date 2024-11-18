All programs were tested on Arch Linux x86-64
Kernel: 6.11.6-arch1-1
CPU: Intel i5-8350U (8) @ 3.600GHz 

C programs:
gcc version 14.2.1

MIPS programs:
Mars version 4.5 from https://computerscience.missouristate.edu/mars-mips-simulator.html

Risc-V programs:
Ripes version 2.2.6 from https://ripes.me/Ripes/# Project Setup and Testing Environment

This project consists of C, MIPS, and RISC-V programs tested on a specific environment. Below is the detailed setup for each type of program and the tools used for testing.

## System Information

- **Operating System**: Arch Linux x86-64
- **Kernel Version**: 6.11.6-arch1-1
- **CPU**: Intel Core i5-8350U (8 cores) @ 3.6 GHz

## Tools and Versions

### C Programs

- **Compiler**: GCC version 14.2.1
- **Compilation and Testing**: C programs are compiled using the GCC toolchain.
- **Makefile**: A `Makefile` is provided for building the C programs.

### MIPS Programs

- **Simulator**: MARS version 4.5
- **Source**: [MARS MIPS Simulator](https://computerscience.missouristate.edu/mars-mips-simulator.htm)
- MIPS programs are tested using the MARS simulator for execution and debugging.

### RISC-V Programs

- **Simulator**: Ripes version 2.2.6
- **Source**: [Ripes - RISC-V Simulator](https://ripes.me/Ripes/)
- RISC-V programs are tested using Ripes, a graphical simulator that supports various RISC-V tools.

## Usage and Testing

### C Programs

The C programs are managed with a `Makefile`. You can build and run the C programs as follows:

1. **Build the Program**:
   Navigate to the directory containing the `Makefile`, and run:
   ```bash
   make

### MIPS Programs

1. Download Mars v4.5 from the link provided above
2. Open the .s assembly program in Mars
3. Click **build** and then **run** using the simulator


### Risc-V programs

1. Download Ripes v2.2.6 from the link provided above
2. Open the .s assembly program in Ripes as a source file 
3. Click **run** to run the program
