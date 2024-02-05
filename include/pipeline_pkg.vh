package pipeline_pkg.vh;

typedef struct packed {
    logic [31:0] PC_plus_four;
    logic [31:0] instruction;
} IF_ID;

typedef struct packed {
    logic [25:0] instruction_jump;
    logic [31:0] PC_plus_four;
    logic [31:0] rdat1;
    logic [31:0] rdat2;
    logic [31:0] immExtension;
    logic [31:0] LUIdat;
    logic [4:0] dest;

    logic ALUSrc;
    logic[3:0] ALUCtrl;
    logic MemRead, MemWrite, Jump, Beq, Bne, JR;
    logic MemtoReg, Link, LUI;
} ID_EX;

typedef struct packed {
    logic [25:0] instruction_jump;
    logic [31:0] PC_plus_four;
    logic [31:0] rdat1;
    logic [31:0] rdat2;
    logic [31:0] LUIdat;
    logic [4:0] dest;
    logic [31:0] branchPC;
    logic zero;
    logic [31:0] ALU_output;

    logic MemRead, MemWrite, Jump, Beq, Bne, JR;
    logic MemtoReg, Link, LUI;
} EX_MEM;

typedef struct packed {
    logic [31:0] PC_result;
    logic [31:0] dmemload;
    logic [31:0] LUIdat;
    logic [4:0] dest;
    logic [31:0] PC_plus_four;

    logic MemtoReg, Link, LUI;
} MEM_WB;