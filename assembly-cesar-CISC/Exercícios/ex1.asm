;Leitura de caracter com eco e fila

	MOV #65499, R5	;MOVE A POSIÇÃO DE MEMÓRIA DO ÚLTIMO VALOR LIDO PELO TECLADO
	MOV #65498, R3	;MOVE A POSIÇÃO DE MEMÓRIA DO ESTADO DO TECLADO
	MOV #65500, R1	;MOVE A PRIMEIRA POSIÇÃO DE MEMÓRIA DO VETOR
retorna:
	CLR (R3)		;ZERA O ESTADO DO TECLADO
teste:
	TST (R3)		;FICA TESTANDO ATÉ RECEBER ALGUM INPUT DO TECLADO
	BEQ teste		;BRANCH EQUAL (SE O RESULT DE TST NÃO FOR "OK")
	MOV (R5), (R1)	;MOVE O ULTIMO INPUT LIDO PELO TECLADO PRA PRIMEIRA POSIÇÃO DO VISOR
	INC R1			;COLOCA A PRÓXIMA POSIÇÃO DO VETOR PRA JOGO	
	BR retorna		;BRANCH PRA FAZER TUDO DENOVO



