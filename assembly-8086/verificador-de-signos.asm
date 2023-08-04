section .data
msg_dia             db     10,"INDIQUE O DIA DO SEU ANIVERSARIO: "
tam_dia             equ     $-msg_dia   

msg_mes             db      10,"INDIQUE O MES DO SEU ANIVERSARIO: "
tam_mes             equ     $-msg_mes 

msg_aquario         db      10,"SEU SIGNO É AQUARIO!"
tam_aquario         equ      $-msg_aquario

msg_peixes          db      10,"SEU SIGNO É PEIXES!"
tam_peixes          equ      $-msg_peixes

msg_capricornio     db      10,"SEU SIGNO É CAPRICORNIO"
tam_capricornio     equ      $-msg_capricornio

msg_aries           db      10,"SEU SIGNO É ÁRIES!"
tam_aries           equ     $-msg_aries

msg_touro           db      10,"SEU SIGNO É TOURO!"
tam_touro           equ     $-msg_touro

msg_gemeos          db      10,"SEU SIGNO É GÊMEOS!"
tam_gemeos          equ     $-msg_gemeos         

msg_cancer          db      10,"SEU SIGNO É CÂNCER!"
tam_cancer          equ     $-msg_cancer

msg_leao            db      10,"SEU SIGNO É LEÃO!"
tam_leao            equ     $-msg_leao

msg_virgem          db      10,"SEU SIGNO É VIRGEM!"
tam_virgem          equ     $-msg_virgem

msg_libra           db      10,"SEU SIGNO É LIBRA!"
tam_libra           equ     $-msg_libra

msg_escorpiao       db     10,"SEU SIGNO É ESCORPIÃO!"
tam_escorpiao       equ     $-msg_escorpiao

msg_sagitario       db      10,"SEU SIGNO É SAGITÁRIO!"
tam_sagitario       equ     $-msg_sagitario

msg_fim             db      10,"DENOVO? (0 PARA NÃO) "
tam_fim             equ     $-msg_fim
;----------------------------------------------------------------------

section .bss
dia   resb   3
mes   resb   3
FIM   resb   3
;----------------------------------------------------------------------

section	.text
global _start

_start:                     
	;printf:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg_dia
    mov edx, tam_dia
    int 0x80

    ;scanf:
    mov eax, 3
    mov ebx, 0
    mov ecx, dia
    mov edx, 3
    int 0x80
    
    ;testa se o dia tem somente um número:
    mov al, byte[dia + 1]   ;move o segundo digito da var "dia"
    cmp al, 10              ;último número do dia == \n?
    je unico_dia_zero
    jmp dia_dois_dig
    
;testa o unico digito da var dia:
unico_dia_zero:
    mov al, byte[dia + 0]   ;move o primeiro digito da var "dia"
    cmp al, 48              ;compara com '0'
    jz _start               ;se == '0', então é inválido e repete o scanf
    sub al, 48              ;se != '0', então é válido e prossegue
    push ax
    jmp recebe_mes_antes

;faz as validações caso o dia tenha dois digitos (com o primeiro já != 0):
dia_dois_dig:
    mov al, byte[dia + 0]   ;move o primeiro digito da var "dia"
    sub al, 48              ;transforma o primeiro digito de "char" pra "int"
    mov bl, 10              ;multiplica o primeiro digito por 10 para criar a dezena do dia
    mul bl
    mov bl, byte[dia + 1]   ;move o segundo digito da var "dia"
    sub bl, 48              ;transforma o segundo digito de "char" pra "int"
    add al, bl              ;soma os valores e termina enfim de validar o dia inserido
    push ax                 ;guarda essa soma na pilha
    jmp recebe_mes_antes


recebe_mes_antes:
    cmp al, 0
    je _start
recebe_mes:   
    ;printf:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg_mes
    mov edx, tam_mes
    int 0x80

    ;scanf:
    mov eax, 3
    mov ebx, 0
    mov ecx, mes
    mov edx, 3
    int 0x80
    
    ;testa se o mes tem somente um número:
    mov al, byte[mes + 1] 
    cmp al, 10
    je mes_zero
    jmp mes_dois_dig

;testa o unico digito da var mes:
mes_zero:
    mov al, byte[mes + 0] 
    cmp al, 48
    jz recebe_mes
    sub al, 48
    jmp verifica_mes

;faz as validações caso o mes tenha dois digitos (com o primeiro já != 0):
mes_dois_dig:
    mov al, byte[mes + 0]
    sub al, 48
    mov bl, 10
    mul bl
    mov bl, byte[mes + 1]
    sub bl, 48
    add al, bl
    jmp verifica_mes

;valida se o mes esta no intervalo de 1 - 12:
verifica_mes:
    cmp al, 0
    jle recebe_mes
    cmp al, 12
    jg recebe_mes
    jmp escolhe_mes
    
;switch case:
escolhe_mes:
    cmp al, 12
    je dezembro
    cmp al, 11
    je novembro
    cmp al, 10
    je outubro
    cmp al, 9
    je setembro
    cmp al, 8
    je agosto
    cmp al, 7
    je julho
    cmp al, 6
    je junho
    cmp al, 5
    je maio
    cmp al, 4
    je abril
    cmp al, 3
    je marco
    cmp al, 2
    je fevereiro
    jmp janeiro
    
;cases:
dezembro:
    pop ax
    cmp al, 31
    jg _start
    cmp al, 21
    jle printa_sagitario
    jmp printa_capricornio
novembro:
    pop ax
    cmp al, 30
    jg _start
    cmp al, 21
    jle printa_escorpiao
    jmp printa_sagitario
outubro:
    pop ax
    cmp al, 31
    jg _start
    cmp al, 22
    jle printa_libra
    jmp printa_escorpiao
setembro:
    pop ax
    cmp al, 30
    jg _start
    cmp al, 22
    jle printa_virgem
    jmp printa_libra
agosto:
    pop ax
    cmp al, 31
    jg _start
    cmp al, 22
    jle printa_leao
    jmp printa_virgem
julho:
    pop ax
    cmp al, 31
    jg _start
    cmp al, 21
    jle printa_cancer
    jmp printa_leao
junho:
    pop ax
    cmp al, 30  
    jg _start
    cmp al, 20
    jle printa_gemeos
    jmp printa_cancer
maio:
    pop ax
    cmp al, 31
    jg _start
    cmp al, 20
    jle printa_touro
    jmp printa_gemeos
abril:
    pop ax
    cmp al, 30
    jg _start
    cmp al, 20
    jle printa_aries
    jmp printa_touro
marco:
    pop ax
    cmp al, 31
    jg _start
    cmp al, 20
    jle printa_peixes
    jmp printa_aries
fevereiro:
    pop ax
    cmp al, 28
    jg _start
    cmp al, 19
    jle printa_aquario
    jmp printa_peixes
janeiro:
    pop ax  
    cmp al, 31
    jg _start
    cmp al, 20
    jle printa_capricornio
    jmp printa_aquario
    
;printfs de cada case:
printa_aquario:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg_aquario
    mov edx, tam_aquario
    int 0x80
    jmp fim
printa_peixes:
    mov eax, 4
	mov ebx, 1
	mov ecx, msg_peixes
    mov edx, tam_peixes
    int 0x80
    jmp fim
printa_aries:
    mov eax, 4
	mov ebx, 1
	mov ecx, msg_aries
    mov edx, tam_aries
    int 0x80
    jmp fim
printa_touro:
    mov eax, 4
	mov ebx, 1
	mov ecx, msg_touro
    mov edx, tam_touro
    int 0x80
    jmp fim
printa_gemeos:
    mov eax, 4
	mov ebx, 1
	mov ecx, msg_gemeos
    mov edx, tam_gemeos
    int 0x80
    jmp fim
printa_cancer:
    mov eax, 4
	mov ebx, 1
	mov ecx, msg_cancer
    mov edx, tam_cancer
    int 0x80
    jmp fim
printa_leao:
    mov eax, 4
	mov ebx, 1
	mov ecx, msg_leao
    mov edx, tam_leao
    int 0x80
    jmp fim
printa_virgem:
    mov eax, 4
	mov ebx, 1
	mov ecx, msg_virgem
    mov edx, tam_virgem
    int 0x80
    jmp fim
printa_libra:
    mov eax, 4
	mov ebx, 1
	mov ecx, msg_libra
    mov edx, tam_libra
    int 0x80
    jmp fim
printa_escorpiao:
    mov eax, 4
	mov ebx, 1
	mov ecx, msg_escorpiao
    mov edx, tam_escorpiao
    int 0x80
    jmp fim
printa_sagitario:
    mov eax, 4
	mov ebx, 1
	mov ecx, msg_sagitario
    mov edx, tam_sagitario
    int 0x80
    jmp fim
printa_capricornio:
    mov eax, 4
	mov ebx, 1
	mov ecx, msg_capricornio
    mov edx, tam_capricornio
    int 0x80
    jmp fim
    
fim:
    ;exibe uma mensagem perguntando se o usuário gostaria de consultar novamente:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg_fim
    mov edx, tam_fim
    int 0x80

    ;scanf
    mov eax, 3
    mov ebx, 0
    mov ecx, FIM
    mov edx, 3
    int 0x80
    
    ;testa se a reposta foi == 0 (qualquer outro valor != 0 constará como "sim")
    mov al, byte[FIM + 0]
    cmp al, 48
    jne _start

;finaliza o programa:
fim_real:
    mov eax, 1
    int 0x80
;----------------------------------------------------------------------