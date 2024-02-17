`ifndef FORWARD_UNIT_IF_VH
`define FORWARD_UNIT_IF_VH

// ram memory types
`include "cpu_types_pkg.vh"

interface forward_unit_if;

  // import types
  import cpu_types_pkg::*;

  //conditions for the hazard

  logic [4:0] stage2_rs, stage2_rt, stage3_rd, stage4_rd;
  logic stage3_RegWr, stage4_RegWr;
  logic stage2_MemWr;
  //
  logic [1:0] forwardA, forwardB; //for stage 2

  modport fu (
    input stage2_rs, stage2_rt, stage3_rd, stage4_rd, stage3_RegWr, stage4_RegWr, stage2_MemWr,
    output forwardA, forwardB
  );

  modport tb (
    input forwardA, forwardB,
    output stage2_rs, stage2_rt, stage3_rd, stage4_rd, stage3_RegWr, stage4_RegWr, stage2_MemWr
  );
endinterface
`endif
  
