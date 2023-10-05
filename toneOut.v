module toneOut (clk, toneIn, buzzOut );
 input clk; // 10MHz
 input [14:0] toneIn;
 output reg buzzOut;

 reg clk1;
 reg [4:0] clkCount;
 reg [14:0] i=0;

 always @ (posedge clk)
 begin
 clk1 <= ~clk1; // 10MHz / 2 = 5MHz
 end

 always @(posedge clk1) // clk1 = 5MHz
 begin
  if (i == toneIn)
 begin
 i <= 0;
 buzzOut <= !buzzOut;
 end
 else
 i<= i + 1;
end

 endmodule 