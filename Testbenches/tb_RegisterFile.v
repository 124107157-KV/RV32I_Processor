`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2024 20:56:51
// Design Name: 
// Module Name: tb_RegisterFile
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

module tb_RegisterFile;

    // Testbench signals
    reg clk;
    reg reset;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] write_data;
    reg reg_write;
    wire [31:0] read_data1, read_data2;

    // Instantiate the RegisterFile module
    RegisterFile uut (
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
    // Clock generation
    always begin
        #5 clk = ~clk;  // Toggle clock every 5 ns
    end
    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        rs1 = 5'b0;
        rs2 = 5'b0;
        rd = 5'b0;
        write_data = 32'b0;
        reg_write = 0;
        // Test 1: Reset test - Ensure all registers are cleared
        $display("Test 1: Reset Test");
        reset = 1;
        #10;
        reset = 0;
        #10;
        if (uut.registers[0] !== 32'b0 || uut.registers[1] !== 32'b0) begin
            $display("ERROR: Registers are not cleared after reset.");
        end else begin
            $display("PASS: Registers cleared after reset.");
        end
        // Test 2: Writing and reading a register (Write to rd[5] and read from rs1[5] and rs2[5])
        $display("\nTest 2: Write and Read Test");
        rd = 5'b00101;  // Register 5
        write_data = 32'hABCD1234;  // Data to write
        reg_write = 1;  // Enable write
        #10;
        reg_write = 0;  // Disable write
        // Read from the same register
        rs1 = 5'b00101;  // Register 5 for read
        rs2 = 5'b00101;  // Register 5 for read
        #10;
        if (read_data1 !== 32'hABCD1234 || read_data2 !== 32'hABCD1234) begin
            $display("ERROR: Incorrect data read from register 5.");
        end else begin
            $display("PASS: Correct data read from register 5.");
        end
        // Test 3: Writing to register 0 (should not write)
        $display("\nTest 3: Write to Register 0");
        rd = 5'b00000;  // Register 0 (Read-Only)
        write_data = 32'hFFFFFFFF;  // Attempt to write 0xFFFFFFFF
        reg_write = 1;  // Enable write
        #10;
        reg_write = 0;  // Disable write
        // Verify register 0 still holds 0
        if (uut.registers[0] !== 32'b0) begin
            $display("ERROR: Register 0 should remain 0.");
        end else begin
            $display("PASS: Register 0 remains 0.");
        end
        // Test 4: Writing and reading multiple registers
        $display("\nTest 4: Multiple Registers Test");
        rd = 5'b01001;  // Register 9
        write_data = 32'h12345678;  // Data to write
        reg_write = 1;
        #10;
        reg_write = 0;
        rs1 = 5'b01001;  // Read from register 9
        rs2 = 5'b01001;  // Read from register 9
        #10;
        if (read_data1 !== 32'h12345678 || read_data2 !== 32'h12345678) begin
            $display("ERROR: Incorrect data read from register 9.");
        end else begin
            $display("PASS: Correct data read from register 9.");
        end
        // Test 5: Reset after write (ensure write does not persist after reset)
        $display("\nTest 5: Reset after Write");
        rd = 5'b01010;  // Register 10
        write_data = 32'h98765432;  // Data to write
        reg_write = 1;
        #10;
        reg_write = 0;
        reset = 1;  // Trigger reset
        #10;
        reset = 0;  // Release reset
        #10;
        if (uut.registers[10] !== 32'b0) begin
            $display("ERROR: Data in register 10 should be cleared after reset.");
        end else begin
            $display("PASS: Data in register 10 cleared after reset.");
        end
        // Test 6: Edge case - Read from an uninitialized register
        $display("\nTest 6: Read Uninitialized Register");
        rs1 = 5'b11111;  // Register 31 (uninitialized)
        rs2 = 5'b11111;  // Register 31 (uninitialized)
        #10;
        if (read_data1 !== 32'b0 || read_data2 !== 32'b0) begin
            $display("ERROR: Uninitialized registers should return 0.");
        end else begin
            $display("PASS: Uninitialized registers return 0.");
        end
        // Test 7: Writing to a register and ensuring other registers are unaffected
        $display("\nTest 7: Writing to One Register and Checking Others");
        rd = 5'b01111;  // Register 15
        write_data = 32'hDEADBEEF;  // Data to write
        reg_write = 1;
        #10;
        reg_write = 0;
        // Read from other registers
        rs1 = 5'b01000;  // Register 8
        rs2 = 5'b10000;  // Register 16
        #10;
        if (read_data1 !== 32'b0 || read_data2 !== 32'b0) begin
            $display("ERROR: Registers 8 and 16 should not be affected by write to register 15.");
        end else begin
            $display("PASS: Registers 8 and 16 unaffected by write to register 15.");
        end
        $display("\nAll tests completed.");
        $finish;
    end
endmodule
