`include "instruction_memory.v"
`include "top_module.v"
module top_tb ();

localparam t = 25;

reg clk,reset_ms,reset;
wire [31:0] instr,pc_out;

top_module t1(.clk(clk),
			  .reset_ms(reset_ms),
			  .reset(reset),
			  .pc_out(pc_out),
			  .instr(instr));

//instruction_memory (address,data_out,clk);
instruction_memory instruct(.address (pc_out),
							  .data_out (instr));

initial 
begin
	clk = 0;
	forever #(t/2) clk = ~clk;
end

initial 
begin
	
	$dumpfile ("top_tb.vcd");
	$dumpvars (0,top_tb);
	reset_ms = 1'b1;
	reset = 1'b1;
	#t
	reset_ms = 1'b0;	//to free the memory system reset
	reset = 1'b0;    	//to free RISC resets and enables and pc_sel
	#t
	#(t*165)    ///wait for the program to finish
	$dumpoff;
/* mem_add_h  mem_add_d  	val_h 
	0xe0        224 >> 		0x19
	0x60   		96  >> 		0x7
	0x50   		80  >> 		0xc
	0x2d   		45  >> 		0xc
	0x28  		40  >> 		0xa
	0x20  		32  >> 		0xa
	0x1f   		31  >> 		0xc
	0x1e   		30  >> 		0xc
	0x1b   		27  >> 		0x7
	0x1a   		26  >> 		0x7
	0x18  		24  >> 		0xe
	0x14   		20  >> 		0xe4
	0x10   		16  >> 		0xe	
	0xf    		15 !>> 		0xa0
	0xc    		12  >> 		0xe
	0x8    		8   >> 		0xa
	0x6    		6   >> 		0xc
	0x5    		5   >> 		0xa
	0x2    		2   >> 		0x7
*/	
///////////////cash check///////////////////////////
	if (t1.ms.data_mem1.mem[8] == 32'ha)
		$display ("success in add 0x8");
	else
			$display ("failure in add 0x8");
////////////////////////////////////////////			
	if (t1.ms.data_mem1.mem[80] == 32'hc)
		$display ("success in add 0x50");
	else
		$display ("failure in add 0x50");			
////////////////////////////////////////////			
	if (t1.ms.data_mem1.mem[16] == 32'he)
		$display ("success in add 0x10");
	else
		$display ("failure in add 0x10");		
////////////////////////////////////////////		
	if (t1.ms.data_mem1.mem[24] == 32'he)
		$display ("success in add 0x18");
	else 
		$display ("failure in add 0x18");
////////////////////////////////////////////
	if (t1.ms.data_mem1.mem[32] == 32'ha)
		$display ("success in add 0x20");
	else
		$display ("failure in add 0x20");
////////////////////////////////////////////
	if (t1.ms.data_mem1.mem[6] == 32'd12)
		$display ("success in add 0x6");
	else
			$display ("failure in 0x6");
////////////////////////////////////////////			
	if (t1.ms.data_mem1.mem[5] == 32'd10)
		$display ("success in add 0x5");
	else
		$display ("failure in add 0x5");			
////////////////////////////////////////////			
	if (t1.ms.data_mem1.mem[12] == 32'd14)
		$display ("success in add 0xc");
	else
		$display ("failure in add 0xc");		
////////////////////////////////////////////		
	if (t1.ms.data_mem1.mem[40] == 32'd10)
		$display ("success in add 0x28");
	else 
		$display ("failure in add 0x28");
////////////////////////////////////////////
	if (t1.ms.data_mem1.mem[45] == 32'hc)
		$display ("success in add 0x2d");
	else
		$display ("failure in add 0x2d");
	
///////////////pipline processor check/////////////////
	if (t1.ms.data_mem1.mem[96] == 32'h7)
		$display ("success in add 0x60");
	else
			$display ("failure in 0x60");		
////////////////////////////////////////////			
	if (t1.ms.data_mem1.mem[224] == 32'h19)
		$display ("success in add 0xe0");
	else
		$display ("failure in add 0xe0");			
////////////////////////////////////////////				
	if (t1.ms.data_mem1.mem[2] == 32'h7)
		$display ("success in add 0x2");
	else
		$display ("failure in add 0x2");	
////////////////////////////////////////////		
	if (t1.ms.data_mem1.mem[15] != 32'hc0)
		$display ("success jalr jumping");
	else 
		$display ("failure jalr jumping");		
////////////////////////////////////////////		
	if (t1.ms.data_mem1.mem[20] == 32'he4)
		$display ("success in add 0x14");
	else 
		$display ("failure in add 0x14");
////////////////////////////////////////////
	if (t1.ms.data_mem1.mem[30] == 32'hc)
		$display ("success in add 0x1e");
	else
		$display ("failure in add 0x1e");	
////////////////////////////////////////////
	if (t1.ms.data_mem1.mem[31] == 32'hc)
		$display ("success in add 0x1f");
	else
		$display ("failure in add 0x1f");	
/////////////////////////////////////////////
	if (t1.ms.data_mem1.mem[26] == 32'h7)
		$display ("success in add 0x1a");
	else
		$display ("failure in add 0x1a");
//////////////////////////////////////////////
	if (t1.ms.data_mem1.mem[27] == 32'h7)
		$display ("success in add 0x1b");
	else
		$display ("failure in add 0x1b");
////////////////////////////////////////////	
	$stop;
								
end
endmodule