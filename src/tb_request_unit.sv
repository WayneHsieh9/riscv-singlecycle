
`timescale 1ms / 100us
typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR
	} cuOPType;	
module tb_request_unit();
    localparam CLK_PERIOD = 10;

    logic tb_clk, tb_nRST, tb_i_ready, tb_d_ready, tb_dmmWen, tb_dmmRen, tb_imemRen;
    cuOPType tb_cuOP;
    logic [31:0] tb_dmmstorei, tb_dmmaddri, tb_imemaddri, tb_imemloadi, tb_dmmloadi;
    logic [31:0] tb_dmmstoreo, tb_dmmaddro, tb_imemaddro, tb_imemloado, tb_dmmloado;


    always begin
        tb_clk = 1'b0; 
        #(CLK_PERIOD / 2.0);
        tb_clk = 1'b1; 
        #(CLK_PERIOD / 2.0); 
    end

    request_unit DUT (.CLK(tb_clk), .nRST(tb_nRST), .i_ready(tb_i_ready),
    .d_ready(tb_d_ready), .dmmWen(tb_dmmWen), .dmmRen(tb_dmmRen), .imemRen(tb_imemRen),
    .cuOP(tb_cuOP), 
    .dmmstorei(tb_dmmstorei), .dmmaddri(tb_dmmaddri), .imemaddri(tb_imemaddri), .imemloadi(tb_imemloadi), .dmmloadi(tb_dmmloadi),
    .dmmstoreo(tb_dmmstoreo), .dmmaddro(tb_dmmaddro), .imemaddro(tb_imemaddro), .imemloado(tb_imemloado), .dmmloado(tb_dmmloado));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        tb_nRST = 0; 
        tb_dmmstorei = 0;
        tb_dmmaddri = 0;
        tb_imemaddri = 0;
        tb_cuOP = CU_LH;
        tb_i_ready = 0;
        tb_d_ready = 0; 
        tb_dmmloadi = 0; 
        tb_imemloadi = 0;
       
       #(CLK_PERIOD)
       #(CLK_PERIOD)


        //test i_ready and load word instruction changes dmmRen
    tb_nRST = 1;
    tb_i_ready = 1;
    tb_d_ready = 0;
    tb_cuOP = CU_LB;
    tb_dmmstorei = 32'hABCDABCD;
    tb_dmmaddri = 32'h00010001;
    tb_imemaddri = 32'h12341234;

     @(negedge tb_clk);
     @(posedge tb_clk);

    // test d_ready changes dmmRen and dmmWen to 0;
    tb_i_ready = 0;
    tb_d_ready = 1; 
    tb_cuOP = CU_LH;
    
    @(negedge tb_clk);
    @(posedge tb_clk);

    // test  i_ready and store word instruction
    tb_i_ready = 1;
    tb_d_ready = 0;

    @(negedge tb_clk);
    @(posedge tb_clk);

    tb_cuOP = CU_SW;

    @(negedge tb_clk);
    @(posedge tb_clk);

    tb_dmmstorei = 32'hDACBDACB;
    tb_dmmaddri = 32'h01010101;
    tb_imemaddri = 32'h43214321;

    tb_i_ready = 0;
    tb_d_ready = 1;

    #1
    $finish;
    end
endmodule