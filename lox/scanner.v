module lox

pub struct Scanner {
	source []rune
mut:
	proc &Proc
	tokens []Token = []
	start int
	current int
	line int = 1
}

pub fn new_scanner(proc &Proc, source []rune) Scanner {
	return Scanner{
		proc: proc,
		source: source
	}
}

pub fn (mut sc Scanner) scan_tokens() []Token {
	for !sc.is_at_end() {
		sc.start = sc.current

		sc.scan_token()
	}

	sc.tokens << Token{
		token: .eof,
		lexeme: "",
		literal: voidptr(0),
		line: sc.line
	}
	return sc.tokens
}

fn (sc &Scanner) is_at_end() bool {
	return sc.current >= sc.source.len
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
		else {
			sc.proc.error(sc.line, 'Unexpected character `${sc.advance()}`.')
		}
	}
}

fn (mut sc Scanner) advance() rune {
	sc.current++
	return sc.source[sc.current - 1]
}

fn (mut sc Scanner) add_token(typ TokenType) {
	sc.add_token1(typ, voidptr(0))
}

fn (mut sc Scanner) add_token1(typ TokenType, literal voidptr) {
	text := sc.source[sc.start..sc.current]
	sc.tokens << Token{
		token: typ,
		lexeme: text.str(),
		literal: literal,
		line: sc.line
	}
}
