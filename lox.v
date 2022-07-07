module main

import os
import readline

fn main() {
	if os.args.len > 2 {
		panic('Usage: lox [script] / lox.exe [script]')
	} else if os.args.len == 1 {
		run_prompt()?
	} else {
		run_file(os.args[1])?
	}
}

fn run_file(path string) ? {
	source := os.read_file(path)?
	run(source)
}

fn run_prompt() ? {
	for {
		line := readline.read_line('> ')?.trim_space()

		if line.len == 0 {
			break
		}

		run(line)
	}
}

fn run(source string) {
}
