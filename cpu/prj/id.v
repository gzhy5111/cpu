module id(
	input wire rst,				//使能
	input wire[31:0] pc_i,		//指令地址
	input wire[31:0] inst_i,	//指令
	
	//送到执行阶段的信息
	output reg[7:0] aluop_o,	//运算子类型
	output reg[2:0] alusel_o,	//运算类型
	
	output reg[4:0] wd_o,		//EX后写入的目的寄存器地址
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

wire[5:0] op = inst_i[31:26];		//ORI指令的操作码

reg[31:0] imm;


/********************************************
************	第一阶段：对指令译码	************
********************************************/

always @(*) begin
	if (rst == `RstEnable) begin
		aluop_o <= `EXE_NOP_OP;		//8'b00000000
		alusel_o <= `EXE_RES_NOP;	//3'b000
		
		wd_o <= 5'b00000;
		wreg_o <= 1'b0;
		
		reg2_addr_o <= 5'b00000;
		reg2_read_o <= 1'b0;
		reg1_addr_o <= 5'b00000;
		reg1_read_o <= 1'b0;
		
		imm <= 32'h0000_0000;
	end
end 

endmodule 