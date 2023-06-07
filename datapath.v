
module datapath (
    input [31:0] IM_out ,
    input [63:0] DM_out ,
    input clk, we_RF, load_IR, load_PC, //loads e enables
    input sel_ALU_A, sel_ALU_B, sel_PC_A, sel_PC_B, sel_PC_RF//selecionadores (MUX) 
    input [2:0] sel_imme,
    input [1:0] sel_RF_in,
    output [63:0] ALU_out, //vai pra RAM
    output [19:0] PC_out, //vai pra ROM
    output [6:0] opcode //vai pra UC
    //faltam flags de saída
);
    
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
wire [63:0] ALU_A;
wire [63:0] ALU_B;
wire [1:0] sel_ALU;

//Instanciação dos fios do circuito PC
wire [19:0] PC_A;
wire [19:0] PC_B;
wire [19:0] PC_sum;
wire [19:0] PC_out_int; 
wire [63:0] PC_RF;
wire [63:0] PC_RF_sum;


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

assign imme_m = (sel_imme == 3'b000) ? imme_I_64 :
               (sel_imme == 3'b001) ? imme_S_64 :
               (sel_imme == 3'b010) ? imme_B_64 :
               (sel_imme == 3'b011) ? imme_J_64 :
               (sel_imme == 3'b100) ? imme_U_64 :
               64'b0;


//Instanciação da ALU 


assign ALU_A = (sel_ALU_A)? dout_A: imme_m;
assign ALU_B = (sel_ALU_B)? dout_B: imme_m;
assign sel_ALU = (func7 == 7'b0)? 2'b00: 2'b01; 

ALU ALU_dp #(64) (
    .A(ALU_A),
    .B(ALU_B),
    .result (ALU_out_int),
    .sel_alu (sel_ALU),
    .flag_beq (),
    .flag_bnq(),
    .flag_blt (),
    .flag_bge (),
    .flag_bltu (),
    .flag_bgeu()    
    );

//Instanciação do PC

registrador_pc PC_dp #(20)(
    .D (PC_sum),
    .Q(PC_out_int),
    .clk(clk),
    .load(load_PC)    
    );

//Instanciação do somador do PC

assign PC_A = (sel_PC_A)? PC_out_int: dout_A[19:0];
assign PC_B = (sel_PC_B)? 20'd4: imme_m[19:0];

sum_sub somador_PC #(20) (
    .A(PC_A),
    .B(PC_B),
    .result(PC_sum),
    .substract(1'b0)
    );

//Instanciação circuito PC_RF

assign PC_RF_sum = (sel_PC_RF)? 64'd4: imme_m;

sum_sub somador_PC_RF #(64) (
    .A(PC_RF_sum),
    .B({44'b0, PC_out_int}),
    .result(PC_RF),
    .substract(1'b0)
    );

//Instanciação da IR
registrador IR_dp #(32)(
    .D(IM_out),
    .Q(IR_out),
    .load(load_IR),
    .clk(clk)
    );


//Instanciação do MUX da entrada do RF

assign RF_in = (sel_RF_in == 2'b00) ? ALU_out_int :
               (sel_RF_in == 2'b01) ? DM_out :
               (sel_RF_in == 2'b11) ? PC_RF :
               64'b0; // Valor padrão caso nenhuma condição seja satisfeita

//Atribuição dos sinais de saída

assign ALU_out = ALU_out_int;
assign PC_out = PC_out_int;






endmodule