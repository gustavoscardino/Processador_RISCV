module unidade_controle(
    input clk, rst_n,                       // clock borda subida, reset assíncrono ativo baixo
    input [6:0] opcode,                     // OpCode direto do IR no FD
    output d_mem_we, rf_we,                 // Habilita escrita na memória de dados e no banco de registradores
    input  [3:0] alu_flags,                 // Flags da ULA
    output [3:0] alu_cmd,                   // Operação da ULA
    output alu_src, pc_src, rf_src          // Seletor dos MUXes
);  

  // Definição dos estados
  parameter FETCH           = 4'b0000;
  parameter DECODE          = 4'b0001;
  parameter EX_ADD          = 4'b0010;
  parameter EX_ADDI         = 4'b0011;
  parameter EX_LW           = 4'b0100;
  parameter EX_SW           = 4'b0101;
  parameter EX_BRANCH       = 4'b0110;
  parameter EX_JAL          = 4'b0111;
  parameter EX_JALR         = 4'b1000;
  parameter EX_AUIPC        = 4'b1001;
  parameter WRITEBACK       = 4'b1010;


  // Parametrizacao dos opc
  parameter ADD          = 7'b0110011;
  parameter ADDI         = 7'b0010011;
  parameter LW           = 7'b0000011;
  parameter SW           = 7'b0100011;
  parameter BRANCH       = 7'b1100011;
  parameter JAL          = 7'b1101111;
  parameter JALR         = 7'b1100111;
  parameter AUIPC        = 7'b0010111;

  
  // Declaração dos registradores
  reg [3:0] estado_atual;
  reg [3:0] proximo_estado;
  
  // Atribuição do estado inicial
  initial estado_atual = FETCH;
  
  // Definição da máquina de estados
  always @(posedge clk) begin
    case (estado_atual)
        FETCH:
            if (rst_n)
                proximo_estado =  FETCH;
            else
                proximo_estado = DECODE;
        DECODE:
            case (opcode)

            ADD:
                proximo_estado = EX_ADD;
            ADDI:
                proximo_estado = EX_ADDI;
            LW:
                proximo_estado = EX_LW;
            SW:
                proximo_estado = EX_SW;
            BRANCH:
                proximo_estado = EX_BRANCH;
            // JAL:
            //     proximo_estado = EX_JAL;
            // JALR:
            //     proximo_estado = EX_JALR;
            // AUIPC:
            //     proximo_estado = EX_AUIPC;
            endcase
        EX_ADD, EX_ADDI, EX_LW, EX_SW, EX_BRANCH, EX_JAL, EX_JALR, EX_AUIPC:
            proximo_estado = WRITEBACK;
        WRITEBACK:
            proximo_estado = FETCH;
    endcase
    estado_atual <= proximo_estado;
  end
    
  
  // Definição das saídas
    assign alu_src = (estado_atual == EX_LW | estado_atual == EX_SW);
    assign rf_src = (estado_atual == EX_LW);
    assign pc_src = ((estado_atual == EX_BRANCH) & (alu_flags[3]));
    assign d_mem_we = (estado_atual == EX_SW);
    assign rf_we = (estado_atual == EX_ADD | estado_atual == EX_LW);
    // alu_cmd
    assign alu_cmd[3] = 1'b0;
    assign alu_cmd[2] = 1'b0;
    assign alu_cmd[1] = (estado_atual == EX_SW | estado_atual == EX_BRANCH);
    assign alu_cmd[0] = (estado_atual == EX_LW | estado_atual == EX_BRANCH);


endmodule