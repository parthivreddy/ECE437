// mapped needs this
`include "ALU_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  ALU_if alu ();

  test PROG(alu);
  // DUT
`ifndef MAPPED
  ALU DUT(alu);
`else
  ALU DUT(
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
endmodule

program test(
    ALU_if alu
);
parameter PERIOD = 10;
string testType;

///////////////////////
initial begin
testType = "Shift Left";
alu.port_a = 3;
alu.port_b = 4;
assert(alu.ALU_output == alu.port_b * (2 ** alu.port_a));

#(PERIOD);

testType = "Shift Right";
alu.port_a = 2;
alu.port_b = 16;
assert(alu.ALU_output == alu.port_b / (2 ** alu.port_a));

#(PERIOD);

testType = "ADD";
alu.port_a = 13;
alu.port_b = 25;
assert(alu.ALU_output == alu.port_a + alu.port_b);

#(PERIOD);

testType = "ADD OVERFLOW";
alu.port_a = 32'hFFFFFFFF;
alu.port_b = 1;
assert(alu.ALU_output == 0);
assert(alu.ov = 1);

#(PERIOD);

testType = "SUB";
alu.port_a

end
endprogram