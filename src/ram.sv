// module ram (
// input logic clk, nRst, write_enable, read_enable,
// input logic [11:0] address_DM, address_IM,
// input logic [31:0] data_in,
// input logic [5:0] CUOp,
// output reg [31:0] data_out,
// output reg [31:0] instr_out,
// // output logic [31:0]memory[31:0],
// // output logic [31:0]nxt_memory[31:0],
// output logic pc_enable
// );
// typedef enum logic [5:0] {
// 		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
// 		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
// 		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
// 		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
// 		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
// 		CU_ERROR
// 	} cuOPType;	
// reg [31:0] memory [63:0];
// reg [31:0] nxt_memory [63:0];

// typedef enum logic {IDLE, WAIT} StateType;
// StateType state, next_state;

// // initial begin
// // $readmemh("fill.mem", nxt_memory);
// // end

// always_ff @(posedge clk, negedge nRst) begin
//     if (!nRst) begin
//         // for (int i = 0;i<32 ;i++ ) begin
//         //     for (int j = 0;j<32 ;j++ ) begin
//         //         memory[i][j] <= 1'b0;
//         //     end
//         // end
//         $readmemh("fill.mem", memory);

//         state <= IDLE;
//     end else begin
//         // $readmemh("fill.mem", nxt_memory);
//         for (int i = 0;i<64 ;i++ ) begin
//             // for (int j = 0;j<32 ;j++ ) begin
//                 memory[i] <= nxt_memory[i];
//             // end
//         end
//         state <= next_state;
//     end
// end

// always_comb begin
//     next_state = state;
//     for (int i = 0;i<64 ;i++ ) begin
//             // for (int j = 0;j<32 ;j++ ) begin
//                 nxt_memory[i] = memory[i];
//             // end
//     end
//     pc_enable = 1;
//     case (state)
//         IDLE : begin
//             pc_enable = 0;
//             if (CUOp == CU_SB | CUOp == CU_SH | CUOp == CU_SW | CUOp == CU_LB 
//             | CUOp == CU_LH | CUOp == CU_LW | CUOp == CU_LBU| CUOp ==  CU_LHU ) begin
//                 next_state = WAIT;
//             end
//             else begin
//                 pc_enable = 1'b1;
//             end
//         end

//         WAIT : begin
//             pc_enable = 1;
//             next_state = IDLE;
//             if (write_enable) begin
//                 nxt_memory[address_DM>>2] = data_in;
//             end
//         end
        
//     endcase  
// end

// // assign data_out = memory[address_DM>>2];
// assign data_out = memory[address_DM>>2];

// assign instr_out = memory[address_IM>>2];

// // always_ff @(posedge clk, negedge nRst) begin
// // if (!nRst) begin
// // state <= IDLE;
// // data_out <= '0;
// // instr_out <= '0;
// // end else begin
// // state <= next_state;
// // // data_out <= memory[address_DM];
// // // instr_out <= memory[address_IM];
// // if (write_enable) begin
// //     memory[address_DM>>2] <= data_in;
// // end
// //     data_out <= memory[address_DM>>2];
// //     instr_out <= memory[address_IM>>2];
// // end
// // end

// // // assign data_out = memory[address_DM];
// // // assign instr_out = memory[address_IM];

// // always_comb begin
// // pc_enable = 1'b1;
// // next_state = state;
// // case (state)
// // IDLE: begin
// // if (read_enable | write_enable) begin
// // pc_enable = 1'b0;
// // next_state = WAIT;
// // end
// // end
// // WAIT: begin
// // // pc_enable = 1'b1;
// // next_state = IDLE;
// // end
// // default:;
// // endcase
// // end

// // // always @(posedge clk) begin
// // // if (write_enable) begin
// // // memory[address_DM>>2] <= data_in;
// // // end
// // // data_out <= memory[address_DM>>2];
// // // instr_out <= memory[address_IM>>2];
// // // end
// endmodule

module ram (
input logic clk, nRst, write_enable, read_enable,
input logic [11:0] address_DM, address_IM,
input logic [31:0] data_in,
output reg [31:0] data_out,
output reg [31:0] instr_out,
output logic pc_enable,
output logic [31:0] display
);
logic [31:0] memory [4096:0];
 
typedef enum logic {IDLE, WAIT} StateType;
StateType state, next_state;
 
initial begin
$readmemh("fill.mem", memory);
end
 
always_ff @(posedge clk, negedge nRst) begin
if (!nRst) begin
state <= IDLE;
// data_out <= '0;
// instr_out <= '0;
end else begin
state <= next_state;
// data_out <= memory[address_DM];
// instr_out <= memory[address_IM];
end
end
 
// assign data_out = memory[address_DM];
// assign instr_out = memory[address_IM];
 
always_comb begin
pc_enable = 1'b1;
next_state = state;
case (state)
IDLE: begin
if (read_enable | write_enable) begin
pc_enable = 1'b0;
next_state = WAIT;
end
end
WAIT: begin
// pc_enable = 1'b1;
next_state = IDLE;
end
default:;
endcase
end
 
always @(posedge clk) begin
if (write_enable) begin
memory[address_DM>>2] <= data_in;
end
data_out <= memory[address_DM>>2];
instr_out <= memory[address_IM>>2];

end
assign display = memory [0];

endmodule
 