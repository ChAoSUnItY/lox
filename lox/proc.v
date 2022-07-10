module lox

import os
import readline

[heap]
pub struct Proc {
mut:
	had_error bool
}

pub fn (mut proc Proc) run_file(path string) ? {
	source := os.read_file(path)?
	proc.run(source)
}

pub fn (mut proc Proc) run_prompt() ? {
	for {
		line := readline.read_line('> ')?.trim_space()

		if line.len == 0 {
			break
		}

		proc.run(line)
	}
}

fn (mut proc Proc) run(source string) {
}

pub fn (mut proc Proc) error(line int, message string) {
	proc.report(line, '', message)
}

pub fn (mut proc Proc) report(line int, where string, message string) {
	proc.had_error = true
	eprintln('[line $line] Error $where: message')
}
