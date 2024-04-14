`include "forward_unit_if.vh"
`include "cpu_types_pkg.vh"

module forward_unit(
    forward_unit_if.fu fuif
);
import cpu_types_pkg::*;

    always_comb begin 
        fuif.forwardA = 2'b00;
        fuif.forwardB = 2'b00;
        if(fuif.stage3_RegWr && fuif.stage3_rd != 0)
        begin
            if(fuif.stage3_rd == fuif.stage2_rs)
            begin
                fuif.forwardA = 2'b10;
            end
            if(fuif.stage3_rd == fuif.stage2_rt)
            begin
                fuif.forwardB = 2'b10;
            end
        end
        if(fuif.stage4_RegWr && fuif.stage4_rd != 0)
        begin
            if(fuif.stage4_rd == fuif.stage2_rs && fuif.stage3_rd != fuif.stage2_rs) //use more recent result
            begin
                fuif.forwardA = 2'b01;
            end

            if(fuif.stage4_rd == fuif.stage2_rt && fuif.stage3_rd != fuif.stage2_rt) //use more recent result
            begin
                fuif.forwardB = 2'b01;
            end
        end
    end
endmodule