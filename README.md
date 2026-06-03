# FPGA AI Accelerator using Verilog HDL

## Overview

This project presents the design and implementation of a complete FPGA-based AI Accelerator using Verilog HDL. The accelerator is built around a systolic-array architecture, a highly parallel computing structure commonly used in modern Machine Learning and Deep Learning hardware accelerators.

The project was developed using a modular design methodology where individual hardware blocks were first designed, simulated, and verified independently before being integrated into a complete AI Accelerator system.

All modules were verified using Icarus Verilog and GTKWave, and the final design was successfully synthesized, placed, routed, and programmed onto an FPGA using the open-source IceStorm toolchain.

---

# 1. Introduction

## 1.1 What is an AI Accelerator?

Artificial Intelligence workloads are dominated by matrix multiplication and Multiply-Accumulate (MAC) operations. Traditional CPUs execute these operations sequentially, while AI accelerators perform them in parallel using dedicated hardware architectures.

Modern AI accelerators are used in:
- Google TPUs
- NVIDIA Tensor Cores
- Edge AI Devices
- Neural Processing Units (NPUs)
- FPGA-based Inference Engines

This project demonstrates the fundamental building blocks used in such accelerators.

## 1.2 Project Objectives

- Design an FPGA-based AI Accelerator
- Implement MAC-based computation
- Develop reusable Processing Elements (PEs)
- Build 1D and 2D Systolic Arrays
- Implement Matrix Multiplication Hardware
- Design Control Logic using FSMs
- Verify all modules through simulation
- Deploy the design onto FPGA hardware

---

# 2. Hardware Architecture

Input Buffer → Weight Buffer → Controller FSM → Systolic Array → Accumulator → Output Matrix

The accelerator uses a systolic-array architecture where data flows through Processing Elements performing parallel MAC operations.

---

# 3. Arithmetic Building Blocks

## 3.1 Full Adder

The Full Adder performs binary addition of two bits and a carry input. It forms the basis for larger arithmetic circuits used throughout digital hardware systems.

### Features
- Binary Addition
- Carry Propagation
- Arithmetic Building Block

### Verification

![Full Adder](output/Full_Adder.png)

---

## 3.2 Multiplier

The Multiplier performs arithmetic multiplication between two operands. Multiplication is one of the most frequently used operations in AI workloads.

### Features
- Combinational Arithmetic
- Hardware Multiplication
- MAC Integration

### Verification

![Multiplier](output/Multiplier.png)

---

## 3.3 Accumulator

The Accumulator stores intermediate results and continuously updates accumulated values during computation.

### Features
- Sequential Accumulation
- Intermediate Result Storage
- Partial Sum Generation

### Verification

![Accumulator](output/Accumulator.png)

---

## 3.4 MAC Unit

The Multiply-Accumulate Unit combines multiplication and addition into a single hardware block.

MAC = Previous Sum + (A × B)

### Importance

MAC units form the computational core of neural network accelerators.

### Verification

![MAC Unit](output/Mac_Unit.png)

---

# 4. Processing and Control Modules

## 4.1 Processing Element (PE)

The Processing Element is the fundamental computational block of the accelerator.

### Features
- Local MAC Computation
- Partial Sum Generation
- Data Forwarding
- Parallel Processing

### Verification

![Processing Element](output/processing_element.png)

---

## 4.2 Input Buffer

Stores incoming activation values before computation.

### Features
- Input Storage
- Controlled Data Flow
- Timing Synchronization

### Verification

![Input Buffer](output/input_buffer.png)

---

## 4.3 Weight Buffer

Stores weights used during matrix multiplication.

### Features
- Weight Storage
- Data Reuse
- Efficient Computation

### Verification

![Weight Buffer](output/weight_buffer.png)

---

## 4.4 Controller FSM

Coordinates accelerator operation through multiple states.

### States

IDLE → LOAD → COMPUTE → DONE

### Responsibilities
- Data Loading
- Computation Scheduling
- Control Signal Generation
- Completion Detection

### Verification

![Controller FSM](output/controller_fsm.png)

---

# 5. Systolic Array Architecture

## 5.1 1D Systolic Array

A linear arrangement of Processing Elements that demonstrates pipelined data propagation and parallel computation.

### Verification

![1D Systolic Array](output/systolic_array_1d.png)

---

## 5.2 2D Systolic Array

A two-dimensional arrangement of Processing Elements capable of performing matrix operations efficiently.

### Features
- Parallel Processing
- High Throughput
- Scalable Architecture

### Verification

![2D Systolic Array](output/systolic_array_2d.png)

---

## 5.3 PE Array (2×2)

The PE Array combines multiple Processing Elements into a larger computational structure.

### Verification

![PE Array](output/PE_Array_2_2.png)

---

# 6. Matrix Multiplication Engine

Matrix multiplication is the primary workload targeted by the accelerator.

### Example

Matrix A

|1 2|
|3 4|

Matrix B

|5 6|
|7 8|

Output

|19 22|
|43 50|

### Verification

![Matrix Multiplication](output/Matrix_Mult_2_2.png)

---

# 7. AI Accelerator Integration

## 7.1 AI Accelerator Top

Integrates buffers, controller logic, and compute arrays into a complete subsystem.

### Verification

![AI Accelerator Top](output/ai_accelerator_top.png)

---

## 7.2 Final AI Accelerator

Represents the complete integrated accelerator with control, storage, and computation modules.

### Verification

![AI Accelerator Final](output/ai_accelerator_final.png)

---

# 8. Simulation and Verification Flow

## Simulation Tools

- Icarus Verilog
- GTKWave

### Compilation

```bash
iverilog -o sim rtl/*.v tb/*.v
```

### Simulation

```bash
vvp sim
```

### Waveform Analysis

```bash
gtkwave waveform.vcd
```

All modules were individually verified before full-system integration.

---

# 9. FPGA Implementation Flow

## RTL Design

Design entry using Verilog HDL.

## Synthesis

Tool Used: Yosys

## Place and Route

Tool Used: NextPNR

## Bitstream Generation

Tool Used: IcePack

## FPGA Programming

Tool Used: IceProg

---

# 10. FPGA Programming Results

The generated bitstream was successfully programmed onto the FPGA.

### Programming Result

![FPGA Programming](output/output.png)

### Verification Result

![FPGA Verification](output/output_2.png)

The successful verification confirms that the generated bitstream was correctly downloaded and validated on the FPGA hardware.

---

# 11. Challenges Faced

During development several practical FPGA design challenges were encountered:

- RTL integration issues
- Module interface mismatches
- Constraint file debugging
- FPGA synthesis errors
- Place-and-route issues
- Hardware programming verification
- Signal validation using waveforms

Resolving these challenges provided valuable experience with real FPGA development workflows.

---

# 12. Key Learning Outcomes

- Verilog RTL Design
- Digital System Design
- FSM Design
- MAC Architectures
- Systolic Arrays
- Matrix Multiplication Hardware
- FPGA Tool Flow
- Waveform Debugging
- Hardware Verification
- FPGA Deployment

---

# 13. Future Improvements

- 4×4 Systolic Array
- 8×8 Systolic Array
- CNN Acceleration
- UART Output Interface
- External Memory Support
- Quantized Neural Networks
- Transformer Acceleration
- ASIC Design Flow

---

# 14. Applications

- AI Inference Engines
- Neural Network Accelerators
- Edge AI Systems
- Embedded Machine Learning
- FPGA Research Platforms
- Digital Design Education

---

# 15. Conclusion

This project successfully demonstrates the complete development cycle of an FPGA-based AI Accelerator. Starting from individual arithmetic modules, the design evolved into a complete systolic-array-based accelerator capable of matrix computation.

The project involved RTL design, simulation, verification, synthesis, place-and-route, FPGA programming, and hardware validation. It provides a strong foundation for future work in FPGA design, VLSI systems, AI hardware acceleration, and semiconductor engineering.

---

# Author

**Avanni Thakur**

Electronics and Communication Engineering

Areas of Interest:
- FPGA Design
- VLSI Design
- Digital System Design
- AI Hardware Accelerators
- Semiconductor Engineering
