
; Outputs to std out. Currently currupts the stack
; Input:	EBX: 	The address of the first byte to output.
;			ECX:	The maximum number of bytes to output.
; Output:	EAX: The number of bytes written.
; Uses: EAX, ECX, EDX
stdout:
	push ebp
	mov ebp, esp
	push eax	; bWritten (ebp -4): the number of output byte written
	push ecx	; save ECX as it migh be corrupted by GetStdHandle
	
	; call GetStdHandle
	push STD_OUTPUT_HANDLE
	call GetStdHandle	; handle in EAX
	pop ecx				; reload
	
	; call WriteFile
	push 0		; overlap
	mov edx, ebp
	sub edx, 4	; *bWritten
	push edx	; *bWritten
	push ecx	; buffer Length
	push ebx	; buffer address
	push eax	; handle
	call WriteFile	; success (!0) in EAX
	
	pop eax	; pop bWritten
	pop ebp	; reload caller ebp
	ret
	
	
	
	
	