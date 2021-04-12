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
// 指令码（op）：I型指令的操作符
`define EXE_NOP			6'b000000		// 空操作
// 以下3个是I型指令的逻辑类指令的操作符
`define EXE_ORI			6'b001101		// ori指令码
`define EXE_ANDI		6'b001100		// andi
`define EXE_XORI		6'b001110		// xori
// 下面这个是I型指令的载入类指令的操作符
`define EXE_LUI			6'b001111		// lui
`define EXE_PREF		6'b110011
// 下面是I指令的算数操作指令的操作符
`define EXE_ADDI        6'b001000
`define EXE_ADDIU       6'b001001
`define EXE_SLTI        6'b001010
`define EXE_SLTIU       6'b001011


// 功能码（op3）：R型指令的操作符附加段
`define EXE_AND			6'b100100		// and指令
`define EXE_OR			6'b100101		// or指令
`define EXE_XOR			6'b100110		// xor指令
`define EXE_NOR			6'b100111		// nor指令
// 逻辑指令 逻辑左移、逻辑右移、算数右移（移动位数是指定的，为6~10位）
`define EXE_SLL			6'b000000		// sll指令
`define EXE_SRL  		6'b000010
`define EXE_SRA			6'b000011
// 移位指令，不指定移动位数，将rt寄存器中的值移动rs位，放到rd中。
`define EXE_SLLV		6'b000100
`define EXE_SRLV		6'b000110
`define EXE_SRAV		6'b000111
// sync
`define EXE_SYNC		6'b001111
// 移动操作指令
`define EXE_MOVN		6'b001011
`define EXE_MOVZ		6'b001010
`define EXE_MFHI		6'b010000
`define EXE_MFLO		6'b010010
`define EXE_MTHI		6'b010001
`define EXE_MTLO		6'b010011
// 算数操作指令
`define EXE_ADD         6'b100000
`define EXE_ADDU        6'b100001
`define EXE_SUB         6'b100010
`define EXE_SUBU        6'b100011
`define EXE_SLT         6'b101010
`define EXE_SLTU        6'b101011
`define EXE_CLZ         6'b100000
`define EXE_CLO         6'b100001


//AluOp（运算子类型）
`define EXE_NOP_OP		8'b00000000		// 供sync指令、pref指令使用
// 以下运算子类型码是我从光盘代码中抄写的，因为我暂时不清楚运算子类型的编码规则
`define EXE_AND_OP   	8'b00100100
`define EXE_OR_OP    	8'b00100101
`define EXE_XOR_OP  	8'b00100110
`define EXE_NOR_OP  	8'b00100111
`define EXE_LUI_OP  	8'b01011100
// 移位运算子类型码，6种移位指令共用
`define EXE_SLL_OP  	8'b01111100 
`define EXE_SRL_OP  	8'b00000010
`define EXE_SRA_OP		8'b00000011
// 移动操作指令
`define EXE_MOVN_OP		8'b00001011
`define EXE_MOVZ_OP		8'b00001010
`define EXE_MFHI_OP		8'b00010000
`define EXE_MFLO_OP		8'b00010010
`define EXE_MTHI_OP		8'b00010001
`define EXE_MTLO_OP		8'b00010011
// 算数操作指令
`define EXE_ADD_OP      8'b10000000
`define EXE_ADDI_OP     8'b10000001
`define EXE_ADDU_OP     8'b10000010
`define EXE_SUB_OP      8'b10000011
`define EXE_SUBU_OP     8'b10000100
`define EXE_ADDIU_OP    8'b10000101
`define EXE_SLT_OP      8'b10000110
`define EXE_SLTU_OP     8'b10000111
`define EXE_SLTI_OP     8'b10001000  
`define EXE_SLTIU_OP    8'b10001001
`define EXE_CLZ_OP      8'b10001010
`define EXE_CLO_OP      8'b10001011


//AluSel（运算类型）
`define EXE_RES_LOGIC	3'b001			// 逻辑运算
// sync指令、pref指令使用
`define EXE_RES_NOP		3'b000	
// 以下运算类型码是我从光盘代码中抄写的，因为我暂时不清楚运算类型的编码规则，我感觉这是纯粹自己设定的，只要能区分开就行。
`define EXE_RES_SHIFT 	3'b010			// 移位运算
`define EXE_RES_MOVE	3'b011			// 移动操作指令
`define EXE_RES_ARITHMETIC  3'b100      // 算数操作指令
		

//********************	与通用寄存器Regfile有关的宏定义fine	*********************
`define InstBus			31:0
`define InstMemNum		131071		// 指令存储器大小 128kb = 1024 * 128
`define InstAddrBus		31:0
`define	InstMemNumLog2	17