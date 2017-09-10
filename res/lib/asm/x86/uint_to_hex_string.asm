	
; Takes an unsigned integer and converts it to its string representation in hexadecimal
; and inserts that at the given address.
; Up to 8 bytes are overwritten at the given address, 
; though the exact number is (floor(log16(<uint>)) + 1) assuming <uint> isn't zero.
; Input: 	ESI - address of buffer to overwrite
;			EAX - uint to convert
; Output: 	AX - number of bytes used (the number of chars the int representation takes, as described above)
;			
; Uses: eax, ebx, ecx, edx, esi, edi
uint_to_hex_string:
	mov ecx, 0	; number of chars created
	mov ebx, 16	; dividing by hex
	mov edi, esi ; make a copy of the first char address for later
	
	; always convert once
uint_to_hex_string_convert_loop:
	mov edx, 0		; remainders (must be cleared before a doing a 32 bit DIV)
	div ebx			; divide / modulo 16. result of division in eax, modulo in edx
	add dl, 32		; convert remainder to char
	mov [esi], dl	; save char
	add esi, 1		; inc buffer addr
	add cx, 1		; inc char count
	cmp eax, 0
	jne uint_to_hex_string_convert_loop	; if not done
	
	; need to switch the order of the generated number
	sub esi, 1		; esi now points at the last char (edi already points at the first)
	mov bx, cx
	push cx			; store the char nr to be able to use ecx
	shr bx,1		; ebx/2. Now counts the number of switches to do
	cmp bx, 0
	je uint_to_hex_string_switch_ret
	
uint_to_hex_string_switch_loop:
	mov al, [edi]	; hold a copy of the char at edi
	mov cl, [esi] 	; hold a copy of the char at esi
	mov [edi], cl	; move the char that was at esi to edi
	mov [esi], al	; move the char that was at edi to esi
	add edi, 1
	sub esi, 1
	sub bx, 1
	cmp bx, 0
	jne uint_to_hex_string_switch_loop	; more switches needed
	
uint_to_hex_string_switch_ret:
	pop ax
	ret
	
