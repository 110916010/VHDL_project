module autoPlay(begin1, clk, autoPlayIndex);
input begin1, clk; //10MHz
output reg [4:0] autoPlayIndex;

 reg jiepai,clk1;
 reg [4:0] j = 0;
 reg [16:0] clkCount=0;
 reg [7:0] count;

 always @(posedge clk)
 begin
 clkCount = clkCount + 1;
 if (clkCount == 9765) // 50MHz / 9765 = 1024
 begin
 clkCount = 0;
 clk1 = !clk1; //1024 / 2 = 512
 end
 end

 always @ (posedge clk1)
 begin
 if (j == 15) begin // 512/ 16 = 32
 j <= 0;
 jiepai <= !jiepai; // 32/2 = 16
 end
 else
 j <= j+1;
 end

 always @(posedge jiepai, posedge begin1)
 begin
 if (begin1==0)
 count <= 0;
 else
 if (jiepai)
 if (count==127 )
 count<=0;
 else
 count<=count+1;
 end


 always @(count) // Canon
 begin
 case (count)
 0 : autoPlayIndex<=5'b01111; //77
 1 : autoPlayIndex<=5'b01111; //77
 2 : autoPlayIndex<=5'b00000; //0
 3 : autoPlayIndex<=5'b01111; //77
 4 : autoPlayIndex<=5'b01111; //77
 5 : autoPlayIndex<=5'b00000; //0
 6 : autoPlayIndex<=5'b01111; //77
 7 : autoPlayIndex<=5'b01111; //77
 8 : autoPlayIndex<=5'b01111; //77
 9 : autoPlayIndex<=5'b01111; //77
 10 : autoPlayIndex<=5'b00000; //0
 11 : autoPlayIndex<=5'b00000; //0
 12 : autoPlayIndex<=5'b01111; //77
 13 : autoPlayIndex<=5'b01111; //77
 14 : autoPlayIndex<=5'b00000; //0
 15 : autoPlayIndex<=5'b01111; //77
 16 : autoPlayIndex<=5'b01111; //77
 17 : autoPlayIndex<=5'b00000; //0
 18 : autoPlayIndex<=5'b01111; //77
 19 : autoPlayIndex<=5'b01111; //77
 20 : autoPlayIndex<=5'b01111; //77
 21 : autoPlayIndex<=5'b01111; //77
 22 : autoPlayIndex<=5'b00000; //0
 23 : autoPlayIndex<=5'b00000; //0
 
 24 : autoPlayIndex<=5'b01111; //77
 25 : autoPlayIndex<=5'b00000; //77
 26 : autoPlayIndex<=5'b00000; //0
 27 : autoPlayIndex<=5'b11010; //2
 28 : autoPlayIndex<=5'b11010; //2
 29 : autoPlayIndex<=5'b00000; //0
 30 : autoPlayIndex<=5'b01101; //55
 31 : autoPlayIndex<=5'b01101; //55
 32 : autoPlayIndex<=5'b01101; //55
 33 : autoPlayIndex<=5'b01101; //55
 34 : autoPlayIndex<=5'b01101; //55
 35 : autoPlayIndex<=5'b01110; //66
 36 : autoPlayIndex<=5'b01110; //66
 37 : autoPlayIndex<=5'b01111; //77
 38 : autoPlayIndex<=5'b01111; //77
 39 : autoPlayIndex<=5'b01111; //77
 40 : autoPlayIndex<=5'b01111; //77
 41 : autoPlayIndex<=5'b01111; //77
 42 : autoPlayIndex<=5'b01111; //77
 43 : autoPlayIndex<=5'b01111; //77
 44 : autoPlayIndex<=5'b01111; //77
 45 : autoPlayIndex<=5'b00000; //0
 46 : autoPlayIndex<=5'b00000; //0
 47 : autoPlayIndex<=5'b00000; //0
 
 48 : autoPlayIndex<=5'b11001; //1
 49 : autoPlayIndex<=5'b11001; //1
 50 : autoPlayIndex<=5'b00000; //0
 51 : autoPlayIndex<=5'b11001; //1
 52 : autoPlayIndex<=5'b11001; //1
 53 : autoPlayIndex<=5'b00000; //0
 54 : autoPlayIndex<=5'b11001; //1
 55 : autoPlayIndex<=5'b11001; //1
 56 : autoPlayIndex<=5'b11001; //1
 57 : autoPlayIndex<=5'b00000; //0
 58 : autoPlayIndex<=5'b11001; //1
 59 : autoPlayIndex<=5'b00000; //0
 60 : autoPlayIndex<=5'b11001; //1
 61 : autoPlayIndex<=5'b00000; //0
 62 : autoPlayIndex<=5'b01111; //7
 63 : autoPlayIndex<=5'b00000; //0
 64 : autoPlayIndex<=5'b01111; //7
 65 : autoPlayIndex<=5'b01111; //7
 66 : autoPlayIndex<=5'b00000; //0
 67 : autoPlayIndex<=5'b01111; //7
 68 : autoPlayIndex<=5'b01111; //7
 69 : autoPlayIndex<=5'b00000; //0
 70 : autoPlayIndex<=5'b01111; //7
 71 : autoPlayIndex<=5'b01111; //7
 
 72 : autoPlayIndex<=5'b00000; //0
 73 : autoPlayIndex<=5'b01111; //7
 74 : autoPlayIndex<=5'b01111; //7
 75 : autoPlayIndex<=5'b00000; //0
 76 : autoPlayIndex<=5'b01111; //7
 77 : autoPlayIndex<=5'b01111; //7
 78 : autoPlayIndex<=5'b00000; //0
 79 : autoPlayIndex<=5'b01110; //6
 80 : autoPlayIndex<=5'b01110; //6
 81 : autoPlayIndex<=5'b00000; //0
 82 : autoPlayIndex<=5'b01110; //6
 83 : autoPlayIndex<=5'b01110; //6
 84 : autoPlayIndex<=5'b00000; //0
 85 : autoPlayIndex<=5'b01111; //7
 86 : autoPlayIndex<=5'b01111; //7
 87 : autoPlayIndex<=5'b00000; //0
 88 : autoPlayIndex<=5'b01110; //6
 89 : autoPlayIndex<=5'b01110; //6
 90 : autoPlayIndex<=5'b01110; //6
 91 : autoPlayIndex<=5'b01110; //6
 92 : autoPlayIndex<=5'b00000; //0
 93 : autoPlayIndex<=5'b11010; //2
 94 : autoPlayIndex<=5'b11010; //2
 95 : autoPlayIndex<=5'b00000; //0
 
 
 default : autoPlayIndex<=0;
 endcase
 end
 endmodule 