module ram (din, addr, write_en, clk, dout);// 512x8
parameter addr_width = 12;
parameter data_width = 32;
input [addr_width-1:0] addr;
input [data_width-1:0] din;
input write_en, clk;
output [data_width-1:0] dout;
reg [data_width-1:0] dout; // Register for output.
reg [data_width-1:0] mem [(1<<addr_width)-1:0];

initial begin
    $readmemh("fill.mem", mem);
end

always @(posedge clk)begin
if (write_en)
    mem[(addr)] <= din;
    dout = mem[addr]; // Output register controlled by clock.
end


endmodule