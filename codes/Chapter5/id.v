/*! 
 * 译码模块
 * 功能：将取到的指令进行拆分，得到运算类型：逻辑、移位、算数、源操作数1、源操作数2、目的地址等
 *									 子类型：当运算类型是逻辑运算时，子类型可以是逻辑与、或、异或
*/
`include "defines.v"
module id(
	input wire rst,				//使能
	input wire[31:0] pc_i,		//指令地址
	input wire[31:0] inst_i,	//指令
	
	// 读取到的Regfile信息
	// 先不用管，后面的例化中再连接
	input wire[31:0] reg1_data_i,
	input wire[31:0] reg2_data_i,
	
	// 第5章 采用数据前推的方式解决数据相关问题
	// 首先，先对译码模块做改进
	// EX执行模块输出的内容连接到译码模块
	input wire[4:0]		ex_wd_i,		// 要写回的目的寄存器地址
	input wire			ex_wreg_i,		// 是否写回
	input wire[31:0] 	ex_wdata_i,		// 将什么数据写回
	// 访存模块输出的内容连接到译码模块
	input wire[4:0]		mem_wd_i,		
	input wire 			mem_wreg_i,			
	input wire[31:0] 	mem_wdata_i,
	
	
	//送到执行阶段的信息
	output reg[7:0] aluop_o,	//运算子类型
	output reg[2:0] alusel_o,	//运算类型
	
	output reg[4:0] wd_o,		// EX（执行）后写入的目的寄存器地址
	output reg wreg_o,			//是否有要写入的目的寄存器
	
	output reg[31:0] reg1_o,	//传原操作数给EX
	output reg[31:0] reg2_o,

	//送到regfile的信息
	output reg[4:0] reg2_addr_o,
	output reg reg2_read_o,
	output reg[4:0] reg1_addr_o,
	output reg reg1_read_o
	
);

/********************************************
************	取得指令的操作码	***************
********************************************/

// ORI指令的操作码
wire[5:0] op = inst_i[31:26];		

// 保存指令需要的立即数
reg[31:0] imm;

// 标记指令是否有效
reg instVaild;


/********************************************
************	第一阶段：对指令译码	************
********************************************/

always @(*) begin
	// 复位有效
	if (rst == `RstEnable) begin
		aluop_o <= `EXE_NOP_OP;		// 运算子类型，8'b00000000
		alusel_o <= `EXE_RES_NOP;	// 运算类型，3'b000
		
		wd_o <= 5'b00000;
		wreg_o <= 1'b0;
		
		reg2_addr_o <= 5'b00000;
		reg2_read_o <= 1'b0;
		reg1_addr_o <= 5'b00000;
		reg1_read_o <= 1'b0;
		
		imm <= 32'h0000_0000;
	// 正常情况下，下面的是默认运算
	end else begin
		// 操作子类型和操作类型
		aluop_o <= `EXE_NOP_OP;
		alusel_o <= `EXE_RES_NOP;
		
		// 要写入的目的寄存器
		wd_o <= inst_i[15:11];
		wreg_o <= 1'b1;
		
		// InstVaild = 1，指令有效
		instVaild <= `InstVaild;
		
		// 需不需要去读寄存器？
		// 这里显然不需要，因为ori指令是对immediate操作的
		reg1_o <= 1'b0;
		reg2_o <= 1'b0;
		
		// 要通过指令去寄存器取值
		reg1_addr_o <= inst_i[25:21];
		reg2_addr_o <= inst_i[20:16];
		
		imm <= 32'h0000_0000;
		
		case (op)
			`EXE_ORI: begin
				// 首先肯定是要写回的，修改下使能
				wreg_o <= 1'b1;
				// 运算子类型
				aluop_o <= `EXE_OR_OP;
				// 运算类型
				alusel_o <= `EXE_RES_LOGIC;
				// 需要通过读一个寄存器，另一个是imm，控制使能
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b0;
				// 立即数进行无符号扩展
				imm <= {16'h0, inst_i[15:0]};
				wd_o <= inst_i[20:16];
				// 此指令有效
				instVaild <= `InstVaild;
			end
			default:begin
			end
		endcase
	end
end 

/********************************************
*********	第二阶段：控制源操作数1	*********
********************************************/

// 第5章 这里为了实现数据前推。译码的时候增加了两种情况。
// 情况1：如果要读的目的寄存器就是执行阶段将要写回的寄存器，那么直接将执行阶段要写回的寄存器赋给译码要读的寄存器。
// 情况2：如果要读的目的寄存器就是访存阶段要写回的目的寄存器，那么直接将要回写的寄存器地址赋给译码阶段将要读取的寄存器即可。
always @ (*) begin
	if (rst == `RstEnable) begin
		reg1_o <= 1'b0;
	end else if ((reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg1_addr_o)) begin
		// 直接将ex的data值给reg1_o（参考P111页）
		reg1_o <= ex_wdata_i;
	end else if ((reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg1_addr_o)) begin
		reg1_o <= mem_wdata_i;
	end else if (reg1_read_o == 1'b1) begin
		reg1_o <= reg1_data_i;
	end else if (reg1_read_o == 1'b0) begin
		reg1_o <= imm;
	end else begin
		reg1_o <= `ZeroWord;
	end
end

/********************************************
*********	第三阶段：控制源操作数2	*********
********************************************/
// 与上面的一样，1改成2
// 第5章 需要改进的两种情况，以解决数据相关问题。（1改成2即可）
always @ (*) begin
	if (rst == `RstEnable) begin
		reg2_o <= 1'b0;
	end else if ((reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg2_addr_o)) begin
		reg2_o <= ex_wdata_i;
	end else if ((reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg2_addr_o)) begin
		reg2_o <= mem_wdata_i;
	end else if (reg2_read_o == 1'b1) begin
		reg2_o <= reg2_data_i;
	end else if (reg2_read_o == 1'b0) begin
		reg2_o <= imm;
	end else begin
		reg2_o <= `ZeroWord;
	end
end

endmodule 