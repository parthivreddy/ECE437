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
  input logic CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 1;

  typedef enum logic [3:0] {IDLE, REQUEST, SNOOP, ENDSNOOP, CTC, SDAT0, SDAT1, DAT0, DAT1, ARB} st;

  st state, nstate;
  logic LRU_PC, nLRU_PC;

  logic IorS; //I if 0 S if 1

  always_ff @(posedge CLK, negedge nRST) begin : NLGC
    if(nRST)
    begin
      state <= IDLE;
      LRU_PC <= 0;
    end
    else
    begin
      state <= nstate;
      LRU_PC <= nLRU_PC;
    end
  end

  always_comb begin : REQUEST
    nstate = state;
    ccif.iwait = 1;
    ccif.dwait = 1;
    ccif.iload = 0; 
    ccif.dload = 0;
    ccif.ramaddr = 0;
    ccif.ramstore = 0;
    ccif.ramWEN = 0;
    ccif.ramREN = 0;

    //signals staying the same
    ccif.ccinv = 0;
    ccif.ccwait = 0;
    ccif.ccsnoopaddr = 0;

    case(state)
      IDLE:
        if(ccif.dWEN[LRU_PC])
        begin
          nLRU_PC = ~LRU_PC; //change least recently used core
          nstate = DAT0;
        end
        else if(ccif.dREN[LRU_PC])
        begin
          nLRU_PC = ~LRU_PC;
          nstate = REQUEST;
        end
        else if(ccif.ccwrite[LRU_PC])
        begin
          nLRU_PC = ~LRU_PC;
          nstate = REQUEST;
          IorS = 1; //write (hit but frame is clean) S state
        end
        else if(ccif.iREN)
        begin
          nLRU_PC = ~LRU_PC;
          ccif.iwait = (ccif.ramstate == ACCESS) ? 0 : 1;
          ccif.iload = ccif.ramload;
          ccif.ramaddr = ccif.iaddr;
          ccif.ramREN = ccif.iREN;
        end
      
      REQUEST:
        ccif.ccwait[LRU_PC] = ccif.ccwrite[LRU_PC];
        nstate = SNOOP;
      
      SNOOP:
        ccif.ccinv[~LRU_PC] = ccif.ccwrite[LRU_PC];
        ccif.ccwait[LRU_PC] = ccif.ccwrite[LRU_PC];
        ccif.ccsnoopaddr[~LRU_PC] = ccif.ccdaddr[LRU_PC];
        if(!ccif.cctrans[~LRU_PC])
        begin
          nstate = ENDSNOOP;
        end
        else if(ccif.ccwait[~LRU_PC])
        begin
          nstate = CTC;
        end
      
      CTC:
        ccif.ccinv[~LRU_PC] = ccif.ccwrite[LRU_PC];
        ccif.ccwait[LRU_PC] = ccif.ccwrite[LRU_PC];
        ccif.ccsnoopaddr[~LRU_PC] = ccif.ccdaddr[LRU_PC];
        //THIS ISNT DONE
        ccif.dload[LRU_PC] = ccif.dstore[~LRU_PC];

        if(!ccif.cctrans[~LRU_PC])
        begin
          nstate = ENDSNOOP;
        end
        if(!ccif.ccwrite[LRU_PC])
        begin
          nstate = SDAT0;
        end
      
      SDAT0:
        ccif.ccinv[~LRU_PC] = ccif.ccwrite[LRU_PC];
        ccif.ccwait[LRU_PC] = ccif.ccwrite[LRU_PC];
        ccif.ccsnoopaddr[~LRU_PC] = ccif.ccdaddr[LRU_PC];

        ccif.ramWEN = 1;
        ccif.ramaddr = ccif.daddr[LRU_PC];
        ccif.ramstore = ccif.dstore[~LRU_PC];

        if(ccif.ramstate == ACCESS)
        begin
          nstate = SDAT1;
        end
      
      SDAT1:
        ccif.ccinv[~LRU_PC] = ccif.ccwrite[LRU_PC];
        ccif.ccwait[LRU_PC] = ccif.ccwrite[LRU_PC];
        ccif.ccsnoopaddr[~LRU_PC] = ccif.ccdaddr[LRU_PC];
        
        ccif.ramWEN = 1;
        ccif.ramaddr = ccif.daddr[LRU_PC];
        ccif.ramstore = ccif.dstore[~LRU_PC];

        if(ccif.ramstate == ACCESS && ~ccif.cctrans[~LRU_PC])
        begin
          nstate = ENDSNOOP;
        end
      
      ENDSNOOP:
        if(!ccif.ccwrite[LRU_PC] || !IorS)
        begin
          nstate = DAT0;
        end
        else
        begin
          nstate = IDLE;
        end
      
      DAT0:
        ccif.ramaddr[LRU_PC] = ccif.daddr[LRU_PC];
        if(ccif.dREN[LRU_PC])
        begin
          ccif.ramREN = 1;
          ccif.dload = ccif.ramload;
        end
        else if(ccif.dWEN[LRU_PC])
        begin
          ccif.ramWEN = 1;
          ccif.ramstore = ccif.dstore[LRU_PC];
        end

        if(ccif.ramstate == ACCESS)
        begin
          ccif.dwait[LRU_PC] = 0;
          nstate = DAT1;
        end

      DAT1:
        ccif.ramaddr[LRU_PC] = ccif.daddr[LRU_PC];
        if(ccif.dREN[LRU_PC])
        begin
          ccif.ramREN = 1;
          ccif.dload = ccif.ramload;
        end
        else if(ccif.dWEN[LRU_PC])
        begin
          ccif.ramWEN = 1;
          ccif.ramstore = ccif.dstore[LRU_PC];
        end

        if(ccif.ramstate == ACCESS)
        begin
          ccif.dwait[LRU_PC] = 0;
          nstate = IDLE;
        end

    endcase

  end
          

//   always_comb begin : REQUEST
//     ccif.iwait = 1;
//     ccif.dwait = 0;
//     ccif.iload = 0;
//     ccif.dload = 0;
//     ccif.ramaddr = ccif.daddr;
//     ccif.ramstore = ccif.dstore;
//     ccif.ramWEN = 0;
//     ccif.ramREN = 0;

//     if(ccif.dREN)
//       begin
//         ccif.dwait = (ccif.ramstate == ACCESS) ? 0 : 1;
//         ccif.ramREN = ccif.dREN;
//         ccif.dload = ccif.ramload;
//       end

//     else if(ccif.dWEN)
//       begin
//         ccif.ramWEN = ccif.dWEN;
//         ccif.dwait = (ccif.ramstate == ACCESS) ? 0 : 1;
//         ccif.dload = ccif.ramload;
//       end

//     else if(ccif.iREN)
//       begin
//         ccif.iwait = (ccif.ramstate == ACCESS) ? 0 : 1;
//         ccif.iload = ccif.ramload;
//         ccif.ramaddr = ccif.iaddr;
//         ccif.ramREN = ccif.iREN;
//       end
//   end

endmodule
