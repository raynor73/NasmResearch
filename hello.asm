    global _main
    
    extern _sprintf_s
    extern _strnlen
    extern _memset
    extern _AllocConsole@0
    extern _GetStdHandle@4
    extern _ReadConsoleA@20
    extern _WriteConsoleA@20
    extern _GetModuleHandleA@4
    extern _RegisterClassA@4
    extern _CreateWindowExA@48
    extern _ShowWindow@8
    extern _PeekMessageA@20
    extern _GetLastError@0
    extern _DefWindowProcA@16
    extern _GetMessageA@16
    extern _TranslateMessage@4
    extern _DispatchMessageA@4
    extern _PostQuitMessage@4
    extern _FillRect@12
    extern _BeginPaint@8
    extern _EndPaint@8
    extern _LoadCursorA@8

    section .text
_main:
    push ebp
    mov ebp, esp
    sub esp, 84
    ; [ebp - 4] tmp
    ; [ebp - 8] inputHandle
    ; [ebp - 12] outputHandle
    ; [ebp - 52] wc
    ; [ebp - 56] hWnd
    ; [ebp - 84] msg

    call _AllocConsole@0

    push STD_INPUT_HANDLE
    call _GetStdHandle@4
    mov [ebp - 8], eax

    push STD_OUTPUT_HANDLE
    call _GetStdHandle@4
    mov [ebp - 12], eax



    push dword WNDCLASSA_size
    push dword 0
    lea eax, [ebp - 52]
    push eax
    call _memset
    add esp, 12
    
    push dword MSG_size
    push dword 0
    lea eax, [ebp - 84]
    push eax
    call _memset
    add esp, 12

    push dword IDC_ARROW
    push dword 0
    call _LoadCursorA@8
    mov [ebp - 52 + WNDCLASSA.hCursor], eax

    push dword 0
    call _GetModuleHandleA@4
    
    cmp eax, 0
    jz getModuleHandleFailed
        
    mov [ebp - 52 + WNDCLASSA.hInstance], eax ; result of GetModuleHandleA call
    mov dword [ebp - 52 + WNDCLASSA.lpszClassName], window_class_name
    mov dword [ebp - 52 + WNDCLASSA.lpfnWndProc], windowProcedure
    lea eax, [ebp - 52]
    push eax
    call _RegisterClassA@4
    
    cmp ax, 0
    jz registerClassFailed
    
    push dword 0
    push dword [ebp - 52 + WNDCLASSA.hInstance]
    push dword 0
    push dword 0
    push dword CW_USEDEFAULT
    push dword CW_USEDEFAULT
    push dword CW_USEDEFAULT
    push dword CW_USEDEFAULT
    push dword WS_OVERLAPPEDWINDOW
    push dword window_class_name
    push dword window_class_name
    push dword 0
    call _CreateWindowExA@48
    
    cmp eax, 0
    jz createWindowFailed
    
    push SW_SHOWNORMAL
    push eax ; hWnd from result of _CreateWindowExA@48 call
    call _ShowWindow@8
    
message_loop:
    push dword 0
    push dword 0
    push dword 0
    lea eax, [ebp - 84]
    push eax
    call _GetMessageA@16
    
    cmp eax, 0
    jle finish_message_loop

    lea eax, [ebp - 84]
    push eax
    call _TranslateMessage@4

    lea eax, [ebp - 84]
    push eax
    call _DispatchMessageA@4

    jmp message_loop
    
finish_message_loop:
    jmp finish
    
    
    
getModuleHandleFailed:
    push 0
    lea ebx, [ebp - 4]
    push ebx
    push get_module_handle_failed_msglen
    push get_module_handle_failed_msg
    push dword [ebp - 12]
    call _WriteConsoleA@20
    
    jmp finish
    
createWindowFailed:
    call _GetLastError@0
    push eax
    push error_code_msg
    push BUFFER_SIZE
    push buffer
    call _sprintf_s
    add esp, 16

    push 0
    lea ebx, [ebp - 4]
    push ebx
    push create_window_failed_msglen
    push create_window_failed_msg
    push dword [ebp - 12]
    call _WriteConsoleA@20
        
    push BUFFER_SIZE
    push buffer
    call _strnlen
    add esp, 8
    
    push 0
    lea ebx, [ebp - 4]
    push ebx
    push eax
    push buffer
    push dword [ebp - 12]
    call _WriteConsoleA@20
    
    jmp finish

registerClassFailed:
    call _GetLastError@0
    push eax
    push error_code_msg
    push BUFFER_SIZE
    push buffer
    call _sprintf_s
    add esp, 16

    push 0
    lea ebx, [ebp - 4]
    push ebx
    push register_class_failed_msglen
    push register_class_failed_msg
    push dword [ebp - 12]
    call _WriteConsoleA@20
        
    push BUFFER_SIZE
    push buffer
    call _strnlen
    add esp, 8
    
    ;push 0
    ;lea ebx, [ebp - 4]
    ;push ebx
    ;push eax
    ;push buffer
    ;push dword [ebp - 12]
    ;call _WriteConsoleA@20
    
    jmp finish
    
    

finish:
    ;push 0
    ;lea ebx, [ebp - 4]
    ;push ebx
    ;push register_class_failed_msglen
    ;push register_class_failed_msg
    ;push dword [ebp - 12]
    ;call _WriteConsoleA@20

    push 0
    lea ebx, [ebp - 4]
    push ebx
    push press_enter_msglen
    push press_enter_msg
    push dword [ebp - 12]
    call _WriteConsoleA@20

    push 0
    lea ebx, [ebp - 4]
    push ebx
    push 1
    push input_buffer
    push dword [ebp - 8]
    call _ReadConsoleA@20

    mov esp, ebp
    pop ebp

    xor eax, eax
    ret

windowProcedure:
    push ebp
    mov ebp, esp
    sub esp, 68
    ; [ebp + 20] lParam
    ; [ebp + 16] wParam
    ; [ebp + 12] message
    ; [ebp + 08] hWnd
    ; [ebp - 04] hdc
    ; [ebp - 68] ps

    mov eax, [ebp + 12]
    cmp eax, WM_DESTROY
    jz wm_destroy
    
    cmp eax, WM_PAINT
    jz wm_paint
    
    jmp window_procedure_default

wm_paint:
    lea eax, [ebp - 68]
    push eax
    push dword [ebp + 8]
    call _BeginPaint@8
    mov [ebp - 4], eax

    mov eax, COLOR_WINDOW
    inc eax
    push eax
    lea eax, [ebp - 68 + PAINTSTRUCT.rcPaint]
    push eax
    push dword [ebp - 4]
    call _FillRect@12

    lea eax, [ebp - 68]
    push eax
    push dword [ebp + 8]
    call _EndPaint@8

    jmp window_procedure_end

wm_destroy:
    push dword 0
    call _PostQuitMessage@4
    
    jmp window_procedure_end

window_procedure_default:
    push dword [ebp + 20]
    push dword [ebp + 16]
    push dword [ebp + 12]
    push dword [ebp + 08]
    call _DefWindowProcA@16

window_procedure_end:
    mov esp, ebp
    pop ebp
    
    ret 16

    section .data
window_class_name               db      'Hello World Window Class', 0

register_class_failed_msg       db      'RegisterClass call failed', 10
register_class_failed_msglen    equ     $ - register_class_failed_msg

create_window_failed_msg        db      'CreateWindowEx call failed', 10
create_window_failed_msglen     equ     $ - create_window_failed_msg

get_module_handle_failed_msg    db      'GetModuleHandle call failed', 10
get_module_handle_failed_msglen equ     $ - get_module_handle_failed_msg

press_enter_msg                 db      'Press ENTER to continue...', 10
press_enter_msglen              equ     $ - press_enter_msg

error_code_msg                  db      'Error code: %d', 10, 0

    section .bss
buffer                          resb    BUFFER_SIZE
input_buffer                    resb    BUFFER_SIZE

BUFFER_SIZE                     equ     1024

%include "winuser.inc"
%include "kernel32.inc"
