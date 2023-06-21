/* Grupo 15
Aluno: Pedro Freitas Fassini, NUSP: 12566571
Aluno: Antônio Freitas Fassini, NUSP:12551032 
Aluno: Gustavo Scardino, NUSP: 11797229 
Arquivo: Código de uma memória RAM*/



module ram(
    input clk,
    input [4:0] endereco,
    input d_mem_we,
    inout [63:0] d_mem_data
    );





//criação da memória usando arrays
    reg [63:0] mem[31:0];
    wire [63:0] saida_mem;


//definindo operação de leitura
    assign saida_mem = mem[endereco];
    
//atribuição do inout
assign d_mem_data = (d_mem_we)? 64'bz: saida_mem;

//definindo operação de escrita

    always @(posedge clk) begin
        if (d_mem_we) begin
            mem[endereco] <= d_mem_data;
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