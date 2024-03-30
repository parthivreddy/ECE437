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
    logic endSet, nEndSet;
    logic [2:0] index, nIndex;
    logic [31:0] hit_counter, nhit_counter, ndaddr, ndstore;
    logic ndWEN, ndREN, dmemRENFF;
    logic equal;
    logic WENfirst, RENfirst;
    //logic cif.dwait;

    dcachef_t addr, oldaddr;

    assign addr.bytoff = dcif.dmemaddr[1:0];
    assign addr.blkoff = dcif.dmemaddr[2];
    assign addr.idx = dcif.dmemaddr[5:3];
    assign addr.tag = dcif.dmemaddr[31:6];

    assign oldaddr.tag = dcache[LRU[addr.idx]][addr.idx].tag;
    // assign equal = cif.daddr == dcif.dmemaddr;
    // assign toggleEqual = {cif.daddr[31:3], ~cif.daddr[2], cif.daddr[1:0]} == dcif.dmemaddr;
    // assign WBequal = cif.daddr == {oldaddr.tag, addr.idx, addr.blkoff, addr.bytoff};
    // assign toggleWBequal = cif.daddr == {oldaddr.tag, addr.idx, ~addr.blkoff, addr.bytoff};

    typedef enum logic [1:0] {IDLEfirst, REN, WEN} firstState; //just to see which came first
    typedef enum logic [3:0] {IDLE, COMPARE, WB1, WB2, ALLOCATE1, ALLOCATE2, OUTPUT, ENDWR1, ENDWR2, INCRCNT, WCOUNT, HALT} state;

    firstState firstSt, nfirstSt;

    state currState;
    state nState;

    always_ff @(posedge CLK, negedge nRST) begin : nST
        if(!nRST)
        begin
            currState <= IDLE;
            firstSt <= IDLEfirst;
            dcache <= '0;
            LRU <= '0;
            index <= 0;
            hit_counter <= 0;
            endSet <= '0;
            cif.daddr <= 0;
            cif.dstore <= 0;
            cif.dWEN <= 0;
            cif.dREN <= 0;
            dmemRENFF <= 0;
            //cif.dwait <= 0;
        end
        else
        begin
            currState <= nState;
            firstSt <= nfirstSt;
            dcache <= ndcache;
            LRU <= nLRU;
            index <= nIndex;
            hit_counter <= nhit_counter;
            endSet <= nEndSet;
            cif.daddr <= ndaddr;
            cif.dstore <= ndstore;
            cif.dWEN <= ndWEN;
            cif.dREN <= ndREN;
            dmemRENFF <= dcif.dmemREN;
            //cif.dwait <= cif.dwait;
        end
    end

    always_comb
    begin
        nfirstSt = firstSt;
        WENfirst = 0;
        RENfirst = 0;
        case(firstSt)
            IDLEfirst:
            begin
                if(dcif.dmemREN)
                begin
                    nfirstSt = REN;
                end
                else if(dcif.dmemWEN)
                begin
                    nfirstSt = WEN;
                end
            end
            REN:
            begin
                RENfirst = 1;
                if(!dcif.dmemREN)
                begin
                    nfirstSt = IDLEfirst;
                end
            end
            WEN:
            begin
                WENfirst = 1;
                if(!dcif.dmemWEN)
                begin
                    //WENfirst = 0;
                    nfirstSt = IDLEfirst;
                end
            end
        endcase
    end

    // always_ff @(posedge CLK, negedge nRST) begin : address
    //     if(!nRST)
    //     begin
    //         dmemaddrFF <= 0;
    //     end
    //     else if (currState == IDLE)
    //     begin
    //         dmemaddrFF <= dcif.dmemaddr;
    //     end
    // end

    always_comb begin : CMBLGC
        nState = currState;
        ndcache = dcache;
        nLRU = LRU;
        nIndex = index;
        nhit_counter = hit_counter;
        nEndSet = endSet;

        ndREN = 0;
        ndWEN = 0;
        ndaddr = 0;
        ndstore = 0;

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
                nEndSet = 0;
                if(dcif.halt)
                begin
                    nState = ENDWR1;
                end
                else if(dcif.dmemREN)
                begin
                    if(dcache[0][addr.idx].valid && dcache[0][addr.idx].tag == addr.tag)
                    begin
                        dcif.dhit = 1;
                        dcif.dmemload = dcache[0][addr.idx].data[addr.blkoff];
                        ndcache[0][addr.idx].dirty = dcache[0][addr.idx].dirty; //might not need this line
                        ndcache[0][addr.idx].data[addr.blkoff] = dcif.dmemWEN ? dcif.dmemstore : dcache[0][addr.idx].data[addr.blkoff];
                        nhit_counter = hit_counter + 1;
                        nLRU[addr.idx] = 1;
                    end
                    else if(dcache[1][addr.idx].valid && dcache[1][addr.idx].tag == addr.tag)
                    begin
                        dcif.dhit = 1;
                        dcif.dmemload = dcache[1][addr.idx].data[addr.blkoff];
                        ndcache[1][addr.idx].dirty = dcache[1][addr.idx].dirty;
                        ndcache[1][addr.idx].data[addr.blkoff] = dcif.dmemWEN ? dcif.dmemstore : dcache[1][addr.idx].data[addr.blkoff];
                        nhit_counter = hit_counter + 1;
                        nLRU[addr.idx] = 0;
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
                else if(dcif.dmemWEN)
                begin
                    if(dcache[0][addr.idx].valid && dcache[0][addr.idx].tag == addr.tag && dcache[0][addr.idx].dirty)
                    begin
                        dcif.dhit = 1;
                        dcif.dmemload = dcache[0][addr.idx].data[addr.blkoff];
                        ndcache[0][addr.idx].dirty = 1; //might not need this line
                        ndcache[0][addr.idx].data[addr.blkoff] = dcif.dmemWEN ? dcif.dmemstore : dcache[0][addr.idx].data[addr.blkoff];
                        nhit_counter = hit_counter + 1;
                        nLRU[addr.idx] = 1;
                    end
                    else if(dcache[1][addr.idx].valid && dcache[1][addr.idx].tag == addr.tag && dcache[1][addr.idx].dirty)
                    begin
                        dcif.dhit = 1;
                        dcif.dmemload = dcache[1][addr.idx].data[addr.blkoff];
                        ndcache[1][addr.idx].dirty = 1;
                        ndcache[1][addr.idx].data[addr.blkoff] = dcif.dmemWEN ? dcif.dmemstore : dcache[1][addr.idx].data[addr.blkoff];
                        nhit_counter = hit_counter + 1;
                        nLRU[addr.idx] = 0;
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
            end
            WB1: //writing LRU data into RAM
            begin
                // cif.daddr = dmemaddrFF;
                ndaddr = {oldaddr.tag, addr.idx, addr.blkoff, addr.bytoff};
                ndstore = dcache[LRU[addr.idx]][addr.idx].data[addr.blkoff];
                ndWEN = 1;
                if(!cif.dwait && cif.daddr == {oldaddr.tag, addr.idx, addr.blkoff, addr.bytoff})
                begin
                    nState = WB2;
                end
            end
            WB2:
            begin
                ndaddr = {oldaddr.tag, addr.idx, ~addr.blkoff, addr.bytoff};
                ndstore = dcache[LRU[addr.idx]][addr.idx].data[~addr.blkoff];
                ndWEN = 1;
                if(!cif.dwait && cif.daddr == {oldaddr.tag, addr.idx, ~addr.blkoff, addr.bytoff})
                begin
                    nState = ALLOCATE1;
                end
            end
            ALLOCATE1: //Taking RAM data and putting it into LRU cache
            //Swap ALLOCATE1 and ALLOCATE2
            begin
                //need to wait for RAM
                //miss = 1;
                ndREN = 1;
                ndaddr = {addr.tag, addr.idx, ~addr.blkoff, addr.bytoff};
                if(!cif.dwait && cif.daddr == {addr.tag, addr.idx, ~addr.blkoff, addr.bytoff})
                begin
                    ndcache[LRU[addr.idx]][addr.idx].tag = addr.tag;
                    ndcache[LRU[addr.idx]][addr.idx].data[~addr.blkoff] = cif.dload;
                    ndcache[LRU[addr.idx]][addr.idx].valid = 1;
                    ndcache[LRU[addr.idx]][addr.idx].dirty = 0;
                    nState = ALLOCATE2;
                    // dcif.dhit = 1;
                    // nState = IDLE;
                end
            end
            ALLOCATE2:
            begin
                if(dcif.dmemWEN && WENfirst)
                begin
                    ndcache[LRU[addr.idx]][addr.idx].tag = addr.tag;
                    ndcache[LRU[addr.idx]][addr.idx].data[addr.blkoff] = dcif.dmemstore;
                    ndcache[LRU[addr.idx]][addr.idx].valid = 1;
                    ndcache[LRU[addr.idx]][addr.idx].dirty = 1;
                    dcif.dhit = 1;
                    //miss = 0;
                    nLRU[addr.idx] = ~LRU[addr.idx];
                    nState = IDLE;
                    // nState = ALLOCATE2;
                end
                else
                begin
                    //miss = 1;
                    ndREN = 1;
                    // cif.daddr = dmemaddrFF;
                    ndaddr = dcif.dmemaddr;
                    if(!cif.dwait && cif.daddr == dcif.dmemaddr)
                    begin
                        ndcache[LRU[addr.idx]][addr.idx].tag = addr.tag;
                        ndcache[LRU[addr.idx]][addr.idx].data[addr.blkoff] = cif.dload;
                        ndcache[LRU[addr.idx]][addr.idx].valid = 1;
                        ndcache[LRU[addr.idx]][addr.idx].dirty = 0;
                        dcif.dhit = 1;
                        //miss = 0;
                        nLRU[addr.idx] = ~LRU[addr.idx];
                        dcif.dmemload = cif.dload;
                        nState = IDLE;
                        // nState = ALLOCATE2;
                    end

                end
            end
            // ALLOCATE1: //Taking RAM data and putting it into LRU cache
            // //Swap ALLOCATE1 and ALLOCATE2
            // begin
            //     //this causes issues with WAR
            //     //if no flip-flopped REN then dmemWEN is first
            //     if(dcif.dmemWEN && WENfirst)
            //     begin
            //         ndcache[LRU[addr.idx]][addr.idx].tag = addr.tag;
            //         ndcache[LRU[addr.idx]][addr.idx].data[addr.blkoff] = dcif.dmemstore;
            //         ndcache[LRU[addr.idx]][addr.idx].valid = 1;
            //         ndcache[LRU[addr.idx]][addr.idx].dirty = 1;
            //         //dcif.dhit = 1;
            //         //nLRU[addr.idx] = ~LRU[addr.idx];
            //         nState = ALLOCATE2;
            //     end
            //     //need to wait for RAM
            //     else
            //     begin
            //         ndREN = 1;
            //         ndaddr = dcif.dmemaddr;
            //         if(!cif.dwait && cif.daddr == dcif.dmemaddr)
            //         begin
            //             ndcache[LRU[addr.idx]][addr.idx].tag = addr.tag;
            //             ndcache[LRU[addr.idx]][addr.idx].data[addr.blkoff] = cif.dload;
            //             ndcache[LRU[addr.idx]][addr.idx].valid = 1;
            //             ndcache[LRU[addr.idx]][addr.idx].dirty = 0;
            //             nState = ALLOCATE2;
            //             // dcif.dhit = 1;
            //             // nState = IDLE;
            //         end
            //     end
            // end
            // ALLOCATE2:
            // begin
            //     ndREN = 1;
            //     // cif.daddr = dmemaddrFF;
            //     ndaddr = {addr.tag, addr.idx, ~addr.blkoff, addr.bytoff};
            //     if(!cif.dwait && cif.daddr == {addr.tag, addr.idx, ~addr.blkoff, addr.bytoff})
            //     begin
            //         ndcache[LRU[addr.idx]][addr.idx].tag = addr.tag;
            //         ndcache[LRU[addr.idx]][addr.idx].data[~addr.blkoff] = cif.dload;
            //         ndcache[LRU[addr.idx]][addr.idx].valid = 1;
            //         ndcache[LRU[addr.idx]][addr.idx].dirty = dcache[LRU[addr.idx]][addr.idx].dirty;
            //         dcif.dhit = 1;
            //         dcif.dmemload = dcache[LRU[addr.idx]][addr.idx].data[addr.blkoff];
            //         nLRU[addr.idx] = ~LRU[addr.idx];
            //         nState = IDLE;
            //         // nState = ALLOCATE2;
            //     end
            // end
            ENDWR1:
            begin
                if(dcache[endSet][index].dirty)
                begin
                    ndWEN = 1;
                    ndaddr = {dcache[endSet][index].tag, index, 3'b0};
                    ndstore = dcache[endSet][index].data[0];
                    if(!cif.dwait && cif.daddr == {dcache[endSet][index].tag, index, 3'b0} && cif.dWEN)
                    begin
                        nState = ENDWR2;
                    end
                    // else
                    // begin
                    //     nState = ENDWR1;
                    // end
                end
                else
                begin
                    nState = INCRCNT;
                end
            end
            ENDWR2:
            begin
                ndWEN = 1;
                ndaddr = {dcache[endSet][index].tag, index, 1'b1, 2'b0};
                ndstore = dcache[endSet][index].data[1];
                if(!cif.dwait && cif.daddr == {dcache[endSet][index].tag, index, 1'b1, 2'b0} && cif.dWEN)
                begin
                    nState = INCRCNT;
                end
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
                    nEndSet = 1;
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
                ndWEN = 1;
                ndaddr = 32'h3100;
                ndstore = hit_counter;
                if (!cif.dwait && cif.daddr == 32'h3100)
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

//hit count might be off because of load word stalling maybe don't incr all the time when stalling in load mem