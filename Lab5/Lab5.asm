.MODEL SMALL
.DATA
	FirRequest DB 'Ingrese un numero (maximo 128): $'
	ResultMsg DB 13, 10, 'Factorial: $'			
	Aux DW 0
    Count DW 0
	FactIndex DB 0			 	
	MULtIndex DB 0 				
	Carry DB 0
    FirString DB 300 DUP ('$')		
	SecString DB 300 DUP ('$')	
.STACK
.CODE	
MOV AX, @DATA	            	;INICIALIZACIÓN.
MOV DS, AX
XOR AX, AX
Main:
	CALL ReaDInput
	CALL Factorial
	CALL StringToNum
	XOR DX, DX
	LEA DX, ResultMsg
	MOV AH, 09h
	INT 21h
	LEA DX, FirString
	INT 21h	
EndProgram:
	MOV AH, 4Ch
	INT 21h  
	
ReaDInput PROC NEAR
	LEA DX, FirRequest
	MOV AH, 09h
	INT 21h
	XOR AX, AX
	XOR BX, BX
	XOR DX, DX
	MOV FactIndex, 0
	MOV Aux, 0
	MOV BL, 10d			
	MOV AH, 01h					;LECTURA DE DÍGITO.		
	INT 21h
	SUB AL, 30h					;AJUSTE DE ASCII.
	MOV DL, AL
	XOR AH, AH
	MOV Aux, AX			
	MOV AH, 01h	 				;LECTURA DE DÍGITO.
	INT 21h
	MOV CL, AL			
	SUB CL, 30h			        ;AJUSTE DE ASCII.
	CMP AL, 0Dh			
	JE EndReaDInput             ;SALTA A EndReaDInput SI SE PRESIONA ENTER.
	XOR AX, AX
	MOV AX, Aux
	MUL BX				
	MOV Aux, AX
	ADD Aux, CX				
	MOV AH, 01h					;LECTURA DE DÍGITO.
	INT 21h
	MOV CL, AL			
	SUB CL, 30h			        ;AJUSTE DE ASCII.
	CMP AL, 0Dh			
	JE EndReaDInput             ;SALTA A EndReadInput SI SE PRESIONA ENTER.
	XOR AX, AX
	MOV AX, Aux
	MUL BX				
	MOV Aux, AX
	ADD Aux, CX				
EndReaDInput:
	XOR AX, AX
	MOV AX, Aux
	MOV FactIndex, AL
RET
ReaDInput ENDP

Factorial PROC NEAR
	CALL NumToString
	FactProcess:
		XOR DL, DL
		DEC FactIndex			
		CMP FactIndex, 0h		
		JE EndFact            	;SALTA A EndFact SI EL ÍNDICE ES CERO.
		MOV DL, FactIndex		
		MOV MultIndex, DL
		CALL MULtStrings	
		JMP FactProcess		  	;SALTA A Fact.
	EndFact:
		MOV FactIndex, 0h					
RET
Factorial ENDP
	
MultStrings PROC NEAR
	CALL CopyString	
	MultProcess:
		DEC MultIndex
		CMP MultIndex, 0h		
		JE EndMult           	;SALTA A EndMult SI EL ÍNDICE ES 0.
		CALL AddStrings			
		JMP MultProcess		    ;SALTA A MultProcess.
	EndMult:
		MOV MultIndex, 0h
RET
MultStrings ENDP
	
ADDStrings PROC NEAR
	LEA SI, FirString		
	LEA DI, SecString
	ReadAll:
		MOV AL, [SI]
		CMP AL, 24h				            
		JE AddProcess			;SALTA A AddProcess SI YA NO HAY DÍGITOS.			
		INC SI
		INC DI
		INC Count
		JMP ReadAll             ;SALTA A ReadAll.
	AddProcess:
		DEC SI	
		DEC DI	
		DEC Count
	Addition:
		XOR AX, AX
		XOR BX, BX
		XOR CX, CX
		MOV BL, [SI]	
		MOV CL, [DI]	
		ADD BL, CL
		ADD BL, Carry
		MOV Carry, 0h
		CMP BL, 0AH		
		JL NonCarry           	;SALTA A NonCarry SI ES MENOR A CERO.
		MOV Carry, 1h	
		SUB BL, 0AH	
	NonCarry:
		MOV [SI], BL
		DEC SI
		DEC DI
		DEC Count
		CMP Count, 0h
		JGE Addition			;SALTA A Addition SI AÚN QUEDAN DÍGITOS.
	EndAdd:
		CALL StartMove
		MOV Count, 0h
RET
AddStrings ENDP
	
StartMove PROC NEAR
	CMP Carry, 0h		           
	JE EndStartProcess			;SALTA A EndStartProcess SI NO HAY ACARREO
	CALL ToRightString	            
	CALL MoveToRight		        
	XOR BX, BX			    
	MOV BL, Carry		    
	LEA SI, FirString		    
	MOV [SI], BL		    
	EndStartProcess:
		MOV Carry, 0h		    
RET
StartMove ENDP
	
ToRightString PROC NEAR
	XOR CX, CX			
	LEA SI, FirString		
	MOV CL, 2Bh
	MoveProcess:
		XOR AX, AX
		XOR BX, BX
		MOV BL, [SI]
		MOV [SI], CL
		MOV CL, BL
		INC SI
		MOV AL, [SI]
		CMP AL, 24h
		jne MoveProcess		 	;SALTA A MoveProcess SI AÚN QUEDAN DÍGITOS.
		MOV [SI], CL	
RET
ToRightString ENDP
	
MoveToRight PROC NEAR
	XOR CX, CX			
	LEA SI, SecString		
	MOV CL, 0h			
	MoveSProcess:
		XOR AX, AX
		XOR BX, BX
		MOV BL, [SI]	
		MOV [SI], CL	
		MOV CL, BL		
		INC SI			
		MOV AL, [SI]	
		CMP AL, 24h		
		JNE MoveSProcess		;SALTA A MoveSProcess SI AÚN QUEDAN DÍGITOS.
		MOV [SI], CL	
RET
MoveToRight ENDP
	
CopyString PROC NEAR
	XOR DX, DX
	XOR AX, AX
	LEA SI, FirString	
	LEA DI, SecString	
	Copy:
		XOR DL, DL
		MOV DL, [SI]
		MOV [DI], DL
		INC SI			
		INC DI
		MOV AL, [SI]	
		CMP AL, 24h		
		JNE Copy	         	;SALTA A Copy SI AÚN QUEDAN DÍGITOS.
RET
CopyString ENDP
	
NumToString PROC NEAR
	XOR BX, BX
	XOR CX, CX
	LEA SI, FirString	
	MOV BL, FactIndex
	CMP BX, 09h				        
	JLE Units		           	;SALTA A Units SI EL NÚMERO ES DE UN DÍGITO.
	CMP BX, 63h				
	JLE Tens		            ;SALTA A Tens SI EL NÚMERO ES DE DOS DÍGITOS.
	JMP Hundreds		        ;SALTA A Hundreds SI EL NÚMERO ES DE TRES DÍGITOS.
	AUnit:
		MOV [SI], CL			    
		INC SI					    
	Units:
		MOV [SI], BL			   
		JMP EndProc             ;SALTA A EndProc.
	ATens:
		MOV [SI], CL
		INC SI					    
		XOR CL, CL
	Tens:
		CMP BL, 09h
		JLE AUnit			    ;SALTA A AUnit SI QUEDA UN DÍGITO. 
		SUB BL, 0AH				   
		INC CL					;CONTADOR DE DECENAS.
		JMP Tens		        ;SALTA A Tens.
	Hundreds:
		CMP BL, 63h
		JBE ATens			    ;SALTA A ATens SI TIENE DOS DÍGITOS.
		SUB BL, 64h			
		INC CL					;CONTADOR DE CENTENAS.
		JMP Hundreds		    ;SALTA Hundreds
	EndProc:
RET
NumToString ENDP
	
StringToNum PROC NEAR
	LEA SI, FirString	
	Adjust:
		XOR AX, AX
		XOR BX, BX
		MOV BL, [SI]
		ADD BL, 30h		        ;AJUSTE DE ASCII
		MOV [SI], BL	
		INC SI			
		MOV AL, [SI]	
		CMP AL, 24h		
		JNE Adjust		        ;SALTO A Adjust SI QUEDAN DÍGITOS.
RET
StringToNum ENDP

ClearString PROC NEAR
	LEA SI, FirString	
	Clear:
		XOR AX, AX
		MOV BL, '$'
		MOV [SI], BL
		INC SI			
		MOV AL, [SI]	
		CMP AL, 24h		
		JNE Clear	                ;SALTA A Clear SI AÚN QUEDAN DÍGITOS
RET
ClearString ENDP
END