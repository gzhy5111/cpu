/*!
 * 回写阶段的实现
 * 功能：对前面各个阶段的模块进行连接和例化
 *		  采用层次化设计，1)顶层文件负责连线和例化
 *							 2)分频模块负责产生时钟信号
 *
 *					OpenMips模块接口图
 *			 __________________________
 *		——	|rst				rom_ce_o		|——
 *		—— |clk				rom_addr_o	|——
 *		—— |rom_data_i						|
 *			|__________________________|
 *						openmips.v
 */
 `include "defines.v"
 
module openmips(
	input wire clk,
	input wire rst,
	
	input wire [`RegBus]			rom_data_i,				// 从指令寄存器中取得的数据
	output wire 					rom_ce_o,				// 指令寄存器使能
	output wire [`RegBus]		rom_addr_o				// 输出到指令存储器的地址
);
	
	// IF/ID  -->  ID
	wire[31:0] pc;		//指令地址
	wire[31:0] id_pc_i;			//暂存：从PC获取的指令的地址
	wire[31:0] id_inst_i;
	
	// ID  -->  ID/EX
	wire[7:0] id_aluop_o;	//运算子类型
	wire[2:0] id_alusel_o;	//运算类型	
	wire[4:0] id_wd_o;		// EX（执行）后写入的目的寄存器地址
	wire id_wreg_o;			//是否有要写入的目的寄存器	
	wire[31:0] id_reg1_o;	//传原操作数给EX
	wire[31:0] id_reg2_o;
	
	// ID/EX --> EX
	wire[7:0] ex_aluop_i;	// 运算子类型
	wire[2:0] ex_alusel_i;	// 运算类型
	wire[4:0] ex_wd_i;		// EX（执行）后要写入的目的寄存器地址
	wire ex_wreg_i;			// 是否有要写入的目的寄存器
	wire[31:0] ex_reg1_i;	// 传原操作数1给EX
	wire[31:0] ex_reg2_i;	// 传原操作数2给EX
	
	// EX  -->  EX/MEM
	wire[4:0] ex_wd_o;		// 要写回的目的寄存器地址
	wire ex_wreg_o;			// 是否写回
	wire[31:0] ex_wdata_o;	// 讲什么数据写回
	
	// EX/MEM  -->  MEM
	wire[4:0] mem_wd_i;		
	wire mem_wreg_i;		
	wire[31:0] mem_wdata_i;

	// MEM  -->  MEM/WB
	wire[4:0] wb_wd_o;			
	wire wb_wreg_o;		
	wire[31:0] wb_wdata_o;
	
	// MEM/WB  -->  regfile
	wire[4:0] wb_wd_i;			
	wire wb_wreg_i;			
	wire[31:0] wb_wdata_i;

	// ID --- regfile
	// ID --> regfile
	wire	[4:0]	reg2_addr;
	wire		reg2_read;
	wire	[4:0]	reg1_addr;
	wire		reg1_read;
	// regfile --> ID
	wire	[31:0]	reg1_data;
	wire	[31:0]	reg2_data;
	

/***********************************************************************************************/

	pc_reg pc_reg0(
		.clk(clk),		.rst(rst),		.pc(pc),		.ce(rom_ce_o)			
	);
	
/***********************************************************************************************/

	assign rom_addr_o = pc;

/***********************************************************************************************/

	// if_id0是模块例化名
	if_id if_id0(
		.clk(clk),		 			 .rst(rst),		 		.if_pc(pc),
		.if_inst(rom_data_i),		 .id_pc(id_pc_i),	 	.id_inst(id_inst_i)
	);
/***********************************************************************************************/
/***********************************************************************************************/
	
	regfile regfile0(
		.rst(rst),			.clk(clk),				.we(wb_wreg_i),					.waddr(wb_wd_i),
		.wdata(wb_wdata_i),		.re1(reg1_read),				.raddr1(reg1_addr),		.rdata1(reg1_data),
		.re2(reg2_read),			.raddr2(reg2_addr),		.rdata2(reg2_data)
);
/***********************************************************************************************/
/***********************************************************************************************/
	
	id id0(
		.rst(rst),							.pc_i(id_pc_i),					.inst_i(id_inst_i),				.reg1_data_i(reg1_data),
		.reg2_data_i(reg2_data),		.aluop_o(id_aluop_o),			.alusel_o(id_alusel_o),			.wd_o(id_wd_o),		
		.wreg_o(id_wreg_o),					.reg1_o(id_reg1_o),				.reg2_o(id_reg2_o),				.reg2_addr_o(reg2_addr),
		.reg2_read_o(reg2_read),		.reg1_addr_o(reg1_addr),	.reg1_read_o(reg1_read),
		
		.ex_wd_i(ex_wd_o), 			.ex_wreg_i(ex_wreg_o), 			.ex_wdata_i(ex_wdata_o),
		.mem_wd_i(wb_wd_o), 			.mem_wreg_i(wb_wreg_o), 			.mem_wdata_i(wb_wdata_o)
	);


/***********************************************************************************************/
/***********************************************************************************************/
	
	id_ex id_ex0(
	.rst(rst),				.clk(clk),					.id_aluop(id_aluop_o),		.id_alusel(id_alusel_o),		
	.id_wd(id_wd_o),			.id_wreg(id_wreg_o),		.id_reg1(id_reg1_o),		.id_reg2(id_reg2_o),		
	.ex_aluop(ex_aluop_i),	.ex_alusel(ex_alusel_i),	.ex_wd(ex_wd_i),				.ex_wreg(ex_wreg_i),			
	.ex_reg1(ex_reg1_i),	.ex_reg2(ex_reg2_i)	
);


/***********************************************************************************************/
/***********************************************************************************************/

	ex ex0(
		.rst(rst),				.aluop_i(ex_aluop_i),		.alusel_i(ex_alusel_i),		.wd_i(ex_wd_i),		
		.wreg_i(ex_wreg_i),		.reg1_i(ex_reg1_i),			.reg2_i(ex_reg2_i),			
		.wd_o(ex_wd_o),		.wreg_o(ex_wreg_o),		.wdata_o(ex_wdata_o)
	);

/***********************************************************************************************/
/***********************************************************************************************/

	ex_mem ex_mem0(
		.rst(rst),				.clk(clk),				.ex_wd(ex_wd_o),					.ex_wreg(ex_wreg_o),
		.ex_wdata(ex_wdata_o),	.mem_wd(mem_wd_i),		.mem_wreg(mem_wreg_i),			.mem_wdata(mem_wdata_i)
	);

/***********************************************************************************************/
/***********************************************************************************************/

	mem mem0(
		.rst(rst),			.wd_i(mem_wd_i),				.wreg_i(mem_wreg_i),			.wdata_i(mem_wdata_i),	
		.wd_o(wb_wd_o),		.wreg_o(wb_wreg_o),			.wdata_o(wb_wdata_o)
	);

/***********************************************************************************************/
/***********************************************************************************************/
	

	mem_wb mem_wb0(
		.rst(rst),					.clk(clk),				.mem_wd(wb_wd_o),			.mem_wreg(wb_wreg_o),				
		.mem_wdata(wb_wdata_o),	.wb_wd(wb_wd_i),			.wb_wreg(wb_wreg_i),		.wb_wdata(wb_wdata_i)	
	);

/***********************************************************************************************/

endmodule
