`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH

// types
`include "cpu_types_pkg.vh"

interface request_unit_if;
  // import types
  import cpu_types_pkg::*;

logic ihit, dhit, MemRead, MemWrite;
logic imemREN, dmemREN, dmemWEN;

modport rq (
    input ihit, dhit, MemRead, MemWrite,
    output imemREN, dmemREN, dmemWEN
);

modport tb (
    input imemREN, dmemREN, dmemWEN,
    output ihit, dhit, MemRead, MemWrite
);
endinterface
`endif