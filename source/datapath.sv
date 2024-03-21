`include "datapath_cache_if.vh"
`include "register_file_if.vh"
`include "request_unit_if.vh"
`include "control_unit_if.vh"
`include "ALU_if.vh"
`include "hazard_unit_if.vh"
`include "forward_unit_if.vh"

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
  hazard_unit_if huif();
  hazard_unit HU(huif);
  forward_unit_if fuif();
  forward_unit FU(fuif);

  // pc init
  parameter PC_INIT = 0;
  logic [31:0] PC;
  logic [31:0] nPC;
  logic prog;
  logic flush;

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

  logic [31:0] nstore, naddr;

  //Temporary read and write enable signals
  logic rqimemREN, rqdmemWEN, rqdmemREN, ndmemREN, ndmemWEN;
  logic [31:0] dmemFF, daddrFF, dstoreFF;
  logic delay_stall;

  assign flush = 0;

  IF_ID stage1, nstage1;
  ID_EX stage2, nstage2;
  EX_MEM stage3, nstage3;
  MEM_WB stage4, nstage4;


  //Hazard Unit inputs
  assign huif.jump = ctif.Jump;
  assign huif.jr = stage2.JR;
  assign huif.branch = (stage3.Beq && stage3.zero) || (stage3.Bne && !stage3.zero);
  assign huif.stage1_rs = rs;
  assign huif.stage1_rt = rt;
  assign huif.stage2_rt = stage2.rt;
  assign huif.stage2_MemRead = stage2.MemRead;
  assign huif.stage3_MemRead = dpif.dmemREN;
  assign huif.stage3_MemWrite = dpif.dmemWEN;
  assign huif.ihit = dpif.ihit;


  //Forward Unit inputs
  assign fuif.stage2_rs = stage2.rs;
  assign fuif.stage2_rt = stage2.rt;
  assign fuif.stage3_rd = stage3.dest;
  assign fuif.stage4_rd = stage4.dest;
  assign fuif.stage3_RegWr = stage3.RegWr;
  assign fuif.stage4_RegWr = stage4.RegWr;
  assign fuif.stage2_MemWr = stage2.MemWrite;

  always_ff @(posedge CLK, negedge nRST) begin
    if(!nRST)
    begin
      delay_stall <= 0;
    end
    else
    begin
      delay_stall <= huif.stall;
    end
  end

  assign prog = (dpif.ihit && (huif.stall ? dpif.dhit : 1) && ((dpif.dmemWEN || dpif.dmemREN) ? dpif.dhit : 1));

  always_ff @(posedge CLK, negedge nRST) begin : PIPES
    if(!nRST)
    begin
        stage1 <= 0;
        stage2 <= 0;
        stage3 <= 0;
        stage4 <= 0;
    end
    else if(prog)
    begin
        stage1 <= nstage1;
        stage2 <= nstage2;
        stage3 <= nstage3;
        stage4 <= nstage4;
    end
  end

  always_comb begin : STG1
    nstage1 = stage1;
    // if(flush || (dpif.dhit && ~dpif.ihit))
    if(huif.flush1)
    begin
        nstage1 = 0;
    end
    else if(!huif.stall && !huif.stall_all)
    begin
        nstage1.PC_plus_four = PC + 4;
        nstage1.instruction = dpif.imemload;
    end
  end

  always_comb begin : STG2
    nstage2 = stage2;
    //nstage2.dest = stage2.dest;
    if((huif.flush2 || huif.stall))
    begin
        nstage2 = 0;
    end
    else if(!huif.stall_all)
    begin
        nstage2.PC_plus_four = stage1.PC_plus_four;
        nstage2.rdat1 = rfif.rdat1;
        nstage2.rdat2 = rfif.rdat2;
        nstage2.immExtension = ctif.ExtOp ? {{16{imm16[15]}}, imm16} : {{16{1'b0}}, imm16};
        nstage2.LUIdat = {imm16, 16'b0};
        nstage2.rs = rs;
        nstage2.rt = rt;
        // nstage2.rd = rd;
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
        nstage2.halt = ctif.halt;
    end
  end

  always_comb begin : STG3
    nstage3 = stage3;
    if(huif.flush3)
    begin
        nstage3 = 0;
    end
    else if(!huif.stall_all)
    begin
        nstage3.PC_plus_four = stage2.PC_plus_four;
        nstage3.rdat1 = stage2.rdat1;
        //rdat2 hazard only occurs when storing after modifying register in prev inst. Only need to worry about rt because thats the memload
        if(fuif.forwardB == 2)
        begin
          if(stage3.LUI)
          begin
            nstage3.rdat2 = stage3.LUIdat;
          end
          else if(stage3.Link)
          begin
            nstage3.rdat2 = stage3.PC_plus_four;
          end
          else
          begin
            nstage3.rdat2 = stage3.ALU_output;
          end
        end
        else if(fuif.forwardB == 1)
        begin
          if(stage4.LUI)
          begin
            nstage3.rdat2 = stage4.LUIdat;
          end
          else if(stage4.Link)
          begin
            nstage3.rdat2 = stage4.PC_plus_four;
          end
          else if(stage4.MemRead) //will only happen between stage2 and 4 for storing right after lw
          begin
            nstage3.rdat2 = stage4.dmemload;
          end
          else
          begin
            nstage3.rdat2 = stage4.ALU_output;
          end
        end 
        else
        begin
          nstage3.rdat2 = stage2.rdat2;
        end
        //nstage3.rdat2 = (fuif.forwardA != 0 || fuif.forwardB != 0) ? (stage3.ALU_output) : stage2.rdat2;
        nstage3.LUIdat = stage2.LUIdat;
        nstage3.dest = stage2.dest;
        nstage3.branchPC = {stage2.PC_plus_four + {stage2.immExtension[29:0], 2'b0}};
        nstage3.zero = alif.zero;
        nstage3.ALU_output = alif.ALU_output;
        // nstage3.rs = stage2.rs;
        nstage3.rt = stage2.rt;
        // nstage3.rd = stage2.rd;

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
        nstage3.halt = stage2.halt;

        //maybe halt stage 3 hecking flushes from hazard

        //dpif.dmemREN = stage2.MemRead;
        //dpif.dmemWEN = stage2.MemWrite;
    end
  end

always_comb begin : STG4
    nstage4 = stage4;
    if(flush)
    begin
        nstage4 = 0;
    end
    else if(!huif.stall_all)
    begin
        //nstage4.dmemload = dpif.dmemload; //CHANGE BACK
        nstage4.dmemload = (stage3.MemRead && dpif.dmemREN) ? dpif.dmemload : dmemFF;
        nstage4.LUIdat = stage3.LUIdat;
        nstage4.dest = stage3.dest;
        nstage4.PC_plus_four = stage3.PC_plus_four;
        nstage4.ALU_output = stage3.ALU_output;
        // nstage4.rs = stage3.rs;
        // nstage4.rt = stage3.rt;
        // nstage4.rd = stage3.rd;
        // nstage4.rdat2 = stage3.rdat2;

        //Control Signals
        nstage4.MemRead = stage3.MemRead;
        nstage4.MemtoReg = stage3.MemtoReg;
        nstage4.Link = stage3.Link;
        nstage4.LUI = stage3.LUI;
        nstage4.RegWr = stage3.RegWr;
        // nstage4.halt = stage3.halt;
    end
end
//one between execute and memory advance on ihit and dhit

always_ff @(posedge CLK, negedge nRST) begin : MEMLD
    if(!nRST)
    begin
        dmemFF <= 0;
    end
    else if(dpif.dhit)
    begin
        dmemFF <= dpif.dmemload;
    end
end

always_ff @(posedge CLK, negedge nRST) begin : RQFF
    if(!nRST)
    begin
        dpif.dmemREN <= 0;
        dpif.dmemWEN <= 0;
    end
    else if(dpif.dhit || (stage3.Beq && stage3.zero) || (stage3.Bne && !stage3.zero))
    begin
        dpif.dmemREN <= 0;
        dpif.dmemWEN <= 0;
    end
    else if(dpif.ihit)
    begin
      // dpif.dmemREN <= dpif.halt ? 0 : (huif.set2 ? 0 : stage2.MemRead);
      // dpif.dmemWEN <= dpif.halt ? 0 : (huif.set2 ? 0 : stage2.MemWrite);
        dpif.dmemREN <= dpif.halt ? 0 : (stage2.MemRead | dpif.dmemREN); //want to keep latched until we see dhit
        dpif.dmemWEN <= dpif.halt ? 0 : (stage2.MemWrite | dpif.dmemWEN);
    end
end
assign dpif.imemREN = dpif.halt ? 0 : 1;

//Instruction Decoding  assign prog = (dpif.ihit || dpif.dhit);
assign ctif.opcode = opcode_t'(stage1.instruction[31:26]);
assign ctif.func = funct_t'(stage1.instruction[5:0]);
assign rs = stage1.instruction[25:21];
assign rt = stage1.instruction[20:16];
assign rd = stage1.instruction[15:11];
assign imm16 = stage1.instruction[15:0];

//Register File Interactions
assign rfif.rsel1 = rs;
assign rfif.rsel2 = rt;
assign rfif.WEN = (stage4.RegWr);

//ALU interactions
always_comb begin : ALUINTS
  if(fuif.forwardA == 2'b10)
  begin
    if(stage3.LUI)
    begin
      alif.port_a = stage3.LUIdat;
    end
    else if(stage3.Link)
    begin
      alif.port_a = stage3.PC_plus_four;
    end
    else
    begin
      alif.port_a = stage3.ALU_output;
    end
  end
  else if(fuif.forwardA == 2'b01)
  begin
    if(stage4.LUI)
    begin
      alif.port_a = stage4.LUIdat;
    end
    else if(stage4.Link)
    begin
      alif.port_a = stage4.PC_plus_four;
    end
    else if(stage4.MemtoReg)
    begin
      alif.port_a = stage4.dmemload;
    end
    else
    begin
      alif.port_a = stage4.ALU_output;
    end
    //alif.port_a = stage4.LUI ? stage4.LUIdat : (stage4.Link ? stage4.PC_plus_four : (stage4.MemtoReg ? stage4.dmemload : stage4.ALU_output));
    
    //stage4.MemtoReg ? stage4.dmemload : stage4.ALU_output;
  end
  else
  begin
    alif.port_a = stage2.rdat1;
  end
  if(stage2.ALUSrc)
  begin
    alif.port_b = stage2.immExtension;
  end
  else if(fuif.forwardB == 2'b10)
  begin
    //alif.port_b = stage2.ALUSrc ? stage2.immExtension : (stage4.MemtoReg ? stage4.dmemload : stage4.ALU_output);
    if(stage3.LUI)
    begin
      alif.port_b = stage3.LUIdat;
    end
    else if(stage3.Link)
    begin
      alif.port_b = stage3.PC_plus_four;
    end
    else
    begin
      alif.port_b = stage3.ALU_output;
    //alif.port_b = stage2.ALUSrc ? stage2.immExtension : stage3.ALU_output;
    end
  end
  else if(fuif.forwardB == 2'b01)
  begin
    if(stage4.LUI)
    begin
      alif.port_b = stage4.LUIdat;
    end
    else if(stage4.Link)
    begin
      alif.port_b = stage4.PC_plus_four;
    end
    else if(stage4.MemtoReg)
    begin
      alif.port_b = stage4.dmemload;
    end
    else
    begin
      alif.port_b = stage4.ALU_output;
    end
  end
  else
  begin
    alif.port_b = stage2.rdat2;
  end
end
// assign alif.port_a = stage2.rdat1;
// assign alif.port_b = stage2.ALUSrc ? stage2.immExtension : stage2.rdat2;
assign alif.op = aluop_t'(stage2.ALUCtrl);

//outputs to ram
assign dpif.dmemaddr = (huif.stall) ? alif.ALU_output : stage3.ALU_output;
// always_comb begin
//   dpif.dmemaddr = stage3.ALU_output;
//   if (huif.stall)
//   begin
//     dpif.dmemaddr = alif.ALU_output;
//   end
//   else if (stage3.MemRead && dpif.dmemREN)
//   begin
//     dpif.dmemaddr = stage3.rt;
//   end
// end
// assign dpif.dmemstore = (fuif.forwardB == 2'b01) ? stage4.rdat2 : stage3.rdat2;
// assign dpif.dmemstore = (fuif.forwardA != 0 || fuif.forwardB != 0) ? (stage3.ALU_output) : stage3.rdat2;
assign dpif.dmemstore = stage3.rdat2;


// always_ff @(posedge CLK, negedge nRST) begin
//     if(!nRST)
//     begin
//         dpif.dmemaddr <= 0;
//         dpif.dmemstore <= 0;
//     end

//     else if(!prog)
//     begin
//         dpif.dmemaddr <= stage3.ALU_output;
//         dpif.dmemstore <= stage3.rdat2;
//     end

//     else if((huif.stall || stage2.MemRead || stage2.MemWrite) && !(stage3.halt))
//     begin
//         dpif.dmemaddr <= alif.ALU_output;
//         dpif.dmemstore <= stage2.rdat2;
//     end

//     else if(prog && !(stage2.MemRead || stage2.MemWrite))
//     begin
//         dpif.dmemaddr <= stage3.ALU_output;
//         dpif.dmemstore <= stage3.rdat2;
//     end
// end

// next state logic for dmemaddr and dmemstore
// always_ff @(posedge CLK, negedge nRST) begin
//     if(!nRST)
//     begin
//         dpif.dmemaddr <= 0;
//         dpif.dmemstore <= 0;
//     end
//     else
//     begin
//         dpif.dmemaddr <= daddrFF;
//         dpif.dmemstore <= dstoreFF;
//     end

// end

// always_comb begin
//     daddrFF = dpif.dmemaddr;
//     dstoreFF = dpif.dmemstore;
//     if (prog && (stage2.MemRead || stage2.MemWrite))
//     begin
//         daddrFF = stage3.ALU_output;
//         dstoreFF = stage3.rdat2;
//     end
//     else if((huif.stall || stage2.MemRead || stage2.MemWrite) && !(stage3.halt))
//     begin
//         daddrFF = alif.ALU_output;
//         dstoreFF = stage2.rdat2;
//     end
// end



// instruction address

assign dpif.imemaddr = PC;  

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
    else if(dpif.ihit && !huif.stall && !huif.stall_all)
    begin
        PC <= nPC; //stage4.PC_result
        dpif.halt <= (dpif.halt | stage3.halt);
    end
    else
    begin
        dpif.halt <= (dpif.halt | stage3.halt);
    end
end

always_comb begin : PCUPDT
    nPC = PC;
    if(dpif.ihit && !huif.stall && !huif.stall_all)
    begin
        if((stage3.Beq && stage3.zero) || (stage3.Bne && !stage3.zero))
        begin
            nPC = stage3.branchPC;
        end
        else if(ctif.Jump)
        begin
            nPC = {stage1.PC_plus_four[31:28], stage1.instruction[25:0], 2'b0};
        end
        else if(stage2.JR) //Add stuff for this in forwarding unit
        begin
          if(fuif.forwardA == 2)
          begin
            nPC = stage3.ALU_output;
          end
          else if(fuif.forwardA == 1)
          begin
            nPC = stage4.ALU_output;
          end
          else
          begin
            nPC = stage2.rdat1;
          end
        end
        else
        begin
            nPC = PC + 4;
        end
    end
end
endmodule