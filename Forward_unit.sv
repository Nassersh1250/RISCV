`timescale 1ns / 1ps

module Forward_unit(
    input  [4:0] EXE_rs1,EXE_rs2,
    input  [4:0] MEM_rd, WB_rd,
    input  MEM_regwrite, WB_regwrite,
    output logic [1:0] forwardA,forwardB
    );
    
    
    always@(*) begin 
        if (MEM_regwrite && (MEM_rd!=0) && (MEM_rd == EXE_rs1)) forwardA = 10;
        if (MEM_regwrite && (MEM_rd!=0) && (MEM_rd == EXE_rs2)) forwardB = 10;
        
        if (WB_regwrite && (WB_rd!=0) && !(MEM_regwrite && (MEM_rd!=0) && (MEM_rd == EXE_rs1))&& (WB_rd == EXE_rs1))
            forwardA = 01;
        if (WB_regwrite && (WB_rd!=0) && !(MEM_regwrite && (MEM_rd!=0) && (MEM_rd == EXE_rs2))&& (WB_rd == EXE_rs2))
            forwardB = 01;
            
        else begin
            forwardA = 0;
            forwardB = 0;
            end
        end    
            
endmodule
