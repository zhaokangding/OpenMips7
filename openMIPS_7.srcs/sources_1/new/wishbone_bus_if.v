`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/11 09:36:14
// Design Name: 
// Module Name: wishbone_bus_if
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

module wishbone_bus_if(
    clk             ,
	rst             ,
	stall_i         ,
	flush_i         ,
	cpu_ce_i        ,
	cpu_data_i      ,
	cpu_addr_i      ,
	cpu_we_i        ,
	cpu_sel_i       ,
	cpu_data_o      ,
	wishbone_data_i ,
	wishbone_ack_i  ,
	wishbone_addr_o ,
	wishbone_data_o ,
	wishbone_we_o   ,
	wishbone_sel_o  ,
	wishbone_stb_o  ,
	wishbone_cyc_o  ,
	stallreq	       
    );
    input			  clk             ;
	input 			  rst             ;
	input      [7:0]  stall_i         ;
	input             flush_i         ;
	input             cpu_ce_i        ;
	input      [31:0] cpu_data_i      ;
	input      [31:0] cpu_addr_i      ;
	input             cpu_we_i        ;
	input      [3:0]  cpu_sel_i       ;
	output reg [31:0] cpu_data_o      ;
	input      [31:0] wishbone_data_i ;
	input             wishbone_ack_i  ;
	output reg [31:0] wishbone_addr_o ;
	output reg [31:0] wishbone_data_o ;
	output reg        wishbone_we_o   ;
	output reg [3:0]  wishbone_sel_o  ;
	output reg        wishbone_stb_o  ;
	output reg        wishbone_cyc_o  ;
	output reg        stallreq	      ; 
    
    reg [1:0]  wishbone_state;
    reg [31:0] rd_buf;

	always @ (posedge clk,posedge rst) begin
		if(rst == 1'b1) begin
			wishbone_state <= `WB_IDLE;
			wishbone_addr_o <= 32'b0;
			wishbone_data_o <= 32'b0;
			wishbone_we_o <= 1'b0;
			wishbone_sel_o <= 4'b0000;
			wishbone_stb_o <= 1'b0;
			wishbone_cyc_o <= 1'b0;
			rd_buf <= 32'b0;
		end 
		else begin
			case (wishbone_state)
				`WB_IDLE:		
				 begin
					if((cpu_ce_i == 1'b1) && (flush_i == 1'b0)) begin
						wishbone_stb_o <= 1'b1;
						wishbone_cyc_o <= 1'b1;
						wishbone_addr_o <= cpu_addr_i;
						wishbone_data_o <= cpu_data_i;
						wishbone_we_o <= cpu_we_i;
						wishbone_sel_o <=  cpu_sel_i;
						wishbone_state <= `WB_BUSY;
						rd_buf <= 32'b0;
					end							
				end
				`WB_BUSY:		
				begin
					if(wishbone_ack_i == 1'b1) begin
						wishbone_stb_o <= 1'b0;
						wishbone_cyc_o <= 1'b0;
						wishbone_addr_o <= 32'b0;
						wishbone_data_o <= 32'b0;
						wishbone_we_o <= 1'b0;
						wishbone_sel_o <=  4'b0000;
						wishbone_state <= `WB_IDLE;
						if(cpu_we_i == 1'b0) begin
							rd_buf <= wishbone_data_i;
						end
						
						if(stall_i != 8'b00000000) begin
							wishbone_state <= `WB_WAIT_FOR_STALL;
						end					
					end 
					else if(flush_i == 1'b1) begin
					    wishbone_stb_o <= 1'b0;
						wishbone_cyc_o <= 1'b0;
						wishbone_addr_o <= 32'b0;
						wishbone_data_o <= 32'b0;
						wishbone_we_o <= 1'b0;
						wishbone_sel_o <=  4'b0000;
						wishbone_state <= `WB_IDLE;
						rd_buf <= 32'b0;
					end
				end
				`WB_WAIT_FOR_STALL:		
				begin
					if(stall_i == 8'b00000000) begin
						wishbone_state <= `WB_IDLE;
					end
				end
				default: 
				begin
				
				end 
			endcase
		end    
	end    
			

	always @ (*) begin
		if(rst == 1'b1) begin
			stallreq = 1'b0;
			cpu_data_o = 32'b0;
		end else begin
			stallreq = 1'b0;
			cpu_data_o = 32'b0;	
			case (wishbone_state)
				`WB_IDLE:		
				    begin
				    	if((cpu_ce_i == 1'b1) && (flush_i == 1'b0)) begin
				    		stallreq = 1'b1;
				    		cpu_data_o = 32'b0;				
				    	end
				    end
				`WB_BUSY:		
				    begin
				    	if(wishbone_ack_i == 1'b1) begin
				    		stallreq = 1'b0;
				    		if(wishbone_we_o == 1'b0) begin
				    			cpu_data_o = wishbone_data_i;  
				    		end 
				    		else begin
				    		  cpu_data_o = 32'b0;
				    		end							
				    	end 
				    	else begin
				    		stallreq = 1'b1;	
				    		cpu_data_o = 32'b0;				
				    	end
				    end
				`WB_WAIT_FOR_STALL:		
				    begin
				    	stallreq = 1'b0;
				    	cpu_data_o = rd_buf;
				    end
				default: 
				    begin
				    
				    end 
			endcase
		end    
	end      

endmodule
