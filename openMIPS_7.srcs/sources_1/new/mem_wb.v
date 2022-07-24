`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 09:24:35
// Design Name: 
// Module Name: mem_wb
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


module mem_wb(
    rst                    ,
    clk                    ,
    mem_wd                 ,
    mem_wreg               ,
    mem_wdata              ,
    wb_wd                  ,
    wb_wreg                ,
    wb_wdata               ,
    mem_LLbit_we           ,
    mem_LLbit_value        ,
    wb_LLbit_we            ,
    wb_LLbit_value         ,
    mem_cp0_reg_we         ,
    mem_cp0_reg_write_addr ,
    mem_cp0_reg_data       ,
    wb_cp0_reg_we          ,
    wb_cp0_reg_write_addr  ,
    wb_cp0_reg_data        ,
    mem_whilo              ,
    mem_hi                 ,
    mem_lo                 ,
    wb_whilo               ,
    wb_hi                  ,
    wb_lo                  ,
    stall                  ,
    flush                  
    );                                       
    input             rst                    ;
    input             clk                    ;
    input      [4:0]  mem_wd                 ;
    input             mem_wreg               ;
    input      [31:0] mem_wdata              ;
    output reg [4:0]  wb_wd                  ;
    output reg        wb_wreg                ;
    output reg [31:0] wb_wdata               ;
    input             mem_LLbit_we           ;
    input             mem_LLbit_value        ;
    output reg        wb_LLbit_we            ;
    output reg        wb_LLbit_value         ;
    input             mem_cp0_reg_we         ;
    input      [4:0]  mem_cp0_reg_write_addr ;
    input      [31:0] mem_cp0_reg_data       ;
    output reg        wb_cp0_reg_we          ;
    output reg [4:0]  wb_cp0_reg_write_addr  ;
    output reg [31:0] wb_cp0_reg_data        ;
    input             mem_whilo              ;
    input      [31:0] mem_hi                 ;
    input      [31:0] mem_lo                 ;
    output reg        wb_whilo               ;
    output reg [31:0] wb_hi                  ;
    output reg [31:0] wb_lo                  ;
    input      [7:0]  stall                  ;
    input             flush                  ;
    
    always @ (posedge clk, posedge rst) begin
        if(rst) begin
            wb_wd    <= 5'b0;
            wb_wreg  <= 1'b0;
            wb_wdata <= 32'b0; 
            wb_whilo <= 1'b0;     
            wb_hi    <= 32'b0;
            wb_lo    <= 32'b0;
            wb_LLbit_we <= 1'b0;
            wb_LLbit_value <= 1'b0;
            wb_cp0_reg_we         <= 1'b0;
            wb_cp0_reg_write_addr <= 5'b0;
            wb_cp0_reg_data       <= 32'b0;

        end
        else if(flush == 1'b1) begin
            wb_wd    <= 5'b0;
            wb_wreg  <= 1'b0;
            wb_wdata <= 32'b0; 
            wb_whilo <= 1'b0;     
            wb_hi    <= 32'b0;
            wb_lo    <= 32'b0;
            wb_LLbit_we <= 1'b0;
            wb_LLbit_value <= 1'b0;
            wb_cp0_reg_we         <= 1'b0;
            wb_cp0_reg_write_addr <= 5'b0;
            wb_cp0_reg_data       <= 32'b0;
        end
        else if(stall[6]==1'b1 & stall[7] == 1'b0) begin
            wb_wd    <= 5'b0;
            wb_wreg  <= 1'b0;
            wb_wdata <= 32'b0; 
            wb_whilo <= 1'b0;     
            wb_hi    <= 32'b0;
            wb_lo    <= 32'b0;
            wb_LLbit_we <= 1'b0;
            wb_LLbit_value <= 1'b0;
            wb_cp0_reg_we         <= 1'b0;
            wb_cp0_reg_write_addr <= 5'b0;
            wb_cp0_reg_data       <= 32'b0;
        end
        else if(stall[6]==1'b0) begin
            wb_wd    <= mem_wd;   
            wb_wreg  <= mem_wreg;
            wb_wdata <= mem_wdata;
            wb_whilo <= mem_whilo;      
            wb_hi    <= mem_hi;   
            wb_lo    <= mem_lo;   
            wb_LLbit_we <= mem_LLbit_we;
            wb_LLbit_value <= mem_LLbit_value;
            wb_cp0_reg_we         <= mem_cp0_reg_we        ;
            wb_cp0_reg_write_addr <= mem_cp0_reg_write_addr;
            wb_cp0_reg_data       <= mem_cp0_reg_data      ;
        end
    end
 
endmodule
