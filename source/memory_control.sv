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
  logic validLRU, nvalidLRU;
  logic core, ncore;

  logic IorS, nIorS; //I if 0 S if 1


  logic CurrCore;
  assign CurrCore = validLRU ? LRU_PC : core;

  always_ff @(posedge CLK, negedge nRST) begin : NLGC
    if(!nRST)
    begin
      state <= IDLE;
      LRU_PC <= 0;
      core <= 0;
      validLRU <= 0;
      IorS <= 0;
    end
    else
    begin
      state <= nstate;
      LRU_PC <= nLRU_PC;
      core <= ncore;
      validLRU <= nvalidLRU;
      IorS <= nIorS;
    end
  end

  always_comb begin : BUS
    nstate = state;
    nLRU_PC = LRU_PC;
    ncore = core;
    nvalidLRU = validLRU;
    nIorS = IorS;

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
      begin
        if(ccif.dWEN[0] && ccif.dWEN[1])
        begin
          nLRU_PC = ~LRU_PC; //change least recently used core
          nvalidLRU = 1;
          nstate = DAT0;
        end
        else if(ccif.dWEN[0])
        begin
          ncore = 0;
          nvalidLRU = 0;
          nstate = DAT0;
        end
        else if(ccif.dWEN[1])
        begin
          ncore = 1;
          nvalidLRU = 0;
          nstate = DAT0;
        end
        else if(ccif.dREN[0] && ccif.dREN[1])
        begin
          nLRU_PC = ~LRU_PC;
          nvalidLRU = 1;
          nstate = REQUEST;
        end
        else if(ccif.dREN[0])
        begin
          ncore = 0;
          nvalidLRU = 0;
          nstate = REQUEST;
        end
        else if(ccif.dREN[1])
        begin
          ncore = 1;
          nvalidLRU = 0;
          nstate = REQUEST;
        end
        else if(ccif.ccwrite[0] && ccif.ccwrite[1])
        begin
          nLRU_PC = ~LRU_PC;
          nvalidLRU = 1;
          nstate = REQUEST;
          nIorS = 1; //write (hit but frame is clean) S state
        end
        else if(ccif.ccwrite[0])
        begin
          nvalidLRU = 0;
          nIorS = 1;
          ncore = 0;
          nstate = REQUEST;
        end
        else if(ccif.ccwrite[1])
        begin
          nvalidLRU = 0;
          nIorS = 1;
          ncore = 1;
          nstate = REQUEST;
        end

        else if(ccif.iREN[0] && ccif.iREN[1])
        begin
          nLRU_PC = ~LRU_PC;
          ccif.iwait = (ccif.ramstate == ACCESS) ? 0 : 1;
          ccif.iload = ccif.ramload;
          ccif.ramaddr = ccif.iaddr[~LRU_PC]; //use opposite because hasn't switched yet
          ccif.ramREN = 1;
        end
        else if(ccif.iREN[0])
        begin
          ccif.iwait = (ccif.ramstate == ACCESS) ? 0 : 1;
          ccif.iload = ccif.ramload;
          ccif.ramaddr = ccif.iaddr[0]; //use opposite because 
          ccif.ramREN = 1;
        end
        else if(ccif.iREN[1])
        begin
          ccif.iwait = (ccif.ramstate == ACCESS) ? 0 : 1;
          ccif.iload = ccif.ramload;
          ccif.ramaddr = ccif.iaddr[~LRU_PC]; //use opposite because 
          ccif.ramREN = 1;
        end
      end
          
      
      REQUEST:
      begin
        ccif.ccwait[CurrCore] = ccif.ccwrite[CurrCore];
        nstate = SNOOP;
      end
      
      SNOOP:
      begin
        ccif.ccinv[~CurrCore] = ccif.ccwrite[CurrCore];
        ccif.ccwait[CurrCore] = ccif.ccwrite[CurrCore];
        ccif.ccsnoopaddr[~CurrCore] = ccif.daddr[CurrCore];
        if(!ccif.cctrans[~CurrCore])
        begin
          nstate = ENDSNOOP;
        end
        else if(ccif.ccwait[~CurrCore])
        begin
          nstate = CTC;
        end
      end

      CTC:
      begin
        ccif.ccinv[~CurrCore] = ccif.ccwrite[CurrCore];
        ccif.ccwait[CurrCore] = ccif.ccwrite[CurrCore];
        ccif.ccsnoopaddr[~CurrCore] = ccif.daddr[CurrCore];
        //THIS ISNT DONE
        ccif.dload[CurrCore] = ccif.dstore[~CurrCore];

        if(!ccif.cctrans[~CurrCore])
        begin
          nstate = ENDSNOOP;
        end
        if(!ccif.ccwrite[CurrCore])
        begin
          nstate = SDAT0;
        end
      end
      
      SDAT0:
      begin
        ccif.ccinv[~CurrCore] = ccif.ccwrite[CurrCore];
        ccif.ccwait[CurrCore] = ccif.ccwrite[CurrCore];
        ccif.ccsnoopaddr[~CurrCore] = ccif.daddr[CurrCore];

        ccif.ramWEN = 1;
        ccif.ramaddr = ccif.daddr[CurrCore];
        ccif.ramstore = ccif.dstore[~CurrCore];

        if(ccif.ramstate == ACCESS)
        begin
          nstate = SDAT1;
        end
      end

      SDAT1:
      begin
        ccif.ccinv[~CurrCore] = ccif.ccwrite[CurrCore];
        ccif.ccwait[CurrCore] = ccif.ccwrite[CurrCore];
        ccif.ccsnoopaddr[~CurrCore] = ccif.daddr[CurrCore];
        
        ccif.ramWEN = 1;
        ccif.ramaddr = ccif.daddr[CurrCore];
        ccif.ramstore = ccif.dstore[~CurrCore];

        if(ccif.ramstate == ACCESS && ~ccif.cctrans[~CurrCore])
        begin
          nstate = ENDSNOOP;
        end
      end

      ENDSNOOP:
      begin
        if(!ccif.ccwrite[CurrCore] || !IorS)
        begin
          nstate = DAT0;
        end
        else
        begin
          nstate = IDLE;
        end
      end

      DAT0:
      begin
        ccif.ramaddr[CurrCore] = ccif.daddr[CurrCore];
        if(ccif.dREN[CurrCore])
        begin
          ccif.ramREN = 1;
          ccif.dload = ccif.ramload;
        end
        else if(ccif.dWEN[CurrCore])
        begin
          ccif.ramWEN = 1;
          ccif.ramstore = ccif.dstore[CurrCore];
        end

        if(ccif.ramstate == ACCESS)
        begin
          ccif.dwait[CurrCore] = 0;
          nstate = DAT1;
        end
      end

      DAT1:
      begin
        ccif.ramaddr[CurrCore] = ccif.daddr[CurrCore];
        if(ccif.dREN[CurrCore])
        begin
          ccif.ramREN = 1;
          ccif.dload = ccif.ramload;
        end
        else if(ccif.dWEN[CurrCore])
        begin
          ccif.ramWEN = 1;
          ccif.ramstore = ccif.dstore[CurrCore];
        end

        if(ccif.ramstate == ACCESS)
        begin
          ccif.dwait[CurrCore] = 0;
          nstate = IDLE;
        end
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
