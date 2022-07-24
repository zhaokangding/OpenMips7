`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/12 16:26:55
// Design Name: 
// Module Name: if_id
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


module if_id(
    rst     ,
    clk     ,
    if_pc   ,
    if_inst ,
    stall   ,
    flush   ,
    id_pc   ,
    id_inst
    );
    input             rst     ;
    input             clk     ;
    input      [31:0] if_pc   ;
    input      [31:0] if_inst ;
    input      [7:0]  stall   ;
    input             flush   ;
    output reg [31:0] id_pc   ;
    output reg [31:0] id_inst ;
    
    always @ (posedge clk, posedge rst) begin
        if(rst) begin
            id_pc   <= 32'h0000_0000;
            id_inst <= 32'h0000_0000;
        end
        else if(flush == 1'b1) begin
            id_pc   <= 32'b0;
            id_inst <= 32'b0;
        end
        else if(stall[1]==1'b1 & stall[2] == 1'b0) begin
            id_pc   <= 32'h0000_0000;
            id_inst <= 32'h0000_0000;
        end
        else if(stall[1]==1'b0) begin
            id_pc   <= if_pc;
            id_inst <= if_inst;
        end
    end
endmodule
