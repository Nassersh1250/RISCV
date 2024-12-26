`timescale 1ns / 1ps

module Data_memory_tb;

    // Inputs
    reg clk;
    reg resetn;
    reg memwrite;
    reg [31:0] addr;
    reg [1:0] load_type;
    reg [1:0] store_type;
    reg [31:0] wdata;

    // Outputs
    wire [31:0] rdata_word;
    wire [15:0] rdata_half;
    wire [7:0] rdata_byte;

    // Instantiate the Data_memory module
    Data_memory uut (
        .clk(clk),
        .resetn(resetn),
        .memwrite(memwrite),
        .addr(addr),
        .load_type(load_type),
        .store_type(store_type),
        .wdata(wdata),
        .rdata_word(rdata_word),
        .rdata_half(rdata_half),
        .rdata_byte(rdata_byte)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Testbench logic
    initial begin
        // Initialize inputs
        clk = 0;
        resetn = 0;
        memwrite = 0;
        addr = 0;
        load_type = 0;
        store_type = 0;
        wdata = 0;

        // Reset the memory
        #10 resetn = 1;
        #10 resetn = 0;
        #10 resetn = 1;

        // Test case 1: Write a word and read it back
        #10 memwrite = 1;
        store_type = 2'b00; // store word
        addr = 32'h00000004;
        wdata = 32'hDEADBEEF;
        #10 memwrite = 0;

        #10 load_type = 2'b00; // load word
        addr = 32'h00000004;

        // Test case 2: Write a half-word and read it back
        #10 memwrite = 1;
        store_type = 2'b01; // store half word
        addr = 32'h00000006; // Half-word aligned address
        wdata = 32'h0000ABCD;
        #10 memwrite = 0;

        #10 load_type = 2'b01; // load half word
        addr = 32'h00000006;

        // Test case 3: Write a byte and read it back
        #10 memwrite = 1;
        store_type = 2'b10; // store byte
        addr = 32'h00000007; // Byte-aligned address
        wdata = 32'h000000EF;
        #10 memwrite = 0;

        #10 load_type = 2'b10; // load byte
        addr = 32'h00000007;

        // End simulation
        #50 $stop;
    end
endmodule
