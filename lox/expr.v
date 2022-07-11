module lox

struct Expr {
}

struct Binary {
	Expr
	left     Expr
	operator Token
	right    Expr
}
