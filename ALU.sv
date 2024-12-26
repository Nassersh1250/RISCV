`timescale 1ns / 1ps

module ALU(
    input logic [31:0]op1,op2,
    input logic [3:0]aluctrl,
    output logic [31:0] result,
    output logic zero
    );
    
    always@(*) begin 
        case(aluctrl) 
            4'b0000: result = op1+op2;
            4'b1000: result = op1-op2;
            4'b0111: result = op1&op2;
            4'b0110: result = op1|op2;
            4'b0100: result = op1^op2;
            4'b0001: result = op1<<op2;
            4'b0101: result = op1>>op2;
            4'b1111: result = op1>>>op2;
            4'b0010: result = $signed(op1)<$signed(op2);
            4'b0011: result = $unsigned(op1)<$unsigned(op2);
            default result = 0;
            endcase;
            
            if (result == 0)
                zero = 1;
            else 
                zero = 0;
                
         end
endmodule
