global _start                 

section .data
    message db "Hello world!", 10    
    length  equ $ - message          
    err_msg db "Error", 10  
    err_len equ $ - err_msg

section .text
_start:
    
    mov rax, 1              ; 1 — номер системного вызова write
    mov rdi, 1              ; 1 — stdout
    mov rsi, message         ; адрес строки
    mov rdx, length          ; количество байт
    syscall
    cmp rax, 0
    jl write_error  
    cmp rax, length           ; проверяем равны ли значения 
    jne write_error           
    mov rax, 60              ; верное завершение
    xor rdi, rdi             ; код возврата 0
    syscall

write_error:
    
    mov rax, 1               
    mov rdi, 2               
    mov rsi, err_msg         ; сообщение об ошибке
    mov rdx, err_len         ; длина сообщения
    syscall
    mov rax, 60              ; Выход ошибки
    mov rdi, 1               ; код возврата 1
    syscall