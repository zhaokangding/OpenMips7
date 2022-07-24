`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/25 01:10:43
// Design Name: 
// Module Name: data_ram
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
`include "define.v"

module data_ram(
    clk    ,
    ce     ,
    we     ,
    addr   ,
    sel    ,
    i_data ,
    o_data 
    );
    input             clk    ;
    input             ce     ;
    input             we     ;
    input      [31:0] addr   ;
    input      [3:0]  sel    ;
    input      [31:0] i_data ;
    output reg [32:0] o_data ;
    
    reg [7:0] data_mem0 [`DataMemNum-1:0];
    reg [7:0] data_mem1 [`DataMemNum-1:0];
    reg [7:0] data_mem2 [`DataMemNum-1:0];
    reg [7:0] data_mem3 [`DataMemNum-1:0];
    
    always @ (posedge clk) begin
        if(ce == 1'b0) begin
            ;
        end
        else if(we == 1'b1) begin
            if(sel[3] == 1'b1) begin
                data_mem3[addr[`DataMemNumLog2+1:2]] <= i_data[31:24];
            end
            if(sel[2] == 1'b1) begin
                data_mem2[addr[`DataMemNumLog2+1:2]] <= i_data[23:16];
            end
            if(sel[1] == 1'b1) begin
                data_mem1[addr[`DataMemNumLog2+1:2]] <= i_data[15:8];
            end
            if(sel[0] == 1'b1) begin
                data_mem0[addr[`DataMemNumLog2+1:2]] <= i_data[7:0];
            end
        end
    end
    always @ (*) begin
        if(ce == 1'b0) begin
            o_data = 32'b0;
        end
        else if(we == 1'b0) begin
            o_data = {data_mem3[addr[`DataMemNumLog2+1:2]],data_mem2[addr[`DataMemNumLog2+1:2]],data_mem1[addr[`DataMemNumLog2+1:2]],data_mem0[addr[`DataMemNumLog2+1:2]]};
        end
        else begin
            o_data = 32'b0;
        end
    end
    
endmodule
