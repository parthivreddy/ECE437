'include "AlU_if.vh"

module ALU_fpga (
    input logic [3:0] KEY,
    input logic [17:0] SW,
    output logic [17:0] LEDR
);

ALU_if alu();
ALU AL(alu);

assign alu.op = KEY[3:0];
assign alu.port_a = SW[17] ? alu.port_a: SW[16:0];
assign alu.port_b = SW[17] ? SW[16:0] : alu.port_b;

endmodule