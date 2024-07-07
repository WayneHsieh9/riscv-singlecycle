`timescale 1ms / 100us


module signExtender_tb ();

    	typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR
	} cuOPType;

    // Testbench parameters
    parameter WAIT = 5;

    logic tb_checking_outputs; 
    integer tb_test_num;

    // DUT (design under test) ports
    //not needed because of interface !!
    logic [19:0] imm;
    logic [31:0] immOut;
    logic [5:0] CUOp;

    signExtender a4(.imm(imm), .immOut(immOut), .CUOp(CUOp));

    // Task to check ALU output
    task check_immOut;
    input logic[31:0] exp_signEx_out; 
    begin
        tb_checking_outputs = 1'b1;
        if(immOut == exp_signEx_out)
            $info("Correct signEx_Out: %b.", exp_signEx_out);
        else
            $error("Incorrect signEx_out. Expected: %b. Actual: %b.", exp_signEx_out, immOut); 
        tb_checking_outputs = 1'b0;  
        #(WAIT);
    end
    endtask

initial begin
    // Signal dump
    $dumpfile("dump.vcd");
    $dumpvars; 

    //b type
    $display("CU_BLT");
    CUOp = CU_BLT;
    imm = 20'b11001100110011001100;
    #10;
    check_immOut(32'b11111111111111111111_100110011001);

    //jump
    $display("CU_JUMP");
    CUOp = CU_JAL;
    imm = 20'b11001100110011001100;
    #10;
    check_immOut(32'b111111111111_10011001100110011001);

    //I type INCLUDES JALR

    $display("CU_LH");
    CUOp = CU_LH;
    imm = 20'b11001100110011001100;
    #10;
    check_immOut(32'b11111111111111111111_110011001100);

    //s type

    CUOp = CU_SH;
    $display("CU_SH");
    imm = 20'b11001100110011001100;
    #10;
    check_immOut(32'b11111111111111111111_110011001100);

    //U type (LUI, AUIPC)

    $display("U type");
    CUOp = CU_LUI;
    imm = 20'b11001100110011001100;
    #10;
    check_immOut({20'b11001100110011001100, 12'b0});
$finish;
end

endmodule