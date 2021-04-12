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

// 算术运算中用到的变量 
reg overflow;
reg[31:0] temp_counts;

// 暂存运算结果
reg[31:0] logicout;
reg[31:0] shiftres;
reg[31:0] moveres;
reg[31:0] counts;

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
		moveres <= `ZeroWord;
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

/* 算术操作 */
always @ (*) begin
    if (rst == `RstEnable) begin
        counts <= `ZeroWord;
    end else begin
        case (aluop_i)
            // add addi addu 指令都是直接相加。不同的是，带ｕ的不进行溢出检查直接保存；不带ｕ的如果产生溢出则不保存结果。
            `EXE_ADD_OP: begin
                temp_counts <= reg1_i + reg2_i;
                // 下面进行溢出检测，如果溢出，则写回寄存器使能无效。
                if ((reg1_i[31] == 0 && reg2_i[31] == 0 && temp_counts[31] == 1) || (reg1_i[31] == 1 && reg2_i[31] == 1 && temp_counts[31] == 0)) begin
                    overflow = 1;
                    wreg_o <= 1'b0;
                end else begin
                    overflow = 0;
                    counts <= temp_counts;
                end
            end
            `EXE_ADDI_OP: begin
                temp_counts <= reg1_i + reg2_i;
                if ((reg1_i[31] == 0 && reg2_i[31] == 0 && temp_counts[31] == 1) || (reg1_i[31] == 1 && reg2_i[31] == 1 && temp_counts[31] == 0)) begin
                    overflow = 1;
                    wreg_o <= 1'b0;
                end else begin
                    overflow = 0;
                    counts <= temp_counts;
                end
            end
            `EXE_ADDIU_OP: begin
                counts <= reg1_i + reg2_i;
            end
            `EXE_ADDU_OP: begin
                counts <= reg1_i + reg2_i;
            end
            `EXE_SUB_OP: begin
                temp_counts <= reg1_i - reg2_i;
                if ((reg1_i[31] == 0 && reg2_i[31] == 0 && temp_counts[31] == 1) || (reg1_i[31] == 1 && reg2_i[31] == 1 && temp_counts[31] == 0)) begin
                    overflow = 1;
                    wreg_o <= 1'b0;
                end else begin
                    overflow = 0;
                    counts <= temp_counts;
                end
            end
            `EXE_SUBU_OP: begin
                counts <= reg1_i - reg2_i;
            end
            `EXE_SLT_OP: begin
                // 下面进行有符号比较，既然有符号，就有正负。分下面四种情况：
                // 1. rs正数，rt正数
                if (reg1_i[31] == 0 && reg2_i[31] == 0) begin
                    // reg1减去reg2，大于0则counts为0；小于0，则counts为1
                    if ((reg1_i - reg2_i) < 0) begin
                        counts <= 1;
                    end else begin
                        counts <= 0;
                    end 
                end
                // 2. rs正数，rt负数（rs > rt）
                if (reg1_i[31] == 0 && reg2_i[31] == 1) begin
                    counts <= 0;
                end
                // 3. rs负数，rt正数（rs < rt）
                if (reg1_i[31] == 1 && reg2_i[31] == 0) begin
                    counts <= 1;
                end
                // 4. rs负数，rt负数
                if (reg1_i[31] == 1 && reg2_i[31] == 1) begin
                    // reg1减去reg2，大于0则counts为0；小于0，则counts为1
                    if ((reg1_i - reg2_i) < 0) begin
                        counts <= 1;
                    end else begin
                        counts <= 0;
                    end 
                end
            end
            `EXE_SLTU_OP: begin
                // 无符号比较，直接比较即可。
                if ((reg1_i - reg2_i) < 0) begin
                    counts <= 1;
                end else begin
                    counts <= 0;
                end
            end
            `EXE_SLTI_OP: begin
                // 下面进行有符号比较，既然有符号，就有正负。分下面四种情况：
                // 1. rs正数，rt正数（）
                if (reg1_i[31] == 0 && reg2_i[31] == 0) begin
                    // reg1减去reg2，大于0则counts为1；小于0，则counts为0
                    if ((reg1_i - reg2_i) > 0) begin
                        counts <= 1;
                    end
                    if ((reg1_i - reg2_i) < 0) begin
                        counts <= 0;
                    end 
                end
                // 2. rs正数，rt负数（rs > rt）
                if (reg1_i[31] == 0 && reg2_i[31] == 1) begin
                    counts <= 1;
                end
                // 3. rs负数，rt正数（rs < rt）
                if (reg1_i[31] == 1 && reg2_i[31] == 0) begin
                    counts <= 0;
                end
                // 4. rs负数，rt负数
                if (reg1_i[31] == 1 && reg2_i[31] == 1) begin
                    // reg1减去reg2，大于0则counts为0；小于0，则counts为1
                    if ((reg1_i - reg2_i) > 0) begin
                        counts <= 1;
                    end else begin
                        counts <= 0;
                    end 
                end
            end
            `EXE_SLTIU_OP: begin
                // 无符号比较，直接比较即可。
                if ((reg1_i - reg2_i) > 0) begin
                    counts <= 1;
                end else begin
                    counts <= 0;
                end
            end
            `EXE_CLZ_OP: begin
                counts <= 0;
                if (reg1_i == 32'h00000000)
                    counts <= 32;
                // 统计1之前0的个数，所以以1作为“决断”。
                else if (reg1_i[31] == 1)
                    counts <= 0;       
                else if (reg1_i[30] == 1)
                    counts <= 1;       
                else if (reg1_i[29] == 1)
                    counts <= 2;       
                else if (reg1_i[28] == 1)
                    counts <= 3;       
                else if (reg1_i[27] == 1)
                    counts <= 4;       
                else if (reg1_i[26] == 1)
                    counts <= 5;       
                else if (reg1_i[25] == 1)
                    counts <= 6;       
                else if (reg1_i[24] == 1)
                    counts <= 7;       
                else if (reg1_i[23] == 1)
                    counts <= 8;       
                else if (reg1_i[22] == 1)
                    counts <= 9;      
                else if (reg1_i[21] == 1)
                    counts <= 10;      
                else if (reg1_i[20] == 1)
                    counts <= 11;      
                else if (reg1_i[19] == 1)
                    counts <= 12;      
                else if (reg1_i[18] == 1)
                    counts <= 13;      
                else if (reg1_i[17] == 1)
                    counts <= 14;      
                else if (reg1_i[16] == 1)
                    counts <= 15;      
                else if (reg1_i[15] == 1)
                    counts <= 16;      
                else if (reg1_i[14] == 1)
                    counts <= 17;      
                else if (reg1_i[13] == 1)
                    counts <= 18;      
                else if (reg1_i[12] == 1)
                    counts <= 19;      
                else if (reg1_i[11] == 1)
                    counts <= 20;      
                else if (reg1_i[10] == 1)
                    counts <= 21;
                else if (reg1_i[9] == 1) 
                    counts <= 22;     
                else if (reg1_i[8] == 1) 
                    counts <= 23;     
                else if (reg1_i[7] == 1) 
                    counts <= 24;     
                else if (reg1_i[6] == 1) 
                    counts <= 25;     
                else if (reg1_i[5] == 1) 
                    counts <= 26;     
                else if (reg1_i[4] == 1) 
                    counts <= 27;     
                else if (reg1_i[3] == 1) 
                    counts <= 28;     
                else if (reg1_i[2] == 1) 
                    counts <= 29;     
                else if (reg1_i[1] == 1) 
                    counts <= 30;
                else
                    counts <= 31;

            end
            `EXE_CLO_OP: begin
                counts <= 0;
                if (reg1_i == 32'hffffffff)
                    counts <= 32;
                else
                
                // 统计0之前1的个数，所以以0作为“决断”。
                if (reg1_i[31] == 0)
                    counts <= 0;  
                else              
                if (reg1_i[30] == 0)
                    counts <= 1;  
                else              
                if (reg1_i[29] == 0)
                    counts <= 2;  
                else              
                if (reg1_i[28] == 0)
                    counts <= 3;  
                else              
                if (reg1_i[27] == 0)
                    counts <= 4;  
                else              
                if (reg1_i[26] == 0)
                    counts <= 5;  
                else              
                if (reg1_i[25] == 0)
                    counts <= 6;  
                else              
                if (reg1_i[24] == 0)
                    counts <= 7;  
                else              
                if (reg1_i[23] == 0)
                    counts <= 8;  
                else              
                if (reg1_i[22] == 0)
                    counts <= 9;  
                else              
                if (reg1_i[21] == 0)
                    counts <= 10; 
                else              
                if (reg1_i[20] == 0)
                    counts <= 11; 
                else              
                if (reg1_i[19] == 0)
                    counts <= 12; 
                else              
                if (reg1_i[18] == 0)
                    counts <= 13; 
                else              
                if (reg1_i[17] == 0)
                    counts <= 14; 
                else              
                if (reg1_i[16] == 0)
                    counts <= 15; 
                else              
                if (reg1_i[15] == 0)
                    counts <= 16; 
                else              
                if (reg1_i[14] == 0)
                    counts <= 17; 
                else              
                if (reg1_i[13] == 0)
                    counts <= 18; 
                else              
                if (reg1_i[12] == 0)
                    counts <= 19; 
                else              
                if (reg1_i[11] == 0)
                    counts <= 20; 
                else              
                if (reg1_i[10] == 0)
                    counts <= 21;
                else              
                if (reg1_i[9] == 0)
                    counts <= 22;
                else             
                if (reg1_i[8] == 0)
                    counts <= 23;
                else             
                if (reg1_i[7] == 0)
                    counts <= 24;
                else             
                if (reg1_i[6] == 0)
                    counts <= 25;
                else             
                if (reg1_i[5] == 0)
                    counts <= 26;
                else             
                if (reg1_i[4] == 0)
                    counts <= 27;
                else             
                if (reg1_i[3] == 0)
                    counts <= 28;
                else             
                if (reg1_i[2] == 0)
                    counts <= 29;
                else             
                if (reg1_i[1] == 0)
                    counts <= 30;
                else
                    counts <= 31;

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
        `EXE_RES_ARITHMETIC: begin
            wdata_o <= counts;
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
