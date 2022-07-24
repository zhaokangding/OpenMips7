`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/18 08:59:02
// Design Name: 
// Module Name: openmips
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


module openmips(
    clk              ,
    rst              ,
//    i_rom_data  ,
//    i_ram_data  ,
    i_int            ,
//    o_rom_ce    ,
//    o_rom_addr  ,
//    o_ram_addr  ,
//    o_ram_data  ,
//    o_ram_sel   ,
//    o_ram_we    , 
//    o_ram_ce    ,
    // inst wishbone
    iwishbone_data_i ,
    iwishbone_ack_i  ,
    iwishbone_addr_o ,
    iwishbone_data_o ,
    iwishbone_we_o   ,
    iwishbone_sel_o  ,
    iwishbone_stb_o  ,
    iwishbone_cyc_o  , 
    
    // data wishbone 
    dwishbone_data_i ,
    dwishbone_ack_i  ,
    dwishbone_addr_o ,
    dwishbone_data_o ,
    dwishbone_we_o   ,
    dwishbone_sel_o  ,
    dwishbone_stb_o  ,
    dwishbone_cyc_o  ,
    
    o_timer_int  
    );
    input         clk        ;
    input         rst        ;
//    input  [31:0] i_rom_data ;
//    input  [31:0] i_ram_data ;
    input  [5:0]  i_int      ;
//    output        o_rom_ce   ;
//    output [31:0] o_rom_addr ;
//    output [31:0] o_ram_addr ; 
//    output [31:0] o_ram_data ; 
//    output [3:0]  o_ram_sel  ;
//    output        o_ram_we   ;
//    output        o_ram_ce   ;
	input  [31:0] iwishbone_data_i;
	input         iwishbone_ack_i;
	output [31:0] iwishbone_addr_o;
	output [31:0] iwishbone_data_o;
	output        iwishbone_we_o;
	output [3:0]  iwishbone_sel_o;
	output        iwishbone_stb_o;
	output        iwishbone_cyc_o;
	
	input  [31:0] dwishbone_data_i;
	input         dwishbone_ack_i;
	output [31:0] dwishbone_addr_o;
	output [31:0] dwishbone_data_o;
	output        dwishbone_we_o;
	output [3:0]  dwishbone_sel_o;
	output        dwishbone_stb_o;
	output        dwishbone_cyc_o;
		
    output        o_timer_int;
    wire [31:0] inst_cpu_data;
    wire        stallreq_from_if;
    wire [31:0] data_cpu_data;
    wire        stallreq_from_mem;
    wire [31:0] i_rom_data;
    wire [31:0] i_ram_data;
    wire        o_rom_ce  ;
    wire [31:0] o_rom_addr;
    wire [31:0] o_ram_addr;
    wire [31:0] o_ram_data;
    wire [3:0]  o_ram_sel; 
    wire        o_ram_we;  
    wire        o_ram_ce;  
    wire        branch_flag;
    wire [31:0] branch_target_address;
    wire [7:0]  stall;
    wire        stallreq_from_id;
    wire        stallreq_from_ex;
    wire [4:0]  wb_wd;
    wire        wb_wreg;
    wire [31:0] wb_wdata;
    wire [31:0] id_pc;
    wire [31:0] id_inst;
    wire [31:0] rdata1;
    wire [31:0] rdata2;
    wire [31:0] id_reg1;
    wire [31:0] id_reg2;
    wire [7:0]  id_aluop;
    wire [2:0]  id_alusel;
    wire [4:0]  id_wd;
    wire        id_wreg;
    wire        re1;
    wire [4:0]  raddr1;
    wire        re2;
    wire [4:0]  raddr2;
    wire [4:0]  ex_res_wd;
    wire        ex_res_wreg;
    wire [31:0] ex_res_wdata;
    wire [4:0]  nop1_wd;
    wire        nop1_wreg;
    wire [31:0] nop1_wdata;
    wire [4:0]  nop2_wd;
    wire        nop2_wreg;
    wire [31:0] nop2_wdata;
    wire [4:0]  mem_res_wd;
    wire        mem_res_wreg;
    wire [31:0] mem_res_wdata;
    wire        next_inst_in_delayslot;
    wire        is_in_delayslot;
    wire        id_is_in_delayslot;
    wire [31:0] id_link_addr;
    wire [2:0]  ex_alusel;
    wire [7:0]  ex_aluop;  
    wire [31:0] ex_reg1;   
    wire [31:0] ex_reg2;  
    wire [4:0]  ex_wd;     
    wire        ex_wreg;  
    wire        ex_is_in_delayout;
    wire [31:0] ex_link_addr; 
    wire [31:0] ex_inst;
    wire [31:0] wb_hi;
    wire [31:0] wb_lo;
    wire        wb_whilo;
    wire [31:0] hi;
    wire [31:0] lo;
    
    wire        ex_whilo;
    wire [31:0] ex_hi;
    wire [31:0] ex_lo;
    wire        nop1_whilo;
    wire [31:0] nop1_hi;
    wire [31:0] nop1_lo;
    wire        nop2_whilo;
    wire [31:0] nop2_hi;
    wire [31:0] nop2_lo;
    wire        mem_res_whilo;
    wire [31:0] mem_res_hi;
    wire [31:0] mem_res_lo;
    wire [63:0] hilo_nop1_temp;
    wire [1:0]  cnt_nop1_temp;
    wire [63:0] hilo_ex_temp;
    wire [1:0]  cnt_ex_temp;
    wire [31:0] ex_mem_addr;
    wire [7:0]  ex_res_aluop;
    wire [31:0] ex_res_reg2;
    wire [7:0]  nop2_aluop;
    wire [31:0] nop2_mem_addr;
    wire [31:0] nop2_reg2;
    wire [4:0]  mem_wd;
    wire        mem_wreg;
    wire [31:0] mem_wdata;
    wire        mem_whilo;
    wire [31:0] mem_hi;
    wire [31:0] mem_lo;
    wire [7:0]  mem_aluop;
    wire [31:0] mem_mem_addr;
    wire [31:0] mem_reg2;
    wire [7:0]  nop1_aluop;
    wire [31:0] nop1_mem_addr;
    wire [31:0] nop1_reg2;
    wire        wb_LLbit_we;
    wire        wb_LLbit_value;
    wire        LLbit;
    wire        mem_res_LLbit_we;
    wire        mem_res_LLbit_value;
    wire [4:0]  cp0_raddr;
    wire [31:0] cp0_data;
    wire        flush; 
    wire [31:0] new_pc;
    wire [31:0] mem_res_excepttype;
    wire [31:0] mem_res_cp0_epc;
    wire [31:0] cp0_count  ;
    wire [31:0] cp0_compare;
    wire [31:0] cp0_status ;
    wire [31:0] cp0_cause  ;
    wire [31:0] cp0_epc    ;
    wire [31:0] cp0_config ;
    wire [31:0] cp0_prid   ;
    wire [31:0] id_res_inst;             
    wire [31:0] id_res_excepttype;       
    wire [31:0] id_res_current_inst_addr;
    wire [31:0] ex_excepttype;       
    wire [31:0] ex_current_inst_addr;
    wire        ex_cp0_reg_we        ;        
    wire [4:0]  ex_cp0_reg_write_addr;
    wire [31:0] ex_cp0_reg_data      ;      
    wire        nop1_cp0_reg_we;        
    wire [4:0]  nop1_cp0_reg_write_addr;
    wire [31:0] nop1_cp0_reg_data;
    wire        nop2_cp0_reg_we;        
    wire [4:0]  nop2_cp0_reg_write_addr;
    wire [31:0] nop2_cp0_reg_data;
    wire        mem_cp0_reg_we;        
    wire [4:0]  mem_cp0_reg_write_addr;
    wire [31:0] mem_cp0_reg_data;
    wire        mem_res_cp0_reg_we;        
    wire [4:0]  mem_res_cp0_reg_write_addr;
    wire [31:0] mem_res_cp0_reg_data;
    wire        wb_cp0_reg_we;        
    wire [4:0]  wb_cp0_reg_write_addr;
    wire [31:0] wb_cp0_reg_data;
    wire [31:0] ex_res_excepttype;       
    wire [31:0] ex_res_current_inst_addr;
    wire        ex_res_is_in_delayslot;
    wire [31:0] nop1_excepttype;       
    wire [31:0] nop1_current_inst_addr;
    wire        nop1_is_in_delayslot;
    wire [31:0] nop2_excepttype;       
    wire [31:0] nop2_current_inst_addr;
    wire        nop2_is_in_delayslot;
    wire [31:0] mem_excepttype;       
    wire [31:0] mem_current_inst_addr;
    wire        mem_is_in_delayslot;
      
    wire [31:0] mem_res_current_inst_addr;
    wire        mem_res_is_in_delayslot;
    ctrl ctrl0(
    .rst              (rst),
    .stallreq_from_if (stallreq_from_if),
    .stallreq_from_id (stallreq_from_id),
    .stallreq_from_ex (stallreq_from_ex),
    .stallreq_from_mem (stallreq_from_mem),
    .stall            (stall),
    .i_cp0_epc        (mem_res_cp0_epc),
    .i_excepttype     (mem_res_excepttype),
    .new_pc           (new_pc),
    .flush            (flush) 
    );
    pc_reg pc_reg0(
    .rst                     (rst),
    .clk                     (clk),
    .i_branch_flag           (branch_flag),
    .i_branch_target_address (branch_target_address),
    .flush                   (flush),
    .new_pc                  (new_pc),
    .stall                   (stall),
    .pc                      (o_rom_addr),
    .ce                      (o_rom_ce)
    );
    
    wishbone_bus_if wishbone_bus_if0(
    .clk             (clk),
	.rst             (rst),
	.stall_i         (stall),
	.flush_i         (flush),
	.cpu_ce_i        (o_rom_ce),
	.cpu_data_i      (32'b0),
	.cpu_addr_i      (o_rom_addr),
	.cpu_we_i        (1'b0),
	.cpu_sel_i       (4'b1111),
	.cpu_data_o      (inst_cpu_data),
	.wishbone_data_i (iwishbone_data_i),
	.wishbone_ack_i  (iwishbone_ack_i),
	.wishbone_addr_o (iwishbone_addr_o ),
	.wishbone_data_o (iwishbone_data_o ),
	.wishbone_we_o   (iwishbone_we_o   ),
	.wishbone_sel_o  (iwishbone_sel_o  ),
	.wishbone_stb_o  (iwishbone_stb_o  ),
	.wishbone_cyc_o  (iwishbone_cyc_o  ),
	.stallreq	     (stallreq_from_if)  
    );
    
    if_id if_id0(
    .rst     (rst),
    .clk     (clk),
    .if_pc   (o_rom_addr),
    .if_inst (inst_cpu_data),
    .stall   (stall),
    .flush   (flush),
    .id_pc   (id_pc),
    .id_inst (id_inst)
    );
    
    
    regfile regfile0(
    .rst    (rst),
    .clk    (clk),
    .waddr  (wb_wd),
    .wdata  (wb_wdata),
    .we     (wb_wreg),
    .raddr1 (raddr1),
    .re1    (re1),
    .rdata1 (rdata1),
    .raddr2 (raddr2),
    .re2    (re2),
    .rdata2 (rdata2)
    );
    
    
    
    
    id id0(
    .rst                       (rst),
    .i_pc                      (id_pc),
    .i_inst                    (id_inst),
    .i_reg1_data               (rdata1),
    .i_reg2_data               (rdata2),
    .i_ex_wreg                 (ex_res_wreg),
    .i_ex_wd                   (ex_res_wd),
    .i_ex_wdata                (ex_res_wdata),
    .i_nop1_wreg               (nop1_wreg),
    .i_nop1_wd                 (nop1_wd),
    .i_nop1_wdata              (nop1_wdata),
    .i_nop2_wreg               (nop2_wreg),
    .i_nop2_wd                 (nop2_wd),
    .i_nop2_wdata              (nop2_wdata),
    .i_mem_wreg                (mem_res_wreg),
    .i_mem_wd                  (mem_res_wd),
    .i_mem_wdata               (mem_res_wdata),
    .i_ex_aluop                (ex_res_aluop),
    .i_nop1_aluop              (nop1_aluop),
    .i_nop2_aluop              (nop2_aluop),
    .i_is_in_delayslot         (is_in_delayslot),
    .o_reg1_read               (re1),
    .o_reg2_read               (re2),
    .o_reg1_addr               (raddr1),
    .o_reg2_addr               (raddr2),
    .o_aluop                   (id_aluop),
    .o_alusel                  (id_alusel),
    .o_reg1                    (id_reg1),
    .o_reg2                    (id_reg2),
    .o_wd                      (id_wd),
    .o_wreg                    (id_wreg),
    .o_branch_flag             (branch_flag),
    .o_branch_target_address   (branch_target_address),
    .o_is_in_delayslot         (id_is_in_delayslot),
    .o_link_addr               (id_link_addr),
    .o_next_inst_in_delayslot  (next_inst_in_delayslot),
    .o_inst                    (id_res_inst),
    .o_excepttype              (id_res_excepttype),
    .o_current_inst_addr       (id_res_current_inst_addr),
    .stallreq                  (stallreq_from_id)
    );
    
    
    id_ex id_ex0(
    .rst                      (rst),
    .clk                      (clk),
    .id_alusel                (id_alusel),
    .id_aluop                 (id_aluop),
    .id_reg1                  (id_reg1),
    .id_reg2                  (id_reg2),
    .id_wd                    (id_wd),
    .id_wreg                  (id_wreg),
    .stall                    (stall),
    .flush                    (flush),
    .id_excepttype            (id_res_excepttype),
    .id_current_inst_addr     (id_res_current_inst_addr),
    .id_is_in_delayslot       (id_is_in_delayslot),
    .id_link_addr             (id_link_addr),
    .i_next_inst_in_delayslot (next_inst_in_delayslot),
    .id_inst                  (id_inst),
    .ex_inst                  (ex_inst),
    .ex_is_in_delayslot       (ex_is_in_delayout),
    .ex_link_addr             (ex_link_addr),
    .o_is_in_delayslot        (is_in_delayslot),
    .ex_excepttype            (ex_excepttype),
    .ex_current_inst_addr     (ex_current_inst_addr),
    .ex_alusel                (ex_alusel),
    .ex_aluop                 (ex_aluop),
    .ex_reg1                  (ex_reg1),
    .ex_reg2                  (ex_reg2),
    .ex_wd                    (ex_wd),
    .ex_wreg                  (ex_wreg)
    );
    
    
    
    
    
    ex ex0(
    .rst                    (rst),
    .i_alusel               (ex_alusel),
    .i_aluop                (ex_aluop),
    .i_reg1                 (ex_reg1),
    .i_reg2                 (ex_reg2),
    .i_wd                   (ex_wd),
    .i_wreg                 (ex_wreg),
    .i_excepttype           (ex_excepttype       ),
    .i_current_inst_addr    (ex_current_inst_addr),
    .i_is_in_delayslot      (ex_is_in_delayout),
    .i_link_address         (ex_link_addr),
    .i_hilo_temp            (hilo_nop1_temp),
    .i_cnt                  (cnt_nop1_temp),
    .o_hilo_temp            (hilo_ex_temp),
    .o_cnt                  (cnt_ex_temp),
    .o_excepttype           (ex_res_excepttype       ),
    .o_current_inst_addr    (ex_res_current_inst_addr),
    .o_is_in_delatslot      (ex_res_is_in_delayslot),
    .o_wd                   (ex_res_wd),
    .o_wreg                 (ex_res_wreg),
    .o_wdata                (ex_res_wdata),
    .o_signed_div           (),
    .o_div_opdata1          (),
    .o_div_opdata2          (),
    .o_div_start            (),
    .i_div_result           (),
    .i_div_ready            (),
    .i_hi                   (hi),
    .i_lo                   (lo),
    .i_nop1_whilo           (nop1_whilo),
    .i_nop1_hi              (nop1_hi   ),
    .i_nop1_lo              (nop1_lo   ),
    .i_nop2_whilo           (nop2_whilo),
    .i_nop2_hi              (nop2_hi   ),
    .i_nop2_lo              (nop2_lo   ),
    .i_mem_whilo            (mem_res_whilo),
    .i_mem_hi               (mem_res_hi   ),
    .i_mem_lo               (mem_res_lo   ),
    .i_wb_whilo             (wb_whilo),
    .i_wb_hi                (wb_hi   ),
    .i_wb_lo                (wb_lo   ),
    .o_whilo                (ex_whilo),
    .o_hi                   (ex_hi),
    .o_lo                   (ex_lo),
    .i_cp0_reg_data         (cp0_data),
    .nop1_cp0_reg_we        (nop1_cp0_reg_we        ),
    .nop1_cp0_reg_write_addr(nop1_cp0_reg_write_addr),
    .nop1_cp0_reg_data      (nop1_cp0_reg_data      ),
    .nop2_cp0_reg_we        (nop2_cp0_reg_we        ),
    .nop2_cp0_reg_write_addr(nop2_cp0_reg_write_addr),
    .nop2_cp0_reg_data      (nop2_cp0_reg_data      ),
    .mem_cp0_reg_we         (mem_res_cp0_reg_we        ),
    .mem_cp0_reg_write_addr (mem_res_cp0_reg_write_addr),
    .mem_cp0_reg_data       (mem_res_cp0_reg_data      ),
    .wb_cp0_reg_we          (wb_cp0_reg_we        ),
    .wb_cp0_reg_write_addr  (wb_cp0_reg_write_addr),
    .wb_cp0_reg_data        (wb_cp0_reg_data      ),
    .o_cp0_reg_read_addr    (cp0_raddr),
    .o_cp0_reg_we           (ex_cp0_reg_we        ),
    .o_cp0_reg_write_addr   (ex_cp0_reg_write_addr),
    .o_cp0_reg_data         (ex_cp0_reg_data      ),
    .i_inst                 (ex_inst),
    .o_aluop                (ex_res_aluop),
    .o_mem_addr             (ex_mem_addr),
    .o_reg2                 (ex_res_reg2),
    .stallreq               (stallreq_from_ex)
    );
    
    
    ex_regnop1 ex_regnop10(                               
    .rst                      (rst),              
    .clk                      (clk),              
    .ex_wd                    (ex_res_wd),        
    .ex_wreg                  (ex_res_wreg),      
    .ex_wdata                 (ex_res_wdata),     
    .nop1_wd                  (nop1_wd),           
    .nop1_wreg                (nop1_wreg),         
    .nop1_wdata               (nop1_wdata),        
    .stall                    (stall),                 
    .flush                    (flush),                 
    .ex_cp0_reg_we            (ex_cp0_reg_we        ),                 
    .ex_cp0_reg_write_addr    (ex_cp0_reg_write_addr),                 
    .ex_cp0_reg_data          (ex_cp0_reg_data      ),                 
    .nop1_cp0_reg_we          (nop1_cp0_reg_we        ),                 
    .nop1_cp0_reg_write_addr  (nop1_cp0_reg_write_addr),                 
    .nop1_cp0_reg_data        (nop1_cp0_reg_data      ),                 
    .ex_aluop                 (ex_res_aluop),                 
    .ex_mem_addr              (ex_mem_addr),                 
    .ex_reg2                  (ex_res_reg2),                 
    .nop1_aluop               (nop1_aluop),                 
    .nop1_mem_addr            (nop1_mem_addr),                 
    .nop1_reg2                (nop1_reg2),                 
    .ex_whilo                 (ex_whilo),                 
    .ex_hi                    (ex_hi),                 
    .ex_lo                    (ex_lo),                 
    .nop1_whilo               (nop1_whilo),                 
    .nop1_hi                  (nop1_hi),                 
    .nop1_lo                  (nop1_lo),                 
    .ex_excepttype            (ex_res_excepttype          ),                 
    .ex_current_inst_address  (ex_res_current_inst_addr),                 
    .ex_is_in_delayslot       (ex_res_is_in_delayslot     ),                 
    .nop1_excepttype          (nop1_excepttype          ),                 
    .nop1_current_inst_address(nop1_current_inst_addr),                 
    .nop1_is_in_delayslot     (nop1_is_in_delayslot     ),                 
    .i_hilo                   (hilo_ex_temp),                 
    .i_cnt                    (cnt_ex_temp),                 
    .o_hilo                   (hilo_nop1_temp),                 
    .o_cnt                    (cnt_nop1_temp)                  
    );                                            
    
       
    
    regnop1_regnop2 regnop1_regnop20(                               
    .rst                      (rst),              
    .clk                      (clk),              
    .nop1_wd                  (nop1_wd),        
    .nop1_wreg                (nop1_wreg),      
    .nop1_wdata               (nop1_wdata),     
    .nop2_wd                  (nop2_wd),           
    .nop2_wreg                (nop2_wreg),         
    .nop2_wdata               (nop2_wdata),        
    .stall                    (stall),                 
    .flush                    (flush),                 
    .nop1_cp0_reg_we          (nop1_cp0_reg_we        ),                 
    .nop1_cp0_reg_write_addr  (nop1_cp0_reg_write_addr),                 
    .nop1_cp0_reg_data        (nop1_cp0_reg_data      ),                 
    .nop2_cp0_reg_we          (nop2_cp0_reg_we        ),                 
    .nop2_cp0_reg_write_addr  (nop2_cp0_reg_write_addr),                 
    .nop2_cp0_reg_data        (nop2_cp0_reg_data      ),                 
    .nop1_aluop               (nop1_aluop   ),                 
    .nop1_mem_addr            (nop1_mem_addr),                 
    .nop1_reg2                (nop1_reg2    ),                 
    .nop2_aluop               (nop2_aluop   ),                 
    .nop2_mem_addr            (nop2_mem_addr),                 
    .nop2_reg2                (nop2_reg2    ),                 
    .nop1_whilo               (nop1_whilo),                 
    .nop1_hi                  (nop1_hi   ),                 
    .nop1_lo                  (nop1_lo   ),                 
    .nop2_whilo               (nop2_whilo),                 
    .nop2_hi                  (nop2_hi   ),                 
    .nop2_lo                  (nop2_lo   ),                 
    .nop1_excepttype          (nop1_excepttype          ),                 
    .nop1_current_inst_address(nop1_current_inst_addr),                 
    .nop1_is_in_delayslot     (nop1_is_in_delayslot     ),                 
    .nop2_excepttype          (nop2_excepttype          ),                 
    .nop2_current_inst_address(nop2_current_inst_addr),                 
    .nop2_is_in_delayslot     (nop2_is_in_delayslot     )                
    );

    
    
    regnop2_mem regnop2_mem0(                               
    .rst                      (rst),              
    .clk                      (clk),              
    .nop2_wd                  (nop2_wd),        
    .nop2_wreg                (nop2_wreg),      
    .nop2_wdata               (nop2_wdata),     
    .mem_wd                   (mem_wd),           
    .mem_wreg                 (mem_wreg),         
    .mem_wdata                (mem_wdata),        
    .stall                    (stall),                 
    .flush                    (flush),                 
    .nop2_cp0_reg_we          (nop2_cp0_reg_we        ),                 
    .nop2_cp0_reg_write_addr  (nop2_cp0_reg_write_addr),                 
    .nop2_cp0_reg_data        (nop2_cp0_reg_data      ),                 
    .mem_cp0_reg_we           (mem_cp0_reg_we        ),                 
    .mem_cp0_reg_write_addr   (mem_cp0_reg_write_addr),                 
    .mem_cp0_reg_data         (mem_cp0_reg_data      ),                 
    .nop2_aluop               (nop2_aluop    ),                 
    .nop2_mem_addr            (nop2_mem_addr ),                 
    .nop2_reg2                (nop2_reg2     ),                 
    .mem_aluop                (mem_aluop   ),                 
    .mem_mem_addr             (mem_mem_addr),                 
    .mem_reg2                 (mem_reg2    ),                 
    .nop2_whilo               (nop2_whilo),                 
    .nop2_hi                  (nop2_hi   ),                 
    .nop2_lo                  (nop2_lo   ),                 
    .mem_whilo                (mem_whilo),                 
    .mem_hi                   (mem_hi   ),                 
    .mem_lo                   (mem_lo   ),                 
    .nop2_excepttype          (nop2_excepttype          ),                 
    .nop2_current_inst_address(nop2_current_inst_addr),                 
    .nop2_is_in_delayslot     (nop2_is_in_delayslot     ),                 
    .mem_excepttype           (mem_excepttype          ),                 
    .mem_current_inst_address (mem_current_inst_addr),                 
    .mem_is_in_delayslot      (mem_is_in_delayslot     )                
    );
// five level piple line    
//    ex_mem ex_mem0(
//    .rst                      (rst),
//    .clk                      (clk),
//    .ex_wd                    (ex_res_wd),
//    .ex_wreg                  (ex_res_wreg),
//    .ex_wdata                 (ex_res_wdata),
//    .mem_wd                   (mem_wd),
//    .mem_wreg                 (mem_wreg),
//    .mem_wdata                (mem_wdata),
//    .stall                    (),
//    .flush                    (),
//    .ex_cp0_reg_we            (),
//    .ex_cp0_reg_write_addr    (),
//    .ex_cp0_reg_data          (),
//    .mem_cp0_reg_we           (),
//    .mem_cp0_reg_write_addr   (),
//    .mem_cp0_reg_data         (),
//    .ex_aluop                 (),
//    .ex_mem_addr              (),
//    .ex_reg2                  (),
//    .mem_aluop                (),
//    .mem_mem_addr             (),
//    .mem_reg2                 (),
//    .ex_whilo                 (),
//    .ex_hi                    (),
//    .ex_lo                    (),
//    .mem_whilo                (),
//    .mem_hi                   (),
//    .men_lo                   (),
//    .ex_excepttype            (),
//    .ex_current_inst_address  (),
//    .ex_is_in_delayslot       (),
//    .mem_excepttype           (),
//    .mem_current_inst_address (),
//    .mem_is_in_delayslot      (),
//    .i_hilo                   (),
//    .i_cnt                    (),
//    .o_hilo                   (),
//    .o_cnt                    ()
//    );
    
    
    
    mem mem0(
    .rst                      (rst),
    .i_wd                     (mem_wd),
    .i_wreg                   (mem_wreg),
    .i_wdata                  (mem_wdata),
    .o_wd                     (mem_res_wd),
    .o_wreg                   (mem_res_wreg),
    .o_wdata                  (mem_res_wdata),
    .i_aluop                  (mem_aluop   ),
    .i_mem_addr               (mem_mem_addr),
    .i_reg2                   (mem_reg2    ),
    .i_mem_data               (data_cpu_data),
    .o_mem_addr               (o_ram_addr),
    .o_mem_we                 (o_ram_we),
    .o_mem_sel                (o_ram_sel),
    .o_mem_data               (o_ram_data),
    .o_mem_ce                 (o_ram_ce),
    .i_whilo                  (mem_whilo),
    .i_hi                     (mem_hi   ),
    .i_lo                     (mem_lo   ),
    .o_whilo                  (mem_res_whilo),
    .o_hi                     (mem_res_hi   ),
    .o_lo                     (mem_res_lo   ),
    .i_cp0_reg_we             (mem_cp0_reg_we        ),
    .i_cp0_reg_write_addr     (mem_cp0_reg_write_addr),
    .i_cp0_reg_data           (mem_cp0_reg_data      ),
    .o_cp0_reg_we             (mem_res_cp0_reg_we        ),
    .o_cp0_reg_write_addr     (mem_res_cp0_reg_write_addr),
    .o_cp0_reg_data           (mem_res_cp0_reg_data      ),
    .i_excepttype             (mem_excepttype          ),
    .i_current_inst_address   (mem_current_inst_addr),
    .i_is_in_delayslot        (mem_is_in_delayslot     ),
    .i_cp0_status             (cp0_status),
    .i_cp0_cause              (cp0_cause ),
    .i_cp0_epc                (cp0_epc   ),
    .wb_cp0_reg_we            (wb_cp0_reg_we        ),
    .wb_cp0_reg_write_addr    (wb_cp0_reg_write_addr),
    .wb_cp0_reg_data          (wb_cp0_reg_data      ),
    .o_excepttype             (mem_res_excepttype          ),
    .o_current_inst_address   (mem_res_current_inst_addr),
    .o_is_in_delayslot        (mem_res_is_in_delayslot     ),
    .o_cp0_epc                (mem_res_cp0_epc),
    .i_LLbit                  (LLbit),
    .i_wb_LLbit_we            (wb_LLbit_we   ),
    .i_wb_LLbit_value         (wb_LLbit_value),
    .o_LLbit_we               (mem_res_LLbit_we   ),
    .o_LLbit_value            (mem_res_LLbit_value)
    );
    
    wishbone_bus_if wishbone_bus_if1(
    .clk             (clk),
	.rst             (rst),
	.stall_i         (stall),
	.flush_i         (flush),
	.cpu_ce_i        (o_ram_ce),
	.cpu_data_i      (o_ram_data),
	.cpu_addr_i      (o_ram_addr),
	.cpu_we_i        (o_ram_we),
	.cpu_sel_i       (o_ram_sel),
	.cpu_data_o      (data_cpu_data),
	.wishbone_data_i (dwishbone_data_i),
	.wishbone_ack_i  (dwishbone_ack_i ),
	.wishbone_addr_o (dwishbone_addr_o),
	.wishbone_data_o (dwishbone_data_o),
	.wishbone_we_o   (dwishbone_we_o  ),
	.wishbone_sel_o  (dwishbone_sel_o ),
	.wishbone_stb_o  (dwishbone_stb_o ),
	.wishbone_cyc_o  (dwishbone_cyc_o ),
	.stallreq	     (stallreq_from_mem)  
    );
    
    
    mem_wb mem_wb0(
    .rst                    (rst),
    .clk                    (clk),
    .mem_wd                 (mem_res_wd),
    .mem_wreg               (mem_res_wreg),
    .mem_wdata              (mem_res_wdata),
    .wb_wd                  (wb_wd),
    .wb_wreg                (wb_wreg),
    .wb_wdata               (wb_wdata),
    .mem_LLbit_we           (mem_res_LLbit_we   ),
    .mem_LLbit_value        (mem_res_LLbit_value),
    .wb_LLbit_we            (wb_LLbit_we),
    .wb_LLbit_value         (wb_LLbit_value),
    .mem_cp0_reg_we         (mem_res_cp0_reg_we        ),
    .mem_cp0_reg_write_addr (mem_res_cp0_reg_write_addr),
    .mem_cp0_reg_data       (mem_res_cp0_reg_data      ),
    .wb_cp0_reg_we          (wb_cp0_reg_we        ),
    .wb_cp0_reg_write_addr  (wb_cp0_reg_write_addr),
    .wb_cp0_reg_data        (wb_cp0_reg_data      ),
    .mem_whilo              (mem_res_whilo),
    .mem_hi                 (mem_res_hi   ),
    .mem_lo                 (mem_res_lo   ),
    .wb_whilo               (wb_whilo),
    .wb_hi                  (wb_hi   ),
    .wb_lo                  (wb_lo   ),
    .stall                  (stall),
    .flush                  (flush)
    );
    
    hilo_reg hilo_reg0(
    .rst  (rst),
    .clk  (clk),
    .we   (wb_whilo),
    .i_hi (wb_hi),
    .i_lo (wb_lo),
    .o_hi (hi),
    .o_lo (lo)
    );
    
    LLbit_reg LLbit_reg0(
    .rst     (rst),
    .clk     (clk),
    .flush   (flush),
    .we      (wb_LLbit_we),
    .i_LLbit (wb_LLbit_value),
    .o_LLbit (LLbit)
    );
    
    
    
    cp0_reg cp0_reg0(
    .rst                    (rst),
    .clk                    (clk),
    .i_raddr                (cp0_raddr),
    .i_int                  (i_int),
    .i_we                   (wb_cp0_reg_we),
    .i_waddr                (wb_cp0_reg_write_addr),
    .i_wdata                (wb_cp0_reg_data),
    .o_data                 (cp0_data),
    .o_count                (cp0_count  ),
    .o_compare              (cp0_compare),
    .o_status               (cp0_status ),
    .o_cause                (cp0_cause  ),
    .o_epc                  (cp0_epc    ),
    .o_config               (cp0_config ),
    .o_prid                 (cp0_prid   ),
    .o_timer_int            (o_timer_int),
    .i_excepttype           (mem_res_excepttype       ),
    .i_current_inst_addr    (mem_res_current_inst_addr),
    .i_is_in_delayslot      (mem_res_is_in_delayslot  )
    );
endmodule
