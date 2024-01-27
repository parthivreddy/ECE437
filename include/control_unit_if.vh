`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

// types
`include "cpu_types_pkg.vh"

interface control_unit_if;
  // import types
  import cpu_types_pkg::*;

  opcode_t opcode;
  funct_t func;
  logic MemRead, MemWrite, RegDst, ExtOp, ALUSrc,
  RegWr, MemtoReg, Beq, Bne, Jump, Link, LUI, Halt;
  aluop_t ALUCtrl;

  modport ct (
    input opcode, func,
    output MemRead, MemWrite, ALUCtrl, RegDst, ExtOp, ALUSrc,
    RegWr, MemtoReg, Beq, Bne, Jump, Link, LUI, Halt
  );

  modport tb (
    input MemRead, MemWrite, ALUCtrl, RegDst, ExtOp, ALUSrc,
    RegWr, MemtoReg, Beq, Bne, Jump, Link, LUI, Halt,
    output opcode, func
  );
endinterface
`endif