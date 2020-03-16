/* vim: set ft=yacc: */
/*
 * changes from assignment 3: sheet->sheet is replaced with sheet->unit
 * reflecting the design decision to implement the sheet using arrays
 */
%{
%}
%token <float> FLOAT
%token LPAREN RPAREN
%token LBRAC RBRAC
%token COMMA
%token COLON
	/* assignment operator */
%token ASSIGN
	/* formula termination */
%token SEMICOLON
%token <Sheet.index> INDEX
%token <Sheet.range> RANGE
    /* functions */
%token <Sheet.func_unary> FUNC_UNARY
%token <Sheet.func_binary> FUNC_BINARY
    /* end-of-file */
%token EOF
    /* signals lexical error */
%token ERROR

%start main
%type <Sheet.sheet -> Sheet.sheet> main

%start line
%type <Sheet.sheet -> Sheet.sheet> line

%%

main: /* empty */ { fun x -> x }
    | main line { fun x -> $2 ($1 x) }
;

line: INDEX ASSIGN FUNC_UNARY RANGE SEMICOLON { $3 $4 $1 }
    | INDEX ASSIGN FUNC_BINARY FLOAT RANGE SEMICOLON { $3.for_float $5 $4 $1 }
    | INDEX ASSIGN FUNC_BINARY RANGE FLOAT SEMICOLON { $3.for_float $4 $5 $1 }
    | INDEX ASSIGN FUNC_BINARY INDEX RANGE SEMICOLON { $3.for_index $5 $4 $1 }
    | INDEX ASSIGN FUNC_BINARY RANGE INDEX SEMICOLON { $3.for_index $4 $5 $1 }
    | INDEX ASSIGN FUNC_BINARY RANGE RANGE SEMICOLON { $3.for_range $5 $4 $1 }
    | error {
        let start_pos = Parsing.symbol_start_pos () in
        Printf.eprintf "Line %d: syntax error\n" (start_pos.pos_lnum);
        flush stderr;
        fun x -> x
    }
;

