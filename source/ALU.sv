import cpu_types_pkg::*;
module ALU (
    ALU_if.alu alu
);
reg signed [31:0] bSigned, aSigned;


always_comb begin : COMBLGC
    bSigned = alu.port_b;
    aSigned = alu.port_a;
    if(alu.port_b[31] == alu.port_a[31] && alu.ALU_output[31] != alu.port_a[31])
        alu.ov = 1;
    else
        alu.ov = 0;
    alu.neg = alu.ALU_output[31] ? 1 : 0;
    alu.zero = !alu.ALU_output ? 1 : 0;
    alu.ALU_output = 0;

    casez(alu.op)
        ALU_SLL: alu.ALU_output = alu.port_b << alu.port_a;
        ALU_SRL: alu.ALU_output = alu.port_b >> alu.port_a;
        ALU_ADD: alu.ALU_output = bSigned + aSigned;
        ALU_SUB: alu.ALU_output = aSigned - bSigned;         
        ALU_AND: alu.ALU_output = alu.port_b & alu.port_a;
        ALU_OR: alu.ALU_output = alu.port_b | alu.port_a;
        ALU_XOR: alu.ALU_output = alu.port_b ^ alu.port_a;
        ALU_NOR: alu.ALU_output = ~(alu.port_b | alu.port_a);
        ALU_SLT: alu.ALU_output = (aSigned < bSigned) ? 1 : 0;
        ALU_SLTU: alu.ALU_output = (alu.port_a < alu.port_b) ? 1 : 0;
    endcase
end



endmodule