
`timescale 1ms / 100us

module tb_alu ();


	typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR
	} cuOPType;	

    logic [31:0]tb_inputA, tb_inputB;
    logic [5:0] aluOP;
    logic [31:0] ALUResult;
    logic negative, zero;

    alu a1(.inputA(tb_inputA), .inputB(tb_inputB), .aluOP(aluOP), .ALUResult(ALUResult), .negative(negative), .zero(zero));


    // Testbench parameters
    parameter WAIT = 5;

    logic tb_checking_outputs; 
    logic tb_check_neg_out;
    logic tb_check_zero_out;
    integer tb_test_num;

    // DUT (design under test) ports
    //not needed because of interface !!

    // Task to check ALU output
    task check_ALU_out;
    input logic[31:0] exp_ALU_out; 
    begin
        tb_checking_outputs = 1'b1;
        if(ALUResult == exp_ALU_out)
            $info("Correct ALU_o: %b.", exp_ALU_out);
        else
            $error("Incorrect ALU_o. Expected: %b. Actual: %b.", exp_ALU_out, ALUResult); 
        tb_checking_outputs = 1'b0;  
        #(WAIT);
    end
    endtask

    task check_neg;
    input exp_neg; 
    begin
        tb_check_neg_out = 1'b1;
        if(negative == exp_neg)
            $info("Correct neg out: %b.", exp_neg);
        else
            $error("Incorrect neg out. Expected: %b. Actual: %b.", exp_neg, negative); 
        tb_check_neg_out = 1'b0;
        #(WAIT);
    end
    endtask

    task check_zero;
    input exp_zero; 
    begin
        tb_check_zero_out = 1'b1;
        if(zero == exp_zero)
            $info("Correct zero out: %b.", exp_zero);
        else
            $error("Incorrect zero out. Expected: %b. Actual: %b.", exp_zero, zero); 
        tb_check_zero_out = 1'b0;
        #(WAIT);
    end
    endtask

    initial begin
    // Signal dump
    $dumpfile("dump.vcd");
    $dumpvars; 

    //SLL / SLLI
    tb_test_num = 0; //test case unsigned 0
    $display("SLL %d", tb_test_num);
    tb_inputA = 32'd256;
    tb_inputB = 32'd3;
    aluOP = CU_SLL;
    #10;
    check_ALU_out(32'd2048);

    tb_test_num += 1; //test case signed 1
    $display("SLL %d", tb_test_num);
    tb_inputA = -32'd256;
    tb_inputB = 32'd3;
    aluOP = CU_SLL;
    #10;
    check_ALU_out(-32'd2048);

    //SRA/SRAI
    tb_test_num += 1; //test case 2
    $display("SRA %d", tb_test_num);
    tb_inputA = 32'b11111111111111111111111001110000;
    tb_inputB = 32'd3;
    aluOP = CU_SRA;
    #10;
    check_ALU_out(-32'd50);

    tb_test_num += 1; //test case 3
    $display("SRA %d", tb_test_num);
    tb_inputA = 32'd1000;
    tb_inputB = 32'd3;
    aluOP = CU_SRA;
    #10;
    check_ALU_out(32'd125);

    //ADD/ADDI
    ////////////////////////////////////
    //pos plus pos
    tb_test_num += 1; //test case 4
    $display("ADD %d", tb_test_num);
    tb_inputA = 32'd40;
    tb_inputB = 32'd90;
    aluOP = CU_ADD;
    #10;
    check_ALU_out(32'd130);
    check_neg(0);

    //negative plus negative
    tb_test_num += 1; //test case 5
    $display("ADD %d", tb_test_num);
    tb_inputA = -32'd8;
    tb_inputB = -32'd10;
    aluOP = CU_ADD;
    #10;
    check_ALU_out(-32'd18);
    check_neg(1);

    //positve plus negative
    tb_test_num += 1; //test case 6
    $display("ADD %d", tb_test_num);
    tb_inputA = 32'd10;
    tb_inputB = -32'd8;
    aluOP = CU_ADD;
    #10;
    check_ALU_out(32'd2);
    check_neg(0);

    //negative plus positive
    tb_test_num += 1; //test case 7
    $display("ADD %d", tb_test_num);
    tb_inputA = -32'd20;
    tb_inputB = 32'd4;
    aluOP = CU_ADD;
    #10;
    check_ALU_out(-32'd16);
    check_neg(1);

    //check zero
    tb_test_num += 1; //test case 8
    $display("ADD %d", tb_test_num);
    tb_inputA = 32'd10;
    tb_inputB = 32'd10;
    aluOP = CU_SUB;
    #10;
    check_zero(1);

    /////////////////////////////////

    //sub
    /////////////////////////////////////////////////////////
    //neg minus neg
    tb_test_num += 1; //test case 9
    $display("SUB %d", tb_test_num);
    tb_inputA = -32'd10;
    tb_inputB = -32'd5;
    aluOP = CU_SUB;
    #10;
    check_ALU_out(-32'd5);
    check_neg(1);

    //pos minus pos
    tb_test_num += 1; //test case 10
    $display("SUB %d", tb_test_num);
    tb_inputA = 32'd15;
    tb_inputB = 32'd5;
    aluOP = CU_SUB;
    #10;
    check_ALU_out(32'd10);

    //pos - neg
    tb_test_num += 1; //test case 11
    $display("SUB %d", tb_test_num);
    tb_inputA = 32'd20;
    tb_inputB = -32'd5;
    aluOP = CU_SUB;
    #10;
    check_ALU_out(32'd25);

    //neg - pos
    tb_test_num += 1; //test case 12
    $display("SUB %d", tb_test_num);
    tb_inputA = -32'd20;
    tb_inputB = 32'd10;
    aluOP = CU_SUB;
    #10;
    check_ALU_out(-32'd30);

    //check zero
    tb_test_num += 1; //test case 13 
    $display("SUB %d", tb_test_num);
    tb_inputA = 32'd10;
    tb_inputB = 32'd10;
    aluOP = CU_SUB;
    #10;
    check_zero(1);

    ////////////////////////////////////////////////////////////

    //OR/ORI 
    tb_test_num += 1; //test case 14
    $display("OR %d", tb_test_num);
    tb_inputA = 32'b0010;
    tb_inputB = 32'b1101;
    aluOP = CU_OR;
    #10;
    check_ALU_out(32'b1111);

    //XOR/XORI
    tb_test_num += 1; //test case 15
    $display("XOR %d", tb_test_num);
    tb_inputA = 32'b100011;
    tb_inputB = 32'b101010;
    aluOP = CU_XOR;
    #10;
    check_ALU_out(32'b001001);

    //AND/ANDI
    tb_test_num += 1; //test case 16
    $display("AND %d", tb_test_num);
    tb_inputA = 32'b100110;
    tb_inputB = 32'b111100;
    aluOP = CU_AND;
    #10;
    check_ALU_out(32'b100100);

    //SLT/SLTI
    tb_test_num += 1; //test case 17
    $display("SLT %d", tb_test_num);
    tb_inputA = -32'd15;
    tb_inputB = 32'd10;
    aluOP = CU_SLT;
    #10;
    check_ALU_out(32'b1);

    //SLTU
    tb_test_num += 1; //test case 18
    $display("SLTU %d", tb_test_num);
    tb_inputA = 32'd8;
    tb_inputB = 32'd10;
    aluOP = CU_SLTU;
    #10;
    check_ALU_out(32'd1);

    //SRL
    tb_test_num += 1; //test case 19
    $display("SRL %d", tb_test_num);
    tb_inputA = 32'd1000;
    tb_inputB = 32'd2;
    aluOP = CU_SRL;
    #10;
    check_ALU_out(32'd250);
$finish;
end

endmodule