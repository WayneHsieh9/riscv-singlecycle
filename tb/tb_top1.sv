// `include "src/top1.sv"
// `include "src/alu.sv"
// `include "src/control.sv"
// `include "src/mux.sv" 
// `include "src/pc.sv" 
// `include "src/ram.sv" 
// `include "src/register_file.sv" 
// `include "src/signExtender.sv" 
// `include "src/writeToReg.sv" 







`timescale 1ms / 10ns

module tb_top1;

logic [31:0] tb_muxOut, tb_aluIn, tb_aluOut, tb_immOut, tb_pc, tb_memload, tb_writeData, tb_regData1, tb_regData2, tb_instruction_out;
logic [5:0] tb_cuOP;
logic [4:0] tb_regsel1, tb_regsel2, tb_w_reg;
logic [3:0] tb_aluOP;
logic [19:0] tb_imm;
logic clk, nrst, tb_zero, tb_negative, tb_aluSrc, tb_regWrite, tb_i_ready, tb_d_ready, tb_memWrite, tb_memRead;


parameter CLK_PER = 10;
//always #(CLK_PER/2) clk ++;
always begin 
clk = 1'b0;
#(CLK_PER / 2.0);
clk = 1'b1;
#(CLK_PER / 2.0);
end



top1 DUT(.clk(clk), .nrst(nrst), .memload(tb_memload), .aluIn(tb_aluIn), .aluOut(tb_aluOut), .immOut(tb_immOut), 
.pc(tb_pc), .writeData(tb_writeData), .zero(tb_zero), .negative(tb_negative), .cuOP(tb_cuOP), .regsel1(tb_regsel1), .regsel2(tb_regsel2), .w_reg(tb_w_reg), .imm(tb_imm), .regData1(tb_regData1), .regData2(tb_regData2), .aluOP(tb_aluOP), .aluSrc(tb_aluSrc),
.regWrite(tb_regWrite), .d_ready(tb_d_ready), .i_ready(tb_i_ready), .memWrite(tb_memWrite), .memRead(tb_memRead), .instruction_out(tb_instruction_out));

task reset_dut;
  // @(negedge clk);
  nrst = 1'b0; 
  @(negedge clk);
  @(negedge clk);
  @(negedge clk);
  @(negedge clk);
  nrst = 1'b1;
  @(posedge clk);
endtask

initial begin
$dumpfile("test.vcd");
$dumpvars; 



//ADDI x1, x0, 1000
reset_dut;

nrst = 1'b1;
// @(negedge clk);
// @(posedge clk);
// @(negedge clk);
// @(posedge clk);
// @(negedge clk);
// @(posedge clk);
// @(negedge clk);
// @(posedge clk);
// @(negedge clk);
// @(posedge clk);
// @(negedge clk);
// @(posedge clk);
// @(negedge clk);
// @(posedge clk);
// @(negedge clk);
// @(posedge clk);
// @(negedge clk);
// @(posedge clk);
#1000;
$finish;
end

endmodule