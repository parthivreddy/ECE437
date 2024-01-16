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

  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  // test PROG (
  //   .rdat2 (rfif.rdat2),
  //   .rdat1 (rfif.rdat1),
  //   .wdat (rfif.wdat),
  //   .rsel2 (rfif.rsel2),
  //   .rsel1 (rfif.rsel1),
  //   .wsel (rfif.wsel),
  //   .WEN (rfif.WEN),
  //   .nRST (nRST),
  //   .CLK (CLK)
  // );
  test PROG(CLK, nRST, rfif);
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
  // register_file DUT(
  //   .rdat2 (rfif.rdat2),
  //   .rdat1 (rfif.rdat1),
  //   .wdat (rfif.wdat),
  //   .rsel2 (rfif.rsel2),
  //   .rsel1 (rfif.rsel1),
  //   .wsel (rfif.wsel),
  //   .WEN (rfif.WEN),
  //   .nRST (nRST),
  //   .CLK (CLK)
  // );
endmodule

// program test (
//   input logic CLK,
//   input logic [31:0] rdat1, rdat2,
//   output logic WEN, nRST,
//   output logic [4:0] rsel1, rsel2, wsel,
//   output logic [31:0] wdat
// );
//   parameter PERIOD = 10;
//   logic [4:0] regNums;
//   logic [31:0] regVals;
//   integer testNum = 0;
//   string testType;
  
//   task reset;
//     begin
//       testType = "RESET";
//       nRST = 0;
//       #(PERIOD);
//       $display("\nCheck To Make Sure Reset to 0\n");
//       nRST = 1;
//       #(PERIOD);
//     end
//   endtask

//   task write;
//     input regNum;
//     input val;
//     begin
//       testType = "Writing";
//       $display("Writing to %d reg at %t time\n", regNum, $time);
//       wsel = regNum;
//       wdat = val;
//       #(PERIOD);
//       $display("\nCheck if Specificied Register has appropriate Val\n");
//     end
//   endtask

//   task read;
//     input regNum1;
//     input regNum2;
//     input regVal1;
//     input regVal2;
//     begin
//       rsel1 = regNum1;
//       rsel2 = regNum2;
//       #(PERIOD);
//       $display("\nChecking reg %d and %d, at time: %t\n", regNum1, regNum2, $time);
//       if(rdat1 != regVal1 || rdat2 != regVal2)
//         $error("Incorrect reading\n");
//       else
//         $display("Correct reading: %t\n", $time);
//     end
//   endtask

//   task readWrite;
//     begin
//       for(int i = 0; i < 32; i = i+ 1)
//       begin
//         regNums = i;
//         regVals = i;
//         write(regNums, regVals);
//         read(regNums, regNums, regVals, regVals);
//       end
//     end
//   endtask

// initial begin
//   nRST = 1;
//   WEN = 1;
//   rsel1 = 0;
//   rsel2 = 0;
//   wsel = 0;
//   wdat = 0;

//   reset();

//   write(5'd10, 32'd10);
//   write(5'd9, 32'd9);
//   read(5'd10, 5'd9, 32'd10, 32'd9);

//   reset();
//   write(5'd0, 32'd100);
//   write(5'd5, 32'd5);
//   read(5'd0, 5'd5, 32'd0, 32'd5);

//   readWrite();
// end

program test (
  input logic CLK,
  output logic nRST,
  register_file_if.tb rfif
);
  parameter PERIOD = 10;
  logic [4:0] regNums;
  logic [31:0] regVals;
  integer testNum = 0;
  string testType;
  
  task reset;
    begin
      testType = "RESET";
      nRST = 0;
      rfif.wdat = 0;
      #(PERIOD);
      $display("\nCheck To Make Sure Reset to 0\n");
      nRST = 1;
      #(PERIOD);
    end
  endtask

  task write;
    input [4:0] regNum;
    input [31:0] val;
    begin
      testType = "Writing";
      $display("Value: %d\n", val);
      $display("Writing to %d reg at %t time\n", regNum, $time);
      rfif.wsel = regNum;
      rfif.wdat = val;
      #(PERIOD);
      $display("\nCheck if Specificied Register has appropriate Val\n");
    end
  endtask

  task read;
    input [4:0] regNum1;
    input [4:0] regNum2;
    input [31:0] regVal1;
    input [31:0] regVal2;
    begin
      testType = "Reading";
      rfif.rsel1 = regNum1;
      rfif.rsel2 = regNum2;
      #(PERIOD);
      $display("\nChecking reg %d and %d, at time: %t\n", regNum1, regNum2, $time);
      if(rfif.rdat1 != regVal1 || rfif.rdat2 != regVal2)
        $error("Incorrect reading\n");
      else
        $display("Correct reading: %t\n", $time);
    end
  endtask

  task readWrite;
    begin
      for(int i = 0; i < 32; i = i+ 1)
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
  rfif.rsel1 = 0;
  rfif.rsel2 = 0;
  rfif.wsel = 0;
  rfif.wdat = 0;

  reset();
  write(5'd0, 32'd7);
  write(5'd1, 32'd3);
  read(5'd0, 5'd1, 32'd0, 32'd3);

  reset();

  write(5'd10, 32'd10);
  write(5'd9, 32'd9);
  read(5'd10, 5'd9, 32'd10, 32'd9);

  reset();
  write(5'd0, 32'd100);
  write(5'd5, 32'd5);
  read(5'd0, 5'd5, 32'd0, 32'd5);

  reset();

  readWrite();
end
endprogram
