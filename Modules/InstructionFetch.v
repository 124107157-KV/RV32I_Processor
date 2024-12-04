`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2024 21:32:44
// Design Name: 
// Module Name: InstructionFetch
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

module InstructionFetch (
    input clk,
    input reset,
    input [31:0] branch_target,
    input branch_taken,
    input jump_taken,
    input [31:0] jump_target,
    input interrupt_taken,
    input [31:0] interrupt_vector,
    input stall,
    input [255:0] instruction_memory_input,
    output reg [31:0] pc,
    output reg [31:0] instruction,
    output reg exception
);

    reg [31:0] prefetch_buffer [0:3];
    reg [31:0] cache [0:15];
    reg cache_valid [0:15];
    integer i;

    // Instruction fetch logic
    always @(*) begin
        if (pc[31:4] < 16 && cache_valid[pc[31:4]]) begin
            instruction = cache[pc[31:4]];
        end else begin
            instruction = instruction_memory_input[(pc[6:2] * 32) +: 32];
        end
    end

    // PC update logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'b0;
        end else if (stall) begin
            pc <= pc;  // Hold PC during stall
        end else if (interrupt_taken) begin
            pc <= interrupt_vector;
        end else if (branch_taken) begin
            pc <= branch_target;
        end else if (jump_taken) begin
            pc <= jump_target;
        end else begin
            pc <= pc + 4;
        end
    end

    // Cache and prefetch update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1) begin
                cache_valid[i] <= 1'b0;
            end
        end else if (!stall) begin
            if (pc[31:4] < 16) begin
                cache[pc[31:4]] <= instruction_memory_input[(pc[6:2] * 32) +: 32];
                cache_valid[pc[31:4]] <= 1'b1;
            end

            prefetch_buffer[0] <= instruction_memory_input[((pc + 4) >> 2) * 32 +: 32];
            prefetch_buffer[1] <= instruction_memory_input[((pc + 8) >> 2) * 32 +: 32];
            prefetch_buffer[2] <= instruction_memory_input[((pc + 12) >> 2) * 32 +: 32];
            prefetch_buffer[3] <= instruction_memory_input[((pc + 16) >> 2) * 32 +: 32];
        end
    end

    // Exception detection
    always @(*) begin
        if (pc > 255 || instruction == 32'hFFFFFFFF) begin
            exception = 1'b1;
        end else begin
            exception = 1'b0;
        end
    end

endmodule
