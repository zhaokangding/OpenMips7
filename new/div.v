`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 08:40:33
// Design Name: 
// Module Name: div
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


module div(
    rst          ,
    clk          ,
    i_signed_div ,
    i_opdata1    ,
    i_opdata2    ,
    i_start      ,
    i_annul      ,
    o_result     ,
    o_ready      
    );   
    input rst              ;              
    input clk              ;              
    input i_signed_div     ;     
    input [31:0] i_opdata1 ;        
    input [31:0] i_opdata2 ;        
    input i_start          ;          
    input i_annul          ;          
    output [63:0] o_result ;         
    output o_ready         ;          
            
endmodule
