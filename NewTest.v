module NewTest (clk,reset,left,right,up,down,segout,scanout,segout_me,buzz,segout_time,scanout_time,play);

input clk,reset,left,right,up,down;
output reg[7:0] segout;
output reg[7:0] scanout,segout_me;
output buzz;
input play;
 reg jiepai,clk_music;
 reg [4:0] j_music = 0;
 reg [16:0] clk_music_count=0;
 reg [7:0] count;
 reg [14:0] tone;
reg [4:0] autoPlayIndex;

reg[25:0] cnt_scan;
reg[30:0] rnd1;
reg[16:0] rnd2;

reg[2:0] x=7, y=7; //用直觀的方式記錄初始玩家的位置，x=y=7->最右下角(q[63])
reg[2:0] ufoX[4], ufoY[4];
reg [2:0] ux[4];
reg [1:0] uy[4];
reg [63:0] me;
reg [1:0] ufoWall[4]; //決定是哪一面牆(0、1、2、3)發出[ufo1]、[ufo2]、[ufo3]
reg [2:0] ufoStart[4]; //決定是哪一面牆的哪個位置(0-7)發出[ufo1]、[ufo2]、[ufo3]
reg [3:0] ufoRecord[4]; //用來記錄走了幾格
reg [1:0] ufoWallFirst[4];

reg clk1;
reg [63:0] q ;
reg [2:0] i,j,r;
reg [1:0] level;
reg [63:0] q1 = 64'b00000101_00000111_11111101_00100000_11111000_00010100_00101010_01000001;
reg[1:0] record=0;

//---此地方為計時器的宣告---------------------------------------------------------------
reg clk_time;
output reg[7:0] segout_time;
output reg[2:0] scanout_time;
reg[25:0] cnt_scan_time;
reg[3:0] sel;
reg [3:0] q_time_0 = 4'h0; 
reg [3:0] q_time_1 = 4'h3; 
//---此地方為計時器的宣告-------------------------------------------------------------------


//------------------ clock running -----------------------
always@(posedge clk )
begin
	cnt_scan<=cnt_scan+1;
	cnt_scan_time<=cnt_scan_time+1;
	clk_music_count = clk_music_count + 1;
	if (clk_music_count == 9765) // 50MHz / 9765 = 1024
	begin
	 clk_music_count = 0;
	 clk_music = !clk_music; //1024 / 2 = 512
	end
	if (cnt_scan == 02500000) begin
	cnt_scan <=0;
	clk1 = ~clk1;
	end
	if(cnt_scan_time == 5000000)begin
	cnt_scan_time<=0;
	clk_time = ~clk_time;
	end
end

always@(posedge clk)
begin
	rnd1 <= rnd1 + 1;
	rnd2 <= rnd2 + 1;

	ux[0] = rnd1[25:23] ^ rnd2[10:8];
	uy[0] = rnd1[21:20] ^ rnd2[15:14];
	ufoWallFirst[0] = rnd1[20:19] ^ rnd2[8:7]; //第一個ufo隨機選取一面牆出發

	ux[1] = rnd1[20:18] ^ rnd2[9:7];
	uy[1] = rnd1[24:23] ^ rnd2[12:11];
	ufoWallFirst[1] = rnd1[16:15] ^ rnd2[9:8]; //第二個ufo隨機選取一面牆出發

	ux[2] = rnd1[15:13] ^ rnd2[13:12];
	uy[2] = rnd1[11:10] ^ rnd2[7:6];
	ufoWallFirst[2] = rnd1[12:11] ^ rnd2[3:2]; //第三個ufo隨機選取一面牆出發
end

//---------modify display digit ----------
always @(posedge clk1 , posedge reset)
begin

	if (reset)
	begin
		record = 1;
		for(i=0;i<4;i=i+1) 
		begin
			ufoX[i] = 0;
			ufoY[i] = 0;
		end
		i = 0;
		level = 1;
		x = 7;
		y = 7;
		q = 64'b00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000;
		me[x+8*y] = 1'b1;
	end
	
	else 
	begin
	
	if (left == 0)  //左移
	begin
		x = x - 1;
		me[x+8*y] = 1'b1;
	end
	
	else if (right == 0)  //右移
	begin
		x = x + 1;
		me[x+8*y] = 1'b1;
	end

	else if (up == 0 ) //上移
	begin
		y = y - 1;
		me[x+8*y] = 1'b1;
	end
	
	else if (down == 0 ) //下移
	begin
		y = y + 1;
		me[x+8*y] = 1'b1;
	end
	
	record = 0;
	if(i <= level)  //創造幾個ufo，未滿兩個(level)時就一直進入這個迴圈，只有遊戲一開始會有這道程序
	begin
		if (ufoX[i] == 0 && ufoY[i] == 0) //如果ufo(ufo[0])的座標皆==0->尚未存在
		begin
			ufoX[i] = ux[i]; //把隨意產生的0-7(從哪一面牆出發)的值給X
			ufoY[i] = uy[i] ; //把隨意產生的0-7(從ufo[i]面牆的哪一個位置)的值給Y
			ufoWall[i] = ufoWallFirst[i] ;
			ufoRecord[0] = 0;
		end
		i = i + 1;
	end
	else //已經創造好兩個ufo了，此時i等於2
		for (j = 0 ; j<= level; j = j+1)
			if (ufoRecord[j]==8) //生命結束或者是走完八格
			begin
				ufoX[j] = ux[j]; //指定一個出現的x座標給他
				ufoY[j] = uy[j]; //指定一個出現的y座標給他
				ufoWall[j] = ufoWallFirst[j];
				ufoRecord[j] = 0;
			end
	q = q & 64'h0000_0000_0000_0000;
	me = me & 64'h0000_0000_0000_0000;
	for(j=0;j<=level;j=j+1) //做兩次，每個ufo做一次
		q[ufoX[j]+8*ufoY[j]] = 1'b1; //ufo亮起來

	for(r=0;r<=level;r=r+1) //每一個ufo都需要做同樣的動作
	begin
		if(ufoRecord[r]<8) //ufoRecord[r]尚未走完所有格數
		begin
			if(ufoWall[r]==0) //如果初發射的牆是0牆的話
			begin
				if(ufoRecord[r] == 0)
				begin
					ufoY[r] = 0; //ufoY[r]若出現在0牆，y值會必須需得是0
				end
				q[ufoX[r]+8*ufoY[r]] = 1'b1; //ufo原地亮
				ufoRecord[r] = ufoRecord[r] + 1; //紀錄ufo走了一格囉
				me[x+8*y] = 1'b1; //角色亮
				ufoY[r] = ufoY[r] + 1; //紀錄ufo走了一格囉，要往下移一個了
			end
	
	if(ufoWall[r]==1) //如果發射的牆是1牆的話，需要往左走
	begin
		if(ufoRecord[r] == 0) //是初發射
		begin
			ufoX[r] = 7; //初發射在1牆的時候，ufoX[r]一定會是7
		end
		q[ufoX[r] + 8*ufoY[r]] = 1'b1; //ufo原地亮
		ufoRecord[r] = ufoRecord[r]+1; //紀錄ufo走了一格囉
		me[x+8*y] = 1'b1; //角色亮
		ufoX[r] = ufoX[r] - 1; //紀錄ufo往左走一格
	end

	if(ufoWall[r]==2) //如果發射的牆是2牆的話，需要往上走
	begin
		if(ufoRecord[r] == 0) //是初發射
		begin
			ufoY[r] = 7; //初發射在2牆的時候，ufoY[r]一定會是7
		end
		q[ufoX[r] + 8*ufoY[r]] = 1'b1; //ufo原地亮
		ufoRecord[r] = ufoRecord[r]+1; //紀錄ufo走了一格囉
		me[x+8*y] = 1'b1; //角色亮
		ufoY[r] = ufoY[r] - 1; //紀錄ufo往上走一格
	end

	if(ufoWall[r]==3) //如果發射的牆是3牆的話，需要往左走
	begin
		if(ufoRecord[r] == 0) //是初發射
		begin
			ufoX[r] = 0; //初發射在3牆的時候，ufoX[r]一定會是0
		end
		q[ufoX[r] + 8*ufoY[r]] = 1'b1; //ufo原地亮
		ufoRecord[r] = ufoRecord[r]+1; //紀錄ufo走了一格囉
		me[x+8*y] = 1'b1; //角色亮
		ufoX[r] = ufoX[r] + 1; //紀錄ufo往右走一格
	end
	end
end

	

	
	if(x == 0 && y==0)
	begin
		q = q1;
end
	for(r=0;r<=level;r=r+1)
	begin
		if((x==ufoX[r] && y==ufoY[r]) || (q_time_1 == 4'h0 && q_time_0 == 4'h0))
		begin
			record = 1;
			for(i=0;i<4;i=i+1) 
			begin
				ufoX[i] = 0;
				ufoY[i] = 0;
			end
			i = 0;
			level = 1;
			x = 7;
			y = 7;
			q = 64'b00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000;
			me[x+8*y] = 1'b1;	
		end
	end
end
end

always@(posedge clk_time)
begin
	if(record == 1)
	begin
		q_time_0 = 4'h0;
		q_time_1 = 4'h3;
	end
	else begin
	if(q_time_0 == 4'h0) //個位數秒q0，q0只要到0了:q0就要回來9，且q1要-1
		begin	
			q_time_1 = q_time_1 - 1; //q1就往下加一
			q_time_0 = 4'h9; //讓個位秒數為9
		end
	else
		q_time_0 = q_time_0 - 1;
	end
end

 //-----------scan and display 7-SEG-------------掃描整個矩陣----------
 
always@(cnt_scan[15:13])
begin
case(cnt_scan[15:13])
3'b000 :
scanout = 8'b0000_0001; 
3'b001 :
scanout = 8'b0000_0010;
3'b010 :
scanout = 8'b0000_0100;
3'b011 :
scanout = 8'b0000_1000;
3'b100 :
scanout = 8'b0001_0000;
3'b101 :
scanout = 8'b0010_0000;
3'b110 :
scanout = 8'b0100_0000;
3'b111 :
scanout = 8'b1000_0000;
default :
scanout = 8'b0000_0001;
endcase
end

always@(scanout) 
begin
case(scanout)
8'b0000_0001:
begin
segout=q[63:56];
segout_me=me[63:56];
end
8'b0000_0010:
begin
segout=q[55:48];
segout_me=me[55:48];
end
8'b0000_0100:
begin
segout=q[47:40];
segout_me=me[47:40];
end
8'b0000_1000:
begin
segout=q[39:32];
segout_me=me[39:32];
end
8'b0001_0000:
begin
segout=q[31:24];
segout_me=me[31:24];
end
8'b0010_0000:
begin
segout=q[23:16];
segout_me=me[23:16];
end
8'b0100_0000:
begin
segout=q[15:8];
segout_me=me[15:8];
end
8'b1000_0000:
begin
segout=q[7:0];
segout_me=me[7:0];
end
default:
begin
segout=8'b11111111;
segout_me=8'b11111111;
end
endcase
end

//--------這裡是計時器的掃描--------------------------------------------------
always@(*)
	scanout_time <= cnt_scan_time[15:13];
	
always@(scanout_time)
begin
	case(scanout_time) //總共有九個七節碼
		3'b000: //第一個七節碼
			sel=q_time_1;
		3'b001: //第二個
			sel=q_time_0;

		default:
			sel=4'hD;
	endcase
end

always@(sel)
begin
	case(sel)
		4'h0:
			segout_time <= 8'b00111111;
		4'h1:
			segout_time <= 8'b00000110;
		4'h2:
			segout_time <= 8'b01011011;
		4'h3:
			segout_time <= 8'b01001111;
		4'h4:
			segout_time <= 8'b01100110;
		4'h5:
			segout_time <= 8'b01101101;
		4'h6:
			segout_time <= 8'b01111101;
		4'h7:
			segout_time <= 8'b00100111;
		4'h8:
			segout_time <= 8'b01111111;
		4'h9:
			segout_time <= 8'b01101111;
		default:
			segout_time <= 8'b00000000;
	endcase
end


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

 always @ (posedge clk_music)
 begin
 if (j_music == 15) begin // 512/ 16 = 32
 j_music <= 0;
 jiepai <= !jiepai; // 32/2 = 16
 end
 else
 j_music <= j_music+1;
 end

 always @(posedge jiepai, posedge reset)
 begin
 if (reset)
 count <= 0;
 else if(play)
 if (jiepai)
 if (count==127 )
 count<=0;
 else
 count<=count+1;
 end


 always @(count) // Canon
 begin
 case (count)
 0 : autoPlayIndex<=5'b11101; //55 //一拍
 1 : autoPlayIndex<=5'b11101; //55
 2 : autoPlayIndex<=5'b11101; //55
 3 : autoPlayIndex<=5'b11101; //55
 4 : autoPlayIndex<=5'b11101; //55
 5 : autoPlayIndex<=5'b11101; //55
 6 : autoPlayIndex<=5'b11101; //55
 7 : autoPlayIndex<=5'b00000; //0
 8 : autoPlayIndex<=5'b11011; //33
 9 : autoPlayIndex<=5'b11011; //33
 10 : autoPlayIndex<=5'b11011; //33
 11 : autoPlayIndex<=5'b00000; //0
 12 : autoPlayIndex<=5'b11100; //44
 13 : autoPlayIndex<=5'b11100; //44
 14 : autoPlayIndex<=5'b11100; //44
 15 : autoPlayIndex<=5'b00000; //0
 16 : autoPlayIndex<=5'b11101; //55
 17 : autoPlayIndex<=5'b11101; //55
 18 : autoPlayIndex<=5'b11101; //55
 19 : autoPlayIndex<=5'b11101; //55
 20 : autoPlayIndex<=5'b11101; //55
 21 : autoPlayIndex<=5'b11101; //55
 22 : autoPlayIndex<=5'b11101; //55
 23 : autoPlayIndex<=5'b00000; //0
 24 : autoPlayIndex<=5'b11011; //33
 25 : autoPlayIndex<=5'b11011; //33
 26 : autoPlayIndex<=5'b11011; //33
 27 : autoPlayIndex<=5'b00000; //0
 28 : autoPlayIndex<=5'b11100; //44
 29 : autoPlayIndex<=5'b11100; //44
 30 : autoPlayIndex<=5'b11100; //44
 31 : autoPlayIndex<=5'b00000; //0
 32 : autoPlayIndex<=5'b11101; //55
 33 : autoPlayIndex<=5'b11101; //55
 34 : autoPlayIndex<=5'b11101; //55
 35 : autoPlayIndex<=5'b00000; //0
 36 : autoPlayIndex<=5'b01101; //5
 37 : autoPlayIndex<=5'b01101; //5
 38 : autoPlayIndex<=5'b01101; //5
 39 : autoPlayIndex<=5'b00000; //0
 40 : autoPlayIndex<=5'b01110; //6
 41 : autoPlayIndex<=5'b01110; //6
 42 : autoPlayIndex<=5'b01110; //6
 43 : autoPlayIndex<=5'b00000; //0
 44 : autoPlayIndex<=5'b01111; //7
 45 : autoPlayIndex<=5'b01111; //7
 46 : autoPlayIndex<=5'b01111; //7
 47 : autoPlayIndex<=5'b00000; //0
 48 : autoPlayIndex<=5'b11001; //11
 49 : autoPlayIndex<=5'b11001; //11
 50 : autoPlayIndex<=5'b11001; //11
 51 : autoPlayIndex<=5'b00000; //0
 52 : autoPlayIndex<=5'b11010; //22
 53 : autoPlayIndex<=5'b11010; //22
 54 : autoPlayIndex<=5'b11010; //22
 55 : autoPlayIndex<=5'b00000; //0
 56 : autoPlayIndex<=5'b11011; //33
 57 : autoPlayIndex<=5'b11011; //33
 58 : autoPlayIndex<=5'b11011; //33
 59 : autoPlayIndex<=5'b00000; //0
 60 : autoPlayIndex<=5'b11100; //44
 61 : autoPlayIndex<=5'b11100; //44
 62 : autoPlayIndex<=5'b11100; //44
 63 : autoPlayIndex<=5'b00000; //0
 64 : autoPlayIndex<=5'b11011; //33
 65 : autoPlayIndex<=5'b11011; //33
 66 : autoPlayIndex<=5'b11011; //33
 67 : autoPlayIndex<=5'b11011; //33
 68 : autoPlayIndex<=5'b11011; //33
 69 : autoPlayIndex<=5'b11011; //33
 70 : autoPlayIndex<=5'b11011; //33
 71 : autoPlayIndex<=5'b00000; //0
 72 : autoPlayIndex<=5'b11001; //11
 73 : autoPlayIndex<=5'b11001; //11
 74 : autoPlayIndex<=5'b11001; //11
 75 : autoPlayIndex<=5'b00000; //0
 76 : autoPlayIndex<=5'b11010; //22
 77 : autoPlayIndex<=5'b11010; //22
 78 : autoPlayIndex<=5'b11010; //22
 79 : autoPlayIndex<=5'b00000; //0
 80 : autoPlayIndex<=5'b11011; //33
 81 : autoPlayIndex<=5'b11011; //33
 82 : autoPlayIndex<=5'b11011; //33
 83 : autoPlayIndex<=5'b11011; //33
 84 : autoPlayIndex<=5'b11011; //33
 85 : autoPlayIndex<=5'b11011; //33
 86 : autoPlayIndex<=5'b11011; //33
 87 : autoPlayIndex<=5'b00000; //0
 88 : autoPlayIndex<=5'b01011; //3
 89 : autoPlayIndex<=5'b01011; //3
 90 : autoPlayIndex<=5'b01011; //3
 91 : autoPlayIndex<=5'b00000; //0
 92 : autoPlayIndex<=5'b01100; //4
 93 : autoPlayIndex<=5'b01100; //4
 94 : autoPlayIndex<=5'b01100; //4
 95 : autoPlayIndex<=5'b00000; //0
 96 : autoPlayIndex<=5'b01101; //5
 97 : autoPlayIndex<=5'b01101; //5
 98 : autoPlayIndex<=5'b01101; //5
 99 : autoPlayIndex<=5'b00000; //0
 100 : autoPlayIndex<=5'b01110; //6
 101 : autoPlayIndex<=5'b01110; //6
 102 : autoPlayIndex<=5'b01110; //6
 103 : autoPlayIndex<=5'b01100; //0
 104 : autoPlayIndex<=5'b01101; //5
 105 : autoPlayIndex<=5'b01101; //5
 106 : autoPlayIndex<=5'b01101; //5
 107 : autoPlayIndex<=5'b00000; //0
 108 : autoPlayIndex<=5'b01100; //4
 109 : autoPlayIndex<=5'b01100; //4
 110 : autoPlayIndex<=5'b01100; //4
 111 : autoPlayIndex<=5'b00000; //0
 112 : autoPlayIndex<=5'b01101; //5
 113 : autoPlayIndex<=5'b01101; //5
 114 : autoPlayIndex<=5'b01101; //5
 115 : autoPlayIndex<=5'b00000; //0
 116 : autoPlayIndex<=5'b01011; //3
 117 : autoPlayIndex<=5'b01011; //3
 118 : autoPlayIndex<=5'b01011; //3
 119 : autoPlayIndex<=5'b00000; //0
 120 : autoPlayIndex<=5'b01100; //4
 121 : autoPlayIndex<=5'b01100; //4
 123 : autoPlayIndex<=5'b01100; //4
 124 : autoPlayIndex<=5'b00000; //0
 125 : autoPlayIndex<=5'b01101; //5
 126 : autoPlayIndex<=5'b01101; //5
 127 : autoPlayIndex<=5'b01101; //5
 default : autoPlayIndex<=0;
 endcase
 end




endmodule

//------這裡是計時器的掃描--------------------------------------------

