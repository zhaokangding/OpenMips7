`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/01 19:12:30
// Design Name: 
// Module Name: qw
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


module qw(
    input clk,
    input rst,
    output reg [1:0] a
    );
    always @ (posedge clk ,posedge rst) begin
        if(rst) begin
            a <= 2'b0;
        end
        else begin
            a <= a + 1;
            a <= a + 2;
        end
        
    end
    
    
//    assign b = a;
//    assign b = a + 1;
endmodule
