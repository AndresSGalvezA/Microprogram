Cipher MACRO
	print chr$("Ingrese mensaje en claro:", 13, 10)
	INVOKE StdIn, ADDR Message, 100
	print chr$("Ingrese la clave:", 13, 10)
	INVOKE StdIn, ADDR Key, 100
	print chr$("Mensaje cifrado: ")
	MOV MsgCounter, 0										;inicializa en 0 los contadores para recorrer el mensaje y la clave		
	MOV KeyCounter, 0

	CipherLoop:
	CALL FindJ												;Busca la letra de Message.
	CMP MainJ, 1Fh											;Evalúa espacio en blanco.
	JNE ContinueIndex
	print chr$(" ")
	MOV MainJ, 1Eh											;1Eh = 30d

	ContinueIndex:
	CMP MainJ, 1Eh											;Evalúa caracter a ignorar.
	JE CipherLoop

	CallFindI:
	CALL FindI												;Busca la letra de Key.
	CMP MainI, 1Eh											;Evalúa caracter a ignorar.
	JE CallFindI

	CALL Mapping
	LEA ESI, Matrix
	ADD ESI, EAX											;EAX guarda resultado de Mapeo
	MOV AL, [ESI]											;se guarda en AL el caracter que debe ser reemplazado
	MOV CipherChar, AL
	INVOKE StdOut, ADDR CipherChar
	LEA ESI, Message										;apuntador de cadena regresa al inicio del mensaje
	ADD ESI, MsgCounter										;avanza a la posicion que indica el contador
	MOV AL, [ESI]
	CMP AL, 0												;si es 0 significa que termino el recorrido del mensaje
	JNE CipherLoop											;si no es 0 continua el ciclo de cifrado
ENDM

CipherVariant MACRO
	print chr$("Ingrese mensaje en claro:", 13, 10)
	INVOKE StdIn, ADDR Message, 100
	print chr$("Ingrese la clave:", 13, 10)
	INVOKE StdIn, ADDR Key, 100
	print chr$("Mensaje cifrado con variante: ")
	MOV MsgCounter, 0
	MOV KeyCounter, 0
	MOV CipherFlag, 0

	CipherLoopV:
	CALL FindJ												;Busca la letra de Message.
	CMP MainJ, 1Fh											;Evalúa espacio en blanco.
	JNE ContinueIndexV
	print chr$(" ")
	MOV MainJ, 1Eh

	ContinueIndexV:
	CMP MainJ, 1Eh											;Evalúa caracter a ignorar.
	JE CipherLoopV

	CallFindIV:
	CALL FindIV												;Busca la letra de Key.
	CMP MainI, 1Eh											;Evalúa caracter a ignorar.
	JE CallFindIV

	CALL Mapping
	LEA ESI, Matrix
	ADD ESI, EAX
	MOV AL, [ESI]
	MOV CipherChar, AL
	INVOKE StdOut, ADDR CipherChar
	LEA ESI, Message
	ADD ESI, MsgCounter
	MOV AL, [ESI]
	CMP AL, 0
	JNE CipherLoopV
ENDM

Decipher MACRO
	print chr$("Ingrese mensaje cifrado:", 13, 10)
	INVOKE StdIn, ADDR Message, 100
	print chr$("Ingrese la clave:", 13, 10)
	INVOKE StdIn, ADDR Key, 100
	print chr$("Mensaje descifrado: ")
	MOV MsgCounter, 0
	MOV KeyCounter, 0
	MOV DecipherMsgCount, 0

	DecipherLoop:
	CALL FindI												;Busca la letra de Key.
	CMP MainI, 1Eh											;Evalúa caracter a ignorar.
	JE DecipherLoop
	MOV MainJ, 0

	CallMapping:
	CALL Mapping
	LEA ESI, Matrix
	ADD ESI, EAX
	LEA EDI, Message 
	ADD EDI, DecipherMsgCount
	MOV BL, [EDI]
	CMP BL, 20h												;Evalúa espacio en blanco.
	JE DBlankSpace
	CMP BL, 61h												;Evalua "a" (inicio del intervalo de letras)
	JS DIgnoreJ
	CMP BL, 7Bh												;Evalua "{" (fin del intervalo de letras)
	JNS DIgnoreJ
	MOV AL, [ESI]
	CMP AL, [EDI]
	JE JFound
	INC MainJ
	JMP CallMapping

	DBlankSpace:
	print chr$(" ")

	DIgnoreJ:
	INC DecipherMsgCount
	JMP CallMapping

	JFound:
	INC DecipherMsgCount
	MOV MainI, 0
	CALL Mapping
	LEA ESI, Matrix
	ADD ESI, EAX
	MOV AL, [ESI]
	MOV CipherChar, AL
	INVOKE StdOut, ADDR CipherChar
	LEA ESI, Message
	ADD ESI, DecipherMsgCount
	MOV AL, [ESI]
	CMP AL, 0
	JNE DecipherLoop
ENDM

DecipherVariant MACRO
	print chr$("Ingrese mensaje cifrado:", 13, 10)
	INVOKE StdIn, ADDR Message, 100
	print chr$("Ingrese la clave:", 13, 10)
	INVOKE StdIn, ADDR Key, 100
	print chr$("Mensaje descifrado con variante: ")
	MOV MsgCounter, 0
	MOV KeyCounter, 0
	MOV CipherFlag, 0
	MOV DecipherMsgCount, 0
	MOV SecKeyCounter, 0

	DecipherLoopV:
	CALL FindIDV											;Busca la letra de Key.
	CMP MainI, 1Eh											;Evalúa caracter a ignorar.
	JE DecipherLoop
	MOV MainJ, 0

	CallMappingV:
	CALL Mapping
	LEA ESI, Matrix
	ADD ESI, EAX
	LEA EDI, Message 
	ADD EDI, DecipherMsgCount
	MOV BL, [EDI]
	CMP BL, 20h												;Evalúa espacio en blanco.
	JE DVBlankSpace
	CMP BL, 61h												;Evalua "a" (inicio de intervalo de letras)
	JS DVIgnoreJ
	CMP BL, 7Bh												;Evalua "{" (fin del intervalo de letras)
	JNS DVIgnoreJ
	MOV AL, [ESI]
	CMP AL, [EDI]
	JE JFoundV
	INC MainJ
	JMP CallMappingV

	DVBlankSpace:
	print chr$(" ")

	DVIgnoreJ:
	INC DecipherMsgCount
	JMP CallMappingV

	JFoundV:
	INC DecipherMsgCount
	MOV MainI, 0
	CALL Mapping
	LEA ESI, Matrix
	ADD ESI, EAX
	MOV AL, [ESI]
	MOV CipherChar, AL
	INVOKE StdOut, ADDR CipherChar
	MOV AL, CipherChar
	LEA EDI, SecKey
	ADD EDI, SecKeyCounter
	MOV [EDI], AL
	LEA ESI, Message
	ADD ESI, DecipherMsgCount
	INC SecKeyCounter
	MOV AL, [ESI]
	CMP AL, 0
	JNE DecipherLoopV
ENDM


.386
.MODEL flat, stdcall
OPTION casemap:none 
INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\kernel32.inc
INCLUDE \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc
locate PROTO:DWORD,:DWORD
.DATA
	Message DB 100 DUP(0)
	Key DB 100 DUP(0)
	SecKey DB 100 DUP(0)
	MainMenu DB "-CIFRADO DE MENSAJES USANDO MATRICES-", 10, 13,"Ingrese la opcion a realizar: ", 10, 13, 
				"1) Ingresar mensaje y clave para generar criptograma", 10, 13, "2) Ingresar mensaje y clave para generar criptograma (variante algoritmo)", 10, 13, 
				"3) Ingresar criptograma y clave para descifrar mensaje", 10, 13, 0
	MainMenu2 DB "4) Ingresar criptograma y clave para descifrar mensaje (variante algoritmo)", 10, 13, 
				 "5) Ingresar criptograma para calcular estadisticas", 10, 13, "--Ingresar otra opcion cerrara el programa--", 10, 13, 0
	opcion1 DB 0, 0
	CipherChar DB 0, 0
	MsgCounter DD 0											;DD para que sean del mismo tamano que EDI y ESI
	KeyCounter DD 0
	SecKeyCounter DD 0
	DecipherMsgCount DD 0
	CipherFlag DB 0

	AbcStatistics DB 26 DUP(0)
	Counter DB 0
	MsgLength DB 0, 0
	AbcCounter DB 26 DUP(0)									;vector de contadores inicia con todas las posiciones en 0
	CharFrequency DB 26 DUP(0)
	CharToPrint DB 61h										;inicia con "a"
	TensToPrint DB 0, 0
	UnitsToPrit DB 0, 0
.DATA?
	Matrix DB 676 DUP(?)									;inicia la matriz con 26*26 posiciones por la cantidad de letras del abecedario
	MainI DW ?
	MainJ DW ?
.CODE
Program:
	LEA ESI, Matrix											;inicio de la matriz en ESI
	MOV CX, 2A4h											;676d = 26d * 26d, inicia el registro contador con la cantidad de posiciones de la matriz
	MOV AL, 61h												;"a" inicio de letras en el ASCII
	MOV BL, 0												;Ajuste de corrimiento de filas, inicia con 0 (sin ajsute)
	MOV BH, 0												;Contador de caracteres.
	
	FillMatrix:
	MOV [ESI], AL											;se guarda la letra en la posicion de la matriz que indica el apuntador
	INC ESI													;se corre una posicion (posicion +1)
	INC BH													;contador de caracteres +1
	INC AL													;siguiente letra en el ASCII
	CMP BH, 1Ah												;contador de caracteres =  26d (cantidad de letras del abecedario que son la cantidad de letras en la fila)
	JE FixNewRow											;si llega a 26d, salta a agregar nueva fila
	CMP AL, 7Bh												;si AL = "{", marca el fin del intervalo de letras del ASCII
	JE FixChar
	JMP LoopCounter
	FixChar:
	MOV AL, 61h												;reinicia el registro AL a guardar "a"
	JMP LoopCounter
	FixNewRow:
	MOV BH, 0												;reinicia contador caracteres
	MOV AL, 61h												;AL se reinicia a "a"
	INC BL 
	ADD AL, BL												;se le agrega el ajuste AL, para que la fila empiece con el corrimiento que corresponde
	LoopCounter:
	DEC CX													;decrementa el contador (posiciones que faltan de la matriz)
	CMP CX, 0
	JNE FillMatrix											;si el contador no ha llegado a 0, continua el ciclo de llenado

Main:
	CALL ClearScreen
	INVOKE StdOut, ADDR MainMenu							;Impresión de menú principal
	INVOKE StdOut, ADDR MainMenu2
	INVOKE StdIn, ADDR opcion1, 3
	CMP opcion1, 31h
	JE Op1													;1 en ASCII -> Cifrar
	CMP opcion1, 32h
	JE Op2													;2 en ASCII -> Cifrar con Variante
	CMP opcion1, 33h
	JE Op3													;3 en ASCII -> Descifrar
	CMP opcion1, 34h
	JE Op4													;4 en ASCII -> Descifrar con variante
	CMP opcion1, 35h
	JE Op5													;5 en ASCII -> Deducir el mensaje

	JMP EndProgram
	
	Op1:
	Cipher
	JMP ContinueMsg
	Op2:
	CipherVariant
	JMP ContinueMsg
	Op3:
	Decipher
	JMP ContinueMsg
	Op4:
	DecipherVariant
	JMP ContinueMsg
	Op5:
	CALL DeduceProcess

	ContinueMsg:
	print chr$(13, 10, 13, 10, "Presione enter para continuar... ")
	INVOKE StdIn, ADDR opcion1, 4
	JMP Main
	
	EndProgram:
	print chr$(13, 10, ".:Gracias por usar el programa de cifrado con matrices:.")
    INVOKE ExitProcess, 0
	
	ClearScreen PROC NEAR
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
		XOR EAX, EAX
		XOR ECX, ECX
	RET
	ClearScreen ENDP

	Mapping PROC NEAR									;mapeo por filas
		XOR EAX, EAX
		MOV AX, MainI
		MOV BL, 1Ah										;1Ah = 26d (cantidad de elementos en una fila)
		MUL BL											
		ADD AX, MainJ									; (MainI * 26d) + MainJ 
	RET
	Mapping ENDP										;resultado del mapeo en AX con la posicion del arreglo que maneja la matriz

	FindI PROC NEAR
		BeginFindI:
		XOR AX, AX
		LEA EDI, Key										;apunta al inicio de la cadena de la clave
		ADD EDI, KeyCounter									;se corre a la posicion que le toca segun el contador del recorrido de la clave
		MOV AL, [EDI]										;guardar el valor de la posicion en AL
		CMP AL, 0
		JE RestartKey										;si la posicion tiene el valor 0, significa que debe regresar al inicio de la llve
		CMP AL, 61h											;"a"
		JS IgnoreI
		CMP AL, 7Bh											;"{"
		JNS IgnoreI
		MOV MainI, AX
		SUB MainI, 61h
		JMP EndFindI

		RestartKey:
		MOV KeyCounter, 0									;reinicia contador para el recorrido de la llave
		JMP BeginFindI										

		IgnoreI:
		MOV MainI, 1Eh										;30d

		EndFindI:
		INC KeyCounter
	RET
	FindI ENDP

	FindJ PROC NEAR
		XOR AX, AX
		LEA ESI, Message									;apunta al inicio de la cadena del mensaje
		ADD ESI, MsgCounter									;corrimiento hasta donde va el contador de caracteres del mensaje
		MOV AL, [ESI]										;guarda el caracter en la posicion
		CMP AL, 20h											;Evalúa espacio en blanco.
		JE BlankSpace
		CMP AL, 61h											;"a" inicio de intervalo de letras en el ASCII
		JS IgnoreJ
		CMP AL, 7Bh											;"{" marca fin de intervalo de letras en el ASCII
		JNS IgnoreJ
		MOV MainJ, AX
		SUB MainJ, 61h
		JMP EndFindJ

		BlankSpace:
		MOV MainJ, 1Fh										;31d
		JMP EndFindJ

		IgnoreJ:
		MOV MainJ, 1Eh										;30d

		EndFindJ:
		INC MsgCounter
	RET
	FindJ ENDP

	FindIV PROC NEAR
		BeginFindIV:
		XOR AX, AX
		CMP CipherFlag, 1 
		JNE NormalKey
		LEA EDI, Message
		JMP ContAdjust

		NormalKey:
		LEA EDI, Key

		ContAdjust:
		ADD EDI, KeyCounter
		MOV AL, [EDI]
		CMP AL, 0
		JE RestartKeyV
		CMP AL, 61h											;"a" inicio de intervalo letras en el ASCII
		JS IgnoreIV
		CMP AL, 7Bh											;"{" marca fin de intervalo letras en el ASCII
		JNS IgnoreIV
		MOV MainI, AX
		SUB MainI, 61h
		JMP EndFindIV

		RestartKeyV:
		MOV KeyCounter, 0
		MOV CipherFlag, 1
		JMP BeginFindIV

		IgnoreIV:
		MOV MainI, 1Eh										;30d

		EndFindIV:
		INC KeyCounter
	RET
	FindIV ENDP

	FindIDV PROC NEAR
		BeginFindIVV:
		XOR AX, AX
		CMP CipherFlag, 1 
		JNE NormalKeyV
		LEA EDI, SecKey
		JMP ContAdjustV

		NormalKeyV:
		LEA EDI, Key

		ContAdjustV:
		ADD EDI, KeyCounter
		MOV AL, [EDI]
		CMP AL, 0
		JE RestartKeyVV
		CMP AL, 61h											;"a" inicio de las letras en el ASCII
		JS IgnoreIVV
		CMP AL, 7Bh											;"{" marca fin de intervalo de letras en el ASCII
		JNS IgnoreIVV
		MOV MainI, AX
		SUB MainI, 61h
		JMP EndFindIVV

		RestartKeyVV:
		MOV KeyCounter, 0
		MOV CipherFlag, 1
		JMP BeginFindIVV

		IgnoreIVV:
		MOV MainI, 1Eh										;30d

		EndFindIVV:
		INC KeyCounter
	RET
	FindIDV ENDP

	DeduceProcess PROC NEAR
		print chr$("Ingresar criptograma: ", 13, 10)		;solicitar mensaje cifrado
		INVOKE StdIn, ADDR Message, 100
		
		;obtener largo del mensaje
		LEA EDI, Message
		MOV MsgLength, 0
		XOR BL, BL
		XOR CL, CL
		countMsg:
			MOV BL, [EDI]
			CMP BL, 0h									;la cadena se llena de 0, por lo que si encuentra 1 significa ya no es parte del mensaje del usuario
			JE finishCount
			CMP BL, 61h									
			JL notLetter								;ignora los menores a 61h (letra a en ASCII)
			CMP BL, 7Ah
			JG notLetter								;ignora los mayores a 7Ah (letra z en ASCII)

			INC EDI										;mover apuntador
			INC CL										;incrementar contador
			JMP countMsg

		notLetter:
			INC EDI
			JMP countMsg
		finishCount:									;resultado del largo se encuentra guardado en CL
		MOV MsgLength, CL	

		;contar apariciones de cada caracter
		LEA EDI, Message								;apuntador al mensaje
		LEA ESI, AbcCounter								;apuntador al arreglo contador de caracteres
		XOR AX, AX

		countChr:
		XOR EBX, EBX
		MOV BL, [EDI]									;en BL se pasa el valor del ascii en la posicion

		CMP BL, 0h										;0 significa que termino el recorrido
		JE finishCount2
		CMP BL, 61h									
		JL notLetter2									;ignora los menores a 61h (letra a en ASCII)
		CMP BL, 7Ah
		JG notLetter2									;ignora los mayores a 7Ah (letra z en ASCII)

		SUB BL, 61h										;61h = a, que le corresponde la posicion 0 del arreglo contador
		ADD ESI, EBX									;mover el apuntador del arreglo contador a la letra que corresponde
		MOV AL, [ESI]									;guardar valor de la posicion en AL para trabajar calculos sobre el registro
		ADD AL, 01h										;posicion contador++
		MOV [ESI], AL
		LEA ESI, AbcCounter

		notLetter2:
		INC EDI
		LEA ESI, AbcCounter
		JMP countChr

		finishCount2:

		;impresiones
		print chr$(13, 10, "Frecuencias de cada caracter:", 13, 10, 13, 10)	
		LEA ESI, AbcCounter										;apuntador al arreglo contador
		XOR BX, BX
		MOV BL, 10
		INVOKE StdOut, ADDR MsgLength

		imprime:		
		XOR AX, AX
		print chr$("La frecuencia de aparicion del caracter ")	
		INVOKE StdOut, ADDR CharToPrint
		print chr$(" es de: ")

		MOV AL, [ESI]									;valor se pasa a AL para que pueda ser dividido
		DIV BL											;cociente en AL (decenas) residuo AH (unidades)
		ADD AL, 30h
		MOV TensToPrint, AL	
		INVOKE StdOut, ADDR TensToPrint					;imprime decenas
		ADD AH, 30h
		MOV UnitsToPrit, AH	
		INVOKE StdOut, ADDR UnitsToPrit					;imprime unidades

		print chr$(2Fh)									;imprime caracter "/"

		XOR AX, AX
		MOV AL, MsgLength
		DIV BL											;div 10
		ADD AL, 30h
		MOV TensToPrint, AL	
		INVOKE StdOut, ADDR TensToPrint					;imprime decenas
		ADD AH, 30h
		MOV UnitsToPrit, AH	
		INVOKE StdOut, ADDR UnitsToPrit					;imprime unidades		

		print chr$(13, 10)								;salto de linea

		INC ESI
		INC CharToPrint
		XOR CX, CX
		MOV CL, CharToPrint
		CMP CL, 7Bh										;ver si llego a "z"
		JL imprime

	RET 
	DeduceProcess ENDP



END Program