.386
.MODEL flat, stdcall
OPTION casemap:none 
INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\kernel32.inc
INCLUDE \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc
.DATA
	Counter DB 0
	Matrix DB 81 DUP(0)
.DATA?
	Rows DB ?
	Columns DB ?
	I DB ?
	J DB ?
.CODE
Program:
	print chr$("PROBLEMA 1", 13, 10)
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
	print str$(AL)
	LEA ESI, Matrix
	MOV AL, 0
	MOV I, 0

	RowsLoop:
	MOV J, 0
	print chr$(13, 10)

	ColumnsLoop:
	MOV AL, Counter
	MOV [ESI], AL
	MOV BL, [ESI] ;Se mueve a BL para comprobar que se ha guardado correctamente.
	print str$(BL)
	print chr$("	") ;Tabulador para que se imprima ordenado.
	INC Counter
	INC ESI
	INC J
	MOV CL, J
	CMP CL, Columns
	JL ColumnsLoop
	INC I
	MOV CL, I
	CMP CL, Rows
	JL RowsLoop
	INVOKE ExitProcess, 0
END Program