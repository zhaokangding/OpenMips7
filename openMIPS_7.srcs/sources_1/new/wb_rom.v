`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/21 14:44:23
// Design Name: 
// Module Name: wb_rom
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


module wb_rom(
    wb_clk_i    ,      
    wb_rst_i    ,      
    wb_adr_i    ,
    wb_dat_o    ,
    wb_dat_i    ,
    wb_sel_i    ,
    wb_we_i     ,      
    wb_stb_i    ,        
    wb_cyc_i    ,        
    wb_ack_o    ,        
    rom_adr_o   ,
    rom_dat_i 
    );
    input             wb_clk_i  ;  
    input             wb_rst_i  ; 
    input      [31:0] wb_adr_i  ; 
    output reg [31:0] wb_dat_o  ; 
    input      [31:0] wb_dat_i  ; 
    input      [3:0]  wb_sel_i  ; 
    input             wb_we_i   ; 
    input             wb_stb_i  ; 
    input             wb_cyc_i  ; 
    output reg        wb_ack_o  ; 
    output     [15:0] rom_adr_o ;
    input      [31:0] rom_dat_i ; 
    
    wire wb_acc;
    wire wb_rd;
    reg  [1:0] count;
    assign wb_acc = wb_cyc_i & wb_stb_i;
    assign wb_rd = wb_acc & !wb_we_i;
    assign rom_adr_o = wb_adr_i[17:2];
//    assign wb_dat_o  = rom_dat_i;
    always @ (posedge wb_clk_i, posedge wb_rst_i) begin
        if(wb_rst_i) begin
            wb_ack_o <= 1'b0;
            wb_dat_o <= 32'b0;
        end
        else if(wb_rd) begin
            wb_ack_o <= 1'b1;
            wb_dat_o <= rom_dat_i;
        end
        else begin
            wb_ack_o <= 1'b0;
            wb_dat_o <= 32'b0;
        end
    
    end
    
endmodule
