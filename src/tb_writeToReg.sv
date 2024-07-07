
`timescale 1ms / 100us


module writeToReg_tb ();
 
typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR
	} cuOPType;


 
logic [31:0] tb_memload, tb_pc, tb_aluOut, tb_imm, tb_writeData;
logic tb_negative, tb_checking_outputs;
logic [5:0] tb_cuOP;
integer tb_test_num, tb_intermResult;
string tb_test_case;
 
writeToReg DUT(.memload(tb_memload), .pc(tb_pc), .aluOut(tb_aluOut),
.imm(tb_imm), .writeData(tb_writeData), .negative(tb_negative), .cuOP(tb_cuOP));
 
 
localparam CLK_PERIOD = 10;
 
logic tb_clk;
 
always begin
    tb_clk = 1'b0;
    #(CLK_PERIOD / 2.0);
    tb_clk = 1'b1;
    #(CLK_PERIOD / 2.0);
end
 
task checkOut;
    input logic [31:0] exp_out;
    tb_checking_outputs = 1'b1;
	#2;
    if(tb_writeData == exp_out)
        $info("Correct value to write %0b.", exp_out);
    else
        $error("Incorrect value to write. Expected: %0b. Actual: %0b.", exp_out, tb_writeData);
    #(1);
    tb_checking_outputs = 1'b0;  
endtask
 
initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    tb_memload = 32'b0;
    tb_pc = 32'b0;
    tb_aluOut = 32'b0;
    tb_imm = 32'b0;
    tb_negative = 0;
    tb_cuOP = 6'b0;
    tb_test_num = -1;
    tb_test_case = "Initializing";
    tb_intermResult = 0;
#2;
// ************************************************************************
  // Test Case 1: Test LB case
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 1: Testing LB";
	  $display("\n\n%s", tb_test_case);
			tb_memload = 32'haaaaaaaa;
			tb_pc = 32'hbbbbbbbb;
			tb_cuOP = CU_LB;
			#2;
			checkOut(32'b1111_1111_1111_1111_1111_1111_1010_1010);
			#5;
	// ************************************************************************
  // Test Case 2: Test LH case
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 2: Testing LH";
	  $display("\n\n%s", tb_test_case);
			tb_memload = 32'hbbbbbaba;
			tb_pc = 32'hbbbbbbbb;
			tb_cuOP = CU_LH;
			#2;
			checkOut(32'b1111_1111_1111_1111_1011_1010_1011_1010);
			#5;
	// ************************************************************************
  // Test Case 3: Test LW case
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 3: Testing LW";
	  $display("\n\n%s", tb_test_case);
			tb_memload = 32'habababab;
			tb_pc = 32'hbbbbbbbb;
			tb_cuOP = CU_LW;
			#2;
			checkOut(32'b1010_1011_1010_1011_1010_1011_1010_1011);
			#5;
	// ************************************************************************
  // Test Case 4: Test LBU case
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 4: Testing LBU";
	  $display("\n\n%s", tb_test_case);
			tb_memload = 32'haaaaaaaa;
			tb_pc = 32'hbbbbbbbb;
			tb_cuOP = CU_LBU;
			#2;
			checkOut({24'b0, 4'b1010, 4'b1010});
			#5;
	// ************************************************************************
  // Test Case 5: Test LHU case
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 5: Testing LHU";
	  $display("\n\n%s", tb_test_case);
			tb_memload = 32'hbbbbbbbb;
			tb_pc = 32'hbbbbbbbb;
			tb_cuOP = CU_LHU;
			#2;
			checkOut({16'b0, 4'b1011, 4'b1011, 4'b1011, 4'b1011});
			#5;
	// ************************************************************************
  // Test Case 6: Test AUIPC case
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 6: Testing AUIPC";
	  $display("\n\n%s", tb_test_case);
			tb_memload = 32'hbbbbbbbb;
			tb_pc = 32'hbbbbbbbb;
			tb_imm = 32'd10;
			tb_cuOP = CU_AUIPC;
			#2;
			//check that the checkout is correct, is should the immediate be 31:12 or 19:0?
			checkOut({tb_imm[31:12], 12'b0} + tb_pc);
			#5;
	// ************************************************************************
  // Test Case 7: Test LUI case
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 7: Testing LUI";
	  $display("\n\n%s", tb_test_case);
			tb_memload = 32'hbbbbbbbb;
			tb_pc = 32'hbbbbbbbb;
			tb_imm = 32'd10;
			tb_cuOP = CU_LUI;
			#2;
			//check that the checkout is correct, is should the immediate be 31:12 or 19:0?
			checkOut({tb_imm[31:12], 12'b0});
			#5;
	// ************************************************************************
  // Test Case 8: Test JAL case
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 8: Testing JAL";
	  $display("\n\n%s", tb_test_case);
			tb_memload = 32'hbbbbbbbb;
			tb_pc = 32'hbbbbbbbb;
			tb_imm = 32'd10;
			tb_cuOP = CU_JAL;
			#2;
			//check that the checkout is correct, is should the immediate be 31:12 or 19:0?
			checkOut(tb_pc + 4);
			#5;
	// ************************************************************************
  // Test Case 9: Test JALR case
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 9: Testing JALR";
	  $display("\n\n%s", tb_test_case);
			tb_memload = 32'hbbbbbbbb;
			tb_pc = 32'hbbbbbbbb;
			tb_imm = 32'd10;
			tb_cuOP = CU_JALR;
			#2;
			//check that the checkout is correct, is should the immediate be 31:12 or 19:0?
			checkOut(tb_pc + 4);
			#5;
	// ************************************************************************
  // Test Case 10: Checking other OPs
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 10: Testing other cases";
	  $display("\n\n%s", tb_test_case);
			tb_memload = 32'hbbbbbbbb;
			tb_pc = 32'hbbbbbbbb;
			tb_imm = 32'd10;
			tb_cuOP = CU_ADD;
			#2;
			checkOut(tb_aluOut);
			#5;
			tb_cuOP = CU_XOR;
			#2;
			checkOut(tb_aluOut);
			#5;
			tb_cuOP = CU_SB;
			#2;
			checkOut(tb_aluOut);
			#5;
#1;
    $finish;
end
 
 
endmodule