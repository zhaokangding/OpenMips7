`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 08:10:57
// Design Name: 
// Module Name: regnop2_mem
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


module regnop2_mem(
    rst                       ,
    clk                       ,
    nop2_wd                   ,
    nop2_wreg                 ,
    nop2_wdata                ,
    mem_wd                    ,
    mem_wreg                  ,
    mem_wdata                 ,
    stall                     ,
    flush                     ,
    nop2_cp0_reg_we           ,
    nop2_cp0_reg_write_addr   ,
    nop2_cp0_reg_data         ,
    mem_cp0_reg_we            ,
    mem_cp0_reg_write_addr    ,
    mem_cp0_reg_data          ,
    nop2_aluop                ,
    nop2_mem_addr             ,
    nop2_reg2                 ,
    mem_aluop                 ,
    mem_mem_addr              ,
    mem_reg2                  ,
    nop2_whilo                ,
    nop2_hi                   ,
    nop2_lo                   ,
    mem_whilo                 ,
    mem_hi                    ,
    mem_lo                    ,
    nop2_excepttype           ,
    nop2_current_inst_address ,
    nop2_is_in_delayslot      ,
    mem_excepttype            ,
    mem_current_inst_address  ,
    mem_is_in_delayslot                
    );
    input             rst                       ;              
    input             clk                       ;              
    input      [4:0]  nop2_wd                   ;        
    input             nop2_wreg                 ;              
    input      [31:0] nop2_wdata                ;       
    output reg [4:0]  mem_wd                    ;   
    output reg        mem_wreg                  ;         
    output reg [31:0] mem_wdata                 ;  
    input      [7:0]  stall                     ;        
    input             flush                     ;              
    input             nop2_cp0_reg_we           ;       
    input      [4:0]  nop2_cp0_reg_write_addr   ;       
    input      [31:0] nop2_cp0_reg_data         ;       
    output reg        mem_cp0_reg_we            ;  
    output reg [4:0]  mem_cp0_reg_write_addr    ;  
    output reg [31:0] mem_cp0_reg_data          ;  
    input      [7:0]  nop2_aluop                ;       
    input      [31:0] nop2_mem_addr             ;       
    input      [31:0] nop2_reg2                 ;       
    output reg [7:0]  mem_aluop                 ;  
    output reg [31:0] mem_mem_addr              ;  
    output reg [31:0] mem_reg2                  ;  
    input             nop2_whilo                ;              
    input      [31:0] nop2_hi                   ;       
    input      [31:0] nop2_lo                   ;       
    output reg        mem_whilo                 ;         
    output reg [31:0] mem_hi                    ;  
    output reg [31:0] mem_lo                    ;  
    input      [31:0] nop2_excepttype           ;       
    input      [31:0] nop2_current_inst_address ;       
    input             nop2_is_in_delayslot      ;       
    output reg [31:0] mem_excepttype            ;  
    output reg [31:0] mem_current_inst_address  ;  
    output reg        mem_is_in_delayslot       ;  
         
    
    always @ (posedge clk, posedge rst) begin
        if(rst) begin
            mem_wd    <= 5'b0;
            mem_wreg  <= 1'b0;
            mem_wdata <= 32'b0; 
            mem_whilo <= 1'b0; 
            mem_hi    <= 32'b0;
            mem_lo    <= 32'b0;
            mem_aluop   <= 8'b0;
            mem_mem_addr<= 32'b0;
            mem_reg2    <= 32'b0;
            mem_cp0_reg_we         <= 1'b0;
            mem_cp0_reg_write_addr <= 5'b0;
            mem_cp0_reg_data       <= 32'b0;
            mem_excepttype           <= 32'b0;
            mem_current_inst_address <= 32'b0;
            mem_is_in_delayslot      <= 1'b0;
           
           
        end
        else if(flush == 1'b1) begin
            mem_wd    <= 5'b0;
            mem_wreg  <= 1'b0;
            mem_wdata <= 32'b0; 
            mem_whilo <= 1'b0; 
            mem_hi    <= 32'b0;
            mem_lo    <= 32'b0;
            mem_aluop   <= 8'b0;
            mem_mem_addr<= 32'b0;
            mem_reg2    <= 32'b0; 
            mem_cp0_reg_we         <= 1'b0;
            mem_cp0_reg_write_addr <= 5'b0;
            mem_cp0_reg_data       <= 32'b0;
            mem_excepttype           <= 32'b0;
            mem_current_inst_address <= 32'b0;
            mem_is_in_delayslot      <= 1'b0;
        end
        else if(stall[5]==1'b1 & stall[6] == 1'b0) begin
            mem_wd    <= 5'b0;
            mem_wreg  <= 1'b0;
            mem_wdata <= 32'b0; 
            mem_whilo <= 1'b0; 
            mem_hi    <= 32'b0;
            mem_lo    <= 32'b0;
            mem_aluop   <= 8'b0;
            mem_mem_addr<= 32'b0;
            mem_reg2    <= 32'b0; 
            mem_cp0_reg_we         <= 1'b0;
            mem_cp0_reg_write_addr <= 5'b0;
            mem_cp0_reg_data       <= 32'b0;
            mem_excepttype           <= 32'b0;
            mem_current_inst_address <= 32'b0;
            mem_is_in_delayslot      <= 1'b0;
        end
        else if(stall[5]==1'b0)begin
            mem_wd    <= nop2_wd;   
            mem_wreg  <= nop2_wreg;
            mem_wdata <= nop2_wdata;
            mem_whilo <= nop2_whilo;
            mem_hi    <= nop2_hi   ;
            mem_lo    <= nop2_lo   ;
            mem_aluop   <= nop2_aluop   ;
            mem_mem_addr<= nop2_mem_addr;
            mem_reg2    <= nop2_reg2    ;
            mem_cp0_reg_we         <= nop2_cp0_reg_we        ; 
            mem_cp0_reg_write_addr <= nop2_cp0_reg_write_addr; 
            mem_cp0_reg_data       <= nop2_cp0_reg_data      ; 
            mem_excepttype           <= nop2_excepttype          ;
            mem_current_inst_address <= nop2_current_inst_address;
            mem_is_in_delayslot      <= nop2_is_in_delayslot     ;
        end
    end
    
    
    
endmodule
 
