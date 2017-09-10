.data
	print_esp_str	db "ESP",58,2 ;"ESP: "
	print_ebp_str	db "EBP",58,2 ;"ESP: "
	print_esp_NL	BYTE 4
	print_esp_buf	BYTE 10 dup (0)
	
.code

; Prints the address of the ESP as seen from the caller.
; Input:
; Output:
; Uses:
print_esp:
	push ebp
	mov ebp, esp
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	
	mov ebx, offset print_esp_str
	mov ecx, 5
	call stdout
	
	mov eax, ebp
	add eax, 8		;To print the ESP of the caller
	mov esi, offset print_esp_buf
	call uint_to_hex_string
	
	mov ebx, offset print_esp_buf
	mov ecx, eax
	call stdout
	
	mov ebx, offset print_esp_NL
	mov ecx, 1
	call stdout
	
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret
	
; Prints the address of the EBP as seen from the caller.
; Input:
; Output:
; Uses:
print_ebp:
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	mov ebx, offset print_ebp_str
	mov ecx, 5
	call stdout
	
	mov eax, ebp
	mov esi, offset print_esp_buf
	call uint_to_hex_string
	
	mov ebx, offset print_esp_buf
	mov ecx, eax
	call stdout
	
	mov ebx, offset print_esp_NL
	mov ecx, 1
	call stdout
	
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret