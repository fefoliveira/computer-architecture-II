;Faça um programa que considere um vetor com valores inteiros. Deve ser verificado
;quantos números do vetor são múltiplos de 8. 

LDR X #0        ;zerando registadores
LDR B #0        ;    "            "

LOOP:
LDR A 128, X    ;CARREGA VALOR

DIV8: 
AND A #7        ;00000111 (TODOS OS VALORES DEPOIS DE 8 NÃO IMPORTAM)
JZ INC             ;INCREMENTA UM NO B
SUB A #7        ;TESTE PARA CONDIÇÃO DE SAÍDA
JZ DEC            ;CONDIÇÕES DE SAÍDA
JN DEC            ;     "        "    "    

DEC:
ADD X, #1        ;INCREMENTA ÍNDICE
STR X 127        ;PUSH ÍNDICE
SUB X #10        ;TESTE PARA CONDIÇÃO DE SAÍDA (EXISTEM 10 VALORES NESTE VETOR)
JZ HALT            ;CONDIÇÃO DE SAÍDA
LDR X 127        ;POP ÍNDICE
JMP LOOP        ;VOLTA PARA O INÍCIO DO PROGRAMA

INC:
ADD B #1        ;INC CONTADOR PARA CONTABILIZAÇÃO
JMP DEC        

HALT:
STR B 126        ;CONTABILIZAÇÃO FINAL
NOP
HLT

ORG 128
DB 8
DB 16
DB 33
DB 127
DB 255
DB 0
DB 3
DB 2
DB 5
DB 94










