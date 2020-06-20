/*!
 * ID/EX模块
 *	作用：将id模块的输出连接到ID/EX模块，以便于在下一个时钟传递到执行模块（EX）
*/
`include "defines.v"
module id_ex(
	// 控制信息
	input wire rst,
	input wire clk,
	
	//从执行阶段获得的信息
	input wire[7:0] id_aluop,		// 运算子类型
	input wire[2:0] id_alusel,	// 运算类型	
	input wire[4:0] id_wd,			// EX（执行）后要写入的目的寄存器地址
	input wire id_wreg,				// 是否有要写入的目的寄存器	
	input wire[31:0] id_reg1,		// 传原操作数1给EX
	input wire[31:0] id_reg2,		// 传原操作数2给EX
	
	// 传给EX
	output reg[7:0] ex_aluop,	// 运算子类型
	output reg[2:0] ex_alusel,	// 运算类型
	output reg[4:0] ex_wd,		// EX（执行）后要写入的目的寄存器地址
	output reg ex_wreg,			// 是否有要写入的目的寄存器
	output reg[31:0] ex_reg1,	// 传原操作数1给EX
	output reg[31:0] ex_reg2	// 传原操作数2给EX
);

always @ (posedge clk) begin	// 上升沿触发
	if (rst == `RstEnable) begin
		ex_aluop <= `EXE_NOP_OP;	
		ex_alusel <= `EXE_RES_NOP;	
		ex_wd <= `NOPRegAddr;		
		ex_wreg <= `WriteDisable;			
		ex_reg1 <= `ZeroWord;	
		ex_reg2 <= `ZeroWord;	
	end else begin
		ex_aluop <= id_aluop;
		ex_alusel <= id_alusel;	
		ex_wd <= id_wd;		
		ex_wreg <= id_wreg;			
		ex_reg1 <= id_reg1;	
		ex_reg2 <= id_reg2;
	end
end

endmodule

