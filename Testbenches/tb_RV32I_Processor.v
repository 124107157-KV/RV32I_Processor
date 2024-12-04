`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2024 21:00:57
// Design Name: 
// Module Name: TB_RV32I_Processor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Testbench for RV32I_Processor module covering all submodule functionalities.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module tb_RV32I_Processor;

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

    wire [31:0] pc;
    wire [31:0] instruction;
    wire exception;
    wire branch_taken;
    wire jump_taken;

    RV32I_Processor uut (
        .clk(clk),
        .reset(reset),
        .branch_target(branch_target),
        //.branch_taken(branch_taken),
        //.jump_taken(jump_taken),
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
    // Generate instruction memory data dynamically based on PC
    always @(pc) begin
        case (pc[7:0]) // Simulate a 256-byte instruction memory
            8'h00: instruction_memory_input = {32'h00000033, 32'h00010063, 32'h0000006F, 32'hFFFFFFFF}; // Block 0
            8'h10: instruction_memory_input = {32'h12345678, 32'h9ABCDEF0, 32'h00000011, 32'h22222222}; // Block 1
            8'h20: instruction_memory_input = {32'h33333333, 32'h44444444, 32'h55555555, 32'h66666666}; // Block 2
            8'h30: instruction_memory_input = {32'h77777777, 32'h88888888, 32'h99999999, 32'hAAAAAAAA}; // Block 3
            default: instruction_memory_input = {8{32'hFFFFFFFF}}; // Default invalid data
        endcase
    end
    // Test cases
    initial begin
        $monitor("Time: %0t | PC: %h | Instruction: %h | Exception: %b", 
                  $time, pc, instruction, exception);
        // Initialize signals
        clk = 0;
        reset = 0;
        branch_target = 0;
        branch_taken = 0;
        jump_taken = 0;
        jump_target = 0;
        interrupt_taken = 0;
        interrupt_vector = 0;
        stall = 0;
        instruction_memory_input = 256'b0;
        // Apply reset
        #10 reset = 1;
        #10 reset = 0;
        // Test instruction fetch
        #40;
        // Basic Branch test
        branch_taken = 1; branch_target = 32'h10; #10 branch_taken = 0;
        #20;
        // Basic Jump test
        jump_taken = 1; jump_target = 32'h20; #10 jump_taken = 0;
        #20;
        // Interrupt test
        interrupt_taken = 1; interrupt_vector = 32'h30; #10 interrupt_taken = 0;
        #20;
        // Stall test
        stall = 1; #10 stall = 0;
        #20;
        // Exception test
        #50 instruction_memory_input = {8{32'hFFFFFFFF}};
        #20;
        // ** Additional Test Cases **
        // 1. Back-to-back branches
        branch_taken = 1; branch_target = 32'h10; #10 branch_taken = 0;
        #10 branch_taken = 1; branch_target = 32'h20; #10 branch_taken = 0;
        #30;
        // 2. Nested jump test (jump followed by another jump)
        jump_taken = 1; jump_target = 32'h10; #10 jump_taken = 0;
        #10 jump_taken = 1; jump_target = 32'h30; #10 jump_taken = 0;
        #30;
        // 3. Interrupt with branch and jump
        interrupt_taken = 1; interrupt_vector = 32'h30; #10 interrupt_taken = 0;
        #10 branch_taken = 1; branch_target = 32'h10; #10 branch_taken = 0;
        #10 jump_taken = 1; jump_target = 32'h20; #10 jump_taken = 0;
        #30;
        // 4. Combined stall and branch
        stall = 1; #10;
        branch_taken = 1; branch_target = 32'h20; #10 branch_taken = 0; 
        stall = 0; #20;
        // 5. Instruction memory full of valid data
        instruction_memory_input = {32'h12345678, 32'h87654321, 32'hFEDCBA98, 32'hABCDEF01, 
                                     32'h55555555, 32'hAAAAAAAA, 32'h11111111, 32'h22222222};
        #50;
        // 6. PC wrap-around (boundary conditions)
        branch_taken = 1; branch_target = 32'hFC; #10 branch_taken = 0; // Near the end of memory
        #20;
        // Finish simulation
        #50 $finish;
    end
endmodule
