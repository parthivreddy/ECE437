
module register_file(
    input logic CLK,
    input logic nRST,
    input logic [31:0] wdat,
    input logic [4:0] rsel1, 
    input logic [4:0] rsel2, 
    input logic [4:0] wsel,
    input logic WEN,
    output logic [31:0] rdat1, 
    output logic [31:0] rdat2
);
logic [31:0][31:0] arr;
logic [31:0][31:0] arrFF;
// logic [31:0] wdat, rdat1, rdat2;
// logic [4:0] rsel1, rsel2, wsel;
// logic WEN;
integer i;

// assign wsel = SW[4:0];
// assign rsel1 = SW[9:5];
// assign rsel2 = SW[14:10];
// assign wdat = {29'b0,SW[17:15]};

// assign WEN = ~KEY[3];

// assign LEDR[8:5] = rdat1[3:0];
// assign LEDR[13:10] = rdat2[3:0];

//MY CODE
//give R0 constant value of 0
//assign arr[0] = '0;

always_comb begin : COMBLGC
  if(WEN)
  begin
    if(wsel != '0)
      arr[wsel] = wdat;
    else
      arr[0] = '0;
  end
  else
  begin
    arr[wsel] = arr[wsel]; //here could put a for loop that would keep prev values for all registers?
  end
end

always_ff @(posedge CLK, negedge nRST) begin : NXTLGC
  if(!nRST)
  begin
    for(i = 0; i < 32; i = i + 1)
      arrFF[i] <= '0;
  end
  else
  begin
    for(i = 0; i < 32; i = i + 1)
      arrFF[i] <= arr[i];
  end
  
end

assign rdat1 = arrFF[rsel1];
assign rdat2 = arrFF[rsel2];

// for (i = 0; i < 32; i = i+ 1)
// begin
//   assign arr[rfif.wsel] = rfif.wdat;
// end

endmodule
