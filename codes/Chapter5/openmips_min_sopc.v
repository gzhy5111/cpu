/*
 *					OpenMips模块接口图											指令存储器ROM模块接口图
 *			 __________________________	   									  _______________			
 *		——	|rst				rom_ce_o		|——— openmips.v --> inst_rom.v —— |ce			inst |————|			
 *		—— |clk				rom_addr_o	|——— openmips.v --> inst_rom.v —— |addr			  |	 |
 *		—— |rom_data_i						|	  										 |_______________|    |
 *	  |	|__________________________|											     inst_rom.v		 |
 *	  |				openmips.v											  										 |
 *   |___________________________ openmips.v <-- inst_rom.v _______________________________|
 *
 */
  `include "defines.v"
 module openmips_min_sopc(
	input wire clk,
	input wire rst
 );
	/* openmips.v --> inst_rom.v */
	wire 					rom_ce;					// 指令寄存器使能
	wire [`InstAddrBus]		inst_addr;				// 输出到指令存储器的地址
	/* openmips.v <-- inst_rom.v */
	wire [`InstBus]		inst;						// 从指令寄存器中取得的数据
	
/***********************************************************************************/
	openmips openmips0(
		.clk(clk),
		.rst(rst),
		.rom_data_i(inst),				
		.rom_ce_o(rom_ce),				
		.rom_addr_o(inst_addr)
	);
	
/***********************************************************************************/
/***********************************************************************************/
	inst_rom inst_rom0(
		.ce(rom_ce),
		.addr(inst_addr),
		.inst(inst)
	);	

/***********************************************************************************/
 
 endmodule 