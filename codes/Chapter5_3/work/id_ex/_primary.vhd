library verilog;
use verilog.vl_types.all;
entity id_ex is
    port(
        rst             : in     vl_logic;
        clk             : in     vl_logic;
        id_aluop        : in     vl_logic_vector(7 downto 0);
        id_alusel       : in     vl_logic_vector(2 downto 0);
        id_wd           : in     vl_logic_vector(4 downto 0);
        id_wreg         : in     vl_logic;
        id_reg1         : in     vl_logic_vector(31 downto 0);
        id_reg2         : in     vl_logic_vector(31 downto 0);
        ex_aluop        : out    vl_logic_vector(7 downto 0);
        ex_alusel       : out    vl_logic_vector(2 downto 0);
        ex_wd           : out    vl_logic_vector(4 downto 0);
        ex_wreg         : out    vl_logic;
        ex_reg1         : out    vl_logic_vector(31 downto 0);
        ex_reg2         : out    vl_logic_vector(31 downto 0)
    );
end id_ex;
