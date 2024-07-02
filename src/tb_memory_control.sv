
`timescale 1ms / 100us

module tb_memory_control();
    localparam CLK_PERIOD = 10;

    logic tb_clk, tb_nRST, tb_dmmRen, tb_dmmWen, tb_imemRen, tb_busy_o;
    logic tb_i_ready, tb_d_ready, tb_Ren, tb_Wen, tb_i_wait, tb_d_wait;
    logic [31:0] tb_imemaddr, tb_dmmaddr, tb_dmmstore, tb_ramload;
    logic [31:0] tb_ramaddr, tb_ramstore, tb_imemload, tb_dmmload;

     always begin
        tb_clk = 1'b0; 
        #(CLK_PERIOD / 2.0);
        tb_clk = 1'b1; 
        #(CLK_PERIOD / 2.0); 
    end

    memory_control DUT (.CLK(tb_clk), .nRST(tb_nRST), .i_wait(tb_i_wait), .d_wait(tb_d_wait),
                        .dmmRen(tb_dmmRen), .dmmWen(tb_dmmWen), .imemRen(tb_imemRen), .busy_o(tb_busy_o),
                        .i_ready(tb_i_ready), .d_ready(tb_d_ready), .Ren(tb_Ren), .Wen(tb_Wen),
                        .imemaddr(tb_imemaddr), .dmmaddr(tb_dmmaddr), .dmmstore(tb_dmmstore), .ramload(tb_ramload),
                        .ramaddr(tb_ramaddr), .ramstore(tb_ramstore), .imemload(tb_imemload), .dmmload(tb_dmmload));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        tb_nRST = 0;
        tb_dmmRen = 0;
        tb_dmmWen = 0;
        tb_imemRen = 1;
        tb_busy_o = 0;
        tb_imemaddr = 0;
        tb_dmmaddr = 0;
        tb_dmmstore = 0;
        tb_ramload = 0;

         @(negedge tb_clk);
         @(posedge tb_clk);

        tb_dmmaddr = 32'hABCD1234;
        tb_dmmstore = 32'h9876DCBA;
        tb_ramload = 32'h99991111;
        tb_imemaddr = 32'h11119999;
        tb_busy_o = 1;
        tb_nRST = 1;
        tb_imemRen = 1; 

         @(negedge tb_clk);
         @(posedge tb_clk);

        tb_dmmRen = 1;
        
        @(negedge tb_clk);
        @(posedge tb_clk);

        tb_dmmRen = 0;

        @(negedge tb_clk);
        @(posedge tb_clk);

        tb_dmmWen = 1;

        
        
     #1;
     $finish;
    end
endmodule