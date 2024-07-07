module request_ram (
    input logic clk, nRst, write_enable, 
    input logic [31:0] addr,
    input logic [31:0] data_in,
    output logic [31:0] data_out,
    output logic busy,
    output logic [31:0] display
);

reg [31:0] memory [31:0];
//logic [31:0] nxt_memory [31:0];

typedef enum logic {IDLE, WAIT} StateType;
StateType state, next_state;

initial begin
    $readmemh("fill.mem", memory);
end
always_ff @(posedge clk, negedge nRst) begin
    if (!nRst) begin
        
        state <= IDLE;
    end else begin
        if(write_enable) begin
            memory [addr] <= data_in;
        end
        state <= next_state;
    end
end

always_comb begin
    next_state = state;
  
    busy = 0;

    case (state)
        IDLE : begin
            busy = 0;
            // next_state = WAIT;
            next_state = IDLE;
         
        end

        WAIT : begin
            next_state = IDLE;
            busy = 1;
        end
    endcase  
    display = {memory [0]};
end

assign data_out = memory[addr>>2];

endmodule