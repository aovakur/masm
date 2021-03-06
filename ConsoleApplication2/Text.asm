.386
.model stdcall, flat
option casemap:none


include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
include \masm32\include\debug.inc
include \masm32\include\user32.inc
include \masm32\include\gdi32.inc
 
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\debug.lib
includelib \masm32\lib\user32.lib

.data

hwnd dd 0
hInst dd 0
szTitleName db '������������ ������ �4', 0
szClassName db '���������� Win32', 0
msg MONMSGSTRUCT <?>
wc WNDCLASS <?>
ps PAINTSTRUCT <?>

.code

Main PROC
invoke GetModuleHandle, 0 ;��������� �������� ���. ������,
mov hInst, eax ;�� �������� �������� ������.
mov wc.style, CS_HREDRAW + CS_VREDRAW + CS_GLOBALCLASS
mov wc.lpfnWndProc, offset WndProc ;����� ������� ���������
mov wc.cbClsExtra, 0
mov wc.cbWndExtra, 0
mov eax, hInst ;���������� ����������
mov wc.hInstance, eax ;� ���� hInstance
invoke LoadIcon, 0, IDI_APPLICATION
mov wc.hIcon, eax ;���������� ������ � ���� hIcon
invoke LoadCursorA, 0, IDC_ARROW
mov wc.hCursor, eax ;���������� ������� � ���� hCursor
mov wc.hbrBackground, WHITE_BRUSH ;���� ���������� ���� �����
mov dword ptr wc.lpszMenuName, 0 ;�������� ���� ���
mov dword ptr wc.lpszClassName, offset szClassName ;��� ������ ����
invoke RegisterClassA, offset wc ;����������� ������ ����
invoke CreateWindowEx, 0, offset szClassName, offset szTitleName, \
WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, \
CW_USEDEFAULT, CW_USEDEFAULT, 0, 0, hInst, 0
mov hwnd, eax ;�������� ����
invoke ShowWindow, hwnd, SW_SHOWNORMAL ;����� ����
invoke UpdateWindow, hwnd ;������������� ����������� ����
cycle1: ;���� ���������
invoke GetMessage, offset msg, 0, 0, 0
cmp ax, 0
je end_c
invoke TranslateMessage, offset msg ;���������� ����� � ����������
invoke DispatchMessage, offset msg ;���������� ���������
;������� ���������
jmp cycle1
end_c:
invoke ExitProcess, 0 ;����� �� ����������
Main ENDP

WndProc PROC USES ebx edi esi, _hwnd:DWORD, _wmsg:DWORD, _wparam:DWORD, _lparam:DWORD
local _hdc:DWORD
cmp _wmsg, WM_DESTROY
je wmdestroy
cmp _wmsg, WM_PAINT
je wmpaint
invoke DefWindowProcA, _hwnd, _wmsg, _wparam, _lparam ;�����. �� ���������
jmp exit_proc
wmpaint:
invoke BeginPaint, _hwnd, offset ps ;�������� �������� ����������
mov _hdc, eax

invoke MoveToEx, _hdc, 300, 300, 0; ��������� ������� �������
invoke LineTo, _hdc, 300, 500; ������ �����

invoke MoveToEx, _hdc, 300, 300, 0; ��������� ������� �������
invoke LineTo, _hdc, 100, 500; ������ ����� �����

invoke MoveToEx, _hdc, 200, 400, 0; ��������� ������� �������
invoke LineTo, _hdc, 400, 400; ������ �����


invoke EndPaint, _hdc, offset ps ;����������� ��������
mov eax, 0 ;������������ �������� - 0
jmp exit_proc
wmdestroy:
invoke PostQuitMessage, 0 ;������� ��������� WM_QUIT
mov eax, 0 ;������������ �������� - 0
exit_proc:
ret
WndProc ENDP
END Main