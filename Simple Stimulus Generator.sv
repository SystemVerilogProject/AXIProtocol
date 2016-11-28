`include "AXI_package.sv"
import AXI_package::*;

module axi_tb();
logic	ACLK;
logic	RESETn;
logic	wr, rd;


parameter TRUE   = 1'b1;
parameter FALSE  = 1'b0;
parameter ACLK_CYCLE  = 20;
parameter ACLK_WIDTH  = ACLK_CYCLE/2;
parameter IDLE_ACLKS  = 2;


	WriteChannelInputs	WCI;
	WriteChannelOutputs	WCO;
	WriteChannelOutputs	WCO_T;
	ReadChannelInputs	RCI;
	ReadChannelOutputs	RCO;
	ReadChannelOutputs	RCO_T;
/*

typedef struct {

logic	[3:0]	AWID;
logic	[31:0]	AWADDR;
logic	[3:0]	AWLEN;
logic	[2:0]	AWSIZE;
logic	[1:0]	AWBURST;
logic	[1:0]	AWLOCK;
logic	[3:0]	AWCACHE;
logic	[2:0]	AWPROT;
logic		AWVALID;
logic	[3:0]	WID;
logic	[`DATA_BUS_WIDTH-1:0]	WDATA;
logic	[3:0]	WSTRB;
logic		WLAST;
logic		WVALID;
logic		BREADY;

} WriteChannelOutputs;

*/

	
//
// Create free running ACLK
//

initial
begin
ACLK = FALSE;
forever #ACLK_WIDTH ACLK = ~ACLK;
#2000  $finish ;
end

//
// Generate RESETn signal for two cycles
//

initial
begin
//wr=1;
//rd=0;

RESETn = FALSE;
repeat (IDLE_ACLKS) @(negedge ACLK);
RESETn = TRUE;

end

initial
begin
wr=1;
rd=0;

WCO_T = '{4'b0101,32'h1234,4'b1100,3'b010,2'b01,2'b01,4'h5,3'b001,1'b0,4'h4,32'h5123,4'h2,1'b0,1'b0,1'b0};
wait (WCO.WLAST == 1);
@(negedge ACLK);
WCO_T = '{4'b0111,32'h3456,4'b0010,3'b010,2'b01,2'b01,4'h5,3'b001,1'b0,4'h4,32'h8794,4'h2,1'b0,1'b0,1'b0};
repeat (4) @(negedge ACLK);
wait (WCO.WLAST == 1);
@(negedge ACLK);

/*
typedef struct {

logic	[3:0]	ARID;
logic	[31:0]	ARADDR;
logic	[3:0]	ARLEN;
logic	[2:0]	ARSIZE;
logic	[1:0]	ARBURST;
logic	[1:0]	ARLOCK;
logic	[3:0]	ARCACHE;
logic	[2:0]	ARPROT;
logic		ARVALID;
logic		RREADY;

} ReadChannelOutputs;
*/
rd=1;
wr=0;
	  
WCO_T='{4'b1111,32'h4598,4'b0011,3'b010,2'b01,2'b01,4'h5,3'b001,1'b0,4'h4,32'h8794,4'h2,1'b0,1'b0,1'b0};
//'{4'b1111,32'h4598,4'b0011,3'b010,2'b01,2'b01,4'h5,3'b001,1'b0,1'b1};	

wait (RCI.RLAST == 1);

@(negedge ACLK);
WCO_T='{4'b1000,32'h1212,4'b1111,3'b010,2'b01,2'b01,4'h5,3'b001,1'b0,4'h4,32'h1111,4'h2,1'b0,1'b0,1'b0};

//wait (WCO.WLAST == 1);
repeat (4) @(negedge ACLK);
wait (RCI.RLAST == 1);
@(negedge ACLK);
wr=1;
WCO_T='{4'b1010,32'h1110,4'b0101,3'b010,2'b01,2'b01,4'h5,3'b001,1'b0,4'h4,32'h101001,4'h2,1'b0,1'b0,1'b0};

end

AXI_MASTER a1 (.*);

AXI_SLAVE s1 (.*);

endmodule


