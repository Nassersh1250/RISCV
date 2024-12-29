`timescale 1ns / 1ps


module RISCV_top(
    input logic clk,resetn
    );
    logic [31:0]next_pc,current_pc,instruction,wdata,rdata1,rdata2,imm,alu_out,romout;
    logic reg_write, mem_write, mem_to_reg, alu_src,branch,zero,Upper_imm;
    logic [1:0] alu_op;
    logic [6:0] opcode;
    logic [3:0] alu_ctrl;
    
    ALU ALU_PC(.op1(current_pc), .op2(4), .aluctrl(4'b0000), .result(next_pc));
    
    Program_Counter PC(.*);
    
    Instruction_Memory IM(.address(current_pc), .instruction(instruction));
    assign opcode = instruction[6:0];
    
    control cntroler(.*);
    
    Register regfile (.raddr1(instruction[19:15]), 
                      .raddr2(instruction[24:20]),
                      .waddr(instruction[11:7]),
                      .wdata(mem_to_reg?romout:alu_out),
                      .rdata1(rdata1),
                      .rdata2(rdata2),
                      .regwrite(reg_write),
                      .clk(clk),
                      .resetn(resetn));
                      
      alu_control ALUCTRL( .alu_op(alu_op),
                           .fun7(instruction[31:25]),
                           .fun3(instruction[14:12]),
                           .alu_ctrl(alu_ctrl));
                                          
      ALU ALU_Main (.op1(rdata1),
                    .op2(alu_src?imm:rdata2),
                    .aluctrl(alu_ctrl),
                    .result(alu_out),
                    .zero(zero));                
     
      Data_memory RAM(.clk(clk),
                      .resetn(resetn),
                      .memwrite(mem_write),
                      .addr(alu_out),
                      .load_type(instruction[14:12]),
                      .wdata(rdata2),
                      .rdata_word(romout)
                      );        
                
    immediate_gen imm_gen(.inst(instruction),.imm(imm));
                          
    
endmodule
