/* Grupo 15
Aluno: Pedro Freitas Fassini, NUSP: 12566571
Aluno: Antônio Freitas Fassini, NUSP:12551032 
Aluno: Gustavo Scardino, NUSP: 11797229
Arquivo: Código do Registrador Parametrizável*/



module registrador_pc #(parameter N=64) 
(
    input [N-1:0] D,
    input load,
    input clk,
    output  reg signed [N-1:0] Q
);
    


always @(posedge clk ) begin
    
    if (load) Q <= D;
end

initial begin
    Q =64'd0;
end

endmodule