/*!
 * EX模块 执行指令
 * 作用：根据译码的结果，对源操作数1、源操作数2进行指定的运算
 *		  执行阶段包括EX和EX/MEM两个模块
*/
`include "defines.v"
module ex(
	input wire rst,

	// 来自id_ex的信号
	input wire[7:0] aluop_i,	// 运算子类型
	input wire[2:0] alusel_i,	// 运算类型
	input wire[4:0] wd_i,		// EX（执行）后要写入的目的寄存器地址
	input wire wreg_i,			// 是否有要写入的目的寄存器
	input wire[31:0] reg1_i,	// 原操作数1的值
	input wire[31:0] reg2_i,	// 原操作数2的值
	
	// 执行结果的输出
	output reg[4:0] wd_o,		// 要写回的目的寄存器地址
	output reg wreg_o,			// 是否写回
	output reg[31:0] wdata_o	// 将什么数据写回
	
);

// 暂存运算结果
reg[31:0] logicout;
reg[31:0] shiftres;

/********************************************
************	根据子类型运算	***************
********************************************/
/* 逻辑运算 */
always @ (*) begin
	if (rst == `RstEnable) begin
		logicout <= `ZeroWord;
	end else begin
		// 根据子类型运算
		case (aluop_i)
			`EXE_AND_OP: begin
				logicout <= reg1_i & reg2_i;
			end
			`EXE_OR_OP: begin
				logicout <= reg1_i | reg2_i;
			end
			`EXE_XOR_OP: begin
				logicout <= reg1_i ^ reg2_i;
			end
			`EXE_NOR_OP: begin
				logicout <= ~(reg1_i | reg2_i);
			end
			default: begin
				logicout <= `ZeroWord;
			end
		endcase
	end
end 

/* 移位运算 */
always @ (*) begin
	if (rst == `RstEnable) begin
		shiftres <= `ZeroWord;
	end else begin
		case (aluop_i)
			`EXE_SLL_OP: begin
				// reg1_i：传过来的是移动的位数，32位，0-4位表示移动位数
				shiftres <= reg2_i << reg1_i[4:0];
			end
			`EXE_SRL_OP: begin
				shiftres <= reg2_i >> reg1_i[4:0];
			end
			`EXE_SRA_OP: begin
				// reg1_i：传过来的是移动的位数，32位，0-4位表示移动的位数
				// reg2_i：传过来的是源操作数				
				shiftres <=  $signed(reg2_i) >>> $signed(reg1_i);			
			end
		endcase
	end
end

/*************************************************************************
**	根据运算类型，其实就是看下需不需要将运算结果返回，再写回寄存器堆	**
**************************************************************************/
always @ (*) begin
	wd_o <= wd_i;
	wreg_o <= wreg_i;
	// 回写数据，根据运算类型分别来处理。
	case (alusel_i)
		`EXE_RES_LOGIC: begin
			// 数据写回去
			wdata_o <= logicout;
		end
		`EXE_RES_SHIFT: begin
			wdata_o <= shiftres;
		end
		default: begin
			wdata_o <= `ZeroWord;
		end
	endcase
	
end
endmodule
