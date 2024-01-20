/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 1;




  always_comb begin : REQUEST
    ccif.iwait = 1;
    ccif.dwait = 0;
    ccif.iload = 0;
    ccif.dload = ccif.ramload;
    ccif.ramaddr = ccif.daddr;
    ccif.ramstore = ccif.dstore;
    ccif.ramWEN = 0;
    ccif.ramREN = 0;

    if(ccif.dREN)
      begin
        ccif.dwait = (ramstate == ACCESS) ? 0 : 1;
        ccif.ramREN = ccif.dREN;
      end

    else if(ccif.dWEN)
      begin
        ccif.ramWEN = ccif.dWEN;
        ccif.dwait = (ramstate == ACCESS) ? 0 : 1;
      end

    else if(ccif.iREN)
      begin
        ccif.iwait = (ramstate == ACCESS) ? 0 : 1;
        ccif.iload = ccif.ramload;
        ccif.ramaddr = ccif.iaddr;
        ccif.ramREN = ccif.iREN;
      end
  end

endmodule
