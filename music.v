module music (clk, begin1, buzz);
input clk,begin1;
output buzz;

wire [4:0] playIndex;
wire [14:0] tone;

autoPlay play(begin1, clk, playIndex);
toneTable toneOut(playIndex, tone);
toneOut speeker(clk,tone,buzz);

endmodule 