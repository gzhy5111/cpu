# 项目文件使用说明

## 导入项目方法

所使用的软件：Modelsim SE-64 10.4

导入方法：

1. 启动Modelsim
2. file菜单打开.wlf文件（需要先在下面的文件类型中选择.wlf类型）
3. 现在会出现一个sim视窗
4. 在窗口中的任意位置鼠标右击 -- add wave，file - load，选择.do文件即可加载对应波形

## 项目框架

Chapter4：第 4 章 第一条指令ori的实现

Chapter5：使用数据前推解决数据相关问题

Chapter5_1：实现逻辑指令中的一条——and指令

Chapter5_2：已实现全部8条逻辑指令：and、andi、or、ori、xor、xori、nor、lui

Chapter5_3：修改连接文件的错误，部分线没连接对导致无法正确读取寄存器数据。并已完成6个移位操作指令和2个空指令（sync和pref）。

Chapter6：实现 movn、movz、mfhi、mflo、mthi、mtlo六个移动操作指令。