/*!
 * 名：IF/ID
 * 功能：暂存从PC获取的指令地址 和 从指令存储器获取的指令（二进制指令代码）
*/
`include "defines.v"

module if_id(

	input wire clk,
	input wire rst,	
	input wire[31:0] if_pc,			//暂存：从PC获取的指令的地址
	input wire[31:0] if_inst,		//暂存：从指令存储器获取的，取指阶段所需要的，指令
	
	output reg[31:0] id_pc,			//将指令地址送给译码模块(id.v)
	output reg[31:0] id_inst		//将指令送给译码模块
);
	
	always @(posedge clk) begin
		//处于复位状态
		if (rst == `RstEnable) begin		
			id_pc <= 32'h0000_0000;
			id_inst <= 32'h0000_0000;
			
		// 正常情况下将指令地址和指令送到output
		end else begin
			id_pc <= if_pc;
			id_inst <= if_inst;
		end
	end
	
endmodule 