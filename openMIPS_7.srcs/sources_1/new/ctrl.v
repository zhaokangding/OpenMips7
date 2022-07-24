`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 10:32:41
// Design Name: 
// Module Name: ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


 module ctrl(
    rst               ,
    stallreq_from_if  ,
    stallreq_from_id  ,
    stallreq_from_ex  ,
    stallreq_from_mem ,
    stall             ,
    i_cp0_epc         ,
    i_excepttype      ,
    new_pc            ,
    flush            
    );
    input             rst               ;
    input             stallreq_from_if  ;
    input             stallreq_from_id  ;
    input             stallreq_from_ex  ;
    input             stallreq_from_mem ;
    output reg [7:0]  stall             ;
    input      [31:0] i_cp0_epc         ;
    input      [31:0] i_excepttype      ;
    output reg [31:0] new_pc            ;
    output reg        flush             ;
    
    always @ (*) begin
        if(rst) begin
            stall = 8'b0000_0000;
            flush = 1'b0;
            new_pc = 32'b0;
        end
        else if(i_excepttype != 32'b0) begin
            flush = 1'b1;
            stall = 8'b00000000;
            case(i_excepttype)
            32'h00000001: 
                begin
                    new_pc = 32'h00000020;
                end
            32'h00000008: 
                begin
                    new_pc = 32'h00000040;
                end
            32'h0000000a: 
                begin
                    new_pc = 32'h00000040;
                end
            32'h0000000d: 
                begin
                    new_pc = 32'h00000040;
                end
            32'h0000000c: 
                begin
                    new_pc = 32'h00000040;
                end
            32'h0000000e: 
                begin
                    new_pc = i_cp0_epc;
                end
            default:
                begin
                end
            endcase
        end
        else if(stallreq_from_mem) begin
            stall = 8'b0111_1111;
            flush = 1'b0;
        end
        
        else if(stallreq_from_ex) begin
            stall = 8'b0000_1111;
            flush = 1'b0;
        end
        else if(stallreq_from_id) begin
            stall = 8'b0000_0111;
            flush = 1'b0;
        end
        else if(stallreq_from_if) begin
            stall = 8'b0000_0111;
            flush = 1'b0;
        end
        else begin
            stall = 8'b0000_0000;
            flush = 1'b0;
        end
    end
endmodule
