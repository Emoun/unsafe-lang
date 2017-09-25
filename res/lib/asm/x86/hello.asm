.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib

.data
	; the addresses of the globals below
	; go from low addresses to high, from the first globals up to down
	
	; fx addr 0
	outBufUse	DWORD 0
	; fx addr 4
	outBuf		BYTE 20 dup (0)
	; fx addr 24 and so on
	inBufUse	DWORD 0
	inBuf		BYTE 20 dup (0)
	startingValues	db "Starting",2,"values",58,4
	finalValues	db "Final",2,"values",58,4
	startOfDynamicArrayValues db "Values",2,"at",2,"start",2,"of",2,"dynamicArray",58,4
	lengthString db "Length",58,2
	SPACE		BYTE 2
	TAB			BYTE 3
	NL			BYTE 4
.code

include stdout.asm
include stdin.asm
include uint_to_hex_string.asm
include string_to_int.asm
include print_esp.asm
include i32_array.asm

start:
	mov ebx, offset startingValues
	mov ecx, 17
	call stdout
	call print_ebp
	call print_esp
	
	mov esi, 030h
	call i32_array
	
	mov ebx, offset lengthString
	mov ecx, 8
	call stdout
	
	; Print array length
	mov esi, offset outBuf
	mov eax, [esp]
	call uint_to_hex_string
	
	mov ebx, offset outBuf
	mov ecx, 0
	mov cx, ax
	call stdout
	
	mov ebx, offset NL
	mov ecx, 1
	call stdout
	
	mov edx, [esp] 		; load the array length
	mov ecx, 0			; iteration counter
	mov edi, esp		; The address of the array header
	
print_array:
	cmp ecx, edx
	jge print_array_end
	add edi, 4			; move pointer to next element
	mov eax, [edi]		; load element value
	mov esi, offset outBuf
	push ecx
	push edx
	push edi
	call uint_to_hex_string
	
	mov ebx, offset outBuf
	mov ecx, eax
	call stdout
	mov ebx, offset NL
	mov ecx, 1
	call stdout
	pop edi
	pop edx
	pop ecx
	add ecx, 1
	jmp print_array
	
	
print_array_end:
	
	mov ebx, offset finalValues
	mov ecx, 14
	call stdout
	call print_ebp
	call print_esp

exit:
	mov eax, 0
	push 0
	call ExitProcess
	


	
	
end start
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
