;4. CONVERTIR UN NÚMERO DE DOS DÍGITOS A BINARIO (CICLOS).
.MODEL SMALL
.DATA
	FirRequest DB 'Primer numero: $'
	SecRequest DB 13, 10, 'Segundo numero: $'
	ExtRequest DB 13, 10, 'Numero a descomponer y convertir a binario: $'
	MultResult DB 13, 10, 'Multiplicacion: $'
	DivResult DB 13, 10, 'Division entera: $'
	FacResult DB 13, 10, 'Factores:', 13, 10, '$'
	BinResult DB 'Binario: $'
	Units DB ?
	Tens DB ?
	Aux DW ?
	FirNum DW ?
	SecNum DW ?
	AuxResult DW ?
	Bit7 DW 30h
	Bit6 DW ?
	Bit5 DW ?
	Bit4 DW ?
	Bit3 DW ?
	Bit2 DW ?
	Bit1 DW ?
	Bit0 DW ?
.STACK
.CODE
Main:
	MOV AX, @DATA					;INICIALIZACIÓN.
	MOV DS, AX
	XOR AX, AX 		
	LEA DX, FirRequest				;PETICIÓN DEL PRIMER NÚMERO.
	MOV AH, 09h
	INT 21h
	MOV AH, 01h						;LEER PRIMER CARACTER.
	INT 21h
	SUB AL, 30h						;AJUSTE DE ASCII.
	MOV Tens, AL					
	INT 21h							;LEER SEGUNDO CARACTER.
	SUB AL, 30h						;AJUSTE DE ASCII.
	MOV Units, AL
	MOV AL, 0Ah						;GENERACIÓN DE DECENAS.
	MOV BL, Tens
	MUL BL	
	MOV BL, Units
	ADD AX, BX						;GENERACIÓN DE NÚMERO COMPLETO.
	MOV FirNum, AX
	MOV CX, AX						;GUARDADO DE PRIMER NÚMERO COMPLETO EN EL CONTADOR DEL CICLO.
	DEC CX							;DECREMENTO PARA IMPRESIÓN.
	LEA DX, SecRequest				;PETICIÓN DEL SEGUNDO NÚMERO.
	MOV AH, 09h
	INT 21h
	MOV AH, 01h						;LEER PRIMER CARACTER.
	INT 21h
	SUB AL, 30h						;AJUSTE DE ASCII.
	MOV Tens, AL					
	INT 21h							;LEER SEGUNDO CARACTER.
	SUB AL, 30h						;AJUSTE DE ASCII.
	MOV Units, AL
	MOV AL, 0Ah						;GENERACIÓN DE DECENAS.
	MOV BL, Tens
	MUL BL		
	MOV BL, Units
	ADD AX, BX						;GENERACIÓN DE NÚMERO COMPLETO.
	MOV SecNum, AX
Mult:								;CICLO DE SUMAS SUCESIVAS.
	ADD AX, SecNum
LOOP Mult
	MOV AuxResult, AX
	LEA DX, MultResult				;IMPRESIÓN DE RESULTADO DE MULTIPLICACIÓN.
	MOV AH, 09h
	INT 21h
	MOV AX, AuxResult				;DIVISIÓN ENTRE 1000d.
	MOV BX, 3E8h
	MOV DX, 0h
	DIV BX						
	CMP AX, 0h
	JE NonPrintThou					;SALTO CONDICIONAL A NO IMPRESIÓN DE MILLAR.
	MOV Aux, AX
	ADD AX, 30h						;AJUSTE DE ASCII.
	MOV DX, AX						;IMPRESIÓN DE MILLAR.
	MOV AH, 02h 
	INT 21h
	MOV AX, Aux						;DISMINUCIÓN DE MILLAR.
	MOV BX, 3E8h
	MUL BX						
	SUB AuxResult, AX				
NonPrintThou:
	MOV AX, AuxResult				;DIVISIÓN ENTRE 100d.
	MOV BX, 64h
	MOV DX, 0h
	DIV BX		
	MOV Aux, AX
	ADD AX, 30h						;AJUSTE DE ASCII.
	MOV DX, AX						;IMPRESIÓN DE CENTENA.
	MOV AH, 02h 
	INT 21h	
	MOV AX, Aux						;DISMINUCIÓN DE CENTENA.
	MOV BX, 64h
	MUL BX					
	SUB AuxResult, AX	
	MOV AX, AuxResult				;DIVISIÓN ENTRE 10d.
	MOV BX, 0Ah
	MOV DX, 0h
	DIV BX
	MOV Aux, AX
	ADD AX, 30h						;AJUSTE DE ASCII.
	MOV DX, AX						;IMPRESIÓN DE DECENA.
	MOV AH, 02h 
	INT 21h
	MOV AX, Aux						;DISMINUCIÓN DE DECENA.
	MOV BX, 0Ah
	MUL BX
	SUB AuxResult, AX				
	MOV AX, AuxResult				;IMPRESIÓN DE UNIDAD.					
	ADD AX, 30h						;AJUSTE DE ASCII.
	MOV DX, AX						
	MOV AH, 02h 
	INT 21h
	SUB AuxResult, AX				;DISMINUCIÓN DE UNIDAD.
;--------------------------------------------------------------------------------------
	LEA DX, DivResult				;IMPRESIÓN DE RESULTADO DE DIVISIÓN.
	MOV AH, 09h
	INT 21h
	XOR AX, AX						;LIMPIEZA AX.
	MOV AX, FirNum
	XOR BX, BX						;LIMPIEZA BX.
	MOV BX, 0h
	JMP Divi						;SALTO A LA ETIQUETA Divi.
AddDiv:								
	INC BX							;INCREMENTO DEL COCIENTE.
Divi:
	CMP AX, SecNum
	JS ContDiv						;SALTO SI LA RESTA ES MENOR A 0.;RESTAS SUCESIVAS.
	SUB AX, SecNum
	JMP AddDiv						;SALTO A AddDiv.
ContDiv:
	MOV AuxResult, BX				;DIVISIÓN ENTRE 10d.
	MOV AX, BX
	MOV BX, 0Ah
	MOV DX, 0h
	DIV BX
	MOV Aux, AX
	ADD AX, 30h						;AJUSTE DE ASCII.
	MOV DX, AX						;IMPRESIÓN DE DECENA.
	MOV AH, 02h 
	INT 21h
	MOV AX, Aux						;DISMINUCIÓN DE DECENA.
	MOV BX, 0Ah
	MUL BX
	SUB AuxResult, AX				
	MOV AX, AuxResult				;IMPRESIÓN DE UNIDAD.					
	ADD AX, 30h						;AJUSTE DE ASCII.
	MOV DX, AX						
	MOV AH, 02h 
	INT 21h
	SUB AuxResult, AX				;DISMINUCIÓN DE UNIDAD.
;--------------------------------------------------------------------------------------
	LEA DX, ExtRequest				;PETICIÓN DE TERCER NÚMERO.
	MOV AH, 09h
	INT 21h
	MOV AH, 01h						;LEER PRIMER CARACTER.
	INT 21h
	SUB AL, 30h						;AJUSTE DE ASCII.
	MOV Tens, AL					
	INT 21h							;LEER SEGUNDO CARACTER.
	SUB AL, 30h						;AJUSTE DE ASCII.
	MOV Units, AL
	MOV AL, 0Ah						;GENERACIÓN DE DECENAS.
	MOV BL, Tens
	MUL BL	
	MOV BL, Units
	ADD AX, BX						;GENERACIÓN DE NÚMERO COMPLETO.
	MOV FirNum, AX
	MOV SecNum, AX
	LEA DX, FacResult				;IMPRESIÓN DE RESULTADO DE FACTORES.
	MOV AH, 09h
	INT 21h
Fact:
	XOR AX, AX						;LIMPIEZA AX.
	XOR DX, DX						;LIMPIEZA DX.
	MOV AX, FirNum
	DIV SecNum
	CMP DX, 0h
	JZ Print						;SALTO SI ES UNA DIVISIÓN EXACTA.
Facto:
	DEC SecNum
	CMP SecNum, 0h						
	JZ Bin							;SALTO SI EL DIVISOR LLEGÓ A 0.
	JMP Fact
Print:
	MOV AuxResult, AX				;DIVISIÓN ENTRE 10d.
	MOV BX, 0Ah
	MOV DX, 0h
	DIV BX
	MOV Aux, AX
	ADD AX, 30h						;AJUSTE DE ASCII.
	MOV DX, AX						;IMPRESIÓN DE DECENA.
	MOV AH, 02h 
	INT 21h
	MOV AX, Aux						;DISMINUCIÓN DE DECENA.
	MOV BX, 0Ah
	MUL BX
	SUB AuxResult, AX				
	MOV AX, AuxResult				;IMPRESIÓN DE UNIDAD.					
	ADD AX, 30h						;AJUSTE DE ASCII.
	MOV DX, AX						
	MOV AH, 02h 
	INT 21h
	SUB AuxResult, AX				;DISMINUCIÓN DE UNIDAD.
	MOV DL, 0Ah						;SALTO DE LÍNEA
	INT 21h
	JMP Facto
;--------------------------------------------------------------------------------------
Bin:
	LEA DX, BinResult				;IMPRESIÓN DE RESULTADO DE BINARIO.
	MOV AH, 09h
	INT 21h
	XOR AX, AX
	MOV AX, FirNum
	MOV CX, 7h						;DEFINICIÓN DE NÚMERO DE REPETICIONES.
	MOV BX, 2h
Convert:
	XOR DX, DX
	DIV BX
	CMP CX, 7h
	JZ B6
	CMP CX, 6h
	JZ B5
	CMP CX, 5h
	JZ B4
	CMP CX, 4h
	JZ B3
	CMP CX, 3h
	JZ B2
	CMP CX, 2h
	JZ B1
	CMP CX, 1h
	JZ B0
	JMP Again
B6:
MOV Bit6, DX
JMP Again
B5:
MOV Bit5, DX
JMP Again
B4:
MOV Bit4, DX
JMP Again
B3:
MOV Bit3, DX
JMP Again
B2:
MOV Bit2, DX
JMP Again
B1:
MOV Bit1, DX
JMP Again
B0:
MOV Bit0, DX
Again:
LOOP Convert
	MOV DX, Bit7				;IMPRESIÓN DE BITS.		
	MOV AH, 02h 
	INT 21h
	ADD Bit0, 30h				
	MOV DX, Bit0
	INT 21h
	ADD Bit1, 30h
	MOV DX, Bit1						 
	INT 21h
	ADD Bit2, 30h
	MOV DX, Bit2						
	INT 21h
	ADD Bit3, 30h
	MOV DX, Bit3						
	INT 21h
	ADD Bit4, 30h
	MOV DX, Bit4						
	INT 21h
	ADD Bit5, 30h
	MOV DX, Bit5						
	INT 21h
	ADD Bit6, 30h
	MOV DX, Bit6						
	INT 21h
EndProgram:
	MOV AH, 4Ch						;FIN DE PROGRAMA.
	INT 21h
END