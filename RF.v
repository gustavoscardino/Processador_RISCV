
/* Grupo 15
Aluno: Pedro Freitas Fassini, NUSP: 12566571
Aluno: Antônio Freitas Fassini, NUSP:12551032 
Aluno: Gustavo Scardino, NUSP: 11797229
Arquivo: Código do Register File*/


module RF (
input  [4:0] reg_r1, reg_r2,
input [4:0] reg_w,
input [63:0] data_in,
input en_write, 
input clk,
output [63:0] dout_r1,
output [63:0] dout_r2
);

//Instanciação do wire matricial para auxiliar na instanciação dos registradores

wire [63:0] rf [31:0];

//Instanciação do banco de 32 registradores 

genvar i;
generate
    for (i = 1; i < 32; i = i + 1) begin : inst_regi
        registrador #(
            .N(64)
        ) regi_middle (
            .D(data_in),
            .load(en_write && reg_w == i), //aqui garante-se que a operação de escrita só aconteça com o registrador especificado
            .clk(clk),
            .Q(rf[i])
        );
    end
endgenerate 


//Conexão das saídas do banco de registradores nas saídas do módulo

assign dout_r1 = (reg_r1==0)?5'b00000:rf[reg_r1];

assign dout_r2 = (reg_r2==0)?5'b00000:rf[reg_r2];

endmodule