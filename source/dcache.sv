`include "cpu_types_pkg.vh"
`include "caches_if.vh"
`include "datapath_cache_if.vh"

module dcache(
    input logic CLK, nRST,
    datapath_cache_if.dcache dcif,
    caches_if.dcache cif
);

    import cpu_types_pkg::*;

    dcache_frame [1:0][7:0] dcache, ndcache;

    logic [7:0] LRU, nLRU;

    dcachef_t addr;

    assign addr.bytoff = dcif.dmemaddr[1:0];
    assign addr.blkoff = dcif.dmemaddr[2];
    assign addr.idx = dcif.dmemaddr[5:3];
    assign addr.tag = dcif.dmemaddr[31:6];

    typedef enum logic [3:0] {IDLE, COMPARE, WB1, WB2, ALLOCATE1, ALLOCATE2, OUTPUT, HALT} state;

    state currState;
    state nState;

    always_ff @(posedge CLK, negedge nRST) begin : nST
        if(!nRST)
        begin
            currState <= IDLE;
            dcache <= '0;
            LRU <= '0;
        end
        else
        begin
            currState <= nState;
            dcache <= ndcache;
            LRU <= nLRU;
        end
    end

    always_comb begin : CMBLGC
        nState = currState;
        ndcache = dcache;
        nLRU = LRU;
        cif.dREN = 0;
        cif.dWEN = 0;
        cif.daddr = 0;
        cif.dstore = 0;

        dcif.dhit = 0;
        dcif.dmemload = 0;
        dcif.flushed = 0;

        if(!dcif.dmemREN && !dcif.dmemWEN)
        begin
            nState = IDLE;
        end
        else
        begin
            case(currState)
                IDLE:
                begin
                    if(dcif.dmemREN || dcif.dmemWEN)
                    begin
                        nState = COMPARE;
                    end
                end
                COMPARE:
                begin
                    //Hits
                    
                    if(dcache[0][addr.idx].valid && dcache[0][addr.idx].tag == addr.tag)
                    begin
                        dcif.dhit = 1;
                        dcif.dmemload = dcache[0][addr.idx].data[addr.blkoff];
                        dcache[0][addr.idx].dirty = dcif.dmemWEN ? 1 : 0;
                        nLRU[addr.idx] = 1;
                        nState = OUTPUT;
                    end
                    else if(dcache[1][addr.idx].valid && dcache[1][addr.idx].tag == addr.tag)
                    begin
                        dcif.dhit = 1;
                        dcif.dmemload = addr.blkoff ? dcache[1][addr.idx].data[1] : dcache[1][addr.idx].data[0];
                        dcache[1][addr.idx].dirty = dcif.dmemWEN ? 1 : 0;
                        nLRU[addr.idx] = 0;
                        nState = OUTPUT;
                    end
                    //Misses
                    else if(dcache[LRU[addr.idx]][addr.idx].dirty)
                    begin
                        nState = WB1;
                    end
                    else
                    begin
                        nState = ALLOCATE1;
                    end
                end
                OUTPUT:
                begin
                    nState = IDLE;
                end
                WB1: //writing LRU data into RAM
                begin
                    if(dcache[LRU[addr.idx]][addr.idx].valid)
                    begin
                        cif.daddr = dcif.dmemaddr;
                        cif.dstore = dcache[LRU[addr.idx]][addr.idx].data[addr.blkoff];
                        cif.dWEN = 1;
                    end
                    nState = WB2;
                end
                WB2:
                begin
                    if(dcache[LRU[addr.idx]][addr.idx].valid)
                    begin
                        cif.daddr = {addr.tag, addr.idx, ~addr.blkoff, addr.bytoff};
                        cif.dstore = dcache[LRU[addr.idx]][addr.idx].data[~addr.blkoff];
                        cif.dWEN = 1;
                    end
                    nState = ALLOCATE1;
                end
                ALLOCATE1: //Taking RAM data and putting it into LRU cache
                begin
                    if(dcif.dmemREN)
                    begin
                        //need to wait for RAM
                        cif.dREN = 1;
                        cif.daddr = dcif.dmemaddr;
                        if(!cif.dwait)
                        begin
                            ndcache[LRU[addr.idx]][addr.idx].tag = addr.tag;
                            ndcache[LRU[addr.idx]][addr.idx].data[addr.blkoff] = cif.dload;
                            ndcache[LRU[addr.idx]][addr.idx].valid = 1;
                            ndcache[LRU[addr.idx]][addr.idx].dirty = 0;
                            nState = ALLOCATE2;
                        end
                    end
                    else if(dcif.dmemWEN)
                    begin
                        ndcache[LRU[addr.idx]][addr.idx].tag = addr.tag;
                        ndcache[LRU[addr.idx]][addr.idx].data[addr.blkoff] = dcif.dmemstore;
                        ndcache[LRU[addr.idx]][addr.idx].valid = 1;
                        ndcache[LRU[addr.idx]][addr.idx].dirty = 1;
                    end
                end
                


            endcase
        end

    end

    

endmodule