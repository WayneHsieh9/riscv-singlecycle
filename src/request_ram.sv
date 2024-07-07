module ru_ram(
    input logic clk, nRst, write_enable, 
    input logic [31:0] addr,
    input logic [31:0] data_in,
    output logic [31:0] data_out,
    output logic busy,
    output logic [31:0] display
);
endmodule