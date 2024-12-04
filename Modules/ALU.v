`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2024 20:56:51
// Design Name: 
// Module Name: ALU
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


module ALU (
    input [31:0] operand_a,
    input [31:0] operand_b,
    input [5:0] alu_control, // Extended control to 6 bits for more operations
    output reg [31:0] alu_result,
    output reg carry_out,
    output reg overflow,
    output reg negative,
    output zero
);

    assign zero = (alu_result == 0);

    always @(*) begin
        // Default flag values
        carry_out = 0;
        overflow = 0;
        negative = 0;

        case (alu_control)
            // Arithmetic Operations
            6'b000000: alu_result = operand_a + operand_b;             // ADD
            6'b000001: alu_result = operand_a - operand_b;             // SUB
            6'b000010: alu_result = operand_a * operand_b;             // MUL
            6'b000011: alu_result = operand_a / operand_b;             // DIV
            6'b000100: alu_result = operand_a % operand_b;             // MOD
            6'b000101: alu_result = -operand_a;                        // NEG
            6'b000110: alu_result = operand_a + 1;                     // INC
            6'b000111: alu_result = operand_a - 1;                     // DEC
            //6'b001000: alu_result = operand_a ** operand_b;            // EXP
            6'b001001: alu_result = (operand_a < operand_b) ? operand_a : operand_b; // MIN
            6'b001010: alu_result = (operand_a > operand_b) ? operand_a : operand_b; // MAX

            // Logical Operations
            6'b010000: alu_result = operand_a & operand_b;             // AND
            6'b010001: alu_result = operand_a | operand_b;             // OR
            6'b010010: alu_result = operand_a ^ operand_b;             // XOR
            6'b010011: alu_result = ~(operand_a & operand_b);          // NAND
            6'b010100: alu_result = ~(operand_a | operand_b);          // NOR
            6'b010101: alu_result = ~(operand_a ^ operand_b);          // XNOR
            6'b010110: alu_result = ~operand_a;                        // NOT
            6'b010111: alu_result = operand_a & ~operand_b;            // BIT CLEAR
            6'b011000: alu_result = |operand_a;                        // REDUCE OR
            6'b011001: alu_result = ^operand_a;                        // PARITY
            6'b011010: alu_result = (operand_a != 0) ? 32'hFFFFFFFF : 0; // ALL 1s if non-zero

            // Shift and Rotate Operations
            6'b100000: alu_result = operand_a << operand_b[4:0];       // SLL
            6'b100001: alu_result = operand_a >> operand_b[4:0];       // SRL
            6'b100010: alu_result = $signed(operand_a) >>> operand_b[4:0]; // SRA
            6'b100011: alu_result = {operand_a[30:0], operand_a[31]};  // ROL
            6'b100100: alu_result = {operand_a[0], operand_a[31:1]};   // ROR
            6'b100101: alu_result = operand_a << (32 - operand_b);     // CIRCULAR LEFT SHIFT
            6'b100110: alu_result = operand_a >> (32 - operand_b);     // CIRCULAR RIGHT SHIFT

            // Comparison Operations
            6'b101000: alu_result = (operand_a == operand_b) ? 1 : 0;  // EQUAL
            6'b101001: alu_result = (operand_a < operand_b) ? 1 : 0;   // LESS THAN
            6'b101010: alu_result = (operand_a > operand_b) ? 1 : 0;   // GREATER THAN
            6'b101011: alu_result = (operand_a <= operand_b) ? 1 : 0;  // LESS THAN OR EQUAL
            6'b101100: alu_result = (operand_a >= operand_b) ? 1 : 0;  // GREATER THAN OR EQUAL

            // Cryptographic and Specialized Operations
            6'b110000: alu_result = operand_a ^ operand_b;             // XOR (Cryptographic Primitive)
            6'b110001: alu_result = ~operand_a;                        // BITWISE NOT
            6'b110010: alu_result = operand_a[operand_b[4:0]];         // BIT SELECT
            6'b110011: alu_result = {operand_a, operand_b};            // CONCATENATION
            6'b110100: alu_result = operand_a ^ (operand_a >> 1);      // GRAY CODE

            // Floating-Point Operations (Pseudo-Support via Integer Approximation)
            6'b111000: alu_result = operand_a * operand_a;             // SQUARE
            6'b111001: alu_result = operand_a / 2;                     // APPROXIMATE DIVISION BY 2
            6'b111010: alu_result = operand_a * operand_b / 1000;      // APPROX MULTIPLY-SCALE

            // Stochastic Computing Operations
            6'b111100: alu_result = (operand_a & operand_b) ? 32'h1 : 0; // AND Probability
            6'b111101: alu_result = operand_a | operand_b;             // OR Probability
            6'b111110: alu_result = ^(operand_a & operand_b);          // XOR Reduce for Randomness
            6'b111111: alu_result = $random;                           // RANDOM Number Generation

            // Default case
            default: alu_result = 32'b0;
        endcase

        // Overflow Detection
        if (alu_control == 6'b000000 || alu_control == 6'b000001) begin
            overflow = (~operand_a[31] & ~operand_b[31] & alu_result[31]) |
                       (operand_a[31] & operand_b[31] & ~alu_result[31]);
        end

        // Negative Detection
        negative = alu_result[31];
    end
endmodule
