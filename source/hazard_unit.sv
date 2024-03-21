/*
    Hazard Unit
*/
`include "hazard_unit_if.vh"

module hazard_unit (
    // input logic clk,
    // input logic nRST,
    hazard_unit_if.hu huif
);

    always_comb begin
        huif.flush1 = 0;
        huif.flush2 = 0;
        huif.flush3 = 0;
        huif.stall = 0;
        huif.stall_all = 0;


        // load hazard
        // if (ID/EX.MemRead and
        //  ((ID/EX.RegisterRt = IF/ID.RegisterRs) or
        //  (ID/EX.RegisterRt = IF/ID.RegisterRt)))
        //  stall the pipeline

        //maybe stall pipeline for JR
        if((huif.stage3_MemRead || huif.stage3_MemWrite))
        begin
            huif.stall_all = 1;
        end

        else if ((huif.stage2_MemRead && !huif.branch) && 
            ((huif.stage2_rt == huif.stage1_rs) ||
            (huif.stage2_rt == huif.stage1_rt))) begin

            huif.stall = 1;

        end


        // branch hazard
        if (huif.branch) begin
            huif.flush1 = 1;
            huif.flush2 = 1;
            huif.flush3 = 1;
        end
        // jump "hazard"
        else if (huif.jump) begin
            huif.flush1 = 1;
        end
        else if(huif.jr) begin
            huif.flush1 = 1;
            huif.flush2 = 1;
        end
    end

endmodule