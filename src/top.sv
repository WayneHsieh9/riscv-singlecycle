// FPGA Top Level

`default_nettype none

module top (
 // I/O ports
  input  logic hz100, reset,
  input  logic [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready

);
// assign right [0] = 1'b1;
logic [31:0] dummyVar;
ru_ram test (.clk(hz100), .nRst(!pb[19]), .addr(32'b0), .data_in(32'b0), .data_out(dummyVar), .busy(right[0]), .write_enable(1'b1));



endmodule
