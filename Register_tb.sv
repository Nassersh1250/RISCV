`timescale 1ns / 1ps

module Register_tb;

    // Inputs
    reg clk;
    reg resetn;
    reg regwrite;
    reg [4:0] raddr1;
    reg [4:0] raddr2;
    reg [4:0] waddr;
    reg [31:0] wdata;

    // Outputs
    wire [31:0] rdata1;
    wire [31:0] rdata2;

    // Instantiate the Unit Under Test (UUT)
    Register uut (
        .clk(clk),
        .resetn(resetn),
        .regwrite(regwrite),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .waddr(waddr),
        .wdata(wdata),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        resetn = 0;
        regwrite = 0;
        raddr1 = 0;
        raddr2 = 0;
        waddr = 0;
        wdata = 0;

        // Reset the register file
        #10;
        resetn = 1;
        #10;
        resetn = 0;
        #10;
        resetn = 1;

        // Test write operation
        #10;
        regwrite = 1;waddr = 5'd1; wdata = 32'hAAAA_AAAA;
        #20
        regwrite = 0;

        // Test read operation
        #10; raddr1 = 5'd1;raddr2 = 5'd0; // Read register 1 and register 0
        

        // Test another write
        regwrite = 1;
        waddr = 5'd2; // Write to register 2
        wdata = 32'h5555_5555;
        #10;
        regwrite = 0;

        // Test another read
        #10;
        raddr1 = 5'd2; // Read register 2
        raddr2 = 5'd1; // Read register 1
        #10;

        // Test reset
        resetn = 0;
        #10;
        resetn = 1;

        // Check that registers are reset
        raddr1 = 5'd1; // Should return 0 after reset
        raddr2 = 5'd2; // Should return 0 after reset
        #10;

        // Finish simulation
        $stop;
    end

endmodule
