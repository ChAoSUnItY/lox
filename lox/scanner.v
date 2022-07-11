module lox

pub struct Scanner {
	source []rune
mut:
	proc    &Proc
	tokens  []Token = []
	start   int
	current int
	line    int = 1
}

const (
	keywords = {
		'and':    TokenType.and
		'class':  .class
		'else':   .else_
		'false':  .false_
		'for':    .for_
		'fun':    .fun
		'if':     .if_
		'nil':    .nil_
		'or':     .or_
		'print':  .print
		'return': .return_
		'super':  .super
		'this':   .this
		'true':   .true_
		'var':    .var
		'while':  .while
	}
)

pub fn new_scanner(proc &Proc, source []rune) Scanner {
	return Scanner{
		proc: proc
		source: source
	}
}

pub fn (mut sc Scanner) scan_tokens() []Token {
	for !sc.is_at_end() {
		sc.start = sc.current

		sc.scan_token()
	}

	sc.tokens << Token{
		token: .eof
		lexeme: ''
		literal: voidptr(0)
		line: sc.line
	}
	return sc.tokens
}

fn (mut sc Scanner) scan_token() {
	c := sc.advance()
	match c {
		`(` {
			sc.add_token(.left_paren)
		}
		`)` {
			sc.add_token(.right_paren)
		}
		`{` {
			sc.add_token(.left_brace)
		}
		`}` {
			sc.add_token(.right_brace)
		}
		`,` {
			sc.add_token(.comma)
		}
		`.` {
			sc.add_token(.dot)
		}
		`-` {
			sc.add_token(.minus)
		}
		`+` {
			sc.add_token(.plus)
		}
		`;` {
			sc.add_token(.semicolon)
		}
		`*` {
			sc.add_token(.star)
		}
		`!` {
			sc.add_token(if sc.match_(`=`) { .bang_equal } else { .bang })
		}
		`=` {
			sc.add_token(if sc.match_(`=`) { .equal_equal } else { .equal })
		}
		`<` {
			sc.add_token(if sc.match_(`=`) { .less_equal } else { .less })
		}
		`>` {
			sc.add_token(if sc.match_(`=`) { .greater_equal } else { .greater })
		}
		`/` {
			if sc.match_(`/`) {
				for sc.peek() != `\n` && !sc.is_at_end() {
					sc.advance()
				}
			} else {
				sc.add_token(.slash)
			}
		}
		`"` {
			sc.string_()
		}
		` `, `\r`, `\t` {
			// ignored
		}
		`\n` {
			sc.line++
		}
		else {
			if is_digit(sc.peek()) {
				sc.number()
			} else if is_alpha(sc.peek()) {
				sc.identifier()
			} else {
				sc.proc.error(sc.line, 'Unexpected character `$sc.advance()`.')
			}
		}
	}
}

fn (mut sc Scanner) string_() {
	for sc.peek() != `"` && !sc.is_at_end() {
		if sc.peek() == `\n` {
			sc.line++
		}
		sc.advance()
	}

	if sc.is_at_end() {
		sc.proc.error(sc.line, 'Unterminated string.')
		return
	}

	value := sc.source[sc.start + 1..sc.current - 1]
	sc.add_token1(.string_, value)
}

fn (mut sc Scanner) number() {
	for is_digit(sc.peek()) {
		sc.advance()
	}

	if sc.peek() == `.` && is_digit(sc.peek_next()) {
		sc.advance()

		for is_digit(sc.peek()) {
			sc.advance()
		}
	}

	unsafe {
		mut addr := &f64(malloc(sizeof(f64)))

		*addr = sc.source[sc.start..sc.current].str().f64()

		sc.add_token1(.number, addr)
	}
}

fn (mut sc Scanner) identifier() {
	for is_alpha_numberic(sc.peek()) {
		sc.advance()
	}

	text := sc.source[sc.start..sc.current]
	typ := lox.keywords[text.str()] or { TokenType.identifier }

	sc.add_token(typ)
}

fn (sc &Scanner) peek() rune {
	if sc.is_at_end() {
		return `\0`
	}
	return sc.source[sc.current]
}

fn (sc &Scanner) peek_next() rune {
	if sc.current + 1 >= sc.source.len {
		return `0`
	}
	return sc.source[sc.current + 1]
}

fn (mut sc Scanner) advance() rune {
	sc.current++
	return sc.source[sc.current - 1]
}

fn (mut sc Scanner) match_(expected rune) bool {
	if sc.is_at_end() || sc.source[sc.current] != expected {
		return false
	}

	sc.current++
	return true
}

[inline]
fn is_digit(r rune) bool {
	return r >= `0` && r <= `9`
}

[inline]
fn is_alpha(r rune) bool {
	return (r >= `a` && r <= `z`) || (r >= `A` && r <= `Z`) || r == `_`
}

[inline]
fn is_alpha_numberic(r rune) bool {
	return is_digit(r) || is_alpha(r)
}

fn (sc &Scanner) is_at_end() bool {
	return sc.current >= sc.source.len
}

fn (mut sc Scanner) add_token(typ TokenType) {
	sc.add_token1(typ, voidptr(0))
}

fn (mut sc Scanner) add_token1(typ TokenType, literal voidptr) {
	text := sc.source[sc.start..sc.current]
	sc.tokens << Token{
		token: typ
		lexeme: text.str()
		literal: literal
		line: sc.line
	}
}
