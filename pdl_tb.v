`timescale 1ns / 1ps

module tb_pdl;

 // Inputs
 reg clk;
 reg [31:0] wb;
 reg [31:0] dl;
 reg reset;
 reg trigger;
 // Outputs
 wire delay_out;

 pdl uut (
  .wb(wb),
  .dl(dl),
  .clk(clk), 
  .reset(reset),
  .trigger(trigger),
  .delay_out(delay_out)
 );

 // Create 100Mhz clock
 initial begin
 clk = 0;
 forever #5 clk = ~clk;
 end 

 initial begin
  $dumpfile("sim_out.vcd");
  $dumpvars;
  $monitor("OUT=%b, wb=%d, dl=%d",delay_out, wb, dl);

  wb = 1;
  dl = 1;

  #100; 
    reset  = 1; 
  #100;
    reset = 0;
  #100; 
    trigger = 0;
  #100;
    trigger = 1;
  #50;
    wb = 2;
    dl = 2;
  #100; 
    trigger = 0;
  #100;
    trigger = 0;
  #100;
    trigger = 1; 
  #100;
    trigger = 0;
  #100; 
    trigger = 1;
  #100;
    trigger = 0;
  #100;
    trigger = 1;
  #100;
    trigger = 0;
  #100 $finish;
 end
endmodule

