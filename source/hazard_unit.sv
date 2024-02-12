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
        huif.set2 = 0;
        huif.stall = 0;
        huif.npc_sel = 0;

        // load hazard
        // if (ID/EX.MemRead and
        //  ((ID/EX.RegisterRt = IF/ID.RegisterRs) or
        //  (ID/EX.RegisterRt = IF/ID.RegisterRt)))
        //  stall the pipeline
        if ((huif.stage2_MemRead) && 
            ((huif.stage2_rt == huif.stage1_rs) ||
            (huif.stage2_rt == huif.stage1_rt))) begin

            huif.stall = 1;

        end


        // branch hazard
        if (huif.branch) begin
            huif.flush1 = 1;
            huif.set2 = 1;
            huif.npc_sel = 2;
        end
        // jump "hazard"
        else if (huif.jump) begin
            huif.flush1 = 1;
            huif.npc_sel = 1;
        end
    end

endmodule