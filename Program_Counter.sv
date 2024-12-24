`timescale 1ns / 1ps

module Program_Counter#(parameter n = 32)(
    input logic [n-1:0]next_pc,
    input logic clk, resetn,
    output logic [n-1:0] current_pc

    );
    
    
    always@(posedge clk or negedge resetn) begin
        if (!resetn)
            current_pc <= 0;
        else 
            current_pc <= next_pc;
        end
endmodule
