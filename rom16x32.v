module rom16x32 (
    input [3:0] endereco,
    input clk,
    output [31:0] saida
);

     reg [32:0] rom [15:0];
     
    initial begin
        rom[0]= {12'd9, 5'd0, 3'd3, 5'd2, 7'd3}; //  lw x2, #9(x0)
        rom[1]= {12'd5, 5'd2, 3'd0, 5'd1, 7'd19}; //  addi x1, x2,#5
        rom[2]= {7'b0000000, 5'd1, 5'd0, 3'd2, 5'b00101, 7'd35}; //  sw x1, #5 (x0)
        rom[3]= {12'd5, 5'd0, 3'd2, 5'd3, 7'd3}; //  lw x3,#5 (x0)
        rom[4]= {12'b111111110111, 5'd3, 3'd3, 5'd7, 7'd19}; //addi x7,x3, #-9
        rom[5]= {7'd0, 5'd1, 5'd3, 3'd0, 5'd4, 7'd51}; // add x4, x3, x1
        rom[6]= {7'b0000000, 5'd1, 5'd3, 3'd0, 5'd4, 7'd99}; //beq x1, x3, #2
        rom[7]= {12'd3, 5'd2, 3'd0, 5'd4, 7'd19}; //  addi x4, x2,#3
        rom[8]= {12'd19, 5'd0, 3'd0, 5'd27, 7'd19}; //  addi x27, x0,#19
        rom[9]= {12'd6, 5'd0, 3'd0, 5'd13, 7'd19}; //  addi x13, x0,#6
        rom[10]= {12'd59, 5'd0, 3'd0, 5'd18, 7'd19}; //  addi x18, x0,#59
        rom[11]= {7'd32, 5'd2, 5'd3, 3'd0, 5'd5, 7'd51}; // sub x5, x3, x2
        rom[12]= {12'd5, 5'd2, 3'd0, 5'd9, 7'd19}; //  addi x9, x2,#5
        rom[13]= 32'h00000000; 
        rom[14]= 32'h00000000; 
        rom[15]= 32'h00000000; 
        end


   assign saida = rom[endereco];
   

    

endmodule
