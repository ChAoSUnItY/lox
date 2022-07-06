all: lox.v
	v lox.v
clean:
	powershell "Remove-Item lox.exe"
