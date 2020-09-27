.MODEL SMALL
.DATA
	TRequest DB 'Cantidad de pruebas realizadas: $'
	PRequest DB 13, 10, 'Cantidad de resultados positivos: $'
	GAlert DB 13, 10, 'Alerta: verde.', 13, 10, '$'						;13, 10 ES SALTO DE LÍNEA.
	YAlert DB 13, 10, 'Alerta: amarilla.', 13, 10, '$'
	OAlert DB 13, 10, 'Alerta: naranja.', 13, 10, '$'
	RAlert DB 13, 10, 'Alerta: roja.', 13, 10, '$'
	Units DB ?
	Tens DB ?
	Hundreds DB ?
	Aux DB ?
	NHundreds DW ?
	NTens DW ?
	NUnits DW ?
	TNum DB ?
	PNum DB ?
	NTNum DW ?
	NPNum DW ?
.STACK
.CODE
Main:
	MOV AX, @DATA		        ;INICIALIZACIÓN.
	MOV DS, AX
	MOV DX, OFFSET TRequest		;IMPRESIÓN DE PRIMERA SOLICITUD.
	MOV AH, 09h
	INT 21h
	MOV AH, 01h					;LEER PRIMER CARACTER.
	INT 21h
	SUB AL, 30h					;AJUSTE DE ASCII.
	MOV Units, AL
	MOV AH, 01h					;LEER SEGUNDO CARACTER.
	INT 21h
	MOV Aux, AL
	CMP Aux, 0Dh				;EVALUACIÓN DE INGRESO DE ENTER.
	JE UProcess					;SI SE PRESIONA ENTER, SALTA A UProcess.
	SUB AL, 30h					;AJUSTE DE ASCII (EN CASO DE NO PRESIONARSE ENTER).
	MOV Aux, AL					;AJUSTE DE UNIDAD Y DECENA.
	MOV AL, Units
	MOV Tens, AL
	MOV AL, Aux
	MOV Units, AL
	MOV AL, 0Ah
	MOV BL, Tens
	MUL BL						;GENERACIÓN DE DECENAS.
	XOR BX, BX					;LIMPIEZA BX.
	MOV BL, Units				;GENERACIÓN DE NÚMERO COMPUESTO.
	ADD AX, BX					;SUMA DE DECENAS + UNIDADES.
	MOV NTNum, AX
	MOV AH, 01h					;LEER TERCER CARACTER.
	INT 21h
	MOV Aux, AL
	CMP Aux, 0Dh				;EVALUACIÓN DE INGRESO DE ENTER.
	JE TProcess					;SI SE PRESIONA ENTER, SALTA A TProcess.
	SUB AL, 30h					;AJUSTE DE ASCII (EN CASO DE NO PRESIONARSE ENTER).
	MOV Aux, AL					;AJUSTE DE UNIDAD, DECENA Y CENTENA.
	MOV AL, Tens
	MOV Hundreds, AL
	MOV AL, Units
	MOV Tens, AL
	MOV AL, Aux
	MOV Units, AL	
	MOV AL, 64h
	MOV BL, Hundreds			
	MUL BL						;GENERACIÓN DE CENTENAS.
	XOR BX, BX					;LIMPIEZA BX.
	ADD AX, NTNum				;SUMA DE CENTENAS + DECENAS + UNIDADES.
	MOV NTNum, AX
	;LLEGADO A ESTE PUNTO, SE INGRESÓ EL MÁXIMO PERMITIDO.
	MOV DL, 0Ah					;SALTO DE LÍNEA.
	MOV AH, 02h
	INT 21h
	JMP HProcess
	
UProcess:
	MOV DX, OFFSET PRequest		;IMPRESIÓN DE SEGUNDA SOLICITUD.
	MOV AH, 09h
	INT 21h
	MOV AH, 01h					;LEER PRIMER CARACTER.
	INT 21h
	
UBProcess:
	SUB AL, 30h					;AJUSTE DE ASCII.
	MOV BL, Units
	MOV Units, AL
	MOV NPNum, AX
	MOV NTNum, BX
	JMP Percentage
	
TProcess:
	MOV DX, OFFSET PRequest		;IMPRESIÓN DE SEGUNDA SOLICITUD.
	MOV AH, 09h
	INT 21h
	MOV AH, 01h					;LEER PRIMER CARACTER.
	INT 21h
	
TBProcess:
	SUB AL, 30h					;AJUSTE DE ASCII.
	MOV Units, AL
	MOV AH, 01h					;LEER SEGUNDO CARACTER.
	INT 21h
	MOV Aux, AL
	CMP Aux, 0Dh				;EVALUACIÓN DE INGRESO DE ENTER.
	JE TOne						;SI SE PRESIONA ENTER, SALTA A TOne.
	JMP TTwo					;SI NO SE PRESIONA ENTER, SALTA A TTwo.
	
TOne:
	MOV BL, Units
	MOV NPNum, BX
	JMP Percentage

TTwo:
	SUB AL, 30h					;AJUSTE DE ASCII (EN CASO DE NO PRESIONARSE ENTER).
	MOV Aux, AL					;AJUSTE DE UNIDAD Y DECENA.
	MOV AL, Units
	MOV Tens, AL
	MOV AL, Aux
	MOV Units, AL
	MOV AL, 0Ah
	MOV BL, Tens
	MUL BL						;GENERACIÓN DE DECENAS.
	XOR BX, BX					;LIMPIEZA BX.
	MOV BL, Units				;GENERACIÓN DE NÚMERO COMPUESTO.
	ADD AX, BX					;SUMA DE DECENAS + UNIDADES.
	MOV NPNum, AX
	
HProcess:
	MOV DX, OFFSET PRequest		;IMPRESIÓN DE SEGUNDA SOLICITUD.
	MOV AH, 09h
	INT 21h
	MOV AH, 01h					;LEER PRIMER CARACTER.
	INT 21h
	SUB AL, 30h					;AJUSTE DE ASCII.
	MOV Units, AL
	MOV AH, 01h					;LEER SEGUNDO CARACTER.
	INT 21h
	MOV Aux, AL
	CMP Aux, 0Dh				;EVALUACIÓN DE INGRESO DE ENTER.
	JE UBProcess				;SI SE PRESIONA ENTER, SALTA A UBProcess.
	SUB AL, 30h					;AJUSTE DE ASCII (EN CASO DE NO PRESIONARSE ENTER).
	MOV Aux, AL					;AJUSTE DE UNIDAD Y DECENA.
	MOV AL, Units
	MOV Tens, AL
	MOV AL, Aux
	MOV Units, AL
	MOV AL, 0Ah
	MOV BL, Tens
	MUL BL						;GENERACIÓN DE DECENAS.
	XOR BX, BX					;LIMPIEZA BX.
	MOV BL, Units				;GENERACIÓN DE NÚMERO COMPUESTO.
	ADD AX, BX					;SUMA DE DECENAS + UNIDADES.
	MOV NPNum, AX
	MOV AH, 01h					;LEER TERCER CARACTER.
	INT 21h
	MOV Aux, AL
	CMP Aux, 0Dh				;EVALUACIÓN DE INGRESO DE ENTER.
	JE TProcess					;SI SE PRESIONA ENTER, SALTA A TBProcess.
	SUB AL, 30h					;AJUSTE DE ASCII (EN CASO DE NO PRESIONARSE ENTER).
	MOV Aux, AL					;AJUSTE DE UNIDAD, DECENA Y CENTENA.
	MOV AL, Tens
	MOV Hundreds, AL
	MOV AL, Units
	MOV Tens, AL
	MOV AL, Aux
	MOV Units, AL	
	MOV AL, 64h
	MOV BL, Hundreds			
	MUL BL						;GENERACIÓN DE CENTENAS.
	XOR BX, BX					;LIMPIEZA BX.
	ADD AX, NTNum				;SUMA DE CENTENAS + DECENAS + UNIDADES.
	MOV NTNum, AX
	
Percentage:
	XOR AX, AX					;LIMPIEZA AX.
	XOR BX, BX					;LIMPIEZA BX.
	MOV AL, 64h					
	MOV BX, NPNum				;NPNum * 100
	MUL BX	
	DIV NTNum					;NPNum * 100 / NTNum SE ALMACENA EN AL.
	CMP AL, 04h					;EVALUACIÓN DE ALERTA VERDE.
	JE Green					;SI EL COCIENTE ES 4, SALTA A Green.
	JS Green					;SI EL COCIENTE ES MENOR A 4, SALTA A Green.
	CMP AL, 0Fh					;EVALUACIÓN DE ALERTA AMARILLA.
	JE Yellow					;SI EL COCIENTE ES 15, SALTA A Yellow.
	JS Yellow					;SI EL COCIENTE ES MENOR A 15, SALTA A Yellow.
	CMP AL, 13h					;EVALUACIÓN DE ALERTA NARANJA.
	JE Orange					;SI EL COCIENTE ES 19, SALTA A Orange.
	JS Orange					;SI EL COCIENTE ES MENOR A 19, SALTA A Orange.
	JMP Red						;SI NINGUNA CONDICIÓN ANTERIOR SE CUMPLE, SALTA A Red.
	
Green:
	MOV DX, OFFSET GAlert			;IMPRESIÓN DE ALERTA VERDE.
	MOV AH, 09h
	INT 21h
	JMP EndProgram

Yellow:
	MOV DX, OFFSET YAlert			;IMPRESIÓN DE ALERTA AMARILLA.
	MOV AH, 09h
	INT 21h
	JMP EndProgram
	
Orange:
	MOV DX, OFFSET OAlert			;IMPRESIÓN DE ALERTA NARANJA.
	MOV AH, 09h
	INT 21h
	JMP EndProgram
	
Red:
	MOV DX, OFFSET RAlert			;IMPRESIÓN DE ALERTA ROJA.
	MOV AH, 09h
	INT 21h

EndProgram:
	MOV AH, 4Ch						;FIN DE PROGRAMA.
	INT 21h
END