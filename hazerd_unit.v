module hazerd_unit (rs1D,rs2D,rdE,rs1E,rs2E,pc_sel,result_selE,rdM,reg_writeM,rdW
					,reg_writeW,forwardAE,forwardBE,stallF,stallD,stallE,stallM
					,stallW,flushD,flushE,stall);

input pc_sel,result_selE,reg_writeM,reg_writeW,stall;
input [4:0] rdE,rdM,rdW,rs1D,rs2D,rs1E,rs2E;

output reg stallF,stallD,stallE,stallM,stallW,flushD,flushE;
output reg [1:0] forwardAE,forwardBE;

always@(*)
begin
	//------------------forward for data Hazerd----------------------------
	if (((rs1E == rdM) & reg_writeM) & (rs1E != 0)) 
		forwardAE = 2'b10;
	else if (((rs1E == rdW) & reg_writeW) & (rs1E != 0))
		forwardAE = 2'b01;
	else 
		forwardAE = 2'b00;
		
	if (((rs2E == rdM) & reg_writeM) & (rs2E != 0)) 
		forwardBE = 2'b10;
	else if (((rs2E == rdW) & reg_writeW) & (rs2E != 0))
		forwardBE = 2'b01;
	else 
		forwardBE = 2'b00;
	//--------------------------------------------------------------------
end

wire lwStall;
assign lwStall = result_selE/*[0]*/ & ((rs1D == rdE) | (rs2D == rdE));
always@(lwStall or pc_sel or stall)
begin
	if (stall)		//memory system stall
		begin
			stallF = 1'b1;
			stallD = 1'b1;
			stallE = 1'b1;
			stallM = 1'b1;
			stallW = 1'b1;
		end
	else
		begin
		//------------------stall for load Hazerd----------------------------
		if (lwStall == 1'b1)
			begin
				stallF = lwStall;
				stallD = lwStall;
				stallE = 1'b0;
				stallM = 1'b0;
				stallW = 1'b0;
			end	
		else 
			begin
				stallF = 1'b0;
				stallD = 1'b0;
				stallE = 1'b0;
				stallM = 1'b0;
				stallW = 1'b0;
			end
		end
	//--------------------------------------------------------------------
	flushE = 1'b0;
	flushD = 1'b0;
	
	//------------------flush for controls Hazerd----------------------------
	if ((lwStall | pc_sel)== 1'b1)
	begin
		flushD = pc_sel;
		flushE = lwStall | pc_sel;
	end
	//--------------------------------------------------------------------
end
endmodule