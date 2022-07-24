`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 11:42:48
// Design Name: 
// Module Name: inst_tb
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


module inst_tb(

    );
    reg ce;
    reg [31:0] addr;
    wire [31:0] inst;
    initial begin
        ce = 1'b1;
        addr = 32'h00000000;
    end
    always # 10 addr = addr + 4;
    inst_rom uut0(
    .ce   (ce),
    .addr (addr),
    .inst (inst)
    );
endmodule
