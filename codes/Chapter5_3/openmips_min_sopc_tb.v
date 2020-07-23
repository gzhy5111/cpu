`include "defines.v"
`timescale 1ns/1ps

module openmips_min_sopc_tb();
	reg clk_50hz;
	reg rst;
	
	
	initial begin
		// 每隔10ns，clk信号翻转一次，造就了一个周期是20ns，即50Hz
		clk_50hz = 1'b0;
		forever #10 clk_50hz = ~clk_50hz;
	end
	
	initial begin
		// 刚开始 复位信号有效 模块无法执行
		rst = `RstEnable;
		// 195ns后 复位信号无效 开始运行模块
		#195 rst = `RstDisable;
		// 1000ns后 停止仿真
		#1000 $stop;
	end
	
	openmips_min_sopc openmips_min_sopc0(
		.clk(clk_50hz),
		.rst(rst)
	);
	
endmodule 