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
    logic endSet;
    logic [2:0] index, nIndex;
    logic [31:0] hit_counter, nhit_counter;

    dcachef_t addr;

    assign addr.bytoff = dcif.dmemaddr[1:0];
    assign addr.blkoff = dcif.dmemaddr[2];
    assign addr.idx = dcif.dmemaddr[5:3];
    assign addr.tag = dcif.dmemaddr[31:6];

    typedef enum logic [3:0] {IDLE, COMPARE, WB1, WB2, ALLOCATE1, ALLOCATE2, OUTPUT, ENDWR1, ENDWR2, INCRCNT, WCOUNT, HALT} state;

    state currState;
    state nState;

    always_ff @(posedge CLK, negedge nRST) begin : nST
        if(!nRST)
        begin
            currState <= IDLE;
            dcache <= '0;
            LRU <= '0;
            index <= 0;
            hit_counter <= 0;
        end
        else
        begin
            currState <= nState;
            dcache <= ndcache;
            LRU <= nLRU;
            index <= nIndex;
            hit_counter <= nhit_counter;
        end
    end

    always_comb begin : CMBLGC
        nState = currState;
        ndcache = dcache;
        nLRU = LRU;
        nIndex = index;
        nhit_counter = hit_counter;

        cif.dREN = 0;
        cif.dWEN = 0;
        cif.daddr = 0;
        cif.dstore = 0;

        dcif.dhit = 0;
        dcif.dmemload = 0;
        dcif.flushed = 0;

        // if(!dcif.dmemREN && !dcif.dmemWEN)
        // begin
        //     nState = IDLE;
        // end
        // else
        // begin
        case(currState)
            IDLE:
            begin
                endSet = 0;
                if(dcif.halt)
                begin
                    nState = ENDWR1;
                end
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
                    ndcache[0][addr.idx].dirty = dcif.dmemWEN ? 1 : 0;
                    nhit_counter = hit_counter + 1;
                    nLRU[addr.idx] = 1;
                    nState = IDLE;
                end
                else if(dcache[1][addr.idx].valid && dcache[1][addr.idx].tag == addr.tag)
                begin
                    dcif.dhit = 1;
                    dcif.dmemload = addr.blkoff ? dcache[1][addr.idx].data[1] : dcache[1][addr.idx].data[0];
                    ndcache[1][addr.idx].dirty = dcif.dmemWEN ? 1 : 0;
                    nLRU[addr.idx] = 0;
                    nState = IDLE;
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
                //nLRU[addr.idx] = ~LRU[addr.idx];
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
            ALLOCATE2:
            begin
                cif.dREN = 1;
                cif.daddr = {addr.tag, addr.idx, ~addr.blkoff, addr.bytoff};
                if(!cif.dwait)
                begin
                    ndcache[LRU[addr.idx]][addr.idx].tag = addr.tag;
                    ndcache[LRU[addr.idx]][addr.idx].data[~addr.blkoff] = cif.dload;
                    ndcache[LRU[addr.idx]][addr.idx].valid = 1;
                    ndcache[LRU[addr.idx]][addr.idx].dirty = 0;
                    if(dcif.dmemWEN)
                    begin
                        ndcache[LRU[addr.idx]][addr.idx].tag = addr.tag;
                        ndcache[LRU[addr.idx]][addr.idx].data[addr.blkoff] = dcif.dmemstore;
                        ndcache[LRU[addr.idx]][addr.idx].valid = 1;
                        ndcache[LRU[addr.idx]][addr.idx].dirty = 1;
                    end
                    dcif.dhit = 1;
                    nLRU[addr.idx] = ~LRU[addr.idx];
                    nState = IDLE;
                end
            end
            ENDWR1:
            begin
                if(dcache[endSet][index].dirty)
                begin
                    cif.dWEN = 1;
                    cif.daddr = {dcache[endSet][index].tag, index, 3'b0};
                    cif.dstore = dcache[endSet][index].data[0];
                    if(!cif.dwait)
                    begin
                        nState = ENDWR2;
                    end
                end
                nState = ENDWR2;
            end
            ENDWR2:
            begin
                if(dcache[endSet][index].dirty)
                begin
                    cif.dWEN = 1;
                    cif.daddr = {dcache[endSet][index].tag, index, 1'b1, 2'b0};
                    cif.dstore = dcache[endSet][index].data[1];
                    if(!cif.dwait)
                    begin
                        nState = INCRCNT;
                    end
                end
                nState = INCRCNT;
            end
            INCRCNT:
            begin
                nIndex = index + 1;
                // if(index == 7)
                // begin
                //     if(endSet)
                //     begin
                //         nState = WCOUNT;
                //     end
                //     else
                //     begin
                //         endSet = 1;
                //         nIndex = 0;
                //     end
                // end
                if (index == 7 && endSet == 1)
                begin
                    nState = WCOUNT;
                end
                else if (index == 7)
                begin
                    endSet = 1;
                    nIndex = 0;
                    nState = ENDWR1;
                end
                else
                begin
                    nState = ENDWR1;
                end

            end
            WCOUNT:
            begin
                cif.dWEN = 1;
                dcif.dmemaddr = 32'h3100;
                cif.dstore = hit_counter;
                if (cif.dwait == 0)
                begin
                    nState = HALT;
                end
            end
            HALT:
            begin
                dcif.flushed = 1;
            end
            
            


        endcase
        // end

    end

    

endmodule