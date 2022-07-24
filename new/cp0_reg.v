`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 10:22:37
// Design Name: 
// Module Name: cp0_reg
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

module cp0_reg(
    rst                    ,
    clk                    ,
    i_raddr                ,
    i_int                  ,
    i_we                   ,
    i_waddr                ,
    i_wdata                ,
    o_data                 ,
    o_count                ,
    o_compare              ,
    o_status               ,
    o_cause                ,
    o_epc                  ,
    o_config               ,
    o_prid                 ,
    o_timer_int            ,
    
    i_excepttype           ,
    i_current_inst_addr    ,
    i_is_in_delayslot      
    );
    input             rst                    ;
    input             clk                    ;
    input      [4:0]  i_raddr                ;
    input      [5:0]  i_int                  ;
    input             i_we                   ;
    input      [4:0]  i_waddr                ;
    input      [31:0] i_wdata                ;
    output reg [31:0] o_data                 ;
    output reg [31:0] o_count                ;
    output reg [31:0] o_compare              ;
    output reg [31:0] o_status               ;
    output reg [31:0] o_cause                ;
    output reg [31:0] o_epc                  ;
    output reg [31:0] o_config               ;
    output reg [31:0] o_prid                 ;
    output reg        o_timer_int            ;
    
    input      [31:0] i_excepttype           ;
    input      [31:0] i_current_inst_addr    ;
    input             i_is_in_delayslot      ;
    reg [31:0] count_next;
    reg [31:0] compare_next;
    reg [31:0] status_next;
    reg [31:0] cause_next;
    reg [31:0] epc_next;
    reg [31:0] config_next;
    reg [31:0] pid_next;
    reg [31:0] timer_int_next;
    always @ (posedge clk, posedge rst) begin
        if(rst==1'b1) begin
            o_count     <= 32'b0000_0000_0000_0000__0000_0000_0000_0000;
            o_compare   <= 32'b0000_0000_0000_0000__0000_0000_0000_0000;
            o_status    <= 32'b0001_0000_0000_0000__0000_0000_0000_0000;
            o_cause     <= 32'b0000_0000_0000_0000__0000_0000_0000_0000;
            o_epc       <= 32'b0000_0000_0000_0000__0000_0000_0000_0000;
            o_config    <= 32'b0000_0000_0000_0000__1000_0000_0000_0000;
            o_prid      <= 32'b0000_0000_0100_1100__0000_0001_0000_0010;
            o_timer_int <= 1'b0;
            
        end
        else begin
            o_count     <= count_next    ;
            o_compare   <= compare_next  ;  
            o_status    <= status_next   ;   
            o_cause     <= cause_next    ;    
            o_epc       <= epc_next      ;      
            o_config    <= config_next   ;   
            o_prid      <= pid_next      ;      
            o_timer_int <= timer_int_next;     
        end
    end
    always @ (*) begin
        count_next     = o_count    ;
        compare_next   = o_compare  ;
        status_next    = o_status   ;  
        cause_next     = o_cause    ;
        epc_next       = o_epc      ;
        config_next    = o_config   ;
        pid_next       = o_prid     ;
        timer_int_next = o_timer_int;
        
        count_next     = o_count + 1;
        
        cause_next     = {o_cause[31:16],i_int,o_cause[9:0]};
        
        if(o_compare != 32'b0 & o_count == o_compare) begin
            timer_int_next = 1'b1;
        end
        
        if(i_we == 1'b1 & i_excepttype == 32'b0) begin
            case(i_waddr)
            `CP0_REG_COUNT:
                begin
                    count_next = i_wdata;
                end
            `CP0_REG_COMPARE:
                begin
                    compare_next = i_wdata;
                    timer_int_next = 1'b0;
                end
            `CP0_REG_STATUS:
                begin
                    status_next = i_wdata;
                end
            `CP0_REG_EPC:
                begin
                    epc_next = i_wdata;
                end
            `CP0_REG_CAUSE:
                begin
                    cause_next = {o_cause[31:24],i_wdata[23],i_wdata[22],o_cause[21:16],i_int,i_wdata[9:8],o_cause[7:0]};
                end
            default: 
                begin
                     
                end
            endcase
        end 
        else if (i_excepttype != 32'b0) begin
            case(i_excepttype)
            32'h00000001: //interrupt
                begin
                    if(i_is_in_delayslot == 1'b1) begin
                        epc_next = i_current_inst_addr - 4;
                        cause_next[31] = 1'b1;
                    end 
                    else begin
                        epc_next = i_current_inst_addr;
                        cause_next[31] = 1'b0;
                    end
                    status_next[1] = 1'b1;
                    cause_next[6:2] = 5'b0;
                end
            32'h00000008: //syscall
                begin
                    if(o_status[1] == 1'b0) begin
                        if(i_is_in_delayslot == 1'b0) begin
                            epc_next = i_current_inst_addr - 4;
                            cause_next[31] = 1'b1;
                        end
                        else begin
                            epc_next = i_current_inst_addr;
                            cause_next[31] = 1'b0;
                        end
                    end
                    status_next[1] = 1'b1;
                    cause_next[6:2] = 5'b01000; 
                end
            32'h0000000a: //invalid_inst
                begin
                    if(o_status[1] == 1'b0) begin
                        if(i_is_in_delayslot == 1'b0) begin
                            epc_next = i_current_inst_addr - 4;
                            cause_next[31] = 1'b1;
                        end
                        else begin
                            epc_next = i_current_inst_addr;
                            cause_next[31] = 1'b0;
                        end
                    end
                    status_next[1] = 1'b1;
                    cause_next[6:2] = 5'b01000; 
                end
            32'h0000000d: // trap
                begin
                    if(o_status[1] == 1'b0) begin
                        if(i_is_in_delayslot == 1'b0) begin
                            epc_next = i_current_inst_addr - 4;
                            cause_next[31] = 1'b1;
                        end
                        else begin
                            epc_next = i_current_inst_addr;
                            cause_next[31] = 1'b0;
                        end
                    end
                    status_next[1] = 1'b1;
                    cause_next[6:2] = 5'b01101; 
                end
            32'h0000000c: //ovassert
                begin
                    if(o_status[1] == 1'b0) begin
                        if(i_is_in_delayslot == 1'b0) begin
                            epc_next = i_current_inst_addr - 4;
                            cause_next[31] = 1'b1;
                        end
                        else begin
                            epc_next = i_current_inst_addr;
                            cause_next[31] = 1'b0;
                        end
                    end
                    status_next[1] = 1'b1;
                    cause_next[6:2] = 5'b01100; 
                end
            32'h00000000e:
                begin
                    status_next[1] = 1'b0;
                end
            default:
                begin
                    
                end
            endcase
        end
    end
    always @ (*) begin
        if( rst== 1'b1) begin
            o_data = 32'b0;
        end
        else begin
            case(i_raddr)
            `CP0_REG_COUNT:
                begin
                    o_data = o_count;
                end
            `CP0_REG_COMPARE:
                begin
                    o_data = o_compare;
                end
            `CP0_REG_STATUS:
                begin
                    o_data = o_status;
                end
            `CP0_REG_CAUSE:
                begin
                    o_data = o_cause;
                end
            `CP0_REG_EPC:
                begin
                    o_data = o_epc;
                end
            `CP0_REG_PRID:
                begin
                    o_data = o_prid;
                end
            `CP0_REG_CONFIG:
                begin
                    o_data = o_config;
                end
            
            default:
                begin
                end
            endcase
        end
    end
    
endmodule
