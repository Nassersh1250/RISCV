`timescale 1ns / 1ps

module Data_memory(
    input logic clk,resetn,memwrite,
    input logic [31:0]addr, 
    input logic [2:0] load_type,
    input reg [31:0]wdata,
    output reg [31:0] rdata_word
    );
    
    reg [31:0] dmem[0:1023];
    
    always@(*) begin
   if (memwrite == 0) begin
        case (load_type[2:0])
        3'b010:rdata_word = dmem[{addr[31:2], 2'b00}]; // load word
        3'b001: begin                // load half word
            case (addr[1])
                1'b0: rdata_word = dmem[{addr[31:2], 2'b00}][15:0];
                1'b1: rdata_word = dmem[{addr[31:2], 2'b00}][31:16];
                endcase
                end
        3'b000: begin                // load byte 
            case (addr[1:0])
                2'b00: rdata_word = dmem[{addr[31:2], 2'b00}][7:0];
                2'b01: rdata_word = dmem[{addr[31:2], 2'b00}][15:8];
                2'b10: rdata_word = dmem[{addr[31:2], 2'b00}][23:16];
                2'b11: rdata_word = dmem[{addr[31:2], 2'b00}][31:24];
                endcase
                end
         endcase
        end
         
    end
    
    always@(posedge clk or negedge resetn) begin
        if (!resetn) begin 
            dmem = '{default: 32'b0};
            wdata = 0;
            rdata_word = 0;
            
        end
        
        else if (memwrite == 1)
            case (load_type[2:0])
                3'b010: dmem[{addr[31:2], 2'b00}] = wdata; // store word
                3'b001: begin            // store half word
                    case (addr[1])
                        1'b0: dmem[{addr[31:2], 2'b00}][15:0] = wdata[15:0];
                        1'b1: dmem[{addr[31:2], 2'b00}][31:16] = wdata[15:0];
                        endcase
                        end
                3'b000: begin            // store byte
                    case (addr[1:0])
                        2'b00: dmem[{addr[31:2], 2'b00}][7:0] = wdata[7:0];
                        2'b01: dmem[{addr[31:2], 2'b00}][15:8] = wdata[7:0];
                        2'b10: dmem[{addr[31:2], 2'b00}][23:16] = wdata[7:0];
                        2'b11: dmem[{addr[31:2], 2'b00}][31:24] = wdata[7:0];
                        endcase
                        end
               endcase
     end
endmodule
