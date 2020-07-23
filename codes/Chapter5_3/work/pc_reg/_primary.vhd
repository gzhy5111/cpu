library verilog;
use verilog.vl_types.all;
entity pc_reg is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        pc              : out    vl_logic_vector(31 downto 0);
        ce              : out    vl_logic
    );
end pc_reg;
