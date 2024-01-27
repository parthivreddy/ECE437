`include "cpu_types_pkg.vh"
`include "ALU_if.vh"

module ALU (
    ALU_if.alu alu
);
import cpu_types_pkg::*;
reg signed [31:0] bSigned, aSigned;
logic ovTest, negTest, zeroTest;


always_comb begin : COMBLGC
    bSigned = alu.port_b;
    aSigned = alu.port_a;
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
        default: alu.ALU_output = 0;
    endcase
end

// always_comb 
// begin
//     alu.ov = ((alu.port_b[31] == alu.port_a[31]) && (alu.ALU_output[31] != alu.port_a[31])) ? 1 : 0;
//     alu.neg = (alu.ALU_output[31] == 1) ? 1 : 0;
//     alu.zero = (alu.ALU_output == '0) ? 1 : 0;
//     ovTest = ((alu.port_b[31] == alu.port_a[31]) && (alu.ALU_output[31] != alu.port_a[31])) ? 1 : 0;
//     negTest = (alu.ALU_output[31] == 1) ? 1 : 0;
//     zeroTest = (alu.ALU_output == '0) ? 1 : 0;

// end


//POSSIBLY ONLY assign zero within sub test
assign alu.ov = ((alu.port_b[31] == alu.port_a[31]) && (alu.ALU_output[31] != alu.port_a[31])) ? 1 : 0;
assign alu.neg = (alu.ALU_output[31] == 1) ? 1 : 0;
assign alu.zero = (alu.ALU_output == '0) ? 1 : 0;
assign ovTest = ((alu.port_b[31] == alu.port_a[31]) && (alu.ALU_output[31] != alu.port_a[31])) ? 1 : 0;
assign negTest = alu.ALU_output[31];
assign zeroTest = (alu.ALU_output == '0) ? 1 : 0;


endmodule