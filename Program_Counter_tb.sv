`timescale 1ns / 1ps

module Program_Counter_tb;

    // Parameter
    parameter n = 32;

    // Testbench Signals
    logic [n-1:0] next_pc;
    logic clk;
    logic resetn;
    logic [n-1:0] current_pc;

    // Instantiate the DUT (Device Under Test)
    Program_Counter #(.n(n)) dut (
        .next_pc(next_pc),
        .clk(clk),
        .resetn(resetn),
        .current_pc(current_pc)
    );

    // Clock generation: 10ns period (50MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize signals
        resetn = 0;        // Apply reset
        next_pc = 0;
        
        // Monitor values for debugging
        $monitor("Time: %0t | resetn: %b | next_pc: %h | current_pc: %h", $time, resetn, next_pc, current_pc);
        
        // Hold reset for a few cycles
        #10 resetn = 1; next_pc = 32'h00000004;
        #10 resetn = 0;
        #10 resetn = 1;    // Release reset
        #10 next_pc = 32'h00000008;
        #10 next_pc = 32'h00000010;
        // Apply test patterns
         // PC should update to 4
         // PC should update to 8
         // PC should update to 16
        
        // Apply reset during operation
        #10 resetn = 0;    // Apply reset again
        #10 resetn = 1;  next_pc = 32'h00000020; // PC should update to 32
        
        // Finish simulation
        #20 $finish;
    end

endmodule
