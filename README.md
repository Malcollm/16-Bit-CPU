# 16-bit CPU

A from-scratch 16-bit processor written in Verilog and implemented on a Xilinx
Spartan-7 (XC7S25, Digilent Arty S7-25) with Vivado 2025.2. It has a 16-instruction
ISA, sixteen general-purpose registers, an 8-operation ALU, subroutine support, and
16-bit parallel I/O.

## Specifications

| | |
|---|---|
| Data width | 16 bits |
| Registers | 16 × 16-bit general purpose (R0–R15) |
| Architecture | Harvard (separate instruction ROM and data RAM) |
| Instruction ROM | 2049 × 16-bit words, initialized from `program.mem` |
| Data RAM | 65,536 × 16-bit words |
| ALU | 8 operations (add, sub, and, or, xor, not, lsl, lsr) |
| Flags | zero, negative, carry, overflow |
| Control | multi-cycle (single-cycle fetch + variable-length execute) |
| I/O | one 16-bit input port, one 16-bit output port |
| Clock | 12 MHz |
| Target | Spartan-7 XC7S25 (Arty S7-25) |

## Architecture

```
top  (board I/O: CLK12MHZ, ja/jb in, jc/jd out, btn reset)
└── core
    ├── program_rom          instruction memory (combinational read, PC-addressed)
    ├── control_unit         instruction decoder + sequencer + multi-cycle state
    │   └── sequencer        sub-cycle counter for multi-cycle instructions
    ├── memory               64K × 16-bit data RAM (synchronous)
    └── datapath
        ├── ALU              combinational 16-bit ALU + flag generation
        ├── flag_register    latches the 4 condition flags
        ├── register_file    16 × 16-bit, 2 read ports / 1 write port
        ├── program_counter  reset / load / increment
        ├── instruction_register   transparent latch (PC-synchronized fetch)
        ├── io_register      16-bit input and output ports
        └── subroutine_register    holds the return address for RET
```

### Module reference

| Module | Description |
|--------|-------------|
| `top` | Board wrapper. Maps the 12 MHz clock, the reset button, and the Pmod I/O to the core. |
| `core` | Connects the datapath, data memory, program ROM, and control unit; contains the register-write source mux. |
| `control_unit` | Combinational instruction decoder driving every control signal, plus clocked state for multi-cycle instructions. |
| `sequencer` | Counts sub-cycles within an instruction; reset each time an instruction completes. |
| `datapath` | Execution datapath housing the ALU, flags, register file, PC, IR, I/O, and subroutine register. |
| `ALU` | Purely combinational 16-bit ALU. Computes 8 operations and the raw condition flags. |
| `flag_register` | 4-bit register `{overflow, carry, negative, zero}`; updates only when enabled, clears on reset. |
| `register_file` | 16 × 16-bit registers. Two asynchronous read ports, one synchronous write port. |
| `program_counter` | 16-bit PC with synchronous reset, absolute load, and increment. |
| `instruction_register` | Transparent (combinational) latch: `ir_out = reset ? 0 : rom[pc]`. |
| `subroutine_register` | Stores `PC + 1` on a subroutine call for later return. |
| `io_register` | Registered 16-bit input port and 16-bit output port. |
| `memory` | 64K × 16-bit synchronous data RAM (1-cycle read latency). |
| `program_rom` | 2049 × 16-bit instruction ROM, combinational read, loaded from `program.mem` via `$readmemh`. |

## Instruction Set Architecture

Every instruction is a single 16-bit word. The top nibble `[15:12]` is the opcode.
`CON` is the only two-word instruction (opcode word followed by a 16-bit constant).

### Opcode map

| Opcode | Mnemonic | Meaning |
|:------:|----------|---------|
| `0x0` | ADD | Add |
| `0x1` | SUB | Subtract |
| `0x2` | LOG | Logic/shift (ALU op selected by a field) |
| `0x3` | JMP | Conditional jump (register target) |
| `0x4` | JTS | Jump to subroutine |
| `0x5` | RET | Return from subroutine |
| `0x6` | LD  | Load from data RAM (immediate address) |
| `0x7` | LDR | Load from data RAM (register + register address) |
| `0x8` | ST  | Store to data RAM (immediate address) |
| `0x9` | STR | Store to data RAM (register + register address) |
| `0xA` | IN  | Read input port into a register |
| `0xB` | OUT | Write a register to the output port |
| `0xC` | MOV | Copy register to register |
| `0xD` | HLT | Halt *(not yet implemented — decodes as NOP)* |
| `0xE` | CON | Load 16-bit constant (two-word) |
| `0xF` | NOP | No operation |

### Encodings

Notation: `A/B/W/T/D/S/I` = 4-bit register numbers, `M` = 4-bit flag mask,
`imm8` = 8-bit immediate, `P` = 3-bit ALU op, `F` = flag-enable bit, `-` = unused.

| Mnemonic | Bit layout `[15:0]` | Operation | Cycles |
|----------|---------------------|-----------|:------:|
| ADD  | `0000 AAAA BBBB WWWW` | `R[W] = R[A] + R[B]`, update flags | 1 |
| SUB  | `0001 AAAA BBBB WWWW` | `R[W] = R[A] - R[B]`, update flags | 1 |
| LOG  | `0010 F PPP DDDD BBBB` | `R[D] = R[D] <op P> R[B]` (in place); update flags if `F` | 1 |
| JMP  | `0011 MMMM TTTT ----` | if masked flags all set: `PC = R[T]` | 1 |
| JTS  | `0100 ---- TTTT ----` | `SRR = PC + 1; PC = R[T]` | 2 |
| RET  | `0101 ---- ---- ----` | `PC = SRR` | 1 |
| LD   | `0110 IIIIIIII WWWW` | `R[W] = MEM[imm8]` | 2 |
| LDR  | `0111 AAAA BBBB WWWW` | `R[W] = MEM[R[A] + R[B]]` | 2 |
| ST   | `1000 IIIIIIII SSSS` | `MEM[imm8] = R[S]` | 1 |
| STR  | `1001 BBBB IIII SSSS` | `MEM[R[B] + R[I]] = R[S]` | 2 |
| IN   | `1010 ---- ---- WWWW` | `R[W] = input_port` | 1 |
| OUT  | `1011 ---- ---- SSSS` | `output_port = R[S]` | 1 |
| MOV  | `1100 AAAA ---- WWWW` | `R[W] = R[A]` | 1 |
| CON  | `1110 ---- ---- DDDD` + `imm16` | `R[D] = imm16` | 2 |
| NOP  | `1111 ---- ---- ----` | no operation | 1 |

Notes:
- **LOG** reuses operand A's register as the destination (in-place). The `P` field
  selects the ALU operation (see below); `NOT`, `LSL`, and `LSR` are unary and
  ignore `R[B]`.
- **LD/ST** take an 8-bit immediate address (`imm8`, bits `[11:4]`), reaching the
  first 256 words of data RAM.
- **LDR/STR** compute a full 16-bit address by adding two registers.
- **CON** advances the PC to read the following word as the constant, then skips
  past it — so the constant is never executed as an instruction.

### ALU operations (`P` field)

| `P` | Operation | Result |
|:---:|-----------|--------|
| `000` | ADD | `a + b` (sets carry, overflow) |
| `001` | SUB | `a - b` (sets carry, overflow) |
| `010` | AND | `a & b` |
| `011` | OR  | `a \| b` |
| `100` | XOR | `a ^ b` |
| `101` | NOT | `~a` |
| `110` | LSL | `a << 1` |
| `111` | LSR | `a >> 1` |

`ADD` and `SUB` have their own opcodes; the same ALU op codes are available to
`LOG` via the `P` field.

### Condition flags

The flag register holds 4 bits, updated by `ADD`, `SUB`, and (optionally) `LOG`:

| Bit | Flag | Set when |
|:---:|------|----------|
| 0 | Zero (Z) | result == 0 |
| 1 | Negative (N) | result bit 15 == 1 |
| 2 | Carry (C) | carry-out of add/sub |
| 3 | Overflow (V) | signed overflow of add/sub |

Carry and overflow are only meaningful for `ADD`/`SUB`.

### Conditional jumps

`JMP` uses a 4-bit mask in `[11:8]`, one bit per flag (bit 0 = Zero, bit 1 = Negative,
bit 2 = Carry, bit 3 = Overflow). The jump is taken when **every** flag whose mask
bit is 1 is currently set:

- `mask = 0000` → unconditional jump.
- `mask = 0001` → jump if Zero.
- `mask = 0010` → jump if Negative, etc.

The jump target is always the address held in register `R[T]` (load it first with `CON`).

## Memory model

This is a **Harvard** machine — instructions and data live in separate memories:

- **Program ROM** (`program_rom`): 2049 × 16-bit, read-only, **combinational** read
  addressed directly by the PC. Initialized at power-up from `program.mem`.
- **Data RAM** (`memory`): 65,536 × 16-bit, synchronous read/write with a one-cycle
  read latency (which is why `LD`/`LDR` take two cycles). Written by `ST`/`STR`,
  read by `LD`/`LDR`.
- **Register file**: 16 × 16-bit, two combinational read ports and one clocked write
  port. Registers are not reset (undefined until first written).
- **Subroutine register**: a single 16-bit register that stores the return address on
  `JTS` and restores it on `RET` (single-level; no hardware call stack).

## Execution model

Fetch is **single-cycle and PC-synchronized**: the PC drives the combinational ROM,
whose output passes through the transparent instruction register straight into the
decoder, so the instruction is valid the same cycle the PC points at it — no fetch bubble.

The `sequencer` counts sub-cycles for multi-cycle instructions. The PC holds while an
instruction is mid-execution and advances when the instruction completes:

- **1 cycle**: ADD, SUB, LOG, JMP, RET, ST, IN, OUT, MOV, NOP
- **2 cycles**: LD, LDR (RAM read latency), STR (compute address, then store),
  JTS (save return address, then jump), CON (fetch the constant word, then write it)

## Writing programs

Programs are hand-assembled into `program.mem`, one 16-bit **hex** word per line,
read at load time by `$readmemh`. Use plain `LF` line endings (no carriage returns).

Example — compute `R2 = 8 + 7` and drive it to the output port:

```
F000        // NOP        (start)
E000        // CON R0 = ...
0008        //   constant 0x0008
E001        // CON R1 = ...
0007        //   constant 0x0007
0012        // ADD R2 = R0 + R1   (op=0, A=0, B=1, W=2)
B002        // OUT R2      -> 0x000F
```

Because `CON` is two words, remember that every `CON` occupies two addresses when
computing jump targets.

## I/O and board connections (Arty S7-25)

| Signal | Port | Pin(s) | Purpose |
|--------|------|--------|---------|
| Clock | `CLK12MHZ` | F14 | 12 MHz system clock |
| Reset | `btn[0]` | (button) | Synchronous reset |
| Input port | `{ja, jb}` | Pmod JA/JB | 16-bit `IN` source |
| Output port | `{jc, jd}` | Pmod JC/JD | 16-bit `OUT` destination |

## Clocking

The design runs at **12 MHz** (83.333 ns period), driven from the Arty S7's on-board
12 MHz oscillator. The critical path (instruction fetch → decode → register read →
address add → data memory) closes comfortably at this rate.

## Build and simulation

**Simulate (behavioral):**
1. Open the project in Vivado 2025.2.
2. Place your program in `program.mem`.
3. Set `core_tb` as the simulation top and run **Run Behavioral Simulation**.

**Program the board:**
1. Put your program in `program.mem` (it is baked into the ROM at synthesis).
2. Run synthesis → implementation → generate bitstream.
3. Program the Arty S7-25 via the Hardware Manager.

## Author

Malcolm Mohr
