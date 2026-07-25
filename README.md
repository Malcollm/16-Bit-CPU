# 16-bit CPU

A 16-bit processor written from scratch in Verilog, targeting the Digilent **Arty S7-25**
(Xilinx **Spartan-7 XC7S25**) FPGA and built with **Vivado 2025.2**.

> ⚠️ **Work in progress.** The individual building blocks (ALU, register file, program
> counter, memory, etc.) are implemented and the datapath is wired together. The **control
> unit / instruction decoder is not built yet**, and the top-level `core` does not yet drive
> all of the datapath's control signals. See [Status](#status) below.

## Overview

- **Data width:** 16 bits
- **Registers:** 16 × 16-bit general-purpose register file
- **Memory:** 65,536 × 16-bit words (single-port, synchronous)
- **ALU ops:** add, subtract, bitwise AND, bitwise OR
- **Flags:** zero, negative, carry, overflow (stored in a dedicated flag register)
- **I/O:** one 16-bit input port and one 16-bit output port

## Architecture

```
top
└── core
    ├── instruction_register     // latches the fetched instruction word
    ├── memory                   // 64K × 16-bit unified memory
    └── datapath
        ├── ALU                  // combinational add / sub / and / or + flags
        ├── flag_register        // latches ALU flags when enabled
        ├── register_file        // 16 × 16-bit, 2 read ports / 1 write port
        ├── program_counter      // reset / load / increment
        └── io_register          // 16-bit input and output ports
```

## Modules

| File | Module | Description |
|------|--------|-------------|
| [`top.v`](CPUproj.srcs/sources_1/new/top.v) | `top` | Top-level wrapper; connects the 100 MHz board clock (`CLK100MHZ`) to the core. |
| [`core.v`](CPUproj.srcs/sources_1/new/core.v) | `core` | Ties together the datapath, memory, and instruction register. Selects the register-file write source (memory / ALU / input port). |
| [`datapath.v`](CPUproj.srcs/sources_1/new/datapath.v) | `datapath` | The execution datapath: ALU, flag register, register file, program counter, and I/O register. |
| [`ALU.v`](CPUproj.srcs/sources_1/new/ALU.v) | `ALU` | Purely combinational 16-bit ALU. Computes add / sub / and / or and produces zero, negative, carry, and overflow flags. Carry/overflow are only meaningful for add/sub. |
| [`flag_register.v`](CPUproj.srcs/sources_1/new/flag_register.v) | `flag_register` | 4-bit register holding `{overflow, carry, negative, zero}`; updates only when enabled, clears on reset. |
| [`register_file.v`](CPUproj.srcs/sources_1/new/register_file.v) | `register_file` | 16 × 16-bit registers. Two asynchronous read ports (`out_a`, `out_b`) and one synchronous write port gated by `write`. |
| [`program_counter.v`](CPUproj.srcs/sources_1/new/program_counter.v) | `program_counter` | 16-bit PC supporting synchronous reset, absolute load (`write`), and increment (`inc`). |
| [`instruction_register.v`](CPUproj.srcs/sources_1/new/instruction_register.v) | `instruction_register` | 16-bit register that latches the current instruction word on `write`, clears on reset. |
| [`io_register.v`](CPUproj.srcs/sources_1/new/io_register.v) | `io_register` | Holds one 16-bit output port (latched on `latch_out`) and one 16-bit input port. |
| [`memory.v`](CPUproj.srcs/sources_1/new/memory.v) | `memory` | 65,536 × 16-bit synchronous memory with a single read/write port. |

## ALU operations

| `op` | Operation | Notes |
|------|-----------|-------|
| `2'b00` | `a + b` (ADD) | Sets carry and overflow |
| `2'b01` | `a - b` (SUB) | Sets carry and overflow |
| `2'b10` | `a & b` (AND) | carry/overflow forced to 0 |
| `2'b11` | `a \| b` (OR)  | carry/overflow forced to 0 |

Flags produced: `zero` (result == 0), `neg` (result MSB), `carry` (bit 16 of the widened
add/sub), `overflow` (signed overflow for add/sub).

## Target hardware

- **Board:** Digilent Arty S7-25
- **FPGA:** Xilinx Spartan-7 `XC7S25`
- **Clock:** 100 MHz (`CLK100MHZ`)
- **Constraints:** [`Arty-S7-25-Master.xdc`](CPUproj.srcs/constrs_1/imports/Downloads/Arty-S7-25-Master.xdc)

## Building

1. Open `CPUproj.xpr` in Vivado 2025.2.
2. Run synthesis and implementation.
3. Generate the bitstream and program the Arty S7-25.

## Status

Implemented:
- [x] ALU (add / sub / and / or with flags)
- [x] Flag register
- [x] 16 × 16-bit register file
- [x] Program counter (reset / load / increment)
- [x] Instruction register
- [x] I/O register
- [x] 64K × 16-bit memory
- [x] Datapath integrating the above

Still to do:
- [ ] Instruction set architecture (`ISA.xlsx` is currently a placeholder)
- [ ] Control unit / instruction decoder (fetch–decode–execute FSM)
- [ ] Wire the control signals through `core` (datapath control inputs, memory `addr`/`write`, IR `write`, and the register write-source selects `mem_to_reg` / `alu_to_reg`)
- [ ] Reset routing to the top level
- [ ] Testbenches / simulation
- [ ] Pin constraints for I/O ports

## Author

Malcolm Mohr
