.386
.model flat, stdcall
option casemap:none 
include \masm32\include\windows.inc				
include \masm32\include\kernel32.inc			
include \masm32\include\masm32.inc				
include \masm32\include\masm32rt.inc
.data
.data? 
	carne db 10 dup (?)
	carrera db 100 dup (?)
	nombre db 100 dup (?)
.const 
.code
	main:
		print chr$("Ingresar Nombre: ")
		invoke StdIn, addr nombre, 100
		print chr$(13,10)
		print chr$("Ingresar carné: ")
		invoke StdIn, addr carne, 10
		print chr$(13,10)
		print chr$("Ingresar carrera: ")
		invoke StdIn, addr carrera, 100
		print chr$(13,10)

		print chr$("Hola ")
		invoke StdOut, addr nombre
		print chr$(" su carne es: ")
		invoke StdOut, addr carne
		print chr$(13,10)

		print chr$("Bienvenido a la carrera de ")
		invoke StdOut, addr carrera
		;FINALIZAR
		invoke ExitProcess, 0
end main