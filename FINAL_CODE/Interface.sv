/********************************************************************************************
Filename:	Interface.sv   

Description:	Interface for Intel8088 

Version:	1.0

*********************************************************************************************/



interface Intel8088Pins(input bit CLK,RESET);

logic MNMX;
logic TEST;

logic READY;
logic NMI;
logic INTR;
logic HOLD;

logic HLDA;
tri [7:0] AD;
tri [19:8] A;

logic IOM ;
logic WR;
logic RD;
logic SSO;
logic INTA;
logic ALE;
logic DTR;
logic DEN;

// declartion of modports for processor
modport Processor (input  READY, MNMX, TEST, NMI, INTR, HOLD,CLK,RESET, 
		   output ALE, IOM, RD, WR, DTR, DEN, INTA, SSO,HLDA,
		   inout AD, A);

// declartion of modports for peripheral
modport Peripheral (input  CLK,RESET,ALE, WR, RD);

	
endinterface
