;Fa�a um programa que soma todas as posi��es de um vetor de 10 posi��es
;e guarda o resultado no endere�o 200 (preencher de 128 a 138).

LDR X #0
LDR B #246	;00001010 
			;11110101 
			;11110110 
LDR A 128

LOOP:
ADD X #2
ADD A 128, X
ADD B #1
JN LOOP
STR A 200
HLT

ORG 128
DB 1
DB 0
DB 2
DB 0
DB 3
DB 0
DB 4
DB 0
DB 5
DB 0
DB 6
DB 0
DB 7
DB 0
DB 8
DB 0
DB 9
DB 0
DB 10
