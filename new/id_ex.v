`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 00:41:16
// Design Name: 
// Module Name: id_ex
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


module id_ex(
    rst                      ,
    clk                      ,
    id_alusel                ,
    id_aluop                 ,
    id_reg1                  ,
    id_reg2                  ,
    id_wd                    ,
    id_wreg                  ,
    stall                    ,
    flush                    ,
    id_excepttype            ,
    id_current_inst_addr     ,
    id_is_in_delayslot       ,
    id_link_addr             ,
    i_next_inst_in_delayslot ,
    id_inst                  ,
    ex_inst                  ,
    ex_is_in_delayslot       ,
    ex_link_addr             ,
    o_is_in_delayslot        ,
    ex_excepttype            ,
    ex_current_inst_addr     ,
    ex_alusel                ,
    ex_aluop                 ,
    ex_reg1                  ,
    ex_reg2                  ,
    ex_wd                    ,
    ex_wreg                  
    );
    input             rst                      ;                      
    input             clk                      ;                      
    input      [2:0]  id_alusel                ;          
    input      [7:0]  id_aluop                 ;           
    input      [31:0] id_reg1                  ;           
    input      [31:0] id_reg2                  ;           
    input      [4:0]  id_wd                    ;              
    input             id_wreg                  ;                  
    input      [7:0]  stall                    ;                    
    input             flush                    ;                    
    input      [31:0] id_excepttype            ;     
    input      [31:0] id_current_inst_addr     ;   
    input             id_is_in_delayslot       ;       
    input      [31:0] id_link_addr             ;          
    input             i_next_inst_in_delayslot ; 
    input      [31:0] id_inst                  ;                  
    output reg [31:0] ex_inst                  ;                 
    output reg        ex_is_in_delayslot       ;      
    output reg [31:0] ex_link_addr             ;         
    output reg        o_is_in_delayslot        ;       
    output reg [31:0] ex_excepttype            ;           
    output reg [31:0] ex_current_inst_addr     ;    
    output reg [2:0]  ex_alusel                ;               
    output reg [7:0]  ex_aluop                 ;                  
    output reg [31:0] ex_reg1                  ;                
    output reg [31:0] ex_reg2                  ;                 
    output reg [4:0]  ex_wd                    ;                   
    output reg        ex_wreg                  ;     
    
    
    always @ (posedge clk, posedge rst) begin
        if(rst) begin 
            ex_alusel          <= 3'b0;
            ex_aluop           <= 8'b0;
            ex_reg1            <= 32'b0;
            ex_reg2            <= 32'b0;
            ex_wd              <= 5'b0;
            ex_wreg            <= 1'b0;
            ex_is_in_delayslot <= 1'b0;
            ex_link_addr       <= 32'b0;
            o_is_in_delayslot  <= 1'b0;
            ex_inst            <= 32'b0;
            ex_excepttype        <= 32'b0;
            ex_current_inst_addr <= 32'b0;
        end
        else if(flush == 1'b1) begin
            ex_alusel          <= 3'b0;
            ex_aluop           <= 8'b0;
            ex_reg1            <= 32'b0;
            ex_reg2            <= 32'b0;
            ex_wd              <= 5'b0;
            ex_wreg            <= 1'b0;
            ex_is_in_delayslot <= 1'b0;
            ex_link_addr       <= 32'b0;
            o_is_in_delayslot  <= 1'b0;
            ex_inst            <= 32'b0;
            ex_excepttype        <= 32'b0;
            ex_current_inst_addr <= 32'b0;
        end
        else if(stall[2]==1'b1 & stall[3] == 1'b0) begin
            ex_alusel         <= 3'b0;
            ex_aluop          <= 8'b0;
            ex_reg1           <= 32'b0;
            ex_reg2           <= 32'b0;
            ex_wd             <= 5'b0;
            ex_wreg           <= 1'b0;
            ex_is_in_delayslot <= 1'b0;
            ex_link_addr       <= 32'b0;
            o_is_in_delayslot  <= 1'b0;
            ex_inst            <= 32'b0;
            ex_excepttype        <= 32'b0;
            ex_current_inst_addr <= 32'b0;
        end
        else if(stall[2]==1'b0) begin
            ex_alusel <= id_alusel;
            ex_aluop  <= id_aluop ;
            ex_reg1   <= id_reg1  ;
            ex_reg2   <= id_reg2  ;
            ex_wd     <= id_wd    ;
            ex_wreg   <= id_wreg  ;
            ex_is_in_delayslot <= id_is_in_delayslot;
            ex_link_addr       <= id_link_addr;
            o_is_in_delayslot  <= i_next_inst_in_delayslot;
            ex_inst            <= id_inst;
            ex_excepttype        <= id_excepttype       ;
            ex_current_inst_addr <= id_current_inst_addr;
        end
    end
                    
endmodule
