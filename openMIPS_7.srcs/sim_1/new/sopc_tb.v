`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/18 09:04:16
// Design Name: 
// Module Name: sopc_tb
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


module sopc_tb(

    );
    reg clk;
    reg rst;
    openmips_min_sopc openmips_min_sopc0(
    .clk(clk),
    .rst(rst)
    );
    
    
    initial begin
        clk = 0;
        rst = 0;
        #3 rst = 1;
        #3 rst = 0;
    end
    always #50 clk = ~clk ;
endmodule
