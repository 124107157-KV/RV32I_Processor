`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2024 20:56:51
// Design Name: 
// Module Name: tb_ControlUnit
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

module tb_ControlUnit;
    // Inputs to the Control Unit
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    // Outputs from the Control Unit
    wire reg_write;
    wire mem_read;
    wire mem_write;
    wire mem_to_reg;
    wire branch_taken;
    wire imm_select;
    wire jump;
    // Instantiate the ControlUnit module
    ControlUnit uut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch_taken(branch_taken),
        .imm_select(imm_select),
        .jump(jump)
    );
    // Test procedure
    initial begin
        // Apply Reset
        $display("Starting Testbench for Control Unit");
        // Test R-Type (e.g., ADD)
        opcode = 7'b0110011;  // R-Type opcode
        funct3 = 3'b000;       // ADD funct3
        funct7 = 7'b0000000;   // No special funct7 for ADD
        #10;
        $display("R-Type (ADD): reg_write=%b, mem_read=%b, mem_write=%b, mem_to_reg=%b, branch_taken=%b, imm_select=%b, jump=%b", 
                 reg_write, mem_read, mem_write, mem_to_reg, branch_taken, imm_select, jump);
        // Test I-Type (e.g., ADDI)
        opcode = 7'b0010011;  // I-Type opcode
        funct3 = 3'b000;       // ADDI funct3
        funct7 = 7'b0000000;   // No funct7 for ADDI
        #10;
        $display("I-Type (ADDI): reg_write=%b, mem_read=%b, mem_write=%b, mem_to_reg=%b, branch_taken=%b, imm_select=%b, jump=%b", 
                 reg_write, mem_read, mem_write, mem_to_reg, branch_taken, imm_select, jump);
        // Test Load instruction (lw)
        opcode = 7'b0000011;  // Load opcode (lw)
        funct3 = 3'b010;       // lw funct3
        funct7 = 7'b0000000;   // No funct7 for lw
        #10;
        $display("Load (lw): reg_write=%b, mem_read=%b, mem_write=%b, mem_to_reg=%b, branch_taken=%b, imm_select=%b, jump=%b", 
                 reg_write, mem_read, mem_write, mem_to_reg, branch_taken, imm_select, jump);
        // Test Store instruction (sw)
        opcode = 7'b0100011;  // Store opcode (sw)
        funct3 = 3'b010;       // sw funct3
        funct7 = 7'b0000000;   // No funct7 for sw
        #10;
        $display("Store (sw): reg_write=%b, mem_read=%b, mem_write=%b, mem_to_reg=%b, branch_taken=%b, imm_select=%b, jump=%b", 
                 reg_write, mem_read, mem_write, mem_to_reg, branch_taken, imm_select, jump);
        // Test Branch instruction (beq)
        opcode = 7'b1100011;  // Branch opcode (beq)
        funct3 = 3'b000;       // beq funct3
        funct7 = 7'b0000000;   // No funct7 for beq
        #10;
        $display("Branch (beq): reg_write=%b, mem_read=%b, mem_write=%b, mem_to_reg=%b, branch_taken=%b, imm_select=%b, jump=%b", 
                 reg_write, mem_read, mem_write, mem_to_reg, branch_taken, imm_select, jump);
        // Test Jump instruction (jal)
        opcode = 7'b1101111;  // Jump opcode (jal)
        funct3 = 3'b000;       // No funct3 for jal
        funct7 = 7'b0000000;   // No funct7 for jal
        #10;
        $display("Jump (jal): reg_write=%b, mem_read=%b, mem_write=%b, mem_to_reg=%b, branch_taken=%b, imm_select=%b, jump=%b", 
                 reg_write, mem_read, mem_write, mem_to_reg, branch_taken, imm_select, jump);
        // Test Jump and Link Register instruction (jalr)
        opcode = 7'b1100111;  // Jump opcode (jalr)
        funct3 = 3'b000;       // No funct3 for jalr
        funct7 = 7'b0000000;   // No funct7 for jalr
        #10;
        $display("Jump and Link Register (jalr): reg_write=%b, mem_read=%b, mem_write=%b, mem_to_reg=%b, branch_taken=%b, imm_select=%b, jump=%b", 
                 reg_write, mem_read, mem_write, mem_to_reg, branch_taken, imm_select, jump);
        // Test default (Unknown opcode)
        opcode = 7'b1111111;  // Unknown opcode
        funct3 = 3'b111;       // Random funct3
        funct7 = 7'b1111111;   // Random funct7
        #10;
        $display("Default (Unknown opcode): reg_write=%b, mem_read=%b, mem_write=%b, mem_to_reg=%b, branch_taken=%b, imm_select=%b, jump=%b", 
                 reg_write, mem_read, mem_write, mem_to_reg, branch_taken, imm_select, jump);
        $stop;
    end
endmodule
