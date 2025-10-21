global _start

section .data
    filename db "output.txt", 0        ; имя файла 
    message  db "Hello, world", 10     
    length   equ $ - message           
    err_msg  db "Error", 10
    err_len  equ $ - err_msg
section .text
_start:
     
    mov rax, 2               ; номер системного вызова open(filename, O_WRONLY | O_CREAT | O_TRUNC, 0644)
    mov rdi, filename        ; указатель на имя файла
    mov rsi, 577             ; флаги  = O_WRONLY|O_CREAT|O_TRUNC
    mov rdx, 0o644           ; права 
    syscall
    cmp rax, 0               ; проверка
    jl .error_exit           ; если ошибка, переход на обработку
    mov rbx, rax             ; чтобы не потерять значение 

    mov rax, 1               ; записываем в файл
    mov rdi, rbx             
    mov rsi, message         
    mov rdx, length  
    mov rcx, rdx             ; возможно вызов syscall перезаписывает регистр rdx, поэтому для проверки нужно сохранить ожидаемую длину        
    syscall
    cmp rax, 0                    ; 1. Проверяем на отрицательное значение
    jl .error_exit_clouse                                      
    ;cmp rax, rcx                  ; 2. совпадает ли rax с rdx
    ;jne .error_exit_clouse

    mov rax, 3                    ; закрывает
    mov rdi, rbx
    syscall
    cmp rax, 0                    ; Проверяем, вернул ли close ошибку
    jl .error_exit

    mov rax, 60              ; успешный выход
    xor rdi, rdi             ; код возврата = 0
    syscall

.error_exit:
    mov rax, 1                    
    mov rdi, 2                    
    mov rsi, err_msg              
    mov rdx, err_len              
    syscall                       

    mov rax, 60                   
    mov rdi, 1                    ; rdi = 1 (ошибка)
    syscall 

.error_exit_clouse:      ;если файл открыт при возникновении ошибки
    mov rax, 3                    
    mov rdi, rbx  
    syscall                                      
    jmp .error_exit