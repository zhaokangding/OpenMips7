`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/11 11:42:13
// Design Name: 
// Module Name: pc_reg
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


module pc_reg(
    rst                     ,
    clk                     ,
    i_branch_flag           ,
    i_branch_target_address ,
    flush                   ,
    new_pc                  ,
    stall                   ,
    pc                      ,
    ce
    );
    input             rst                     ;
    input             clk                     ;
    input             i_branch_flag           ;
    input      [31:0] i_branch_target_address ; //
    input             flush                   ; //
    input      [31:0] new_pc                  ; //
    input      [7:0]  stall                   ; //
    output reg [31:0] pc                      ;
    output reg        ce                      ;
    
    always @ (posedge clk, posedge rst) begin
        if(rst) begin
            ce <= 1'b0;
        end
        else begin
            ce <= 1'b1;
        end
    end
    always @ (posedge clk, posedge rst) begin
        if(rst) begin
            pc <= 32'h30000000;
        end
        else if(flush == 1'b1) begin
            pc <= new_pc;
        end
        else if(ce & stall[0]==1'b0) begin
            if(i_branch_flag == 1'b1) begin
                pc <= i_branch_target_address;
            end
            else begin
                pc <= pc + 4;
            end
        end
    end
    
endmodule
