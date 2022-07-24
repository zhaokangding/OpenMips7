`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 00:36:32
// Design Name: 
// Module Name: regfile
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


module regfile(
    rst    ,
    clk    ,
    waddr  ,
    wdata  ,
    we     ,
    raddr1 ,
    re1    ,
    rdata1 ,
    raddr2 ,
    re2    ,
    rdata2 
    );
    input             rst    ;
    input             clk    ;
    input      [4:0]  waddr  ;
    input      [31:0] wdata  ;
    input             we     ;
    input      [4:0]  raddr1 ;
    input             re1    ;
    output reg [31:0] rdata1 ;
    input      [4:0]  raddr2 ;
    input             re2    ;
    output reg [31:0] rdata2 ;
    
    reg  [31:0] regs [31:0];
    always @ (posedge clk, posedge rst) begin
        if(rst) regs[5'b00000] <= 0;
        else begin
            if(we & (waddr != 5'b00000)) regs[waddr] <= wdata;
        end
    end
    always @ (*) begin
        if(~re1) begin
            rdata1 = 32'h0000_0000;
        end
        else if(rst) begin
            rdata1 = 32'h0000_0000;
        end
        else if(raddr1 == 5'b00000) begin
            rdata1 = 32'h0000_0000;
        end
        else if(raddr1 == waddr & we == 1) begin
            rdata1 = wdata;
        end
        else begin
            rdata1 = regs[raddr1];
        end
    end
    always @ (*) begin
        if(~re2) begin
            rdata2 = 32'h0000_0000;
        end
        else if(rst) begin
            rdata2 = 32'h0000_0000;
        end
        else if(raddr2 == 5'b00000) begin
            rdata2 = 32'h0000_0000;
        end
        else if(raddr2 == waddr & we == 1) begin
            rdata2 = wdata;
        end
        else begin
            rdata2 = regs[raddr2];
        end
    end
endmodule
