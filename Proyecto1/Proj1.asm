.MODEL SMALL
.DATA
	Header DB 'GENERADOR DE IDENTIFICADOR UNICO UNIVERSAL -UUID-$'
	GenMsg DB 13, 10, '1. Generar un nuevo UUID$'
	ValMsg DB 13, 10, '2. Validar un UUID$'
	ExitMsg DB 13, 10, '-Presionar otra tecla finalizara el programa-', 13, 10, '$'
	ContMsg DB 13, 10, 'Presione una tecla para continuar: $'
	QtyMsg DB 13, 10, 'Ingrese el numero de UUIDs que desea generar (1-9): $'
	InError1 DB 13, 10, 'Error, debe ingresar un numero.', 13, 10, '$'
	Iterations DB ?
	UUIDQty DB ?
	RndSeed DW ?
	UUID DB 37 DUP ('$')
	car db 48
	num2 db 0
	blo1 db 0
	blo2 db 0
	blo3 db 0
	blo4 db 0
	blo5 db 0
	caracter db 0
	Titulo DB 13, 10, 'Ingrese un UUID: $'
	Titulo2 DB 13, 10, 'UUID INVALIDO$'
	Titulo3 DB 13, 10, 'UUID VALIDO$'
.STACK
.CODE
	MOV AX, @DATA		
	MOV DS, AX

Main:
	CALL ClearScreen
	CALL GenRndSeed
	LEA DX, Header
	MOV AH, 09h
	INT 21h
	LEA DX, GenMsg
	INT 21h
	LEA DX, ValMsg
	INT 21h
	LEA DX, ExitMsg
	INT 21h
	MOV AH, 01h					;LEER OPCIÓN.
	INT 21h
	CMP AL, 31h					;EVALUACIÓN DE INGRESO.
	JE Generate
	CMP AL, 32h
	JE Validate
	JMP EndProgram

Generate:
	LEA DX, QtyMsg
	MOV AH, 09h
	INT 21h
	MOV AH, 01h					;LEER OPCIÓN.
	INT 21h
	CMP AL, 30h
	JE Main
	CMP AL,	3Ah					;VALIDACIÓN DE INGRESO DE DÍGITOS.
	JNS BadInput
	CMP AL, 30h
	JS BadInput
	SUB AL, 30h					;AJUSTE DE ASCII.
	ADD AL, 01h
	MOV UUIDQty, AL      		;ASIGNACIÓN DE NÚMERO DE CÓDIGOS A GENERAR.
	MOV CL, UUIDQty
	MOV DL, 0Ah					;SALTO DE LÍNEA
	MOV AH, 02h
	INT 21h
	MOV DL, 0Dh					
	INT 21h
	
	UUIDGen:
		CALL FillString
		MOV DL, 0Ah				;SALTO DE LÍNEA
		MOV AH, 02h
		INT 21h
		MOV DL, 0Dh					
		INT 21h
		DEC UUIDQty
		MOV CL, UUIDQty
	LOOP UUIDGen
	
	LEA DX, ContMsg
	MOV AH, 09h
	INT 21h
	MOV AH, 01h
	INT 21h
	JMP Main
	
BadInput:
	LEA DX, InError1
	MOV AH, 09h
	INT 21h
	LEA DX, ContMsg
	INT 21h
	MOV AH, 01h
	INT 21h
	JMP Main

Validate:
	MOV DX,offset Titulo
	MOV Ah,09h
	INT 21h
	;Hacer bloque numero 1
	CALL prcblo1
	mov car,48
	CALL prcblo2
	mov car,48
	call prcblo3
	mov car,48
	call prcblo4
	mov car,48
	call prcblo5
	MOV car,48
	MOV DX,offset Titulo3
	MOV Ah,09h
	INT 21h
	MOV DX, offset ContMsg
	MOV AH, 09h
	INT 21h
	MOV AH, 01h
	INT 21h
	JMP Main

prcblo1 PROC NEAR
	bloque1:
	XOR AX,AX
	cmp blo1,8
	je salir
	MOV AH, 01h						;INTERRUPCION PARA LEER DEL TECLADO
	INT 21h
	MOV caracter,AL
	inc blo1
	mov car,48
	jmp ciclo
	
	ciclo:
	xor ax,ax
	cmp car,58
	je pasot
	mov Al,car
	cmp caracter,al
	je bloque1
	inc car
	jmp ciclo
	
	pasot:
	mov car,97
	jmp ciclo2
	
	ciclo2:
	xor ax,ax
	cmp car,103
	je pasar0
	mov Al,car
	cmp caracter,AL
	je bloque1
	inc car
	jmp ciclo2
	
	pasar0:
	MOV DX,offset Titulo2
	MOV Ah,09h
	INT 21h
	MOV DX, offset ContMsg
	MOV AH, 09h
	INT 21h
	MOV AH, 01h
	INT 21h
	JMP Main
	
	salir:
	XOR AX,AX
RET
prcblo1 ENDP

prcblo2 PROC NEAR
	xor AX,AX
	MOV AH, 01h						;INTERRUPCION PARA LEER DEL TECLADO
	INT 21h
	MOV num2,AL
	cmp num2,45
	jne pasar
	
	;bloque numero 2;;;;;;;;;;;;;
	bloque2:
	
	XOR AX,AX
	
	cmp blo2,4
	je salir2
	MOV AH, 01h						;INTERRUPCION PARA LEER DEL TECLADO
	INT 21h
	MOV caracter,AL
	inc blo2
	mov car,48
	jmp ciclo3
	
	ciclo3:
	xor ax,ax
	cmp car,58
	je pasot2
	mov Al,car
	cmp caracter,al
	je bloque2
	inc car
	jmp ciclo3
	
	pasot2:
	mov car,97
	jmp ciclo4
	
	ciclo4:
	xor ax,ax
	cmp car,103
	je pasar
	mov Al,car
	cmp caracter,AL
	je bloque2
	inc car
	jmp ciclo4
	
	pasar:
	MOV DX,offset Titulo2
	MOV Ah,09h
	INT 21h
	MOV DX, offset ContMsg
	MOV AH, 09h
	INT 21h
	MOV AH, 01h
	INT 21h
	JMP Main
	
	salir2:
	XOR AX,AX
	
RET
prcblo2 ENDP
;----------bloque3---------------
prcblo3 PROC NEAR
	xor AX,AX
	MOV AH, 01h						;INTERRUPCION PARA LEER DEL TECLADO
	INT 21h
	MOV num2,AL
	cmp num2,45
	jne pasar1
	
	xor AX,AX
	MOV AH, 01h						;INTERRUPCION PARA LEER DEL TECLADO
	INT 21h
	MOV num2,AL
	cmp num2,49
	je bloque3
	jmp pasar1
	
	bloque3:
	XOR AX,AX
	cmp blo3,3
	je salir3
	MOV AH, 01h						;INTERRUPCION PARA LEER DEL TECLADO
	INT 21h
	MOV caracter,AL
	inc blo3
	mov car,48
	jmp ciclo5
	
	ciclo5:
	xor ax,ax
	cmp car,58
	je pasot3
	mov Al,car
	cmp caracter,al
	je bloque3
	inc car
	jmp ciclo5
	
	pasot3:
	mov car,97
	jmp ciclo6
	
	ciclo6:
	xor ax,ax
	cmp car,103
	je pasar1
	mov Al,car
	cmp caracter,AL
	je bloque3
	inc car
	jmp ciclo6
	
	pasar1:
	MOV DX,offset Titulo2
	MOV Ah,09h
	INT 21h
	MOV DX, offset ContMsg
	MOV AH, 09h
	INT 21h
	MOV AH, 01h
	INT 21h
	JMP Main
	salir3:
	
	XOR AX,AX
RET
prcblo3 ENDP

prcblo4 PROC NEAR
	xor AX,AX
	MOV AH, 01h						;INTERRUPCION PARA LEER DEL TECLADO
	INT 21h
	MOV num2,AL
	cmp num2,45
	jne pasar2
	
	xor AX,AX
	MOV AH, 01h						;INTERRUPCION PARA LEER DEL TECLADO
	INT 21h
	MOV num2,AL
	cmp num2,56
	je bloque4
	cmp num2,57
	je bloque4
	cmp num2,97
	je bloque4
	cmp num2,98
	je bloque4
	jmp pasar2
	
	bloque4:
	XOR AX,AX
	cmp blo4,3
	je salir4
	MOV AH, 01h						;INTERRUPCION PARA LEER DEL TECLADO
	INT 21h
	MOV caracter,AL
	inc blo4
	mov car,48
	jmp ciclo7
	
	ciclo7:
	xor ax,ax
	cmp car,58
	je pasot4
	mov Al,car
	cmp caracter,al
	je bloque4
	inc car
	jmp ciclo7
	
	pasot4:
	mov car,97
	jmp ciclo8
	
	ciclo8:
	xor ax,ax
	cmp car,103
	je pasar2
	mov Al,car
	cmp caracter,AL
	je bloque4
	inc car
	jmp ciclo8
	
	pasar2:
	MOV DX,offset Titulo2
	MOV Ah,09h
	INT 21h
	MOV DX, offset ContMsg
	MOV AH, 09h
	INT 21h
	MOV AH, 01h
	INT 21h
	JMP Main
	salir4:
	XOR AX,AX
RET
prcblo4 ENDP

prcblo5 PROC NEAR
	xor AX,AX
	MOV AH, 01h						;INTERRUPCION PARA LEER DEL TECLADO
	INT 21h
	MOV num2,AL
	cmp num2,45
	jne pasar3
	
	bloque5:
	XOR AX,AX
	cmp blo5,12
	je salir5
	MOV AH, 01h						;INTERRUPCION PARA LEER DEL TECLADO
	INT 21h
	MOV caracter,AL
	inc blo5
	mov car,48
	jmp ciclo9
	
	ciclo9:
	xor ax,ax
	cmp car,58
	je pasot5
	mov Al,car
	cmp caracter,al
	je bloque5
	inc car
	jmp ciclo9
	
	pasot5:
	mov car,97
	jmp ciclo10
	
	ciclo10:
	xor ax,ax
	cmp car,103
	je pasar3
	mov Al,car
	cmp caracter,AL
	je bloque5
	inc car
	jmp ciclo10
	
	pasar3:
	MOV DX,offset Titulo2
	MOV Ah,09h
	INT 21h
	MOV DX, offset ContMsg
	MOV AH, 09h
	INT 21h
	MOV AH, 01h
	INT 21h
	JMP Main
	salir5:
	XOR AX,AX
RET
prcblo5 ENDP

EndProgram:
	MOV AH, 4Ch
	INT 21h

;LIMPIEZA DE PANTALLA.
ClearScreen PROC NEAR
	MOV AX, 600h		
	MOV BH, 07h
	MOV CX, 0000h
	MOV DX, 184Fh
	INT 10h
	MOV AH, 02h
	MOV BH, 00h
	MOV DH, 00h
	MOV DL, 00h
	INT 10h
	XOR AX, AX
	XOR BX, BX
	XOR CX, CX
	XOR DX, DX
RET
ClearScreen ENDP

GenRndSeed PROC NEAR
	MOV AH, 00h					;TICS DEL DÍA.
	INT 1Ah
	MOV AX, DX
	MOV RndSeed, DX
RET
GenRndSeed ENDP

;GENERA UN NÚMERO HEX ALEATORIO 0-F.
GenRnd PROC NEAR
	ADD AX, RndSeed
	MOV RndSeed, AX
	XOR DX, DX
	MOV CX, 10h
	DIV CX 
	CMP DL, 0Ah					;EVALÚA EL RESIDUO.
	JE IsTen
	CMP DL, 0Bh
	JE IsEleven
	CMP DL, 0Ch
	JE IsTwelve
	CMP DL, 0Dh
	JE IsThirteen
	CMP DL, 0Eh
	JE IsFourteen
	CMP DL, 0Fh
	JE IsFifteen
	JMP IsNum
	IsTen:
		ADD DL, 37h
		JMP EndRnd
	IsEleven:
		ADD DL, 37h
		JMP EndRnd
	IsTwelve:
		ADD DL, 37h
		JMP EndRnd
	IsThirteen:
		ADD DL, 37h
		JMP EndRnd
	IsFourteen:
		ADD DL, 37h
		JMP EndRnd
	IsFifteen:
		ADD DL, 37h
		JMP EndRnd
	IsNum:
		ADD DL, 30h
	EndRnd:
RET
GenRnd ENDP

GenSecRnd PROC NEAR
	XOR DX, DX
	MOV CX, 04h
	DIV CX 
	CMP DL, 0h					;EVALÚA EL RESIDUO.
	JE IsEight
	CMP DL, 01h
	JE IsNine
	CMP DL, 02h
	JE IsA
	JMP IsB
	IsEight:
		MOV DL, 38h
		JMP EndSecRnd
	IsNine:
		MOV DL, 39h
		JMP EndSecRnd
	IsA:
		MOV DL, 41h
		JMP EndSecRnd
	IsB:
		MOV DL, 42h
	EndSecRnd:
RET
GenSecRnd ENDP

FillString PROC NEAR
	LEA SI, UUID
	MOV Iterations, 08h
	MOV CL, 08h
	
	AFillString:
		CALL GenRnd
		MOV [SI], DL
		INC SI
		MOV CL, Iterations
		DEC Iterations
	LOOP AFillString
	
	MOV BYTE PTR [SI], 2Dh
	INC SI
	MOV Iterations, 04h
	MOV CL, 04h
	
	BFillString:
		CALL GenRnd
		MOV [SI], DL
		INC SI
		MOV CL, Iterations
		DEC Iterations
	LOOP BFillString
	
	MOV BYTE PTR [SI], 2Dh
	INC SI
	MOV BYTE PTR [SI], 31h		;REGLA "1" CUATRO BITS MÁS SIGNIFICATIVOS.
	INC SI
	MOV Iterations, 03h
	MOV CL, 03h
	
	CFillString:
		CALL GenRnd
		MOV [SI], DL
		INC SI
		MOV CL, Iterations
		DEC Iterations
	LOOP CFillString
	
	MOV BYTE PTR [SI], 2Dh
	INC SI
	CALL GenSecRnd
	MOV [SI], DL				;REGLA ALEATORIO 8-B.
	INC SI
	MOV Iterations, 03h
	MOV CL, 03h
	
	DFillString:
		CALL GenRnd
		MOV [SI], DL
		INC SI
		MOV CL, Iterations
		DEC Iterations
	LOOP DFillString
	
	MOV BYTE PTR [SI], 2Dh
	INC SI
	MOV Iterations, 0Ch
	MOV CL, 0Ch
	
	EFillString:
		CALL GenRnd
		MOV [SI], DL
		INC SI
		MOV CL, Iterations
		DEC Iterations
	LOOP EFillString
		
	LEA DX, UUID
	MOV AH, 09h
	INT 21h
RET
FillString ENDP

END