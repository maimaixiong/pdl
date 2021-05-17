/*
* https://web.eecs.umich.edu/~prabal/teaching/eecs373-f10/labs/lab5/index.html
*/

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
      output reg delay_out // delay output
);

 reg [2:0] fsm_clk;

 reg [N-1:0] DL ;  
 reg [N-1:0] TH;  
 reg [N-1:0] counter=0;  

 reg trigger_sync_1=0,trigger_sync_2=0;  
 reg timer_delay_enable = 0, timer_width_enable;
 wire trigger_rising,trigger_falling;  
 
 reg reset_det1=0,reset_det2=0; 
 reg TimerEn = 0;
 reg LoadEnReg = 0;

always @(posedge clk)  
 begin  
           trigger_sync_1 <= trigger;           // the first Flip-Flop  
           trigger_sync_2 <= trigger_sync_1;    // the second Flip-Flop  

           reset_det1 <= reset;  
           reset_det2 <= reset_det1;

 end 

 // Identify the zero to one transitions on trigger signal  
 assign trigger_rising = trigger_sync_1 & (~trigger_sync_2);   
 assign trigger_falling = trigger_sync_2 & (~trigger_sync_1);   

always @(posedge clk or negedge reset)

if ( ~reset ) begin  
    counter <= 32'h00000000;
 end
else
 begin
     begin
         if(LoadEnReg == 1'b1)
         begin
             counter <= 32'h00000000;
         end
     else if (TimerEn == 1'b1)
     begin
         counter <= counter + 1;
     end
 end
end

always @( posedge clk)
 begin
     case(fsm_clk)
         2'b00: delay_out = 0; 
         2'b01: delay_out = 0;
         2'b11: delay_out = 1;
    endcase
 end

 
 always@(posedge clk or negedge reset)
 if (~ reset)
 begin
     fsm_clk <= 2'b00;
     TH <= 32'h00000000;
     DL <= 32'h00000000;
     LoadEnReg <= 1'b1;
     TimerEn <= 1'b0;
 end
 else
 begin
     case (fsm_clk)
         2'b00: begin
             if ( trigger_rising == 1 ) 
             begin
                LoadEnReg <= 1'b1;
                TimerEn <= 1'b0;
                DL = dl;
                fsm_clk <= 2'b01;
            end
         end

         2'b01: begin
             LoadEnReg <= 1'b0;
             TimerEn <= 1'b1;

             if ( counter == DL )
             begin
                TH = dl + wb;
                fsm_clk <= 2'b11;
            end
         end

         2'b11: begin
             if ( counter == TH )
             begin
                 fsm_clk <= 2'b00;
             end
         end
    endcase
end

endmodule  
