/*
** UTILITY FUNCTION FOR AST STRUCTS GENERATION
*/
import os

fn main() {
	if os.args.len != 2 {
		eprintln('Usage: generate_ast <output directory>')
		exit(64)
	}

	output_dir := os.args[1]
	define_ast(output_dir, 'Expr', [
		'Binary		: left Expr, operator Token, right Token',
		'Grouping	: expression Expr',
		'Literal	: value voidptr',
		'Unary		: operator Token, right Expr',
	])?

	// fmt after generation
	os.execute(@VEXE + ' fmt $output_dir -w')
}

fn define_ast(output_dir string, base_name string, types []string) ? {
	path := '$output_dir/${base_name}.v'
	mut file := os.open_file(path, 'w+')?

	file.writeln('module lox')?
	file.writeln('')?
	file.writeln('struct $base_name {')?
	file.writeln('}')?

	for typ in types {
		splitted_data := typ.split(':')
		struct_name := splitted_data[0].trim_space()
		fields := splitted_data[1].trim_space()

		file.writeln('')?
		define_type(mut file, base_name, struct_name, fields)?
	}

	file.close()
}

fn define_type(mut file os.File, base_name string, struct_name string, field_list string) ? {
	file.writeln('struct $struct_name {')?
	file.writeln('\t$base_name')?

	fields := field_list.split(', ')
	for field in fields {
		file.writeln('\t$field')?
	}

	file.writeln('}')?
}
