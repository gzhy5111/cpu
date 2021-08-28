/*！
 * 访存
 * 作用：单条ori指令：因为不需要访问RAM，所以只需要简单的将信号传递下去即可
*/
`include "defines.v"
module mem(
	input wire rst,
	
	// 来自ex_mem的信号
	input wire[4:0] wd_i,		// 要写回的目的寄存器地址
	input wire wreg_i,			// 是否写回
	input wire[31:0] wdata_i,	// 讲什么数据写回
	
	// 传给mem_wb模块
	output reg[4:0] wd_o,		
	output reg wreg_o,			
	output reg[31:0] wdata_o,
	
	// 新增第六章
	// 将对HI LO特殊寄存器的控制和数据信息传递下去
	input wire whilo_i,				// 是否要写HI LO的使能信号
	input wire[31:0] hi_i,			// 写入HI寄存器的数据
	input wire[31:0] lo_i,			// 写入LO寄存器的数据
	
	output reg whilo_o,				// 是否要写HI LO的使能信号
	output reg[31:0] hi_o,			// 写入HI寄存器的数据
	output reg[31:0] lo_o			// 写入LO寄存器的数据
);

always @ (*) begin
	if (rst == `RstEnable) begin
		wd_o <= `NOPRegAddr;	
		wreg_o <= `WriteDisable;	
		wdata_o <= `ZeroWord;
		whilo_o <= 1'b0;			// 是否要写HI LO的使能信号
		hi_o <= `ZeroWord;			// 写入HI寄存器的数据
		lo_o <= `ZeroWord;			// 写入LO寄存器的数据
	end else begin
		wd_o <= wd_i;	
		wreg_o <= wreg_i;	
		wdata_o <= wdata_i;
		whilo_o <= whilo_i;		
		hi_o <= hi_i;			
		lo_o <= lo_i;			
	end
end

endmodule
