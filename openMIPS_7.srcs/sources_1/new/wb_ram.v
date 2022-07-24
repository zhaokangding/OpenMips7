`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/22 16:56:00
// Design Name: 
// Module Name: wb_ram
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


module wb_ram(
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
    ram_adr_o   ,
    ram_wdat_o  ,
    ram_rdat_i  ,
    ram_we_o    
    );
    input             wb_clk_i   ;  
    input             wb_rst_i   ; 
    input      [31:0] wb_adr_i   ; 
    output reg [31:0] wb_dat_o   ; 
    input      [31:0] wb_dat_i   ; 
    input      [3:0]  wb_sel_i   ; 
    input             wb_we_i    ; 
    input             wb_stb_i   ; 
    input             wb_cyc_i   ; 
    output reg        wb_ack_o   ;
    output reg [15:0] ram_adr_o  ;
    output reg [7:0]  ram_wdat_o ;
    input      [7:0]  ram_rdat_i ;
    output reg        ram_we_o   ;
    
    
    wire wb_acc;
    wire wb_rd;
    wire wb_we;
    reg  [2:0] count;
    assign wb_acc = wb_cyc_i & wb_stb_i;
    assign wb_rd = wb_acc & !wb_we_i;
    assign wb_we =wb_acc & wb_we_i;
    always @ (posedge wb_clk_i, posedge wb_rst_i) begin
        if(wb_rst_i) begin
            wb_ack_o <= 1'b0;
            wb_dat_o <= 32'b0;
            ram_adr_o <= 16'b0;
            count    <= 3'b00;
            ram_we_o <= 1'b0;
            ram_wdat_o <= 8'b0;
            
        end
        else if(wb_rd) begin
            case(count)
                3'b000: 
                    begin
                        
                        count           <= count + 1;
                        ram_adr_o       <= {wb_adr_i[15:2],{2'b00}};
                    end
                3'b001:
                    begin
                        wb_dat_o[31:24] <= ram_rdat_i;
                        count           <= count + 1;
                        ram_adr_o       <= {wb_adr_i[15:2],{2'b01}};
                    end
                3'b010:
                    begin
                        wb_dat_o[23:16] <= ram_rdat_i;
                        count           <= count + 1;
                        ram_adr_o       <= {wb_adr_i[15:2],{2'b10}};
                    end
                3'b011:
                    begin
                        wb_dat_o[15:8]  <= ram_rdat_i;
                        count           <= count + 1;
                        ram_adr_o       <= {wb_adr_i[15:2],{2'b11}};
                        
                    end
                3'b100:
                    begin
                        wb_dat_o[7:0]   <= ram_rdat_i;
                        count           <= count + 1;
                        wb_ack_o        <= 1'b1;
                    end
                default: 
                    begin
                        wb_dat_o  <= 32'b0;
                        ram_adr_o <= 16'b0;
                        count     <= 3'b00;
                        wb_ack_o  <= 1'b0;
                    end
            endcase
        end
        else if(wb_we) begin
            case(count) 
                3'b000:
                    begin
                        count <= count + 1 ;
                        if(wb_sel_i[3]==1'b1) begin
                            ram_we_o  <= 1'b1;
                            ram_adr_o <= {wb_adr_i[15:2],{2'b00}};
                            ram_wdat_o <= wb_dat_i[31:24];
                        end
                    end
                3'b001:
                    begin
                        count <= count + 1 ;
                        if(wb_sel_i[2]==1'b1) begin
                            ram_we_o  <= 1'b1;
                            ram_adr_o <= {wb_adr_i[15:2],{2'b01}};
                            ram_wdat_o <= wb_dat_i[23:16];
                        end
                    end
                3'b010:
                    begin
                        count <= count + 1 ;
                        if(wb_sel_i[1]==1'b1) begin
                            ram_we_o  <= 1'b1;
                            ram_adr_o <= {wb_adr_i[15:2],{2'b10}};
                            ram_wdat_o <= wb_dat_i[15:8];
                        end
                    end
                3'b011:
                    begin
                        count <= count + 1 ;
                        if(wb_sel_i[0]==1'b1) begin
                            ram_we_o  <= 1'b1;
                            ram_adr_o <= {wb_adr_i[15:2],{2'b11}};
                            ram_wdat_o <= wb_dat_i[7:0];
                        end
                        wb_ack_o <= 1'b1;
                    end
                3'b110: 
                    begin
                        wb_ack_o <= 1'b0;
                    end
                default:
                    begin
                        
                        ram_we_o   <=  1'b0;
                        ram_adr_o  <=  16'b0;
                        ram_wdat_o <=  8'b0;
                    end
            endcase
        end
        else begin
            wb_ack_o  <= 1'b0;
            wb_dat_o  <= 32'b0;
            ram_adr_o <= 16'b0;
            count     <= 3'b000;
            ram_we_o  <= 1'b0;
            ram_wdat_o <= 8'b0;
        end
    
    end

endmodule
