`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 08:44:43
// Design Name: 
// Module Name: ex_mem
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


module ex_mem(
    rst                      ,
    clk                      ,
    ex_wd                    ,
    ex_wreg                  ,
    ex_wdata                 ,
    mem_wd                   ,
    mem_wreg                 ,
    mem_wdata                ,
    stall                    ,
    flush                    ,
    ex_cp0_reg_we            ,
    ex_cp0_reg_write_addr    ,
    ex_cp0_reg_data          ,
    mem_cp0_reg_we           ,
    mem_cp0_reg_write_addr   ,
    mem_cp0_reg_data         ,
    ex_aluop                 ,
    ex_mem_addr              ,
    ex_reg2                  ,
    mem_aluop                ,
    mem_mem_addr             ,
    mem_reg2                 ,
    ex_whilo                 ,
    ex_hi                    ,
    ex_lo                    ,
    mem_whilo                ,
    mem_hi                   ,
    men_lo                   ,
    ex_excepttype            ,
    ex_current_inst_address  ,
    ex_is_in_delayslot       ,
    mem_excepttype           ,
    mem_current_inst_address ,
    mem_is_in_delayslot      ,
    i_hilo                   ,
    i_cnt                    ,
    o_hilo                   ,
    o_cnt          
    );
    input rst                              ;
    input clk                              ;
    input [4:0] ex_wd                      ; 
    input ex_wreg                          ;
    input [31:0] ex_wdata                  ;  
    output reg [4:0] mem_wd                    ;  
    output reg mem_wreg                        ;
    output reg [31:0] mem_wdata                ;   
    input stall                            ;
    input flush                            ;
    input ex_cp0_reg_we                    ;
    input [4:0] ex_cp0_reg_write_addr      ; 
    input [31:0] ex_cp0_reg_data           ;  
    output mem_cp0_reg_we                  ;
    output [4:0] mem_cp0_reg_write_addr    ;  
    output [31:0] mem_cp0_reg_data         ;   
    input [7:0] ex_aluop                   ; 
    input [31:0] ex_mem_addr               ;  
    input [31:0] ex_reg2                   ;  
    output [7:0] mem_aluop                 ;  
    output [31:0] mem_mem_addr             ;   
    output [31:0] mem_reg2                 ;   
    input ex_whilo                         ;
    input [31:0] ex_hi                     ;  
    input [31:0] ex_lo                     ;  
    output mem_whilo                       ;
    output [31:0] mem_hi                   ;   
    output [31:0] men_lo                   ;   
    input [31:0] ex_excepttype             ;  
    input [31:0] ex_current_inst_address   ;  
    input ex_is_in_delayslot               ;
    output [31:0] mem_excepttype           ;
    output [31:0] mem_current_inst_address ;
    output mem_is_in_delayslot             ;
    input [63:0] i_hilo                    ;
    input [1:0] i_cnt                      ;
    output [63:0] o_hilo                   ;
    output [1:0] o_cnt                     ;
    
    always @ (posedge clk, posedge rst) begin
        if(rst) begin
           mem_wd    <= 5'b0;
           mem_wreg  <= 1'b0;
           mem_wdata <= 32'b0; 
        end
        else begin
           mem_wd    <= ex_wd;   
           mem_wreg  <= ex_wreg;
           mem_wdata <= ex_wdata;
        end
    end
    
    
    
endmodule
 