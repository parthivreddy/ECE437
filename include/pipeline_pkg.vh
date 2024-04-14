`ifndef PIPELINE_PKG_VH
`define PIPELINE_PKG_VH

package pipeline_pkg;

typedef struct packed {
    logic [31:0] PC_plus_four;
    logic [31:0] instruction;
} IF_ID;

typedef struct packed {
    logic [31:0] PC_plus_four;
    logic [31:0] rdat1;
    logic [31:0] rdat2;
    logic [31:0] immExtension;
    logic [31:0] LUIdat;
    logic [4:0] dest;
    logic [4:0] rs, rt, rd;

    logic ALUSrc;
    logic[3:0] ALUCtrl;
    logic MemRead, MemWrite, Jump, Beq, Bne, JR;
    logic MemtoReg, Link, LUI, RegWr, halt, LL, SC;
} ID_EX;

typedef struct packed {
    logic [31:0] PC_plus_four;
    logic [31:0] rdat1;
    logic [31:0] rdat2;
    logic [31:0] LUIdat;
    logic [4:0] dest;
    logic [31:0] branchPC;
    logic zero;
    logic [31:0] ALU_output;
    logic [4:0] rs, rt, rd;

    logic MemRead, MemWrite, Jump, Beq, Bne, JR;
    logic MemtoReg, Link, LUI, RegWr, halt, LL, SC;
} EX_MEM;

typedef struct packed {
    logic [31:0] dmemload;
    logic [31:0] LUIdat;
    logic [4:0] dest;
    logic [31:0] PC_plus_four;
    logic [31:0] ALU_output;
    logic [4:0] rs, rt, rd;
    logic [4:0] rdat2;

    logic MemRead, MemtoReg, Link, LUI, RegWr, halt, SC;
} MEM_WB;

endpackage
`endif //CPU_TYPES_PKG_VH