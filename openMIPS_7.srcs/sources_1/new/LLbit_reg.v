`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 10:27:24
// Design Name: 
// Module Name: LLbit_reg
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


module LLbit_reg(
    rst     ,
    clk     ,
    flush   ,
    we      ,
    i_LLbit ,
    o_LLbit 
    );
    input      rst     ;
    input      clk     ;
    input      flush   ;
    input      we      ;
    input      i_LLbit ;
    output reg o_LLbit ; 
    always @ (posedge clk) begin
        if(rst) begin
            o_LLbit = 1'b0;
        end
        else if(flush) begin
            o_LLbit = 1'b0;
        end
        else if(we) begin
            o_LLbit = i_LLbit;
        end
    end
endmodule
