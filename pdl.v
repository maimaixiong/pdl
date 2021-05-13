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

/*
* FSM State
*
    * WAIT_TRIG_RISING      OUTPUT=0  WHEN trigger_rising
    * DELAY                 OUTPUT=0  WHEN timer_delay > dl
    * DELAY_OUT             OUTPUT=1  WHEN timer_width > wb
    * WAIT_TRIG_RISING (GO BACK)
    *
*/
parameter 
    FSM_WAIT_TRIG_RISING=3'b000,
    FSM_DELAY=3'b001,
    FSM_DELAY_OUT=3'b011;
    
 reg [2:0] current_state, next_state;

 reg [N-1:0] PULSE_WIDTH ;  
 reg [N-1:0] DELAY;  
 reg [N-1:0] TIMER_DELAY=0;  
 reg [N-1:0] TIMER_WIDTH=0;  

 reg trigger_sync_1=0,trigger_sync_2=0;  
 reg timer_delay_enable = 0, timer_width_enable;
 wire trigger_rising,trigger_falling;  
 
 reg reset_det1=0,reset_det2=0; 

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

 // sample wb and dl 
 always @(trigger_rising,trigger_falling, wb, dl)  
 begin  
      if(trigger_falling == 1 || trigger_rising == 1) begin  
           PULSE_WIDTH = wb;  
           DELAY = dl;  
      end  
 end   
 
 always @(posedge clk, posedge reset)
 begin
     if(reset == 1)
         current_state <= FSM_WAIT_TRIG_RISING;
     else
         current_state <= next_state;
 end


 always @(posedge clk or posedge timer_delay_enable or posedge timer_width_enable)  
 begin  

    if(timer_delay_enable)
    begin
         TIMER_DELAY <= TIMER_DELAY + 1;  
    end

    if(timer_width_enable)
    begin
        TIMER_WIDTH <= TIMER_WIDTH + 1;
    end

 end  

 always @(current_state, trigger_rising, TIMER_WIDTH, TIMER_DELAY)
 begin
     case(current_state)
         FSM_WAIT_TRIG_RISING:
            begin
                TIMER_DELAY = 0;
                TIMER_WIDTH = 0;
                
                if(trigger_rising) 
                begin
                    next_state = FSM_DELAY;
                    timer_width_enable = 0;
                    timer_delay_enable = 1;
                end
            end
         FSM_DELAY: 
            begin
                if(TIMER_DELAY > DELAY) 
                begin
                    next_state = FSM_DELAY_OUT;
                    TIMER_WIDTH = 0;
                    timer_width_enable = 1;
                    timer_delay_enable = 0;
                end
            end
         FSM_DELAY_OUT: 
            begin
                if(TIMER_WIDTH > PULSE_WIDTH)
                begin
                    next_state = FSM_WAIT_TRIG_RISING;
                end
            end
         default:
             next_state = FSM_WAIT_TRIG_RISING;
     endcase
 end


 always @(current_state)
 begin
     case(current_state)
         FSM_WAIT_TRIG_RISING: delay_out = 0; 
         FSM_DELAY:            delay_out = 0;
         FSM_DELAY_OUT:        delay_out = 1;
    endcase
 end

 endmodule  
