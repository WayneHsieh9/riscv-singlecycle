//input 32 bits imemload 
// output read_reg1, read_reg2, writeReg - 5 bits, 
// Cuop - 6 bits. 
// Aluop - 4 bits
// regwrite, Alusrc 1 bit 
// imm 20 bits 

`timescale 1 ms/ 100us

typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR
	} cuOPType;	

module tb_control();
logic [31:0] tb_instructions;
logic [4:0] tb_reg_1, tb_reg_2, tb_rd;
logic [19:0] tb_imm;
logic [3:0] tb_aluOP;
cuOPType tb_cuOP;
logic tb_regWrite, tb_memWrite, tb_memRead, tb_aluSrc;

parameter PERIOD = 10;
control DUT (.cuOP(tb_cuOP), .instruction(tb_instructions), 
.reg_1(tb_reg_1), .reg_2(tb_reg_2), .rd(tb_rd),
.imm(tb_imm), .aluOP(tb_aluOP), .regWrite(tb_regWrite), .memWrite(tb_memWrite), .memRead(tb_memRead), .aluSrc(tb_aluSrc));
 
    
    initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    
tb_instructions = 32'h3e800093;

//addi x2, x0, -2000
#(PERIOD);
tb_instructions = 32'h83000113;

//ori x3 , x0,  1001
#(PERIOD );
tb_instructions = 32'h3e906193;

//andi x4 , x0,  1111
#(PERIOD );
tb_instructions = 32'h45707213;

//andi x4, x3, 1011
#(PERIOD);
tb_instructions = 32'h3f31f213;

    /*
        tb_instructions = 32'hAAAAA537; //Lui
         #(PERIOD)
        tb_instructions = 32'hAAAAA517; // AUIPC 
         #(PERIOD)
        tb_instructions = 32'hFACEE56F;  // JAL
        #(PERIOD)
        tb_instructions = 32'hFAC78567; // JALR
        #(PERIOD)
        tb_instructions = 32'h6EDA88E3;// BEQ
        #(PERIOD)
        tb_instructions = 32'h6EDA98E3;// BNE
        #(PERIOD)
        tb_instructions = 32'h6EDAC8E3 ;// BGE
        #(PERIOD)
        tb_instructions = 32'h6EDAD8E3; // BLTU
        #(PERIOD)
        tb_instructions = 32'h6EDAE8E3; // BEGU
        #(PERIOD)
        tb_instructions = 32'h6EDAF8E3; // BGEU
        #(PERIOD)
        tb_instructions = 32'hABCA8503; // LB
        #(PERIOD)
        tb_instructions = 32'hABCA9503 ;// LH
        #(PERIOD)
        tb_instructions = 32'hABCAA503; // LW
        #(PERIOD)
        tb_instructions = 32'hABCAC503 ;// LBU
        #(PERIOD)
        tb_instructions = 32'hABCAD503; // LHU
        #(PERIOD)
        tb_instructions = 32'hEEAC0723 ;// SB
        #(PERIOD)
        tb_instructions = 32'hEEAC1723; // SH
        #(PERIOD)
        tb_instructions = 32'hEEAC2723; // SW
        #(PERIOD)
        tb_instructions = 32'hABC50D13; // ADDI
        #(PERIOD)
        tb_instructions = 32'hABC52D13; // SLTI
        #(PERIOD)
        tb_instructions = 32'hABC53D13; //SLTIU 
        #(PERIOD)
        tb_instructions = 32'hABC54D13; //XORI
        #(PERIOD)
        tb_instructions = 32'hABC56D13; //ORI
        #(PERIOD)
        tb_instructions = 32'hABC57D13; //ANDI
        #(PERIOD)
        tb_instructions = 32'h002A9C13; // SLLI
        #(PERIOD)
        tb_instructions = 32'h402D9C13; // SRLI
        #(PERIOD)
        tb_instructions = 32'h402D9C13; // SRAI
        #(PERIOD)
        tb_instructions = 32'h00C50C33; // add
        #(PERIOD)
        tb_instructions = 32'h40C50C33; // sub
        #(PERIOD)
        tb_instructions = 32'h00C51C33; // sll
        #(PERIOD)
        tb_instructions = 32'h00C52C33; // slt
        #(PERIOD)
        tb_instructions = 32'h00C53C33; // sltu
        #(PERIOD)
        tb_instructions = 32'h00C54C33; // xor
        #(PERIOD)
        tb_instructions = 32'h00C55C33; // srl
        #(PERIOD)
        tb_instructions = 32'h40C55C33; // sra
        #(PERIOD)
        tb_instructions = 32'h00C56C33; //OR
        #(PERIOD)
        tb_instructions = 32'h00C57C33; // AND */

    end
endmodule