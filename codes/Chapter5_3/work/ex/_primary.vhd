library verilog;
use verilog.vl_types.all;
entity ex is
    port(
        rst             : in     vl_logic;
        aluop_i         : in     vl_logic_vector(7 downto 0);
        alusel_i        : in     vl_logic_vector(2 downto 0);
        wd_i            : in     vl_logic_vector(4 downto 0);
        wreg_i          : in     vl_logic;
        reg1_i          : in     vl_logic_vector(31 downto 0);
        reg2_i          : in     vl_logic_vector(31 downto 0);
        wd_o            : out    vl_logic_vector(4 downto 0);
        wreg_o          : out    vl_logic;
        wdata_o         : out    vl_logic_vector(31 downto 0)
    );
end ex;
