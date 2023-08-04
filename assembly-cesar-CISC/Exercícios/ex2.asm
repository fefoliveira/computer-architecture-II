;Horários abordados:
;	06:00h – 12:00h -> "Bom dia!"
;	12:01h – 18:00h -> "Boa tarde!"
;	18:01h – 05:59h -> "Boa noite!"

MOV #65535, R3	;tira o "?" do fim do visor
CLR (R3)
	
MOV #65498, R5
MOV #65499, R1
MOV #65500, R3
MOV #0, R2			;R2 é o contador de quantos números entraram (não é pra ele considerar os ":")

MOV #8099, R4		;carrega o endereço da mensagem inicial em R4
INFORME:
	MOV (R4),(R3)	;coloca aos poucos o conteúdo da mensagem inicial
	INC R4
	INC R3
	INC R2
	CMP R2, #24
	BNE INFORME
	
	CLR R2		
	MOV #65498, R5
	MOV #65499, R1
	MOV #65524, R3

RESET:
	CLR (R5)		;zera o "buffer" do teclado
	
INICIO:
  	TST (R5)		;testa se a posição de estado do teclado foi alterada (se um caracter foi digitado)
	BEQ INICIO		;branch se nada for digitado
	MOV (R1), (R3)	;move o conteúdo digitado para o visor
	INC R3			;incrementa a próxima posição do visor
	INC R2			;incrementa contador

CONT:
	CMP R2, #2		;comparo com o contador com 2 
	BEQ CMP2		;se for igual, vai para CPM2
	CMP R2, #4		;comparo com o contador com 4 
	BEQ CMP4		;se for igual, vai para CPM4
	JMP RESET
	
CMP2:
	MOV #58, (R3)	;se for igual, imprimo ":" no visor
	INC R3
	JMP RESET

CMP4:				;testes com o primeiro número informado
	CLR (R5)
	MOV #65524, R3	
	CMP (R3), #48	;(48 == 0) se começar com zero, testa para ver se não é menor que 06h (se não for, então é de manhã)
	BEQ ZERO
	CMP (R3), #49	;(49 == 1)
	BEQ MANHA_TARDE
	CMP (R3), #50	;(50 == 2) se começar com 2, testa para ver se não é maior que 23h (se não for, então é de noite)
	BEQ DOIS
	;o JMP abaixo corrige qualquer invalidação do primeiro digito do horário, portanto não preciso checar este na função VAI
	JMP TP			;se não cumprir com nenhum dos requisitos acima, então certamente é invalido

ZERO:				
	MOV #65525, R3	;testa para ver se o segundo digito do horário é menor que 6
	CMP (R3), #54	;(54 == 6)
	BLT	TP2	
	JMP M1
	
DOIS:
	MOV #65525, R3	;testa para ver se o segundo digito do horário é maior que 4
	CMP (R3), #51	;(51 == 3)
	BGT TP
	JMP M3
	
MANHA_TARDE:		;testa o segundo digito do horário para a separação dos que começam com "1" (11:00h até 19:00h)
	MOV #65525, R3
	CMP (R3), #49	;(49 == 1) se for 10:00 ou 11:00, é certeza que é de manhã
	BLE M1
	CMP (R3), #50	;(50 == 2) diferenciar 12:00 e 12:01
	BEQ DOZE1
	CMP (R3), #55	;(55 == 7) se for ...< 17:00, é certeza que é de tarde
	BLE M2
	CMP (R3), #56	;(56 == 8) diferenciar 18:00 e 18:01
	BEQ DEZOITO1
	CMP (R3), #57	;(57 == 9) se for 19:00, é certeza que é de noite
	BEQ M3
	
DOZE1:				;confere 12:x-
	MOV #65527, R3
	CMP (R3), #48	;(48 == 0) 	
	BEQ DOZE2		;se realmente for 12:0-, testa o próximo algarismo dos minutos
	JMP M2			;se não for 12:0-, então é de tarde

DOZE2:				;confere 12:0x
	MOV #65528, R3
	CMP (R3), #48	;(48 == 0) 
	BEQ M1			;se realmente for 12:00, então é de manhã
	JMP M2			;se não for 12:00, então é de tarde

TP2:				;branch intermediário
	JMP M3;

DEZOITO1:			;confere 18:x
	MOV #65527, R3
	CMP (R3), #48	;(48 == 0) 
	BEQ DEZOITO2	;se realmente for 18:0-, testa o próximo algarismo dos minutos
	JMP M3			;se não for 12:0-, então é de tarde

DEZOITO2:			;confere 18:0x
	MOV #65528, R3
	CMP (R3), #48	;(48 == 0) 
	BEQ M2			;se realmente for 18:00, então é de tarde
	JMP M3			;se não for 18:00, então é de noite
	
TP:					;branch intermediário
	JMP INVALIDO

M1:  	
	MOV #5099, R4
    JMP VAI
	
M2:  	
	MOV #6099, R4
	JMP VAI
	
M3:  	
	MOV #7099, R4
	
VAI:				;sequência de testes de validação final (pra deixar tudo direitinho)
	;checagem do segundo digito do horário:
	MOV #65525, R3
	CMP (R3), #48	;(48 == 0)
	BLT INVALIDO	
	CMP (R3), #57	;(57 == 9)
	BGT INVALIDO
	
	;checagem do terceiro digito do horário:
	MOV #65524, R3	;R3 recebe o endereço do terceiro digito do horário
	CMP (R3), #54	;(54 == 6)
	BGE INVALIDO	;se o penultimo digito foi maior ou igual a 6, então é iválido
	CMP (R3), #48	;(48 == 0)
	BLT INVALIDO	;se o penultimo digito foi menor que 0, então é iválido (impedindo que seja digitado outro tipo de caracter da tabela ASCII)
	
	;checagem do quarto digito do horário:
	MOV #65525, R3
	CMP (R3), #48	;(48 == 0)
	BLT INVALIDO
	CMP (R3), #57	;(57 == 9)
	BGT INVALIDO
	
	
LIMPEZA:			;limpeza do visor:
	MOV #65528, R3
	CLR R2
LIMP:
	CLR (R3)
	DEC R3
	INC R2
	CMP R2, #27
	BNE LIMP
	
	MOV #65502, R3	;R3 volta a apontar para seu endereço original
	CLR R2
PRINT:
	MOV (R4),(R3)	;coloca aos poucos o conteúdo da mensagem
	INC R4
	INC R3
	INC R2
	CMP R2, #13
	BNE PRINT
	HLT				;FIM
	
	
INVALIDO:			;função que será impressa caso haja algum número digitado que não satisfaça os horários desejados
	MOV #65528, R3
	CLR R2
LIMPEZA_INVALIDO:	;limpa o visor caso o horário tenha sido inválido
	CLR (R3)
	DEC R3
	INC R2
	CMP R2, #27
	BNE LIMPEZA_INVALIDO
	
	MOV #9099, R4
	MOV #65502, R3
	CLR R2
INV:
	MOV (R4),(R3)
	INC R4
	INC R3
	INC R2
	CMP R2, #20
	BNE INV
	HLT				;FIM

ORG 5100
	DAB 'Bom dia! :)'

ORG 6100
	DAB 'Boa tarde! :)'
	
ORG 7100 
	DAB 'Boa noite! :)'
	
ORG 8100
	DAB '- Informe a hora local: '
	
ORG 9100
	DAB 'Horario invalido! :('
