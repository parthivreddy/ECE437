/*
  hazard unit test bench
*/

import cpu_types_pkg::*;

// mapped needs this
`include "hazard_unit_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module hazard_unit_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  hazard_unit_if huif ();
  // test program
  test PROG (CLK, nRST, huif);
  // DUT
`ifndef MAPPED
  hazard_unit DUT(huif);
`else
  hazard_unit DUT(
    .\cuif.reg_dest (cuif.reg_dest),
    .\cuif.reg_write (cuif.reg_write),
    .\cuif.ALUsrc (cuif.ALUsrc),
    .\cuif.mem_read (cuif.mem_read),
    .\cuif.mem_write (cuif.mem_write),
    .\cuif.mem_to_reg (cuif.mem_to_reg),
    .\cuif.jump (cuif.jump),
    .\cuif.jump_r (cuif.jump_r),
    .\cuif.jump_al (cuif.jump_al),
    .\cuif.branch (cuif.branch),
    .\cuif.branch_bne (cuif.branch_bne),
    .\cuif.halt (cuif.halt),
    .\cuif.opcode (cuif.opcode),
    .\cuif.ALUop (cuif.ALUop),
    .\cuif.funct (cuif.funct),
    .\cuif.ext_op (cuif.ext_op),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test (
  input logic CLK,
  output logic nRST,
  hazard_unit_if.tb huif
);
  import cpu_types_pkg::*;

  logic tb_check;
  integer tb_test_case_num;
  string tb_test_case;

  logic expected_flush1;
  logic expected_set2;
  logic expected_stall;
  logic [1:0] expected_npc_sel;


  logic incorrect_flag;
  task check_outputs;
    input string check_tag;
  begin
    incorrect_flag = 0;
    tb_check = 1;

    if(huif.flush1 != expected_flush1) begin
      $display("Incorrect value %d in flush1 during %s operation.", huif.flush1, check_tag);
      incorrect_flag = 1;
    end

    if(huif.set2 != expected_set2) begin
      $display("Incorrect value %d in set2 during %s operation.", huif.set2, check_tag);
      incorrect_flag = 1;
    end

    if(huif.stall != expected_stall) begin
      $display("Incorrect value %d in stall during %s operation.", huif.stall, check_tag);
      incorrect_flag = 1;
    end

    if(huif.npc_sel != expected_npc_sel) begin
      $display("Incorrect value %d in npc_sel during %s operation.", huif.npc_sel, check_tag);
      incorrect_flag = 1;
    end

    #(1);
    tb_check = 0;

    if (incorrect_flag == 0) begin
      $display("All outputs correct during %s operation.", check_tag);
    end

  end
  endtask

// Task for standard DUT reset procedure
task reset_dut;
begin
  // Activate the reset
  nRST = 1'b0;

  // Maintain the reset for more than one cycle
  @(posedge CLK);
  @(posedge CLK);

  // Wait until safely away from rising edge of the clock before releasing
  @(negedge CLK);
  nRST = 1'b1;

  // Leave out of reset for a couple cycles before allowing other stimulus
  // Wait for negative clock edges, 
  // since inputs to DUT should normally be applied away from rising clock edges
  @(negedge CLK);
  @(negedge CLK);
end
endtask

task reset_inputs;
begin
  huif.jump = 0;
  huif.branch = 0;
  huif.stage1_rs = 0;
  huif.stage1_rt = 0;
  huif.stage2_rt = 0;
  huif.stage2_MemRead = 0;
end
endtask

task reset_expected;
begin
  expected_flush1 = 0;
  expected_set2 = 0;
  expected_stall = 0;
  expected_npc_sel = 0;

end
endtask

initial begin
  // Initialize and reset
  tb_test_case = "Initialization and Reset";
  tb_test_case_num = -1;
  reset_inputs();
  reset_expected();
  reset_dut();

  repeat (4) @(posedge CLK);

  // Test 1: Load Hazard
  tb_test_case = "detect load hazard";
  tb_test_case_num += 1;
  
  cuif.opcode = RTYPE;
  cuif.funct = ADD;
  expected_ALUop = ALU_ADD;
  expected_reg_dest = 1;
  expected_reg_write = 1;
  @(posedge CLK);
  check_outputs(tb_test_case);
  #(10);

  // Test 2: Branch Hazard
  tb_test_case = "branch taken";
  tb_test_case_num += 1;
  
  cuif.opcode = RTYPE;
  cuif.funct = ADDU;
  expected_ALUop = ALU_ADD;
  expected_reg_dest = 1;
  expected_reg_write = 1;
  @(posedge CLK);
  check_outputs(tb_test_case);
  #(10);

  // Test 3: Jump Hazard
  tb_test_case = "R-type SLLV";
  tb_test_case_num += 1;
  
  cuif.opcode = RTYPE;
  cuif.funct = SLLV;
  expected_ALUop = ALU_SLL;
  expected_reg_dest = 1;
  expected_reg_write = 1;
  @(posedge CLK);
  check_outputs(tb_test_case);
  #(10);

 

end
endprogram