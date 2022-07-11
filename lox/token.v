module lox

pub struct Token {
pub:
	token   TokenType
	lexeme  string
	literal voidptr
	line    int
}

[unsafe]
pub fn (t &Token) free() {
	unsafe {
		t.lexeme.free()
		free(t.literal)
	}
}

pub enum TokenType {
	// Single-character tokens
	left_paren
	right_paren
	left_brace
	right_brace
	comma
	dot
	minus
	plus
	semicolon
	slash
	star
	// One or two character tokens
	bang
	bang_equal
	equal
	equal_equal
	greater
	greater_equal
	less
	less_equal
	// Literals
	identifier
	string_
	number
	// Keywords
	and
	class
	else_
	false_
	for_
	if_
	nil_
	or_
	print
	return_
	super
	this
	true_
	var
	while
	eof
}
