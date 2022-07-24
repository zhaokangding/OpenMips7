`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/03 08:01:50
// Design Name: 
// Module Name: qwtest_tb
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


module qwtest_tb(

    );
    reg [2:0] a;
    wire [2:0] b;
    qw qw0(
    .a(a),
    .b(b)
    );
    initial begin
        a = 0;
    end
    always #5 a = a + 1;
endmodule
