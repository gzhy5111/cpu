
/*!
 * 名称：HI LO特殊寄存器
 * 功能：实现HI和LO寄存器。我猜想HI就是HIGH的缩写，LO是LOW的缩写。
 *		 HI LO寄存器用于保存乘法和除法的结果。当保存乘法的结果时，HI保存结果的高32位，LO保存结果的低32位。
 *		 当保存除法的结果时，HI寄存器保存余数，LO寄存器保存商。
*/
`include "defines.v"

module hilo_reg(

	input wire rst,
	input wire clk,
	
	//写，输入
	input wire we,
	input wire[31:0] hi_i,	// 要写入hi寄存器的值
	input wire[31:0] lo_i,	// 要写入lo寄存器的值
	
	//读，输出		
	output reg [31:0] hi_o,	// 输出hi寄存器的值
	output reg [31:0] lo_o	// 输出lo寄存器的值

);


/**************************	写	 ******************************/
//写操作使用的是 时序电路
	
	always @(posedge clk) begin
		if (rst == `RstEnable) begin
			hi_o <= `ZeroWord;
			lo_o <= `ZeroWord;
		end else if (we == `WriteEnable) begin		// 当允许写入的时候（写使能有效）
			hi_o <= hi_i;
			lo_o <= lo_i;
		end
	end
	
endmodule
