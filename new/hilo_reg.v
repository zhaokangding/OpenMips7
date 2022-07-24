`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 10:29:06
// Design Name: 
// Module Name: hilo_reg
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


module hilo_reg(
    rst  ,
    clk  ,
    we   ,
    i_hi ,
    i_lo ,
    o_hi ,
    o_lo 
    );
    input             rst  ;
    input             clk  ;
    input             we   ;
    input      [31:0] i_hi ;
    input      [31:0] i_lo ;
    output reg [31:0] o_hi ;
    output reg [31:0] o_lo ;
    
    always @ (posedge clk, posedge rst) begin
        if(rst) begin
            o_hi <= 32'b0;
            o_lo <= 32'b0;
        end
        else if(we) begin
            o_hi <= i_hi;
            o_lo <= i_lo;
        end
    end
    
    
endmodule
