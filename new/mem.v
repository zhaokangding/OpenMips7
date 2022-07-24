`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 09:02:39
// Design Name: 
// Module Name: mem
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


module mem(
    rst                      ,
    i_wd                     ,
    i_wreg                   ,
    i_wdata                  ,
    o_wd                     ,
    o_wreg                   ,
    o_wdata                  ,
    i_aluop                  ,
    i_mem_addr               ,
    i_reg2                   ,
    i_mem_data               ,
    o_mem_addr               ,
    o_mem_we                 ,
    o_mem_sel                ,
    o_mem_data               ,
    o_mem_ce                 ,
    i_whilo                  ,
    i_hi                     ,
    i_lo                     ,
    o_whilo                  ,
    o_hi                     ,
    o_lo                     ,
    i_cp0_reg_we             ,
    i_cp0_reg_write_addr     ,
    i_cp0_reg_data           ,
    o_cp0_reg_we             ,
    o_cp0_reg_write_addr     ,
    o_cp0_reg_data           ,
    i_excepttype             ,
    i_current_inst_address   ,
    i_is_in_delayslot        ,
    i_cp0_status             ,
    i_cp0_cause              ,
    i_cp0_epc                ,
    wb_cp0_reg_we            ,
    wb_cp0_reg_write_addr    ,
    wb_cp0_reg_data          ,
    o_excepttype             ,
    o_current_inst_address   ,
    o_is_in_delayslot        ,
    o_cp0_epc                ,
    i_LLbit                  ,
    i_wb_LLbit_we            ,
    i_wb_LLbit_value         ,
    o_LLbit_we               ,
    o_LLbit_value            
    );
    input             rst                      ;
    input      [4:0]  i_wd                     ;
    input             i_wreg                   ;
    input      [31:0] i_wdata                  ;
    output reg [4:0]  o_wd                     ;
    output reg        o_wreg                   ;
    output reg [31:0] o_wdata                  ;
    input      [7:0]  i_aluop                  ;
    input      [31:0] i_mem_addr               ;
    input      [31:0] i_reg2                   ;
    input      [31:0] i_mem_data               ;
    output reg [31:0] o_mem_addr               ;
    output            o_mem_we                 ;
    output reg [3:0]  o_mem_sel                ;
    output reg [31:0] o_mem_data               ;
    output reg        o_mem_ce                 ;
    input             i_whilo                  ;
    input      [31:0] i_hi                     ;
    input      [31:0] i_lo                     ;
    output reg        o_whilo                  ;
    output reg [31:0] o_hi                     ;
    output reg [31:0] o_lo                     ;
    input             i_cp0_reg_we             ;
    input      [4:0]  i_cp0_reg_write_addr     ;
    input      [31:0] i_cp0_reg_data           ;
    output reg        o_cp0_reg_we             ;
    output reg [4:0]  o_cp0_reg_write_addr     ;
    output reg [31:0] o_cp0_reg_data           ;
    input      [31:0] i_excepttype             ;
    input      [31:0] i_current_inst_address   ;
    input             i_is_in_delayslot        ;
    input      [31:0] i_cp0_status             ;
    input      [31:0] i_cp0_cause              ;
    input      [31:0] i_cp0_epc                ;
    input             wb_cp0_reg_we            ;
    input      [4:0]  wb_cp0_reg_write_addr    ;
    input      [31:0] wb_cp0_reg_data          ;
    output reg [31:0] o_excepttype             ;
    output     [31:0] o_current_inst_address   ;
    output            o_is_in_delayslot        ;
    output     [31:0] o_cp0_epc                ;
    input             i_LLbit                  ;
    input             i_wb_LLbit_we            ;
    input             i_wb_LLbit_value         ;
    output reg        o_LLbit_we               ;
    output reg        o_LLbit_value            ;
    
    reg         mem_we;
    reg         LLBIT;
    reg  [31:0] cp0_status;
    reg  [31:0] cp0_cause;
    reg  [31:0] cp0_epc;
    
    assign o_is_in_delayslot = i_is_in_delayslot;
    assign o_current_inst_address = i_current_inst_address;
    assign o_mem_we = o_excepttype == 32'b0 ? mem_we : 1'b0;
//    assign o_wd=i_wd;
//    assign o_wreg=i_wreg; 
//    assign o_wdata=i_wdata;
//    assign o_whilo = i_whilo;
//    assign o_hi = i_hi;

//    assign o_lo = i_lo;
    
    always @ (*) begin
        if(rst) begin
            o_wd       = 5'b0;
            o_wreg     = 1'b0;
            o_wdata    = 32'b0;
            o_whilo    = 1'b0;
            o_hi       = 32'b0;
            o_lo       = 32'b0;
            o_mem_addr = 32'b0;
            mem_we     = 1'b0;
            o_mem_sel  = 4'b0;
            o_mem_data = 32'b0;
            o_mem_ce   = 1'b0; 
            o_LLbit_we = 1'b0;
            o_LLbit_value = 1'b0; 
            o_cp0_reg_we         = 1'b0;
            o_cp0_reg_write_addr = 5'b0;
            o_cp0_reg_data       = 32'b0;
            
        end
        else begin
            o_wd       = i_wd;
            o_wreg     = i_wreg;
            o_wdata    = i_wdata;
            o_whilo    = i_whilo;
            o_cp0_reg_we         = i_cp0_reg_we        ;
            o_cp0_reg_write_addr = i_cp0_reg_write_addr;
            o_cp0_reg_data       = i_cp0_reg_data      ;
            
            o_hi       = i_hi;
            o_lo       = i_lo;
            o_mem_addr = 32'b0;
            mem_we     = 1'b0;
            o_mem_sel  = 4'b1111;
            o_mem_data = 32'b0;
            o_mem_ce   = 1'b0;
            o_LLbit_we = 1'b0;
            o_LLbit_value = 1'b0; 
            case(i_aluop)
                `AluOp_LB:begin
                             o_mem_addr = i_mem_addr;
                             mem_we     = 1'b0;
                             o_mem_ce   = 1'b1;
                             case (i_mem_addr[1:0])
                                 2'b00:   begin
                                              o_wdata = {{24{i_mem_data[31]}},i_mem_data[31:24]};
                                              o_mem_sel = 4'b1000;
                                          end
                                 2'b01:   begin
                                              o_wdata = {{24{i_mem_data[23]}},i_mem_data[23:16]};
                                              o_mem_sel = 4'b0100;
                                          end
                                 2'b10:   begin
                                              o_wdata = {{24{i_mem_data[15]}},i_mem_data[15:8]};
                                              o_mem_sel = 4'b0010;
                                          end
                                 2'b11:   begin
                                              o_wdata = {{24{i_mem_data[7]}},i_mem_data[7:0]};
                                              o_mem_sel = 4'b0001;
                                          end         
                                 default: begin
                                              o_wdata = 32'b0;
                                          end
                             endcase
                          end
                `AluOp_LBU:begin
                             o_mem_addr = i_mem_addr;
                             mem_we     = 1'b0;
                             o_mem_ce   = 1'b1;
                             case (i_mem_addr[1:0])
                                 2'b00:   begin
                                              o_wdata = {{24{1'b0}},i_mem_data[31:24]};
                                              o_mem_sel = 4'b1000;
                                          end
                                 2'b01:   begin
                                              o_wdata = {{24{1'b0}},i_mem_data[23:16]};
                                              o_mem_sel = 4'b0100;
                                          end
                                 2'b10:   begin
                                              o_wdata = {{24{1'b0}},i_mem_data[15:8]};
                                              o_mem_sel = 4'b0010;
                                          end
                                 2'b11:   begin
                                              o_wdata = {{24{1'b0}},i_mem_data[7:0]};
                                              o_mem_sel = 4'b0001;
                                          end         
                                 default: begin
                                              o_wdata = 32'b0;
                                          end
                             endcase
                          end
                `AluOp_LH:begin
                             o_mem_addr = i_mem_addr;
                             mem_we     = 1'b0;
                             o_mem_ce   = 1'b1;
                             case (i_mem_addr[1:0])
                                 2'b00:   begin
                                              o_wdata = {{16{i_mem_data[31]}},i_mem_data[31:24],i_mem_data[23:16]};
                                              o_mem_sel = 4'b1100;
                                          end

                                 2'b10:   begin
                                              o_wdata = {{16{i_mem_data[15]}},i_mem_data[15:8],i_mem_data[7:0]};
                                              o_mem_sel = 4'b0011;
                                          end
         
                                 default: begin
                                              o_wdata = 32'b0;
                                          end
                             endcase
                          end
                `AluOp_LHU:begin
                             o_mem_addr = i_mem_addr;
                             mem_we     = 1'b0;
                             o_mem_ce   = 1'b1;
                             case (i_mem_addr[1:0])
                                 2'b00:   begin
                                              o_wdata = {{16{1'b0}},i_mem_data[31:24],i_mem_data[23:16]};
                                              o_mem_sel = 4'b1100;
                                          end

                                 2'b10:   begin
                                              o_wdata = {{16{1'b0}},i_mem_data[15:8],i_mem_data[7:0]};
                                              o_mem_sel = 4'b0011;
                                          end
         
                                 default: begin
                                              o_wdata = 32'b0;
                                          end
                             endcase
                          end
                `AluOp_LW:begin
                             o_mem_addr = i_mem_addr;
                             mem_we     = 1'b0;
                             o_mem_ce   = 1'b1;
                             case (i_mem_addr[1:0])
                                 2'b00:   begin
                                              o_wdata = i_mem_data;
                                              o_mem_sel = 4'b1111;
                                          end

                                 
         
                                 default: begin
                                              o_wdata = 32'b0;
                                          end
                             endcase
                          end
                `AluOp_LWL:begin
                             o_mem_addr = i_mem_addr;
                             mem_we     = 1'b0;
                             o_mem_ce   = 1'b1;
                             case (i_mem_addr[1:0])
                                 2'b00:   begin
                                              o_wdata = i_mem_data;
                                              o_mem_sel = 4'b1111;
                                          end
                                 2'b01:   begin
                                              o_wdata = {i_mem_data[23:0],i_reg2[7:0]};
                                              o_mem_sel = 4'b0111;
                                          end
                                 
                                 2'b10:   begin
                                              o_wdata = {i_mem_data[15:0],i_reg2[15:0]};
                                              o_mem_sel = 4'b0011;
                                          end
                                 2'b11:   begin
                                              o_wdata = {i_mem_data[7:0],i_reg2[23:0]};
                                              o_mem_sel = 4'b0001;
                                          end
                                 default: begin
                                              o_wdata = 32'b0;
                                          end
                             endcase
                          end
                `AluOp_LWR:begin
                             o_mem_addr = i_mem_addr;
                             mem_we     = 1'b0;
                             o_mem_ce   = 1'b1;
                             case (i_mem_addr[1:0])
                                 2'b00:   begin
                                              o_wdata = {i_reg2[31:8],i_mem_data[31:24]};
                                              o_mem_sel = 4'b1000;
                                          end
                                 2'b01:   begin
                                              o_wdata = {i_reg2[31:16],i_mem_data[31:16]};
                                              o_mem_sel = 4'b1100;
                                          end
                                 
                                 2'b10:   begin
                                              o_wdata = {i_reg2[31:24],i_mem_data[31:24]};
                                              o_mem_sel = 4'b1110;
                                          end
                                 2'b11:   begin
                                              o_wdata = i_mem_data;
                                              o_mem_sel = 4'b1111;
                                          end
                                 default: begin
                                              o_wdata = 32'b0;
                                          end
                             endcase
                          end
                `AluOp_LL:begin
                             o_mem_addr = i_mem_addr;
                             mem_we     = 1'b0;
                             o_mem_ce   = 1'b1;
                             o_LLbit_we = 1'b1;
                             o_LLbit_value = 1'b1;
                             case (i_mem_addr[1:0])
                                 2'b00:   begin
                                              o_wdata = {{24{i_mem_data[31]}},i_mem_data[31:24]};
                                              o_mem_sel = 4'b1000;
                                          end
                                 2'b01:   begin
                                              o_wdata = {{24{i_mem_data[23]}},i_mem_data[23:16]};
                                              o_mem_sel = 4'b0100;
                                          end
                                 2'b10:   begin
                                              o_wdata = {{24{i_mem_data[15]}},i_mem_data[15:8]};
                                              o_mem_sel = 4'b0010;
                                          end
                                 2'b11:   begin
                                              o_wdata = {{24{i_mem_data[7]}},i_mem_data[7:0]};
                                              o_mem_sel = 4'b0001;
                                          end         
                                 default: begin
                                              o_wdata = 32'b0;
                                          end
                             endcase
                          end
                `AluOp_SB:begin
                             o_mem_addr = i_mem_addr;
                             mem_we     = 1'b1;
                             o_mem_ce   = 1'b1;
                             o_mem_data = {i_reg2[7:0],i_reg2[7:0],i_reg2[7:0],i_reg2[7:0]};
                             case (i_mem_addr[1:0])
                                 2'b00:   begin
                                              o_mem_sel = 4'b1000;
                                          end
                                 2'b01:   begin
                                              o_mem_sel = 4'b0100;
                                          end
                                 2'b10:   begin
                                              o_mem_sel = 4'b0010;
                                          end
                                 2'b11:   begin
                                              o_mem_sel = 4'b0001;
                                          end
                                 default: begin
                                              
                                              o_mem_sel = 4'b0000;
                                          end
                             endcase
                          end
                `AluOp_SH:begin
                             o_mem_addr = i_mem_addr;
                             mem_we     = 1'b1;
                             o_mem_ce   = 1'b1;
                             o_mem_data ={i_reg2[15:0],i_reg2[15:0]};
                             case (i_mem_addr[1:0])
                                 2'b00:   begin
                                              o_mem_sel = 4'b1100;
                                          end

                                 2'b10:   begin
                                              o_mem_sel = 4'b0011;
                                          end

                                 default: begin
                                              
                                              o_mem_sel = 4'b0000;
                                          end
                             endcase
                          end
                `AluOp_SW:begin
                             o_mem_addr = i_mem_addr;
                             mem_we     = 1'b1;
                             o_mem_ce   = 1'b1;
                             o_mem_data = i_reg2;
                             case (i_mem_addr[1:0])
                                 2'b00:   begin
                                              o_mem_sel = 4'b1111;
                                          end

                                 default: begin
                                              
                                              o_mem_sel = 4'b0000;
                                          end
                             endcase
                          end
                `AluOp_SWL:begin
                             o_mem_addr = i_mem_addr;
                             mem_we     = 1'b1;
                             o_mem_ce   = 1'b1;
                             
                             case (i_mem_addr[1:0])
                                 2'b00:   begin
                                              o_mem_data = i_reg2;
                                              o_mem_sel = 4'b1111;
                                          end
                                 2'b01:   begin
                                              o_mem_data = {{8{1'b0}},i_reg2[31:8]};
                                              o_mem_sel = 4'b0111;
                                          end
                                 2'b10:   begin
                                              o_mem_data = {{16{1'b0}},i_reg2[31:16]};
                                              o_mem_sel = 4'b0011;
                                          end
                                 2'b11:   begin
                                              o_mem_data = {{24{1'b0}},i_reg2[31:24]};
                                              o_mem_sel = 4'b0001;
                                          end
                                 default: begin
                                              
                                              o_mem_sel = 4'b0000;
                                          end
                             endcase
                          end
                `AluOp_SWR:begin
                             o_mem_addr = i_mem_addr;
                             mem_we     = 1'b1;
                             o_mem_ce   = 1'b1;
                             
                             case (i_mem_addr[1:0])
                                 2'b00:   begin
                                              o_mem_data = {i_reg2[7:0],{24{1'b0}}};
                                              o_mem_sel = 4'b1000;
                                          end
                                 2'b01:   begin
                                              o_mem_data = {i_reg2[15:0],{16{1'b0}}};
                                              o_mem_sel = 4'b1100;
                                          end
                                 2'b10:   begin
                                              o_mem_data = {i_reg2[23:0],{8{1'b0}}};
                                              o_mem_sel = 4'b1110;
                                          end
                                 2'b11:   begin
                                              o_mem_data = i_reg2;
                                              o_mem_sel = 4'b1111;
                                          end
                                 default: begin
                                              
                                              o_mem_sel = 4'b0000;
                                          end
                             endcase
                          end
                `AluOp_SC:begin
                             if(LLBIT) begin
                                 o_mem_addr = i_mem_addr;
                                 mem_we     = 1'b1;
                                 o_mem_ce   = 1'b1;
                                 o_mem_data = i_reg2;
                                 o_LLbit_we = 1'b1;
                                 o_LLbit_value = 1'b0;
                                 case (i_mem_addr[1:0])
                                     2'b00:   begin
                                                  o_mem_sel = 4'b1111;
                                                  o_wdata = 32'b1;
                                              end
                                     default: begin
                                                  o_wdata = 32'b0;
                                                  o_mem_sel = 4'b0000;
                                              end
                                 endcase
                              end
                              else begin
                                  o_wdata = 32'b0;
                              end
                          end
                default: begin end
            endcase
        end
        
    end
    
    always @ (*) begin
        if(rst) begin
            LLBIT=1'b0;
        end
        else if(i_wb_LLbit_we) begin
            LLBIT = i_wb_LLbit_value;
        end
        else begin
            LLBIT = i_LLbit;
        end
    end
    
    always @ (*) begin
        if(rst) begin
            cp0_status = 32'b0;
        end
        else if(wb_cp0_reg_we == 1'b1 & wb_cp0_reg_write_addr == `CP0_REG_STATUS) begin
            cp0_status = wb_cp0_reg_data;
        end
        else begin
            cp0_status = i_cp0_status;
        end
    end
    always @ (*) begin
        if(rst) begin
            cp0_epc = 32'b0;
        end
        else if(wb_cp0_reg_we == 1'b1 & wb_cp0_reg_write_addr == `CP0_REG_EPC) begin
            cp0_epc = wb_cp0_reg_data;
        end
        else begin
            cp0_epc = i_cp0_epc;
        end
    end
    assign o_cp0_epc = cp0_epc;
    always @ (*) begin
        if(rst) begin
            cp0_cause = 32'b0;
        end
        else if(wb_cp0_reg_we == 1'b1 & wb_cp0_reg_write_addr == `CP0_REG_CAUSE) begin
            cp0_cause[9:8] = wb_cp0_reg_data[9:8];
            cp0_cause[23:22] = wb_cp0_reg_data[23:22];
        end
        else begin
            cp0_cause = i_cp0_cause;
        end
    end
    
    
	always @ (*) begin
		if(rst) begin
			o_excepttype = 32'b0;
		end else begin
			o_excepttype = 32'b0;
			if(i_current_inst_address != 32'b0) begin
				if(((cp0_cause[15:8] & (cp0_status[15:8])) != 8'h00) && (cp0_status[1] == 1'b0) && (cp0_status[0] == 1'b1)) begin
					o_excepttype = 32'h00000001;        //interrupt
				end 
				else if(i_excepttype[8] == 1'b1) begin
			  	    o_excepttype = 32'h00000008;        //syscall
				end 
				else if(i_excepttype[9] == 1'b1) begin
					o_excepttype = 32'h0000000a;        //inst_invalid
				end 
				else if(i_excepttype[10] ==1'b1) begin
					o_excepttype = 32'h0000000d;        //trap
				end 
				else if(i_excepttype[11] == 1'b1) begin  //ov
					o_excepttype = 32'h0000000c;
				end 
				else if(i_excepttype[12] == 1'b1) begin  //eret
					o_excepttype = 32'h0000000e;
				end
			end	
		end
	end	
endmodule
