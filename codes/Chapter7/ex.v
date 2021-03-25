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
	output reg[31:0] wdata_o,	// 将什么数据写回
	
	// 第六章为解决数据相关问题，新增的连线，为了跟HI LO特殊寄存器相连接
	// 跟特殊寄存器输出端口相连
	input wire[31:0] hi_i,				// 要写入hi寄存器的值
	input wire[31:0] lo_i,				// 要写入lo寄存器的值
	// 为解决数据相关问题，下面是跟访存阶段相连
	input wire mem_whilo_i,				// 是否要写HI LO的使能信号
	input wire[31:0] mem_hi_i,			// 写入HI寄存器的数据
	input wire[31:0] mem_lo_i,			// 写入LO寄存器的数据
	// 为解决数据相关问题，下面是跟回写阶段相连
	input wire wb_whilo_i,				
	input wire[31:0] wb_hi_i,				
	input wire[31:0] wb_lo_i,				
	// 将对HI LO特殊寄存器的控制和数据信息传递下去
	output reg whilo_o,					// 写入特殊寄存器使能					
	output reg[31:0] hi_o,				// 写入特殊寄存器数据		
	output reg[31:0] lo_o				
	
);

// 暂存运算结果
reg[31:0] logicout;
reg[31:0] shiftres;
reg[31:0] moveres;

// 暂存特殊寄存器HI和LO的值
reg[31:0] hi;
reg[31:0] lo;

/******************************************************************
************	需要从特殊寄存器HI和LO中获取数据	***************
*******************************************************************/

always @ (*) begin
	if (rst == `RstEnable) begin	// 复位信号有效
		hi <= `ZeroWord;
		lo <= `ZeroWord;
	end else if (mem_whilo_i == `WriteEnable) begin		// 请看P136页的图，在执行EX模块就要处理好数据相关问题
		hi <= mem_hi_i;
		lo <= mem_lo_i;
	end else if (wb_whilo_i == `WriteEnable) begin
		hi <= wb_hi_i;
		lo <= wb_lo_i;
	end else begin
		hi <= hi_i;
		lo <= lo_i;
	end
end

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

/* 移动操作 */
always @ (*) begin
	if (rst == `RstEnable) begin
		shiftres <= `ZeroWord;
	end else begin
		case (aluop_i)
			`EXE_MOVN_OP: begin
				moveres <= reg1_i;
			end
			`EXE_MOVZ_OP: begin
				moveres <= reg1_i;
			end
			// 他们是特殊寄存器的指令 --> 通用寄存器 的指令，采用的还是与普通指令一样的，常规的方法
			`EXE_MFHI_OP: begin
				moveres <= hi;
			end
			`EXE_MFLO: begin
				moveres <= lo;
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
		`EXE_RES_MOVE: begin
			wdata_o <= moveres;
		end
		default: begin
			wdata_o <= `ZeroWord;
		end
	endcase
	
end

/***********************************************************************************************
**	如果是MTHI MTLO指令，他们是将 通用寄存器的值 -赋给-> 特殊寄存器的指令	********************
**	这两个指令的主要功能就是获取从普通寄存器取值，然后赋给ex阶段输出变量 whilo_o、hi_o和 lo_o **
************************************************************************************************/

always @ (*) begin
	if (rst == `RstEnable) begin
		whilo_o <= 1'b0;					
		hi_o <= hi;				
		lo_o <= lo;
	end else if (aluop_i == `EXE_MTHI_OP) begin
		whilo_o <= 1'b1;					
		hi_o <= reg1_i;				
		lo_o <= lo;
	end else if (aluop_i == `EXE_MTLO_OP) begin
		whilo_o <= 1'b1;					
		hi_o <= hi;				
		lo_o <= reg1_i;
	end else begin
		whilo_o <= 1'b0;					
		hi_o <= hi;				
		lo_o <= lo;
	end
end

endmodule
