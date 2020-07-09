//复位使能
`define RstEnable			1'b1
`define RstDisable		1'b0

//芯片使能
`define ChipEnable		1'b1
`define ChipDisable		1'b0

//写使能
`define WriteEnable		1'b1
`define WriteDisable		1'b0

//读使能
`define ReadEnable		1'b1

//32位零
`define ZeroWord			32'h00000000

// 指令有效
`define InstVaild			1'b1	

//********************	与通用寄存器Regfile有关的宏定义fine	*********************
`define RegNumLog2		5
`define NOPRegAddr		5'b00000
`define RegBus				31:0

//***************************	与具体指令有关的define	***************************
`define EXE_ORI			6'b001101	//ori指令的操作码
`define EXE_NOP			6'b000000	//空操作

//AluOp（运算子类型）
`define EXE_OR_OP			8'b00100101
`define EXE_NOP_OP		8'b00000000

//AluSel（运算类型）
`define EXE_RES_LOGIC	3'b001
`define EXE_RES_NOP		3'b000

//********************	与通用寄存器Regfile有关的宏定义fine	*********************
`define InstBus			31:0
`define InstMemNum		131071		// 指令存储器大小 128kb = 1024 * 128
`define InstAddrBus		31:0
`define	InstMemNumLog2		17