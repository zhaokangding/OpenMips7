`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 11:14:16
// Design Name: 
// Module Name: inst_rom
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
module inst_rom(
    ce   ,
    addr ,
    inst
    );
    input             ce   ;
    input      [31:0] addr ;
    output reg [31:0] inst ;
    
    //define the instructions rom
    reg [31:0] inst_mem [`InstMemNum-1:0];
    
    //face to sim initial
    initial $readmemb ("C:\\Xilinx\\produces\\Machinecode\\data3.data", inst_mem);
    
    always @ (*) begin
        if(ce == 1'b0) begin
            inst = 32'h00000000;
        end 
        else begin
            inst = inst_mem [addr[`InstMemNumLog2+1:2]];
        end
    end
    
endmodule
