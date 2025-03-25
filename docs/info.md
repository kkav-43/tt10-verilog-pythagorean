# Pythagorean Theorem Calculator (Tiny Tapeout)

## Overview
This project implements a **Pythagorean Theorem Calculator** in hardware using Verilog, designed for **Tiny Tapeout** constraints. Given two 8-bit inputs, `x` and `y`, the circuit computes the hypotenuse using the formula:

\[ c = \sqrt{x^2 + y^2} \]

### **Key Features:**
- **8-bit inputs (`x`, `y`)** and **8-bit output (`c`)**.
- **No multiplications (`*`)** – uses a shift-and-add method for squaring.
- **Bitwise approximation for square root computation.**
- **Optimized for Tiny Tapeout constraints.**

## **Block Diagram**

```plaintext
    x (8-bit)        y (8-bit)
        |               |
    +---+---+       +---+---+
    | Square |       | Square |
    +---+---+       +---+---+
        |               |
        +------Sum------+
                |
           +----+----+
           |  Sqrt   |
           +----+----+
                |
              c (8-bit)
```

## **Inputs & Outputs**
| Signal  | Direction | Description |
|---------|-----------|-------------|
| `ui_in[7:0]`  | Input  | 8-bit integer `x` |
| `uio_in[7:0]` | Input  | 8-bit integer `y` |
| `clk` | Input | Clock signal |
| `rst_n` | Input | Active-low reset |
| `ena` | Input | Enable signal |
| `uo_out[7:0]` | Output | 8-bit computed `c` |

## **Implementation Details**
### **1. Squaring using Shift-and-Add**
Instead of using multiplication, the circuit squares numbers using an iterative **shift-and-add** approach, which is Tiny Tapeout-friendly.

### **2. Sum of Squares**
After squaring `x` and `y`, the sum is stored in a 17-bit register to prevent overflow.

### **3. Square Root Approximation**
A **bitwise iterative method** is used to approximate the square root efficiently in hardware.

## **Precision Handling**
Since the output is **only 8 bits**, the circuit rounds down the square root, introducing minor precision loss for larger values.

## **How to Test**
### **1. Run the Testbench**
#### **Prerequisites**
Install **Icarus Verilog** (`iverilog`) and **GTKWave`:
```sh
sudo apt install iverilog gtkwave
```

#### **Compile and Simulate**
```sh
iverilog -g2012 -Wall src/tt_um_pythagoras.sv test/testbench.sv -o sim.out
vvp sim.out
```

#### **Test Cases**
| Test Case | Input `x` | Input `y` | Expected Output `c` |
|-----------|----------|----------|----------------|
| 1         | 3        | 4        | 5              |
| 2         | 6        | 8        | 10             |
| 3         | 5        | 12       | 13             |
| 4         | 7        | 24       | 25             |
| 5         | 10       | 10       | 14             |
| 6         | 15       | 20       | 25             |

### **2. View Waveform**
To visualize the simulation waveforms, run:
```sh
gtkwave tb_pythagoras.vcd
```

## **Optional External Hardware**
- **Seven-segment display** for output visualization.
- **PMODs** for interactive input.
- **Serial UART interface** for debugging.

---
This project is a fully synthesized Tiny Tapeout-compatible module that efficiently calculates the hypotenuse using a resource-constrained approach. 

