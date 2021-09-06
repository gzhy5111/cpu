module div  
#(
parameter DATAWIDTH=32
)
(  
        a,   
        b,  
        enable,
        shang,  
        yushu
);  
input [DATAWIDTH-1:0] a;    // 传输进来的数值是原码            
input [DATAWIDTH-1:0] b;    // 传输进来的数值是原码         
input enable;      
output  shang;              // 计算出的数值是原码      
output  yushu;              // 计算出的数值是原码   
             
wire                enable;            
reg [DATAWIDTH-1:0] shang;    
reg [DATAWIDTH-1:0] yushu;               

// 临时变量
reg [DATAWIDTH-1:0] tempa;  
reg [DATAWIDTH-1:0] tempb;  
reg [2*DATAWIDTH-1:0] temp_a;  
reg [2*DATAWIDTH-1:0] temp_b;  
  
integer i;  
  
always @(a or b)  
begin  
    tempa <= a;  
    tempb <= b;  
end  
  
always @(tempa or tempb) begin  
    if(enable) begin
        temp_a = {{DATAWIDTH{1'b0}},tempa};  
        temp_b = {tempb,{DATAWIDTH{1'b0}}};  
        for(i = 0;i < DATAWIDTH;i = i + 1) begin  
            temp_a = temp_a<<1;
            if(temp_a>= temp_b)  
                temp_a = temp_a - temp_b + 1'b1;  
            else  
                temp_a = temp_a;  
        end  
      
        shang = temp_a[DATAWIDTH-1:0];  
        yushu = temp_a[DATAWIDTH*2-1:DATAWIDTH]; 
    end
end  


  
endmodule
