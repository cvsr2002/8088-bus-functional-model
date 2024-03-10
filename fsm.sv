

module IO_MEM(CLK, RESET, ALE, WR, RD, IOM, AD, Address, Data, OE);

parameter ADDR_WIDTH = 10;
parameter DATA_WIDTH = 8;
parameter MEM_DEPTH = 1024;

input logic CLK;
input logic RESET;
input logic ALE;
input logic WR, RD;
//input logic chip_select;
input logic IOM;

input logic [DATA_WIDTH-1:0]AD;
input logic [ADDR_WIDTH-1:0]Address;
output logic [DATA_WIDTH-1:0]Data;
output logic OE;

logic [DATA_WIDTH-1:0]mem[MEM_DEPTH-1:0];
logic [DATA_WIDTH-1:0]io[MEM_DEPTH-1:0];


typedef enum logic [4:0] {
        INIT		= 5'b00001,
	START		= 5'b00010,
	WRITE		= 5'b00100,
	READ		= 5'b01000,	
	TRI_STATE 	= 5'b10000
} State_t;

State_t State, NextState;



always_ff @(posedge CLK)
begin
if (RESET)
	State <= INIT;
else
	State <= NextState;
end

always_comb
begin
NextState = State;
OE = 1'b0;
unique case (State)
	INIT:		begin
				if(ALE)
					NextState = START;
                                
			end
			
	START:		begin
				if(!RD)
					NextState = READ;
                                else if(!WR)
					NextState = WRITE; 				
                        end
			
	WRITE:		begin
				if( !(WR && IOM) ) 
				begin
    					NextState = TRI_STATE;	
                                	mem[Address] = AD;
					OE = 0;
				end 
				if( !WR && IOM) 
				begin
					NextState = TRI_STATE; 
					io[Address]  = AD;
					OE = 0;
				end		
			end
			
	READ:		begin
				if( !(RD && IOM) ) 
				begin
					NextState = TRI_STATE;
                                	Data = mem[Address];
					OE =1; 
				end
				if( !RD && IOM) 
				begin
					NextState = TRI_STATE;
					Data = io[Address];
					OE=1;
				end				
			end

	TRI_STATE : 	begin
				NextState = INIT;
				Data = 'z;
				OE = 'z;
			end	
       
endcase
end
endmodule

