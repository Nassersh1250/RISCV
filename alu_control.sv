`timescale 1ns / 1ps

module alu_control (
    input [6:0] fun7,                   
    input [2:0] fun3, 
    input [1:0] alu_op,             
    output logic [3:0] alu_ctrl
);

    always_comb begin
        case (alu_op)
            2'b00: alu_ctrl = 4'b0000; // ADD for I-type and Load/Store address calculation
            2'b01: begin  //  Branch instructions
                case (fun3)
                    3'b000: alu_ctrl = 4'b1000; // beq
                    3'b001: alu_ctrl = 4'b1000; // bne
                    3'b100: alu_ctrl = 4'b0010; // blt
                    3'b101: alu_ctrl = 4'b0010; // bge
                    3'b110: alu_ctrl = 4'b0011; // bltu
                    3'b111: alu_ctrl = 4'b0011; //bgeu
                    default:alu_ctrl = 4'b0000;
                    endcase 
                    end  
            2'b10: begin
                case ({fun7[5], fun3})
                    4'b0000: alu_ctrl = 4'b0000; // ADD
                    4'b1000: alu_ctrl = 4'b1000; // SUB
                    4'b0001: alu_ctrl = 4'b0001; // SLL (Shift Left Logical)
                    4'b0010: alu_ctrl = 4'b0010; // SLT (Set Less Than)
                    4'b0011: alu_ctrl = 4'b0011; // SLTU (Set Less Than Unsigned)
                    4'b0100: alu_ctrl = 4'b0100; // XOR
                    4'b0110: alu_ctrl = 4'b0110; // OR
                    4'b0111: alu_ctrl = 4'b0111; // AND
                    4'b1101: alu_ctrl = 4'b1101; // SRA (Shift Right Arithmetic)
                    default: alu_ctrl = 4'b0000; // Default to ADD
                endcase
            end
            default: alu_ctrl = 4'b0000; // Default to ADD
        endcase
    end

endmodule