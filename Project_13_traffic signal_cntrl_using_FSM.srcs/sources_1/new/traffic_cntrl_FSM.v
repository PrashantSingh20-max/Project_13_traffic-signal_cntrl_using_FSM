`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
/* - This defines a macro called `TRUE`.
- `1'b1` is a **1-bit binary** value with value **1**.
- So wherever you write `` `TRUE ``, the compiler replaces it with `1'b1`*/
`define TRUE 1'b1
`define FALSE 1'b0
`define RED 2'd0
`define YELLOW 2'd1
`define GREEN 2'd2


//state definiation Highway  Country
`define S0 3'd0     //green  red
`define S1 3'd1     //yello  red
`define S2 3'd2     //red    red
`define S3 3'd3     //red    green
`define S4 3'd4     //red    yellow

//delay
`define Y2RDELAY 3 
`define R2GDELAY 3 



module traffic_cntrl_FSM( hwy,cntry,X,clock,clear );
//inpout / output ports
output[1:0] hwy,cntry; //2 bit output for 3 states of signal
// greeen yellow red

reg[1:0] hwy,cntry;
input X; //if true in diactes there is a car on cntry road
// otherwise false
input clear,clock;

//internal state variable
reg[2:0] state;
reg[2:0] next_state;

//signal controller starts in s0 state

initial
begin
 state=`S0;
 next_state=`S0;
 hwy=`GREEN;
 cntry=`RED;
end

//state changes only at positive edge of clock
always @(posedge clock)
  state=next_state;
  
// compute values of main signal and country signal
always @(state)
begin
 case(state)
 `S0:begin
      hwy=`GREEN;
      cntry=`RED;
     end
`S1:begin
     hwy=`YELLOW;
     cntry=`RED;
    end
`S2:begin
     hwy=`RED;
     cntry=`RED;
    end          
`S3:begin
      hwy=`RED;
      cntry=`GREEN;
    end
`S4:begin
      hwy=`RED;
      cntry=`YELLOW;
    end
endcase
end

//state machnine using case staements
always @(state or clear or X)
begin 
 if(clear)
  next_state=`S0;
 else
  case(state)
   `S0:if( X)
        next_state=`S1;
       else
        next_state=`S0;
    `S1:begin //delay some +ve edge of clk
        repeat(`Y2RDELAY) @(posedge clock);
        next_state=`S2;
       end
     
     `S2: begin //delay some +ve edge of clk
            repeat(`R2GDELAY) @(posedge clock);
            next_state=`S3;
         end
     `S3:if(X)
        next_state=`S3;
        else
        next_state=`S4;
        
       `S4:begin // delay some +veedge clock
       repeat(`Y2RDELAY)@(posedge clock);
       next_state=`S0;
end
default: next_state=`S0;
endcase
end
endmodule
