//`timescale 1ns / 1ps

//module immediate_gen(
//    input logic [31:0]inst,
//    output logic [31:0] imm
//    );
    
//    always@(*) begin
//    case (inst[6:0]) 
//         7'b0010011: imm = { {20{inst[31]}}, inst[31:20] }; // I-type
//         7'b0000011: imm = { {20{inst[31]}}, inst[31:20] }; // I-type
//         7'b0100011: imm = { {20{inst[31]}}, inst[31:25], inst[11:7] }; // S-type
//         7'b1100011: imm = { {20{inst[31]}},  inst[31:25], inst[11:7]}; // B-type
//         7'b0110111: imm = { inst[31:12], {12{1'b0}}}; // u-type
//         7'b0010111: imm = { inst[31:12], {12{1'b0}}}; // u-type
////         7'b1101111: imm = { {20{inst[31]}},inst[19:12],inst[20],inst[30:21] };
//         default: imm = { {20{inst[31]}}, inst[31:20] }; // Default case for unsupported instructions
//        endcase 
//    end
//endmodule


`timescale 1ns / 1ps

module imm_gen(
    input logic [31:0] inst,
    output logic [31:0] imm
    );
    
    always_comb begin
        case (inst[6:0])
            7'b0010011: imm = { {20{inst[31]}}, inst[31:20] };             // I-type
            7'b0000011: imm = { {20{inst[31]}}, inst[31:20] };             // I-type
            7'b0100011: imm = { {20{inst[31]}}, inst[31:25], inst[11:7] }; // S-type
            7'b1100011: imm = { {19{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0 }; // B-type
            7'b0110111: imm = {inst[31:12], 12'b0};                        // U-type (LUI)
            7'b0010111: imm = {inst[31:12], 12'b0};                        // U-type (AUIPC)
            7'b1101111: imm = { {12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0 }; // J-type
            default: imm = 32'b0;                                          // Default case for unsupported instructions
        endcase
    end
    
endmodule
