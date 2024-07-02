// FPGA Top Level

`default_nettype none
// Empty top module

	typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR
	} cuOPType;	

module topALU (
  // I/O ports
    input logic[31:0] inputA, inputB,
    input cuOPType aluOP,
    output logic [31:0] outputtig,
    output logic negative,zero

);

  // Your code goes here...
    alu a2(.inputA(32'd10), .inputB(32'd15), .aluOP(CU_JAL), .ALUResult(outputtig), .negative(negative), .zero(zero));
  
endmodule  