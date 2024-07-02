module ssdec (
input logic [3:0] in,
input logic enable,
output logic [6:0] out
);

/* Hexadecimal 7-Segment Decoder */
 logic [6:0] seg7 [15:0];
 assign seg7[4'h0] = 7'b0111111;
 assign seg7[4'h1] = 7'b0000110;
 assign seg7[4'h2] = 7'b1011011;
 assign seg7[4'h3] = 7'b1001111;
 assign seg7[4'h4] = 7'b1100110;
 assign seg7[4'h5] = 7'b1101101;  
 assign seg7[4'h6] = 7'b1111101;
 assign seg7[4'h7] = 7'b0000111;
 assign seg7[4'h8] = 7'b1111111;
 assign seg7[4'h9] = 7'b1100111;
 assign seg7[4'ha] = 7'b1110111;
 assign seg7[4'hb] = 7'b1111100;
 assign seg7[4'hc] = 7'b0111001;
 assign seg7[4'hd] = 7'b1011110;
 assign seg7[4'he] = 7'b1111001;
 assign seg7[4'hf] = 7'b1110001;
 
 assign out = enable ? seg7[in] : (7'b0000000);
endmodule