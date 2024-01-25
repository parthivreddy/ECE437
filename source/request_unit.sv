`include "datapath_cache_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  input logic MemRead, MemWrite,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;
  logic nDmemREN;
  logic nDmemWEN;


  // pc init
  parameter PC_INIT = 0;

  assign dpif.imemREN = ihit ? 0 : 1;

  always_comb
  begin: CMBLGC
    if(dhit)
    begin
        nDmemREN = 0;
        nDmemWEN = 0;
    end
    else
    begin
        nDmemREN = MemRead ? 1 : 0;
        nDmemWEN = MemWrite ? 1 : 0;
    end

  end

  always_ff @(posedge CLK, negedge nRST) begin : FFLGC

    if(!nRST)
    begin
        dpif.dmemREN <= 0;
        dpif.dmemWEN <= 0;
    end
    else
    begin
        dpif.dmemREN <= nDmemREN;
        dpif.dmemWEN <= nDmemWEN;
    end
  end

  

endmodule
