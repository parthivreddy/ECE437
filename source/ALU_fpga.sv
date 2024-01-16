`include "ALU_if.vh"
`include "cpu_types_pkg.vh"

module ALU_fpga (
    input logic [3:0] KEY,
    input logic [17:0] SW,
    output logic [17:0] LEDR,
    output logic [7:0] LEDG
);
import cpu_types_pkg::*;
ALU_if alu();
ALU AL(alu);

assign alu.op = aluop_t' (KEY[3:0]);
assign alu.port_a = SW[17] ? alu.port_a: SW[16:0];
assign alu.port_b = SW[17] ? SW[16:0] : alu.port_b;

assign LEDG[3:0] = KEY[3:0];
assign LEDR[17:0] = alu.ALU_output;

endmodule