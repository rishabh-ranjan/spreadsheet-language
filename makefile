all: main

main: main.cmo lexer.cmo parser.cmo
	ocamlc -o $@ $^

main.cmo: main.ml
	ocamlc -c -o $@ $^

lexer.cmo: lexer.ml
	ocamlc -c -o $@ $^

lexer.ml: lexer.mll
	ocamllex -o $@ $^

parser.cmo: parser.ml
	ocamlc -o $@ $^

parser.ml parser.mli: parser.mly
	ocamlyacc $^
