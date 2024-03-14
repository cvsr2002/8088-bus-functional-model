import my_pkg::*;

module top;

bit CLK = '0;
bit MNMX = '1;
bit TEST = '1;
bit RESET = '0;
bit READY = '1;
bit NMI = '0;
bit INTR = '0;
bit HOLD = '0;

wire logic [7:0] AD;
logic [19:8] A;
logic HLDA;
logic IOM;
logic WR;
logic RD;
logic SSO;
logic INTA;
logic ALE;
logic DTR;
logic DEN;

logic CS;

logic [19:0] Address;
logic [15:0] io_addr;
logic [7:0] data_out1, data_out2, data_out3, data_out4;
wire [7:0]  Data;

logic CS1,CS2, CS3, CS4;

//main_bus DUV_IF (CLK, RESET);

Intel8088 P(CLK, MNMX, TEST, RESET, READY, NMI, INTR, HOLD, AD, A, HLDA, IOM, WR, RD, SSO, INTA, ALE, DTR, DEN);

//Intel8088 P (DUV_IF.processor);
	    

/*IO_M1  #(16,'b1) IO_INST1   (CLK, RESET, CS1, ALE, IOM, WR, RD, io_addr, Data, data_out1);
IO_M2  #(16,'b1) IO_INST2   (CLK, RESET, CS2, ALE, IOM, WR, RD, io_addr, Data, data_out2);
Mem_M1 #(20,'b0) MEM_INST1  (CLK, RESET, CS3, ALE, IOM, WR, RD, Address, Data, data_out3);
Mem_M2 #(20,'b0) MEM_INST2  (CLK, RESET, CS4, ALE, IOM, WR, RD, Address, Data, data_out4);*/

MEM_IO  #(16,'b1) IO_INST1   (CLK, RESET, CS1, CS2, CS3, CS4, ALE, IOM, WR, RD, Address, Data, data_out1);
MEM_IO  #(16,'b1) IO_INST2   (CLK, RESET, CS1, CS2, CS3, CS4, ALE, IOM, WR, RD, Address, Data, data_out2);
MEM_IO #(20,'b0) MEM_INST1  (CLK, RESET, CS1, CS2, CS3, CS4, ALE, IOM, WR, RD, Address, Data, data_out3);
MEM_IO #(20,'b0) MEM_INST2  (CLK, RESET, CS1, CS2, CS3, CS4, ALE, IOM, WR, RD, Address, Data, data_out4);




// 8282 Latch to latch bus address
always_latch
begin
if (ALE)
	Address <= {A, AD};
end

// 8286 transceiver
assign Data =  (DTR & ~DEN) ? AD   : 'z;
assign AD   = (~DTR & ~DEN) ? Data : 'z;

assign io_addr = Address[15:0];
assign CS = Address[19];

always_comb
begin
	{CS1,CS2,CS3, CS4} = 4'b0000;
	if(IOM)
	begin
		if(Address >= IO_PORT1_START && Address <=  IO_PORT1_END ) 
		begin
			CS1 = 1;
		end
		else if(Address >= IO_PORT2_START  && Address <= IO_PORT2_END) 
		begin
			CS2 = 1; 
		end
        end
        else 
	begin
		 if ( Address[19]) 	
			CS3 = 1;
		else if (!Address[19])
			CS4 = 1; 
	end

end

always #50 CLK = ~CLK;

initial
begin
	$dumpfile("dump.vcd"); $dumpvars;

	repeat (2) @(posedge CLK);
	RESET = '1;
	repeat (5) @(posedge CLK);
	RESET = '0;

	repeat(10000) @(posedge CLK);
	$finish();
end

endmodule
