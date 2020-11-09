;PARA LOS PRIMEROS DOS, USAR MACROS.
;PARA EL TERCERO, PROCEDIMIENTOS.
CalcSquare MACRO mainSide
	print chr$("Area del cuadrado: ")
	MOV AL, mainSide
	MUL mainSide
	print str$(AL)
	print chr$(13, 10, "Perimetro del cuadrado: ")
	MOV AL, 4h
	MUL mainSide
	print str$(AL)
ENDM

CalcRect MACRO base, height
	print chr$("Area del rectangulo: ")
	MOV AL, base
	MUL height
	print str$(AL)
	print chr$(13, 10, "Perimetro del rectangulo: ")
	MOV AL, base
	ADD AL, base
	ADD AL, height
	ADD AL, height
	print str$(AL)
ENDM

CalcTrian MACRO base, height, hypo
	print chr$("Area (parte entera) del triangulo: ")
	MOV AL, base
	MUL height
	MOV BL, 2h
	DIV BL
	print str$(AL)
	print chr$(13, 10, "Perimetro del triangulo: ")
	MOV AL, base
	ADD AL, height
	ADD AL, hypo
	print str$(AL)
ENDM

CalcOp MACRO valA, valB, valC
	MOV DL, valC
	CMP valA, DL
	JS IsNeg
	JMP IsPos
	
	IsNeg:
	MOV BL, valB
	ADD BL, valB
	MOV AL, valC
	SUB AL, valA
	MOV CL, 3h
	IMUL CL
	CMP BL, AL
	JS NeedSign
	SUB BL, AL
	MOV ResultOp, BL
	print chr$(13, 10, "2*b+3*(a-c) = ")
	MOV AL, ResultOp
	print str$(AL)
	JMP ContinueOpc

	NeedSign:
	SUB AL, BL
	MOV ResultOp, AL
	print chr$(13, 10, "2*b+3*(a-c) = -")
	MOV AL, ResultOp
	print str$(AL)
	JMP ContinueOpc

	IsPos:
	print chr$(13, 10, "2*b+3*(a-c) = ")
	MOV BL, valB
	ADD BL, valB
	MOV AL, valA
	SUB AL, valC
	MOV CL, 3h
	IMUL CL
	ADD AL, BL
	print str$(AL)

	ContinueOpc:
	print chr$(13, 10, "a/b = ")
	MOV AL, valA
	IDIV valB
	print str$(AL)
	print chr$(13, 10, "a*b/c = ")
	MOV AL, valA
	IMUL valB
	IDIV valC
	print str$(AL)
	print chr$(13, 10, "a*(b/c) = ")
	MOV AL, valB
	IDIV valC
	IMUL valA
	print str$(AL)
ENDM

.386
.MODEL flat, stdcall
OPTION casemap:none
INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\kernel32.inc
INCLUDE \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc
locate PROTO:DWORD,:DWORD						;USADO PARA LIMPIAR LA CONSOLA.
.DATA
	InputStr DB 100 DUP(0)
	SearchStr DB 100 DUP(0)
.DATA?
	Opn DB ?
    aVal DB ?
    bVal DB ?
	cVal DB ?
	Result DB ?
	ResultOp DB ?
.CODE 
Program:
	CALL ClrScreen
	MOV Opn, 0
	print chr$("-LABORATORIO 8-", 13, 10)
	print chr$("1. Ejercicio 1", 13, 10)
	print chr$("2. Ejercicio 2", 13, 10)
	print chr$("3. Ejercicio 3", 13, 10)
	print chr$("-Otra tecla finalizara el programa-", 13, 10)
	INVOKE StdIn, ADDR Opn, 3
	CMP Opn, 31h
	JE E1
	CMP Opn, 32h
	JE E2
	CMP Opn, 33h
	JE E3
	JMP EndProgram

	E1:
	print chr$(13, 10, "-Calculo de area y perimetro-", 13, 10)
	print chr$("1. Cuadrado", 13, 10)
	print chr$("2. Rectangulo", 13, 10)
	print chr$("3. Triangulo", 13, 10)
	print chr$("-Otra tecla avanzara al ejercicio 2-", 13, 10)
	INVOKE StdIn, ADDR Opn, 3
	CMP Opn, 31h
	JE Square
	CMP Opn, 32h
	JE Rect
	CMP Opn, 33h
	JE Triangle
	JMP E2

	Square:
	print chr$("Ingrese el valor del lado: ")
	INVOKE StdIn, ADDR aVal, 3
	SUB aVal, 30h
	CalcSquare aVal
	print chr$(13, 10, 13, 10)
	CALL ContMsg
	JMP Program

	Rect:
	print chr$("Ingrese el valor de la base: ")
	INVOKE StdIn, ADDR aVal, 3
	SUB aVal, 30h
	print chr$("Ingrese el valor de la altura: ")
	INVOKE StdIn, ADDR bVal, 3
	SUB bVal, 30h
	CalcRect aVal, bVal
	print chr$(13, 10, 13, 10)
	CALL ContMsg
	JMP Program

	Triangle:
	print chr$("Ingrese el valor de la base: ")
	INVOKE StdIn, ADDR aVal, 3
	SUB aVal, 30h
	print chr$("Ingrese el valor de la altura: ")
	INVOKE StdIn, ADDR bVal, 3
	SUB bVal, 30h
	print chr$("Ingrese el valor de la hipotenusa: ")
	INVOKE StdIn, ADDR cVal, 3
	SUB cVal, 30h
	CalcTrian aVal, bVal, cVal
	print chr$(13, 10, 13, 10)
	CALL ContMsg
	JMP Program
	
	E2:
	print chr$(13, 10, "-Valor de expresiones-")
	print chr$(13, 10, "Ingrese el valor de a: ")
	INVOKE StdIn, ADDR aVal, 3
	SUB aVal, 30h
	print chr$("Ingrese el valor de b: ")
	INVOKE StdIn, ADDR bVal, 3
	SUB bVal, 30h
	print chr$("Ingrese el valor de c: ")
	INVOKE StdIn, ADDR cVal, 3
	SUB cVal, 30h
	CalcOp aVal, bVal, cVal
	print chr$(13, 10, 13, 10)
	CALL ContMsg
	JMP Program

	E3:
	print chr$(13, 10, "-Ocurrencia en cadenas-")
	print chr$(13, 10, "Ingrese la cadena principal: ")
	INVOKE StdIn, ADDR InputStr, 97
	print chr$("Ingrese la cadena a buscar: ")
	INVOKE StdIn, ADDR SearchStr, 97
	CALL StringSearch
	print chr$(13, 10, 13, 10)
	CALL ContMsg
	JMP Program
	
	EndProgram:
    INVOKE ExitProcess, 0
	 
	StringSearch PROC NEAR
		print chr$("Numero de ocurrencias: ")
		MOV CL, 0
		LEA ESI, InputStr
		LEA EDI, SearchStr

		ReadStr:
		MOV AL, [ESI]
		CMP AL, 0
		JE EndProc			;SALTA SI SE TERMINA LA CADENA DE ENTRADA.
		CMP AL, [EDI]
		JE MatchOcurred
		INC ESI
		JMP ReadStr

		MatchOcurred:
		MOV BL, [EDI]
		CMP BL, 0
		JE ConfOcurrence
		INC ESI
		INC EDI
		MOV AL, [ESI]
		CMP AL, [EDI]
		JE MatchOcurred
		MOV BL, [EDI]
		CMP BL, 0
		JE ConfOcurrence
		LEA EDI, SearchStr
		JMP ReadStr

		ConfOcurrence:
		INC CL
		LEA EDI, SearchStr
		JMP ReadStr

		EndProc:
		print str$(CL)
	RET
	StringSearch ENDP

	ClrScreen PROC NEAR
		LOCAL hOutPut:DWORD
		LOCAL noc:DWORD
		LOCAL cnt:DWORD
		LOCAL sbi:CONSOLE_SCREEN_BUFFER_INFO
		INVOKE GetStdHandle,STD_OUTPUT_HANDLE
		MOV hOutPut, EAX
		INVOKE GetConsoleScreenBufferInfo, hOutPut, ADDR sbi
		MOV EAX, sbi.dwSize
		PUSH AX
		ROL EAX, 16
		MOV CX, AX
		POP AX
		MUL CX
		CWDE
		MOV cnt, EAX
		INVOKE FillConsoleOutputCharacter, hOutPut, 32, cnt, NULL, ADDR noc
		INVOKE locate, 0, 0
	RET
	ClrScreen ENDP

	ContMsg PROC NEAR
		print chr$(13, 10, "Presione enter para continuar... ")
		INVOKE StdIn, ADDR Result, 2
	RET
	ContMsg ENDP
END Program