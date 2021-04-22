hello.exe : clean hello.obj
	link /subsystem:windows /entry:mainCRTStartup hello.obj libcmt.lib legacy_stdio_definitions.lib kernel32.lib user32.lib

hello.obj :
	nasm -fwin32 hello.asm

clean :
	del *.exe
	del *.obj
