// FPGA Top Level

`default_nettype none

module top (
  // I/O ports
  input  logic hz100, reset,
  input  logic [20:0] pb,
  output logic [7:0] left, right,
  ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  // // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
);

top1 f1 (.clk(hz100), .nrst(!reset), .pb(pb), .ss7(ss7), .ss6(ss6), .ss5(ss5), .ss4(ss4), .ss3(ss3), .ss2(ss2), .ss1(ss1), .ss0(ss0));

// ///////////////////////FPGA connection
// logic muxxedMemEnable, fpgaMemEnable;
// logic[31:0] muxxedDataOut, fpgaAddressOut, fpgaDataOut;
// logic [31:0] muxxedAddressOut, addressOut;
// logic [31:0]intermedWriteEnable;
// mux enableFpgaOut(.in1(32'd1), .in2({31'b0, write_enable_cpu}), .en(fpgaMemEnable), .out(intermedWriteEnable));
// assign write_enable = intermedWriteEnable[0];
// mux enableFpgaData(.in1(fpgaDataOut), .in2(datain), .en(fpgaMemEnable), .out(muxxedDataOut));
// mux enableFpgaAddress(.in1(fpgaAddressOut), .in2(addr), .en(fpgaMemEnable), .out(muxxedAddressOut));

// logic displayCPU;
// FPGAModuleCalc a1 (.memEnable(fpgaMemEnable), .dataOut(fpgaDataOut), .displayCPU(displayCPU), .inputFromRam(1), .addressOut(fpgaAddressOut), .hz100(hz100), .pb(pb), .reset(~reset), .ss7(ss7), .ss6(ss6), .ss4(ss4), .ss3(ss3), .ss1(ss1), .ss0(ss0));
////////////////////

  // logic [31:0]addressOut;
  // logic [31:0]dataOut;
  //  FPGAModuleCalc a1 (.memEnable(right[0]), .dataOut(dataOut), .displayCPU(1), .inputFromRam(1), .addressOut(addressOut), .hz100(hz100), .pb(pb), .reset(~reset), .ss7(ss7), .ss6(ss6), .ss4(ss4), .ss3(ss3), .ss1(ss1), .ss0(ss0));
  //  assign right[1] = dataOut[0];
  //  assign left[0] = addressOut[0];

endmodule