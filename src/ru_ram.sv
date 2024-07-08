// module ru_ram (
//     input logic clk, nRst, write_enable, 
//     input logic [31:0] addr,
//     input logic [31:0] data_in,
//     output logic [31:0] data_out,
//     output logic busy,
//     output logic [31:0] display
// );

// logic [31:0] memory [31:0];
// logic [31:0] nxt_memory [31:0];

// typedef enum logic {IDLE, WAIT} StateType;
// StateType state, next_state;

// always_ff @(posedge clk, negedge nRst) begin
//     if (!nRst) begin
//         $readmemh("fill.mem", memory);
//         state <= IDLE;
//     end else begin
//         for (int i = 0;i<32 ;i++ ) begin
//             memory[i] <= nxt_memory[i];
//         end
//         state <= next_state;
//     end
// end

// always_comb begin
//     next_state = state;
//     for (int i = 0;i<32 ;i++ ) begin
//         nxt_memory[i] = memory[i];
//     end

//     busy = 0;

//     case (state)
//         IDLE : begin
//             busy = 0;
//             // next_state = WAIT;
//             next_state = IDLE;
//             if (write_enable) begin
//                 nxt_memory[addr>>2] = data_in;
//             end 
//         end

//         WAIT : begin
//             next_state = IDLE;
//             busy = 1;
//         end
//     endcase  
//     display = {memory [0]};
// end

// assign data_out = memory[addr>>2];

// endmodule



module ru_ram (
    input logic clk, nRst, write_enable, 
    input logic [31:0] addr,
    input logic [31:0] data_in,
    output logic [31:0] data_out,
    output logic busy,
    output logic [31:0] display
);

logic [31:0] memory [4095:0];
logic [31:0] nxt_memory;

typedef enum logic {IDLE, WAIT} StateType;
StateType state, next_state;

always_ff @(posedge clk, negedge nRst) begin
    if (!nRst) begin
        $readmemh("fill.mem", memory);
        state <= IDLE;
    end else begin
        memory[addr>>2] <= nxt_memory;
        state <= next_state;
    end
end

always_comb begin
    next_state = state;
    nxt_memory = memory[addr>>2];

    busy = 0;

    case (state)
        IDLE : begin
            busy = 0;
            // next_state = WAIT;
            next_state = IDLE;
            if (write_enable) begin
                nxt_memory = data_in;
            end 
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