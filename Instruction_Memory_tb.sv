`timescale 1ns / 1ps

module Instruction_Memory_tb;

    // Inputs
    reg [31:0] address;

    // Outputs
    wire [31:0] instruction;

    // Instantiate the Instruction_Memory module
    Instruction_Memory uut (
        .address(address),
        .instruction(instruction)
    );

    // Testbench logic
    initial begin
        // Monitor address and instruction for debugging
        $monitor("Time: %0d | Address: %h | Instruction: %h", $time, address, instruction);

        // Initialize inputs
        address = 0;

        // Apply test cases
        #10 address = '{default: 32'b0};  // Test reading from the first address
        #10 address = 32'h00000004; // Test reading from the second instruction
        #10 address = 32'h00000008; // Test reading from the third instruction
        #10 address = 32'h0000000C; // Test reading from the fourth instruction
        #10 address = 32'h00000010; // Test reading from the fifth instruction

        // End simulation
        #50 $stop;
    end

endmodule
