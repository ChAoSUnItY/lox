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
	splitted_datas := types.map(it.split(':')).map(it.map(it.trim_space()))

	file.writeln('module lox')?
	file.writeln('')?
	file.writeln('type $base_name =')?

	for i, splitted_data in splitted_datas {
		struct_name := splitted_data[0]

		file.write_string('\t')?

		if i > 0 {
			file.write_string('|')?
		}

		file.writeln('$struct_name')?
	}

	file.writeln('')?
	define_visitor(mut file, base_name, types)?

	for splitted_data in splitted_datas {
		struct_name := splitted_data[0].trim_space()
		fields := splitted_data[1].trim_space()

		file.writeln('')?
		define_type(mut file, base_name, struct_name, fields)?
	}

	// accept function
	file.writeln('')?

	file.close()
}

fn define_type(mut file os.File, base_name string, struct_name string, field_list string) ? {
	file.writeln('struct $struct_name {')?

	fields := field_list.split(', ')
	for field in fields {
		file.writeln('\t$field')?
	}

	file.writeln('}')?
	file.writeln('')?
	file.writeln('fn (mut expr $struct_name) accept<R>(visitor Visitor<R>) R {')?
	file.writeln('\treturn visitor.visit${camel2snake(struct_name)}_${base_name.to_lower()}(expr)')?
	file.writeln('}')?
}

fn define_visitor(mut file os.File, base_name string, types []string) ? {
	file.writeln('interface Visitor<R> {')?
	file.writeln('}')?

	for typ in types {
		file.writeln('')?
		type_name := typ.split(':')[0].trim_space()
		file.writeln('fn (mut v Visitor<R>) visit${camel2snake(type_name)}_$base_name.to_lower()<R>($base_name.to_lower() $type_name) {')? // mut?
		file.writeln('}')?
	}
}

fn camel2snake(id string) string {
	return id.runes().map(fn (r rune) string {
		s := r.str()
		return if s.is_capital() {
			'_$s.to_lower()'
		} else {
			s
		}
	}).join('')
}
