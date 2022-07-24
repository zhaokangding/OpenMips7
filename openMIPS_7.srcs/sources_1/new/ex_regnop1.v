`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 08:05:45
// Design Name: 
// Module Name: ex_regnop1
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


module ex_regnop1(
    rst                       ,
    clk                       ,
    ex_wd                     ,
    ex_wreg                   ,
    ex_wdata                  ,
    nop1_wd                   ,
    nop1_wreg                 ,
    nop1_wdata                ,
    stall                     ,
    flush                     ,
    ex_cp0_reg_we             ,
    ex_cp0_reg_write_addr     ,
    ex_cp0_reg_data           ,
    nop1_cp0_reg_we           ,
    nop1_cp0_reg_write_addr   ,
    nop1_cp0_reg_data         ,
    ex_aluop                  ,
    ex_mem_addr               ,
    ex_reg2                   ,
    nop1_aluop                ,
    nop1_mem_addr             ,
    nop1_reg2                 ,
    ex_whilo                  ,
    ex_hi                     ,
    ex_lo                     ,
    nop1_whilo                ,
    nop1_hi                   ,
    nop1_lo                   ,
    ex_excepttype             ,
    ex_current_inst_address   ,
    ex_is_in_delayslot        ,
    nop1_excepttype           ,
    nop1_current_inst_address ,
    nop1_is_in_delayslot      ,
    i_hilo                    ,
    i_cnt                     ,
    o_hilo                    ,
    o_cnt          
    );
    input             rst                       ;
    input             clk                       ;
    input      [4:0]  ex_wd                     ; 
    input             ex_wreg                   ;
    input      [31:0] ex_wdata                  ;  
    output reg [4:0]  nop1_wd                   ;  
    output reg        nop1_wreg                 ;
    output reg [31:0] nop1_wdata                ;   
    input      [7:0]  stall                     ;
    input             flush                     ;
    input             ex_cp0_reg_we             ;
    input      [4:0]  ex_cp0_reg_write_addr     ; 
    input      [31:0] ex_cp0_reg_data           ;  
    output reg        nop1_cp0_reg_we           ;
    output reg [4:0]  nop1_cp0_reg_write_addr   ;  
    output reg [31:0] nop1_cp0_reg_data         ;   
    input      [7:0]  ex_aluop                  ; 
    input      [31:0] ex_mem_addr               ;  
    input      [31:0] ex_reg2                   ;  
    output reg [7:0]  nop1_aluop                ;  
    output reg [31:0] nop1_mem_addr             ;   
    output reg [31:0] nop1_reg2                 ;   
    input             ex_whilo                  ;
    input      [31:0] ex_hi                     ;  
    input      [31:0] ex_lo                     ;  
    output reg        nop1_whilo                ;
    output reg [31:0] nop1_hi                   ;   
    output reg [31:0] nop1_lo                   ;   
    input      [31:0] ex_excepttype             ;  
    input      [31:0] ex_current_inst_address   ;  
    input             ex_is_in_delayslot        ;
    output reg [31:0] nop1_excepttype           ;
    output reg [31:0] nop1_current_inst_address ;
    output reg        nop1_is_in_delayslot      ;
    input      [63:0] i_hilo                    ;
    input      [1:0]  i_cnt                     ;
    output reg [63:0] o_hilo                    ;
    output reg [1:0]  o_cnt                     ;
    
    always @ (posedge clk, posedge rst) begin
        if(rst) begin
            nop1_wd    <= 5'b0;
            nop1_wreg  <= 1'b0;
            nop1_wdata <= 32'b0; 
            nop1_whilo <= 1'b0;
            nop1_hi    <= 32'b0;
            nop1_lo    <= 32'b0;
            o_hilo     <= {32'b0,32'b0};
            o_cnt      <= 2'b00;
            nop1_aluop    <= 8'b0;
            nop1_mem_addr <= 32'b0;
            nop1_reg2     <= 32'b0;
            nop1_cp0_reg_we         <= 1'b0;
            nop1_cp0_reg_write_addr <= 5'b0;
            nop1_cp0_reg_data       <= 32'b0;
            nop1_excepttype           <= 32'b0;
            nop1_current_inst_address <= 32'b0;
            nop1_is_in_delayslot      <= 1'b0;
        end
        else if(flush == 1'b1) begin
            nop1_wd    <= 5'b0;
            nop1_wreg  <= 1'b0;
            nop1_wdata <= 32'b0; 
            nop1_whilo <= 1'b0;
            nop1_hi    <= 32'b0;
            nop1_lo    <= 32'b0;
            o_hilo     <= {32'b0,32'b0};
            o_cnt      <= 2'b00;
            nop1_aluop    <= 8'b0;
            nop1_mem_addr <= 32'b0;
            nop1_reg2     <= 32'b0;
            nop1_cp0_reg_we         <= 1'b0;
            nop1_cp0_reg_write_addr <= 5'b0;
            nop1_cp0_reg_data       <= 32'b0;
            nop1_excepttype           <= 32'b0;
            nop1_current_inst_address <= 32'b0;
            nop1_is_in_delayslot      <= 1'b0;
        end
        else if(stall[3]==1'b1 & stall[4] == 1'b0) begin
            nop1_wd    <= 5'b0;
            nop1_wreg  <= 1'b0;
            nop1_wdata <= 32'b0; 
            nop1_whilo <= 1'b0;
            nop1_hi    <= 32'b0;
            nop1_lo    <= 32'b0;
            nop1_cp0_reg_we         <= 1'b0;
            nop1_cp0_reg_write_addr <= 5'b0;
            nop1_cp0_reg_data       <= 32'b0;
            
            o_hilo     <= i_hilo;
            o_cnt      <= i_cnt;
            
            nop1_aluop    <= 8'b0;
            nop1_mem_addr <= 32'b0;
            nop1_reg2     <= 32'b0;
            nop1_excepttype           <= 1'b0; 
            nop1_current_inst_address <= 5'b0; 
            nop1_is_in_delayslot      <= 32'b0;
        end
        else if(stall[3]==1'b0) begin
            nop1_wd    <= ex_wd;   
            nop1_wreg  <= ex_wreg;
            nop1_wdata <= ex_wdata;
            nop1_whilo <= ex_whilo;
            nop1_hi    <= ex_hi   ;
            nop1_lo    <= ex_lo   ;
            nop1_cp0_reg_we         <= ex_cp0_reg_we        ;
            nop1_cp0_reg_write_addr <= ex_cp0_reg_write_addr;
            nop1_cp0_reg_data       <= ex_cp0_reg_data      ;
            o_hilo     <= {32'b0,32'b0};
            o_cnt      <= 2'b00;
            
            nop1_aluop    <= ex_aluop;
            nop1_mem_addr <= ex_mem_addr;
            nop1_reg2     <= ex_reg2;
            nop1_excepttype           <= ex_excepttype          ;
            nop1_current_inst_address <= ex_current_inst_address;
            nop1_is_in_delayslot      <= ex_is_in_delayslot     ;
        
           
           
        end
        else begin
            o_hilo     <= i_hilo;
            o_cnt      <= i_cnt;
        end
    end
    
    
    
endmodule
