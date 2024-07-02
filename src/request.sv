
module request (
    input logic CLK, nRST, busy_o,
    input logic [31:0] imemaddr, dmmaddr, dmmstore, ramload,
    input logic [5:0] cuOP,
    output logic Ren, Wen, 
    output logic [31:0] imemload, dmmload, ramaddr, ramstore
);
typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR
	} cuOPType;	
logic i_ready, d_ready, dmmRen, dmmWen, imemRen;
logic [31:0] imemaddr_co, dmmaddr_co, dmmstore_co, dmmload_co, imemload_co;

request_unit r1 (.CLK(CLK), .nRST(nRST), .dmmstorei(dmmstore), .dmmaddri(dmmaddr), .imemaddri(imemaddr), .cuOP(cuOP), 
.i_ready(i_ready), .d_ready(d_ready), .dmmRen(dmmRen), .dmmWen(dmmWen), .imemRen(imemRen),
 .imemaddro(imemaddr_co), .dmmstoreo(dmmstore_co), .dmmaddro(dmmaddr_co),
 .dmmloadi(dmmload_co), .imemloadi(imemload_co),
 .imemloado(imemload), .dmmloado(dmmload));

memory_control m1 (.CLK(CLK), .nRST(nRST),
                    .dmmRen(dmmRen), .dmmWen(dmmWen), .imemRen(imemRen), .busy_o(busy_o),
                    .imemaddr(imemaddr_co), .dmmaddr(dmmaddr_co), .dmmstore(dmmstore_co),
                    .ramload(ramload), .i_ready(i_ready), .d_ready(d_ready), .Ren(Ren), .Wen(Wen),
                    .ramaddr(ramaddr), .ramstore(ramstore), .dmmload(dmmload_co), .imemload(imemload_co));
                    

endmodule