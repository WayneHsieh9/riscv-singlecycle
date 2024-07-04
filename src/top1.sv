// FPGA Top Level

`default_nettype none

module top1 (
  // I/O ports
  input  logic clk, nrst,
  input  logic [20:0] pb,
  // output logic [7:0] left, right,
  output logic [7:0] ss7, ss6, ss4, ss3, ss1, ss0
  // output logic red, green, blue,

  // // UART ports
  // output logic [7:0] txdata,
  // input  logic [7:0] rxdata,
  // output logic txclk, rxclk,
  // input  logic txready, rxready
);

	logic zero, negative, regWrite, aluSrc, d_ready, i_ready, memWrite, memRead, write_enable_cpu, write_enable, busy_o;
	logic [3:0] aluOP;
	logic [4:0] regsel1, regsel2, w_reg;
	logic [5:0] cuOP;
	logic [19:0] imm;
	logic [31:0] memload, aluIn, aluOut, immOut, pc, writeData, regData1, regData2, instruction_out;
  logic [31:0] datain, dataout;
  logic [31:0] addr;
  logic [31:0][31:0] test_memory;
  logic [31:0][31:0] test_nxt_memory; 

///////////////////////FPGA connection
logic muxxedMemEnable, fpgaMemEnable;
logic[31:0] muxxedDataOut, fpgaAddressOut, fpgaDataOut;
logic [31:0] muxxedAddressOut, addressOut;
logic [31:0]intermedWriteEnable;
// mux enableFpgaOut(.in1(32'd1), .in2({31'b0, write_enable_cpu}), .en(fpgaMemEnable), .out(intermedWriteEnable));
// assign write_enable = intermedWriteEnable[0];
// mux enableFpgaData(.in1(fpgaDataOut), .in2(datain), .en(fpgaMemEnable), .out(muxxedDataOut));
// mux enableFpgaAddress(.in1(fpgaAddressOut), .in2(addr), .en(fpgaMemEnable), .out(muxxedAddressOut));

logic displayCPU;
FPGAModuleCalc a1 (.memEnable(fpgaMemEnable), .dataOut(fpgaDataOut), .displayCPU(displayCPU), .inputFromRam(1), .addressOut(fpgaAddressOut), .hz100(clk), .pb(pb), .reset(~nrst), .ss7(ss7), .ss6(ss6), .ss4(ss4), .ss3(ss3), .ss1(ss1), .ss0(ss0));
////////////////////



logic [31:0] instruction;
logic [7:0] data_out8;
mux aluMux(.in1(immOut), .in2(regData2), .en(aluSrc), .out(aluIn));

alu arith(.aluOP(aluOP), .inputA(regData1), .inputB(aluIn), .ALUResult(aluOut), .zero(zero), .negative(negative));

register_file DUT(.clk(clk), .nRST(nrst), .reg_write(regWrite), .read_index1(regsel1), .read_index2(regsel2), 
.read_data1(regData1), .read_data2(regData2), .write_index(w_reg), .write_data(writeData));

control controller (.cuOP(cuOP), .instruction(instruction), 
.reg_1(regsel1), .reg_2(regsel2), .rd(w_reg),
.imm(imm), .aluOP(aluOP), .regWrite(regWrite), .memWrite(memWrite), .memRead(memRead), .aluSrc(aluSrc));

pc testpc(.clk(clk), .nRST(nrst), .ALUneg(negative), .Zero(zero), .iready(i_ready), .PCaddr(pc), .cuOP(cuOP), .rs1Read(regData1), .signExtend(immOut));

writeToReg write(.cuOP(cuOP), .memload(memload), .aluOut(aluOut), .imm(immOut), .pc(pc), .writeData(writeData), .negative(negative));

signExtender signex(.imm(imm), .immOut(immOut), .CUOp(cuOP));

request ru(.CLK(clk), .nRST(nrst), .imemload(instruction), .imemaddr(pc), .dmmaddr(aluOut), .dmmstore(regData2), .ramaddr(addr), .ramload(dataout), .ramstore(datain), 
.cuOP(cuOP), .Wen(write_enable_cpu), .busy_o(busy_o), .dmmload(memload), .i_ready(i_ready), .d_ready(d_ready), .Ren());

ru_ram rram (.clk(clk), .nRst(nrst), .write_enable(|write_enable), .addr(muxxedAddressOut), .data_in(muxxedDataOut), .data_out(dataout), .busy(busy_o));
//ram ra(.clk(clk), .nRst(nrst), .write_enable(memWrite), .read_enable(1), .address_DM(aluOut[5:0]), .address_IM(pc[5:0]), .data_in(regData2), .data_out(memload), .instr_out(instruction), .pc_enable(i_ready), .CUOp(cuOP));
assign instruction_out = instruction;


endmodule