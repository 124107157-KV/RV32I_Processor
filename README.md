# Design of RV32I Processor for Basic Stochastic Computing
# RV32I Processor

The **RV32I Processor** is a simplified implementation of the 32-bit RISC-V instruction set architecture (ISA), designed to execute basic instructions, including arithmetic, logical, memory access, and control transfer operations. This processor is modular, making it easy to understand, extend, and customize.

---

                          +-----------------------+
                          |      Instruction      |
                          |        Fetch (IF)     |
                          |-----------------------|
                          |  Inputs: clk, reset,  |
                          |  branch/jump signals, |
                          |  instruction mem blk  |
                          |  Outputs: PC, Instr   |
                          +-----------+-----------+
                                      |
                                      V
                          +-----------------------+
                          |     Control Unit      |
                          |        (CU)           |
                          |-----------------------|
                          |  Inputs: Opcode,      |
                          |  funct3, funct7       |
                          |  Outputs: Control     |
                          |  signals (reg_write,  |
                          |  mem_read, etc.)      |
                          +-----------+-----------+
                                      |
                    +-----------------+-----------------+
                    |                                   |
                    V                                   V
         +----------------------+           +-----------------------+
         |    Register File     |           |          ALU          |
         |         (RF)         |           |                       |
         |----------------------|           |  Inputs: operand_a,   |
         |  Inputs: clk, reset, |           |  operand_b, alu_ctrl  |
         |  rs1, rs2, rd,       |           |  Outputs: alu_result, |
         |  write_data, reg_wr  |           |  flags (zero, etc.)   |
         |  Outputs: read_data1,|           +-----------+-----------+
         |  read_data2          |                       |
         +----------------------+                       |
                    |                                  (Branch, jump,
                    +------------> Write Back <--------- results, etc.)

---

## Features

- **32-bit Instruction Set**: Implements the RV32I base instruction set.
- **Pipeline Support**: Basic fetch, decode, and execute stages with support for branch prediction and stalls.
- **ALU Operations**: Comprehensive support for arithmetic, logical, and shift operations.
- **Interrupt Handling**: Supports interrupt vectors for preemptive execution.
- **Register File**: Includes 32 general-purpose registers.
- **Instruction Fetch Optimization**: Prefetch buffer and cache for efficient instruction memory access.

---

## Project Structure

The design consists of modular components, each responsible for a specific part of the processor's operation. Below is an overview of the key modules:

### 1. **RV32I_Processor**
The top-level module integrates all the submodules and serves as the main interface. 

**Inputs:**
- `clk`: Clock signal.
- `reset`: Reset signal.
- `branch_target`: Target address for branch instructions.
- `jump_target`: Target address for jump instructions.
- `interrupt_taken`: Indicates if an interrupt is active.
- `interrupt_vector`: Address of the interrupt service routine.
- `stall`: Control signal to stall the pipeline.
- `instruction_memory_input`: Input instructions from memory.

**Outputs:**
- `pc`: Current program counter.
- `alu_result`: Result of the ALU operation.
- `instruction`: Current instruction being executed.
- `reg_write`: Indicates if a register write occurred.
- `read_data1` and `read_data2`: Outputs of the register file for the two source operands.
- `zero`: Zero flag from the ALU.
- `alu_control`: Control signals for the ALU.
- `exception`: Indicates exceptions like memory access violations.

---

### 2. **InstructionFetch**
Handles fetching instructions from memory, updating the program counter (PC), and managing prefetch buffers and instruction cache.

**Key Features:**
- Prefetch buffer for the next four instructions.
- Cache for instructions to reduce memory latency.
- Supports branch and jump instructions.
- Handles interrupts and stalls.

**Outputs:**
- `pc`: Current program counter.
- `instruction`: Fetched instruction.
- `exception`: Indicates invalid memory access or instruction fetch.

---

### 3. **RegisterFile**
Implements a 32-register array where data can be read asynchronously and written synchronously.

**Key Features:**
- 32 general-purpose registers.
- Register 0 is hardwired to zero.
- Supports simultaneous reads from two registers.

**Inputs:**
- `rs1`, `rs2`, `rd`: Source and destination register indices.
- `write_data`: Data to write to the destination register.
- `reg_write`: Enable signal for writing.

**Outputs:**
- `read_data1`: Data from the first source register.
- `read_data2`: Data from the second source register.

---

### 4. **ControlUnit**
Decodes the instruction opcode and generates control signals for the rest of the processor.

**Key Features:**
- Decodes instruction types (R, I, S, B, U, J).
- Generates control signals for ALU, memory, and branch/jump logic.

**Outputs:**
- `reg_write`, `mem_read`, `mem_write`, `mem_to_reg`, `branch_taken`, `imm_select`, `jump`.

---

### 5. **ALU**
Performs arithmetic, logical, and comparison operations.

**Key Features:**
- Supports operations like ADD, SUB, MUL, DIV, AND, OR, XOR, shifts, comparisons, and more.
- Overflow, carry-out, and zero detection.
- Flexible 6-bit control signal for extended operations.

**Outputs:**
- `alu_result`: Result of the operation.
- `zero`: Flag indicating if the result is zero.
- `carry_out`, `overflow`, `negative`: Additional ALU status flags.

---

## Usage

### Simulation
1. Use a Verilog simulator like **ModelSim** or **Vivado**.
2. Create a testbench to provide instructions, inputs, and observe outputs.
3. Simulate the processor and analyze waveforms to verify functionality.

### Integration
1. Connect the `instruction_memory_input` to an instruction memory module or ROM.
2. Connect the ALU outputs to a memory or I/O interface if required.
3. Handle interrupts and exceptions through appropriate input vectors.

---

## Future Enhancements
- Add support for more RISC-V extensions (e.g., RV32M for multiplication/division).
- Implement pipelining for enhanced performance.
- Integrate a memory management unit (MMU) for virtual memory.
- Enhance branch prediction logic.

---

## References
- [RISC-V ISA Specifications](https://riscv.org/technical/specifications/)
- Digital Design Resources for Verilog and RISC Architectures

Feel free to extend or modify the modules based on your specific requirements!
