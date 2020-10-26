.386
.MODEL flat, stdcall
OPTION casemap:none
INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\kernel32.inc
INCLUDE \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc
.DATA?
    InputName DB 50 DUP(?)
    InputID DB 9 DUP(?)
    InputCar DB 50 DUP(?)
.CODE
Program:
    print chr$("Ingrese su nombre: ")
	INVOKE StdIn, ADDR InputName, 50
	print chr$("Ingrese su carne: ")
	INVOKE StdIn, ADDR InputID, 9
	print chr$("Ingrese su carrera: ")
    INVOKE StdIn, ADDR InputCar, 50
	print chr$(13, 10)
	print chr$("Hola, ")
	INVOKE StdOut, ADDR InputName
	print chr$(", su carne es ")
	INVOKE StdOut, ADDR InputID
	print chr$(".", 13, 10)
	print chr$("Bienvenido a la carrera de ")
	INVOKE StdOut, ADDR InputCar
	print chr$(".")
    INVOKE ExitProcess, 0
END Program