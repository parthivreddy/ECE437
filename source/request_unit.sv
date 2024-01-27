`include "datapath_cache_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

//MAYBE IMEMREN HAS TO BE REGISTERED
//ALLEERTTT

module request_unit (
  input logic CLK, nRST,
  request_unit_if.rq rqif
);
  // import types
  import cpu_types_pkg::*;
  logic nDmemREN;
  logic nDmemWEN;


  // pc init
  parameter PC_INIT = 0;

  //assign it to !halt
  assign rqif.imemREN = 1;

  //Might have to deassert REN and WEN 1 clock cycle after dhit

  always_comb
  begin: CMBLGC
    if(rqif.dhit)
    begin
        nDmemREN = 0;
        nDmemWEN = 0;
    end
    else
    begin
        nDmemREN = rqif.MemRead ? 1 : 0;
        nDmemWEN = rqif.MemWrite ? 1 : 0;
    end

  end

  always_ff @(posedge CLK, negedge nRST) begin : FFLGC

    if(!nRST)
    begin
        rqif.dmemREN <= 0;
        rqif.dmemWEN <= 0;
    end
    else
    begin
        rqif.dmemREN <= nDmemREN;
        rqif.dmemWEN <= nDmemWEN;
    end
  end

  

endmodule
