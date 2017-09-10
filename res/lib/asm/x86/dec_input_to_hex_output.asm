.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
	outBufUse	DWORD 0
	outBuf		BYTE 20 dup (0)
	inBufUse	DWORD 0
	inBuf		BYTE 20 dup (0)
	parseFail1	db "ParseNotDec",0
	parseFail2	db "ParseTooLar",0
	parseFail3	db "ParseUnknow",0
	error1		db "e1",0
	error2		db "e2",0
	error3		db "e3",0
.code

include stdout.asm
include stdin.asm
include uint_to_hex_string.asm
include string_to_int.asm

start:

start_more_input:
	invoke stdin, ADDR inBuf, 20	; eax has the nr of input bytes read
	mov esi, eax
	mov edi, offset inBuf
	call string_to_int	; eax has the integer from input
	cmp ebx, 1
	jne start_parse_fail
	mov esi, offset outBuf
	call uint_to_hex_string
	invoke stdout, offset outBuf, ax
exit:
	invoke ExitProcess, 0
	
start_parse_fail:
	cmp ecx, 1
	je start_parse_not_dec
	cmp ecx, 2
	je start_parse_too_large
	invoke stdout, offset parseFail3, 11
	jmp exit
start_parse_not_dec:
	invoke stdout, offset parseFail1, 11
	jmp exit
start_parse_too_large:
	invoke stdout, offset parseFail2, 11
	jmp exit
	
	
	
end start
	
	
	
	
	
	
