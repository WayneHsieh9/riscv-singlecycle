module ram_wrapper(
    input logic clk, nRst,
    input logic [5:0] cuOP,
    input logic [31:0] address_DM, address_IM, 
    input logic [31:0] data_in, 
    output reg [31:0] data_out,
    output reg [31:0] instr_out,
    output logic pc_enable
);
typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR
	} cuOPType;	
logic write_enable, read_enable;
logic [11:0] address_DM12, address_IM12;
always_comb begin
if (cuOP == CU_LB || cuOP == CU_LH || cuOP == CU_LW || cuOP == CU_LBU || cuOP == CU_LHU ) begin
    read_enable = 1;
    write_enable = 0;
end
else if (cuOP == CU_SB || cuOP == CU_SW ||cuOP == CU_SH) begin
    read_enable = 0;
    write_enable = 1;
end
else begin
    read_enable = 0;
    write_enable = 0;
end


end
assign address_DM12 = address_DM [11:0];
assign address_IM12 = address_IM [11:0];

// call ram 

ram r1(.clk(clk), .nRst(nRst), .write_enable(write_enable), .read_enable(read_enable), .address_DM(address_DM12), .address_IM(address_IM12)
, .data_in(data_in), .data_out(data_out), .instr_out(instr_out), .pc_enable(pc_enable));
endmodule