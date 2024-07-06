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
logic [31:0] display;
top1 top (.clk(hz100), .nrst(!pb[19]), .display(display));
assign ss7 = display [31:24];
assign ss6 = display [23:16];
assign ss5 = display [15:8];
assign ss4 = display [7:0];
assign right [0] = pb[9];
endmodule
