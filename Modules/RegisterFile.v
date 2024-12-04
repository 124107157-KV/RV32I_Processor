`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2024 20:56:51
// Design Name: 
// Module Name: RegisterFile
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

module RegisterFile (
    input clk,
    input reset,
    input [4:0] rs1,           // Register address for read data 1
    input [4:0] rs2,           // Register address for read data 2
    input [4:0] rd,            // Register address for write data
    input [31:0] write_data,   // Data to be written to register rd
    input reg_write,           // Write enable signal
    output [31:0] read_data1,  // Read data from register rs1
    output [31:0] read_data2   // Read data from register rs2
);

    // Register file array of 32 registers, each 32 bits wide
    reg [31:0] registers [0:31];
    // Integer variable for loop (reset logic)
    integer i;
    // Asynchronous reset block: Clears all registers to 0
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Clear all registers when reset is active
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else if (reg_write && rd != 5'b0) begin
            // Write to register rd, but prevent write to register 0 (it's always 0)
            registers[rd] <= write_data;
        end
    end
    // Simultaneous read from register file
    assign read_data1 = registers[rs1];  // Read from register rs1
    assign read_data2 = registers[rs2];  // Read from register rs2

endmodule
