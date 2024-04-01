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

  typedef enum logic [3:0] {IDLE, ILOAD, REQUEST, SNOOP, ENDSNOOP, CTC, SDAT0, SDAT1, DAT0, DAT1, ARB} st;

  st state, nstate;
  logic core, ncore;


  always_ff @(posedge CLK, negedge nRST) begin : NLGC
    if(!nRST)
    begin
      state <= IDLE;
      core <= 0;
    end
    else
    begin
      state <= nstate;
      core <= ncore;
    end
  end

  always_comb begin : BUS
    nstate = state;
    ncore = core;

    ccif.iwait = '1;
    ccif.dwait = '1;
    ccif.iload = '0; 
    ccif.dload = '0;
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
        if(ccif.dREN)
        begin
          ncore = ccif.dREN[1] && !ccif.dREN[0];
          nstate = REQUEST;
        end
        else if(ccif.dWEN)
        begin
          ncore = ccif.dWEN[1] && !ccif.dWEN[0];
          nstate = DAT0;
        end
        else if(ccif.iREN[0] && ccif.iREN[1])
        begin
          ncore = ~core;
          nstate = ILOAD;
        end
        else if(ccif.iREN[0])
        begin
          ncore = 0;
          nstate = ILOAD;
        end
        else if(ccif.iREN[1])
        begin
          ncore = 1;
          nstate = ILOAD;
        end
      end

      ILOAD:
      begin
        ccif.iwait[core] = (ccif.ramstate == ACCESS) ? 0 : 1;
        ccif.iload[core] = ccif.ramload;
        ccif.ramaddr = ccif.iaddr[core]; //use opposite because hasn't switched yet
        ccif.ramREN = 1;
        if(ccif.ramstate == ACCESS)
        begin
          nstate = IDLE;
        end
      end
        
          
      
      REQUEST:
      begin
        ccif.ccwait[core] = ccif.ccwrite[core];
        nstate = SNOOP;
      end
      
      SNOOP:
      begin
        ccif.ccinv[~core] = ccif.ccwrite[core];
        //ccif.ccwait[core] = ccif.ccwrite[core];
        ccif.ccsnoopaddr[~core] = ccif.daddr[core];
        if(!ccif.cctrans[~core])
        begin
          ccif.ccwait[~core] = 1; //use as a way for snooped core to go check itself
          nstate = ENDSNOOP;
        end
        else
        begin
          nstate = SDAT0;
        end
      end

      // CTC:
      // begin
      //   ccif.ccinv[~core] = ccif.ccwrite[core];
      //   ccif.ccwait[core] = ccif.ccwrite[core];
      //   ccif.ccsnoopaddr[~core] = ccif.daddr[core];
      //   //THIS ISNT DONE
      //   ccif.dload[core] = ccif.dstore[~core];

      //   if(!ccif.cctrans[~core])
      //   begin
      //     nstate = ENDSNOOP;
      //   end
      //   if(!ccif.ccwrite[core])
      //   begin
      //     nstate = SDAT0;
      //   end
      // end
      
      SDAT0:
      begin
        ccif.ccinv[~core] = ccif.ccwrite[core];
        ccif.ccwait[core] = ccif.ccwrite[core];
        ccif.ccsnoopaddr[~core] = ccif.daddr[core];

        ccif.ramWEN = 1;
        ccif.ramaddr = ccif.daddr[~core];
        ccif.ramstore = ccif.dstore[~core];

        if(ccif.ramstate == ACCESS)
        begin
          nstate = SDAT1;
        end
      end

      SDAT1:
      begin
        ccif.ccinv[~core] = ccif.ccwrite[core];
        ccif.ccwait[core] = ccif.ccwrite[core];
        ccif.ccsnoopaddr[~core] = ccif.daddr[core];
        
        ccif.ramWEN = 1;
        ccif.ramaddr = ccif.daddr[~core];
        ccif.ramstore = ccif.dstore[~core];

        if(ccif.ramstate == ACCESS)
        begin
          nstate = ENDSNOOP;
        end
      end
      ENDSNOOP:
      begin
        ccif.ccinv[~core] = 0;
        ccif.ccwait[core] = 0;
        nstate = DAT0;
      end

      DAT0:
      begin
        ccif.ramaddr = ccif.daddr[core];
        if(ccif.dREN[core] || ccif.ccwrite[core])
        begin
          ccif.ramREN = 1;
          ccif.dload[core] = ccif.ramload;
        end
        else if(ccif.dWEN[core])
        begin
          ccif.ramWEN = 1;
          ccif.ramstore = ccif.dstore[core];
        end

        if(ccif.ramstate == ACCESS)
        begin
          ccif.dwait[core] = 0;
          nstate = DAT1;
        end
      end

      DAT1:
      begin
        ccif.ramaddr = ccif.daddr[core];
        if(ccif.dREN[core] || ccif.ccwrite[core])
        begin
          ccif.ramREN = 1;
          ccif.dload[core] = ccif.ramload;
        end
        else if(ccif.dWEN[core])
        begin
          ccif.ramWEN = 1;
          ccif.ramstore = ccif.dstore[core];
        end

        if(ccif.ramstate == ACCESS)
        begin
          ccif.dwait[core] = 0;
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
