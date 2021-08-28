module ctrl(
    input wire      rst,                // 使能信号
    input wire      id_suspend_signal,  // 译码阶段暂停信号，传入1表示暂停，0表示不暂停
    input wire      ex_suspend_signal,  // 执行阶段暂停信号
    
    // 输出信号，共有6位信号，从最低位到最高位依次表示 取指地址PC、取指令、译码、执行、访存、回写 控制信号，0表示不予控制正常执行，1表示暂停。
    output reg[5:0] ctrl_signal
);

    always @(*) begin
        if(rst == 1'b1) begin
            ctrl_signal <= 6'b000000;
        // 译码阶段占用 > 1个时钟周期
        end else if(id_suspend_signal == 1'b1) begin
            ctrl_signal <= 6'b000111;
        // 执行阶段占用 > 1个时钟周期
        end else if(ex_suspend_signal == 1'b1) begin
            ctrl_signal <= 6'b001111;
        end
    end

endmodule