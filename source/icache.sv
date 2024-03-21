`include "cpu_types_pkg.vh"
`include "caches_if.vh"
`include "datapath_cache_if.vh"

module icache(
    input logic CLK, nRST,
    datapath_cache_if.icache dcif,
    caches_if.icache cif
);

import cpu_types_pkg::*;

icache_frame [15:0] cache;
icache_frame [15:0] ncache;

icachef_t addr;

assign addr.bytoff = dcif.imemaddr[1:0];
assign addr.idx = dcif.imemaddr[5:2];
assign addr.tag = dcif.imemaddr[31:6];


typedef enum logic {IDLE, MISS} state;

state currState;
state nState;

always_ff @(posedge CLK, negedge nRST) begin : nST
    if(!nRST)
    begin
        currState <= IDLE;
        cache <= '0;
    end
    else
    begin
        currState <= nState;
        cache <= ncache;
    end
end

always_comb begin : CMBLGC
    nState = currState;
    ncache = cache;
    cif.iREN = 0;
    cif.iaddr = 0;
    dcif.ihit = 0;
    dcif.imemload = 0;
    // if(!dcif.imemREN)
    // begin
    //     nState = IDLE;
    // end
    // else
    if(dcif.imemREN)
    begin
        case(currState)
            IDLE:
            begin
                if(cache[addr.idx].valid && cache[addr.idx].tag == addr.tag) //hit
                begin
                    dcif.ihit = 1;
                    dcif.imemload = cache[addr.idx].data;
                end
                else if(!cache[addr.idx].valid || cache[addr.idx].tag != addr.tag) //miss
                begin
                    nState = MISS;
                end

            end
            MISS:
            begin
                cif.iREN = 1;
                cif.iaddr = dcif.imemaddr;
                dcif.ihit = 0;
                if(!cif.iwait)
                begin
                    dcif.imemload = cif.iload;
                    dcif.ihit = 1;
                    ncache[addr.idx].tag = addr.tag;
                    ncache[addr.idx].data = cif.iload;
                    ncache[addr.idx].valid = 1;
                    nState = IDLE;
                end
            end
        endcase

    end

    
end


endmodule