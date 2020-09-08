.model small					;Declaración de modelo.
.data							;Inicia segmento de datos.
	cadena db 'Hola, mundo!$'	;Variable de tipo byte, es cadena y termina con $.
.stack
.code
programa:
	;Inicialización del programa.
	mov ax, @data				;Obtenemos la dirección del inicio del segmento de datos.
	mov ds, ax 					;Inicializa el segmento de datos.
	;Imprimir cadena.
	mov dx, offset cadena		;Llenar dx con todo lo que hay desde el inicio de la cadena.
	mov ah, 09h
	int 21h
	;Finalización del programa.
	mov ah, 4Ch
	int 21h
end programa