# cpu
自己动手写CPU



2020.5.16	已完成单指令ori的取指和译码

2020.6.1	已完成单指令ori的取指、译码和执行

2020.6.1	已完成单指令ori访存阶段

2020.6.20	已完成第 4 章 4.3 节——单条ori指令仿真验证（已实现单条ori指令）

2020.7.9	chapter5，使用数据前推解决数据相关问题

2020.7.10	chapter5_1：又实现了一条逻辑指令——and指令

2020.7.10	已实现全部8条逻辑指令

2020.7.22	准备写移位指令的时候，发现chapter5_2的ex.v有错误。现在错误已经修复好了。

2020.7.23	发现上层文件连接有误导致无法正确读取寄存器中的数据。已经改正。并且完成了6个移位指令和2个空指令。

2020.9.23	已实现6个移动操作指令，包括movn、movz两个条件移动指令和4个 mfhi、mflo 、mthi、mtlo 有关特殊寄存器HI和LO的操作指令。HI和LO寄存器用于保存乘法和除法结果，当用于保存乘法结果时，HI保存结果的高32位，LO报错结果的低32位，当用于保存除法结果时，HI寄存器保存余数，LO寄存器保存商。

2021.3.13	Chapter6增加用于测试的代码文件夹——AsmTest目录，内含有mips代码，可以经过汇编编译器编译后形成二进制机器码。

2021.3.28	Chapter7 实现了add addi addiu addu sub subu指令。

2021.4.9	漏掉了 addiu 指令，修改后将其实现，测试通过。

2021.4.9	实现Chapter7-简单算术指令之第二段。slt\sltu\slti\sltiu指令。

2021.4.12	实现 算术操作指令之 clo\clz 指令。

2021.4.15	实现 mul、mult、multu 指令。