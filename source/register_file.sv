
module register_file(
  input logic clk,
  input logic [3:0] KEY,
  input logic [17:0] SW,
  output logic [17:0] LEDR
);
logic [31:0][31:0] arr;
logic [31:0][31:0] arrFF;
integer i;
  // interface
  register_file_if rfif();
  // rf
  register_file RF(CLOCK_50, KEY[2], rfif);

assign wsel = SW[4:0];
assign rsel1 = SW[9:5];
assign rsel2 = SW[14:10];
assign wdat = {29'b0,SW[17:15]};

assign WEN = ~KEY[3];

assign LEDR[8:5] = rdat1[3:0];
assign LEDR[13:10] = rdat2[3:0];

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

always_ff @(posedge clk, negedge KEY[2]) begin : NXTLGC
  if(!KEY[2])
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
