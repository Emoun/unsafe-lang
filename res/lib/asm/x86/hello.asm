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
	SPACE		BYTE 2
	TAB			BYTE 3
	NL			BYTE 4
.code

include stdout.asm
include stdin.asm
include uint_to_hex_string.asm
include string_to_int.asm
include print_esp.asm

start:
	mov ebx, offset startingValues
	mov ecx, 17
	call stdout
	call print_ebp
	call print_esp
	
	mov esi, 0
	call dynamic_array
	
	mov ebx, offset finalValues
	mov ecx, 14
	call stdout
	call print_ebp
	call print_esp

exit:
	mov eax, 0
	push 0
	call ExitProcess
	
; Returns an DWORD array with the given length
; Input: 	ESI: Array length
; Output:	[DWORD; ESI]: An array with the number of elements given in EAX
; uses:	eax, ebx, ecx, edx, esi, edi
dynamic_array:
	mov ebx, offset startOfDynamicArrayValues
	mov ecx, 33
	call stdout
	call print_ebp
	call print_esp
	push ebp
	mov ebp, esp
	mov ebx, 4		; The size of each element in the array
	mov eax, esi
	mul ebx			; The total size of the array sizeof(DWORD)*length
	sub esp, eax	; Move the stack pointer to the end of the array.
	mov edi, esp	; pointer to the first element
	push esi		; allocate room the for the length and store it
	mov ecx, 1		; counter 'i'

dynamic_array_fill_for:	; Fill the array with values (1..length)
	cmp ecx, esi					; 
	jg dynamic_array_fill_for_end	; for i<= array.length
	mov [edi], ecx					; array[i] = i (abstractly, not really)
	inc ecx							; i++
	add edi, 4						; increment pointer to next element
	jmp dynamic_array_fill_for		; for loop	

dynamic_array_fill_for_end:
	; now esp is pointing to the start of: array =  struct{ length:DWORD, array: length*DWORD}
	; after the array on the stack first comes the callers ebp then the return value.
	; We need move the array so that its last element takes up the return values position
	; and the ebp + return value are before the array in memory (I.e. on the top of the stack, since it grows down)
	; so that we can return gracefully to the caller.
	; register overview:
	; 	eax, ebx, ecx, edx, edi : free
	; 	esi: the length of the array (so the array takes up (esi*4)+4 bytes.	
	mov eax, 4	
	mul esi			; eax = (esi*4)
	add eax, 4		; eax = eax + 4
	mov ecx, eax	; ecx now contains the size (in bytes) of the array
	add eax, esp	; eax now points to the first byte after the array
	sub eax, 1
	mov edi, eax		; edi now points to the last used byte (not array element)
	
	; we now take the callers ebp and the return address and store them on the top of the stack
	mov eax, [ebp+4]
	push eax		; return address
	mov eax, [ebp]
	push eax		; callers ebp
	add ecx, 8		; we add 8 to the size to be moved so that the ebp and return address are also moved back with the array
	mov ebx, 0		; i
	call print_ebp
	call print_esp
	
dynamic_array_moveback_for:
	cmp ebx, ecx
	jge dynamic_array_moveback_for_end	; i<ecx
	mov al, [edi]
	add edi, 8
	mov [edi], al
	sub edi, 9
	inc ebx
	jmp dynamic_array_moveback_for
dynamic_array_moveback_for_end:
	add esp, 8	; the is moved back with the data
	call print_ebp
	call print_esp
	; in theory we are now done
	pop ebp
	ret
	
	
end start
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
