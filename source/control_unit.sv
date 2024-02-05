`include "control_unit_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

//MAYBE IMEMREN HAS TO BE REGISTERED
//ALLEERTTT

module control_unit (
    input logic CLK, nRST,
  control_unit_if.ct ctif
);
  // import types
  import cpu_types_pkg::*;

  always_comb begin : MAINCTRL
    ctif.MemRead = 0;
    ctif.MemWrite = 0;
    ctif.ALUCtrl = aluop_t'(0);
    ctif.RegDst = 0;
    ctif.ExtOp = 0;
    ctif.ALUSrc = 0;
    ctif.RegWr = 0;
    ctif.MemtoReg = 0;
    ctif.Beq = 0;
    ctif.Bne = 0;
    ctif.Jump = 0;
    ctif.Link = 0;
    ctif.LUI = 0;
    ctif.halt = 0;
    ctif.JR = 0;

    casez(ctif.opcode)
    6'b000000: //R type
    begin
        ctif.RegWr = 1;
        ctif.RegDst = 1;
        casez(ctif.func)
        6'b000100:
        begin
            ctif.ALUCtrl = ALU_SLL;
        end
        6'b000110:
        begin
            ctif.ALUCtrl = ALU_SRL;
        end
        6'b001000:
        begin
            ctif.RegWr = 0;
            ctif.JR = 1;
        end
        6'b?0000?:
        begin
            ctif.ALUCtrl = ALU_ADD;
        end
        6'b10001?:
        begin
            ctif.ALUCtrl = ALU_SUB;
        end
        6'b100100:
        begin
            ctif.ALUCtrl = ALU_AND;
        end
        6'b100101:
        begin
            ctif.ALUCtrl = ALU_OR;
        end
        6'b100110:
        begin
            ctif.ALUCtrl = ALU_XOR;
        end
        6'b100111:
        begin
            ctif.ALUCtrl = ALU_NOR;
        end
        6'b101010:
        begin
            ctif.ALUCtrl = ALU_SLT;
        end
        6'b101011:
        begin
            ctif.ALUCtrl = ALU_SLTU;
        end
        endcase
    end
    6'b000010: //J
    begin
        ctif.Jump = 1;
        ctif.ExtOp = 1;
    end
    6'b000011: //JAL
    begin
        ctif.RegWr = 1;
        ctif.Jump = 1;
        ctif.Link = 1;
        ctif.ExtOp = 1;
    end
    6'b000100: //Beq
    begin
        ctif.Beq = 1;
        ctif.ExtOp = 1;
        ctif.ALUCtrl = ALU_SUB;
    end
    6'b000101: //Bne
    begin
        ctif.Bne = 1;
        ctif.ExtOp = 1;
        ctif.ALUCtrl = ALU_SUB;
    end
    6'b00100?: //ADDI and ADDIU
    begin
        ctif.ALUCtrl = ALU_ADD;
        ctif.RegWr = 1;
        ctif.ALUSrc = 1;
        ctif.ExtOp = 1;
    end
    6'b001010: //SLTI
    begin
        ctif.ALUCtrl = ALU_SLT;
        ctif.ExtOp = 1;
        ctif.RegWr = 1;
        ctif.ALUSrc = 1;
    end
    6'b001011: //SLTIU
    begin
        ctif.ALUCtrl = ALU_SLTU; 
        ctif.ExtOp = 1;
        ctif.RegWr = 1;
        ctif.ALUSrc = 1;
    end
    6'b001100: //ANDI
    begin
        ctif.ALUCtrl = ALU_AND;
        ctif.RegWr = 1;
        ctif.ALUSrc = 1;
    end
    6'b001101: //ORI
    begin
        ctif.ALUCtrl = ALU_OR;
        ctif.RegWr = 1;
        ctif.ALUSrc = 1;
    end
    6'b001110: //XORI
    begin
        ctif.ALUCtrl = ALU_XOR;
        ctif.RegWr = 1;
        ctif.ALUSrc = 1;
    end
    6'b001111: //LUI
    begin
        ctif.LUI = 1;
        ctif.RegWr = 1;
    end
    6'b100011: //LW
    begin
        ctif.MemRead = 1;
        ctif.ALUCtrl = ALU_ADD;
        ctif.ExtOp = 1;
        ctif.MemtoReg = 1;
        ctif.ALUSrc = 1;
        ctif.RegWr = 1;
    end
    6'b101011: //SW
    begin
        ctif.MemWrite = 1;
        ctif.ALUCtrl = ALU_ADD;
        ctif.ExtOp = 1;
        ctif.ALUSrc = 1;
    end
    6'b111111: //HALT
    begin
        ctif.halt = 1;
    end
    endcase
  end




endmodule