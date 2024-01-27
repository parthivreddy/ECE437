`include "request_unit_if.vh"
import cpu_types_pkg::*;
// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

`include "cpu_types_pkg.vh"

module request_unit_tb;
  logic nRST;
  parameter PERIOD = 10;

  logic CLK = 0;

  // clock
  always #(PERIOD/2) CLK++;

  request_unit_if rqif();
  test PROG(CLK, nRST, rqif);
  request_unit DUT(CLK, nRST, rqif);
endmodule

program test(
    input logic CLK,
    output logic nRST,
    request_unit_if.tb rqif
);
    parameter PERIOD = 10;
    string testType;

    task reset();
        nRST = 0;
        rqif.MemRead = 0;
        rqif.MemWrite = 0;
        rqif.dhit = 0;
        #(PERIOD);
        nRST = 1;
        #(PERIOD);
    endtask

    initial begin
        nRST = 1;
        rqif.dhit = 0;
        rqif.ihit = 0;

        //Test Case 1
        assert(rqif.imemREN == 1);

        #(PERIOD);

        rqif.MemRead = 1;
        #(PERIOD);
        assert(rqif.dmemREN == 1);

        reset();

        rqif.MemWrite = 1;
        #(PERIOD);
        assert(rqif.dmemWEN == 1);

        reset();

        rqif.MemWrite = 1;
        rqif.dhit = 1;
        #(PERIOD);
        assert(rqif.dmemWEN == 0);
        #(4*PERIOD);




    end

endprogram