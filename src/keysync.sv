module keysync (
 input logic clk,
 input logic rst,
 input logic [19:0] keyin,
 output logic [4:0] keyout,
 output logic keyclk
);
logic delay;
 assign keyout[4] = keyin[16] | keyin[17] | keyin[18] | keyin[19];
 assign keyout[3] = keyin[15] | keyin[14] | keyin[13] | keyin[12] | keyin[11] | keyin[10] | keyin[9] | keyin[8];
 assign keyout[2] = keyin[15] | keyin[14] | keyin[13] | keyin[12] | keyin[7] | keyin[6] | keyin[5] | keyin[4];
 assign keyout[1] = keyin[19] |keyin[18] | keyin[15] | keyin[14] | keyin[11] | keyin[10] | keyin[7] | keyin[6] | keyin[3] | keyin[2];
 assign keyout[0] = keyin[19] | keyin[17] | keyin[15] | keyin[13] | keyin[11] | keyin[9] | keyin[7] | keyin[5] | keyin[3] | keyin[1];

always_ff @(posedge clk or negedge rst) begin
 if(~rst) begin
    delay <= 0;
    keyclk <= 0;
 end else begin
  keyclk <= delay;
  delay <= |keyin;
 end
end
endmodule