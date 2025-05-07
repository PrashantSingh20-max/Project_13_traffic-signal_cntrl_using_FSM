`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.05.2025 22:02:18
// Design Name: 
// Module Name: stimulus_Traffic_cntrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module stimulus_Traffic_cntrl;

wire [1:0] main_sig ,cntry_sig;
reg CAR_ON_CNTRY_RD;
   //if true , indicatrs car on cntry road
reg clock,clear;

//instantiate signal controller
traffic_cntrl_FSM SC(main_sig,cntry_sig,CAR_ON_CNTRY_RD,clock,clear);

//setup monitor
initial
 $monitor($time," main sig=%b country Sig=%b Car_on_cntry=%b",main_sig,cntry_sig,CAR_ON_CNTRY_RD);
 
 //set up Clock
 initial
 begin
  clock = `FALSE;
  forever #5 clock=~clock;
  end
  
  //control clear signal
  
  initial
  begin
  clear=`TRUE;
  repeat (5) @ (negedge clock);
  clear=`FALSE;
  end
   //apply stimiulus
   
   initial
   begin
   CAR_ON_CNTRY_RD=`FALSE;
   
   #200 CAR_ON_CNTRY_RD=`TRUE;
   #100 CAR_ON_CNTRY_RD=`FALSE;

   #200 CAR_ON_CNTRY_RD=`TRUE;
   #100 CAR_ON_CNTRY_RD=`FALSE;

   #200 CAR_ON_CNTRY_RD=`TRUE;
   #100 CAR_ON_CNTRY_RD=`FALSE;
   
   #100 $stop;
   end
  
endmodule
