`timescale 1ns / 1ps

module ALU(
    input logic [31:0] op1, op2,
    input logic [3:0] aluctrl,
    output logic [31:0] result,
    output logic zero, less
    );
    
    always @(*) begin
        result = 0; // Default initialization
        less = 0;
        zero = 0;

        case (aluctrl) 
            4'b0000: result = op1 + op2;
            4'b1000: result = op1 - op2;
            4'b0111: result = op1 & op2;
            4'b0110: result = op1 | op2;
            4'b0100: result = op1 ^ op2;
            4'b0001: result = op1 << op2;
            4'b0101: result = op1 >> op2;
            4'b1111: result = op1 >>> op2;
            4'b0010: result = (op1 < op2) ?1:0;
            4'b0011: result = ($unsigned(op1) < $unsigned(op2))?1:0;
          //  4'b0010: if (op1 < op2) begin
           //             result = 1;
           //             less = 1;
            //         end else begin
            //            result = 0;
            //            less = 0;
            //         end
            //4'b0011: if ($unsigned(op1) < $unsigned (op2)) begin
              //          result = 1;
                //        less = 1;
                 //    end else begin
                   //     result = 0;
                     //   less = 0;
                     //end
            default: result = 0;
        endcase
        
        // Assign zero flag
     //   if (result == 0)
       //     zero = 1;
       // else 
        //    zero = 0;
        assign zero = (result==0);
    end
endmodule