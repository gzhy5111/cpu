library verilog;
use verilog.vl_types.all;
entity regfile is
    port(
        rst             : in     vl_logic;
        clk             : in     vl_logic;
        we              : in     vl_logic;
        waddr           : in     vl_logic_vector(4 downto 0);
        wdata           : in     vl_logic_vector(31 downto 0);
        re1             : in     vl_logic;
        raddr1          : in     vl_logic_vector(5 downto 0);
        rdata1          : out    vl_logic_vector(31 downto 0);
        re2             : in     vl_logic;
        raddr2          : in     vl_logic_vector(5 downto 0);
        rdata2          : out    vl_logic_vector(31 downto 0)
    );
end regfile;
