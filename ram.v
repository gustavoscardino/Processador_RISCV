/* Grupo 15
Aluno: Pedro Freitas Fassini, NUSP: 12566571
Aluno: Antônio Freitas Fassini, NUSP:12551032 
Aluno: Gustavo Scardino, NUSP: 11797229 
Arquivo: Código de uma memória RAM*/



module ram(
    input clk,
    input [4:0] endereco,
    input we,
    input [63:0] dataIn,
    output [63:0] dataOut
    );


//criação da memória usando arrays
    reg [63:0] mem[31:0];


//definindo operação de leitura
    assign dataOut = mem[endereco];


//definindo operação de escrita

    always @(posedge clk) begin
        if (we) begin
            mem[endereco] <= dataIn;
        end
    end

//inicialização dos valores de memória (para uso futuro em simulações)

    integer i;
    initial begin
        for ( i= 1; i<32; i=i+1) begin
          mem[i] = 64'h0000000000000000 + i + 3;
        end
    
    end
    initial mem[0]=64'h0000000000000000 + 5;


endmodule