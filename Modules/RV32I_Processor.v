`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2024 21:00:57
// Design Name: 
// Module Name: RV32I_Processor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// RV32I_Processor module covering all submodule functionalities.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module RV32I_Processor (
    input clk,
    input reset,
    input [31:0] branch_target,
    //input branch_taken,          // Correctly declared as input port
    //input jump_taken,            // Correctly declared as input port
    input [31:0] jump_target,
    input interrupt_taken,
    input [31:0] interrupt_vector,
    input stall,
    input [255:0] instruction_memory_input,  // Instruction memory input port
    // Outputs
    output [31:0] pc,
    output [31:0] alu_result,
    output wire [31:0] instruction,
    output reg_write,
    // Outputs for register file and ALU debug
    output [31:0] read_data1,
    output [31:0] read_data2,
    output zero,
    output [5:0] alu_control,
    output exception
);

    // Internal signals for InstructionFetch and control signals
    wire [31:0] branch_target_wire, jump_target_wire, interrupt_vector_wire;
    wire stall_wire, interrupt_taken_wire;

    // Assign fields from instruction (this is part of the instruction decoding)
    wire [4:0] rs1, rs2, rd;
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd = instruction[11:7];

    // Instruction Fetch Module instantiation
    InstructionFetch IF (
        .clk(clk),
        .reset(reset),
        .branch_target(branch_target),  // Connect to the top-level port
        .branch_taken(CU_branch_taken),    // Use the branch_taken input port directly
        .jump_taken(CU_jump_taken),        // Use the jump_taken input port directly
        .jump_target(jump_target),      // Connect to the top-level port
        .interrupt_taken(interrupt_taken),  // Connect to the top-level port
        .interrupt_vector(interrupt_vector), // Connect to the top-level port
        .stall(stall),  // Connect to the top-level port
        .instruction_memory_input(instruction_memory_input),
        .pc(pc),
        .instruction(instruction),      // Instruction driven by IF module
        .exception(exception)
    );

    // Register File Module instantiation
    RegisterFile RF (
        .clk(clk),
        .reset(reset),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Control Unit instantiation
    ControlUnit CU (
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch_taken(branch_taken),
        .imm_select(imm_select),
        .jump(jump_taken) // Directly use the jump_taken input port
    );

    // ALU instantiation
    ALU ALU (
        .operand_a(read_data1),
        .operand_b(imm_select ? {{20{instruction[31]}}, instruction[31:20]} : read_data2),
        .alu_control(alu_control),
        .alu_result(alu_result),
        .carry_out(),
        .overflow(),
        .negative(),
        .zero(zero)
    );

    // Write Data Assignment (select data from memory or ALU result)
    assign write_data = mem_to_reg ? alu_result : alu_result; // In a real processor, this would also include memory data if mem_to_reg is set

    // Branch Target and Jump Target Logic
    assign branch_target_wire = pc + {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // Branch offset
    assign jump_target_wire = pc + {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // Jump offset

endmodule
