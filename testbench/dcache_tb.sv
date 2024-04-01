`include "cpu_types_pkg.vh"
`include "caches_if.vh"
`include "datapath_cache_if.vh"

module dcache_tb;
    logic nRST;
    parameter PERIOD = 10;
    logic CLK = 0;

    always #(PERIOD/2) CLK++;
    caches_if cif();
    datapath_cache_if dcif();
    test PROG(CLK, nRST, dcif, cif);
    dcache DUT(CLK, nRST, dcif, cif);
endmodule

program test(
    input logic CLK,
    output logic nRST,
    datapath_cache_if.dcache dcif,
    caches_if.dcache cif
);
    import cpu_types_pkg::*;
    parameter PERIOD = 10;

    string testType;
    string inReset;

    task reset;
        inReset = "in reset";
        nRST = 0;
        #(PERIOD);
        inReset = "not in reset";
        nRST = 1;
    endtask

    task instReq;
        input [25:0] tag;
        input [2:0] idx;
        input block_offset;
        
        dcif.dmemaddr = {tag, idx, block_offset, 1'b0, 1'b0};
    endtask

    task inputReset;
        dcif.dmemREN = 0;
        dcif.dmemWEN = 0;
        dcif.dmemstore = 0;
        dcif.dmemaddr = 0;
        cif.dload = 0;
        cif.dwait = 0;
        cif.ccwait = 0;
        cif.ccinv = 0;
        cif.ccsnoopaddr = '0;
    endtask


    initial begin
        nRST = 1;
        inputReset();
        reset();
        testType = "Load into index 2, set 0 of cache"; // miss
        instReq(5, 2, 0);
        cif.dload = 32'hDEAD;
        dcif.dmemREN = 1;
        cif.dwait = 1;
        @(posedge CLK);
        @(posedge CLK); //make sure does not progress to IDLE and stays in MISS
        cif.dwait = 0;
        @(posedge CLK);
        @(posedge CLK);
        dcif.dmemREN = 0;
        #(PERIOD*3);

        testType = "Grab info from index 2, set 0 of cache"; // hit
        dcif.dmemREN = 1;
        @(posedge CLK);
        dcif.dmemREN = 0;
        #(PERIOD*5);

        testType = "Stay in idle";
        #(PERIOD*5);

        testType = "Load into index 2, set 1 of cache"; // miss
        instReq(10, 2, 1);
        cif.dload = 32'hBEEF;
        dcif.dmemREN = 1;
        cif.dwait = 1;
        @(posedge CLK);
        @(posedge CLK);
        cif.dwait = 0;
        @(posedge CLK);
        @(posedge CLK);
        dcif.dmemREN = 0;
        #(PERIOD*3);

        testType = "Write into index 3, set 0 of cache"; // miss
        inputReset();
        instReq(10, 3, 1);
        dcif.dmemstore = 32'habcd;
        dcif.dmemWEN = 1;
        cif.dwait = 1;
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        cif.dwait = 0;
        @(posedge CLK);
        @(posedge CLK);
        cif.dwait = 1;
        dcif.dmemWEN = 0;
        #(PERIOD*3);

        testType = "Write into index 3 slow, set 1 of cache"; // miss
        inputReset();
        instReq(11, 3, 1);
        dcif.dmemstore = 32'hffff;
        dcif.dmemWEN = 1;

        cif.dwait = 1;
        #(PERIOD*5);
        cif.dwait = 0;
        @(posedge CLK);

        // cif.dwait = 1;
        // #(PERIOD*5);
        // cif.dwait = 0;
        // @(posedge CLK);

        cif.dwait = 1;
        @(posedge CLK);

        cif.dwait = 1;
        dcif.dmemWEN = 0;
        #(PERIOD*3);

        testType = "Force a write back in index 3"; // miss
        // inputReset();
        // instReq(11, 3, 1);
        // cif.dload = 32'hBEEF;
        // dcif.dmemREN = 1;
        // cif.dwait = 1;
        // @(posedge CLK);
        // @(posedge CLK);
        // cif.dwait = 0;
        // @(posedge CLK);
        // @(posedge CLK);
        // dcif.dmemREN = 0;
        // #(PERIOD*3);

        inputReset();
        instReq(12, 3, 1);
        dcif.dmemstore = 32'habcd;
        dcif.dmemWEN = 1;
        cif.dwait = 1;
        repeat (4) @(posedge CLK);
        cif.dwait = 0;
        repeat (6) @(posedge CLK);
        cif.dwait = 1;
        dcif.dmemWEN = 0;
        #(PERIOD*3);


        testType = "Write into index 3, set 0 of cache"; // miss
        inputReset();
        instReq(10, 3, 1);
        dcif.dmemstore = 32'habcd;
        dcif.dmemWEN = 1;
        cif.dwait = 1;
        repeat (4) @(posedge CLK);
        cif.dwait = 0;
        @(posedge CLK);
        @(posedge CLK);
        cif.dwait = 1;
        dcif.dmemWEN = 0;
        #(PERIOD*3);

        testType = "Snoop Address Match"; // miss
        inputReset();
        instReq(10, 4, 1);
        dcif.dmemstore = 32'habcd;
        dcif.dmemWEN = 1;
        cif.dwait = 1;
        repeat (4) @(posedge CLK);
        cif.dwait = 0;
        @(posedge CLK);
        @(posedge CLK);
        cif.dwait = 1;
        dcif.dmemWEN = 0;
        #(PERIOD*3);

        testType = "Halt";
        inputReset();
        dcif.halt = 1;
        #(PERIOD*3*18);
        cif.dwait = 0;
        #(PERIOD*3);

    end
    

    




endprogram
