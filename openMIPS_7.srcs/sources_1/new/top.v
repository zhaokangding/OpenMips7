`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/18 07:54:57
// Design Name: 
// Module Name: top
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


module openmi(
    clk         ,
    rst         ,
    i_rom_data  ,
    o_rom_ce    ,
    o_rom_addr  
    );
    input clk                ;
    input rst                ;
    
    input [31:0] i_rom_data  ;
    output [31:0] o_rom_ce   ;
    output [31:0] o_rom_addr ;
    
    pc_reg pc_reg0(
    .rst                     (rst),
    .clk                     (clk),
    .i_branch_flag           (0),
    .i_branch_target_address (0),
    .flush                   (0),
    .new_pc                  (0),
    .stall                   (0),
    .pc                      (o_rom_addr),
    .ce                      (o_rom_ce)
    );
     
    wire [31:0] id_pc;
    wire [31:0] id_inst;
    
    if_id if_id0(
    .rst     (rst),
    .clk     (rst),
    .if_pc   (o_rom_addr),
    .if_inst (i_rom_data),
    .stall   (0),
    .flush   (0),
    .id_pc   (id_pc),
    .id_inst (id_inst)
    );
endmodule
