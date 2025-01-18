`timescale 1ns / 1ps


module RISCV_pipeline(
    input logic clk,resetn
    );
    logic [31:0]next_pc,pc_offset,current_pc,instruction,wdata,rdata1,rdata2,imm,alu_out,romout,pc_jump;
    logic reg_write,jump,pc_return, mem_write, mem_to_reg, alu_src,branch,zero,pc_sel,pc_sel_jump,pc_sel_branch,Upper_imm;
    logic [1:0] alu_op;
    logic [6:0] opcode;
    logic [3:0] alu_ctrl;
    assign pc_offset = pc_return?alu_out:pc_jump;
    assign pc_sel = 0;
    
    
      logic [31:0] instruction_iw,pc_iw,alu_out_iw,romout_w,WB_muxout;
   logic [10:0] control_bits_iw; 
   logic [4:0] WB_rs1,WB_rs2,WB_rd;
   logic [1:0] forwardA,forwardB;

   
    // instruction fetch
    ALU ALU_PC(
    .op1(current_pc),
    .op2(4),
    .aluctrl(4'b0000),
    .result(next_pc));
    
    ALU ALU_PC2(
        .op1(current_pc),
        .op2(imm),
        .aluctrl(4'b0000),
        .result(pc_jump));
        //assign pc_sel = (pc_sel_jump|pc_sel_branch);
    Branch_Controller BC(.*,.func3(instruction[14:12]),.pc_sel(pc_sel_branch));
    
    Program_Counter PC(
        .*,
        .next_pc(pc_sel?pc_offset:next_pc));
        
    Instruction_Memory IM(.address(current_pc), .instruction(instruction));
        
    
    
    
    // Instruction Fetch
    logic [63:0] if_id_out;
    pipeline_reg #(.n(64)) IF_ID (.*,.in_data({current_pc,instruction}),
                                  .out_data(if_id_out));
    // Instruction decode
    
    
//    assign opcode = if_id_out[6:0];
    
    logic [10:0] control_bits_id;
    logic [31:0] instruction_id,pc_id;
    
    assign instruction_id = if_id_out[31:0];
    assign pc_id = if_id_out[63:32];
    
    control cntroler(.opcode(if_id_out[6:0]),
                     .reg_write(control_bits_id[0]),
                     .mem_write(control_bits_id[1]),                            
                     .mem_to_reg(control_bits_id[2]),                           
                     .alu_src(control_bits_id[3]),                          
                     .alu_op(control_bits_id[5:4]),                              
                     .branch(control_bits_id[6]),
                     .Upper_imm(control_bits_id[7]),
                     .pc_sel(control_bits_id[8]),
                     .pc_return(control_bits_id[9]),
                     .jump(control_bits_id[10])
                     );
                     
    Register regfile (.raddr1(instruction_id[19:15]), 
                      .raddr2(instruction_id[24:20]),
                      .waddr(WB_rd),
                      .wdata((WB_muxout)), //control_bits_id[10])?next_pc:
                      .rdata1(rdata1),
                      .rdata2(rdata2),
                      .regwrite(control_bits_id[0]),
                      .clk(clk),
                      .resetn(resetn));
                      
                      
      imm_gen imm_gen(
      .inst(instruction_id[31:0]), 
      .imm(imm)
      );
      
                      
    // Instruction decode 
    logic [138:0] id_ie_out;
    pipeline_reg #(.n(139)) ID_IE (.*,.in_data({rdata2,rdata1,control_bits_id,pc_id,instruction_id}),
                                  .out_data(id_ie_out));
                                  
   // Instruction Execute
   
   
  
   logic [31:0] instruction_ie,pc_ie,rdata1_ie,rdata2_ie,rs1,rs2;
   logic [10:0] control_bits_ie; 
   logic [4:0] EXE_rs1,EXE_rs2, EXE_rd;
   
   assign instruction_ie = id_ie_out[31:0];
   assign EXE_rs1 = instruction_ie[19:15];
   assign EXE_rs2 = instruction_ie[24:20];
   assign EXE_rd = instruction_ie[11:7];
   assign pc_ie = id_ie_out [63:32]; 
   assign control_bits_ie = id_ie_out [74:64];
   assign rdata1_ie =  id_ie_out [106:75] ; 
   assign rdata2_ie =  id_ie_out [138:107] ;  
                                            
      alu_control ALUCTRL( .alu_op(control_bits_ie[5:4]),
                           .fun7(instruction_ie[31:25]),
                           .fun3(instruction_ie[14:12]),
                           .alu_ctrl(alu_ctrl));
    
    always@(*) begin 
        case(forwardA)
            2'b00: rs1 = rdata1_ie;
            2'b01: rs1 = WB_muxout;
            2'b10: rs1 = alu_out_im;
            default: rs1 = rdata1_ie;
            endcase
        case(forwardB)
            2'b00: rs2 = rdata2_ie;
            2'b01: rs2 = WB_muxout;
            2'b10: rs2 = alu_out_im;
            default: rs1 = rdata2_ie; 
            endcase   
            end 
                                          
      ALU ALU_Main (.op1(rs1), //control_bits_ie[7]?pc_ie:
                    .op2(control_bits_ie[3]?imm:rs2),
                    .aluctrl(alu_ctrl),
                    .result(alu_out),
                    .zero(zero));
                    
                    
    // Instructions Execute
    logic [138:0] ie_im_out;
     pipeline_reg #(.n(139)) IE_IM (.*,.in_data({rdata2_ie,alu_out,control_bits_ie,pc_ie,instruction_ie}),
                                  .out_data(ie_im_out));
    // Instruction Memory 
   logic [31:0] instruction_im,pc_im,alu_out_im,rdata2_im;
   logic [10:0] control_bits_im; 
   logic [4:0] MEM_rs1,MEM_rs2,MEM_rd;
   
   assign instruction_im = ie_im_out[31:0];
   assign MEM_rs1 = instruction_im[19:15];
   assign MEM_rs2 = instruction_im[24:20];
   assign MEM_rd = instruction_im[11:7];
   assign pc_im = ie_im_out [63:32]; 
   assign control_bits_im = ie_im_out [74:64];
   assign alu_out_im =  ie_im_out [106:75] ; 
   assign rdata2_im =  ie_im_out [138:107] ;
    
      Data_memory RAM(.clk(clk),
                      .resetn(resetn),
                      .memwrite(control_bits_ie[1]),
                      .addr(alu_out_im),
                      .load_type(instruction_im[14:12]),
                      .wdata(rdata2_im),
                      .rdata_word(romout)
                      );
                      
     // Instructions Memory
    logic [138:0] im_iw_out;
     pipeline_reg #(.n(139)) IM_IW (.*,.in_data({romout,alu_out_im,control_bits_im,pc_im,instruction_im}),
                                  .out_data(im_iw_out));
    // Instruction Write Back       
    
  
   
   assign instruction_iw = im_iw_out[31:0];
   assign WB_rs1 = instruction_iw[19:15];
   assign WB_rs2 = instruction_iw[24:20];
   assign WB_rd = instruction_iw[11:7];
   assign pc_iw = ie_im_out [63:32]; 
   assign control_bits_iw = im_iw_out [74:64];
   assign alu_out_iw =  im_iw_out [106:75] ; 
   assign romout_w =  im_iw_out [138:107] ; 
                     
      Forward_unit FU (.EXE_rs1(EXE_rs1), 
                       .EXE_rs2(EXE_rs2),
                       .MEM_rd(MEM_rd),
                       .WB_rd(WB_rd),
                       .MEM_regwrite(control_bits_im[0]),
                       .WB_regwrite(control_bits_iw[0]),
                       .forwardA(forwardA),
                       .forwardB(forwardB)
                       );
                               
    
       assign WB_muxout = control_bits_iw[2]?romout_w:alu_out_iw;                   
    
endmodule