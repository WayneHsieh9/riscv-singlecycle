
`timescale 1ms / 100us

typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR
	} cuOPType;	

module tb_PCaddr();

localparam CLK_PERIOD = 10; 

//all logic
logic tb_clk;
cuOPType tb_cuOP;
logic tb_iready, tb_nRST, tb_ALUneg, tb_Zero, tb_checking_outputs;
logic [31:0] tb_rs1Read, tb_signExtend, tb_PCaddr, tb_intermResult;
integer tb_numOfTests, tb_test_num;
string tb_test_case;

pc DUT(.cuOP(tb_cuOP), .rs1Read(tb_rs1Read), .signExtend(tb_signExtend), .ALUneg(tb_ALUneg), .Zero(tb_Zero),
.iready(tb_iready), .clk(tb_clk), .nRST(tb_nRST), .PCaddr(tb_PCaddr));


// Clock generation block
always begin
    tb_clk = 1'b0; 
    #(CLK_PERIOD / 2.0);
    tb_clk = 1'b1; 
    #(CLK_PERIOD / 2.0); 
end

task reset_dut;
    @(negedge tb_clk);
    tb_nRST = 1'b0;
    @(negedge tb_clk);
    @(negedge tb_clk);
    tb_nRST = 1'b1;
    @(posedge tb_clk);
endtask

task checkOut;
    input logic [31:0] exp_out;
    tb_checking_outputs = 1'b1;
    if(tb_PCaddr == exp_out)
        $info("Correct address %0d.", exp_out);
    else
        $error("Incorrect address. Expected: %0d. Actual: %0d.", exp_out, tb_PCaddr); 
    
    #(1);
    tb_checking_outputs = 1'b0;  
endtask


initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    tb_nRST = 1;
    tb_ALUneg = 0;
    tb_iready = 1;
    tb_ALUneg = 0;
    tb_cuOP = CU_LUI;
    tb_Zero = 0;
    tb_clk = tb_clk;
    tb_rs1Read = 32'b0;
    tb_signExtend = 32'b0;
    tb_numOfTests = 2;
    tb_test_num = -1;
    tb_test_case = "Initializing";
    tb_intermResult = 0;
    // ************************************************************************
    // Test Case 0: Power-on-Reset of the DUT
    // ************************************************************************
        //Check to see if reset address is correct
        tb_test_num += 1;
        tb_test_case = "Test Case 0: Power-on-Reset of the DUT";
        $display("\n\n%s", tb_test_case);
        tb_nRST = 0;
        #2;
        checkOut(32'b0);
        @(negedge tb_clk);
        tb_nRST = 1;
    // ************************************************************************
    // Test Case 1: Testing JAL operation
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 1: JAL operation";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        tb_signExtend = 0;
        tb_rs1Read = 0;
        tb_cuOP= CU_JAL;

        //change negative and zero values to ensure works properly for different values
        tb_ALUneg = 0;
        tb_Zero = 0;
        tb_iready = 1;
        //loop through test cases
        for (integer i = 1; i < tb_numOfTests; i++) begin
            for (integer j = 1; j < tb_numOfTests; j++) begin
            tb_signExtend = tb_signExtend + j;
            tb_rs1Read = tb_rs1Read + i;
            //check operation for JAL
            @(negedge tb_clk);
            #1;
            checkOut(tb_signExtend + tb_PCaddr);
            end 
        end
    // ************************************************************************
    // Test Case 2: Testing JALR operation
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 2: JALR operation";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        tb_signExtend = 0;
        tb_rs1Read = 0;
        tb_cuOP = CU_JALR;

        //change negative and zero values to ensure works properly for different values
        tb_ALUneg = 0;
        tb_Zero = 0;
        tb_iready = 1;
        //loop through test cases
        for (integer i = 1; i < tb_numOfTests; i++) begin
            for (integer j = 1; j < tb_numOfTests; j++) begin
            tb_signExtend = tb_signExtend + j;
            tb_rs1Read = tb_rs1Read + i;
            @(negedge tb_clk);
            tb_intermResult = tb_rs1Read + tb_signExtend;
            checkOut({tb_intermResult[31:1], 1'b0});
            end 
        end
    // ************************************************************************
    // Test Case 3: Testing BEQ with failed zero condition
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 3: Testing BEQ with failed zero condition";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        tb_signExtend = 0;
        tb_rs1Read = 0;
        tb_cuOP = CU_BEQ;

        //change negative and zero values to ensure works properly for different values
        tb_ALUneg = 0;
        tb_Zero = 0;
        tb_iready = 1;
        //loop through test cases
        //@(negedge tb_clk);
        checkOut(tb_PCaddr + tb_signExtend);
    // ************************************************************************
    // Test Case 4: Testing BNE with failed zero condition
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 4: Testing BNE with failed zero condition";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        tb_signExtend = 0;
        tb_rs1Read = 0;
        tb_cuOP = CU_BNE;

        //change negative and zero values to ensure works properly for different values
        tb_ALUneg = 0;
        tb_Zero = 1;
        tb_iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(tb_PCaddr);
    // ************************************************************************
    // Test Case 5: Testing BLT with failed zero condition
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 5: Testing BLT with failed negative condition";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        tb_signExtend = 0;
        tb_rs1Read = 0;
        tb_cuOP = CU_BLT;

        //change negative and zero values to ensure works properly for different values
        tb_ALUneg = 0;
        tb_Zero = 1;
        tb_iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(tb_PCaddr);
    // ************************************************************************
    // Test Case 6: Testing BGE with failed zero condition
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 6: Testing BGE with failed negative condition";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        tb_signExtend = 0;
        tb_rs1Read = 0;
        tb_cuOP = CU_BGE;

        //change negative and zero values to ensure works properly for different values
        tb_ALUneg = 0;
        tb_Zero = 1;
        tb_iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(tb_PCaddr);
    // ************************************************************************
    // Test Case 7: Testing BGEU with failed zero condition
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 7: Testing BGEU with failed negative condition";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        tb_signExtend = 0;
        tb_rs1Read = 0;
        tb_cuOP = CU_BGEU;

        //change negative and zero values to ensure works properly for different values
        tb_ALUneg = 1;
        tb_Zero = 1;
        tb_iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(tb_PCaddr);
    // ************************************************************************
    // Test Case 8: Testing BEQ 
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 8: Testing BEQ with passed condition";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        tb_signExtend = 0;
        tb_rs1Read = 0;
        tb_cuOP = CU_BEQ;

        //change negative and zero values to ensure works properly for different values
        tb_ALUneg = 1;
        tb_Zero = 1;
        tb_iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(tb_PCaddr + tb_signExtend);
    // ************************************************************************
    // Test Case 9: Testing BNE with passed condition
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 9: Testing BNE with passed condition";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        tb_signExtend = 0;
        tb_rs1Read = 0;
        tb_cuOP = CU_BNE;

        //change negative and zero values to ensure works properly for different values
        tb_ALUneg = 0;
        tb_Zero = 0;
        tb_iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(tb_PCaddr + tb_signExtend);
    // ************************************************************************
    // Test Case 10: Testing BLT with passed condition
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 10: Testing BLT with passed condition";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        tb_signExtend = 0;
        tb_rs1Read = 0;
        tb_cuOP = CU_BLT;

        //change negative and zero values to ensure works properly for different values
        tb_ALUneg = 1;
        tb_Zero = 0;
        tb_iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(tb_PCaddr + tb_signExtend);
    // ************************************************************************
    // Test Case 11: Testing BGE with equal to condition
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 11: Testing BGE with equal to condition";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        tb_signExtend = 0;
        tb_rs1Read = 0;
        tb_cuOP = CU_BGE;

        //change negative and zero values to ensure works properly for different values
        tb_ALUneg = 1;
        tb_Zero = 1;
        tb_iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(tb_PCaddr + tb_signExtend);
    // ************************************************************************
    // Test Case 12: Testing BGE with negative = 0
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 12: Testing BGE with negative = 0";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        tb_signExtend = 0;
        tb_rs1Read = 0;
        tb_cuOP = CU_BGE;

        //change negative and zero values to ensure works properly for different values
        tb_ALUneg = 0;
        tb_Zero = 0;
        tb_iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(tb_PCaddr + tb_signExtend);

    // ************************************************************************
    // Test Case 13: Testing BLTU with negative = 1
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 13: Testing BLTU with negative = 0";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        tb_signExtend = 0;
        tb_rs1Read = 0;
        tb_cuOP = CU_BLTU;

        //change negative and zero values to ensure works properly for different values
        tb_ALUneg = 1;
        tb_Zero = 0;
        tb_iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(tb_PCaddr + tb_signExtend);
    // ************************************************************************
    // Test Case 14: Testing BGEU with negative = 0
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 14: Testing BGEU with negative = 0";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        tb_signExtend = 0;
        tb_rs1Read = 0;
        tb_cuOP = CU_BGEU;

        //change negative and zero values to ensure works properly for different values
        tb_ALUneg = 0;
        tb_Zero = 0;
        tb_iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(tb_PCaddr + tb_signExtend);
    // ************************************************************************
    // Test Case 15: Testing BGEU with zero = 1
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 15: Testing BGEU with zero = 1";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        tb_signExtend = 0;
        tb_rs1Read = 0;
        tb_cuOP = CU_BGEU;

        //change negative and zero values to ensure works properly for different values
        tb_ALUneg = 1;
        tb_Zero = 1;
        tb_iready = 1;
        //loop through test cases
        #1;
        checkOut(tb_PCaddr + tb_signExtend);


    #1;
    $finish;
end

endmodule
