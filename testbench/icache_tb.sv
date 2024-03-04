`include "cpu_types_pkg.vh"
`include "caches_if.vh"
`include "datapath_cache_if.vh"

module icache_tb;
    logic nRST;
    parameter PERIOD = 10;
    logic CLK = 0;

    always #(PERIOD/2) CLK++;
    caches_if cif();
    datapath_cache_if dcif();
    test PROG(CLK, nRST, dcif, cif);
    icache DUT(CLK, nRST, dcif, cif);
endmodule

program test(
    input logic CLK,
    output logic nRST,
    datapath_cache_if.icache dcif,
    caches_if.icache cif
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
        input [3:0] idx;
        
        dcif.imemaddr = {tag, idx, 1'b0, 1'b0};
    endtask




    initial begin
        nRST = 1;
        reset();
        testType = "Populate idx 2 of cache"; //Miss
        instReq(5, 2);
        dcif.imemREN = 1;
        cif.iwait = 1;
        #(PERIOD);
        #(PERIOD); //make sure does not progress to IDLE and stays in MISS
        cif.iwait = 0;
        cif.iload = 10;
        #(PERIOD);
        #(PERIOD);
        dcif.imemREN = 0;

        testType = "Grab info from idx 2 of cache"; //hit
        instReq(5, 2);
        dcif.imemREN = 1;
        #(PERIOD);
        #(PERIOD);

        dcif.imemREN = 0;
        testType = "no data request should not do anything";
        instReq(5,2);
        #(PERIOD);
        #(PERIOD);

    end
    

    




endprogram
