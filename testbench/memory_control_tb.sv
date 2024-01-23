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
    memory_control DUT1(CLK, ccif);

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

task instReq;
    input [31:0] addr;
    cif0.iREN = 1;
    cif0.iaddr = addr;
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

task reset;
    res = "in reset";
    cif0.dREN = 0;
    cif0.dWEN = 0;
    cif0.iaddr = 0;
    cif0.daddr = 0;
endtask

task automatic dump_memory();
    string filename = "memcpu.hex";
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

task automatic dump_memory2();
    string filename = "memcpu2.hex";
    int memfd;

    //syif.tbCTRL = 1;
    cif0.daddr = 0;
    cif0.dWEN = 0;
    cif0.dREN = 0;

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

initial begin
    nRST = 1;
    dump_memory();
    // nRST = 1;
    // cif0.dREN = 0;
    // cif0.dWEN = 0;
    // cif0.dstore = 0;
    // cif0.iaddr = 0;
    // cif0.daddr = 0;
    // cif0.iREN = 1;
    // //dump_memory();
    // // nRST = 1;
    // // cif0.dREN = 0;
    // // cif0.dWEN = 0;
    // // cif0.dstore = 0;
    // // cif0.iaddr = 0;
    // // cif0.daddr = 0;
    // // cif0.iREN = 1;

    // //TEST CASE 1
    // testType = "Regular Instruction";
    // instReq(32'h01234567);
    // #(4*PERIOD);
    
    // //TEST CASE 2



    // //TEST CASE 3
    // testType = "Store from RAM";
    // instReq(32'h00000003);
    // #(PERIOD);
    // dataWrite(32'h00000004, 44); //write 44 to address 4 in RAM
    // #(4*PERIOD);
    // reset();
    // #(PERIOD);
    // res = "not in reset";
    // //dump_memory2();

    // testType = "LOAD from RAM";
    // instReq(32'h00000001); //request instruction from address 5
    // #(PERIOD);
    // dataRead(32'h00000004); //request data from address 4
    // #(4*PERIOD);
    // reset();
    // #(PERIOD);
    // res = "not in reset";

end


endprogram