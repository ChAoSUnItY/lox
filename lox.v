module main

import os
import lox

fn main() {
	mut proc := lox.Proc{}

	if os.args.len > 2 {
		panic('Usage: lox [script] / lox.exe [script]')
	} else if os.args.len == 1 {
		proc.run_prompt()?
	} else {
		proc.run_file(os.args[1])?
	}
}
