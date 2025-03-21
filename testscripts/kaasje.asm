; Assembly code to open a webpage in a borderless window
; Platform detection and universal approach

section .data
    ; Windows command
    win_cmd     db 'start /b cmd /c "explorer.exe --no-default-browser-check --app=https://www.example.com"', 0
    ; macOS command
    mac_cmd     db 'open -a "Google Chrome" --args --app=https://www.example.com', 0
    ; Linux command
    linux_cmd   db 'xdg-open https://www.example.com || google-chrome --app=https://www.example.com || firefox --kiosk https://www.example.com', 0
    
    ; Error messages
    err_msg     db "Error executing command", 10, 0
    
section .text
    global _start
    
_start:
    ; Detect OS (simplified approach)
    ; In real implementation, you would use CPUID or OS-specific syscalls
    
    ; For demonstration, we'll use a conditional compilation approach
    ; You would need to define the OS during compilation with -D flag
    
%ifdef WINDOWS
    mov rdi, win_cmd
%elifdef MACOS
    mov rdi, mac_cmd
%else  ; Default to Linux
    mov rdi, linux_cmd
%endif

    call system_call
    
    ; Exit program
    mov rax, 60       ; syscall: exit (Linux)
    xor rdi, rdi      ; status: 0
    syscall
    
system_call:
    ; This is a simplified wrapper for system()
    ; In reality, you'd need to implement this differently per OS
    
%ifdef WINDOWS
    ; Windows implementation would use WinAPI
    extern system
    call system
%elifdef MACOS
    ; macOS implementation would use syscalls
    extern system
    call system
%else
    ; Linux implementation
    push rdi
    mov rax, 11       ; execve syscall
    lea rdi, [rsp]    ; command string
    xor rdx, rdx      ; no environment variables
    syscall
    
    ; Check for error
    test rax, rax
    js error
    
    pop rdi           ; clean up stack
    ret
    
error:
    mov rax, 1        ; write syscall
    mov rdi, 2        ; stderr
    mov rsi, err_msg
    mov rdx, 21       ; length
    syscall
    
    mov rax, 60       ; exit syscall
    mov rdi, 1        ; error code
    syscall
%endif
    ret