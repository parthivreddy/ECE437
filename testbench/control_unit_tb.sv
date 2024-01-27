`include "control_unit_if.vh"
import cpu_types_pkg::*;
// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

`include "cpu_types_pkg.vh"

module control_unit_tb;
    logic nRST;
  parameter PERIOD = 10;

  logic CLK = 0;

  // clock
  always #(PERIOD/2) CLK++;

  control_unit_if ctif();
  test PROG(CLK, nRST, ctif);
  control_unit DUT(CLK, nRST, ctif);
endmodule

program test(
    input logic CLK,
    output logic nRST,
    control_unit_if.tb ctif
);
    parameter PERIOD = 10;
    string testType;
    string subTest;
    initial begin
    //R type test case
        testType = "R type";
        ctif.opcode = opcode_t'(6'b000000);
        subTest = "SLL";
        ctif.func = funct_t'(6'b000100);
        #(PERIOD);
        subTest = "SRL";
        ctif.func = funct_t'(6'b000110);
        #(PERIOD);
        subTest = "JR";
        ctif.func = funct_t'(6'b001000);
        #(PERIOD);
        subTest = "ADDU";
        ctif.func = funct_t'(6'b100001);
        #(PERIOD);
        subTest = "ADD";
        ctif.func = funct_t'(6'b100000);
        #(PERIOD);
        subTest = "SUB";
        ctif.func = funct_t'(6'b100010);
        #(PERIOD);
        subTest = "SUBU";
        ctif.func = funct_t'(6'b100011);
        #(PERIOD);
        subTest = "AND";
        ctif.func = funct_t'(6'b100100);
        #(PERIOD);
        subTest = "OR";
        ctif.func = funct_t'(6'b100101);
        #(PERIOD);
        subTest = "XOR";
        ctif.func = funct_t'(6'b100110);
        #(PERIOD);
        subTest = "NOR";
        ctif.func = funct_t'(6'b100111);
        #(PERIOD);
        subTest = "SLT";
        ctif.func = funct_t'(6'b101010);
        #(PERIOD);
        subTest = "SLU";
        ctif.func = funct_t'(6'b101011);
        #(PERIOD);

        subTest = "Done";
        ctif.func = funct_t'(0);

        testType = "J";
        ctif.opcode = J;
        #(PERIOD);
        testType = "JAL";
        ctif.opcode = JAL;
        #(PERIOD);
        testType = "BEQ";
        ctif.opcode = BEQ;
        #(PERIOD);
        testType = "BNE";
        ctif.opcode = BNE;
        #(PERIOD);
        testType = "ADDI";
        ctif.opcode = ADDI;
        #(PERIOD);
        testType = "ADDIU";
        ctif.opcode = ADDIU;
        #(PERIOD);
        testType = "SLTI";
        ctif.opcode = SLTI;
        #(PERIOD);
        testType = "SLTIU";
        ctif.opcode = SLTIU;
        #(PERIOD);
        testType = "ANDI";
        ctif.opcode = ANDI;
        #(PERIOD);
        testType = "ORI";
        ctif.opcode = ORI;
        #(PERIOD);
        testType = "XORI";
        ctif.opcode = XORI;
        #(PERIOD);
        testType = "LUI";
        ctif.opcode = LUI;
        #(PERIOD);
        testType = "LW";
        ctif.opcode = LW;
        #(PERIOD);
        testType = "SW";
        ctif.opcode = SW;
        #(PERIOD);
        testType = "HALT";
        ctif.opcode = HALT;
    end
endprogram