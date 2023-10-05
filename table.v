module toneTable (autoPlayIndex, tone);
 input [4:0] autoPlayIndex;
 output reg [14:0] tone;

 always @ (autoPlayIndex)
 case (autoPlayIndex)
 5'b01001: tone = 9542; // DO 262 HZ
 5'b01010: tone = 8504; // RE 294 HZ
 5'b01011: tone = 7576; // Mi 330 Hz
 5'b01100: tone = 7162; // Fa 349 Hz
 5'b01101: tone = 6378; // SO 392 Hz
 5'b01110: tone = 5682; // La 440 Hz
 5'b01111: tone = 5060; // Si 494 Hz
 5'b11001: tone = 4771; // DO 523 Hz
 5'b11010: tone = 4252; // Re 587 Hz
 5'b11011: tone = 3788; // Mi 659 Hz
 5'b11100: tone = 3581; // Fa 698 Hz
 5'b11101: tone = 3189; // So 784 Hz
 5'b11110: tone = 2841; // La 880 Hz
 5'b11111: tone = 2530; // Si 988 Hz

 default : tone = 0;
 endcase
 endmodule 