`include "forward_unit_if.vh"
import cpu_types_pkg::*;
`timescale 1 ns / 1 ns

`include "cpu_types_pkg.vh"

module forward_unit_tb;
    logic nRST;
    parameter PERIOD = 10;
    logic CLK = 0;

    always #(PERIOD/2) CLK++;

    forward_unit_if fuif();
    test PROG(CLK, nRST, fuif);
    forward_unit DUT(fuif);
endmodule

program test(
    input logic CLK,
    output logic nRST,
    forward_unit_if.tb fuif
);

    parameter PERIOD = 10;
    string testType;

    task check_outputs;
        input [1:0] checkA;
        input [1:0] checkB;
        #(PERIOD/2);
        if(fuif.forwardA != checkA || fuif.forwardB != checkB)
        begin
            $display("Incorrect forward output for %s\n", testType);
        end
        else
        begin
            $display("Correct forward output for %s\n", testType);
        end
    endtask
    task reset;
        #(PERIOD);
        testType = "Reset";
        fuif.stage2_rs = 0;
        fuif.stage2_rt = 0;
        fuif.stage3_rd = 0;
        fuif.stage4_rd = 0;

        fuif.stage3_RegWr = 0;
        fuif.stage4_RegWr = 0;
        #(PERIOD);
        
    endtask
    initial begin
        reset();

        testType = "0 register hazard check";
        fuif.stage3_RegWr = 1;
        check_outputs(0,0);




        //test stage 3 hazard
        testType = "Normal stage 3 hazard";
        fuif.stage3_RegWr = 1;
        fuif.stage3_rd = 1;
        fuif.stage2_rs = 1;
        fuif.stage2_rt = 1;
        check_outputs(2,2);


        reset();
        
        testType = "Normal stage 4 hazard";
        fuif.stage4_RegWr = 1;
        fuif.stage4_rd = 2;
        fuif.stage2_rs = 2;
        fuif.stage2_rt = 2;
        check_outputs(1,1);

        reset();

        testType = "A stage 3 B stage 4";
        fuif.stage3_RegWr = 1;
        fuif.stage4_RegWr = 1;
        fuif.stage3_rd = 1;
        fuif.stage2_rs = 1;
        fuif.stage4_rd = 2;
        fuif.stage2_rt = 2;
        check_outputs(2,1);

        reset();

        testType = "A stage 4 B stage3";
        fuif.stage3_RegWr = 1;
        fuif.stage4_RegWr = 1;
        fuif.stage3_rd = 1;
        fuif.stage2_rt = 1;
        fuif.stage4_rd = 2;
        fuif.stage2_rs = 2;
        check_outputs(1,2);

        reset();

        testType = "stage4 hazard but modified in stage 3 also";
        fuif.stage3_RegWr = 1;
        fuif.stage4_RegWr = 1;
        fuif.stage3_rd = 3;
        fuif.stage4_rd = 3;
        fuif.stage2_rs = 3;
        fuif.stage2_rt = 3;
        check_outputs(2,2);

        reset();

        testType = "no hazards";
        fuif.stage3_RegWr = 1;
        fuif.stage4_RegWr = 1;
        fuif.stage3_rd = 10;
        fuif.stage4_rd = 9;
        fuif.stage2_rs = 5;
        fuif.stage2_rt = 6;
        check_outputs(0,0);

    
    end

endprogram