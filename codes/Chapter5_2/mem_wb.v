/*!
 * MEM/WB模块 访存/回写 模块
 *	功能：接受来自mem信号，传递到wb模块
*/
`include "defines.v"
module mem_wb(
	input wire rst,
	input wire clk,
	
	// 来自mem的信号
	input wire[4:0] mem_wd,			// 要写回的目的寄存器地址		
	input wire mem_wreg,				// 是否写回
	input wire[31:0] mem_wdata,	// 讲什么数据写回
	
	// 传递给wb模块
	output reg[4:0] wb_wd,			
	output reg wb_wreg,			
	output reg[31:0] wb_wdata	
);

always @ (posedge clk) begin
	if (rst == `RstEnable) begin
		wb_wd <= `NOPRegAddr;			
		wb_wreg <= `WriteDisable;		
		wb_wdata <= `ZeroWord;	
	end else begin
		wb_wd <= mem_wd;			
		wb_wreg <= mem_wreg;		
		wb_wdata <= mem_wdata;
	end
end

endmodule
