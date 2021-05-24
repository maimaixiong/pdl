`timescale 1ns / 1ps
// fpga4student.com: FPGA Projects, Verilog projects, VHDL projects 
// Verilog project: Verilog testbench code for PWM Generator with variable duty cycle 
module tb_PWM_Generator_Verilog;
 // Inputs
 reg clk;
 reg en;
 reg reset;
 reg [31:0]arr;
 reg [31:0]ccr;
 // Outputs
 wire PWM_OUT;
 // Instantiate the PWM Generator with variable duty cycle in Verilog

//  module pwm_generator(Clk50M,
//                      Rst_n,
//                      cnt_en,
//                      counter_arr,
//                      counter_ccr,
//                      o_pwm);

 pwm_generator PWM_Generator_Unit(
  .Clk50M(clk), 
  .cnt_en(en),
  .Rst_n(reset),
  .counter_arr(arr), 
  .counter_ccr(ccr), 
  .o_pwm(PWM_OUT)
 );
 // Create 100Mhz clock
 initial begin
 clk = 0;
 forever #5 clk = ~clk;
 end 
 initial begin
  $dumpfile("sim_out.vcd");
  $dumpvars;
  $monitor("PWM_OUT=%b",PWM_OUT);
  arr = 19999;
  ccr = 1;
  #100; 
    reset = 0; 
    en = 1;
  #100;
    reset = 1;
  #100000000 $finish;
 end
endmodule

