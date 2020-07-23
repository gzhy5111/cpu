library verilog;
use verilog.vl_types.all;
entity openmips is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        rom_data_i      : in     vl_logic_vector(31 downto 0);
        rom_ce_o        : out    vl_logic;
        rom_addr_o      : out    vl_logic_vector(31 downto 0)
    );
end openmips;
