; Returns an DWORD array with the given length
; Input: 	ESI: Array length
; Output:	[DWORD: =in(ESI)]: An array with the number of elements given in EAX
; uses:	eax, ebx, ecx, edx, esi, edi
i32_array:
	push ebp
	mov ebp, esp
	mov ebx, 4		; The size of each element in the array
	mov eax, esi
	mul ebx			; The total size of the array sizeof(DWORD)*length
	sub esp, eax	; Move the stack pointer to the end of the array.
	mov edi, esp	; pointer to the first element
	push esi		; allocate room the for the length and store it
	mov ecx, 1		; counter 'i'

i32_array_fill_for:	; Fill the array with values (1..length)
	cmp ecx, esi					; 
	jg i32_array_fill_for_end	; for i<= array.length
	mov [edi], ecx					; array[i] = i (abstractly, not really)
	inc ecx							; i++
	add edi, 4						; increment pointer to next element
	jmp i32_array_fill_for		; for loop	

i32_array_fill_for_end:
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
	
i32_array_moveback_for:
	cmp ebx, ecx
	jge i32_array_moveback_for_end	; i<ecx
	mov al, [edi]
	add edi, 8
	mov [edi], al
	sub edi, 9
	inc ebx
	jmp i32_array_moveback_for
i32_array_moveback_for_end:
	add esp, 8	; the is moved back with the data
	pop ebp
	ret


; Takes two i32_arrays of the same length and returns an array with the summed values (by index).
; Input:	[DWORD: x]: First array with length 'x'.
;			[DWORD: x]: Second array with the same length as the first array.
; Output: 	[DWORD: x]: Array containing the sum of the input arrays' indeces. 
;						Has the same length as the given arrays.
; uses:	eax, ebx, ecx, edx, esi, edi
i32_array_interleave:
	push ebp
	mov ebp, esp
	mov esi, [ebp+8]	; start by getting the length of the arrays
	
	; calculate the size of the resulting array
	mov eax, 4		; i32 size
	mul esi			; size of the elements
	add eax, 4		; add the header
	
	; allocate it on the stack
	sub esp, eax	
	mov [esp], esi		; insert the header
	
	; calculate and insert sums
	mov ecx, 0
	add ecx, [esp]
	
	; move callers ebp and return address to after the return array
	
	; move ebp, return, and array up to the ebp.
	
	; return
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	