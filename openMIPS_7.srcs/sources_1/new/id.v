`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/12 16:31:59
// Design Name: 
// Module Name: id
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
module id(
    rst                       ,
    i_pc                      ,
    i_inst                    ,
    i_reg1_data               ,
    i_reg2_data               ,
    i_ex_wreg                 ,
    i_ex_wd                   ,
    i_ex_wdata                ,
    i_nop1_wreg               ,
    i_nop1_wd                 ,
    i_nop1_wdata              ,
    i_nop2_wreg               ,
    i_nop2_wd                 ,
    i_nop2_wdata              ,
    i_mem_wreg                ,
    i_mem_wd                  ,
    i_mem_wdata               ,
    i_ex_aluop                ,
    i_nop1_aluop              ,
    i_nop2_aluop              ,
    i_is_in_delayslot         ,
    o_reg1_read               ,
    o_reg2_read               ,
    o_reg1_addr               ,
    o_reg2_addr               ,
    o_aluop                   ,
    o_alusel                  ,
    o_reg1                    ,
    o_reg2                    ,
    o_wd                      ,
    o_wreg                    ,
    o_branch_flag             ,
    o_branch_target_address   ,
    o_is_in_delayslot         ,
    o_link_addr               ,
    o_next_inst_in_delayslot  ,
    o_inst                    ,
    o_excepttype              ,
    o_current_inst_addr       ,
    stallreq                  
    );

    input             rst                      ;                     
    input      [31:0] i_pc                     ;                    
    input      [31:0] i_inst                   ;                  
    input      [31:0] i_reg1_data              ;             
    input      [31:0] i_reg2_data              ;             
    input             i_ex_wreg                ;               
    input      [4:0]  i_ex_wd                  ;                 
    input      [31:0] i_ex_wdata               ; 
    input             i_nop1_wreg              ;               
    input      [4:0]  i_nop1_wd                ;                 
    input      [31:0] i_nop1_wdata             ;
    input             i_nop2_wreg              ;               
    input      [4:0]  i_nop2_wd                ;                 
    input      [31:0] i_nop2_wdata             ;             
    input             i_mem_wreg               ;              
    input      [4:0]  i_mem_wd                 ;                
    input      [31:0] i_mem_wdata              ;            
    input      [7:0]  i_ex_aluop               ; 
    input      [7:0]  i_nop1_aluop             ;
    input      [7:0]  i_nop2_aluop             ;             
    input             i_is_in_delayslot        ;       
    output reg        o_reg1_read              ;             
    output reg        o_reg2_read              ;             
    output reg [4:0]  o_reg1_addr              ;             
    output reg [4:0]  o_reg2_addr              ;             
    output reg [7:0]  o_aluop                  ;                 
    output reg [2:0]  o_alusel                 ;                
    output reg [31:0] o_reg1                   ;                  
    output reg [31:0] o_reg2                   ;                  
    output reg [4:0]  o_wd                     ;                   
    output reg        o_wreg                   ;                  
    output reg        o_branch_flag            ;           
    output reg [31:0] o_branch_target_address  ; 
    output reg        o_is_in_delayslot        ;       
    output reg [31:0] o_link_addr              ;             
    output reg        o_next_inst_in_delayslot ;
    output     [31:0] o_inst                   ;                  
    output     [31:0] o_excepttype             ;            
    output     [31:0] o_current_inst_addr      ;     
    output            stallreq                 ;
    
    wire [5:0]  opcode;
    wire [4:0]  shamt;
    wire [5:0]  funct;
    wire [4:0]  rt;
    wire [4:0]  rs;
    
    reg  [31:0] imm;
    reg         instvalid;
    wire [31:0] pc_plus_8;
    wire [31:0] pc_plus_4;
    
    reg         execepttype_is_syscall;
    reg         execepttype_is_eret;
    wire        pre_inst_is_load;
    reg         stallreq_for_reg1_load;
    reg         stallreq_for_reg2_load;
    
    assign o_current_inst_addr = i_pc;
    assign o_excepttype = {{19{1'b0}},execepttype_is_eret,{2{1'b0}},~instvalid,execepttype_is_syscall,8'b0};
    
    assign opcode = i_inst[31:26];
    assign shamt  = i_inst[10:6];
    assign funct  = i_inst[5:0];
    assign rt     = i_inst[20:16];
    assign rs     = i_inst[25:21];
    assign pc_plus_8 = i_pc + 8;
    assign pc_plus_4 = i_pc + 4;
    assign o_inst = i_inst;
    always @ (*) begin
        if(rst) begin
            o_reg1_read               = 1'b0;
            o_reg2_read               = 1'b0;
            o_reg1_addr               = 5'b0;
            o_reg2_addr               = 5'b0;
            o_aluop                   = 8'b0;
            o_alusel                  = 3'b0;
            o_wd                      = 5'b0;
            o_wreg                    = 1'b0;
            o_branch_flag             = 1'b0;
            o_branch_target_address   = 32'b0;
            
            o_link_addr               = 32'b0;
            o_next_inst_in_delayslot  = 1'b0;
            
            
            imm                       = 32'b0;
            
            instvalid                 = 1'b0;
            execepttype_is_syscall    = 1'b0;
            execepttype_is_eret       = 1'b0;
            
        end
        else begin
            o_reg1_read               = 1'b0;
            o_reg2_read               = 1'b0;
            o_reg1_addr               = i_inst[25:21];
            o_reg2_addr               = i_inst[20:16];
            o_aluop                   = 8'b0;
            o_alusel                  = 3'b0;
            o_wd                      = i_inst[15:11];
            o_wreg                    = 1'b0;
            o_branch_flag             = 1'b0;
            o_branch_target_address   = 32'b0;
            
            o_link_addr               = 32'b0;
            o_next_inst_in_delayslot  = 1'b0;

            
            instvalid                 = 1'b0;
            imm                       = 32'b0;
            instvalid                 = 1'b0;
            execepttype_is_syscall    = 1'b0;
            execepttype_is_eret       = 1'b0;
            
            
            case(opcode)
            `OP_ORI:
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_ORI;
                    o_alusel    = `AluSel_LOGIC;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b0;
                    o_reg1_addr = i_inst[25:21];
                    imm         = {{16{1'b0}},i_inst[15:0]};
                    instvalid                 = 1'b1;
                end
            `OP_XORI: 
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_XORI;
                    o_alusel    = `AluSel_LOGIC;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b0;
                    o_reg1_addr = i_inst[25:21];
                    imm         = {{16{1'b0}},i_inst[15:0]};
                    instvalid                 = 1'b1;
                end
            `OP_LUI: 
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_LUI;
                    o_alusel    = `AluSel_LOGIC;
                    o_reg1_read = 1'b0;
                    o_reg2_read = 1'b0;
                    o_reg1_addr = i_inst[25:21];
                    imm         = {{16{1'b0}},i_inst[15:0]};
                    instvalid                 = 1'b1;
                end
            `OP_ANDI: 
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_ANDI;
                    o_alusel    = `AluSel_LOGIC;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b0;
                    o_reg1_addr = i_inst[25:21];
                    imm         = {{16{1'b0}},i_inst[15:0]};
                    instvalid                 = 1'b1;
                end
            `OP_ADDI:
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_ADDI;
                    o_alusel    = `AluSel_ARITH;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b0;
                    o_reg1_addr = i_inst[25:21];
                    imm         = {{16{i_inst[15]}},i_inst[15:0]};
                    instvalid                 = 1'b1;
                end
            `OP_ADDIU:
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_ADDIU;
                    o_alusel    = `AluSel_ARITH;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b0;
                    o_reg1_addr = i_inst[25:21];
                    imm         = {{16{i_inst[15]}},i_inst[15:0]};
                    instvalid                 = 1'b1;
                end
            `OP_SLTI:
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_SLTI;
                    o_alusel    = `AluSel_ARITH;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b0;
                    o_reg1_addr = i_inst[25:21];
                    imm         = {{16{i_inst[15]}},i_inst[15:0]};
                    instvalid                 = 1'b1;
                end
            `OP_SLTIU:
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_SLTIU;
                    o_alusel    = `AluSel_ARITH;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b0;
                    o_reg1_addr = i_inst[25:21];
                    imm         = {{16{i_inst[15]}},i_inst[15:0]};
                    instvalid                 = 1'b1;
                end
            `OP_J:   
                begin
                    o_wreg      = 1'b0;
                    o_wd        = i_inst[15:11];
                    o_aluop     = `AluOp_J;
                    o_alusel    = `AluSel_J;
                    o_reg1_read = 1'b0;
                    o_reg2_read = 1'b0;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    o_link_addr = 32'b0;
                    o_branch_flag             = 1'b1;
                    o_branch_target_address   = {pc_plus_4[31:28],i_inst[25:0],{2{1'b0}}};
                    o_next_inst_in_delayslot  = 1'b1;   
                    instvalid                 = 1'b1; 
                end
            `OP_JAL:   
                begin
                    o_wreg      = 1'b1;
                    o_wd        = 5'b11111;
                    o_aluop     = `AluOp_JAL;
                    o_alusel    = `AluSel_J;
                    o_reg1_read = 1'b0;
                    o_reg2_read = 1'b0;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    o_link_addr = pc_plus_8;
                    o_branch_flag             = 1'b1;
                    o_branch_target_address   = {pc_plus_4[31:28],i_inst[25:0],{2{1'b0}}};
                    o_next_inst_in_delayslot  = 1'b1;   
                    instvalid                 = 1'b1; 
                end
            `OP_BEQ,`OP_B:   
                begin
                    o_wreg      = 1'b0;
                    o_wd        = i_inst[15:11];
                    o_aluop     = `AluOp_BEQ;
                    o_alusel    = `AluSel_J;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b1;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    o_link_addr = 32'b0;
                    o_branch_flag             = (o_reg1 == o_reg2)? 1'b1: 1'b0;
                    o_branch_target_address   = {{14{i_inst[15]}},i_inst[15:0],{2{1'b0}}} + pc_plus_4;
                    o_next_inst_in_delayslot  = 1'b1;    
                    instvalid                 = 1'b1;
                end
            `OP_BGTZ:   
                begin
                    o_wreg      = 1'b0;
                    o_wd        = i_inst[15:11];
                    o_aluop     = `AluOp_BGTZ;
                    o_alusel    = `AluSel_J;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b0;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    o_link_addr = 32'b0;
                    o_branch_flag             = (o_reg1[31]!=1'b1 & o_reg1 != 32'b0)? 1'b1: 1'b0;
                    o_branch_target_address   = {{14{i_inst[15]}},i_inst[15:0],{2{1'b0}}} + pc_plus_4;
                    o_next_inst_in_delayslot  = 1'b1;    
                    instvalid                 = 1'b1;
                end
            `OP_BLEZ:   
                begin
                    o_wreg      = 1'b0;
                    o_wd        = i_inst[15:11];
                    o_aluop     = `AluOp_BLEZ;
                    o_alusel    = `AluSel_J;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b0;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    o_link_addr = 32'b0;
                    o_branch_flag             = (o_reg1[31]==1'b1 | o_reg1 == 32'b0)? 1'b1: 1'b0;
                    o_branch_target_address   = {{14{i_inst[15]}},i_inst[15:0],{2{1'b0}}} + pc_plus_4;
                    o_next_inst_in_delayslot  = 1'b1;   
                    instvalid                 = 1'b1; 
                end
            `OP_BNE:   
                begin
                    o_wreg      = 1'b0;
                    o_wd        = i_inst[15:11];
                    o_aluop     = `AluOp_BNE;
                    o_alusel    = `AluSel_J;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b1;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    o_link_addr = 32'b0;
                    o_branch_flag             = (o_reg1 != o_reg2)? 1'b1: 1'b0;
                    o_branch_target_address   = {{14{i_inst[15]}},i_inst[15:0],{2{1'b0}}} + pc_plus_4;
                    o_next_inst_in_delayslot  = 1'b1;    
                    instvalid                 = 1'b1;
                end
            `OP_LB:  
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_LB;
                    o_alusel    = `AluSel_LOAD;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b0;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    instvalid                 = 1'b1;
                end
            `OP_LBU:  
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_LBU;
                    o_alusel    = `AluSel_LOAD;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b0;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    instvalid                 = 1'b1;
                end
            `OP_LH:  
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_LH;
                    o_alusel    = `AluSel_LOAD;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b0;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    instvalid                 = 1'b1;
                end
            `OP_LHU:  
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_LHU;
                    o_alusel    = `AluSel_LOAD;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b0;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    instvalid                 = 1'b1;
                end
            `OP_LW:  
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_LW;
                    o_alusel    = `AluSel_LOAD;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b0;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    instvalid                 = 1'b1;
                end
            `OP_LWL:  
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_LWL;
                    o_alusel    = `AluSel_LOAD;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b1;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    instvalid                 = 1'b1;
                end
            `OP_LWR:  
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_LWR;
                    o_alusel    = `AluSel_LOAD;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b1;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    instvalid                 = 1'b1;
                end
            `OP_LL: 
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_LL;
                    o_alusel    = `AluSel_LOAD;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b0;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    instvalid                 = 1'b1;
                end
            `OP_SB:  
                begin
                    o_wreg      = 1'b0;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_SB;
                    o_alusel    = `AluSel_LOAD;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b1;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    instvalid                 = 1'b1;
                end
            `OP_SH:  
                begin
                    o_wreg      = 1'b0;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_SH;
                    o_alusel    = `AluSel_LOAD;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b1;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    instvalid                 = 1'b1;
                end
            `OP_SW:  
                begin
                    o_wreg      = 1'b0;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_SW;
                    o_alusel    = `AluSel_LOAD;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b1;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    instvalid                 = 1'b1;
                end
            `OP_SWL:  
                begin
                    o_wreg      = 1'b0;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_SWL;
                    o_alusel    = `AluSel_LOAD;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b1;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    instvalid                 = 1'b1;
                end
            `OP_SWR:  
                begin
                    o_wreg      = 1'b0;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_SWR;
                    o_alusel    = `AluSel_LOAD;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b1;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    instvalid                 = 1'b1;
                end
            `OP_SC:  
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[20:16];
                    o_aluop     = `AluOp_SC;
                    o_alusel    = `AluSel_LOAD;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b1;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    instvalid                 = 1'b1;
                end
            `OP_REGIMM: 
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[15:11];
                    o_aluop     = 8'b0;
                    o_alusel    = `AluSel_LOGIC;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b1;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    o_link_addr = 32'b0;
                    o_branch_flag             = 1'b0;
                    o_branch_target_address   = 32'b0;
                    o_next_inst_in_delayslot  = 1'b0;
                    imm                       = 32'b0;
                    instvalid                 = 1'b0;
                    execepttype_is_syscall    = 1'b0;
                    execepttype_is_eret       = 1'b0;
                    case(rt)
                    `Funct_BLTZ: 
                        begin
                            o_wreg      = 1'b0;
                            o_wd        = i_inst[15:11];
                            o_aluop     = `AluOp_BLTZ;
                            o_alusel    = `AluSel_J;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b0;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];
                            o_link_addr = 32'b0;
                            o_branch_flag             = (o_reg1[31] == 1'b1)? 1'b1: 1'b0;
                            o_branch_target_address   = {{14{i_inst[15]}},i_inst[15:0],{2{1'b0}}} + pc_plus_4;
                            o_next_inst_in_delayslot  = 1'b1;    
                            instvalid                 = 1'b1;
                        end
                    `Funct_BLTZAL: 
                        begin
                            o_wreg      = 1'b1;
                            o_wd        = 5'b11111;
                            o_aluop     = `AluOp_BLTZAL;
                            o_alusel    = `AluSel_J;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b0;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];
                            o_link_addr = pc_plus_8;
                            o_branch_flag             = (o_reg1[31] == 1'b1)? 1'b1: 1'b0;
                            o_branch_target_address   = {{14{i_inst[15]}},i_inst[15:0],{2{1'b0}}} + pc_plus_4;
                            o_next_inst_in_delayslot  = 1'b1;    
                            instvalid                 = 1'b1;   
                        end
                    `Funct_BGEZ: 
                        begin
                            o_wreg      = 1'b0;
                            o_wd        = i_inst[15:11];
                            o_aluop     = `AluOp_BGEZ;
                            o_alusel    = `AluSel_J;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b0;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];
                            o_link_addr = 32'b0;
                            o_branch_flag             = (o_reg1[31] == 1'b0)? 1'b1: 1'b0;
                            o_branch_target_address   = {{14{i_inst[15]}},i_inst[15:0],{2{1'b0}}} + pc_plus_4;
                            o_next_inst_in_delayslot  = 1'b1;     
                            instvalid                 = 1'b1;  
                        end
                    `Funct_BGEZAL,`Funct_BAL: 
                        begin
                            o_wreg      = 1'b1;
                            o_wd        = 5'b11111;
                            o_aluop     = `AluOp_BGEZAL;
                            o_alusel    = `AluSel_J;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b0;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];
                            o_link_addr = pc_plus_8;
                            o_branch_flag             = (o_reg1[31] == 1'b0)? 1'b1: 1'b0;
                            o_branch_target_address   = {{14{i_inst[15]}},i_inst[15:0],{2{1'b0}}} + pc_plus_4;
                            o_next_inst_in_delayslot  = 1'b1;      
                            instvalid                 = 1'b1; 
                        end
                    `Funct_TEQI: 
                        begin
                            o_wreg = 1'b0;
                            o_aluop = `AluOp_TEQI;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b0;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];
                            imm         = {{16{i_inst[15]}},i_inst[15:0]};
                            instvalid   = 1'b1;
                            execepttype_is_syscall    = 1'b0;
                            execepttype_is_eret       = 1'b0;
                        end 
                    `Funct_TGEI: 
                        begin
                            o_wreg = 1'b0;
                            o_aluop = `AluOp_TGEI;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b0;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];
                            imm         = {{16{i_inst[15]}},i_inst[15:0]};
                            instvalid   = 1'b1;
                            execepttype_is_syscall    = 1'b0;
                            execepttype_is_eret       = 1'b0;
                        end   
                    `Funct_TGEIU: 
                        begin
                            o_wreg = 1'b0;
                            o_aluop = `AluOp_TGEIU;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b0;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];
                            imm         = {{16{i_inst[15]}},i_inst[15:0]};
                            instvalid   = 1'b1;
                            execepttype_is_syscall    = 1'b0;
                            execepttype_is_eret       = 1'b0;
                        end
                    `Funct_TLTI: 
                        begin
                            o_wreg = 1'b0;
                            o_aluop = `AluOp_TLTI;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b0;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];
                            imm         = {{16{i_inst[15]}},i_inst[15:0]};
                            instvalid   = 1'b1;
                            execepttype_is_syscall    = 1'b0;
                            execepttype_is_eret       = 1'b0;
                        end  
                    `Funct_TLTIU: 
                        begin
                            o_wreg = 1'b0;
                            o_aluop = `AluOp_TLTIU;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b0;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];
                            imm         = {{16{i_inst[15]}},i_inst[15:0]};
                            instvalid   = 1'b1;
                            execepttype_is_syscall    = 1'b0;
                            execepttype_is_eret       = 1'b0;
                        end 
                    `Funct_TNEI: 
                        begin
                            o_wreg = 1'b0;
                            o_aluop = `AluOp_TNEI;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b0;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];
                            imm         = {{16{i_inst[15]}},i_inst[15:0]};
                            instvalid   = 1'b1;
                            execepttype_is_syscall    = 1'b0;
                            execepttype_is_eret       = 1'b0;
                        end                          
                    default:o_aluop   = `AluOp_ERROR;
                    endcase
                end
            `OP_R:   
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[15:11];
                    o_aluop     = 8'b0;
                    o_alusel    = `AluSel_LOGIC;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b1;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                    o_link_addr = 32'b0;
                    o_branch_flag             = 1'b0;
                    o_branch_target_address   = 32'b0;
                    o_next_inst_in_delayslot  = 1'b0;   
                    instvalid                 = 1'b0;
                    
                    execepttype_is_syscall    = 1'b0;
                    execepttype_is_eret       = 1'b0;
                    case(funct)
                    `Funct_AND: 
                        begin
                            o_aluop =`AluOp_AND;   
                            instvalid                 = 1'b1;
                        end
                    `Funct_OR:  
                        begin
                            o_aluop =`AluOp_OR;   
                            instvalid                 = 1'b1;
                                    
                        end
                    `Funct_XOR: 
                        begin
                            o_aluop =`AluOp_XOR;   
                            instvalid                 = 1'b1;
                        end
                    `Funct_NOR: 
                        begin
                            o_aluop =`AluOp_NOR;
                            instvalid                 = 1'b1;
                        end
                    `Funct_SLL: 
                        begin
                            o_aluop     =`AluOp_SLL;
                            o_reg1_read = 1'b0;
                            imm         = {{27{1'b0}},i_inst[10:6]};   
                            instvalid                 = 1'b1;
                        end
                    `Funct_SRL: 
                        begin
                            o_aluop     =`AluOp_SRL;
                            o_reg1_read = 1'b0;
                            imm         = {{27{1'b0}},i_inst[10:6]};   
                            instvalid                 = 1'b1;
                        end
                    
                    `Funct_SRA: 
                        begin
                            o_aluop     =`AluOp_SRA;
                            o_reg1_read = 1'b0;
                            imm         = {{27{1'b0}},i_inst[10:6]};   
                            instvalid                 = 1'b1;
                        end      
                    `Funct_SLLV: 
                        begin
                            o_aluop     =`AluOp_SLLV;     
                            instvalid                 = 1'b1;     
                        end         
                    `Funct_SRLV: 
                        begin
                            o_aluop     =`AluOp_SRLV;     
                            instvalid                 = 1'b1;
                        end           
                    `Funct_SRLV: 
                        begin
                            o_aluop     =`AluOp_SRAV;       
                            instvalid                 = 1'b1; 
                        end               
                    `Funct_MOVN: 
                        begin
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_aluop  =`AluOp_MOVN;
                            if(i_reg2_data == 32'b0) o_wreg = 1'b0;   
                            instvalid                 = 1'b1;
                        end    
                    `Funct_MOVZ: 
                        begin
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_aluop  =`AluOp_MOVZ;
                            if(i_reg2_data != 32'b0) o_wreg = 1'b0;   
                            instvalid                 = 1'b1;
                        end 
                    `Funct_MFHI: 
                        begin
                            o_reg1_read = 1'b0;
                            o_reg2_read = 1'b0;
                            o_aluop     =`AluOp_MFHI;
                            o_wreg      = 1'b1;
                            o_wd        = i_inst[15:11];   
                            instvalid                 = 1'b1;
                        end   
                                 
                    `Funct_MFLO: 
                        begin
                            o_reg1_read = 1'b0;
                            o_reg2_read = 1'b0;
                            o_aluop     =`AluOp_MFLO;
                            o_wreg      = 1'b1;
                            o_wd        = i_inst[15:11];   
                            instvalid                 = 1'b1;
                        end  
                    `Funct_MTHI: 
                        begin
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b0;
                            o_aluop     =`AluOp_MTHI;
                            o_wreg      = 1'b0;
                            o_wd        = i_inst[15:11];   
                            instvalid                 = 1'b1;
                        end     
                    `Funct_MTLO: 
                        begin
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b0;
                            o_aluop     =`AluOp_MTLO;
                            o_wreg      = 1'b0;
                            o_wd        = i_inst[15:11];   
                            instvalid                 = 1'b1;
                        end
                    `Funct_ADD: 
                        begin
                            o_wreg      = 1'b1;
                            o_wd        = i_inst[15:11];
                            o_aluop     = `AluOp_ADD;
                            o_alusel    = `AluSel_ARITH;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];   
                            instvalid                 = 1'b1;
                        end    
                    `Funct_ADDU: 
                        begin
                            o_wreg      = 1'b1;
                            o_wd        = i_inst[15:11];
                            o_aluop     = `AluOp_ADDU;
                            o_alusel    = `AluSel_ARITH;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];   
                            instvalid                 = 1'b1;
                        end             
                                
                    `Funct_SUB: 
                        begin
                            o_wreg      = 1'b1;
                            o_wd        = i_inst[15:11];
                            o_aluop     = `AluOp_SUB;
                            o_alusel    = `AluSel_ARITH;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];   
                            instvalid                 = 1'b1;
                        end 
                    `Funct_SUBU: 
                        begin
                            o_wreg      = 1'b1;
                            o_wd        = i_inst[15:11];
                            o_aluop     = `AluOp_SUBU;
                            o_alusel    = `AluSel_ARITH;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];   
                            instvalid                 = 1'b1;
                        end
                    `Funct_SLT: 
                        begin
                            o_wreg      = 1'b1;
                            o_wd        = i_inst[15:11];
                            o_aluop     = `AluOp_SLT;
                            o_alusel    = `AluSel_ARITH;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];   
                            instvalid                 = 1'b1;
                        end 
                    `Funct_SLTU: 
                        begin
                            o_wreg      = 1'b1;
                            o_wd        = i_inst[15:11];
                            o_aluop     = `AluOp_SLTU;
                            o_alusel    = `AluSel_ARITH;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];   
                            instvalid                 = 1'b1;
                        end
                    `Funct_MULT: 
                        begin
                            o_wreg      = 1'b0;
                            o_wd        = i_inst[15:11];
                            o_aluop     = `AluOp_MULT;
                            o_alusel    = `AluSel_ARITH;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];   
                            instvalid                 = 1'b1;
                        end  
                    `Funct_MULTU: 
                        begin
                            o_wreg      = 1'b0;
                            o_wd        = i_inst[15:11];
                            o_aluop     = `AluOp_MULTU;
                            o_alusel    = `AluSel_ARITH;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];   
                            instvalid                 = 1'b1;
                        end
                    `Funct_DIV: 
                        begin
                            o_wreg      = 1'b0;
                            o_wd        = i_inst[15:11];
                            o_aluop     = `AluOp_DIV;
                            o_alusel    = `AluSel_ARITH;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];   
                            instvalid                 = 1'b1;
                        end
                    `Funct_DIV: 
                        begin
                            o_wreg      = 1'b0;
                            o_wd        = i_inst[15:11];
                            o_aluop     = `AluOp_DIVU;
                            o_alusel    = `AluSel_ARITH;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];   
                            instvalid                 = 1'b1;
                        end
                    `Funct_JR: 
                        begin
                            o_wreg      = 1'b0;
                            o_wd        = i_inst[15:11];
                            o_aluop     = `AluOp_JR;
                            o_alusel    = `AluSel_J;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b0;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];
                            o_link_addr = 32'b0;
                            o_branch_flag             = 1'b1;
                            o_branch_target_address   = o_reg1;
                            o_next_inst_in_delayslot  = 1'b1;   
                            instvalid                 = 1'b1;
                        end
                    `Funct_JALR: 
                        begin
                            o_wreg      = 1'b1;
                            o_wd        = i_inst[15:11];
                            o_aluop     = `AluOp_JALR;
                            o_alusel    = `AluSel_J;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b0;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];
                            o_link_addr = pc_plus_8;
                            o_branch_flag             = 1'b1;
                            o_branch_target_address   = o_reg1;
                            o_next_inst_in_delayslot  = 1'b1;   
                            instvalid                 = 1'b1;
                        end                          
                    `Funct_TEQ: 
                        begin
                            o_wreg = 1'b0;
                            o_aluop = `AluOp_TEQ;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];
                            instvalid   = 1'b1;
                            execepttype_is_syscall    = 1'b0;
                            execepttype_is_eret       = 1'b0;
                        end
                    `Funct_TGE: 
                        begin
                            o_wreg = 1'b0;
                            o_aluop = `AluOp_TGE;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];
                            instvalid   = 1'b1;
                            execepttype_is_syscall    = 1'b0;
                            execepttype_is_eret       = 1'b0;
                        end
                    `Funct_TGEU: 
                        begin
                            o_wreg = 1'b0;
                            o_aluop = `AluOp_TGEU;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];
                            instvalid   = 1'b1;
                            execepttype_is_syscall    = 1'b0;
                            execepttype_is_eret       = 1'b0;
                        end
                    `Funct_TLT: 
                        begin
                            o_wreg = 1'b0;
                            o_aluop = `AluOp_TLT;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];
                            instvalid   = 1'b1;
                            execepttype_is_syscall    = 1'b0;
                            execepttype_is_eret       = 1'b0;
                        end
                    `Funct_TLTU: 
                        begin
                            o_wreg = 1'b0;
                            o_aluop = `AluOp_TLTU;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];
                            instvalid   = 1'b1;
                            execepttype_is_syscall    = 1'b0;
                            execepttype_is_eret       = 1'b0;
                        end
                    `Funct_TNE: 
                        begin
                            o_wreg = 1'b0;
                            o_aluop = `AluOp_TNE;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];
                            instvalid   = 1'b1;
                            execepttype_is_syscall    = 1'b0;
                            execepttype_is_eret       = 1'b0;
                        end
                    `Funct_SYSCALL: 
                        begin
                            o_wreg = 1'b0;
                            o_aluop = `AluOp_SYSCALL;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];
                            instvalid   = 1'b1;
                            execepttype_is_syscall    = 1'b1;
                            execepttype_is_eret       = 1'b0;
                        end
                    default : o_aluop   = `AluOp_ERROR;
                    endcase
                end  
            `OP_R2:  
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[15:11];
                    o_aluop     = 8'b0;
                    o_alusel    = `AluSel_ARITH;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b0;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];
                       
                    instvalid                 = 1'b0;
                    
                    execepttype_is_syscall    = 1'b0;
                    execepttype_is_eret       = 1'b0;
                    case(funct)
                    `Funct_MADD:
                        begin
                                    o_wreg      = 1'b0;
                                    o_wd        = i_inst[20:16];
                                    o_aluop     = `AluOp_MADD;
                                    o_alusel    = `AluSel_ARITH;
                                    o_reg1_read = 1'b1;
                                    o_reg2_read = 1'b1;
                                    o_reg1_addr = i_inst[25:21];
                                    o_reg2_addr = i_inst[20:16];   
                                    instvalid                 = 1'b1;
                        end
                    `Funct_MADDU:
                        begin
                            o_wreg      = 1'b0;
                            o_wd        = i_inst[20:16];
                            o_aluop     = `AluOp_MADDU;
                            o_alusel    = `AluSel_ARITH;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];   
                            instvalid                 = 1'b1;
                        end
                    `Funct_MSUB: 
                        begin
                            o_wreg      = 1'b0;
                            o_wd        = i_inst[20:16];
                            o_aluop     = `AluOp_MSUB;
                            o_alusel    = `AluSel_ARITH;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];   
                            instvalid                 = 1'b1;
                        end
                    `Funct_MSUBU: 
                        begin
                            o_wreg      = 1'b0;
                            o_wd        = i_inst[20:16];
                            o_aluop     = `AluOp_MSUBU;
                            o_alusel    = `AluSel_ARITH;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];   
                            instvalid                 = 1'b1;
                        end 
                    `Funct_CLZ:
                        begin
                            o_wreg      = 1'b1;
                            o_wd        = i_inst[15:11];
                            o_aluop     = `AluOp_CLZ;
                            o_alusel    = `AluSel_ARITH;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b0;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];   
                            instvalid                 = 1'b1;
                        end
                    `Funct_CLO:
                        begin
                            o_wreg      = 1'b1;
                            o_wd        = i_inst[15:11];
                            o_aluop     = `AluOp_CLO;
                            o_alusel    = `AluSel_ARITH;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b0;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];   
                            instvalid                 = 1'b1;
                        end
                    `Funct_MUL:
                        begin
                            o_wreg      = 1'b1;
                            o_wd        = i_inst[15:11];
                            o_aluop     = `AluOp_MUL;
                            o_alusel    = `AluSel_ARITH;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b1;
                            o_reg1_addr = i_inst[25:21];
                            o_reg2_addr = i_inst[20:16];   
                            instvalid                 = 1'b1;
                        end
                    default : o_aluop   = `AluOp_ERROR;
                    endcase
                end 
                
            `OP_COP0:
                begin
                    o_wreg      = 1'b1;
                    o_wd        = i_inst[15:11];
                    o_aluop     = 8'b0;
                    o_alusel    = `AluSel_LOGIC;
                    o_reg1_read = 1'b1;
                    o_reg2_read = 1'b1;
                    o_reg1_addr = i_inst[25:21];
                    o_reg2_addr = i_inst[20:16];   
                    instvalid                 = 1'b0;
                    execepttype_is_syscall    = 1'b0;
                    execepttype_is_eret       = 1'b0;
                    case(rs)
                    `Funct_MT: 
                        begin
                            o_wreg      = 1'b0;
                            o_wd        = i_inst[15:11];
                            o_aluop     = `AluOp_MTC0;
                            o_alusel    = `AluSel_LOGIC;
                            o_reg1_read = 1'b1;
                            o_reg2_read = 1'b0;
                            o_reg1_addr = i_inst[20:16];
                            o_reg2_addr = i_inst[15:11];   
                            instvalid                 = 1'b1;
                        end
                    `Funct_MF: 
                        begin
                            o_wreg      = 1'b1;
                            o_wd        = i_inst[20:16];
                            o_aluop     = `AluOp_MFC0;
                            o_alusel    = `AluSel_LOGIC;
                            o_reg1_read = 1'b0;
                            o_reg2_read = 1'b0;
                            o_reg1_addr = i_inst[20:16];
                            o_reg2_addr = i_inst[15:11];                       
                            instvalid                 = 1'b1;
                        end
                    5'b10000:
                        begin
                            if(funct == 6'b011000) begin
                                o_wreg = 1'b0;                   
                                o_aluop = `AluOp_ERET;        
                                o_reg1_read = 1'b0;              
                                o_reg2_read = 1'b0;              
                                o_reg1_addr = i_inst[25:21];     
                                o_reg2_addr = i_inst[20:16];     
                                instvalid   = 1'b1;              
                                execepttype_is_syscall    = 1'b0;
                                execepttype_is_eret       = 1'b1; 
                            end 
                        end
                    default : o_aluop   = `AluOp_ERROR;
                    endcase
                end
            default: 
                begin
                    o_aluop  = `AluOp_ERROR;
                    o_alusel = `AluSel_ERROR;
                    imm      = 32'b0;
                end  
            endcase
            
            
            
                        
        end
    end
    
    
    assign pre_inst_is_load = ((i_ex_aluop == `AluOp_LB) |
                               (i_ex_aluop == `AluOp_LBU)|
                               (i_ex_aluop == `AluOp_LH) |
                               (i_ex_aluop == `AluOp_LHU)|
                               (i_ex_aluop == `AluOp_LW) |
                               (i_ex_aluop == `AluOp_LWR)|
                               (i_ex_aluop == `AluOp_LWL)|
                               (i_ex_aluop == `AluOp_LWR)|
                               (i_ex_aluop == `AluOp_LL) |
                               (i_ex_aluop == `AluOp_SC) |
                               (i_nop1_aluop == `AluOp_LB) |
                               (i_nop1_aluop == `AluOp_LBU)|
                               (i_nop1_aluop == `AluOp_LH) |
                               (i_nop1_aluop == `AluOp_LHU)|
                               (i_nop1_aluop == `AluOp_LW) |
                               (i_nop1_aluop == `AluOp_LWR)|
                               (i_nop1_aluop == `AluOp_LWL)|
                               (i_nop1_aluop == `AluOp_LWR)|
                               (i_nop1_aluop == `AluOp_LL) |
                               (i_nop1_aluop == `AluOp_SC) |
                               (i_nop2_aluop == `AluOp_LB) |
                               (i_nop2_aluop == `AluOp_LBU)|
                               (i_nop2_aluop == `AluOp_LH) |
                               (i_nop2_aluop == `AluOp_LHU)|
                               (i_nop2_aluop == `AluOp_LW) |
                               (i_nop2_aluop == `AluOp_LWR)|
                               (i_nop2_aluop == `AluOp_LWL)|
                               (i_nop2_aluop == `AluOp_LWR)|
                               (i_nop2_aluop == `AluOp_LL) |
                               (i_nop2_aluop == `AluOp_SC)) == 1'b1 ? 1'b1 : 1'b0;
                                                         
    always @ (*) begin
//        stallreq_for_reg1_load = 1'b0;
        if(rst) begin
            stallreq_for_reg1_load = 1'b0;
        end
        else if(pre_inst_is_load == 1'b1 & (o_reg1_addr == i_ex_wd) & (o_reg1_read == 1'b1)) begin
            stallreq_for_reg1_load = 1'b1;
        end
        else if(pre_inst_is_load == 1'b1 & (o_reg1_addr == i_nop1_wd) & (o_reg1_read == 1'b1)) begin
            stallreq_for_reg1_load = 1'b1;
        end
        else if(pre_inst_is_load == 1'b1 & (o_reg1_addr == i_nop2_wd) & (o_reg1_read == 1'b1)) begin
            stallreq_for_reg1_load = 1'b1;
        end
        else begin
            stallreq_for_reg1_load = 1'b0;
        end
    end
    always @ (*) begin
//        stallreq_for_reg2_load = 1'b0;
        if(rst) begin
            stallreq_for_reg2_load = 1'b0;
        end
        else if(pre_inst_is_load == 1'b1 & (o_reg2_addr == i_ex_wd) & (o_reg2_read == 1'b1)) begin
            stallreq_for_reg2_load = 1'b1;
        end
        else if(pre_inst_is_load == 1'b1 & (o_reg2_addr == i_nop1_wd) & (o_reg2_read == 1'b1)) begin
            stallreq_for_reg2_load = 1'b1;
        end
        else if(pre_inst_is_load == 1'b1 & (o_reg2_addr == i_nop2_wd) & (o_reg2_read == 1'b1)) begin
            stallreq_for_reg2_load = 1'b1;
        end
        
        else begin
            stallreq_for_reg2_load = 1'b0;
        end
    end
    always@(*) begin
//        o_reg1 = 32'b0;
        if(rst) begin
            o_reg1 = 32'b0;
        end
        else if((o_reg1_read == 1'b1) & (i_ex_wreg == 1'b1) & (o_reg1_addr == i_ex_wd)) begin
            o_reg1 = i_ex_wdata;
        end
        else if((o_reg1_read == 1'b1) & (i_nop1_wreg == 1'b1) & (o_reg1_addr == i_nop1_wd)) begin
            o_reg1 = i_nop1_wdata;
        end
        else if((o_reg1_read == 1'b1) & (i_nop2_wreg == 1'b1) & (o_reg1_addr == i_nop2_wd)) begin
            o_reg1 = i_nop2_wdata;
        end
        else if((o_reg1_read == 1'b1) & (i_mem_wreg == 1'b1) & (o_reg1_addr == i_mem_wd)) begin
            o_reg1 = i_mem_wdata;
        end
        else if(o_reg1_read == 1'b1) begin
            o_reg1 = i_reg1_data;
        end
        else if(o_reg1_read == 1'b0) begin
            o_reg1 = imm;
        end
        else begin
            o_reg1 = 32'b0;
        end
    end
    always @(*) begin
//        o_reg2 = 32'b0;
        if(rst) begin
            o_reg2 = 32'b0;
        end
        else if((o_reg2_read == 1'b1) & (i_ex_wreg == 1'b1) & (o_reg2_addr == i_ex_wd)) begin
            o_reg2 = i_ex_wdata;
        end
        else if((o_reg2_read == 1'b1) & (i_nop1_wreg == 1'b1) & (o_reg2_addr == i_nop1_wd)) begin
            o_reg2 = i_nop1_wdata;
        end
        else if((o_reg2_read == 1'b1) & (i_nop2_wreg == 1'b1) & (o_reg2_addr == i_nop2_wd)) begin
            o_reg2 = i_nop2_wdata;
        end
        else if((o_reg2_read == 1'b1) & (i_mem_wreg == 1'b1) & (o_reg2_addr == i_mem_wd)) begin
            o_reg2 = i_mem_wdata;
        end
        else if(o_reg2_read == 1'b1) begin
            o_reg2 = i_reg2_data;
        end
        else if(o_reg2_read == 1'b0) begin
            o_reg2 = imm;
        end
        else begin
            o_reg2 = 32'b0;
        end
    end
   
 
    always @ (*) begin
        if(rst) begin
            o_is_in_delayslot = 1'b0;
        end
        else begin
            o_is_in_delayslot = i_is_in_delayslot;
        end
    end
    assign stallreq =   stallreq_for_reg1_load | stallreq_for_reg2_load;            
endmodule     