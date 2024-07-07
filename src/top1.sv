// FPGA Top Level

`default_nettype none

module top1 (
  // I/O ports
  input  logic clk, nrst,
  input  logic [20:0] pb,
  // output logic [7:0] left, right,
  output logic [7:0] ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0
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
  logic cpuEnable;

// ///////////////////////FPGA connection
logic [31:0]muxxedMemWriteEnable, muxxedReadEnable;
logic fpgaMemEnable, fpgaReadEnable;

logic[31:0] muxxedDataOut, fpgaAddressOut, fpgaDataOut, fpgaReadDataAddress;
logic [31:0] muxxedAddressOut, addressOut, muxxedReadAddressData;

mux writeEnableMux(.in1(32'b1), .in2({31'b0, memWrite}), .en(fpgaMemEnable), .out(muxxedMemWriteEnable));

mux writeFpgaData(.in1(fpgaDataOut), .in2(regData2), .en(fpgaMemEnable), .out(muxxedDataOut));

mux writeFpgaAddress(.in1(fpgaAddressOut), .in2(aluOut), .en(fpgaMemEnable), .out(muxxedAddressOut));

mux readFpgaAddressData(.in1(fpgaReadDataAddress), .in2(muxxedAddressOut), .en(fpgaReadEnable), .out(muxxedReadAddressData)); //once the final state inside the FPGA module is reached, it will output a dedicated address to RAM, which will output a value

mux fpgaReadEnableModule(.in1(32'b1), .in2({31'b0, memRead}), .en(fpgaReadEnable), .out(muxxedReadEnable));

logic [31:0]muxxedCpuEnable;
mux cpuEnableMuxed(.in1(32'b1), .in2(32'b0), .en(cpuEnable), .out(muxxedCpuEnable)); //make i_ready to 0 instead? bc i_ready is 1 anyway.

logic displayCPU;
FPGAModuleCalc a1 (.fpgaReadEnable(fpgaReadEnable), .regVal(memload), .memEnable(fpgaMemEnable), .dataOut(fpgaDataOut), .displayCPU(displayCPU), 
.addressOut(fpgaAddressOut), .fpgaReadDataAddress(fpgaReadDataAddress), .hz100(clk), .pb(pb), .reset(nrst), .ss7(ss7), .ss6(ss6), .ss5(ss5), .ss4(ss4), .ss3(ss3), .ss2(ss2), .ss1(ss1), .ss0(ss0), .cpuEnable(cpuEnable));

// ////////////////////

logic [31:0] instruction;
logic [7:0] data_out8;
mux aluMux(.in1(immOut), .in2(regData2), .en(aluSrc), .out(aluIn));

alu arith(.aluOP(aluOP), .inputA(regData1), .inputB(aluIn), .ALUResult(aluOut), .zero(zero), .negative(negative));

register_file DUT(.clk(clk), .nRST(nrst), .reg_write(regWrite), .read_index1(regsel1), .read_index2(regsel2), 
.read_data1(regData1), .read_data2(regData2), .write_index(w_reg), .write_data(writeData));

control controller (.cuOP(cuOP), .instruction(instruction), 
.reg_1(regsel1), .reg_2(regsel2), .rd(w_reg),
.imm(imm), .aluOP(aluOP), .regWrite(regWrite), .memWrite(memWrite), .memRead(memRead), .aluSrc(aluSrc));

pc testpc(.clk(clk), .nRST(nrst), .ALUneg(negative), .Zero(zero), .iready(muxxedCpuEnable[0]), .PCaddr(pc), .cuOP(cuOP), .rs1Read(regData1), .signExtend(immOut));

writeToReg write(.cuOP(cuOP), .memload(memload), .aluOut(aluOut), .imm(immOut), .pc(pc), .writeData(writeData), .negative(negative));

signExtender signex(.imm(imm), .immOut(immOut), .CUOp(cuOP));

//request ru(.CLK(clk), .nRST(nrst), .imemload(instruction), .imemaddr(pc), .dmmaddr(aluOut), .dmmstore(regData2), .ramaddr(addr), .ramload(dataout), .ramstore(datain), 
// .cuOP(cuOP), .Wen(write_enable_cpu), .busy_o(busy_o), .dmmload(memload), .i_ready(i_ready), .d_ready(d_ready), .Ren());

// ram rram (.clk(clk), .nRst(nrst), .write_enable(|write_enable), .addr(muxxedAddressOut[11:0]), .data_in(muxxedDataOut), .data_out(dataout), .busy(busy_o), .fpgaOut(fpgaOut));
ram ra(.clk(clk), .nRst(nrst), .write_enable(muxxedMemWriteEnable[0]), .read_enable(muxxedReadEnable[0]), .address_DM(muxxedReadAddressData[11:0]), .address_IM(pc[11:0]), .data_in(muxxedDataOut), .data_out(memload), .instr_out(instruction), .pc_enable(i_ready));
assign instruction_out = instruction;
 
endmodule