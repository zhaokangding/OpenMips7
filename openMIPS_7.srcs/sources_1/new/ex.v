`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 08:02:45
// Design Name: 
// Module Name: ex
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
`include "define.v"

module ex(
    rst                    ,
    i_alusel               ,
    i_aluop                ,
    i_reg1                 ,
    i_reg2                 ,
    i_wd                   ,
    i_wreg                 ,
    i_excepttype           ,
    i_current_inst_addr    ,
    i_is_in_delayslot      ,
    i_link_address         ,
    i_hilo_temp            ,
    i_cnt                  ,
    o_hilo_temp            ,
    o_cnt                  ,
    o_excepttype           ,
    o_current_inst_addr    ,
    o_is_in_delatslot      ,
    o_wd                   ,
    o_wreg                 ,
    o_wdata                ,
    o_signed_div           ,
    o_div_opdata1          ,
    o_div_opdata2          ,
    o_div_start            ,
    i_div_result           ,
    i_div_ready            ,
    i_hi                   ,
    i_lo                   ,
    i_nop1_whilo           ,
    i_nop1_hi              ,
    i_nop1_lo              ,
    i_nop2_whilo           ,
    i_nop2_hi              ,
    i_nop2_lo              ,
    i_mem_whilo            ,
    i_mem_hi               ,
    i_mem_lo               ,
    i_wb_whilo             ,
    i_wb_hi                ,
    i_wb_lo                ,
    o_whilo                ,
    o_hi                   ,
    o_lo                   ,
    i_cp0_reg_data         ,
    nop1_cp0_reg_we        ,
    nop1_cp0_reg_write_addr,
    nop1_cp0_reg_data      ,
    nop2_cp0_reg_we        ,
    nop2_cp0_reg_write_addr,
    nop2_cp0_reg_data      ,    
    mem_cp0_reg_we         ,
    mem_cp0_reg_write_addr ,
    mem_cp0_reg_data       ,
    wb_cp0_reg_we          ,
    wb_cp0_reg_write_addr  ,
    wb_cp0_reg_data        ,
    o_cp0_reg_read_addr    ,
    o_cp0_reg_we           ,
    o_cp0_reg_write_addr   ,
    o_cp0_reg_data         ,
    i_inst                 ,
    o_aluop                ,
    o_mem_addr             ,
    o_reg2                 ,
    stallreq  
    );
    input             rst                     ;                   
    input      [2:0]  i_alusel                ;              
    input      [7:0]  i_aluop                 ;               
    input      [31:0] i_reg1                  ;                
    input      [31:0] i_reg2                  ;                
    input      [4:0]  i_wd                    ;                  
    input             i_wreg                  ;                
    input      [31:0] i_excepttype            ;          
    input      [31:0] i_current_inst_addr     ;   
    input             i_is_in_delayslot       ;     
    input      [31:0] i_link_address          ;        
    input      [63:0] i_hilo_temp             ;           
    input      [1:0]  i_cnt                   ;                 
    output reg [63:0] o_hilo_temp             ;           
    output reg [1:0]  o_cnt                   ;                 
    output     [31:0] o_excepttype            ;          
    output     [31:0] o_current_inst_addr     ;    
    output            o_is_in_delatslot       ;     
    output     [4:0]  o_wd                    ;                  
    output reg        o_wreg                  ;                
    output reg [31:0] o_wdata                 ;               
    output reg        o_signed_div            ;          
    output reg [31:0] o_div_opdata1           ;         
    output reg [31:0] o_div_opdata2           ;         
    output reg        o_div_start             ;           
    input      [63:0] i_div_result            ;          
    input             i_div_ready             ;           
    input      [31:0] i_hi                    ;                  
    input      [31:0] i_lo                    ;  
    input             i_nop1_whilo            ;           
    input      [31:0] i_nop1_hi               ;              
    input      [31:0] i_nop1_lo               ;
    input             i_nop2_whilo            ;           
    input      [31:0] i_nop2_hi               ;              
    input      [31:0] i_nop2_lo               ;            
    input             i_mem_whilo             ;           
    input      [31:0] i_mem_hi                ;              
    input      [31:0] i_mem_lo                ;              
    input             i_wb_whilo              ;            
    input      [31:0] i_wb_hi                 ;               
    input      [31:0] i_wb_lo                 ;               
    output reg        o_whilo                 ;               
    output reg [31:0] o_hi                    ;                  
    output reg [31:0] o_lo                    ;                  
    input      [31:0] i_cp0_reg_data          ;        
    input             nop1_cp0_reg_we         ;
    input      [4:0]  nop1_cp0_reg_write_addr ;
    input      [31:0] nop1_cp0_reg_data       ; 
    input             nop2_cp0_reg_we         ;
    input      [4:0]  nop2_cp0_reg_write_addr ;
    input      [31:0] nop2_cp0_reg_data       ; 
    input             mem_cp0_reg_we          ;        
    input      [4:0]  mem_cp0_reg_write_addr  ;
    input      [31:0] mem_cp0_reg_data        ;      
    input             wb_cp0_reg_we           ;         
    input      [4:0]  wb_cp0_reg_write_addr   ; 
    input      [31:0] wb_cp0_reg_data         ;       
    output     [4:0]  o_cp0_reg_read_addr     ;   
    output reg        o_cp0_reg_we            ;          
    output reg [4:0]  o_cp0_reg_write_addr    ;  
    output reg [31:0] o_cp0_reg_data          ;        
    input      [31:0] i_inst                  ;                
    output reg [7:0]  o_aluop                 ;               
    output reg [31:0] o_mem_addr              ;            
    output reg [31:0] o_reg2                  ;                
    output reg        stallreq                ;  
    
    reg         over_sum;
    reg         over_sub;
    reg  [31:0] HI,LO;   //the last value of HI,LO reg
    reg  [31:0] logic_out;
    reg  [31:0] arith_out;
    wire [31:0] result_sum;
    wire [31:0] result_sub;
    wire        reg1_lt_reg2;
    wire        reg1_ltu_reg2;
    wire [31:0] opdata1_mult;
    wire [31:0] opdata2_mult;
    wire [63:0] hilo_temp;
    reg  [63:0] mulres;
    wire [31:0] i_reg1_not;
    reg         stallreq_for_madd_msub;
    reg  [63:0] hilo_madd_msub_temp;
    reg         stallreq_for_div;
    reg  [31:0] CP0_RDATA; // the last data from read address of cp0
    reg         ovassert;
    reg         trapassert;
    assign o_cp0_reg_read_addr = i_inst[15:11];
    assign i_reg1_not = ~ i_reg1;
    assign reg1_ltu_reg2 = i_reg1 < i_reg2;
    assign reg1_lt_reg2 = (i_reg1[31]==1'b1 & i_reg2[31]==1'b0) | (i_reg1[31]==1'b0 & i_reg2[31]==1'b0 & result_sub[31]==1'b1) | (i_reg1[31]==1'b1 & i_reg2[31]==1'b1 & result_sub[31]==1'b1);
    assign result_sum = i_reg1 + i_reg2;
    assign result_sub = i_reg1 + (~i_reg2 + 1'b1);
    
    assign o_excepttype        = {i_excepttype[31:12],ovassert,trapassert,i_excepttype[9:8],{8{1'b0}}};
    
    assign o_current_inst_addr = i_current_inst_addr;
    assign o_is_in_delatslot   = i_is_in_delayslot;
    
    always @ (*) begin
        if(rst) begin
            over_sum = 1'b0;
            over_sub = 1'b0;
            arith_out = 32'b0;
            logic_out = 32'b0;
            o_whilo = 1'b0;
            o_hi = 32'b0;
            o_lo = 32'b0;
            o_mem_addr = 32'b0;
        end
        else begin
            over_sum = 1'b0;
            over_sub = 1'b0;
            logic_out = 32'b0;
            o_whilo = 1'b0;
            o_hi = 32'b0;
            o_lo = 32'b0;
            o_mem_addr = 32'b0;
            case(i_aluop)
            `AluOp_ORI : logic_out = i_reg1 | i_reg2;
            `AluOp_XORI: logic_out = i_reg1 ^ i_reg2;
            `AluOp_LUI : logic_out = {i_reg2[15:0],{16{1'b0}}};
            `AluOp_ANDI: logic_out = i_reg1 & i_reg2;
            `AluOp_AND : logic_out = i_reg1 & i_reg2;
            `AluOp_OR  : logic_out = i_reg1 | i_reg2;
            `AluOp_XOR : logic_out = i_reg1 ^ i_reg2;
            `AluOp_NOR : logic_out = ~(i_reg1 | i_reg2);
            `AluOp_SLL : logic_out = i_reg2 << i_reg1;
            `AluOp_SRL : logic_out = i_reg2 >> i_reg1;
            `AluOp_SRA : logic_out = ({32{i_reg2[31]}} << (6'd32-{1'b0, i_reg1[4:0]})) | (i_reg2 >> i_reg1[4:0]);
            `AluOp_SLLV: logic_out = i_reg2 << i_reg1;
            `AluOp_SRLV: logic_out = i_reg2 >> i_reg1;
            `AluOp_SRAV: logic_out = ({32{i_reg2[31]}} << (6'd32-{1'b0, i_reg1[4:0]})) | (i_reg2 >> i_reg1[4:0]);
            `AluOp_MOVN: logic_out = i_reg1;
            `AluOp_MOVZ: logic_out = i_reg1;
            `AluOp_MFHI: logic_out = HI;
            `AluOp_MFLO: logic_out = LO;
            `AluOp_MFC0: logic_out = CP0_RDATA;
            `AluOp_MTHI: 
                begin
                    logic_out = i_reg1;
                    o_whilo = 1'b1;
                    {o_hi,o_lo} = {i_reg1,LO};
                end
            `AluOp_MTLO: 
                begin
                    logic_out = i_reg1;
                    o_whilo = 1'b1;
                    {o_hi,o_lo} = {HI,i_reg1};
                end
                         
            `AluOp_ADD: 
                begin
                    arith_out = result_sum;
                    if(i_reg1[31]==1 & i_reg2[31]==1 & result_sum[31]==0) begin
                        over_sum = 1'b1;
                    end
                    else if(i_reg1[31]==0 & i_reg2[31]==0 & result_sum[31]==1) begin
                        over_sum = 1'b1;
                    end
                    else begin
                        over_sum = 1'b0;
                    end
                end
            `AluOp_ADDU:
                begin
                    arith_out = result_sum; 
                end
            `AluOp_ADDI: 
                begin
                    arith_out = result_sum;
                    if(i_reg1[31]==1 & i_reg2[31]==1 & result_sum[31]==0) begin
                        over_sum = 1'b1;
                    end
                    else if(i_reg1[31]==0 & i_reg2[31]==0 & result_sum[31]==1) begin
                        over_sum = 1'b1;
                    end
                    else begin
                        over_sum = 1'b0;
                    end
                end 
            `AluOp_ADDIU:
                begin
                    arith_out = result_sum; 
                end                
            `AluOp_SUB: 
                begin
                    arith_out = result_sub;
                    if(i_reg1[31]==0 & i_reg2[31]==1 & result_sub[31]==1) begin
                        over_sub = 1'b1;
                    end
                    else if(i_reg1[31]==1 & i_reg2[31]==0 & result_sub[31]==0) begin
                        over_sub = 1'b1;
                    end
                    else begin
                        over_sub = 1'b0;
                    end
                end 
            `AluOp_SUBU:
                begin
                    arith_out = result_sub;     
                end
            `AluOp_SLT: 
                begin
                    if(reg1_lt_reg2==1'b1) begin
                        arith_out = 32'b1;
                    end
                    else begin
                        arith_out = 32'b0;
                    end
                end
            `AluOp_SLTU: 
                begin
                    if(reg1_ltu_reg2==1'b1) begin
                        arith_out = 32'b1;
                    end
                    else begin
                        arith_out = 32'b0;
                    end
                end
            `AluOp_SLTI: 
                begin
                    if(reg1_lt_reg2==1'b1) begin
                        arith_out = 32'b1;
                    end
                    else begin
                        arith_out = 32'b0;
                    end
                end
            `AluOp_SLTIU: 
                begin
                    if(reg1_ltu_reg2==1'b1) begin
                        arith_out = 32'b1;
                    end
                    else begin
                        arith_out = 32'b0;
                    end
                end            
            `AluOp_MULT: 
                begin
                    o_whilo = 1'b1;
                    {o_hi,o_lo} = mulres;
                end   
            `AluOp_MULTU: 
                begin
                    o_whilo = 1'b1;
                    {o_hi,o_lo} = mulres;
                end
            `AluOp_DIV: 
                begin
                    o_whilo = 1'b1;
                    {o_hi,o_lo} = i_div_result;
                end                
            `AluOp_CLZ: 
                begin
                    if(i_reg1[31:16] == 16'b0) begin
                        if(i_reg1[15:8] == 8'b0) begin
                            if(i_reg1[7:4] == 4'b0) begin
                                if(i_reg1[3:2] == 2'b0) begin
                                    if(i_reg1[1] == 1'b0) begin
                                        if(i_reg1[0] == 1'b0) begin
                                            arith_out = 32;
                                        end
                                        else begin
                                            arith_out = 31;
                                        end
                                    end
                                    else begin
                                        arith_out = 30;
                                    end                                                  
                                end
                                else begin
                                   if(i_reg1[3] == 1'b0) begin
                                        if(i_reg1[2] == 1'b0) begin
                                            arith_out = 30;
                                        end
                                        else begin
                                            arith_out = 29;
                                        end
                                    end
                                    else begin
                                        arith_out = 28;
                                    end
                                end
                            end
                            else begin
                                if(i_reg1[7:6] == 2'b0) begin
                                    if(i_reg1[5] == 1'b0) begin
                                        if(i_reg1[4] == 1'b0) begin
                                            arith_out = 28;
                                        end
                                        else begin
                                            arith_out = 27;
                                        end
                                    end
                                    else begin
                                        arith_out = 26;
                                    end                                                  
                                end
                                else begin
                                   if(i_reg1[7] == 1'b0) begin
                                        if(i_reg1[6] == 1'b0) begin
                                            arith_out = 26;
                                        end
                                        else begin
                                            arith_out = 25;
                                        end
                                    end
                                    else begin
                                        arith_out = 24;
                                    end
                                end
                            end
                        end  
                        else begin
                            if(i_reg1[15:12] == 4'b0) begin
                                if(i_reg1[11:10] == 2'b0) begin
                                    if(i_reg1[9] == 1'b0) begin
                                        if(i_reg1[8] == 1'b0) begin
                                            arith_out = 24;
                                        end
                                        else begin
                                            arith_out = 23;
                                        end
                                    end
                                    else begin
                                        arith_out = 22;
                                    end                                                  
                                end
                                else begin
                                   if(i_reg1[11] == 1'b0) begin
                                        if(i_reg1[10] == 1'b0) begin
                                            arith_out = 22;
                                        end
                                        else begin
                                            arith_out = 21;
                                        end
                                    end
                                    else begin
                                        arith_out = 20;
                                    end
                                end
                            end
                            else begin
                                if(i_reg1[15:14] == 2'b0) begin
                                    if(i_reg1[13] == 1'b0) begin
                                        if(i_reg1[12] == 1'b0) begin
                                            arith_out = 20;
                                        end
                                        else begin
                                            arith_out = 19;
                                        end
                                    end
                                    else begin
                                        arith_out = 18;
                                    end                                                  
                                end
                                else begin
                                   if(i_reg1[15] == 1'b0) begin
                                        if(i_reg1[14] == 1'b0) begin
                                            arith_out = 18;
                                        end
                                        else begin
                                            arith_out = 17;
                                        end
                                    end
                                    else begin
                                        arith_out = 16;
                                    end
                                end
                            end
                        end  
                    end
                    else begin
                        if(i_reg1[31:24] == 8'b0) begin
                            if(i_reg1[23:20] == 4'b0) begin
                                if(i_reg1[19:18] == 2'b0) begin
                                    if(i_reg1[17] == 1'b0) begin
                                        if(i_reg1[16] == 1'b0) begin
                                            arith_out = 16;
                                        end
                                        else begin
                                            arith_out = 15;
                                        end
                                    end
                                    else begin
                                        arith_out = 14;
                                    end                                                  
                                end
                                else begin
                                   if(i_reg1[19] == 1'b0) begin
                                        if(i_reg1[18] == 1'b0) begin
                                            arith_out = 14;
                                        end
                                        else begin
                                            arith_out = 13;
                                        end
                                    end
                                    else begin
                                        arith_out = 12;
                                    end
                                end
                            end
                            else begin
                                if(i_reg1[23:22] == 2'b0) begin
                                    if(i_reg1[21] == 1'b0) begin
                                        if(i_reg1[20] == 1'b0) begin
                                            arith_out = 12;
                                        end
                                        else begin
                                            arith_out = 11;
                                        end
                                    end
                                    else begin
                                        arith_out = 10;
                                    end                                                  
                                end
                                else begin
                                   if(i_reg1[23] == 1'b0) begin
                                        if(i_reg1[22] == 1'b0) begin
                                            arith_out = 10;
                                        end
                                        else begin
                                            arith_out = 9;
                                        end
                                    end
                                    else begin
                                        arith_out = 8;
                                    end
                                end
                            end
                        end  
                        else begin
                            if(i_reg1[31:28] == 4'b0) begin
                                if(i_reg1[27:26] == 2'b0) begin
                                    if(i_reg1[25] == 1'b0) begin
                                        if(i_reg1[24] == 1'b0) begin
                                            arith_out = 8;
                                        end
                                        else begin
                                            arith_out = 7;
                                        end
                                    end
                                    else begin
                                        arith_out = 6;
                                    end                                                  
                                end
                                else begin
                                   if(i_reg1[27] == 1'b0) begin
                                        if(i_reg1[26] == 1'b0) begin
                                            arith_out = 6;
                                        end
                                        else begin
                                            arith_out = 5;
                                        end
                                    end
                                    else begin
                                        arith_out = 4;
                                    end
                                end
                            end
                            else begin
                                if(i_reg1[31:30] == 2'b0) begin
                                    if(i_reg1[29] == 1'b0) begin
                                        if(i_reg1[28] == 1'b0) begin
                                            arith_out = 4;
                                        end
                                        else begin
                                            arith_out = 3;
                                        end
                                    end
                                    else begin
                                        arith_out = 2;
                                    end                                                  
                                end
                                else begin
                                   if(i_reg1[31] == 1'b0) begin
                                        if(i_reg1[30] == 1'b0) begin
                                            arith_out = 2;
                                        end
                                        else begin
                                            arith_out = 1;
                                        end
                                    end
                                    else begin
                                        arith_out = 0;
                                    end
                                end
                            end
                        end
                    end
//                                 arith_out = i_reg1[31] ? 0  : i_reg1[30] ? 1  : i_reg1[29] ? 2 :
//			                              i_reg1[28] ? 3  : i_reg1[27] ? 4  : i_reg1[26] ? 5 :
//			                              i_reg1[25] ? 6  : i_reg1[24] ? 7  : i_reg1[23] ? 8 : 
//			                              i_reg1[22] ? 9  : i_reg1[21] ? 10 : i_reg1[20] ? 11 :
//			                              i_reg1[19] ? 12 : i_reg1[18] ? 13 : i_reg1[17] ? 14 : 
//			                              i_reg1[16] ? 15 : i_reg1[15] ? 16 : i_reg1[14] ? 17 : 
//			                              i_reg1[13] ? 18 : i_reg1[12] ? 19 : i_reg1[11] ? 20 :
//			                              i_reg1[10] ? 21 : i_reg1[9] ? 22  : i_reg1[8] ? 23 : 
//			                              i_reg1[7] ? 24  : i_reg1[6] ? 25  : i_reg1[5] ? 26 : 
//			                              i_reg1[4] ? 27  : i_reg1[3] ? 28  : i_reg1[2] ? 29 : 
//			                              i_reg1[1] ? 30  : i_reg1[0] ? 31  : 32 ;      
                end
            `AluOp_CLO: 
                begin
                    if(i_reg1_not[31:16] == 16'b0) begin
                        if(i_reg1_not[15:8] == 8'b0) begin
                            if(i_reg1_not[7:4] == 4'b0) begin
                                if(i_reg1_not[3:2] == 2'b0) begin
                                    if(i_reg1_not[1] == 1'b0) begin
                                        if(i_reg1_not[0] == 1'b0) begin
                                            arith_out = 32;
                                        end
                                        else begin
                                            arith_out = 31;
                                        end
                                    end
                                    else begin
                                        arith_out = 30;
                                    end                                                  
                                end
                                else begin
                                   if(i_reg1_not[3] == 1'b0) begin
                                        if(i_reg1_not[2] == 1'b0) begin
                                            arith_out = 30;
                                        end
                                        else begin
                                            arith_out = 29;
                                        end
                                    end
                                    else begin
                                        arith_out = 28;
                                    end
                                end
                            end
                            else begin
                                if(i_reg1_not[7:6] == 2'b0) begin
                                    if(i_reg1_not[5] == 1'b0) begin
                                        if(i_reg1_not[4] == 1'b0) begin
                                            arith_out = 28;
                                        end
                                        else begin
                                            arith_out = 27;
                                        end
                                    end
                                    else begin
                                        arith_out = 26;
                                    end                                                  
                                end
                                else begin
                                   if(i_reg1_not[7] == 1'b0) begin
                                        if(i_reg1_not[6] == 1'b0) begin
                                            arith_out = 26;
                                        end
                                        else begin
                                            arith_out = 25;
                                        end
                                    end
                                    else begin
                                        arith_out = 24;
                                    end
                                end
                            end
                        end  
                        else begin
                            if(i_reg1_not[15:12] == 4'b0) begin
                                if(i_reg1_not[11:10] == 2'b0) begin
                                    if(i_reg1_not[9] == 1'b0) begin
                                        if(i_reg1_not[8] == 1'b0) begin
                                            arith_out = 24;
                                        end
                                        else begin
                                            arith_out = 23;
                                        end
                                    end
                                    else begin
                                        arith_out = 22;
                                    end                                                  
                                end
                                else begin
                                   if(i_reg1_not[11] == 1'b0) begin
                                        if(i_reg1_not[10] == 1'b0) begin
                                            arith_out = 22;
                                        end
                                        else begin
                                            arith_out = 21;
                                        end
                                    end
                                    else begin
                                        arith_out = 20;
                                    end
                                end
                            end
                            else begin
                                if(i_reg1_not[15:14] == 2'b0) begin
                                    if(i_reg1_not[13] == 1'b0) begin
                                        if(i_reg1_not[12] == 1'b0) begin
                                            arith_out = 20;
                                        end
                                        else begin
                                            arith_out = 19;
                                        end
                                    end
                                    else begin
                                        arith_out = 18;
                                    end                                                  
                                end
                                else begin
                                   if(i_reg1_not[15] == 1'b0) begin
                                        if(i_reg1_not[14] == 1'b0) begin
                                            arith_out = 18;
                                        end
                                        else begin
                                            arith_out = 17;
                                        end
                                    end
                                    else begin
                                        arith_out = 16;
                                    end
                                end
                            end
                        end  
                    end
                    else begin
                        if(i_reg1_not[31:24] == 8'b0) begin
                            if(i_reg1_not[23:20] == 4'b0) begin
                                if(i_reg1_not[19:18] == 2'b0) begin
                                    if(i_reg1_not[17] == 1'b0) begin
                                        if(i_reg1_not[16] == 1'b0) begin
                                            arith_out = 16;
                                        end
                                        else begin
                                            arith_out = 15;
                                        end
                                    end
                                    else begin
                                        arith_out = 14;
                                    end                                                  
                                end
                                else begin
                                   if(i_reg1_not[19] == 1'b0) begin
                                        if(i_reg1_not[18] == 1'b0) begin
                                            arith_out = 14;
                                        end
                                        else begin
                                            arith_out = 13;
                                        end
                                    end
                                    else begin
                                        arith_out = 12;
                                    end
                                end
                            end
                            else begin
                                if(i_reg1_not[23:22] == 2'b0) begin
                                    if(i_reg1_not[21] == 1'b0) begin
                                        if(i_reg1_not[20] == 1'b0) begin
                                            arith_out = 12;
                                        end
                                        else begin
                                            arith_out = 11;
                                        end
                                    end
                                    else begin
                                        arith_out = 10;
                                    end                                                  
                                end
                                else begin
                                   if(i_reg1_not[23] == 1'b0) begin
                                        if(i_reg1_not[22] == 1'b0) begin
                                            arith_out = 10;
                                        end
                                        else begin
                                            arith_out = 9;
                                        end
                                    end
                                    else begin
                                        arith_out = 8;
                                    end
                                end
                            end
                        end  
                        else begin
                            if(i_reg1_not[31:28] == 4'b0) begin
                                if(i_reg1_not[27:26] == 2'b0) begin
                                    if(i_reg1_not[25] == 1'b0) begin
                                        if(i_reg1_not[24] == 1'b0) begin
                                            arith_out = 8;
                                        end
                                        else begin
                                            arith_out = 7;
                                        end
                                    end
                                    else begin
                                        arith_out = 6;
                                    end                                                  
                                end
                                else begin
                                   if(i_reg1_not[27] == 1'b0) begin
                                        if(i_reg1_not[26] == 1'b0) begin
                                            arith_out = 6;
                                        end
                                        else begin
                                            arith_out = 5;
                                        end
                                    end
                                    else begin
                                        arith_out = 4;
                                    end
                                end
                            end
                            else begin
                                if(i_reg1_not[31:30] == 2'b0) begin
                                    if(i_reg1_not[29] == 1'b0) begin
                                        if(i_reg1_not[28] == 1'b0) begin
                                            arith_out = 4;
                                        end
                                        else begin
                                            arith_out = 3;
                                        end
                                    end
                                    else begin
                                        arith_out = 2;
                                    end                                                  
                                end
                                else begin
                                   if(i_reg1_not[31] == 1'b0) begin
                                        if(i_reg1_not[30] == 1'b0) begin
                                            arith_out = 2;
                                        end
                                        else begin
                                            arith_out = 1;
                                        end
                                    end
                                    else begin
                                        arith_out = 0;
                                    end
                                end
                            end
                        end
                    end                                     
//                             arith_out = i_reg1_not[31] ? 0  : i_reg1_not[30] ? 1  : i_reg1_not[29] ? 2 :
//			                          i_reg1_not[28] ? 3  : i_reg1_not[27] ? 4  : i_reg1_not[26] ? 5 :
//			                          i_reg1_not[25] ? 6  : i_reg1_not[24] ? 7  : i_reg1_not[23] ? 8 : 
//			                          i_reg1_not[22] ? 9  : i_reg1_not[21] ? 10 : i_reg1_not[20] ? 11 :
//			                          i_reg1_not[19] ? 12 : i_reg1_not[18] ? 13 : i_reg1_not[17] ? 14 : 
//			                          i_reg1_not[16] ? 15 : i_reg1_not[15] ? 16 : i_reg1_not[14] ? 17 : 
//			                          i_reg1_not[13] ? 18 : i_reg1_not[12] ? 19 : i_reg1_not[11] ? 20 :
//			                          i_reg1_not[10] ? 21 : i_reg1_not[9] ? 22  : i_reg1_not[8] ? 23 : 
//			                          i_reg1_not[7] ? 24  : i_reg1_not[6] ? 25  : i_reg1_not[5] ? 26 : 
//			                          i_reg1_not[4] ? 27  : i_reg1_not[3] ? 28  : i_reg1_not[2] ? 29 : 
//			                          i_reg1_not[1] ? 30  : i_reg1_not[0] ? 31  : 32 ;      
                end
            `AluOp_MUL:   
                begin
                    arith_out =  mulres[31:0];      
                end
            `AluOp_MADD: 
                begin
                    o_whilo = 1'b1;
                    {o_hi,o_lo} = hilo_madd_msub_temp; 
                end  
            `AluOp_MADDU: 
                begin
                    o_whilo = 1'b1;
                    {o_hi,o_lo} = hilo_madd_msub_temp; 
                end
            `AluOp_MSUB: 
                begin
                    o_whilo = 1'b1;
                    {o_hi,o_lo} = hilo_madd_msub_temp; 
                end    
            `AluOp_MSUBU: 
                begin
                    o_whilo = 1'b1;
                    {o_hi,o_lo} = hilo_madd_msub_temp;
                end
            `AluOp_LB:   
                begin
                    o_mem_addr = i_reg1 + {{16{i_inst[15]}},i_inst[15:0]};
                end 
            `AluOp_LBU:   
                begin
                    o_mem_addr = i_reg1 + {{16{i_inst[15]}},i_inst[15:0]};
                end   
            `AluOp_LH:   
                begin
                    o_mem_addr = i_reg1 + {{16{i_inst[15]}},i_inst[15:0]};
                end
            `AluOp_LHU:   
                begin
                    o_mem_addr = i_reg1 + {{16{i_inst[15]}},i_inst[15:0]};
                end
            `AluOp_LW:   
                begin
                    o_mem_addr = i_reg1 + {{16{i_inst[15]}},i_inst[15:0]};
                end 
            `AluOp_LWL:   
                begin
                    o_mem_addr = i_reg1 + {{16{i_inst[15]}},i_inst[15:0]};
                end
            `AluOp_LWR:   
                begin
                    o_mem_addr = i_reg1 + {{16{i_inst[15]}},i_inst[15:0]};
                end
            `AluOp_LL:   
                begin
                    o_mem_addr = i_reg1 + {{16{i_inst[15]}},i_inst[15:0]};
                end             
            `AluOp_SB:   
                begin
                    o_mem_addr = i_reg1 + {{16{i_inst[15]}},i_inst[15:0]};
                end
            `AluOp_SH:   
                begin
                    o_mem_addr = i_reg1 + {{16{i_inst[15]}},i_inst[15:0]};
                end
            `AluOp_SW:   
                begin
                    o_mem_addr = i_reg1 + {{16{i_inst[15]}},i_inst[15:0]};
                end
            `AluOp_SWL:   
                begin
                    o_mem_addr = i_reg1 + {{16{i_inst[15]}},i_inst[15:0]};
                end
            `AluOp_SWR:   
                begin
                    o_mem_addr = i_reg1 + {{16{i_inst[15]}},i_inst[15:0]};
                end
            `AluOp_SC:   
                begin
                    o_mem_addr = i_reg1 + {{16{i_inst[15]}},i_inst[15:0]};
                end
            default: 
                begin 
                    logic_out = 32'b0; 
                    arith_out = 32'b0;
                end
            endcase
        end
    end
                        
    assign o_wd = i_wd;  
    always @ (*) begin
        o_wreg = i_wreg;
        ovassert = 1'b0;
        if(over_sum == 1'b0 & over_sub == 1'b0) begin
            o_wreg = i_wreg;
            ovassert = 1'b0;
        end
        else begin
            o_wreg = 1'b0;
            ovassert = 1'b1;
        end
    end
    always @ (*) begin
        if(rst) begin
            trapassert = 1'b0;
        end
        else begin
            trapassert = 1'b0;
            case(i_aluop)
            `AluOp_TEQ,`AluOp_TEQI:
                begin
                    if(i_reg1 == i_reg2) begin
                        trapassert = 1'b1;
                    end
                end
            `AluOp_TGE,`AluOp_TGEI:
                begin
                    if(reg1_lt_reg2 == 1'b0) begin
                        trapassert = 1'b1;
                    end
                end 
            `AluOp_TGEU,`AluOp_TGEIU:
                begin
                    if(reg1_ltu_reg2 == 1'b0) begin
                        trapassert = 1'b1;
                    end
                end
            `AluOp_TLT,`AluOp_TLTI:
                begin
                    if(reg1_lt_reg2 == 1'b1) begin
                        trapassert = 1'b1;
                    end
                end
            `AluOp_TLTU,`AluOp_TLTIU:
                begin
                    if(reg1_ltu_reg2 == 1'b1) begin
                        trapassert = 1'b1;
                    end
                end
            `AluOp_TNE,`AluOp_TNEI:
                begin
                    if(i_reg1 != i_reg2) begin
                        trapassert = 1'b1;
                    end
                end
            default: trapassert = 1'b0;
            endcase
        end
    end
    
    always @ (*) begin
        case(i_alusel)
        `AluSel_LOGIC: o_wdata = logic_out;
        `AluSel_ARITH: o_wdata = arith_out;
        `AluSel_J    : o_wdata = i_link_address;
        default: o_wdata = 32'b0;
        endcase
    end
    
    always @ (*) begin
        if(rst) begin
            {HI,LO} = {32'b0,32'b0};
        end
        else if(i_nop1_whilo == 1'b1) begin
            {HI,LO} = {i_nop1_hi,i_nop1_lo};
        end
        else if(i_nop2_whilo == 1'b1) begin
            {HI,LO} = {i_nop2_hi,i_nop2_lo};
        end
        else if(i_mem_whilo == 1'b1) begin
            {HI,LO} = {i_mem_hi,i_mem_lo};
        end
        else if(i_wb_whilo == 1'b1) begin
            {HI,LO} = {i_wb_hi,i_wb_lo};
        end
        else begin
            {HI,LO} = {i_hi,i_lo};
        end
    end   
    
    
    always @ (*) begin
        if(rst) begin
            o_cp0_reg_we         = 1'b0;
            o_cp0_reg_write_addr = 5'b0;
            o_cp0_reg_data       = 32'b0;            
        end
        else if (i_aluop == `AluOp_MTC0) begin
            o_cp0_reg_we         = 1'b1;
            o_cp0_reg_write_addr = i_inst[15:11];
            o_cp0_reg_data       = i_reg1;     
        end
        else begin
            o_cp0_reg_we         = 1'b0;
            o_cp0_reg_write_addr = 5'b0;
            o_cp0_reg_data       = 32'b0; 
        end
    end
    always @ (*) begin
        if(rst) begin
            CP0_RDATA = 32'b0;
        end
        else if(nop1_cp0_reg_we == 1'b1 & nop1_cp0_reg_write_addr == o_cp0_reg_read_addr) begin
            CP0_RDATA = nop1_cp0_reg_data;
        end
        else if(nop2_cp0_reg_we == 1'b1 & nop2_cp0_reg_write_addr == o_cp0_reg_read_addr) begin
            CP0_RDATA = nop2_cp0_reg_data;
        end
        else if(mem_cp0_reg_we == 1'b1 & mem_cp0_reg_write_addr == o_cp0_reg_read_addr) begin
            CP0_RDATA = mem_cp0_reg_data;
        end
        else if(wb_cp0_reg_we == 1'b1 & wb_cp0_reg_write_addr == o_cp0_reg_read_addr) begin
            CP0_RDATA = wb_cp0_reg_data;
        end
        else begin
            CP0_RDATA = i_cp0_reg_data;
        end
    end
    
    
    assign opdata1_mult = (((i_aluop == `AluOp_MULT) | (i_aluop == `AluOp_MUL) | (i_aluop == `AluOp_MADD) | (i_aluop == `AluOp_MSUB)) & (i_reg1[31] == 1'b1)) ? (~i_reg1 + 1) : i_reg1;
    assign opdata2_mult = (((i_aluop == `AluOp_MULT) | (i_aluop == `AluOp_MUL) |(i_aluop == `AluOp_MADD) | (i_aluop == `AluOp_MSUB)) & (i_reg2[31] == 1'b1)) ? (~i_reg2 + 1) : i_reg2;
    assign hilo_temp = opdata1_mult * opdata2_mult;																				

	always @ (*) begin
		if(rst == 1'b1) begin
			mulres = 64'b0;
		end 
		else if ((i_aluop == `AluOp_MULT) | (i_aluop == `AluOp_MUL) |(i_aluop == `AluOp_MADD) | (i_aluop == `AluOp_MSUB)) begin
			 if(i_reg1[31] ^ i_reg2[31] == 1'b1) begin
				mulres = ~hilo_temp + 1;
			 end 
			 else begin
			    mulres = hilo_temp;
			 end
		end 
		else begin
				mulres = hilo_temp;
		end
	end
    always @ (*) begin
        if(rst) begin
            o_hilo_temp = {32'b0,32'b0};
            o_cnt = 2'b00;
            stallreq_for_madd_msub = 1'b0;
            hilo_madd_msub_temp = {32'b0,32'b0};
        end
        case(i_aluop)
        `AluOp_MADD,`AluOp_MADDU: 
            begin
                if(i_cnt==2'b00) begin
                    o_hilo_temp = mulres;
                    o_cnt = 2'b01;
                    hilo_madd_msub_temp = {32'b0,32'b0};
                    stallreq_for_madd_msub = 1'b1;                        
                end
                else if(i_cnt==2'b01) begin
                    o_hilo_temp = {32'b0,32'b0};
                    o_cnt = 2'b10;
                    hilo_madd_msub_temp = i_hilo_temp + {HI,LO};
                    stallreq_for_madd_msub = 1'b0; 
                end
            end
        `AluOp_MSUB,`AluOp_MSUBU: 
            begin
                if(i_cnt==2'b00) begin
                    o_hilo_temp = mulres;
                    o_cnt = 2'b01;
                    hilo_madd_msub_temp = {32'b0,32'b0};
                    stallreq_for_madd_msub = 1'b1;                        
                end
                else if(i_cnt==2'b01) begin
                    o_hilo_temp = {32'b0,32'b0};
                    o_cnt = 2'b10;
                    hilo_madd_msub_temp = ~i_hilo_temp + {HI,LO} + 1'b1;
                    stallreq_for_madd_msub = 1'b0; 
                end
            end
        default: 
            begin
                o_hilo_temp = {32'b0,32'b0};
                o_cnt = 2'b00;
                stallreq_for_madd_msub = 1'b0;
            end
        endcase
    end
    always @ (*) begin
        stallreq = stallreq_for_madd_msub | stallreq_for_div;
    end
    always @ (*) begin
        if(rst) begin
            o_aluop    = 8'b0;  

            o_reg2     = 32'b0;  
        end
        else begin
            o_aluop    = i_aluop;  

            o_reg2     = i_reg2;
        end
    end 
    
    always @ (*) begin
        if(rst) begin
            stallreq_for_div = 1'b0;
            o_div_opdata1 = 32'b0;
            o_div_opdata2 = 32'b0;
            o_div_start   = 1'b0;
            o_signed_div  = 1'b0;
        end
        else begin
            stallreq_for_div = 1'b0;
            o_div_opdata1 = 32'b0;
            o_div_opdata2 = 32'b0;
            o_div_start   = 1'b0;
            o_signed_div  = 1'b0;
            case(i_aluop)
            `AluOp_DIV: 
                begin
                    if(i_div_ready == 1'b0) begin
                        stallreq_for_div = 1'b1;
                        o_div_opdata1 = i_reg1;
                        o_div_opdata2 = i_reg2;
                        o_div_start   = 1'b1;
                        o_signed_div  = 1'b1;
                    end
                    else if(i_div_ready == 1'b1) begin
                        stallreq_for_div = 1'b0;
                        o_div_opdata1 = i_reg1;
                        o_div_opdata2 = i_reg2;
                        o_div_start   = 1'b0;
                        o_signed_div  = 1'b1;
                    end
                    else begin
                        stallreq_for_div = 1'b0;
                        o_div_opdata1 = 32'b0;
                        o_div_opdata2 = 32'b0;
                        o_div_start   = 1'b0;
                        o_signed_div  = 1'b0;
                    end
                end
            default: 
                begin
                    stallreq_for_div = 1'b0;
                    o_div_opdata1 = 32'b0;
                    o_div_opdata2 = 32'b0;
                    o_div_start   = 1'b0;
                    o_signed_div  = 1'b0;
                end
            endcase
        end
    end
                 
endmodule
