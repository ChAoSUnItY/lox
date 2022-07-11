all: lox.v
	v fmt . -w
	v lox.v
clean:
	powershell "Remove-Item lox.exe"
