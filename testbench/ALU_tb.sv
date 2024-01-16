// mapped needs this
`include "ALU_if.vh"
import cpu_types_pkg::*;
// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module ALU_tb;

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
alu.op = ALU_SLL;
alu.port_a = 3;
alu.port_b = 4;
assert(alu.ALU_output == 32) else $display("WRONG1\n");

#(PERIOD);

testType = "Shift Right";
alu.op = ALU_SRL;
alu.port_a = 2;
alu.port_b = 16;
assert(alu.ALU_output == 4) else $display("WRONG2\n");

#(PERIOD);

testType = "ADD";
alu.op = ALU_ADD;
alu.port_a = 13;
alu.port_b = 25;
assert(alu.ALU_output == alu.port_a + alu.port_b) else $display("WRONG3\n");

#(PERIOD);

testType = "ADD OVERFLOW";
alu.op = ALU_ADD;
alu.port_a = 32'hFFFFFFFF;
alu.port_b = 32'h80000000;
assert(alu.ALU_output == 32'h7FFFFFFF) else $display("WRONG4.1\n");
assert(alu.ov == 1) else $display("WRONG4.2\n");

#(PERIOD);

testType = "SUB";
alu.op = ALU_SUB;
alu.port_a = 8;
alu.port_b = 2;
assert(alu.ALU_output == alu.port_a - alu.port_b) else $display("WRONG5.1\n");
assert(alu.ov == 0) else $display("WRONG5.2\n");

#(PERIOD);
testType = "SUB NEGATIVE";
alu.op = ALU_SUB;
alu.port_a = -5;
alu.port_b = 10;
assert(alu.ALU_output == alu.port_a - alu.port_b) else $display("WRONG6.1\n");
assert(alu.ov == 0) else $display("WRONG6.2\n");

#(PERIOD);
testType = "AND";
alu.op = ALU_AND;
alu.port_a = 32'hFFFFFFFF;
alu.port_b = 32'h11111111;
assert(alu.ALU_output == alu.port_b) else $display("WRONG7\n");

#(PERIOD);
testType = "OR";
alu.op = ALU_OR;
alu.port_a = 32'h11111111;
alu.port_b = 32'h22222222;
assert(alu.ALU_output == 32'h33333333) else $display("WRONG8\n");

#(PERIOD);
testType = "XOR";
alu.op = ALU_XOR;
alu.port_a = 32'hFFFFFFFF;
alu.port_b = 32'hFFFF0000;
assert(alu.ALU_output == 32'h0000FFFF) else $display("WRONG9\n");

#(PERIOD);
testType = "NOR";
alu.op = ALU_NOR;
alu.port_a = 32'h00001111;
alu.port_b = 32'h00002222;
assert(alu.ALU_output == 32'hFFFFCCCC) else $display("WRONG10\n");

#(PERIOD);
testType = "SLT";
alu.op = ALU_SLT;
alu.port_a = 32'hFFFFFFFF;
alu.port_b = 32'd1;
assert(alu.ALU_output == 1) else $display("WRONG11\n");

#(PERIOD);
testType = "SLTU";
alu.op = ALU_SLTU;
alu.port_a = 32'hFFFFFFFF;
alu.port_b = 32'd1;
assert(alu.ALU_output == 0) else $display("WRONG12\n");

#(PERIOD);

end
endprogram