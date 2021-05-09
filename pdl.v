module pdl  
#(
          parameter N = 32,
          parameter OUT_NUM = 8 
)   
(   
 
      input [N-1:0] wb, // pulse width, unit 10ns
      input [N-1:0] dl, // delay , unit 10ns
      input clk, // clock input 100Mhz, jitter is 10ns
      input reset, // timer reset  
      input trigger, // trigger input
      input enable,  // active high
      output reg delay_out // delay output
);

 reg [N-1:0] PULSE_WIDTH ;  
 reg [N-1:0] DELAY;  
 reg [N-1:0] TIMER=0;  

 reg mode;

 reg trigger_sync_1=0,trigger_sync_2=0;  
 wire trigger_rising,trigger_falling;  
 
 reg timer_start=0,out_low=0;  
 wire timer_clear2,timer_clear3,timer_clear;  
 
 reg reset_timer1=0,reset_timer2=0,reset_timer=0;  
 wire reset_timer3,reset_det;  
 
 reg reset_det1=0,reset_det2=0; 

always @(posedge clk)  
 begin  
           trigger_sync_1 <= trigger;           // the first Flip-Flop  
           trigger_sync_2 <= trigger_sync_1;    // the second Flip-Flop  

           reset_timer1 <= reset_timer;  
           reset_timer2 <= reset_timer1;  

           reset_det1 <= reset;  
           reset_det2 <= reset_det1;

 end 

 // Identify the zero to one transitions on trigger signal  
 assign trigger_rising = trigger_sync_1 & (~trigger_sync_2);   
 assign trigger_falling = trigger_sync_2 & (~trigger_sync_1);   
 assign reset_timer3 = reset_timer1 & (~reset_timer2);  
 assign reset_det = reset_det2 & (~reset_det1);  

 // sample wb and dl 
 always @(trigger_rising,trigger_falling, wb, dl, enable)  
 begin  
      if(trigger_falling == 1 || trigger_rising == 1) begin  
           PULSE_WIDTH = wb;  
           DELAY = dl;  
           mode = enable;  
      end  
 end   

 always @(posedge clk or posedge timer_clear)  
 begin  
 if(timer_clear)   
      TIMER <= 0;  
 else if(timer_start)  
      TIMER <= TIMER + 1;  
 end  
 assign timer_clear = reset_timer3 | trigger_rising == 1 | timer_clear3 ;  
 assign timer_clear2 = (trigger_rising == 1)|(trigger_falling == 1);  
 assign timer_clear3 = timer_clear2; //& (mode == 2'b11);  

 //delay output  
 always @(posedge clk)  
 begin  
      if(out_low == 1)  
           delay_out <= 0;  
      else  
           delay_out <= 1;  
 end 

 always @(mode,reset,trigger_falling,trigger_rising,TIMER,reset,trigger,PULSE_WIDTH,DELAY,reset_det)  
 begin
     if(reset) begin  
         out_low <= 0;  
         timer_start <= 0;  
         reset_timer <= 1;  
    end  
    else if(reset_det==1 && trigger==1) begin  
         timer_start <= 1;  
         reset_timer <= 0;  
    end  
    else if(trigger_rising==1) begin  
         timer_start <= 1;  
         reset_timer <= 0;  
         end  
    else if(trigger_falling==1 || trigger == 0) begin  
         out_low <= 0;  
         reset_timer <= 1;  
         timer_start <= 0;  
    end  
    else if(TIMER >= DELAY) begin  
         out_low <= 1;  
         timer_start <= 0;  
         reset_timer <= 1;  
    end  
 end  


 endmodule  
