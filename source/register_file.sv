`include "register_file_if.vh"
`include "cpu_types_pkg.vh"
module register_file(
    input logic CLK,
    input logic nRST,
    register_file_if.rf rfif
);
import cpu_types_pkg::*;
// logic [31:0][31:0] arr;
// logic [31:0][31:0] arrFF;
word_t [31:0] arr;
word_t [31:0] arrFF;
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
always_ff @(negedge CLK, negedge nRST) begin : NXTLGC
  if(!nRST)
  begin
    // for(i = 0; i < 32; i = i + 1)
    //   arrFF[i] <= '0;
    arrFF <= '0;
  end
  else
  begin
    // for(i = 0; i < 32; i = i + 1)
    //   arrFF[i] <= arr[i];
    
    //arrFF <= arr;
    arrFF <= arr;
  end
  
end

always_comb begin : COMBLGC
    arr = arrFF;
    if(rfif.WEN)
    begin
        if(rfif.wsel != '0)
            arr[rfif.wsel] = rfif.wdat;
        // else
        //     arr[0] = '0;
    end
end



assign rfif.rdat1 = arrFF[rfif.rsel1];
assign rfif.rdat2 = arrFF[rfif.rsel2];

// always_ff(negedge clk, posedge nRST) begin
//   if (!nRST) begin
//     arrFF <= 0;
//   end
//   else if (rfif.WEN) begin
//       arrFF[31:1] <= arr;
//   end
// end


endmodule
