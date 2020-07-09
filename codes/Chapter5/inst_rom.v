/*
 *	模块：指令存储器ROM模块
 *	功能：输入指令地址 获得 指令
 *
 *			指令存储器ROM模块接口图
 *			 _________________
 *		——	|ce			inst	|——
 *		—— |addr					|
 *			|_________________|
 *				  inst_rom.v
 */
 `include "defines.v"
 module inst_rom(
		input wire 					ce,
		// 输入指定地址
		input wire [`RegBus]		addr,
		// 输出指令
		output reg [`RegBus]	inst
 );
	
	// 定义一个宽度为InstBus（32位），大小为InstMemNum（238KB）的数组
	reg [`InstBus] inst_mem[0:`InstMemNum-1];
	// 读文件 写到inst_mem数组中
	initial $readmemh("inst_rom.data", inst_mem);
	
	always @ (*) begin
		// //如果指令存储器是禁用的，则输出是空的数据
		if (ce == `ChipDisable) begin
			inst <= `ZeroWord;
		end else begin
			inst <= inst_mem[addr[`InstMemNumLog2+1:2]];
		end
	end
	
	
 endmodule 