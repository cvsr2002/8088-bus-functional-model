package my_pkg;

parameter DATA_WIDTH=8;
parameter ADDR_WIDTH = 20;
parameter DEPTH = 1<< ADDR_WIDTH;
parameter IO_PORT1_START = 16'hFF00;
parameter IO_PORT1_END   = 16'hFF0F;
parameter IO_PORT2_START = 16'h1C00;
parameter IO_PORT2_END   = 16'h1DFF;

endpackage
