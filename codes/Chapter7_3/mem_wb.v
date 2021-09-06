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
	output reg[31:0] wb_wdata,

	// 新增第六章
	// 将对HI LO特殊寄存器的控制和数据信息传递下去
	input wire mem_whilo,				// 是否要写HI LO的使能信号
	input wire[31:0] mem_hi,			// 写入HI寄存器的数据
	input wire[31:0] mem_lo,			// 写入LO寄存器的数据
	
	output reg wb_whilo,				// 是否要写HI LO的使能信号
	output reg[31:0] wb_hi,				// 写入HI寄存器的数据
	output reg[31:0] wb_lo,				// 写入LO寄存器的数据	
    
    // ctrl模块
    input wire[5:0] ctrl_signal        // ctrl控制模块输出的信号，用于控制本模块的暂停与否。
	
);

always @ (posedge clk) begin
	if (rst == `RstEnable) begin
		wb_wd <= `NOPRegAddr;			
		wb_wreg <= `WriteDisable;		
		wb_wdata <= `ZeroWord;
		wb_whilo <= 1'b0;				// 是否要写HI LO的使能信号
		wb_hi <= `ZeroWord;				// 写入HI寄存器的数据
		wb_lo <= `ZeroWord;				// 写入LO寄存器的数据		
	end else if (ctrl_signal[4] == 1'b1 && ctrl_signal[5] == 1'b0) begin
        wb_wd <= `NOPRegAddr;			
		wb_wreg <= `WriteDisable;		
		wb_wdata <= `ZeroWord;
		wb_whilo <= 1'b0;				
		wb_hi <= `ZeroWord;				
		wb_lo <= `ZeroWord;				
    end else if (ctrl_signal[4] == 1'b0) begin
		wb_wd <= mem_wd;			
		wb_wreg <= mem_wreg;		
		wb_wdata <= mem_wdata;
		wb_whilo <= mem_whilo;				
		wb_hi <= mem_hi;				
		wb_lo <= mem_lo;	
	end
end

endmodule
