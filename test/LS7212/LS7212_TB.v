`timescale 1ns / 1ps  
//fpga4student.com: FPga projects, Verilog projects, VHDL projects
// Testbench Verilog code for delay timer
 module tb_ls7212;  
      // Inputs  
      reg [7:0] wb;  
      reg clk;  
      reg reset;  
      reg trigger;  
      reg mode_a;  
      reg mode_b;  
      // Outputs  
      wire delay_out_n;  
      //fpga4student.com: FPga projects, Verilog projects, VHDL projects
      // Instantiate the Unit Under Test (UUT)  
      delay_timer_ls7212 uut (  
           .wb(wb),   
           .clk(clk),   
           .reset(reset),   
           .trigger(trigger),   
           .mode_a(mode_a),   
           .mode_b(mode_b),   
           .delay_out_n(delay_out_n)  
      );  
      initial begin  
           // Initialize Inputs  
           $dumpfile("sim_out.vcd");
           $dumpvars;
           $monitor("trigger=%b", trigger);
           wb = 10;  
           mode_a = 0;  
           mode_b = 0;  
           reset = 0;  
           trigger = 0;  
           #500;  
           trigger = 1;  
           #15000;  
           trigger = 0;  
           #15000;  
           trigger = 1;  
           #2000;  
           trigger = 0;  
           #2000;  
           trigger = 1;       
           #2000;  
           trigger = 0;       
           #20000;  
           trigger = 1;            
           #30000;  
           trigger = 0;  
           #2000;  
           trigger = 1;  
           #2000;  
           trigger = 0;       
           #4000;  
           trigger = 1;       
           #10000;  
           reset = 1;  
           #10000;  
           reset = 0;  
           // Delay Operate  
           // Add stimulus here  
           #2000 $finish;
      end  
   initial begin   
   clk = 0;  
   forever #500 clk = ~clk;  
      end  
 endmodule  

