all: main

main: sheet.cmo lexer.cmo parser.cmo main.cmo
	ocamlc -o $@ $^

main.cmo: main.ml lexer.cmi parser.cmi
	ocamlc -c -o $@ $<

lexer.cmo lexer.cmi: lexer.ml sheet.cmi parser.cmi
	ocamlc -c $<

lexer.ml: lexer.mll
	ocamllex -o $@ $^

parser.cmo: parser.ml parser.cmi sheet.cmi
	ocamlc -c -o $@ $<

parser.cmi: parser.mli
	ocamlc -c -o $@ $^

parser.ml parser.mli: parser.mly
	ocamlyacc $^

sheet.cmo: sheet.ml sheet.cmi
	ocamlc -c -o $@ $<

sheet.cmi: sheet.mli
	ocamlc -c -o $@ $^

run: all
	./main

clean:
	rm *.cmi *.cmo main lexer.ml parser.ml parser.mli
