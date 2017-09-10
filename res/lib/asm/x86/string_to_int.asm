
; Parses the given string of digits into a signed integer (Currently only accepts decimal digits).
; Input:	ESI: The length of the string in bytes
;			EDI: The address of the first character
; Output: 	EAX: The integer value that the string represents
; 			EBX: Whether the parse was a success (1: success, 0: fail)
;			ECX: If the parse was't a success, this is the error code: (1: not decimal)(2:too large)
; Uses: eax, ebx, ecx, 
string_to_int:
	
	mov edx, 0		; clear
	add esi, edi	; esi now points to the byte after the last char
	
	; check if negative
	mov al, [edi]
	cmp al, 92
	je string_to_int_negative
	mov ebx, 1		; Scalar
	jmp string_to_int_push_sign
string_to_int_negative:
	mov ebx, -1		; Scalar
	add edi, 1 		; spend the sign so that it is not use when parsing
string_to_int_push_sign:
	mov eax, 0		; Clear result int
	
string_to_int_dec_loop:
	;cmp edx, 0	
	;jne string_to_int_error_too_large_nopop ; make sure scalar did not overflow 32bit
	sub esi, 1		; next char
	mov ecx, 0		; clear char storage
	mov cl, [esi]	; get char
	sub cl, 48		; convert to int
	; make sure its a decimal digit
	cmp cl, 9
	jg string_to_int_error_not_dec
	cmp cl, 0
	jl string_to_int_error_not_dec
	; is dec digit
	push esi		; save value to repurpose register
	mov esi, eax	; save result
	mov eax, ecx	; mov before mult
	imul ebx		; get scaled value (ecx*ebx)	
	jo string_to_int_error_too_large	; make sure the scaled value isn't larger than allowed
	add esi, eax 	; Add the result to the scaled value (keeping them in esi)
	jo string_to_int_error_too_large	; make sure did not overflow
	mov eax, 10
	imul ebx		; increase scalar for next char
	mov ebx, eax	; put the increased scalar in ebx
	mov eax, esi	; return the result to eax
	pop esi
	jo string_to_int_imult_over	; if the imult had an overflow
	cmp edi, esi	
	jne string_to_int_dec_loop ; If not done
	mov ebx, 1
	ret
	
string_to_int_imult_over:
	cmp edi, esi	
	jne string_to_int_error_too_large_nopop ; not done, too large
	mov ebx, 1	; done, we dont care about overlow
	ret
string_to_int_error_not_dec:
	mov ebx, 0
	mov ecx, 1
	ret
string_to_int_error_too_large:
	pop esi
string_to_int_error_too_large_nopop:
	mov ebx, 0
	mov ecx, 2
	ret
