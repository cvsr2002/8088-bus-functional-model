interface main_bus(input logic CLK, RESET);

logic MNMX;
logic TEST;

logic READY;
logic NMI;
logic INTR;
logic HOLD;

logic HLDA;
tri [7:0] AD;
tri [19:8] A;

logic [7:0] Data;
logic CS;

logic IOM;
logic WR;
logic RD;
logic SSO;
logic INTA;
logic ALE;
logic DTR;
logic DEN;

modport processor (input  READY, MNMX, TEST, NMI, INTR, HOLD, 
		   output ALE, IOM, RD, WR, DTR, DEN, INTA, SSO,
		   inout AD, A);

modport peripheral (input  ALE, WR, RD, CS,
		    inout  Data );

/*clocking processor_cb@(posedge CLK);
	default input #1 output #1;
		input RESET;
		input READY; 
		input MNMX; 
		input TEST; 
		input NMI; 
		input INTR; 
		input HOLD; 
		output ALE;
		output IOM;
		output RD;
		output WR;
		output DTR;
		output DEN;
		output INTA;
		output SSO;
		
endclocking: processor_cb

 	
clocking peripheral_cb@(posedge clock);
	default input #1 output #1;
	input ALE;
	input WR;
	input RD; 
	input CS; 
	inout Data;
	
endclocking: peripheral_cb

	
	
modport processor (clocking processor_cb);
modport peripheral (clocking peripheral_cb);*/
	
endinterface
