import my_pkg::*;

module Mem_M1 #(parameter ADDR_WIDTH, IO_SELECT)(CLK, RESET, CS3, ALE, IOM, WR, RD, Address, data_in, data_out);

logic [7:0] mem1 [0:DEPTH-1];


input logic CLK;
input logic RESET;
input logic CS3;
input logic ALE;
input logic IOM;
input logic WR;
input logic RD;
input logic [ADDR_WIDTH-1:0] Address;
input logic [DATA_WIDTH-1:0] data_in;
output logic [DATA_WIDTH-1:0] data_out;

logic OE,WE;
logic LOAD;

typedef enum logic [4:0] {
	INIT = 5'b00001,
	START = 5'b00010, 
	READ = 5'b00100, 
	WRITE = 5'b01000, 
	TRI_STATE = 5'b10000
} State_t;
State_t	State,NextState;



always_ff@(posedge CLK)
begin
	if(RESET)
		State<=INIT;
	else
		State<=NextState;
end

always_comb
begin
	NextState = State;
	unique case(State)
		INIT:
			begin
				if(ALE && IOM == IO_SELECT && CS3)
					NextState = START;
				else
					NextState = INIT;
			end
		START:
			begin
				if(!RD)
					NextState = READ;
				else if(!WR)
					NextState = WRITE;
			end
		READ: NextState = TRI_STATE;

		WRITE: NextState = TRI_STATE;

		TRI_STATE: NextState = INIT;
	endcase
end

always_comb
begin
	{OE,WE,LOAD} = 3'b000;
	unique case(State)
		INIT:	
			begin
			end
		START:	LOAD = 1;

		READ:	OE = 1;

		WRITE:	WE = 1;

		TRI_STATE:	OE = 'z;
	endcase
end


always_ff @(posedge CLK)
begin
	if (WE)
        	mem1[Address] <= data_in;	
end

assign data_out = OE ? mem1[Address] : 'z;


initial 
begin
	$readmemh("MEM.txt",mem1);
end

endmodule
