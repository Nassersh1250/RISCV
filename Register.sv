`timescale 1ns / 1ps

module Register(
    input logic clk,resetn,regwrite,
    input logic [4:0] raddr1,raddr2,waddr,
    input logic [31:0] wdata,
    output logic [31:0] rdata1,rdata2
    );
    
    logic [31:0]register_Data[0:31];
    
    assign register_Data[0] = 0;
    
    always@(*) begin 
        rdata1 = register_Data[raddr1];
        rdata2 = register_Data[raddr2];
    end
    
    always@(posedge clk or negedge resetn) begin
        if(!resetn)
             register_Data = '{32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 
                         32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 
                         32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 
                         32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0};
        else if (regwrite) begin 
            register_Data[waddr] <= wdata;
        end
    end
endmodule
