import my_pkg::*;

module MEM_IO #(parameter ADDR_WIDTH, IO_SELECT)(CLK, RESET, CS1, CS2, CS3, CS4, ALE, IOM, WR, RD, Address, data_in, data_out);

logic [7:0] io_mem1 [0:DEPTH-1];
logic [7:0] io_mem2 [0:DEPTH-1];
logic [7:0] mem1    [0:DEPTH-1];
logic [7:0] mem2    [0:DEPTH-1];



input logic CLK;
input logic RESET;
input logic ALE;
input logic CS1, CS2, CS3, CS4;
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
				if(ALE && IOM == IO_SELECT && (CS1 || CS2 || CS3 || CS4))
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
	if (WE && CS1)
        	io_mem1[Address] <= data_in;
	if (WE && CS2)
        	io_mem2[Address] <= data_in;
	if (WE && CS3)
        	mem1[Address] <= data_in;
	if (WE && CS4)
        	mem2[Address] <= data_in;	
end

always_comb
begin
	if (OE && CS1)
        	data_out = io_mem1[Address];
	if (OE && CS2)
        	data_out = io_mem2[Address];
	if (OE && CS3)
        	data_out = mem1[Address];
	if (OE && CS4)
        	data_out = mem2[Address];	
end



//assign data_out = OE ? io_mem1[Address] : 'z;

initial 
begin
	$readmemh("IO.txt",io_mem1, 16'hFF00, 16'hFF0F);
	$readmemh("IO.txt",io_mem2, 16'h1C00, 16'h1DFF);
	$readmemh("MEM.txt",mem1);
	$readmemh("MEM.txt",mem2);

end

endmodule
