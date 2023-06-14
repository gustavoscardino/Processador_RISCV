module datapath 
    #(  // Tamanho em bits dos barramentos
        parameter i_addr_bits = 6,
        parameter d_addr_bits = 6
    )(
        input  clk, rst_n,                   // clock borda subida, reset assíncrono ativo baixo
        output [6:0] opcode,                    
        input  d_mem_we, rf_we,              // Habilita escrita na memória de dados e no banco de registradores
        input  [3:0] alu_cmd,                // ver abaixo
        output [3:0] alu_flags,
        input  alu_src,                      // 0: rf, 1: imm
               pc_src,                       // 0: +4, 1: +imm
               rf_src,                       // 0: alu, 1:d_mem
        output [i_addr_bits-1:0] i_mem_addr,
        input  [31:0]            i_mem_data,
        output [d_addr_bits-1:0] d_mem_addr,
        inout  [63:0]            d_mem_data

    );
    // AluCmd     AluFlags
    // 0000: R    0: zero
    // 0001: I    1: MSB 
    // 0010: S    2: overflow
    // 0011: SB   3: equal --modificado
    // 0100: U
    // 0101: UJ

//Instanciação do fio auxiliar pro Inout
wire [63:0] d_in_pro;
//wire [63:0] d_in_mem; 

assign d_in_pro = (d_mem_we) ?  64'bz : d_mem_data;
//assign d_in_mem = (d_mem_we) ?  d_mem_data : 64'bz;


//Instanciação das entradas RF
wire [4:0] Ra;
wire [4:0] Rb;
wire [4:0] Rw;
wire [63:0] RF_in;

//Instanciação dos functions
wire [2:0] func3;
wire [6:0] func7;

//Instanciação das saídas RF
wire [63:0] dout_B;
wire [63:0] dout_A;

//Instanciação dos Imediatos
wire [11:0] imme_I;
wire [63:0] imme_I_64;
wire [11:0] imme_S;
wire [63:0] imme_S_64;
wire [19:0] imme_B;
wire [63:0] imme_B_64;
wire [19:0] imme_J;
wire [63:0] imme_J_64;
wire [19:0] imme_U;
wire [63:0] imme_U_64;
wire [63:0] imme_m;

//Instanciação dos fios do circuito ALU
wire [63:0] ALU_out_int;
wire [63:0] ALU_B;
wire [1:0] sel_ALU;

//Instanciação dos fios do circuito PC
//wire [19:0] PC_A;
wire [19:0] PC_B;
wire [19:0] PC_sum;
wire [19:0] PC_out_int; 
//wire [63:0] PC_RF;
//wire [63:0] PC_RF_sum;


//Instanciação da saída do IR
wire [31:0] IR_out;

//Atribuição dos sinais vinculado às instruções
assign Ra = IR_out[19:15];
assign Rb = IR_out[24:20];
assign Rd = IR_out [11:7];
assign func3 = IR_out [14:12];
assign func7 =IR_out [31:25];
assign opcode = IR_out [6:0];

//Atribuição dos imediatos
assign imme_I = IR_out[31:20];
assign imme_S = {IR_out[31:25],IR_out[11:7]};
assign imme_B = {IR_out[31],IR_out[7],IR_out[30:25],IR_out[11:8], 1'b0};
assign imme_J = {IR_out[31],IR_out[19:12],IR_out[20], IR_out[30:21],1'b0};
assign imme_U = {IR_out [31:12], 12'b0};

//Extensão dos imediatos

assign imme_I_64 = (imme_I[11])? {1111111111111111111111111111111111111111111111111111,imme_I}:{0000000000000000000000000000000000000000000000000000,imme_I};
assign imme_S_64 = (imme_S[11])? {1111111111111111111111111111111111111111111111111111,imme_S}:{0000000000000000000000000000000000000000000000000000,imme_S};
assign imme_B_64 = {51'b0, imme_B};
assign imme_J_64 = {43'b0, imme_J};
assign imme_U_64 = {32'b0, imme_J};


//Multiplexadores do imediato

assign imme_m = (alu_cmd == 3'b0001) ? imme_I_64 :
               (alu_cmd == 3'b0010) ? imme_S_64 :
               (alu_cmd == 3'b0011) ? imme_B_64 :
               (alu_cmd == 3'b0100) ? imme_U_64 :
               (alu_cmd == 3'b0101) ? imme_J_64 :
               64'b0;

//Instanciacao do RF
RF RF_dp #(64) (
    .reg_r1(Ra),
    .reg_r2(Rb),
    .reg_w(Rw),
    .data_in(RF_in),
    .en_write(rf_we), 
    .clk(clk),
    .dout_r1(dout_A),
    .dout_r2(dout_B)
);


//Instanciação da ALU 
assign ALU_B = (alu_src)? dout_B: imme_m;

assign sel_ALU = (alu_cmd != 4'b0) ? 2'b0 : 
                 ((func7 != 7'b0) ? 2'b01 : 
                 ((func3 == 3'b0) ? 2'b0  : 
                 ((func3 == 3'd7) ? 2'b10 : 2'b11)));

ALUV2 ALU_dp #(64) (
    .A(dout_A),
    .B(ALU_B),
    .result (ALU_out_int),
    .sel_alu (sel_ALU),
    .flag_beq (alu_flags[3]),
    .flag_bnq(),
    .flag_blt (),
    .flag_bge (),
    .flag_bltu (),
    .flag_zero(alu_flags[0]),
    .flag_msb(alu_flags[1]),
    .flag_over(alu_flags[2])
    );

//Instanciação do PC

registrador_pc PC_dp #(i_addr_bits)(
    .D (PC_sum),
    .Q(PC_out_int),
    .clk(clk),
    .load(1'b1)    
    );

//Instanciação do somador do PC

assign PC_B = (sel_PC_B)? i_addr_bits'd4: imme_m[i_addr_bits-1:0];

sum_sub somador_PC #(i_addr_bits) (
    .A(PC_out_int),
    .B(PC_B),
    .result(PC_sum),
    .substract(1'b0)
    );

// //Instanciação circuito PC_RF

// assign PC_RF_sum = (sel_PC_RF)? 64'd4: imme_m;

// sum_sub somador_PC_RF #(64) (
//     .A(PC_RF_sum),
//     .B({44'b0, PC_out_int}),
//     .result(PC_RF),
//     .substract(1'b0)
//     );

//Instanciação da IR
registrador IR_dp #(32)(
    .D(i_mem_data),
    .Q(IR_out),
    .load(1'b1),
    .clk(clk)
    );


//Instanciação do MUX da entrada do RF

assign RF_in = (rf_src == 2'b00) ? ALU_out_int :
               (rf_src == 2'b01) ? d_in_pro :
               64'b0; // Valor padrão caso nenhuma condição seja satisfeita

//Atribuição dos sinais de saída

assign d_mem_addr = ALU_out_int;
assign i_mem_addr = PC_out_int;

endmodule