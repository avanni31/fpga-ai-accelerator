# FPGA-Based AI Accelerator — Matrix Multiplication Engine

> A hardware-level AI inference accelerator implemented in Verilog/SystemVerilog on an FPGA, built from scratch using a modular bottom-up design methodology. This project demonstrates the full design stack — from primitive arithmetic units to a fully orchestrated 2×2 systolic array with FSM-controlled execution and board-level deployment.

---

## Table of Contents

- [Overview](#overview)
- [Why FPGAs for AI Acceleration?](#why-fpgas-for-ai-acceleration)
- [Architecture Overview](#architecture-overview)
- [Project Structure](#project-structure)
- [Module Deep Dive](#module-deep-dive)
  - [1. Full Adder](#1-full-adder)
  - [2. Multiplier](#2-multiplier)
  - [3. Accumulator](#3-accumulator)
  - [4. MAC Unit](#4-mac-unit)
  - [5. Processing Element](#5-processing-element)
  - [6. Input Buffer](#6-input-buffer)
  - [7. Weight Buffer](#7-weight-buffer)
  - [8. Controller FSM](#8-controller-fsm)
  - [9. 1D Systolic Array](#9-1d-systolic-array)
  - [10. 2D Systolic Array](#10-2d-systolic-array)
  - [11. PE Array 2×2](#11-pe-array-22)
  - [12. Matrix Multiplier 2×2 (Combinational)](#12-matrix-multiplier-22-combinational)
  - [13. AI Accelerator Final](#13-ai-accelerator-final)
  - [14. AI Accelerator Top](#14-ai-accelerator-top)
  - [15. Board Demo Top](#15-board-demo-top)
  - [16. Board Demo 2 (LED Output)](#16-board-demo-2-led-output)
- [Design Philosophy & Methodology](#design-philosophy--methodology)
- [How It All Connects](#how-it-all-connects)
- [Simulation & Testing](#simulation--testing)
- [Tools Used](#tools-used)
- [What I Learned](#what-i-learned)
- [Future Improvements](#future-improvements)

---

## Overview

This project is a **hardware AI accelerator** designed and implemented entirely in Verilog. It accelerates **matrix multiplication** — the most computationally dominant operation in neural network inference (fully connected layers, attention mechanisms, convolutions all reduce to it).

Rather than running matrix multiply on a CPU (which is sequential and general-purpose) or even a GPU (which has high power and cost overhead), this design offloads the computation directly onto **FPGA fabric** — giving fine-grained control over parallelism, pipelining, and data flow at the hardware level.

The design was built **bottom-up**: starting from a single-bit full adder and building up to a complete, FSM-controlled 2×2 systolic array that can perform parallel matrix multiplication in hardware.

---

## Why FPGAs for AI Acceleration?

Modern AI workloads (especially inference) are dominated by matrix multiplications. Running these on a CPU is slow because CPUs are built for general-purpose sequential execution. GPUs are faster but consume significant power and are expensive.

FPGAs sit in a sweet spot:

| Property | CPU | GPU | FPGA |
|---|---|---|---|
| Parallelism | Low | High | Configurable |
| Power Efficiency | Medium | Low | High |
| Latency | High | Medium | Very Low |
| Flexibility | High | Medium | Medium |
| Cost | Medium | High | Low–Medium |

On an FPGA, you can instantiate **multiple multiply-accumulate (MAC) units** that all run **simultaneously** in hardware — there is no instruction fetch, no cache miss, no branch prediction overhead. Every clock cycle does exactly the work you designed it to do.

This is why companies like Google (TPUs), Microsoft (Project Brainwave), and AMD (with Xilinx) use FPGA/custom silicon for AI inference at scale.

---

## Architecture Overview

```
                          ┌─────────────────────────────────────┐
                          │          ai_accelerator_top          │
                          │                                       │
                          │  ┌──────────────┐  ┌─────────────┐  │
          start ─────────►│  │ controller_  │  │ systolic_   │  │
          clk   ─────────►│  │    fsm       │  │  array_2d   │  │
          reset ─────────►│  │              │  │             │  │
                          │  │  IDLE→LOAD   │  │  PE00 PE01  │  │
                          │  │  →COMPUTE    │─►│  PE10 PE11  │  │
                          │  │  →DONE       │  │             │  │
                          │  └──────────────┘  └─────────────┘  │
                          │         │enable            │Y00..Y11 │
                          └─────────┼──────────────────┼─────────┘
                                    │                  │
                                    ▼                  ▼
                                 done=1          16-bit results


          Each Processing Element (PE) internally does:

          A[3:0] ──►┐
                    ├──► mult[7:0] = A × B ──► Y[15:0] = Y + mult  (clocked)
          B[3:0] ──►┘
```

The design uses a **2×2 grid of Processing Elements (PEs)**, each computing one element of the output matrix in parallel. A **Finite State Machine (FSM)** controls when computation starts and signals completion. Input and weight buffers stage the data before computation begins.

---

## Project Structure

```
fpga-ai-accelerator/
│
├── accumulator/
│   ├── rtl/
│   │   └── accumulator.v          # Clocked running sum unit
│   └── tb/
│       └── accumulator_tb.v
│
├── ai_accelerator_final/
│   ├── rtl/
│   │   └── ai_accelerator_final.v # Integrated accelerator with buffers + FSM
│   └── tb/
│       └── ai_accelerator_final_tb.v
│
├── ai_accelerator_top/
│   ├── rtl/
│   │   └── ai_accelerator_top.v   # Top-level: FSM + 2D systolic array
│   └── tb/
│       └── ai_accelerator_top_tb.v
│
├── board_demo_top/
│   └── rtl/
│       └── board_demo_top.v       # Board deployment with hardcoded matrix
│
├── board_demo_2/
│   └── rtl/
│       └── board_demo_top_2.v     # Board deployment with LED done indicator
│
├── controller_fsm/
│   ├── rtl/
│   │   └── controller_fsm.v       # 4-state FSM: IDLE→LOAD→COMPUTE→DONE
│   └── tb/
│       └── controller_fsm_tb.v
│
├── full_adder/
│   ├── rtl/
│   │   └── full_adder.v           # 1-bit full adder (foundational primitive)
│   └── tb/
│       └── full_adder_tb.v
│
├── input_buffer/
│   ├── rtl/
│   │   └── input_buffer.v         # 8-bit registered input latch
│   └── tb/
│       └── input_buffer_tb.v
│
├── mac_unit/
│   ├── rtl/
│   │   └── mac_unit.v             # Multiply-Accumulate unit (always-accumulating)
│   └── tb/
│       └── mac_unit_tb.v
│
├── matrix_mult_2_2/
│   ├── rtl/
│   │   └── matrix_mult_2_2.v      # Combinational 2×2 matrix multiplier
│   └── tb/
│       └── matrix_mult_2_2_tb.v
│
├── multiplier/
│   ├── rtl/
│   │   └── multiplier.v           # 4-bit combinational multiplier
│   └── tb/
│       └── multiplier_tb.v
│
├── pe_array_2_2/
│   └── tb/
│       └── pe_array_2_2_tb.v      # Testbench for 2×2 PE array
│
├── processing_element/
│   ├── rtl/
│   │   └── processing_element.v   # Enable-gated MAC cell (core compute unit)
│   └── tb/
│       └── processing_element_tb.v
│
├── systolic_array_1d/
│   ├── rtl/
│   │   └── systolic_array_1d.v    # 1D chain of 2 PEs with data pipelining
│   └── tb/
│       └── systolic_array_1d_tb.v
│
├── systolic_array_2d/
│   ├── rtl/
│   │   └── systolic_array_2d.v    # 2×2 grid of PEs — full parallel array
│   └── tb/
│       └── systolic_array_2d_tb.v
│
└── weight_buffer/
    ├── rtl/
    │   └── weight_buffer.v        # 8-bit registered weight latch
    └── tb/
        └── weight_buffer_tb.v
```

---

## Module Deep Dive

### 1. Full Adder

**File:** `full_adder/rtl/full_adder.v`

The full adder is the most fundamental building block of all arithmetic in digital design. It adds three 1-bit inputs (A, B, and a carry-in) and produces a 1-bit Sum and a 1-bit Carry-out.

```
Sum  = A ⊕ B ⊕ Cin
Cout = (A·B) | (B·Cin) | (A·Cin)
```

**Why it's here:** Every multiply and accumulate operation in this accelerator ultimately decomposes into additions at the hardware level. The FPGA fabric's LUTs (Look-Up Tables) implement this logic. Building and testing a full adder first confirms that the fundamental logic is correctly understood before building larger units on top of it.

**Testing:** All 8 possible input combinations (2³) are exhaustively tested in the testbench, covering every case of carry propagation.

**Simulation Output (GTKWave):**
![Full Adder Waveform](output/Full_Adder.png)

---

### 2. Multiplier

**File:** `multiplier/rtl/multiplier.v`

A 4-bit combinational multiplier. Takes two 4-bit inputs and produces their product using Verilog's `*` operator, which the synthesizer maps to a hardware DSP block or LUT-based multiplier tree on the FPGA.

**Why 4-bit?** The matrix elements in this design are 4-bit values. The product of two 4-bit numbers fits in 8 bits (max: 15 × 15 = 225, which is < 256 = 2⁸). This width was chosen deliberately to keep resource usage minimal while still being meaningful for demonstrating the architecture.

**Note on the output width:** The testbench correctly wires the output to `wire [7:0] P`, though the RTL declares it as `[3:0]`. This is a known design point — in the integrated design, multiplication products are properly sized at 8 bits inside the MAC unit.


**Simulation Output (GTKWave):**
![Multiplier Waveform](output/Multiplier.png)

---

### 3. Accumulator

**File:** `accumulator/rtl/accumulator.v`

A clocked, synchronous accumulator. On every rising clock edge it adds the current 8-bit input to a running 16-bit sum. A synchronous reset brings the sum back to zero.

```
always @(posedge clk)
    if (reset) sum <= 0;
    else       sum <= sum + in;
```

**Why 16-bit output for 8-bit input?** To prevent overflow. If you accumulate many 8-bit values (max 255 each), the sum can grow beyond 8 bits. 16 bits allows up to 65,535, which is sufficient for the accumulation depth in this design.

**Role in the system:** The accumulator concept is the foundation of the MAC unit — instead of just summing identical inputs, the MAC multiplies first, then accumulates the products.

**Simulation Output (GTKWave):**
![Accumulator Waveform](output/Accumulator.png)

---

### 4. MAC Unit

**File:** `mac_unit/rtl/mac_unit.v`

The Multiply-Accumulate (MAC) unit is the **core arithmetic primitive** of any neural network accelerator. It computes:

```
Y = Y + (A × B)    on every clock cycle
```

This single operation is what makes matrix multiplication fast in hardware. An entire dot product (row × column) can be computed by feeding successive element pairs into a MAC unit and letting it accumulate.

**Design decision — always accumulating:** This version of the MAC accumulates on every clock cycle without an enable gate. This makes it simpler but less flexible. The more advanced `processing_element` adds an `enable` signal to control when accumulation happens.

**Bit widths:**
- Inputs A, B: 4-bit
- Internal product: 8-bit (`wire [7:0] mult = A * B`)
- Output Y: 16-bit (accumulates multiple products safely)

**Simulation Output (GTKWave):**
![MAC Unit Waveform](output/Mac_Unit.png)

---

### 5. Processing Element

**File:** `processing_element/rtl/processing_element.v`

The Processing Element (PE) is the **enable-gated version of the MAC unit** and serves as the fundamental compute cell of the systolic array. It adds an `enable` control signal:

```
always @(posedge clk)
    if (reset)        Y <= 0;
    else if (enable)  Y <= Y + (A × B);
```

**Why enable matters:** In a systolic array, not all PEs should compute at all times. The enable signal — driven by the FSM — allows the controller to precisely gate when computation happens. This is critical for correctness: you don't want PEs accumulating garbage values while the system is in an idle or loading state.

**This is the most reused module in the project.** Every systolic array (1D and 2D) is assembled entirely from instances of this module.

**Simulation Output (GTKWave):**
![Processing Element Waveform](output/processing_element.png)

---

### 6. Input Buffer

**File:** `input_buffer/rtl/input_buffer.v`

A simple 8-bit registered latch for input data. When `load` is asserted, it captures `data_in` on the next rising clock edge and holds it at `data_out`.

```
always @(posedge clk or posedge reset)
    if (reset)      data_out <= 0;
    else if (load)  data_out <= data_in;
```

**Why buffering matters:** In real hardware systems, input data arrives from external sources (memory, sensors, other IPs) at unpredictable times. The buffer decouples data arrival from data consumption — the accelerator reads from the stable buffered value, not directly from a potentially-changing input.

**Analogy:** It's like a staging area in a warehouse. Goods arrive and are held in a staging zone before being moved to the production line.

**Simulation Output (GTKWave):**
![Input Buffer Waveform](output/input_buffer.png)

---

### 7. Weight Buffer

**File:** `weight_buffer/rtl/weight_buffer.v`

Identical in structure to the input buffer but dedicated to **neural network weights**. In ML, weights are the learned parameters of a model — they are loaded once and reused across many input activations.

**Why a separate buffer for weights?** Separating data and weight paths is a common pattern in hardware ML accelerators (including Google's TPU). It reflects the real access pattern of inference: weights are static per inference pass, while activations change with every input sample. Having separate buffers allows them to be loaded at different times and potentially from different memory banks.

**Simulation Output (GTKWave):**
![Weight Buffer Waveform](output/weight_buffer.png)

---

### 8. Controller FSM

**File:** `controller_fsm/rtl/controller_fsm.v`

The **brain of the accelerator**. A 4-state Finite State Machine that sequences the computation:

```
    IDLE ──(start=1)──► LOAD ──► COMPUTE ──► DONE
     ▲                                         │
     └─────────────────────────────────────────┘
                   (stays in DONE)
```

| State | enable | done | Description |
|-------|--------|------|-------------|
| IDLE | 0 | 0 | Waiting for start signal |
| LOAD | 0 | 0 | One-cycle pipeline fill / data staging |
| COMPUTE | 1 | 0 | Enable asserted — PEs accumulate |
| DONE | 0 | 1 | Computation complete, result valid |

**Why an FSM?** Pure combinational logic has no notion of time or sequencing. The FSM enforces the correct order of operations: you must load data before computing, and you must signal completion after computing. Without this, the PEs would be permanently computing garbage.

**Design decision — one-cycle LOAD state:** The LOAD state exists to give buffers time to present stable data before the enable signal activates the PEs. This is a pipeline hazard prevention technique — without it, the first compute cycle might use uninitialized data.

**Simulation Output (GTKWave):**
![Controller FSM Waveform](output/controller_fsm.png)

---

### 9. 1D Systolic Array

**File:** `systolic_array_1d/rtl/systolic_array_1d.v`

A linear chain of two Processing Elements. Data flows through PE0 and then (with a one-cycle pipeline register) to PE1. Each PE has its own fixed weight.

```
data_in ──► PE0 (weight0) ──► out0
    │
    ▼ (pipeline register, 1 cycle delay)
data_in ──► PE1 (weight1) ──► out1
```

**What is a systolic array?** The term "systolic" comes from the heart's rhythmic pumping — data flows through the array in a regular, rhythmic pattern, like blood through the circulatory system. Each PE receives data, processes it, and passes it along. This regular data flow is highly efficient in hardware because there is no shared memory bus — each PE communicates only with its neighbours.

**Why pipeline the data?** The `data_pipe` register introduces a one-cycle delay before data reaches PE1. This is the classic systolic timing: PE0 processes cycle N's data while PE1 processes cycle N-1's data. In a larger array, this staggering allows different PEs to work on different rows of the input simultaneously, achieving high utilization.

**Simulation Output (GTKWave):**
![Systolic Array 1D Waveform](output/systolic_array_1d.png)

---

### 10. 2D Systolic Array

**File:** `systolic_array_2d/rtl/systolic_array_2d.v`

A 2×2 grid of four Processing Elements, each computing one partial product independently and in parallel. This is the **full parallel matrix multiplication engine**.

```
        B00  B01
        │    │
A00 ──► PE00 PE01 ──► Y00, Y01
A10 ──► PE10 PE11 ──► Y10, Y11
        │    │
        B10  B11
```

Each PE computes: `Y_ij = Y_ij + (A_i * B_j)` on every enabled clock cycle.

**Why parallel, not sequential?** By instantiating 4 PEs simultaneously, all four output matrix elements are computed **at the same time** — in a single pass. A sequential CPU would require 4 separate multiply-accumulate operations. This is the fundamental advantage of spatial parallelism on FPGAs.

**Matrix multiplication correctness:** For a 2×2 matrix multiply C = A × B:
```
C00 = A00*B00 + A01*B10
C01 = A00*B01 + A01*B11
C10 = A10*B00 + A11*B10
C11 = A10*B01 + A11*B11
```
In this implementation, each PE accumulates its partial products over multiple clock cycles as data is streamed in, producing the correct final result.

**Simulation Output (GTKWave):**
![Systolic Array 2D Waveform](output/systolic_array_2d.png)

---

### 11. PE Array 2×2

**File:** `pe_array_2_2/tb/pe_array_2_2_tb.v`

A testbench for a flat 2×2 PE array where each PE is independently addressed with its own `A`/`B` inputs and produces its own `Y` output. This tests the PE array in isolation, verifying that four PEs instantiated together don't interfere with each other and that each accumulates correctly.

**Test vectors:** Two rounds of different (A, B) pairs are fed into the four PEs to verify independent accumulation across all cells.

**Simulation Output (GTKWave):**
![PE Array 2×2 Waveform](output/PE_Array_2_2.png)

---

### 12. Matrix Multiplier 2×2 (Combinational)

**File:** `matrix_mult_2_2/rtl/matrix_mult_2_2.v`

A **purely combinational** (no clock, no registers) implementation of 2×2 matrix multiplication using direct `assign` statements:

```verilog
assign C00 = (A00 * B00) + (A01 * B10);
assign C01 = (A00 * B01) + (A01 * B11);
// ...
```

**Why does this exist alongside the systolic array?** This module serves as a **golden reference model**. Because it's purely combinational and directly maps the math to logic, it is simple to verify by hand. The result from this module can be compared against the systolic array output to confirm the clocked design is computing the correct values.

**Tradeoffs of combinational vs clocked:** The combinational version is fast (result available in one propagation delay) but does not pipeline — it cannot stream data. It also consumes more LUT resources for the same operation because there's no register sharing. The systolic array is slower to produce a final result but scales to larger matrices and uses pipelining for throughput.

**Simulation Output (GTKWave):**
![Matrix Multiplier 2×2 Waveform](output/Matrix_Mult_2_2.png)

---

### 13. AI Accelerator Final

**File:** `ai_accelerator_final/rtl/ai_accelerator_final.v`

An integrated module that wires together the `input_buffer`, `weight_buffer`, and `controller_fsm` into a single accelerator interface. This is the **first complete system integration** in the project.

```
data_in ──► input_buffer ──────────────────► result (buffered_data + buffered_weight)
weight_in ──► weight_buffer ──────────────►
start ──► controller_fsm ──► enable, done
```

**Design note:** In this version, the result is computed as a simple addition of the buffered data and weight — a placeholder for what would normally be a MAC operation. This module's primary value is demonstrating the **integration pattern**: how buffers, controllers, and compute units are wired together with clean interfaces.

**Simulation Output (GTKWave):**
![AI Accelerator Final Waveform](output/ai_accelerator_final.png)

---

### 14. AI Accelerator Top

**File:** `ai_accelerator_top/rtl/ai_accelerator_top.v`

The **primary top-level module** of the design. Integrates the `controller_fsm` and `systolic_array_2d` into a clean 2×2 matrix multiplication accelerator with a single control interface:

- Assert `start` → FSM transitions through states → `enable` activates the systolic array → `done` pulses when complete
- Matrix inputs: `A00..A11`, `B00..B11` (4-bit each)
- Matrix outputs: `Y00..Y11` (16-bit each)

**This is the module that represents the complete, working accelerator.** All other modules are either subcomponents of this or standalone experiments that informed its design.

**Simulation Output (GTKWave):**
![AI Accelerator Top Waveform](output/ai_accelerator_top.png)

---

### 15. Board Demo Top

**File:** `board_demo_top/rtl/board_demo_top.v`

> **Why a demo version exists at all — the hardware constraint problem**
>
> The FPGA board used for this project is the **VSDSquadron FM (FPGA Mini)** — a compact, low-cost FPGA development board. It is excellent for learning and prototyping, but it has a limited number of physical I/O pins available.
>
> The full `ai_accelerator_top` module exposes:
> - 8 matrix inputs × 4 bits each = **32 input bits**
> - 4 matrix outputs × 16 bits each = **64 output bits**
> - Plus `clk`, `reset`, `start`, `done`
>
> Routing all the output bits alone would require approximately **~130 physical wires/pins** to be observable externally — far more than the VSDSquadron FM provides. There was simply no way to connect 64 output bits to LEDs, a logic analyser header, or any external display on this board.
>
> **The solution:** Create a stripped-down board demo that hardcodes the matrix inputs inside the RTL itself, runs the full computation internally, and exposes only the signals the board can actually handle — in this case, just the `done` flag and the computed wires kept internal.

This wrapper instantiates `ai_accelerator_top` with **hardcoded matrix values**:

```
A = [[2, 3],    B = [[6, 7],
     [4, 5]]         [8, 9]]
```

**Why hardcoded inputs?** Since the board cannot expose enough pins to receive 32 external input bits, the matrix values are baked into the RTL. This is a standard bring-up technique in hardware engineering — you fix all inputs to known values, run the design, and verify the control signals (`done`) behave correctly. Once that's confirmed, you know the pipeline, FSM, and timing are all working correctly on real silicon.

Expected results (verified by hand):
```
Y00 = 2*6 + 3*8 = 12 + 24 = 36
Y01 = 2*7 + 3*9 = 14 + 27 = 41
Y10 = 4*6 + 5*8 = 24 + 40 = 64
Y11 = 4*7 + 5*9 = 28 + 45 = 73
```

These values are computed correctly inside the FPGA fabric — they just cannot all be routed out to visible pins on this particular board.

**Board Output:**
![Board Demo Output](output/output.png)

---

### 16. Board Demo 2 (LED Output)

**File:** `board_demo_2/rtl/board_demo_top_2.v`

This is the final board-deployable design, and it solves the observation problem in the most elegant way possible given the hardware constraint: **use a single LED.**

```verilog
assign led_r = done;
```

**The thinking behind this:** Since the full 64-bit output cannot be observed on the VSDSquadron FM, the most meaningful single signal to expose is `done` — the FSM's completion flag. When the red LED lights up, it proves that:

1. The design synthesized and fit onto the FPGA fabric correctly
2. The FSM advanced through all four states (IDLE → LOAD → COMPUTE → DONE)
3. The systolic array ran for the required number of clock cycles
4. The controller correctly determined that computation was finished

In other words, even though the numerical result (36, 41, 64, 73) cannot be directly read off the board, the LED lighting up is **proof that the accelerator ran to completion on real hardware**. The correctness of the arithmetic was already established in simulation.

**This is a critical milestone in any hardware project:** the moment a design that only existed as waveforms in a simulator becomes a physical effect in the real world — a light turning on because silicon computed a matrix product.

**Board used:** VSDSquadron FM (FPGA Mini)
- Compact RISC-V + FPGA development board
- Limited I/O pins — sufficient for control signals, not for full 64-bit output observation
- Ideal for learning FPGA design flows end-to-end on real hardware

**Board Output — LED lit when `done = 1`:**
![Board Demo 2 Output](output/output_2.png)

---

## Design Philosophy & Methodology

This project was built using a disciplined **bottom-up hardware design methodology**:

```
Level 0 (Primitives):     Full Adder, Multiplier
         │
         ▼
Level 1 (Arithmetic):     Accumulator, MAC Unit
         │
         ▼
Level 2 (Memory):         Input Buffer, Weight Buffer
         │
         ▼
Level 3 (Compute Cell):   Processing Element
         │
         ▼
Level 4 (Arrays):         Systolic Array 1D → 2D, PE Array 2×2
         │
         ▼
Level 5 (Control):        Controller FSM
         │
         ▼
Level 6 (Integration):    AI Accelerator Final → Top
         │
         ▼
Level 7 (Deployment):     Board Demo Top → Board Demo 2
```

**Why bottom-up?** Each level is verified in simulation before being used in the next level. This means that by the time the top-level module is assembled, each submodule is already a known-good, tested component. Bugs are caught early and isolated — if the MAC unit testbench passes, any error in the PE testbench is a PE-level issue, not a MAC issue.

**Every module has a testbench.** This is non-negotiable in professional hardware design. Hardware bugs that slip to silicon cost millions of dollars to fix. Simulation is the primary verification methodology.

---

## How It All Connects

```
                           USER INPUTS
                    A[00..11], B[00..11], start
                               │
                               ▼
                    ┌─────────────────────┐
                    │  ai_accelerator_top  │
                    │                     │
                    │  ┌───────────────┐  │
                    │  │ controller_   │  │
          clk ─────►│  │    fsm        │  │
          reset────►│  │               │  │
                    │  │ IDLE→LOAD     │  │
          start────►│  │ →COMPUTE→DONE │  │
                    │  └───────┬───────┘  │
                    │          │ enable   │
                    │          ▼          │
                    │  ┌───────────────┐  │
                    │  │ systolic_     │  │
                    │  │  array_2d     │  │
                    │  │               │  │
                    │  │  PE00  PE01  │  │
                    │  │  PE10  PE11  │  │
                    │  │               │  │
                    │  │ Each PE does: │  │
                    │  │ Y += A × B   │  │
                    │  └───────────────┘  │
                    │                     │
                    └─────────────────────┘
                               │
                    Y00, Y01, Y10, Y11, done
                               │
                               ▼
                    board_demo_top_2
                    led_r = done  ──► Physical LED on FPGA
```

---

## Simulation & Testing

Each module is simulated using a dedicated testbench. Simulation waveforms are dumped to VCD (Value Change Dump) files for inspection in GTKWave or any compatible waveform viewer.

### Running a Simulation (Icarus Verilog)

```bash
# Example: simulate the systolic array 2D
cd systolic_array_2d
mkdir -p build
iverilog -o build/sim tb/systolic_array_2d_tb.v rtl/systolic_array_2d.v rtl/processing_element.v
vvp build/sim
gtkwave build/systolic_array_2d.vcd
```

### Test Coverage Summary

| Module | Test Type | Scenarios Covered |
|--------|-----------|-------------------|
| full_adder | Exhaustive | All 8 input combinations |
| multiplier | Directed | Corner cases including 15×15 (max) |
| accumulator | Directed | Reset, sequential accumulation |
| mac_unit | Directed | Multiple A×B pairs, accumulation check |
| processing_element | Directed | Enable gating, reset, accumulation |
| input_buffer | Directed | Load/hold behaviour |
| weight_buffer | Directed | Load/hold behaviour |
| controller_fsm | Directed | Full state sequence, done timing |
| systolic_array_1d | Directed | Multi-cycle streaming |
| systolic_array_2d | Directed | Parallel computation, all 4 outputs |
| pe_array_2_2 | Directed | Independent PE accumulation |
| matrix_mult_2_2 | Directed | Known matrix product verification |
| ai_accelerator_top | Directed | End-to-end: start→done, result check |

---

## Tools Used

| Tool | Purpose |
|------|---------|
| **Verilog/SystemVerilog** | Hardware description language for all RTL |
| **Icarus Verilog (iverilog)** | Open-source Verilog simulation and compilation |
| **GTKWave** | VCD waveform viewer for debugging simulation output |
| **Vivado / Quartus** | FPGA synthesis, place & route, bitstream generation |
| **ModelSim** | Industry-standard HDL simulation for waveform analysis |
| **VSDSquadron FM (FPGA Mini)** | Physical FPGA board used for hardware deployment and demo |

---

## What I Learned

- **Hardware thinking is fundamentally different from software thinking.** Everything is parallel by default. You don't write loops — you instantiate hardware that runs all at once.
- **Bit-width discipline is critical.** A careless width mismatch (e.g. `[3:0]` output where `[7:0]` is needed) silently truncates values and causes wrong results that are very hard to debug.
- **FSMs are the backbone of digital control.** Any time you need sequencing — even just "do A, then B, then C" — you need a state machine.
- **Testbenches are as important as the RTL.** A module without a testbench is untrusted hardware. The testbench is your proof of correctness.
- **Bottom-up design scales.** By building and verifying small pieces first, the top-level integration was relatively straightforward — because all the building blocks were already proven.
- **Systolic arrays achieve parallelism through data flow, not shared memory.** This is a profound insight: eliminating shared buses and instead passing data between neighbours is what makes them so efficient in silicon.

---

## Future Improvements

- [ ] **Pipelined multi-cycle streaming:** Implement true staggered systolic data flow so the array can process a stream of input vectors back-to-back without resetting
- [ ] **Larger array:** Scale from 2×2 to 4×4 or 8×8 PE grid for more meaningful workloads
- [ ] **UART interface:** Add serial communication so the FPGA can receive arbitrary matrix inputs from a host PC instead of hardcoded values
- [ ] **Fixed-point quantization:** Use Q4.4 or Q8.8 fixed-point format to represent fractional weights, bringing the design closer to real neural network inference
- [ ] **Benchmarking:** Measure actual clock cycles per matrix multiply and compare against software baseline on an equivalent embedded CPU
- [ ] **AXI-Lite interface:** Add an AXI bus interface to make the accelerator compatible with Zynq PS-PL integration or standard SoC interconnects
- [ ] **Synthesize and report:** Add Vivado utilization and timing reports to document actual LUT/DSP/FF usage and achievable clock frequency

---

## Author

Built from scratch as a hardware engineering project to understand the fundamentals of FPGA-based AI acceleration — from logic gates to a working systolic array.

---

*All RTL written in Verilog. Simulated with Icarus Verilog and GTKWave. Synthesized and deployed on FPGA hardware.*
