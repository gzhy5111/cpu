# 项目文件使用说明

## 导入项目方法

所使用的软件：Modelsim SE-64 10.4

导入方法：

1. 启动Modelsim
2. file菜单打开.wlf文件（需要先在下面的文件类型中选择.wlf类型）
3. 现在会出现一个sim视窗
4. 在窗口中的任意位置鼠标右击 -- add wave，file - load，选择.do文件即可加载对应波形

文件说明：

AsmTest/inst_rom.S：mips汇编代码

AsmTest/inst_rom.data：经过汇编编译器编译后的二进制代码

## 项目框架

Chapter4：第 4 章 第一条指令ori的实现

Chapter5：使用数据前推解决数据相关问题

Chapter5_1：实现逻辑指令中的一条——and指令

Chapter5_2：已实现全部8条逻辑指令：and、andi、or、ori、xor、xori、nor、lui

Chapter5_3：修改连接文件的错误，部分线没连接对导致无法正确读取寄存器数据。并已完成6个移位操作指令和2个空指令（sync和pref）。

Chapter6：实现 movn、movz、mfhi、mflo、mthi、mtlo六个移动操作指令。

Chapter7：实现 add、addi、addiu、addu、sub、subu 指令。AsmCode文件下内是实现的时候一步步测试的汇编代码和机器码。inst_rom_1.data 是第七章第一段测试的机器码。

​					实现slt\sltu\slti\sltiu指令。inst_rom_2.data 是第七章第二段测试的机器码。

​					实现 第三段：clo\clz指令。inst_rom_3.data 是第三段的测试机器码。

​					实现第四段：mul、mult、multu 指令。inst_rom_4.data 是第四段的测试机器码。

Chapter7_1：7.5 流水线暂停机制实现

Chapter7_2：前面流水线暂停机制代码有误，已经修正，可参考：https://gaozhiyuan.me/computer/cpu/mips-cpu-madd-msub-instructions.html；已实现累乘加 madd、maddu，累乘减 msub、msubu 指令。

Chapter7_3：修改流水线暂停机制，增加访存、回写阶段暂停控制信号。实现除法 div、divu指令。