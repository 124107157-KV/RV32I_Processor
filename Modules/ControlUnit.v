`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2024 20:56:51
// Design Name: 
// Module Name: ControlUnit
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
module ControlUnit (
    input [6:0] opcode,          // 7-bit opcode field
    input [2:0] funct3,          // 3-bit funct3 field for R-type instructions
    input [6:0] funct7,          // 7-bit funct7 field for R-type instructions
    output reg reg_write,        // Register write signal
    output reg mem_read,         // Memory read signal
    output reg mem_write,        // Memory write signal
    output reg mem_to_reg,       // Memory to register signal
    output reg branch_taken,     // Branch taken signal
    output reg imm_select,       // Immediate operand selection signal (I-type)
    output reg jump              // Jump instruction signal
);
    always @(*) begin
        // Default control signals
        reg_write = 0;
        mem_read = 0;
        mem_write = 0;
        mem_to_reg = 0;
        branch_taken = 0;
        imm_select = 0;
        jump = 0;
        case (opcode)
            // R-Type instructions (ALU operations)
            7'b0110011: begin // R-Type (e.g., ADD, SUB, AND, OR, etc.)
                reg_write = 1;         // Enable writing to the register file
                imm_select = 0;        // Use register operand (not immediate)
                mem_read = 0;
                mem_write = 0;
                mem_to_reg = 0;
                branch_taken = 0;
                jump = 0;
            end
            // I-Type instructions (Immediate operations)
            7'b0010011: begin // ADDI, SLTI, ANDI, etc.
                reg_write = 1;
                imm_select = 1;        // Immediate operand
                mem_read = 0;
                mem_write = 0;
                mem_to_reg = 0;
                branch_taken = 0;
                jump = 0;
            end
            // Load instruction (lw)
            7'b0000011: begin // lw
                reg_write = 1;         // Write data from memory to register
                mem_read = 1;          // Enable memory read
                mem_write = 0;
                mem_to_reg = 1;        // Load data from memory to register
                imm_select = 1;        // Immediate address calculation
                branch_taken = 0;
                jump = 0;
            end
            // Store instruction (sw)
            7'b0100011: begin // sw
                reg_write = 0;         // No register write
                mem_read = 0;
                mem_write = 1;         // Enable memory write
                mem_to_reg = 0;
                imm_select = 1;        // Immediate address calculation
                branch_taken = 0;
                jump = 0;
            end
            // Branch instructions (beq, bne, etc.)
            7'b1100011: begin // beq, bne, etc.
                reg_write = 0;         // No register write
                mem_read = 0;
                mem_write = 0;
                mem_to_reg = 0;
                imm_select = 1;        // Immediate value for branch offset
                branch_taken = 1;      // Enable branch logic
                jump = 0;
            end
            // Jump instruction (J-Type: jal, jalr)
            7'b1101111: begin // jal
                reg_write = 1;         // Write PC+4 to the register
                mem_read = 0;
                mem_write = 0;
                mem_to_reg = 0;
                imm_select = 1;        // Immediate offset for jump address
                branch_taken = 0;
                jump = 1;              // Enable jump
            end
            7'b1100111: begin // jalr
                reg_write = 1;         // Write the address of next instruction to register
                mem_read = 0;
                mem_write = 0;
                mem_to_reg = 0;
                imm_select = 1;        // Immediate offset for jump address
                branch_taken = 0;
                jump = 1;              // Enable jump
            end
            // Default case (No operation)
            default: begin
                reg_write = 0;
                mem_read = 0;
                mem_write = 0;
                mem_to_reg = 0;
                imm_select = 0;
                branch_taken = 0;
                jump = 0;
            end
        endcase
    end
endmodule
