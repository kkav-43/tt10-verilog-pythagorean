# PYTHAGOREAN CALCULATOR
## Project Overview
This Tiny Tapeout project implements a hardware module that converts rectangular (x, y) coordinates to  magnitude (r) using efficient hardware-friendly algorithms.

## Technical Details
- **Input**: 8-bit x and y coordinates
- **Output**: 8-bit radius (r)
- **Algorithm**: Utilizes iterative square root approximation
- **Clock Frequency**: 100 MHz

## Functionality
The module computes the radius using the formula:
[ r = sqrt{x^2 + y^2} ]

### Input and Output Specifications
- **Inputs**:
  - `ui_in[7:0]`: x-coordinate
  - `uio_in[7:0]`: y-coordinate
- **Outputs**:
  - `uo_out[7:0]`: Computed radius

## Implementation Highlights
- Newton-Raphson square root approximation
- Iterative computation of squared values
- Optimized for Tiny Tapeout's resource constraints

## Test Cases
1. (3, 4) → Expected r = 5
2. (5, 12) → Expected r = 13
3. (0, 10) → Expected r = 10
4. (10, 0) → Expected r = 10
5. (7, 24) → Expected r = 25

## Simulation and Verification
The design includes comprehensive testbenches using:
- Cocotb for Python-based testing
- Verilog testbench for RTL simulation
- Gate-level simulation support

## Resources
- **Repo**: [GitHub Link]
- **Tiny Tapeout**: https://tinytapeout.com
