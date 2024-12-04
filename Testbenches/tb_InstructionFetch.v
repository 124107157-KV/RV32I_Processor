`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2024 21:32:44
// Design Name: 
// Module Name: tb_InstructionFetch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_InstructionFetch;

    // Inputs
    reg clk;
    reg reset;
    reg [31:0] branch_target;
    reg branch_taken;
    reg jump_taken;
    reg [31:0] jump_target;
    reg interrupt_taken;
    reg [31:0] interrupt_vector;
    reg stall;
    reg [255:0] instruction_memory_input;

    // Outputs
    wire [31:0] pc;
    wire [31:0] instruction;
    wire exception;

    // Instantiate the InstructionFetch module
    InstructionFetch uut (
        .clk(clk),
        .reset(reset),
        .branch_target(branch_target),
        .branch_taken(branch_taken),
        .jump_taken(jump_taken),
        .jump_target(jump_target),
        .interrupt_taken(interrupt_taken),
        .interrupt_vector(interrupt_vector),
        .stall(stall),
        .instruction_memory_input(instruction_memory_input),
        .pc(pc),
        .instruction(instruction),
        .exception(exception)
    );
    // Clock generation
    always #5 clk = ~clk;
    // Testbench logic
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        branch_target = 0;
        branch_taken = 0;
        jump_taken = 0;
        jump_target = 0;
        interrupt_taken = 0;
        interrupt_vector = 0;
        stall = 0;
        instruction_memory_input = {
            32'h00000001, 32'h00000002, 32'h00000003, 32'h00000004, // First 4 instructions
            32'h00000005, 32'h00000006, 32'h00000007, 32'h00000008, // Next 4 instructions
            32'h00000009, 32'h0000000A, 32'h0000000B, 32'h0000000C, // Next 4 instructions
            32'h0000000D, 32'h0000000E, 32'h0000000F, 32'h00000010  // Last 4 instructions
        };
        // Test 1: Reset behavior
        #10 reset = 0;
        #10 $display("After reset: PC=%h, Instruction=%h, Exception=%b", pc, instruction, exception);
        // Test 2: Default instruction fetching
        #10 $display("Default fetch: PC=%h, Instruction=%h, Exception=%b", pc, instruction, exception);
        // Test 3: Stall behavior
        stall = 1;
        #20 $display("During stall: PC=%h, Instruction=%h, Exception=%b", pc, instruction, exception);
        stall = 0;
        // Test 4: Branch handling
        branch_target = 32'h00000020;
        branch_taken = 1;
        #10 branch_taken = 0;
        #10 $display("After branch: PC=%h, Instruction=%h, Exception=%b", pc, instruction, exception);
        // Test 5: Jump handling
        jump_target = 32'h00000040;
        jump_taken = 1;
        #10 jump_taken = 0;
        #10 $display("After jump: PC=%h, Instruction=%h, Exception=%b", pc, instruction, exception);
        // Test 6: Interrupt handling
        interrupt_vector = 32'h00000060;
        interrupt_taken = 1;
        #10 interrupt_taken = 0;
        #10 $display("After interrupt: PC=%h, Instruction=%h, Exception=%b", pc, instruction, exception);
        // Test 7: Exception detection
        #10 instruction_memory_input = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        #10 $display("Exception case: PC=%h, Instruction=%h, Exception=%b", pc, instruction, exception);
        // Test 8: Prefetch buffer and cache validation
        reset = 1;
        #10 reset = 0;
        #10 stall = 0;
        #50 $display("Cache and prefetch behavior test");
        // Finish simulation
        #100 $finish;
    end
endmodule
