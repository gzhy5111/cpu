//复位使能
`define RstEnable		1'b1
`define RstDisable		1'b0

//芯片使能
`define ChipEnable		1'b1
`define ChipDisable		1'b0

//写使能
`define WriteEnable		1'b1
`define WriteDisable	1'b0

//读使能
`define ReadEnable		1'b1

//32位零
`define ZeroWord		32'h00000000

// 指令有效
`define InstVaild		1'b1	

//********************	与通用寄存器Regfile有关的宏定义fine	*********************
`define RegNumLog2		5
`define NOPRegAddr		5'b00000
`define RegBus			31:0

//***************************	与具体指令有关的define	***************************
// 指令码（op）
`define EXE_NOP			6'b000000		// 空操作
`define EXE_ORI			6'b001101		// ori指令码
`define EXE_ANDI		6'b001100		// andi
`define EXE_XORI		6'b001110		// xori
`define EXE_LUI			6'b001111		// lui

// 功能码（op3）
`define EXE_AND			6'b100100		// and指令
`define EXE_OR			6'b100101		// or指令
`define EXE_XOR			6'b100110		// xor指令
`define EXE_NOR			6'b100111		// nor指令

//AluOp（运算子类型）
`define EXE_NOP_OP		8'b00000000
// 以下运算子类型码是我从光盘代码中抄写的，因为我暂时不清楚运算子类型的编码规则
`define EXE_AND_OP   	8'b00100100
`define EXE_OR_OP    	8'b00100101
`define EXE_XOR_OP  	8'b00100110
`define EXE_NOR_OP  	8'b00100111
`define EXE_LUI_OP  	8'b01011100 

//AluSel（运算类型）
`define EXE_RES_LOGIC	3'b001			// 逻辑运算
`define EXE_RES_NOP		3'b000

//********************	与通用寄存器Regfile有关的宏定义fine	*********************
`define InstBus			31:0
`define InstMemNum		131071		// 指令存储器大小 128kb = 1024 * 128
`define InstAddrBus		31:0
`define	InstMemNumLog2	17