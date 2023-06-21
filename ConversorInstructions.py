def toInstruction_LW(imme, rs1, rd):
    # Conversão dos números inteiros para strings binárias formatadas
    imme_bin = "12'd" + str(imme)
    rs1_bin = "5'd" + str(rs1) 
    rd_bin = "5'd" + str(rd) 

    # Concatenação dos campos da instrução
    machine_code = "{" + imme_bin + " , " + rs1_bin + " , " + "010" + " , " + rd_bin + " , "+ "0000011" + "}"

    return machine_code


def toInstruction_SW(imme, rs1, rs2):
    # Conversão dos números inteiros para strings binárias formatadas
    imme_bin = format(imme, '012b')

    # Extração dos bits dos campos imme
    imme_bin_1 = imme_bin[0:7]
    imme_bin_2 = imme_bin[7:12]

    # Concatenação dos campos da instrução
    machine_code = "{{7'b{0}, 5'd{1}, 5'd{2}, 010, 5'b{3}, 0000011}}".format(imme_bin_1, rs2, rs1, imme_bin_2)

    return machine_code

def toInstruction_B(imme, rs1, rs2):
    # Conversão dos números inteiros para strings binárias formatadas
    imme_bin = format(imme, '013b')

    # Extração dos bits dos campos imme
    imme_bin_1 = imme_bin[0]
    imme_bin_2 = imme_bin[2:8]
    imme_bin_3 = imme_bin[8:12]
    imme_bin_4 = imme_bin[1]

    # Concatenação dos campos da instrução
    machine_code = "{{7'b{0}{1}, 5'd{2}, 5'd{3}, 000, 5'b{4}{5}, 1100011}}".format(imme_bin_1, imme_bin_2, rs2, rs1, imme_bin_3, imme_bin_4)

    return machine_code



def toInstruction_Add(rs1, rs2, rd):
    # Conversão dos números inteiros para strings binárias formatadas
 
    # Concatenação dos campos da instrução
    machine_code = "{{0000000, 5'd{0}, 5'd{1}, 000, 5'b{2}, 0110011}}".format(rs2, rs1, rd)

    return machine_code


def toInstruction_Sub(rs1, rs2, rd):
    # Conversão dos números inteiros para strings binárias formatadas
 
    # Concatenação dos campos da instrução
    machine_code = "{{0100000, 5'd{0}, 5'd{1}, 000, 5'b{2}, 0110011}}".format(rs2, rs1, rd)

    return machine_code

def toInstruction_And(rs1, rs2, rd):
    # Conversão dos números inteiros para strings binárias formatadas
 
    # Concatenação dos campos da instrução
    machine_code = "{{0000000, 5'd{0}, 5'd{1}, 111, 5'b{2}, 0110011}}".format(rs2, rs1, rd)

    return machine_code




# Exemplo de uso da função
imme = 10
rs1 = 0
rs2 = 1
rd=2
instruction_1 = toInstruction_LW(imme, rs1, rd)
instruction_2 = toInstruction_SW(imme, rs1, rs2)
instruction_3 = toInstruction_B(imme, rs1, rs2)
instruction_4 = toInstruction_Add(rs1, rs2, rd)
instruction_5 = toInstruction_Sub(rs1, rs2, rd)
instruction_6 = toInstruction_And(rs1, rs2, rd)


print(instruction_2)