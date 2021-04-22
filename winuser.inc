%ifndef WINUSER_INC
%define WINUSER_INC

%include "windef.inc"

struc WNDCLASSA

    .style:             resd        1
    .lpfnWndProc:       resd        1
    .cbClsExtra:        resd        1
    .cbWndExtra:        resd        1
    .hInstance:         resd        1
    .hIcon:             resd        1
    .hCursor:           resd        1
    .hbrBackground:     resd        1
    .lpszMenuName:      resd        1
    .lpszClassName:     resd        1

endstruc

struc MSG

    .hwnd:              resd        1
    .message:           resd        1
    .wParam:            resd        1
    .lParam:            resd        1
    .time:              resd        1
    .pt:                resd        1
    .lPrivate:          resd        1

endstruc

struc PAINTSTRUCT

    .hdc:               resd        1
    .fErase:            resd        1
    .rcPaint:           resb        RECT_size
    .fRestore:          resd        1
    .fIncUpdate         resd        1
    .rgbReserved        resb        32

endstruc

CW_USEDEFAULT           equ         0x80000000

WS_OVERLAPPED           equ         0x00000000
WS_CAPTION              equ         0x00C00000
WS_SYSMENU              equ         0x00080000
WS_THICKFRAME           equ         0x00040000
WS_MINIMIZEBOX          equ         0x00020000
WS_MAXIMIZEBOX          equ         0x00010000

WS_OVERLAPPEDWINDOW     equ         WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX

SW_SHOWNORMAL           equ         1

PM_REMOVE               equ         0x0001

WM_DESTROY              equ         0x0002
WM_PAINT                equ         0x000F

COLOR_WINDOW            equ         5

IDC_ARROW               equ         32512

%endif