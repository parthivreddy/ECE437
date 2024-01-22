`include "caches_if.vh"
`include "cpu_ram_if.vh"
`include "cache_control_if.vh"
import cpu_types_pkg::*;
// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;
    parameter PERIOD = 10;
    logic CLK = 0;
    logic nRST;
    always #(PERIOD/2) CLK++;

    cpu_ram_if ramif ();
    caches_if cache ();
    cache_control_if ccif (cache, cache);
    
    
    test PROG(CLK, nRST, ramif, cache);

    ram DUT0(CLK, nRST, ramif);
    memory_control DUT1(CLK, ccif);

endmodule

program test(
    input logic CLK,
    output logic nRST,
    cpu_ram_if.ram ram,
    caches_if.caches cache
);
parameter PERIOD = 10;
string testType;
integer testNum = 0;
string reset;

task instReq;
    input [31:0] addr;
    cache.iREN = 1;
    cache.iaddr = addr;
endtask

task dataRead;
    input [31:0] addr;

    cache.daddr = addr;
    cache.dREN = 1;
endtask

task dataWrite;
    input [31:0] addr;
    input [31:0] storeVal;
    cache.dWEN = 1;
    cache.daddr = addr;
    cache.dstore = storeVal;
endtask

task reset;
    reset = "in reset";
    cache.dREN = 0;
    cache.dWEN = 0;
    cache.iaddr = 0;
    cache.daddr = 0;
endtask

initial begin
    nRST = 1;
    cache.dREN = 0;
    cache.dWEN = 0;
    cache.dstore = 0;
    cache.iaddr = 0;
    cache.daddr = 0;
    cache.iREN = 1;

    //TEST CASE 1
    testType = "Regular Instruction";
    instReq(32'h01234567);
    #(4*PERIOD);
    
    //TEST CASE 2
    testType = "LOAD from RAM";
    instReq(32'h00000001); //request instruction from address 5
    #(PERIOD);
    dataRead(32'h00000002); //request data from address 10
    #(4*PERIOD);
    reset();
    #(PERIOD);
    reset = "not in reset";


    //TEST CASE 3
    testType = "Store from RAM";
    instReq(32'h00000003);
    #(PERIOD);
    dataWrite(32'h00000004, 44); //write 44 to address 4 in RAM
    #(4*PERIOD);
    reset();
    #(PERIOD);
    reset = "not in reset";

end


endprogram