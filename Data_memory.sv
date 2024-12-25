`timescale 1ns / 1ps

module Data_memory(
    input logic clk,resetn,memwrite,
    input logic [31:0]addr, 
    input logic [1:0] load_type,
    input logic [1:0] store_type,
    input reg [31:0]wdata,
    output reg [31:0] rdata_word,
    output reg [15:0] rdata_half,
    output reg [7:0] rdata_byte
    );
    
    reg [31:0] dmem[0:1023];
    
    always@(*) begin
        case (load_type)
        2'b00:rdata_word = dmem[addr[31:2]]; // load word
        2'b01: begin                // load half word
            case (addr[1])
                1'b0: rdata_word = dmem[addr[31:2]][15:0];
                1'b1: rdata_word = dmem[addr[31:2]][31:16];
                endcase
                end
        2'b10: begin                // load byte 
            case (addr[1:0])
                2'b00: rdata_word = dmem[addr[31:2]][7:0];
                2'b01: rdata_word = dmem[addr[31:2]][15:8];
                2'b10: rdata_word = dmem[addr[31:2]][23:16];
                2'b11: rdata_word = dmem[addr[31:2]][31:24];
                endcase
                end
         endcase
    end
    
    always@(posedge clk or negedge resetn) begin
        if (!resetn) begin 
            dmem = {0};
            wdata = 0;
            rdata_word = 0;
            rdata_half = 0;
            rdata_byte = 0;
            
        end
        
        else if (memwrite == 1)
            case (store_type)
                2'b00: dmem[addr[31:2]] = wdata; // store word
                2'b01: begin            // store half word
                    case (addr[1])
                        1'b0: dmem[addr[31:2]][15:0] = wdata[15:0];
                        1'b1: dmem[addr[31:2]][31:16] = wdata[15:0];
                        endcase
                        end
                2'b10: begin            // store byte
                    case (addr[1:0])
                        2'b00: dmem[addr[31:2]][7:0] = wdata[7:0];
                        2'b01: dmem[addr[31:2]][15:8] = wdata[7:0];
                        2'b10: dmem[addr[31:2]][23:16] = wdata[7:0];
                        2'b11: dmem[addr[31:2]][31:24] = wdata[7:0];
                        endcase
                        end
               endcase
     end
endmodule
