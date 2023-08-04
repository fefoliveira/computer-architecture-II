MOV #65535, R0	;tira o "?" do fim do visor
CLR (R0)
;
MOV R1, 19999
MOV #65498, R1			;estado do teclado
MOV #65499, R2			;último caractere digitado
MOV #65500, R3			;primeira posição do visor
MOV #9099, R5			;#9100 = primeira posição do vetor com a palavra salva
MOV #5099, R0			;#5100 = primeira posição da frase de cadastro

CADASTRE:				;função que imprime a mensagem de cadastro
	MOV (R0), (R3)
	INC R0
	INC R3
	INC R4
	CMP R4, #34
	BNE CADASTRE
	CLR R0
	CLR R4
	
INICIO:
  	TST (R1)			;testa se a posição de estado do teclado foi alterada (se um caracter foi digitado)
	BEQ INICIO
	CMP (R2), #13		;verifica se o último caractere foi "enter"
	BEQ CRIA_UNDERLINE
	
	;consiste se o caractere digitado é uma LETRA MAIÚSCULA
	CMP (R2), #65
	BLT INICIO_ERROU
	CMP (R2), #90
	BGT INICIO_ERROU
	JMP INICIO_CONTINUA	

INICIO_ERROU:			;previne qualquer bug nos inputs da palavra de cadastro, caso algum caractere não maíusculo seja inserido
	CLR (R1)
	CLR (R2)
	JMP INICIO

INICIO_CONTINUA:	
	;salvamento do caractere recém digitado no vetor #9100:
	MOV (R2), (R5)
	INC R5
	INC R5
	
	;contador de quantos caracteres foram digitados na palavra de cadastro
	INC R0				
	
	CMP R4, #0			;garante que vai ir para LIMPA somente uma vez
	BEQ LIMPA
UNDERLINE:				;imprime o underline a cada caractere digitado
	MOV #95, (R3)
	INC R3
	CLR (R1)
	CLR (R2)
	JMP INICIO
	
LIMPA:					;limpa a mensagem de cadastro do visor após receber uma entrada válida
	MOV #1, R4
	CLR (R3)
	CMP R3, #65500
	BEQ UNDERLINE
	DEC R3
	JMP LIMPA
	
;------------------

;criação do vetor de underlines:
CRIA_UNDERLINE:			
	MOV #10099, R3
	MOV #0, R4
CRIA_UNDERLINE_2:
	MOV #95, (R3)
	INC R3
	INC R3
	INC R4
	CMP R4, R0
	BNE CRIA_UNDERLINE_2
	CLR R4
;

	;cria o contador de erros no visor:
	MOV #65535, R3
	MOV #48, (R3)
	MOV (R3), 19999
	;
	
;------------------
	
;limpa o visor depois de clicar "enter" após o cadastro:
LIMPA_ENTER:			
	MOV #65500, R3
	ADD R0, R3
LIMPA_ENTER_2:
	CLR (R3)
	DEC R3
	CMP R3, #65500
	BNE LIMPA_ENTER_2
	MOV #6099, R4		;coloca a primeira posição da mensagem do "menu"
;
	
IMPRIME_OP:				;imprime o "menu" de opções
	MOV (R4), (R3)
	INC R3
	INC R4
	CMP R3, #65526
	BNE IMPRIME_OP
	INC R3
	MOV #65498, R1
	CLR (R1)
	CLR (R2)
	
INICIO2:				;consiste a seleção de opção do "menu"
	TST (R1)
	BEQ INICIO2
	
	CMP (R2), #49		;#49 = 1 em ASCII
	BLT INICIO2_ERROU
	CMP (R2), #50		;#50 = 2 em ASCII
	BGT INICIO2_ERROU
	JMP LIMPA_OP

INICIO2_ERROU:			;previne qualquer bug no input, caso algum caractere não maíusculo seja inserido
	CLR (R1)
	CLR (R2)
	JMP INICIO2
	
LIMPA_OP:				;limpa o menu de opções
	CLR (R3)
	DEC R3
	CMP R3, #65499
	BNE LIMPA_OP
	
;------------------
	
SELECAO:
	;chamada da subrotina que imprime os underlines:
	JSR R4, IMPRIME_UNDERLINE
	;
	CLR (R1)
	;designa para qual função vai com base no número digitado no menu:
	CMP (R2), #49		;#49 = 1 em ASCII
	BEQ F1
	CMP (R2), #50		;#50 = 2 em ASCII
	BEQ TP_F2
	;

;------------------
TP_LIMPA_ENTER:
	JMP LIMPA_ENTER

TP_F2:
	JMP F2
;------------------

;---------------------------------------------
F1:						;função que trabalha a opção selecionada = 1
	TST (R1)
	BEQ F1

	;consiste se o caractere digitado é uma LETRA MAIÚSCULA:
	CMP (R2), #65
	BLT F1_F1_ERROU
	CMP (R2), #90
	BGT F1_F1_ERROU
	JMP F1_CONTINUA
	;
	
F1_F1_ERROU:			;previne qualquer bug no input, caso algum caractere não maíusculo seja inserido
	CLR (R1)
	CLR (R2)
	JMP F1
	
F1_CONTINUA:			;apenas uma continuação de F1
	MOV #0, R1
	MOV #0, R3
	MOV #10099, R4
	MOV #9099, R5

;confere se o valor inserido é igual a cada uma das letras da palavra cadastrada:
F1_CONFERE:
	CMP (R2), (R5)
	BEQ F1_SUBSTITUI
F1_CONFERE_2:
	INC R4
	INC R4
	INC R5
	INC R5
	INC R1
	CMP R1, R0
	BNE F1_CONFERE
	CMP R3, #0
	BEQ F1_ERRO
	JMP F1_COMPARA
;	

F1_SUBSTITUI:			;caso a letra inserida esteja correta, substitui essa no vetor de underlines
	MOV (R2), (R4)
	CMP R3, #0
	BEQ F1_IMPRIME_ACERTOU
	JMP F1_CONFERE_2 

F1_ERRO:				;faz todos os procedimentos necessários quando a conferência acabou e a letra inserida não foi igual a nenhuma outra da palavra cadastrada
	MOV #19999, R4
	;quando a quantia de erros for igual a 6, começa o processo de exibição de perda:
	CMP (R4), #54 
	BEQ TP_LIMPA_PERDEU_1
	;
	INC (R4)
	MOV #65535, R3
	MOV (R4), (R3)
	;quando a quantia de erros for igual a 6, começa o processo de exibição de perda:
	CMP (R4), #54 
	BEQ TP_LIMPA_PERDEU_1
	;
	JMP F1_IMPRIME_ERROU

;------------------
TP2_LIMPA_ENTER:
	JMP TP_LIMPA_ENTER
;------------------

;------------------------------
;imprime a mensagem de acerto:
F1_IMPRIME_ACERTOU:	
	MOV #65500, R3
	MOV R4, 13999
	MOV #12099, R4
F1_IMPRIME_ACERTOU_2:
	MOV (R4), (R3)
	INC R4
	INC R3
	CMP R3, #65513
	BNE F1_IMPRIME_ACERTOU_2
;

;"timer" pra exibir a mensagem de acerto por mais um tempo:
TIMER_ACERTOU:
	MOV R1, 12999
	MOV #0, R1
TIMER_ACERTOU_2:
	INC R1
	CMP R1, #45
	BNE TIMER_ACERTOU_2
;

LIMPA_ACERTOU:			;limpa a mensagem de acerto após o termino do "timer"
	CLR (R3)
	DEC R3
	CMP R3, #65499
	BNE LIMPA_ACERTOU
	MOV 12999, R1
	MOV #1, R3
	MOV 13999, R4
	JMP F1_CONFERE_2
;------------------------------

;------------------
TP_LIMPA_PERDEU_1:
	JMP LIMPA_PERDEU_1
TP3_LIMPA_ENTER:
	JMP TP2_LIMPA_ENTER
;------------------

;------------------------------
;imprime a mensagem de erro:
F1_IMPRIME_ERROU:
	MOV #65500, R3
	MOV #16099, R4
F1_IMPRIME_ERROU_2:
	MOV (R4), (R3)
	INC R4
	INC R3
	CMP R3, #65511
	BNE F1_IMPRIME_ERROU_2
;

;"timer" pra exibir a mensagem de erro por mais um tempo:
TIMER_ERROU:
	MOV #0, R1
TIMER_ERROU_2:
	INC R1
	CMP R1, #45
	BNE TIMER_ERROU_2
;
	
LIMPA_ERROU:			;limpa a mensagem de erro após o termino do "timer"
	CLR (R3)
	DEC R3
	CMP R3, #65499
	BNE LIMPA_ERROU
	MOV #65498, R1
	MOV #65500, R3
	JMP TP2_LIMPA_ENTER
;------------------------------
;testa para ver se todas as letras foram encontradas
F1_COMPARA:
	MOV R1, 12999
	MOV #0, R1
	MOV R4, 13999
	MOV #10099, R4
	MOV #9099, R5
F1_COMPARA_2:	
	CMP (R4), (R5)
	BNE TP3_LIMPA_ENTER
	INC R4
	INC R4
	INC R5
	INC R5
	INC R1
	CMP R1, R0
	BEQ TP_LIMPA_GANHOU_1
	JMP F1_COMPARA_2

;---------------------------------------------

;---------------------------------------------
F2:						;função que trabalha a opção selecionada = 1
	;esquema pra imprimir as letras da palavra de chute no visor
	MOV #65500, R3
	ADD R0, R3
	ADD #1, R3
	;
	MOV #11099, R4
	MOV #0, R5
F2_2:
	TST (R1)
	BEQ F2_2
	;consiste se o caractere digitado é uma LETRA MAIÚSCULA
	CMP (R2), #65
	BLT F2_2_ERROU
	CMP (R2), #90
	BGT F2_2_ERROU
	JMP F2_2_CONTINUA
	
F2_2_ERROU:				;previne qualquer bug no input, caso algum caractere não maíusculo seja inserido
	CLR (R1)
	CLR (R2)
	JMP F2_2
	
F2_2_CONTINUA:			;mostra a palavra que está sendo digitada no visor e a salva em um vetor
	CLR (R1)
	MOV (R2), (R3)
	INC R3
	MOV (R2), (R4)
	INC R4
	INC R4
	INC R5
	CMP R5, R0
	BNE F2_2
	
;compara a palavra inserida com a palavra cadastrada:
F2_COMPARA:
	MOV #0, R1
	MOV #11099, R4
	MOV #9099, R5
F2_COMPARA_2:	
	CMP (R4), (R5)
	BNE LIMPA_PERDEU_1
	INC R4
	INC R4
	INC R5
	INC R5
	INC R1
	CMP R1, R0
	BEQ LIMPA_GANHOU_1
	JMP F2_COMPARA_2	
;---------------------------------------------

;------------------
TP_LIMPA_GANHOU_1:
	JMP LIMPA_GANHOU_1
;------------------	

;------------------
;limpa o visor após a identificação da derrota:
LIMPA_PERDEU_1:
	MOV #65500, R3
LIMPA_PERDEU_2:
	MOV #0, (R3)
	INC R3
	CMP R3, #65535
	BNE LIMPA_PERDEU_2
	MOV #7099, R0
	MOV #65500, R3
;
	
IMPRIME_PERDEU:			;imprime a mensagem de derrota
	MOV (R0), (R3)
	INC R0
	INC R3
	CMP R3, #10
	BNE IMPRIME_PERDEU
	HLT
;------------------

;------------------
;limpa o visor após a identificação da vitória:
LIMPA_GANHOU_1:
	MOV #65500, R3
LIMPA_GANHOU_2:
	MOV #0, (R3)
	INC R3
	CMP R3, #65535
	BNE LIMPA_GANHOU_2
	MOV #8099, R0
	MOV #65500, R3
;

IMPRIME_GANHOU:			;imprime a mensagem de vitória
	MOV (R0), (R3)
	INC R0
	INC R3
	CMP R3, #7
	BNE IMPRIME_GANHOU
	HLT
;------------------

;-------------------> SUBROTINAS <-------------------

;subrotina para imprimir o vetor de underlines
IMPRIME_UNDERLINE:
	MOV #65535, R3
	MOV 19999, (R3)
	;
	MOV #0, R1
	MOV #65500, R3
	MOV #10099, R5
IMPRIME_UNDERLINE_2:
	MOV (R5), (R3)
	INC R5
	INC R5
	INC R3
	INC R1
	CMP R1, R0
	BNE IMPRIME_UNDERLINE_2
	MOV #65498, R1
	MOV #65500, R3
	RTS R4
	
;------------------

ORG 5100
	DAB 'CADASTRAR PALAVRA: ('
ORG 5120
	DB 101	;e
	DB 109	;m
	DB 0	;
	DB 109	;m
	DB 97	;a
	DB 105	;i
	DB 117	;u
	DB 115	;s
	DB 99	;c
	DB 117	;u
	DB 108	;l
	DB 97	;a
	DB 115	;s
	DB 41	;)
	
ORG 6100
	DAB	'1 - letra // 2 - palavra: '

ORG 7100
	DAB 'GAME OVER!'
	
ORG 8100
	DAB 'WINNER!'
	
ORG 12100
	DAB 'VOCE ACERTOU!'

ORG 16100
	DAB 'VOCE ERROU!'