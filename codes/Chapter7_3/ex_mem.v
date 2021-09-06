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
	output reg[31:0] mem_lo,		// 写入LO寄存器的数据
    
    // 第七章 双时钟周期 累乘加/减 指令
    input wire[1:0]  cnt_i,         // 标示第几个时钟周期
    input wire[63:0] hilo_i,        // 暂存执行阶段输出的{hi, lo}的值
    output reg[1:0]  cnt_o,
    output reg[63:0] hilo_o,
    
    // ctrl模块
    input wire[5:0] ctrl_signal    // ctrl控制模块输出的信号，用于控制本模块的暂停与否。
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
	end else if (ctrl_signal[3] == 1'b1 && ctrl_signal[4] == 1'b0) begin
        mem_wd <= `NOPRegAddr;
		mem_wreg <= `WriteDisable;
		mem_wdata <= `ZeroWord;
		mem_whilo <= 1'b0;			
		mem_hi <= `ZeroWord;		
		mem_lo <= `ZeroWord;
        
    end else if(ctrl_signal[3] == 1'b0) begin
		mem_wd <= ex_wd;
		mem_wreg <= ex_wreg;
		mem_wdata <= ex_wdata;
		mem_whilo <= ex_whilo;			
		mem_hi <= ex_hi;		
		mem_lo <= ex_lo;
        cnt_o <= cnt_i;
        hilo_o <= hilo_i;
        
	end
end

endmodule
