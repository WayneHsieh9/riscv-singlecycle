// FPGA Top Level

`default_nettype none

	typedef enum logic [2:0] {
        INIT, NUM1, NUM2, FINAL
    } stateLog;

module FPGAModuleCalc (
  // I/O ports
  input logic displayCPU, //check for this condition to display equal output
  input logic inputFromRam,
  input  logic hz100, reset,
  input  logic [20:0] pb,
  output logic [7:0] ss7, ss6, ss4, ss3, ss1, ss0,

  output logic[31:0] addressOut,   //will be the address that will be written to for the data
  output logic[31:0]dataOut,
  output logic memEnable
);

    stateLog currentState, nextState;


    logic keyStrobe;

    logic [31:0] r1Val, r2Val, nextR1Val, nextR2Val;
    logic [3:0] operation, nextOperation;
    
    logic [31:0] decOut;
    logic [4:0] dumpVar;

    logic [31:0]r1Count, r2Count, r1NextCount, r2NextCount;

    keysync f1 (.clk(hz100), .keyin(pb[19:0]), .keyclk(keyStrobe), .rst(reset), .keyout(dumpVar));

    /*temporary test code for ss display*/

    integer tens1, ones1;
    integer tens2, ones2;
    logic [3:0]hundredsLog1, tensLog1, onesLog1;
    logic [3:0]hundredsLog2, tensLog2, onesLog2;
    integer temp1;
    integer temp2;
    logic [15:0] operationDis, nextOperationDis;

   always_comb begin

        temp1 = r1Val;

        tens1 = temp1 / 10;
        ones1 = temp1 % 10;

        tensLog1 = tens1[3:0];
        onesLog1 = ones1[3:0];

        temp2 = r2Val;

        tens2 = temp2 / 10;
        ones2 = temp2 % 10;

        tensLog2 = tens2[3:0];
        onesLog2 = ones2[3:0];

    end



    ssdec f2 (.in(onesLog1), .enable(1'b1), .out(ss6[6:0]));
    ssdec f3 (.in(tensLog1), .enable(1'b1), .out(ss7[6:0]));
    ssdec f4 (.in(onesLog2), .enable(1'b1), .out(ss0[6:0]));
    ssdec f5 (.in(tensLog2), .enable(1'b1), .out(ss1[6:0]));

    assign {ss4, ss3} = operationDis;

    

//for when we receive the "Equal" output from the CPU, we need an additional comb block for determining what will be displayed on the ss displays

    ////////////////////////////////

    always_ff@(posedge keyStrobe, negedge reset)
        if (~reset) begin
            currentState <= NUM1;
            r1Val <= 0;
            r2Val <= 0;
            operation <= 0;
            operationDis <= 16'b0;
            r1Count <= 0;
            r2Count <= 0;
        end
        else begin
            currentState <= nextState;
            r1Val <= nextR1Val;
            r2Val <= nextR2Val;
            operation <= nextOperation;
            operationDis <= nextOperationDis;
            r1Count <= r1NextCount;
            r2Count <= r2NextCount;
        end

    decoder f7 (.pbIn(pb[19:0]), .decOut(decOut));

    //li t6, 0x140  # load the immediate 0x140 (address) into register t6
    //sw t0, 0(t6)  # store the word in t0 to memory address in t6 with 0 byte offset   

        always_comb begin

        casez({currentState, |pb[10:0], |pb[19:16], pb[14], pb[12]}) //numbers, operation, equal, clear 

        
            // {INIT, 1'b0, 1'b0, 1'b0, 1'b0}: begin //calculator starts, immediately goes to the num1 state to start taking in numbers
            //     nextState = NUM1;
            //     nextR1Val = 0;
            //     nextR2Val = 0;
            //     nextOperation = 0;

            // end

            {NUM1, 1'b1, 1'b0, 1'b0, 1'b0}: begin //inputting numbers begins for num1
                nextState = NUM1;
                r1NextCount = r1Count + 1'b1;
                r2NextCount = r2Count;
                if (r1Count == 32'b00 | r1Count == 32'b01)
                    nextR1Val = decOut + (r1Val << 3) + (r1Val << 1);
                else
                    nextR1Val = r1Val;
                nextR2Val = 0; 
                nextOperation = 0;
                nextOperationDis = 0;
                addressOut = 0;
                dataOut = 0;
                memEnable = 0;

            end

            {NUM1, 1'b0, 1'b1, 1'b0, 1'b0}: begin // operation button was pressed, thus moving on to num2 state
                
                nextState = NUM2;
                r1NextCount = r1Count;
                r2NextCount = r2Count;
                nextR1Val = r1Val;
                nextR2Val = r2Val;
                if (pb[19]) begin
                    nextOperation = 4'b1000; //add
                    nextOperationDis = 16'b01110111_01011110;
                end
                else if (pb[18]) begin //sub
                    nextOperation = 4'b0100;
                    nextOperationDis = 16'b01101101_00111110;
                end
                else if (pb[17]) begin //multiply
                    nextOperation = 4'b0010;
                    nextOperationDis = 16'b01111000_00010000;
                end
                else if (pb[16]) begin //division
                    nextOperation = 4'b0001;
                    nextOperationDis = 16'b01011110_00010000;
                end
                else begin
                    nextOperation = 4'b0000;
                    nextOperationDis = 16'b00111111_00111111;
                end

                addressOut = 32'd20000;
                dataOut = r1Val;
                memEnable = 1;
            end
            

            {NUM2, 1'b1, 1'b0, 1'b0, 1'b0}: begin //inputting numbers right now, will stay at state num2
                
                r1NextCount = r1Count;
                r2NextCount = r2Count + 1'b1;
                nextState = NUM2;
                nextR1Val = r1Val;
                if (r2Count == 32'b00 | r2Count == 32'b01)    
                    nextR2Val = decOut + (r2Val << 3) + (r2Val << 1);
                else
                    nextR2Val = r2Val;

                nextOperation = operation;
                nextOperationDis = operationDis;

                addressOut = 32'd20200;
                dataOut = {28'b0, operation};
                memEnable = 1;
                

            end
            
           {NUM2, 1'b0, 1'b0, 1'b1, 1'b0}: begin //the E (equal button was pressed, thus moving onto the calculation, next final state)
            
            nextState = FINAL; 
            nextR1Val = r1Val;
            nextR2Val = r2Val;
            nextOperation = operation;
            nextOperationDis = operationDis;
            r1NextCount = r1Count;
            r2NextCount = r2Count;
            addressOut = 32'd20400;
            dataOut = r2Val;
            memEnable = 1;

           end

           {FINAL, 1'b1, 1'b0, 1'b0, 1'b1}: begin //the final state is on, we stay here
            
            nextState = NUM1;
            nextR1Val = r1Val;
            nextR2Val = r2Val;
            nextOperation = operation;
            nextOperationDis = operationDis;
            r1NextCount = r1Count;
            r2NextCount = r2Count;
            addressOut = 32'd30000;
            dataOut = 0;
            memEnable = 0;
           end

            {3'b???, 1'b0, 1'b0, 1'b0, 1'b1}: begin //from any state if the clear is pressed
            
            nextState = NUM1;
            nextR1Val = 0;
            nextR2Val = 0;
            nextOperation = 0;
            nextOperationDis = 0;
            r1NextCount = 0;
            r2NextCount = 0;
            addressOut = 32'd30000; //dump address
            dataOut = 0;
            memEnable = 0;
           end

           default: begin
                nextState = currentState;
                nextR1Val = r1Val;
                nextR2Val = r2Val;
                nextOperation = operation;
                nextOperationDis = operationDis;
                r1NextCount = r1Count;
                r2NextCount = r2Count;
                addressOut = 32'd30000; //dump address
                dataOut = 0;
                memEnable = 0;
           end

        endcase

        /*
        if (currentState == FINAL)
            memWrite = 
        else
            memWrite = 0;
        */

        end

        

endmodule

module decoder (input logic [19:0] pbIn,
                output logic [31:0] decOut);

    always_comb
        if (pbIn[9])
            decOut = 32'b1001;
        else if (pbIn[8])
            decOut = 32'b1000;
        else if (pbIn[7])
            decOut = 32'b0111;
        else if (pbIn[6])
            decOut = 32'b0110;
        else if (pbIn[5])
            decOut = 32'b0101;
        else if (pbIn[4])
            decOut = 32'b0100;
        else if (pbIn[3])
            decOut = 32'b0011;
        else if (pbIn[2])
            decOut = 32'b0010;
        else if (pbIn[1])
            decOut = 32'b0001;
        else
            decOut = 0;
endmodule