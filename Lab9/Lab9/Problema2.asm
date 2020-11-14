;Andres Gálvez - 1024718
.386
.MODEL flat, stdcall
OPTION casemap:none 
INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\kernel32.inc
INCLUDE \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc
.DATA
	Matrix DB 81 DUP(0)
	I DB 0
	J DB 0
	SecI DB 0
	SecJ DB 0
	AdderI DD 0
	AdderJ DD 0
	Rows DB 0
	Columns DB 0
	Content DB 0, 0
	MainChar DB 0, 0
	MSize DD 0
	InputChar DB 0
.CODE
Program:
	print chr$("PROBLEMA 2", 13, 10)
	print chr$("Ingrese el numero de filas: ")
	INVOKE StdIn, ADDR Rows, 3
	SUB Rows, 30h
	print chr$("Ingrese el numero de columnas: ")
	INVOKE StdIn, ADDR Columns, 3
	SUB Columns, 30h
	print chr$("El tamano de la matriz es: ")
	MOV AL, Rows
	print str$(AL)
	print chr$("x")
	MOV AL, Columns
	print str$(AL)
	print chr$(" = ")
	MOV AL, Rows
	MUL Columns
	MOV I, AL
	print str$(AL)
	print chr$(13, 10, 13, 10, "Llenado de la matriz por filas (presione enter por cada caracter)", 13, 10)
	LEA ESI, Matrix
	
	FillLoop:
	print chr$("Ingrese el siguiente caracter: ")
	INVOKE StdIn, ADDR InputChar, 4
	MOV AL, InputChar
	MOV [ESI], AL
	INC ESI
	DEC I
	CMP I, 0
	JNE FillLoop
	CALL Sort
	CALL PrintM

	INVOKE ExitProcess, 0

	Sort PROC NEAR
	XOR EAX, EAX
	MOV AL, Rows
	MUL Columns
	MOV MSize, EAX ;Tamaño.
	DEC EAX ;Tamaño - 1.
	
	SortLoop:
	LEA ESI, Matrix
	MOV EBX, AdderI
	INC EBX
	MOV AdderJ, EBX
	CMP AdderI, EAX
	JAE ExitLoop
		MatrixRoad:
		LEA ESI, Matrix
		CMP EBX, MSize
		JAE ContLoop
			ADD ESI, AdderI
			MOV DL, [ESI]
			SUB ESI, AdderI
			ADD ESI, AdderJ
			CMP DL, [ESI]
			JLE ContRoad
				SUB ESI, AdderJ
				ADD ESI, AdderI
				MOV CL, [ESI] ;Matrix[i]
				SUB ESI, AdderI
				ADD ESI, AdderJ
				MOV DH, [ESI] ;Matrix[j]
				SUB ESI, AdderJ
				ADD ESI, AdderI
				MOV [ESI], DH
				SUB ESI, AdderI
				ADD ESI, AdderJ
				MOV [ESI], CL
				SUB ESI, AdderJ
				ContRoad:
				INC AdderJ
				INC EBX
				JMP MatrixRoad
	ContLoop:
	INC AdderI
	JMP SortLoop
	ExitLoop:
	RET 
	Sort ENDP

	PrintM PROC NEAR
		LEA ESI, Matrix

		RowsLoop:
		MOV SecJ, 0
		print chr$(13, 10)

		ColumnsLoop:
		MOV AL, [ESI]
		MOV MainChar, AL
		INVOKE StdOut, ADDR MainChar
		;print str$(AL)
		print chr$("	") ;Tabulador para que se imprima ordenado.
		INC ESI
		INC SecJ
		MOV CL, SecJ
		CMP CL, Columns
		JL ColumnsLoop
		INC SecI
		MOV CL, SecI
		CMP CL, Rows
		JL RowsLoop
	RET
	PrintM ENDP
END Program