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
    caches_if cif0 ();
    caches_if cif1 ();
    cache_control_if ccif (cif0, cif1);
    
    
    test PROG(CLK, nRST, ramif, cif0, ccif);

    ram DUT0(CLK, nRST, ramif);
    memory_control DUT1(CLK, nRST, ccif);

    assign ramif.ramstore = ccif.ramstore;
    assign ramif.ramaddr = ccif.ramaddr;
    assign ramif.ramWEN = ccif.ramWEN;
    assign ramif.ramREN = ccif.ramREN;
    assign ccif.ramload = ramif.ramload;
    assign ccif.ramstate = ramif.ramstate;

endmodule

program test(
    input logic CLK,
    output logic nRST,
    cpu_ram_if.ram ram,
    caches_if.caches cif0,
    cache_control_if.cc ccif
);
parameter PERIOD = 10;
string testType;
integer testNum = 0;
string res;

task instReqC0;
    input [31:0] addr;
    cif0.iREN = 1;
    cif0.iaddr = addr;
endtask

task instReqC1;
    input [31:0] addr;
    cif1.iREN = 1;
    cif1.iaddr = addr;
endtask

task dataRead;
    input [31:0] addr;

    cif0.daddr = addr;
    cif0.dREN = 1;
endtask

task dataWrite;
    input [31:0] addr;
    input [31:0] storeVal;
    cif0.dWEN = 1;
    cif0.daddr = addr;
    cif0.dstore = storeVal;
endtask

task reset_C0;
    res = "core 0 reset";
    cif0.dREN = 0;
    cif0.dWEN = 0;
    cif0.dstore = 0;
    cif0.iaddr = 0;
    cif0.daddr = 0;
    cif0.iREN = 0;
    cif0.ccwrite = 0;
    cif0.cctrans = 0;
endtask

task reset_C1;
    res = "core 1 reset";
    cif1.dREN = 0;
    cif1.dWEN = 0;
    cif1.dstore = 0;
    cif1.iaddr = 0;
    cif1.daddr = 0;
    cif1.iREN = 0;
    cif1.ccwrite = 0;
    cif1.cctrans = 0;
endtask

task automatic dump_memory_0();
    string filename = "memcpuC0.hex";
    int memfd;

    //syif.tbCTRL = 1;
    cif0.daddr = 0;
    cif0.dWEN = 0;
    cif0.dREN = 0;

    #(PERIOD);

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      cif0.daddr = i << 2;
      cif0.dREN = 1;
      repeat (4) @(posedge CLK);
      if (cif0.dload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,cif0.dload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),cif0.dload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      //syif.tbCTRL = 0;
      cif0.dREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask

task automatic dump_memory_1();
    string filename = "memcpuC1.hex";
    int memfd;

    //syif.tbCTRL = 1;
    cif1.daddr = 0;
    cif1.dWEN = 0;
    cif1.dREN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      cif1.daddr = i << 2;
      cif1.dREN = 1;
      repeat (4) @(posedge CLK);
      if (cif1.dload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,cif1.dload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),cif1.dload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      //syif.tbCTRL = 0;
      cif1.dREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask

initial begin
    nRST = 1;
    // inputs to controller
    cif0.dREN = 0;
    cif0.dWEN = 0;
    cif0.dstore = 0;
    cif0.iaddr = 0;
    cif0.daddr = 0;
    cif0.iREN = 0;
    cif0.ccwrite = 0;
    cif0.cctrans = 0;

    cif1.dREN = 0;
    cif1.dWEN = 0;
    cif1.dstore = 0;
    cif1.iaddr = 0;
    cif1.daddr = 0;
    cif1.iREN = 0;
    cif1.ccwrite = 0;
    cif1.cctrans = 0;
    #(2*PERIOD);

    testType = "initialize/reset";
    nRST = 0;
    #(2*PERIOD);
    nRST = 1;
    #(2*PERIOD);


    //TEST CASE 1
    testType = "Regular Instructions";
    instReqC0(32'h1);
    #(2*PERIOD);
    reset_C0();
    #(2*PERIOD);
    instReqC1(32'h2);
    #(2*PERIOD);
    reset_C1();
    
    //TEST CASE 2
    testType = "C0 I->S, C1 S->S || I->I";
    cif0.dREN = 1;
    cif0.daddr = 32'h8000;
    #(2*PERIOD); //ccsnoopaddr should be valid
    cif1.cctrans = 1;
    #(2*PERIOD);
    cif1.cctrans = 0;
    #(5*PERIOD);
    reset_C0();

    //TEST CASE 3
    testType = "C0 I->S, C1 M->S";
    cif0.dREN = 1;
    cif0.daddr = 32'h8000;
    #(2*PERIOD); //ccsnoopaddr should be valid
    cif1.cctrans = 1;
    #(2*PERIOD);
    cif1.dWEN = 1; //core 1 writing back
    #(10*PERIOD);
    reset_C0();
    reset_C1();


    //TEST CASE 4
    testType = "C0 I->M, C1 S->I || I->I";
    cif0.dREN = 1;
    cif0.daddr = 32'hFFFF;
    cif0.ccwrite = 1;
    #(2*PERIOD); //ccsnoopaddr should be valid
    cif1.cctrans = 1;
    #(2*PERIOD);
    #(5*PERIOD);
    reset_C0();
    reset_C1();

    //TEST CASE 5
    testType = "C0 I->M, C1 M->I";
    cif0.dREN = 1;
    cif0.daddr = 32'hFFFF;
    cif0.ccwrite = 1;
    #(2*PERIOD); //ccsnoopaddr should be valid
    cif1.cctrans = 1;
    #(2*PERIOD);
    cif1.dWEN = 1;
    #(2*PERIOD);
    cif1.dWEN = 0;
    cif1.cctrans = 0;
    #(5*PERIOD);
    reset_C0();
    reset_C1();

    //TEST CASE 6
    testType = "C0 S->M, C1 S->I || I->I";
    cif0.daddr = 32'hFFFF;
    cif0.ccwrite = 1;
    #(2*PERIOD); //ccsnoopaddr should be valid
    cif1.cctrans = 1;
    #(2*PERIOD);
    #(2*PERIOD);
    cif1.cctrans = 0;
    #(5*PERIOD);
    reset_C0();
    reset_C1();
end


endprogram