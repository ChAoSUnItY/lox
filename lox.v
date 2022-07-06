module main

import os

fn main() {
	if os.args.len < 2 {
		panic('Usage: lox [script] / lox.exe [script]')
	}
}
