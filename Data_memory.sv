`timescale 1ns / 1ps

module Data_memory(
    input logic clk,resetn,memwrite,
    input logic [31:0]addr, 
    input reg [31:0]wdata,
    output reg [31:0] rdata
    );
    
    reg [31:0] dmem[0:1023];
    
    always@(*) begin
        rdata = dmem[addr];
    end
    
    always@(posedge clk or negedge resetn) begin
        if (!resetn) begin 
            dmem = {0};
            wdata = 0;
            rdata = 0;
            
        end
        
        else if (memwrite == 1)
            dmem[addr] = wdata;
            
     end
endmodule
