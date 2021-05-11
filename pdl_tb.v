`timescale 1ns / 1ps

module tb_pdl;

 // Inputs
 reg clk;
 reg [31:0] wb;
 reg [31:0] dl;
 reg reset;
 reg trigger;
 reg enable;
 // Outputs
 wire delay_out;

 pdl uut (
  .wb(wb),
  .dl(dl),
  .clk(clk), 
  .reset(reset),
  .trigger(trigger),
  .enable(enable),
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
  $monitor("OUT=%b",delay_out);

  wb = 10;
  dl = 10;

  #100; 
    reset  = 1; 
  #100;
    reset = 0;
  #100; 
    enable  = 1;
    trigger = 0;
  #100;
    trigger = 1;
  #50;
    wb = 16;
    dl = 18;
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

