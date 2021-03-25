/*! 
 * 译码模块
 * 功能：将取到的指令进行拆分，得到运算类型：逻辑、移位、算数、源操作数1、源操作数2、目的地址等
 *									 子类型：当运算类型是逻辑运算时，子类型可以是逻辑与、或、异或
*/
`include "defines.v"
module id(
	input wire rst,						//使能
	input wire[31:0] 	pc_i,			//指令地址
	input wire[31:0] 	inst_i,			//指令
	
	// 读取到的Regfile信息
	// 先不用管，后面的例化中再连接
	input wire[31:0] 	reg1_data_i,
	input wire[31:0] 	reg2_data_i,
	
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
	output reg[7:0] 	aluop_o,		//运算子类型
	output reg[2:0] 	alusel_o,		//运算类型
	
	output reg[4:0] 	wd_o,			// EX（执行）后写入的目的寄存器地址
	output reg 			wreg_o,			//是否有要写入的目的寄存器
	
	output reg[31:0] 	reg1_o,			// 译码阶段要进行运算的原操作数1
	output reg[31:0] 	reg2_o,			// 译码阶段要进行运算的原操作数2

	//最终要送到regfile中的信息
	output reg[4:0] 	reg2_addr_o,
	output reg 			reg2_read_o,
	output reg[4:0] 	reg1_addr_o,
	output reg 			reg1_read_o
	
);

/********************************************
************	取得指令的操作码	***************
********************************************/

// ORI指令的操作码
// 根据每个指令格式的不同，依次所判断的op也不同。但都是从op~op1~op2~op3的顺序进行判断的
wire[5:0] op = inst_i[31:26];
wire[4:0] op2 = inst_i[10:6];
wire[5:0] op3 = inst_i[5:0];		

// 保存指令需要的立即数
reg[31:0] imm;

// 标记指令是否有效
reg instVaild;


/*******************************************
******	第一阶段：对指令译码	************
********************************************/

always @(*) begin
	// 复位有效
	if (rst == `RstEnable) begin
		aluop_o <= `EXE_NOP_OP;		// 运算子类型，8'b00000000
		alusel_o <= `EXE_RES_NOP;	// 运算类型，3'b000
		
		wd_o <= 5'b00000;
		wreg_o <= 1'b0;
		instVaild <= `InstVaild;
		
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
		wreg_o <= 1'b0;
		
		// InstVaild = 1，指令有效
		instVaild <= `InstVaild;
		
		// 需不需要去读寄存器？
		// 这里显然不需要，因为ori指令是对immediate操作的，所以将使能设为0
		reg1_read_o <= 1'b0;
		reg2_read_o <= 1'b0;
		
		// 要通过指令去寄存器取值
		reg1_addr_o <= inst_i[25:21];
		reg2_addr_o <= inst_i[20:16];
		
		imm <= 32'h0000_0000;
		
		case (op)
			6'b000000: begin
				case (op2)
					5'b00000: begin
						case(op3)
							// R型指令
							`EXE_AND: begin						// and指令
								// 问？以下这六个从哪来的？
								// 答：看ex的输入端口，ex要什么，我们就输出什么给它。
								// 也可以看指令集手册，看需要译码出什么操作符
								aluop_o <= `EXE_AND_OP;
								alusel_o <= `EXE_RES_LOGIC;
								wreg_o <= 1'b1;					//是否有要写入的目的寄存器
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instVaild <= `InstVaild;
							end
							`EXE_OR: begin						// or指令
								aluop_o <= `EXE_OR_OP;			// 运算子类型
								alusel_o <= `EXE_RES_LOGIC;		// 运算类型	
								// R型指令需要将两个寄存器data传给后面执行模块
								// 所以需要先从regfile中获取data
								wreg_o <= 1'b1;					// 需要将结果写入的目的寄存器
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instVaild <= `InstVaild;		
							end
							`EXE_XOR: begin
								aluop_o <= `EXE_XOR_OP;
								alusel_o <= `EXE_RES_LOGIC;
								wreg_o <= 1'b1;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instVaild <= `InstVaild;			// instVaild = 1'b1
							end
							`EXE_NOR: begin
								aluop_o <= `EXE_NOR_OP;
								alusel_o <= `EXE_RES_LOGIC;
								wreg_o <= 1'b1;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instVaild <= `InstVaild;
							end
							// 移位指令，不指定移动位数，将rt寄存器中的值移动rs位，放到rd中。
							`EXE_SLLV: begin
								alusel_o <=	`EXE_RES_SHIFT;		// 运算类型
								aluop_o <= `EXE_SLL_OP;			// 运算子类型
								wreg_o <= 1'b1;					// 是否最后要写入目的寄存器		
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instVaild <= `InstVaild;	
							end
							`EXE_SRLV: begin
								alusel_o <=	`EXE_RES_SHIFT;		
								aluop_o <= `EXE_SRL_OP;			
								wreg_o <= 1'b1;						
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instVaild <= `InstVaild;	
							end
							`EXE_SRAV: begin
								alusel_o <=	`EXE_RES_SHIFT;		
								aluop_o <= `EXE_SRA_OP;			
								wreg_o <= 1'b1;						
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instVaild <= `InstVaild;
							end
							// 空指令 sync，是一种R型指令
							`EXE_SYNC: begin
								alusel_o <= `EXE_RES_NOP;
								aluop_o <= `EXE_NOP_OP;
								wreg_o <= 1'b0;
								// 下面这两个比较难理解
								// 端口1不读，端口2读。会执行下面的 reg1_o <= imm;，也就是立即数 32'h0000_0000 送到reg1_o，从而传给执行阶段的 reg1_i（源操作数1）。
								reg1_read_o <= 1'b0;
								reg2_read_o <= 1'b1;
								// 传给执行阶段，但因为不让返回，所以执行阶段也没必要处理。
								instVaild <= `InstVaild;
							end
							`EXE_MOVN: begin
								alusel_o <=	`EXE_RES_MOVE;
								aluop_o <= `EXE_MOVN_OP;
														
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instVaild <= `InstVaild;
								if (reg2_o != 0) begin
									wreg_o <= 1'b1;
								end else begin
									wreg_o <= 1'b0;
								end
							end
							`EXE_MOVZ: begin
								alusel_o <=	`EXE_RES_MOVE;
								aluop_o <= `EXE_MOVZ_OP;
														
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instVaild <= `InstVaild;
								if (reg2_o == 0) begin
									wreg_o <= 1'b1;
								end else begin
									wreg_o <= 1'b0;
								end
							end
							`EXE_MFHI: begin
								aluop_o <= `EXE_MFHI_OP;		// 运算子类型
								alusel_o <= `EXE_RES_MOVE;		// 运算类型
								wreg_o <= 1'b1;					// 是否有要写入的目的寄存器
								reg1_read_o <= 1'b0;			// 不需要读取通用寄存器
								reg2_read_o <= 1'b0;
								instVaild <= `InstVaild;
							end
							`EXE_MFLO: begin
								aluop_o <= `EXE_MFLO_OP;		// 运算子类型
								alusel_o <= `EXE_RES_MOVE;		// 运算类型
								wreg_o <= 1'b1;					// 是否有要写入的目的寄存器
								reg1_read_o <= 1'b0;			// 不需要读取通用寄存器
								reg2_read_o <= 1'b0;
								instVaild <= `InstVaild;
							end
							// 下面这两个只用从HI LO寄存器中读取，不需要写入
							`EXE_MTHI: begin
								aluop_o <= `EXE_MTHI_OP;		// 运算子类型
								alusel_o <= `EXE_RES_MOVE;		// 运算类型
								wreg_o <= 1'b0;					// 是否有要写入的目的寄存器
								reg1_read_o <= 1'b1;			
								reg2_read_o <= 1'b0;
								instVaild <= `InstVaild;
							end
							`EXE_MTLO: begin
								aluop_o <= `EXE_MTLO_OP;		// 运算子类型
								alusel_o <= `EXE_RES_MOVE;		// 运算类型
								wreg_o <= 1'b0;					// 是否有要写入的目的寄存器
								reg1_read_o <= 1'b1;			
								reg2_read_o <= 1'b0;
								instVaild <= `InstVaild;
							end
						endcase
					end
				endcase
			end
			// I型指令，这里的指令只匹配op
			`EXE_ORI: begin							// ori指令				
				wreg_o <= 1'b1;						// 首先肯定是要写回的，修改下使能				
				aluop_o <= `EXE_OR_OP;				// 运算子类型				
				alusel_o <= `EXE_RES_LOGIC;			// 运算类型
				// 需要通过读一个寄存器，另一个是imm，控制使能
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b0;			
				// 因为ori指令需要用到立即数，所以才需要下面的两行
				imm <= {16'h0, inst_i[15:0]};		// 立即数进行无符号扩展
				wd_o <= inst_i[20:16];
				instVaild <= `InstVaild;				
			end
			`EXE_ANDI: begin
				alusel_o <= `EXE_RES_LOGIC;
				aluop_o <= `EXE_AND_OP;		
				wreg_o <= 1'b1;
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b0;
				imm <= {16'h0, inst_i[15:0]};
				wd_o <= inst_i[20:16];
				instVaild <= `InstVaild;
			end
			`EXE_XORI: begin
				alusel_o <= `EXE_RES_LOGIC;
				aluop_o <= `EXE_XOR_OP;		
				wreg_o <= 1'b1;
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b0;
				imm <= {16'h0, inst_i[15:0]};
				wd_o <= inst_i[20:16];
				instVaild <= `InstVaild;
			end
			`EXE_LUI: begin
				alusel_o <= `EXE_RES_LOGIC;
				aluop_o <= `EXE_OR_OP;				// 这里比较特殊，我们让lui指令以逻辑或的方式运算	
				wreg_o <= 1'b1;
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b0;
				imm <= {inst_i[15:0], 16'h0};
				wd_o <= inst_i[20:16];
				instVaild <= `InstVaild;
			end
			`EXE_PREF: begin
				alusel_o <= `EXE_RES_NOP;			// 这个运算类型在后面执行阶段的 wdata_o <= `ZeroWord;
				aluop_o <= `EXE_NOP_OP;				// 匹配后面执行阶段的logicout <= `ZeroWord;
				wreg_o <= 1'b0;
				reg1_read_o <= 1'b0;
				reg2_read_o <= 1'b0;
				instVaild <= `InstVaild;
			end
		endcase
		
		// 逻辑指令 逻辑左移、逻辑右移、算数右移（移动位数是指定的，为6~10位）
		if (inst_i[31:21] == 11'b00000000000) begin
			case (op3)
				`EXE_SLL: begin
					alusel_o <=	`EXE_RES_SHIFT;		// 运算类型
					aluop_o <=	`EXE_SLL_OP;		// 运算子类型
					wreg_o <= 1'b1;					// 需要写回寄存器
					reg1_read_o <= 1'b0;			// 端口1是shamt，代表移动的位数，不需要从寄存器中读
					reg2_read_o <= 1'b1;			// 源操作数rt，需要从端口2，从寄存器堆中读取
					imm[4:0] <= inst_i[10:6];		// 移动的位数，最多5位（可以移动0-5位），注意哈，移动的位数可不是从寄存器堆中取得的，而是从指令的第6-10位取到的。
					wd_o <=	inst_i[15:11];			// 需要写回的寄存器编号
					instVaild <= `InstVaild;
				end
				`EXE_SRL: begin
					alusel_o <=	`EXE_RES_SHIFT;		
					aluop_o <=	`EXE_SRL_OP;		
					wreg_o <= 1'b1;					
					reg1_read_o <= 1'b0;			
					reg2_read_o <= 1'b1;			
					imm[4:0] <= inst_i[10:6];		
					wd_o <=	inst_i[15:11];			
				end
				`EXE_SRA: begin
					alusel_o <=	`EXE_RES_SHIFT;		
					aluop_o <=	`EXE_SRA_OP;		
					wreg_o <= 1'b1;					
					reg1_read_o <= 1'b0;			
					reg2_read_o <= 1'b1;			
					imm[4:0] <= inst_i[10:6];		
					wd_o <=	inst_i[15:11];
				end
			endcase
		end
		
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
