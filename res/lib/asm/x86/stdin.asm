; Load input from stdin into the given buffer. Currently currupts the stack
; Parameters: 	ESI: Address to start putting input in
;				EDI: The number of free bytes in the buffer. 
;					NOTE: NOT the max number of bytes to load, but the number of bytes that
;						this function may corrupt. 
;					Ex: stdin has 5 bytes of input, the first 5 bytes will be 
;						loaded with the input, while 2 more bytes WILL be corrupted in the process.
;						Therefore, to load all the input, bLen = 7 is needed, 
;						which results in 5 bytes being read
; returns:	eax - The number of bytes read
;			ebx - Whether there is more input (1: yes, 0:no)
stdin:
	push ebp
	mov ebp, esp
	push eax	; bRead (ebp -4), will hold the amount of bytes read
	
	push STD_INPUT_HANDLE
	call GetStdHandle	; eax has handle	
    push eax			; save handle before function call
	
	mov ebx, ENABLE_LINE_INPUT
	or ebx, ENABLE_ECHO_INPUT
	or ebx, ENABLE_PROCESSED_INPUT
	push ebx			; console mode	
	push eax			; handle
	call SetConsoleMode	; handle poped by SetConsoleMode
	pop eax				; restore handle
	
	mov edx, 0
	push edx	; overlap
	mov edx, ebp
	sub edx, 4
	push edx	; *bRead
	push edi	; buffer length
	push esi	; buffer address
	push eax	; handle
	call ReadFile

  ; -------------------------------
  ; strip the CR LF from the result
  ; -------------------------------
    
	mov edx, ebp
	sub edx, 4
	mov ecx, [edx]		; bRead
	mov edx, esi		; buffer start
	mov ebx, 0			; track cleared CR or NL
	mov eax, 1			; more input (default true)
stdin_for_start:
	cmp ecx, 0			; If done
	je stdin_for_end
stdin_for_try_cr:
    cmp BYTE PTR [edx], 13 	; 
	jne stdin_for_try_nl	; If not CR
	add ebx, 1				; found CR
	jmp stdin_for_continue
stdin_for_try_nl:
	cmp BYTE PTR [edx], 10 	; 
	jne stdin_for_continue	; If not NL
	add ebx, 1				; Found NL
	mov eax, 0				; no more input
	jmp stdin_for_end		; break
stdin_for_continue:
	add edx, 1
	sub ecx, 1
	jmp stdin_for_start
stdin_for_end:
	mov ecx, eax	; Save whether input done
	mov edx, ebp
	sub edx, 4
	mov eax, [edx]	; bRead
    sub eax, ebx	; Subtract the number of CR or NL found from the amount read
	mov ebx, ecx	; return whether there is more input
	pop edx			; pop bRead
	pop ebp			; restore
    ret

