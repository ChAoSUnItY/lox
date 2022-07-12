module lox

type Expr = Binary | Grouping | Literal | Unary

interface Visitor<R> {
}

fn (mut v Visitor<R>) visit_binary_expr<R>(expr Binary) {
}

fn (mut v Visitor<R>) visit_grouping_expr<R>(expr Grouping) {
}

fn (mut v Visitor<R>) visit_literal_expr<R>(expr Literal) {
}

fn (mut v Visitor<R>) visit_unary_expr<R>(expr Unary) {
}

struct Binary {
	left     Expr
	operator Token
	right    Token
}

fn (mut expr Binary) accept<R>(visitor Visitor<R>) R {
	return visitor.visit_binary_expr(expr)
}

struct Grouping {
	expression Expr
}

fn (mut expr Grouping) accept<R>(visitor Visitor<R>) R {
	return visitor.visit_grouping_expr(expr)
}

struct Literal {
	value voidptr
}

fn (mut expr Literal) accept<R>(visitor Visitor<R>) R {
	return visitor.visit_literal_expr(expr)
}

struct Unary {
	operator Token
	right    Expr
}

fn (mut expr Unary) accept<R>(visitor Visitor<R>) R {
	return visitor.visit_unary_expr(expr)
}
