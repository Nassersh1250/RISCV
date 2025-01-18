`timescale 1ns / 1ps

module pipeline_reg#(parameter n)(
    input logic clk,resetn,
    input logic [n-1:0] in_data,
    output logic [n-1:0] out_data
    );
    
    logic [n-1:0] reg_data;
    
    always_ff@(posedge clk or negedge resetn) begin
        if(!resetn)
            reg_data <= 0;
        else 
            reg_data <= in_data;
        end
        
        assign out_data = reg_data;
endmodule
