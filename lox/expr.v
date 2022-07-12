module lox

struct Expr {
}

struct Binary {
	Expr
	left     Expr
	operator Token
	right    Token
}

struct Grouping {
	Expr
	expression Expr
}

struct Literal {
	Expr
	value voidptr
}

struct Unary {
	Expr
	operator Token
	right    Expr
}
