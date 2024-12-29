`timescale 1ns / 1ps


module control(
    input logic [6:0] opcode,
    output logic reg_write,
    output logic mem_write,
    output logic mem_to_reg,
    output logic [1:0]alu_op,
    output logic alu_src,
    output logic branch,Upper_imm
    );
    
    always@(*) begin
    case (opcode) 
        7'b0110011: begin 
                reg_write = 1;
                mem_write = 0;
                mem_to_reg = 0;
                alu_op = 2'b10;
                alu_src = 0;
                branch = 0;
                Upper_imm = 0;
                end
        7'b0010011: begin 
                reg_write = 1;
                mem_write = 0;
                mem_to_reg = 0;
                alu_op = 2'b11;
                alu_src = 1;
                branch = 0;
                Upper_imm = 0;
                end
         7'b0000011: begin 
                reg_write = 1;
                mem_write = 0;
                mem_to_reg = 1;
                alu_op = 2'b00;
                alu_src = 1;
                branch = 0;
                Upper_imm = 0;
                end
         7'b0100011: begin 
                reg_write = 0;
                mem_write = 1;
                alu_op = 2'b00;
                alu_src = 1;
                branch = 0;
                Upper_imm = 0;
                end
          7'b1100011: begin 
                reg_write = 0;
                mem_write = 0;
                alu_op = 2'b01;
                alu_src = 0;
                branch = 1;
                Upper_imm = 0;
                end
          7'b0110111: begin 
                reg_write = 1;
                mem_write = 0;
                alu_op = 2'b00;
                mem_to_reg = 0;
                alu_src = 1;
                branch = 0;
                Upper_imm = 1;
                end
          7'b0010111: begin 
                reg_write = 1;
                mem_write = 0;
                alu_op = 2'b00;
                mem_to_reg = 0;
                alu_src = 1;
                branch = 0;
                Upper_imm = 1;
                end      
                endcase
                end
endmodule
