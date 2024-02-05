`include "datapath_cache_if.vh"
`include "register_file_if.vh"
`include "request_unit_if.vh"
`include "control_unit_if.vh"
`include "ALU_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"
`include "pipeline_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);

  // import types
  import cpu_types_pkg::*;
  import pipeline_pkg::*;

  register_file_if rfif();
  //request_unit_if rqif();
  control_unit_if ctif();
  ALU_if alif();
  ALU AL(alif);
  register_file RF(CLK, nRST, rfif);
  control_unit CT(CLK, nRST, ctif);

  // pc init
  parameter PC_INIT = 0;
  logic [31:0] PC;
  logic [31:0] nPC;
  logic prog;
  logic flush, enable;

  //halt flip flop signal
  logic nHalt;

  //**************************
  //Internal Data Path Signals
  //**************************

  //Instruction Decoding
  logic [4:0] rs, rt, rd;
  logic [15:0] imm16;
  logic [5:0] ALUctrl;

  //Sign Extension Signal
  logic [31:0] imm32;

  logic [31:0] pcTemp;
  //************************

  //Temporary read and write enable signals
  logic rqimemREN, rqdmemWEN, rqdmemREN;

  assign prog = (dpif.ihit || dpif.dhit);
  assign flush = 0;
  assign enable = 1;

  IF_ID stage1, nstage1;
  ID_EX stage2, nstage2;
  EX_MEM stage3, nstage3;
  MEM_WB stage4, nstage4;



  always_ff @(posedge CLK, negedge nRST) begin : PIPES
    if(!nRST)
    begin
        stage1 <= 0;
        stage2 <= 0;
        stage3 <= 0;
        stage4 <= 0;
    end
    else
    begin
        stage1 <= nstage1;
        stage2 <= nstage2;
        stage3 <= nstage3;
        stage4 <= nstage4;
    end
  end

  always_comb begin : STG1
    nstage1 = stage1;
    if(flush)
    begin
        nstage1 = 0;
    end
    else if(prog && enable)
    begin
        nstage1.PC_plus_four = PC + 4;
        nstage1.instruction = dpif.imemload;
    end
  end

  always_comb begin : STG2
    nstage2 = stage2;
    //nstage2.dest = stage2.dest;
    if(flush)
    begin
        nstage2 = 0;
    end
    else if(prog && enable)
    begin
        nstage2.instruction_jump = stage1.instruction[25:0];
        nstage2.PC_plus_four = stage1.PC_plus_four;
        nstage2.rdat1 = rfif.rdat1;
        nstage2.rdat2 = rfif.rdat2;
        nstage2.immExtension = ctif.ExtOp ? {{16{imm16[15]}}, imm16} : {{16{1'b0}}, imm16};
        nstage2.LUIdat = {imm16, 16'b0};
        if(ctif.Link)
        begin
            nstage2.dest = 31;
        end
        else if(ctif.RegDst)
        begin
            nstage2.dest = rd;
        end
        else
        begin
            nstage2.dest = rt;
        end

        //Control Signal Passing
        nstage2.ALUSrc = ctif.ALUSrc;
        nstage2.ALUCtrl = ctif.ALUCtrl;
        nstage2.MemRead = ctif.MemRead;
        nstage2.MemWrite = ctif.MemWrite;
        nstage2.Jump = ctif.Jump;
        nstage2.Beq = ctif.Beq;
        nstage2.Bne = ctif.Bne;
        nstage2.JR = ctif.JR;
        nstage2.MemtoReg = ctif.MemtoReg;
        nstage2.Link = ctif.Link;
        nstage2.LUI = ctif.LUI;
        nstage2.RegWr = ctif.RegWr;
    end
  end

  always_comb begin : STG3
    nstage3 = stage3;
    if(flush)
    begin
        nstage3 = 0;
    end
    else if(prog && enable)
    begin
        nstage3.instruction_jump = stage2.instruction_jump;
        nstage3.PC_plus_four = stage2.PC_plus_four;
        nstage3.rdat1 = stage2.rdat1;
        nstage3.rdat2 = stage2.rdat2;
        nstage3.LUIdat = stage2.LUIdat;
        nstage3.dest = stage2.dest;
        nstage3.branchPC =  {stage2.PC_plus_four + {stage2.immExtension[29:0], 2'b0}};
        nstage3.zero = alif.zero;
        nstage3.ALU_output = alif.ALU_output;

        //Control Signals Pass
        nstage3.MemRead = stage2.MemRead;
        nstage3.MemWrite = stage2.MemWrite;
        nstage3.Jump = stage2.Jump;
        nstage3.Beq = stage2.Beq;
        nstage3.Bne = stage2.Bne;
        nstage3.JR = stage2.JR;
        nstage3.MemtoReg = stage2.MemtoReg;
        nstage3.Link = stage2.Link;
        nstage3.LUI = stage2.LUI;
        nstage3.RegWr = stage2.RegWr;
    end
  end

always_comb begin : STG4
    nstage4 = stage4;
    if(flush)
    begin
        nstage4 = 0;
    end
    else if(prog && enable)
    begin
        if((stage3.Beq && stage3.zero) || (stage3.Bne && !stage3.zero))
        begin
            nstage4.PC_result = stage3.branchPC;
        end
        else if(stage3.Jump)
        begin
            nstage4.PC_result = {stage3.PC_plus_four[31:28], stage3.instruction_jump, 2'b0};
        end
        else if(stage3.JR)
        begin
            nstage4.PC_result = stage3.rdat1;
        end
        else
        begin
            nstage4.PC_result = stage3.PC_plus_four;
        end
        nstage4.dmemload = dpif.dmemload;
        nstage4.LUIdat = stage3.LUIdat;
        nstage4.dest = stage3.dest;
        nstage4.PC_plus_four = stage3.PC_plus_four;
        nstage4.ALU_output = stage3.ALU_output;
        nstage4.RegWr = stage3.RegWr;
    end
end

//****************
//Figure out request unit and halt signals here
//****************

//Request Unit
always_comb begin : RQUNT
    rqimemREN = 1;
    if(dpif.dhit)
    begin
        rqdmemREN = 0;
        rqdmemWEN = 0;
    end
    else
        // rqdmemREN = (stage3.MemRead && dpif.ihit) ? 1 : 0;
        // rqdmemWEN = (stage3.MemWrite && dpif.ihit) ? 1 : 0;
        rqdmemREN = stage3.MemRead;
        rqdmemWEN = stage3.MemWrite;
end

//Instruction Decoding
assign ctif.opcode = opcode_t'(stage1.instruction[31:26]);
assign ctif.func = funct_t'(stage1.instruction[5:0]);
assign rs = stage1.instruction[25:21];
assign rt = stage1.instruction[20:16];
assign rd = stage1.instruction[15:11];
assign imm16 = stage1.instruction[15:0];

//Register File Interactions
assign rfif.rsel1 = rs;
assign rfif.rsel2 = rt;
assign rfif.WEN = (stage4.RegWr && (dpif.ihit || dpif.dhit));

//ALU interactions
assign alif.port_a = stage2.rdat1;
assign alif.port_b = stage2.ALUSrc ? stage2.immExtension : stage2.rdat2;
assign alif.op = aluop_t'(stage2.ALUCtrl);

//outputs to ram
assign dpif.dmemaddr = stage3.ALU_output;
assign dpif.dmemstore = stage3.rdat2;
assign dpif.imemaddr = PC;  
assign dpif.dmemREN = dpif.halt ? 0 : rqdmemREN; //Error on this line
assign dpif.dmemWEN = dpif.halt ? 0 : rqdmemWEN;
assign dpif.imemREN = dpif.halt ? 0 : rqimemREN;

//Cont

always_comb begin : RGFILE
    rfif.wdat = 0;
    rfif.wsel = stage4.dest;
    if(stage4.RegWr)
    begin
        if(stage4.LUI)
        begin
            rfif.wdat = stage4.LUIdat;
        end
        else if(stage4.Link)
        begin
            rfif.wdat = stage4.PC_plus_four;
        end
        else if(stage4.MemtoReg)
        begin
            rfif.wdat = stage4.dmemload;
        end
        else
        begin
            rfif.wdat = stage4.ALU_output;
        end
    end
end

//PC Updating
always_ff @(posedge CLK, negedge nRST) begin : PCFF
    if(!nRST)
    begin
        PC <= PC_INIT;
        dpif.halt <= 0;
    end
    else
    begin
        PC <= nPC; //stage4.PC_result
        dpif.halt <= (dpif.halt | ctif.halt);
    end
end

//INcorrect but lets do it anwyay
assign nPC = dpif.ihit ? PC + 4 : nPC;


endmodule