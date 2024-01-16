/*
  Eric Villasenor
  evillase@gmail.com

  ALU interface
*/
`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface ALU_if;
  // import types
  import cpu_types_pkg::*;

  logic     neg, ov, zero;
  aluop_t   op;
  word_t    port_a, port_b, ALU_output;

  // register file ports
  modport alu (
    input   port_a, port_b, op,
    output  neg, ov, zero, ALU_output
  );
  // register file tb
  modport tb (
    output   port_a, port_b, op,
    input  neg, ov, zero, ALU_output
  );
endinterface

`endif //REGISTER_FILE_IF_VH
