/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;
  integer i;

  logic CLK = 0, nRST;
  logic [4:0] regNums;
  logic [31:0] regVals;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test PROG ();
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif


program test;

  
  task reset;
    begin
      nRST = 0;
      #(PERIOD);
      $info("\nCheck To Make Sure Reset to 0\n");
      nRST = 1;
      #(PERIOD);
    end
  endtask

  task write;
    input regNum;
    input val;
    begin
      rfif.wsel = regNum;
      rfif.wdat = val;
      #(PERIOD);
      $info("\nCheck if Specificied Register has appropriate Val\n");
    end
  endtask

  task read;
    input regNum1;
    input regNum2;
    input regVal1;
    input regVal2;
    begin
      rfif.rsel1 = regNum1;
      rfif.rsel2 = regNum2;
      #(PERIOD);
      $info("\nCheck if read values correctly\n");
      if(rfif.rdat1 != regVal1 || rfif.rdat2 != regVal2)
        $error("Incorrect reading\n");
      else
        $info("Correct reading\n");
    end
  endtask

  task readWrite;
    begin
      for(i = 0; i < 32; i = i+ 1)
      begin
        regNums = i;
        regVals = i;
        write(regNums, regVals);
        read(regNums, regNums, regVals, regVals);
      end
    end
  endtask

initial begin
  nRST = 1;
  rfif.WEN = 1;

  reset();

  write(5'd10, 32'd10);
  write(5'd9, 32'd9);
  read(5'd10, 5'd9, 32'd10, 32'd9);

  reset();
  write(5'd0, 32'd100);
  write(5'd5, 32'd5);
  read(5'd0, 5'd5, 32'd0, 32'd5);

  readWrite();
end

endprogram
endmodule
