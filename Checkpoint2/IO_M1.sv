import my_pkg::*;

module IO_M1 #(parameter ADDR_WIDTH,IO_SELECT)(CLK, RESET, CS1, ALE, IOM, WR, RD, Address, data_in, data_out);


logic [7:0] io_mem1 [0:DEPTH-1];


input logic CLK;
input logic RESET;
input logic ALE;
input logic CS1;
input logic IOM;
input logic WR;
input logic RD;
input logic [ADDR_WIDTH-1:0] Address;
input logic [DATA_WIDTH-1:0] data_in;
output logic [DATA_WIDTH-1:0] data_out;

logic OE,WE;
logic LOAD;
logic [7:0] temp;

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
				if(ALE && IOM == IO_SELECT && CS1)
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
        	io_mem1[Address] <= data_in;	
end

assign data_out = OE ? io_mem1[Address] : 'z;

initial 
begin
	$readmemh("IO.txt",io_mem1, 16'hFF00, 16'hFF0F);
end

endmodule
