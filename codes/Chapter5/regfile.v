/*!
 * 名：寄存器堆
 * 功能：提供32个32位寄存器，并提供“一写两读”功能
*/
`include "defines.v"

module regfile(

	input wire rst,
	input wire clk,
	
	//写
	input wire we,
	input wire[4:0] waddr,
	input wire[31:0] wdata,
	
	//读寄存器1端口
	input wire re1,		//读使能信号
	input wire [5:0]raddr1,
	output reg [31:0]rdata1,
	
	//读寄存器2端口
	input wire re2,
	input wire [5:0]raddr2,
	output reg [31:0]rdata2
);

/*********************************************************************
*******************	定义32个32位寄存器	***********************
**********************************************************************/
	reg[31:0] regs[0:31];		//编号从0开始

/**************************	写	 ******************************/
//写操作使用的是 时序电路
	
	always @(posedge clk) begin
		if (rst == `RstDisable) begin
			if (we == `WriteEnable && waddr != `RegNumLog2'b0) begin		//目的寄存器不能为0号寄存器
				//内容送进指定的寄存器
				regs[waddr] <= wdata;
			end
		end
	end
	
/**************************	读1	 ******************************/
//为方便译码阶段立即取得寄存器的数据，读阶段使用的是组合电路
	always @(*)begin
		//复位信号有效：输出“0”(是异常情况，所以不需要读使能有效）
		if (rst == `RstEnable) begin
			rdata1 <= `ZeroWord;
		end
	
		
		//复位信号无效 && 读取的是第0号寄存器：输出“0”(是异常情况，所以不需要读使能有效）
		else if (rst == `RstDisable && raddr1 == `RegNumLog2'h0) begin
			rdata1 <= `ZeroWord;
		end
		
		//下面的情况就不是异常情况了，所以需要读使能有效）
		
		//读目标寄存器与要写入的目标寄存器相同：直接将要写入的值输出
		else if (raddr1 == waddr && we == `WriteEnable && re1 == `ReadEnable) begin
			rdata1 <= wdata;
			
		//下面是正常情况
		end else if (re1 == `ReadEnable) begin
			rdata1 <= regs[raddr1];
		end
		
		//读使能信号无效：输出“0”
		else begin
			rdata1 <= `ZeroWord;
		end
	end
	
	
/**************************	读2	 ******************************/
	always @(*)begin
		if (rst == `RstEnable) begin
			rdata2 <= `ZeroWord;
		end
		else if (rst == `RstDisable && raddr2 == `RegNumLog2'h0) begin
			rdata2 <= `ZeroWord;
		end
		else if (raddr2 == waddr && we == `WriteEnable && re2 == `ReadEnable) begin
			rdata2 <= wdata;
		end
		// 下面是正常情况
		else if (re2 == `ReadEnable) begin
			rdata2 <= regs[raddr2];
		end
		else begin
			rdata2 <= `ZeroWord;
		end
	end
	
endmodule
