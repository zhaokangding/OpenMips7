`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/19 19:29:09
// Design Name: 
// Module Name: define
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


`define OP_ORI      6'b001101
`define OP_XORI     6'b001110
`define OP_LUI      6'b001111
`define OP_ANDI     6'b001100
`define OP_R        6'b000000
`define OP_R2       6'b011100
`define OP_ADDI     6'b001000
`define OP_ADDIU    6'b001001
`define OP_SLTI     6'b001010
`define OP_SLTIU    6'b001011
`define OP_J        6'b000010
`define OP_JAL      6'b000011
`define OP_BEQ      6'b000100
`define OP_B        6'b000100
`define OP_BGTZ     6'b000111
`define OP_BLEZ     6'b000110
`define OP_BNE      6'b000101
`define OP_REGIMM   6'b000001
`define OP_LB       6'b100000
`define OP_LBU      6'b100100
`define OP_LH       6'b100001
`define OP_LHU      6'b100101
`define OP_LW       6'b100011
`define OP_SB       6'b101000
`define OP_SH       6'b101001
`define OP_SW       6'b101011
`define OP_LWL      6'b100010
`define OP_LWR      6'b100110
`define OP_SWL      6'b101010
`define OP_SWR      6'b101110
`define OP_LL       6'b110000
`define OP_SC       6'b111000
`define OP_COP0     6'b010000

`define Funct_BLTZ    5'b00000
`define Funct_BLTZAL  5'b10000       
`define Funct_BGEZ    5'b00001
`define Funct_BGEZAL  5'b10001
`define Funct_BAL     5'b10001

`define Funct_MT      5'b00100
`define Funct_MF      5'b00000

`define Funct_TEQI    5'b01100
`define Funct_TGEI    5'b01000
`define Funct_TGEIU   5'b01001
`define Funct_TLTI    5'b01010
`define Funct_TLTIU   5'b01011
`define Funct_TNEI    5'b01110

`define Funct_AND   6'b100100
`define Funct_OR    6'b100101
`define Funct_XOR   6'b100110
`define Funct_NOR   6'b100111
`define Funct_SLL   6'b000000
`define Funct_SRL   6'b000010
`define Funct_SRA   6'b000011
`define Funct_SLLV  6'b000100
`define Funct_SRLV  6'b000110
`define Funct_SRAV  6'b000111
`define Funct_MOVN  6'b001011
`define Funct_MOVZ  6'b001010
`define Funct_MFHI  6'b010000
`define Funct_MFLO  6'b010010
`define Funct_MTHI  6'b010001
`define Funct_MTLO  6'b010011
`define Funct_ADD   6'b100000
`define Funct_ADDU  6'b100001
`define Funct_SUB   6'b100010
`define Funct_SUBU  6'b100011
`define Funct_SLT   6'b101010
`define Funct_SLTU  6'b101011
`define Funct_MULT  6'b011000
`define Funct_MULTU 6'b011001
`define Funct_DIV   6'b011010
`define Funct_DIVU  6'b011011
`define Funct_MADD  6'b000000
`define Funct_MADDU 6'b000001
`define Funct_MSUB  6'b000100
`define Funct_MSUBU 6'b000101
`define Funct_CLZ   6'b100000
`define Funct_CLO   6'b100001
`define Funct_MUL   6'b000010
`define Funct_JR    6'b001000
`define Funct_JALR  6'b001001
`define Funct_TEQ   6'b110100
`define Funct_TGE   6'b110000
`define Funct_TGEU  6'b110001
`define Funct_TLT   6'b110010
`define Funct_TLTU  6'b110011
`define Funct_TNE   6'b110110
`define Funct_SYSCALL 6'b001100
`define Funct_ERET  6'b011000


`define AluOp_ERROR   8'bxxxxxxxx
`define AluOp_ORI     8'b0000_0001
`define AluOp_XORI    8'b0000_0010
`define AluOp_LUI     8'b0000_0011
`define AluOp_ANDI    8'b0000_0100
`define AluOp_AND     8'b0000_0101
`define AluOp_OR      8'b0000_0110
`define AluOp_XOR     8'b0000_0111
`define AluOp_NOR     8'b0000_1000
`define AluOp_SLL     8'b0000_1001
`define AluOp_SRL     8'b0000_1010
`define AluOp_SRA     8'b0000_1011
`define AluOp_SLLV    8'b0000_1100
`define AluOp_SRLV    8'b0000_1101
`define AluOp_SRAV    8'b0000_1110
`define AluOp_MOVN    8'b0000_1111
`define AluOp_MOVZ    8'b0001_0000
`define AluOp_MFHI    8'b0001_0001
`define AluOp_MFLO    8'b0001_0010
`define AluOp_MTHI    8'b0001_0011
`define AluOp_MTLO    8'b0001_0100
`define AluOp_ADD     8'b0001_0101
`define AluOp_ADDU    8'b0001_0110
`define AluOp_SUB     8'b0001_0111
`define AluOp_SUBU    8'b0001_1000
`define AluOp_SLT     8'b0001_1001
`define AluOp_SLTU    8'b0001_1010
`define AluOp_MULT    8'b0001_1011
`define AluOp_MULTU   8'b0001_1100
`define AluOp_DIV     8'b0001_1101
`define AluOp_DIVU    8'b0001_1110
`define AluOp_MADD    8'b0001_1111
`define AluOp_MADDU   8'b0010_0000
`define AluOp_MSUB    8'b0010_0001
`define AluOp_MSUBU   8'b0010_0010
`define AluOp_CLZ     8'b0010_0011
`define AluOp_CLO     8'b0010_0100
`define AluOp_MUL     8'b0010_0101
`define AluOp_ADDI    8'b0010_0110
`define AluOp_ADDIU   8'b0010_0111
`define AluOp_SLTI    8'b0010_1000
`define AluOp_SLTIU   8'b0010_1001
`define AluOp_JR      8'b0010_1010
`define AluOp_JALR    8'b0010_1011
`define AluOp_J       8'b0010_1100
`define AluOp_JAL     8'b0010_1101
`define AluOp_BEQ     8'b0010_1110
`define AluOp_B       8'b0010_1111
`define AluOp_BGTZ    8'b0011_0000
`define AluOp_BLEZ    8'b0011_0001
`define AluOp_BNE     8'b0011_0010
`define AluOp_BLTZ    8'b0011_0011
`define AluOp_BLTZAL  8'b0011_0100
`define AluOp_BGEZ    8'b0011_0101
`define AluOp_BGEZAL  8'b0011_0110
`define AluOp_BAL     8'b0011_0111
`define AluOp_LB      8'b0011_1000 
`define AluOp_LBU     8'b0011_1001
`define AluOp_LH      8'b0011_1010
`define AluOp_LHU     8'b0011_1011
`define AluOp_LW      8'b0011_1100
`define AluOp_SB      8'b0011_1101
`define AluOp_SH      8'b0011_1110
`define AluOp_SW      8'b0011_1111
`define AluOp_LWL     8'b0100_0000
`define AluOp_LWR     8'b0100_0001
`define AluOp_SWL     8'b0100_0010
`define AluOp_SWR     8'b0100_0011
`define AluOp_LL      8'b0100_0100
`define AluOp_SC      8'b0100_0101
`define AluOp_MTC0    8'b0100_0110
`define AluOp_MFC0    8'b0100_0111
`define AluOp_TEQ     8'b0100_1000
`define AluOp_TGE     8'b0100_1001
`define AluOp_TGEU    8'b0100_1010
`define AluOp_TLT     8'b0100_1011
`define AluOp_TLTU    8'b0100_1100
`define AluOp_TNE     8'b0100_1101
`define AluOp_TEQI    8'b0100_1110
`define AluOp_TGEI    8'b0100_1111
`define AluOp_TGEIU   8'b0101_0000
`define AluOp_TLTI    8'b0101_0001
`define AluOp_TLTIU   8'b0101_0010
`define AluOp_TNEI    8'b0101_0011
`define AluOp_SYSCALL 8'b0101_0100
`define AluOp_ERET    8'b0101_0101



`define AluSel_LOGIC 3'b001
`define AluSel_ARITH 3'b010
`define AluSel_J     3'b011
`define AluSel_LOAD  3'b100
`define AluSel_ERROR 3'bxxx

`define InstMemNum    131071         //128KB
`define InstMemNumLog2    17         // 17bit
`define DataMemNum    131071         //128KB
`define DataMemNumLog2    17         // 17bit


`define CP0_REG_COUNT      5'b01001        
`define CP0_REG_COMPARE    5'b01011      
`define CP0_REG_STATUS     5'b01100       
`define CP0_REG_CAUSE      5'b01101        
`define CP0_REG_EPC        5'b01110          
`define CP0_REG_PRID       5'b01111         
`define CP0_REG_CONFIG     5'b10000       

`define WB_IDLE            2'b00
`define WB_BUSY            2'b01
`define WB_WAIT_FOR_STALL  2'b11





