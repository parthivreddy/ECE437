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

  logic         jump, branch, flush1, flush2, stall, stage2_MemRead, jr;
  logic [1:0]   npc_sel;
  regbits_t     stage1_rs, stage1_rt, stage2_rt;

  // register file ports
  modport hu (
    input   jump, branch, stage1_rs, stage1_rt, stage2_rt, stage2_MemRead, jr,
    output  flush1, flush2, stall, npc_sel
  );
  // register file tb
  modport tb (
    input   flush1, flush2, stall, npc_sel,
    output  jump, branch, stage1_rs, stage1_rt, stage2_rt, stage2_MemRead, jr
  );
endinterface

`endif //HAZARD_UNIT_IF_VH