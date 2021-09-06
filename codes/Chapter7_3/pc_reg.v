/*! 
 * PC模块
 * PC计数器
 * 功能：每个clk上升沿使指令地址(pc)+4
*/
`include "defines.v"
module pc_reg(
	input wire clk,		//时钟
	input wire rst,		//复位
    input wire[5:0] ctrl_signal,   // ctrl控制模块输出的信号，用于控制本模块的暂停与否。
	
	output reg[31:0] pc,		//指令地址
	output reg ce				//指令存储器使能信号，用于检测指令存储器是否工作，如果不工作则不用让本pc计数器工作
);

	always @(posedge clk) begin
		if (rst == `RstEnable) begin		//复位
			ce <= `ChipDisable;				//禁用指令存储器芯片
		end else begin
			ce <= `ChipEnable;				//启用指令存储器
		end
	end
	
	//实现功能：指令每次+4
	always @(posedge clk) begin
		if (ce == `ChipDisable) begin		//如果指令存储器是禁用的
			pc <= 32'h0000_0000;
        end else if(ctrl_signal[0] == 1'b0) begin
			pc <= pc + 4'h4;			
		end
	end

endmodule 