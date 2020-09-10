.model small
.data
	variable1 DB 'Andres Galvez $'
	variable2 DB '1024718 $'
.stack
.code
programa:
	;Ejercicio 1:
	mov ax, @data 
	mov ds, ax
	
	mov dx, offset variable1
	mov ah, 09h
	int 21h ;Interrupción
	
	mov dx, offset variable2
	mov ah, 09h
	int 21h
	
	;Ejercicio 3:
	mov dx, 0h ;Limpia el registro.
	
	mov dl, 41h ;ASCII de A.
	mov ah, 02h ;Salida de caracter.
	int 21h
	
	mov dl, 2Dh ;ASCII de -.
	mov ah, 02h
	int 21h
	
	mov dl, 6Eh ;n
	mov ah, 02h
	int 21h
	
	mov dl, 2Dh
	mov ah, 02h
	int 21h
	
	mov dl, 64h ;d
	mov ah, 02h
	int 21h
	
	mov dl, 2Dh
	mov ah, 02h
	int 21h
	
	mov dl, 72h ;r
	mov ah, 02h
	int 21h
	
	mov dl, 2Dh
	mov ah, 02h
	int 21h
	
	mov dl, 65h ;e
	mov ah, 02h
	int 21h
	
	mov dl, 2Dh
	mov ah, 02h
	int 21h
	
	mov dl, 73h ;s
	mov ah, 02h
	int 21h
	
	mov dl, 2Dh
	mov ah, 02h
	int 21h
	
	mov dl, 47h ;G
	mov ah, 02h
	int 21h
	
	mov dl, 2Dh
	mov ah, 02h
	int 21h
	
	mov dl, 61h ;a
	mov ah, 02h
	int 21h
	
	mov dl, 2Dh
	mov ah, 02h
	int 21h
	
	mov dl, 6Ch ;l
	mov ah, 02h
	int 21h
	
	mov dl, 2Dh
	mov ah, 02h
	int 21h
	
	mov dl, 76h ;v
	mov ah, 02h
	int 21h
	
	mov dl, 2Dh
	mov ah, 02h
	int 21h
	
	mov dl, 65h ;e
	mov ah, 02h
	int 21h
	
	mov dl, 2Dh
	mov ah, 02h
	int 21h
	
	mov dl, 7Ah ;z
	mov ah, 02h
	int 21h
	
	mov ah, 4Ch ;Finalización del programa.
	int 21h
end 