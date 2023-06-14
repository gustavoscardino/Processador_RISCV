module polirv 
    #(
        parameter i_addr_bits = 6,
        parameter d_addr_bits = 6
    ) (
        input clk, rst_n,                       // clock borda subida, reset assíncrono ativo baixo
        output [i_addr_bits-1:0] i_mem_addr,
        input  [31:0]            i_mem_data,
        output                   d_mem_we,
        output [d_addr_bits-1:0] d_mem_addr,
        inout  [63:0]            d_mem_data
    );

    wire [6:0] opcode_int;
    wire rf_we_int;
    wire [3:0] alu_cmd_int;
    wire [3:0] alu_flags_int;
    wire alu_src_int, pc_src_int, rf_src_int;



    datapath DP_processador (
        .clk(clk),
        .opcode(opcode_int),
        .d_mem_we(d_mem_we),
        .rf_we(rf_we_int),
        .alu_cmd(alu_cmd_int),
        .alu_flags(alu_flags_int),
        .alu_src(alu_src_int),
        .pc_src(pc_src_int),
        .rf_src(rf_src_int),
        .i_mem_addr(i_mem_addr),
        .i_mem_data(i_mem_data),
        .d_mem_addr(d_mem_addr),
        .d_mem_data(d_mem_data)
    );

    unidade_controle UC_processador (
        .clk(clk),
        .rst_n(rst_n),
        .opcode(opcode_int),
        .d_mem_we(d_mem_we),
        .rf_we(rf_we_int),
        .alu_flags(alu_flags_int),
        .alu_cmd(alu_cmd_int),
        .alu_src(alu_src_int),
        .pc_src(pc_src_int),
        .rf_src(rf_src_int)
    );



endmodule