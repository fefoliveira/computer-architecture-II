;Fa�a um programa que implemente o c�digo C abaixo. 
;Considere a posi��o de mem�ria do vetor na posi��o 0 (v[0]) como 200 em decimal.

;	for(i=1; i<10; i++){
;		if (v[i+1] <= v[i]) 
;			v[i+1] = v[i] *2i;
;	}

LDR X #1		;INDICE DO VETOR (i)
LDR A 200		;CARREGA O PRIMEIRO VALOR DO VETOR EM A

IF:
STR X 199		;GUARDA O VALOR ORIGINAL DE X EM 199
ADD X #2		;"i+1"
LDR B 199, X	;CARREGA "v[i+1]" EM B
STR A 198
SUB B 198		;B-A ----- TESTE "v[i+1] <= v[i]"
JZ XXA
JN XXA
LDR X 199		;X VOLTA AO VALOR ORIGINAL
JMP WHILE

FOR:
ADD X #2
LDR A 199, X	;CONTROLE DOS VALORES DO VETOR
JMP IF

WHILE:			;TESTE  "i<10" DO FOR
SUB X #19		;19 = LOOP DE 9 VEZES
JZ FIM
LDR X 199
JMP FOR

XXA:				
LDR X 199		;X VOLTA AO VALOR ORIGINAL
SUB X #1
JZ XXC
JN XXC

XXB:
ADD X 199		;2i
STR X 197		;end197	 = 2i
LDR B 197		;B = 2i
SUB B #1
JMP MULT

XXC:
LDR X 199
JMP XXB

MULT:
ADD A 198		;A+A ----- A AINDA ESTAVA EM 198
SUB B #1
JZ RECEBE
JMP MULT

RECEBE:	
LDR X 199
STR A 201, X
JMP FOR

FIM:
HLT

ORG 200
DB 6
DB 0
DB 2
DB 0
DB 3
DB 0
DB 7
DB 0
DB 5
DB 0
DB 6
DB 0
DB 12
DB 0
DB 8
DB 0
DB 9