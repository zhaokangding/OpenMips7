`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 08:09:07
// Design Name: 
// Module Name: regnop1_regnop2
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


module regnop1_regnop2(
    rst                       ,
    clk                       ,
    nop1_wd                   ,
    nop1_wreg                 ,
    nop1_wdata                ,
    nop2_wd                   ,
    nop2_wreg                 ,
    nop2_wdata                ,
    stall                     ,
    flush                     ,
    nop1_cp0_reg_we           ,
    nop1_cp0_reg_write_addr   ,
    nop1_cp0_reg_data         ,
    nop2_cp0_reg_we           ,
    nop2_cp0_reg_write_addr   ,
    nop2_cp0_reg_data         ,
    nop1_aluop                ,
    nop1_mem_addr             ,
    nop1_reg2                 ,
    nop2_aluop                ,
    nop2_mem_addr             ,
    nop2_reg2                 ,
    nop1_whilo                ,
    nop1_hi                   ,
    nop1_lo                   ,
    nop2_whilo                ,
    nop2_hi                   ,
    nop2_lo                   ,
    nop1_excepttype           ,
    nop1_current_inst_address ,
    nop1_is_in_delayslot      ,
    nop2_excepttype           ,
    nop2_current_inst_address ,
    nop2_is_in_delayslot          
    );
    input             rst                       ;
    input             clk                       ;
    input      [4:0]  nop1_wd                   ;
    input             nop1_wreg                 ;
    input      [31:0] nop1_wdata                ;
    output reg [4:0]  nop2_wd                   ;
    output reg        nop2_wreg                 ;
    output reg [31:0] nop2_wdata                ;
    input      [7:0]  stall                     ;
    input             flush                     ;
    input             nop1_cp0_reg_we           ;
    input      [4:0]  nop1_cp0_reg_write_addr   ;
    input      [31:0] nop1_cp0_reg_data         ;
    output reg        nop2_cp0_reg_we           ;
    output reg [4:0]  nop2_cp0_reg_write_addr   ;
    output reg [31:0] nop2_cp0_reg_data         ;
    input      [7:0]  nop1_aluop                ;
    input      [31:0] nop1_mem_addr             ;
    input      [31:0] nop1_reg2                 ;
    output reg [7:0]  nop2_aluop                ;
    output reg [31:0] nop2_mem_addr             ;
    output reg [31:0] nop2_reg2                 ;
    input             nop1_whilo                ;
    input      [31:0] nop1_hi                   ;
    input      [31:0] nop1_lo                   ;
    output reg        nop2_whilo                ;
    output reg [31:0] nop2_hi                   ;
    output reg [31:0] nop2_lo                   ;
    input      [31:0] nop1_excepttype           ;
    input      [31:0] nop1_current_inst_address ;
    input             nop1_is_in_delayslot      ;
    output reg [31:0] nop2_excepttype           ;
    output reg [31:0] nop2_current_inst_address ;
    output reg        nop2_is_in_delayslot      ;
    
    always @ (posedge clk, posedge rst) begin
        if(rst) begin
            nop2_wd    <= 5'b0;
            nop2_wreg  <= 1'b0;
            nop2_wdata <= 32'b0;
            nop2_whilo <= 1'b0;   
            nop2_hi    <= 32'b0;  
            nop2_lo    <= 32'b0;
            nop2_aluop    <= 8'b0;
            nop2_mem_addr <= 32'b0;
            nop2_reg2     <= 32'b0;  
            nop2_cp0_reg_we         <= 1'b0;
            nop2_cp0_reg_write_addr <= 5'b0;
            nop2_cp0_reg_data       <= 32'b0;
            nop2_excepttype           <= 32'b0;
            nop2_current_inst_address <= 32'b0;
            nop2_is_in_delayslot      <= 1'b0;
             
        end
        else if(flush == 1'b1) begin
            nop2_wd    <= 5'b0;
            nop2_wreg  <= 1'b0;
            nop2_wdata <= 32'b0;
            nop2_whilo <= 1'b0;   
            nop2_hi    <= 32'b0;  
            nop2_lo    <= 32'b0;
            nop2_aluop    <= 8'b0;
            nop2_mem_addr <= 32'b0;
            nop2_reg2     <= 32'b0; 
            nop2_cp0_reg_we         <= 1'b0;
            nop2_cp0_reg_write_addr <= 5'b0;
            nop2_cp0_reg_data       <= 32'b0;
            nop2_excepttype           <= 32'b0;
            nop2_current_inst_address <= 32'b0;
            nop2_is_in_delayslot      <= 1'b0;
                 
        end
        else if(stall[4]==1'b1 & stall[5] == 1'b0) begin
            nop2_wd    <= 5'b0;
            nop2_wreg  <= 1'b0;
            nop2_wdata <= 32'b0;
            nop2_whilo <= 1'b0;   
            nop2_hi    <= 32'b0;  
            nop2_lo    <= 32'b0;
            nop2_aluop    <= 8'b0;
            nop2_mem_addr <= 32'b0;
            nop2_reg2     <= 32'b0; 
            nop2_cp0_reg_we         <= 1'b0;
            nop2_cp0_reg_write_addr <= 5'b0;
            nop2_cp0_reg_data       <= 32'b0;
            nop2_excepttype           <= 32'b0;
            nop2_current_inst_address <= 32'b0;
            nop2_is_in_delayslot      <= 1'b0;
         
        end
        else if(stall[4]==1'b0) begin
            nop2_wd    <= nop1_wd;   
            nop2_wreg  <= nop1_wreg;
            nop2_wdata <= nop1_wdata;
            nop2_whilo <= nop1_whilo;
            nop2_hi    <= nop1_hi   ;
            nop2_lo    <= nop1_lo   ;
            nop2_aluop    <= nop1_aluop;
            nop2_mem_addr <= nop1_mem_addr;
            nop2_reg2     <= nop1_reg2; 
            nop2_cp0_reg_we         <= nop1_cp0_reg_we        ;
            nop2_cp0_reg_write_addr <= nop1_cp0_reg_write_addr;
            nop2_cp0_reg_data       <= nop1_cp0_reg_data      ;
            nop2_excepttype           <= nop1_excepttype          ;
            nop2_current_inst_address <= nop1_current_inst_address;
            nop2_is_in_delayslot      <= nop1_is_in_delayslot     ;
         
        end
    end
    
    
    
endmodule

