`timescale 10ns / 1ns

module tb_register;

logic clk = 0, nrst;
logic tb_check_output, tb_WEN;
logic [4:0] tb_index1, tb_index2, write_index; 
integer tb_testnum = 0;
string tb_test_case;
logic [31:0] read_data1, read_data2, write_data;

register_file DUT(.clk(clk), .nRST(nrst), .reg_write(tb_WEN), .read_index1(tb_index1), .read_index2(tb_index2), 
.read_data1(read_data1), .read_data2(read_data2), .write_index(write_index), .write_data(write_data));

parameter CLK_PER = 10;
always #(CLK_PER/2) clk ++;

task reset_dut;
  @(negedge clk);
  nrst = 1'b0; 
  @(negedge clk);
  @(negedge clk);
  nrst = 1'b1;
  @(posedge clk);
endtask

task checkreg1;
input logic[31:0] tb_exp_reg_data;
	@(negedge clk);
	if(read_data1 == tb_exp_reg_data)
		$info("Correct reg data: %0d.", tb_exp_reg_data);
	else
		$error("Incorrect reg data. Actual: %0d. Exp: %0d.", read_data1, tb_exp_reg_data); 
endtask

task checkreg2;
input logic[31:0] tb_exp_reg_data;
	@(negedge clk);
	if(read_data2 == tb_exp_reg_data)
		$info("Correct reg data: %0d.", tb_exp_reg_data);
	else
		$error("Incorrect reg data. Actual: %0d. Exp: %0d.", read_data1, tb_exp_reg_data); 
endtask

initial begin
$dumpfile("dump.vcd");
$dumpvars; 

nrst = 1;
tb_WEN = 0;
tb_index1 = 0;
tb_index2 = 0;
#(1)
tb_testnum = 0;
tb_test_case = "Test Case 0: Power-on-Reset of the DUT";
nrst = 0;
$display("\n\n%s", tb_test_case);
#(5);
checkreg1('0);
@(negedge clk);
checkreg1('0);
@(negedge clk);
nrst = 1;
checkreg1('0);
//----------------------------------
tb_testnum +=1;
tb_test_case = "Test Case 1: Write register given write index + check regWrite functionality";
reset_dut;
$display("\n\n%s", tb_test_case);

//check for vaildaity of tb_WEN
@(negedge clk);
write_data = 32'hAAAAAAAA;
write_index = 5'b00001;
tb_index1 = 5'b00001;
#(CLK_PER * 5);
checkreg1(0);
#(CLK_PER * 5);

@(negedge clk);
tb_WEN = 1;
write_data = 32'hAAAAAAAA;
write_index = 5'b00001;
tb_index2 = 5'b00001;
#(CLK_PER * 5);
checkreg2(32'hAAAAAAAA);
#(CLK_PER * 5);

//check register can be overwritten
@(negedge clk);
write_data = 32'hAAAAAAAF;
write_index = 5'b00001;
tb_index1 = 5'b00001;
#(CLK_PER * 5);
checkreg1(32'hAAAAAAAF);
#(CLK_PER * 5);

//check both register can be written at the same time
write_data = 32'hFACEAAAA;
write_index = 5'b00010;
#(CLK_PER * 5);
write_data = 32'hAAAAFACE;
write_index = 5'b00100;
#(CLK_PER * 5);
write_data = 32'hAAFACEAA;
write_index = 5'b01000;
#(CLK_PER * 5);
write_data = 32'hFAAAAACE;
write_index = 5'b10000;
#(CLK_PER * 5);
tb_index1 = 5'b00010;
tb_index2 = 5'b00100;
checkreg1(32'hFACEAAAA);
checkreg2(32'hAAAAFACE);
#(CLK_PER * 5);
tb_index1 = 5'b01000;
tb_index2 = 5'b10000;
checkreg1(32'hAAFACEAA);
checkreg2(32'hFAAAAACE);
#(CLK_PER * 5);
end

endmodule
