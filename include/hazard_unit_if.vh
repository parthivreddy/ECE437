/*
  register file interface
*/
`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface hazard_unit_if;
  // import types
  import cpu_types_pkg::*;

  logic         jump, branch, flush1, flush2, flush3, stall, stage2_MemRead, jr, stage3_MemRead, stage3_MemWrite;
  regbits_t     stage1_rs, stage1_rt, stage2_rt;

  // register file ports
  modport hu (
    input   jump, branch, stage1_rs, stage1_rt, stage2_rt, stage2_MemRead, jr, stage3_MemWrite, stage3_MemRead,
    output  flush1, flush2, flush3, stall
  );
  // register file tb
  modport tb (
    input   flush1, flush2, flush3, stall,
    output  jump, branch, stage1_rs, stage1_rt, stage2_rt, stage2_MemRead, jr, stage3_MemWrite, stage3_MemRead
  );
endinterface

`endif //HAZARD_UNIT_IF_VH