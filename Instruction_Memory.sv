`timescale 1ns / 1ps

module Instruction_Memory(
    input logic [31:0]address,
    output logic [31:0]instruction
    );


    logic [31:0] memory[0:255];
    
   initial $readmemh("/home/it/Desktop/CX204/Lab6/machine.hex",memory);
   always@(*) begin
    instruction = memory[address];
   end
   
   endmodule