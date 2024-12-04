`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2024 20:56:51
// Design Name: 
// Module Name:tb_ ALU
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

module tb_ALU;

    // Inputs
    reg [31:0] operand_a;
    reg [31:0] operand_b;
    reg [5:0] alu_control;

    // Outputs
    wire [31:0] alu_result;
    wire carry_out;
    wire overflow;
    wire negative;
    wire zero;

    // Instantiate the ALU module
    ALU uut (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .alu_control(alu_control),
        .alu_result(alu_result),
        .carry_out(carry_out),
        .overflow(overflow),
        .negative(negative),
        .zero(zero)
    );

    initial begin
        // Initialize inputs
        operand_a = 32'b0;
        operand_b = 32'b0;
        alu_control = 6'b000000; // ADD operation

        // Test cases
        $display("Starting ALU Testbench");

        // Test ADD operation
        #10;
        operand_a = 32'h00000005;
        operand_b = 32'h00000003;
        alu_control = 6'b000000; // ADD
        #10;
        $display("ADD: 5 + 3 = %h, Result: %h, Zero: %b, Overflow: %b, Negative: %b, Carry Out: %b", 
                 operand_a, alu_result, zero, overflow, negative, carry_out);

        // Test SUB operation
        #10;
        operand_a = 32'h00000010;
        operand_b = 32'h00000005;
        alu_control = 6'b000001; // SUB
        #10;
        $display("SUB: 16 - 5 = %h, Result: %h, Zero: %b, Overflow: %b, Negative: %b, Carry Out: %b", 
                 operand_a, alu_result, zero, overflow, negative, carry_out);

        // Test MUL operation
        #10;
        operand_a = 32'h00000005;
        operand_b = 32'h00000004;
        alu_control = 6'b000010; // MUL
        #10;
        $display("MUL: 5 * 4 = %h, Result: %h, Zero: %b, Overflow: %b, Negative: %b, Carry Out: %b", 
                 operand_a, alu_result, zero, overflow, negative, carry_out);

        // Test DIV operation
        #10;
        operand_a = 32'h00000010;
        operand_b = 32'h00000002;
        alu_control = 6'b000011; // DIV
        #10;
        $display("DIV: 16 / 2 = %h, Result: %h, Zero: %b, Overflow: %b, Negative: %b, Carry Out: %b", 
                 operand_a, alu_result, zero, overflow, negative, carry_out);

        // Test MOD operation
        #10;
        operand_a = 32'h00000010;
        operand_b = 32'h00000003;
        alu_control = 6'b000100; // MOD
        #10;
        $display("MOD: 16 %% 3 = %h, Result: %h, Zero: %b, Overflow: %b, Negative: %b, Carry Out: %b", 
                 operand_a, alu_result, zero, overflow, negative, carry_out);

        // Test NEG operation
        #10;
        operand_a = 32'h00000005;
        alu_control = 6'b000101; // NEG
        #10;
        $display("NEG: -5 = %h, Result: %h, Zero: %b, Overflow: %b, Negative: %b, Carry Out: %b", 
                 operand_a, alu_result, zero, overflow, negative, carry_out);

        // Test INC operation
        #10;
        operand_a = 32'h00000005;
        alu_control = 6'b000110; // INC
        #10;
        $display("INC: 5 + 1 = %h, Result: %h, Zero: %b, Overflow: %b, Negative: %b, Carry Out: %b", 
                 operand_a, alu_result, zero, overflow, negative, carry_out);

        // Test DEC operation
        #10;
        operand_a = 32'h00000005;
        alu_control = 6'b000111; // DEC
        #10;
        $display("DEC: 5 - 1 = %h, Result: %h, Zero: %b, Overflow: %b, Negative: %b, Carry Out: %b", 
                 operand_a, alu_result, zero, overflow, negative, carry_out);

        // Test AND operation
        #10;
        operand_a = 32'h00000005;
        operand_b = 32'h00000003;
        alu_control = 6'b010000; // AND
        #10;
        $display("AND: 5 & 3 = %h, Result: %h, Zero: %b, Overflow: %b, Negative: %b, Carry Out: %b", 
                 operand_a, alu_result, zero, overflow, negative, carry_out);

        // Test OR operation
        #10;
        operand_a = 32'h00000005;
        operand_b = 32'h00000003;
        alu_control = 6'b010001; // OR
        #10;
        $display("OR: 5 | 3 = %h, Result: %h, Zero: %b, Overflow: %b, Negative: %b, Carry Out: %b", 
                 operand_a, alu_result, zero, overflow, negative, carry_out);

        // Test XOR operation
        #10;
        operand_a = 32'h00000005;
        operand_b = 32'h00000003;
        alu_control = 6'b010010; // XOR
        #10;
        $display("XOR: 5 ^ 3 = %h, Result: %h, Zero: %b, Overflow: %b, Negative: %b, Carry Out: %b", 
                 operand_a, alu_result, zero, overflow, negative, carry_out);

        // Test SLL (Shift Left Logical)
        #10;
        operand_a = 32'h00000001;
        operand_b = 32'h00000002;  // Shift by 2
        alu_control = 6'b100000; // SLL
        #10;
        $display("SLL: 1 << 2 = %h, Result: %h, Zero: %b, Overflow: %b, Negative: %b, Carry Out: %b", 
                 operand_a, alu_result, zero, overflow, negative, carry_out);

        // Test SRL (Shift Right Logical)
        #10;
        operand_a = 32'h00000004;
        operand_b = 32'h00000001;  // Shift by 1
        alu_control = 6'b100001; // SRL
        #10;
        $display("SRL: 4 >> 1 = %h, Result: %h, Zero: %b, Overflow: %b, Negative: %b, Carry Out: %b", 
                 operand_a, alu_result, zero, overflow, negative, carry_out);

        // Test SRA (Shift Right Arithmetic)
        #10;
        operand_a = 32'h80000000;  // Negative number
        operand_b = 32'h00000002;  // Shift by 2
        alu_control = 6'b100010; // SRA
        #10;
        $display("SRA: 80000000 >> 2 = %h, Result: %h, Zero: %b, Overflow: %b, Negative: %b, Carry Out: %b", 
                 operand_a, alu_result, zero, overflow, negative, carry_out);

        // Test RANDOM operation (Stochastic)
        #10;
        alu_control = 6'b111111; // RANDOM
        #10;
        $display("RANDOM: %h, Zero: %b, Overflow: %b, Negative: %b, Carry Out: %b", 
                 alu_result, zero, overflow, negative, carry_out);

        // Test BIT SELECT
        #10;
        operand_a = 32'hA5A5A5A5; // 1010 0101...
        operand_b = 32'h00000010; // Bit 16
        alu_control = 6'b110100; // BIT SELECT
        #10;
        $display("BIT SELECT: A5A5A5A5[16] = %h, Result: %h, Zero: %b, Overflow: %b, Negative: %b, Carry Out: %b", 
                 operand_a, alu_result, zero, overflow, negative, carry_out);

        $display("Testbench Complete");
        $finish;
    end
endmodule
