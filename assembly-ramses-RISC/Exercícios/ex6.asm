;Implemente um programa no assembly Ramses que leia o vetor A de 10 posições e:
;- se o valor for ímpar, o valores devem ser coppiados para o vetor X[0];
;- se o valor for múltiplo de 4, copiar os valores para o vetor iniciadoem Y[0];
;- se não atender nenhuma das condições anteriores, copiar o vetor iniciado em Z[0].
; INDIRETO

X1:				;TESTE NÚMERO ÍMPAR
LDR A 170, I
AND A #1		;AND PRA TESTAR SE É IMPAR
JZ Y			;QUANDO AND RESULTAR EM 0, ENTÃO A É PAR
LDR A 170, I	;A VOLTA AO VALOR ORIGINAL	;
STR A 171, I	;GUARDA O VALOR ÍMPAR EM SEU RESPECTIVO VETOR
LDR B 171		;ACRESCIMO NO "ÍNDICE" DO VETOR E MULT. DE 4
ADD B #1
STR B 171


DENOVO:			;CONTROLE DO ÍNDICE X
LDR X 129	
SUB X #9
JZ FIM
LDR X 129
ADD X #1
STR X 129
LDR B 170		;ACRESCIMO NO "ÍNDICE" DO VETOR PRINCIPAL
ADD B #1
STR B 170
JMP X1


Y:				;MULTIPLOS DE 4
LDR A 170, I                                 
AND A #3		;AND PRA TESTAR SE É MULTIPLO DE 4
JZ Y2


Z:				;NÃO ATENDEU NEM X NEM Y
LDR A 170, I
STR A 173, I	;GUARDA O VALOR DE A NO VETOR Z
LDR B 173		;INCREMENTA O VETOR Z
ADD B #1
STR B 173
JMP DENOVO

Y2:				;CONTINUAÇÃO MULTIPLO DE 4
LDR A 170, I	
STR A 172, I
LDR B 172
ADD B #1
STR B 172
JMP DENOVO


FIM:		
HLT


ORG 129			;DB DO ÍNDICE GERAL (X)
DB 0

ORG 130			;DB DO VETOR PRINCIPAL
DB 2
DB 5
DB 8
DB 7
DB 9
DB 11
DB 12
DB 10
DB 4
DB 6

ORG 170			;DB DAS POSIÇÕES INDIRETAS DOS VETORES
DB 130
DB 140
DB 150
DB 160