/*!
 * EX/MEM模块
 * 作用：暂存信息，等待时钟信号后将信息转发给MEM模块
*/
`include "defines.v"
module ex_mem(
	input wire rst,
	input wire clk,
	
	// 接收来自ex的信号
	input wire[4:0] ex_wd,		// 要写回的目的寄存器地址
	input wire ex_wreg,			// 是否写回
	input wire[31:0] ex_wdata,	// 讲什么数据写回
	
	// 转发信号到mem模块
	output reg[4:0] mem_wd,		
	output reg mem_wreg,			
	output reg[31:0] mem_wdata,
	
	// 新增第六章
	// 将对HI LO特殊寄存器的控制和数据信息传递下去
	input wire ex_whilo,			// 是否要写HI LO的使能信号
	input wire[31:0] ex_hi,			// 写入HI寄存器的数据
	input wire[31:0] ex_lo,			// 写入LO寄存器的数据
	
	output reg mem_whilo,			// 是否要写HI LO的使能信号
	output reg[31:0] mem_hi,		// 写入HI寄存器的数据
	output reg[31:0] mem_lo		// 写入LO寄存器的数据
);

// 遇到上升沿时钟信号就将信号转发到mem模块
always @ (posedge clk) begin
	if (rst == `RstEnable) begin
		mem_wd <= `NOPRegAddr;
		mem_wreg <= `WriteDisable;
		mem_wdata <= `ZeroWord;
		mem_whilo <= 1'b0;			
		mem_hi <= `ZeroWord;		
		mem_lo <= `ZeroWord;		
	end else begin
		mem_wd <= ex_wd;
		mem_wreg <= ex_wreg;
		mem_wdata <= ex_wdata;
		mem_whilo <= ex_whilo;			
		mem_hi <= ex_hi;		
		mem_lo <= ex_lo;	
	end
end

endmodule
