/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
`include "register_file_if.vh"
`include "request_unit_if.vh"
`include "control_unit_if.vh"
`include "ALU_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);

  // import types
  import cpu_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;

  //PC Flip Flop Signals
  logic [31:0] PC;
  logic [31:0] nPC;

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

  logic test;
  logic ntest;




  //************************


  //Hopefully Interface can connect in between modules
  //Might be worth to not use interface in request unit
  //and just use signals then assign them to dpif in datapath  register_file_if.rf rfif,
  register_file_if rfif();
  request_unit_if rqif();
  control_unit_if ctif();
  ALU_if alif();
  request_unit RU(CLK, nRST, rqif);
  ALU AL(alif);
  register_file RF(CLK, nRST, rfif);
  control_unit CT(CLK, nRST, ctif);
  //initialize PC
  always_ff @(posedge CLK, negedge nRST ) begin : PCFF
    if(!nRST)
    begin
      PC <= PC_INIT;
      dpif.halt <= ctif.Halt;
      //test <= 0;
    end
    else
    begin
      PC <= nPC;
      //dpif.halt <= nHalt; //MIGHT BE DIFFERENT 
      dpif.halt <= nHalt;
      //test <= ntest;
    end
  end

  //if ihit then update nPC
  always_comb begin : PCUPDT
    nPC = PC;
    pcTemp = 0;
    if(dpif.ihit && !dpif.halt)
    begin
      if((ctif.Beq && alif.zero) || (ctif.Bne && !alif.zero))
      begin
        pcTemp = PC + 4;
        nPC = (pcTemp) + (imm32 << 2);
      end
      else if(ctif.Jump)
      begin
        pcTemp = PC + 4;
        nPC = {pcTemp[31:28], dpif.imemload[25:0], {2{1'b0}}};
      end
      else if(ctif.JR)
      begin
        nPC = rfif.rdat1;
      end
      else
      begin
        nPC = PC + 4;
      end
    end
  end

  //assign signals straight to output
  assign dpif.dmemREN = dpif.halt ? 0 : rqif.dmemREN;
  assign dpif.dmemWEN = dpif.halt ? 0 : rqif.dmemWEN;
  assign dpif.imemREN = dpif.halt ? 0 : rqif.imemREN;
  assign dpif.imemaddr = PC;
  assign dpif.dmemaddr = alif.ALU_output;
  assign dpif.dmemstore = rfif.rdat2;
  assign nHalt = ctif.Halt | dpif.halt; //dpif.halt is actual output but flip flopped
  //assign ntest = ctif.Halt | test;

  //Instuction Decoding
  assign ctif.opcode = opcode_t'(dpif.imemload[31:26]);
  assign ctif.func = funct_t'(dpif.imemload[5:0]);
  assign rs = dpif.imemload[25:21];
  assign rt = dpif.imemload[20:16];
  assign rd = dpif.imemload[15:11];
  assign imm16 = dpif.imemload[15:0];

  //Sign Extension
  assign imm32 = ctif.ExtOp ? {{16{imm16[15]}}, imm16} : {{16{1'b0}}, imm16};
  
  //Register File Interactions
  assign rfif.rsel1 = rs;
  assign rfif.rsel2 = rt;
  assign rfif.WEN = (ctif.RegWr && (dpif.ihit || dpif.dhit));
  //assign rfif.WEN = ctif.RegWr && (dpif.ihit || dpif.dhit);

  //ALU Interactions
  assign alif.port_a = rfif.rdat1;
  assign alif.port_b = ctif.ALUSrc ? imm32 : rfif.rdat2;
  assign alif.op = ctif.ALUCtrl;

  //Control to Request
  assign rqif.ihit = dpif.ihit;
  assign rqif.dhit = dpif.dhit;
  assign rqif.MemRead = ctif.MemRead;
  assign rqif.MemWrite = ctif.MemWrite;


  always_comb begin : RGFILE
    rfif.wdat = 0;
    if(ctif.Link)
    begin
      rfif.wsel = 31;
    end
    else if(ctif.RegDst)
    begin
      rfif.wsel = rd;
    end
    else
    begin
      rfif.wsel = rt;
    end
    if(ctif.RegWr)
    begin
      if(ctif.LUI)
      begin
        rfif.wdat = {imm16, 16'b0};
      end
      else if(ctif.Link)
      begin
        rfif.wdat = PC + 4;
      end
      else if(ctif.MemtoReg)
      begin
        rfif.wdat = dpif.dmemload;
      end
      else
      begin
        rfif.wdat = dpif.dmemaddr; //equivalent to ALU output
      end
    end
  end

  //PC Updating




  

endmodule
