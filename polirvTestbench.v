module polirv_testbench;
    // Parâmetros do módulo polirv
    parameter i_addr_bits = 6;
    parameter d_addr_bits = 6;
    
    // Sinais de controle
    reg clk;
    reg rst_n;
    
    // Sinais de entrada do módulo polirv
    wire [i_addr_bits-1:0] i_mem_addr;
    wire [31:0] i_mem_data;
    
    // Sinais de saída do módulo polirv
    wire d_mem_we;
    wire [d_addr_bits-1:0] d_mem_addr;
    wire [63:0] d_mem_data;
    
    // Instância do módulo polirv
    polirv #(
        .i_addr_bits(i_addr_bits),
        .d_addr_bits(d_addr_bits)
    ) polirv_inst (
        .clk(clk),
        .rst_n(rst_n),
        .i_mem_addr(i_mem_addr),
        .i_mem_data(i_mem_data),
        .d_mem_we(d_mem_we),
        .d_mem_addr(d_mem_addr),
        .d_mem_data(d_mem_data)
    );
    
    // Instância da memória ROM
    rom64x32 rom_inst (
        .endereco(i_mem_addr),
        .clk(clk),
        .saida(i_mem_data)
    );

    // Instância da memória RAM
    ram ram_inst (
        .clk(clk),
        .endereco(d_mem_addr),
        .we(d_mem_we),
        .d_mem_data(d_mem_data)
    );
    
    // Gerador de clock
    always #5 clk = ~clk;
    
    // Testbench inicialização
    initial begin
        // Inicialização dos sinais de controle
        clk = 0;
        rst_n = 1;

        
        // Inicialização da memória ROM
        // TODO: Inserir os dados desejados na memória ROM
        
        // Inicialização da memória RAM
        // TODO: Inserir os dados desejados na memória RAM
        
        // Aguardar alguns ciclos de clock antes de aplicar o reset
        #10;
        
        // Aplicar o reset
        rst_n = 0;
        
        // Aguardar mais alguns ciclos de clock antes de remover o reset
        #10;
        
        // Remover o reset
        rst_n = 1;
        
        // Ciclos de clock para execução
        #100;
        
        // Encerrar a simulação
        $finish;
    end
    
    // Testbench estímulo
    always begin
        // TODO: Definir os estímulos de entrada para os módulos
        
        // Aguardar um ciclo de clock
        #1;
    end
endmodule