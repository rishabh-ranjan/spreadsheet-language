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

%start main
%type <Sheet.sheet -> unit> main

%type <Sheet.sheet -> unit> line

%%

main: /* empty */ { fun x -> () }
    | main line { fun x -> ($1 x; $2 x) }
    | main error { 
        let start_pos = Parsing.rhs_start_pos 2 in
        Printf.eprintf "Line %d: parse error\n" start_pos.pos_lnum;
        fun x -> ()
    }
;

line: INDEX ASSIGN FUNC_UNARY RANGE SEMICOLON { Printf.eprintf "unary R\n"; $3 $4 $1 }
    | INDEX ASSIGN FUNC_BINARY FLOAT RANGE SEMICOLON { Printf.eprintf "binary F R\n"; $3.for_float $5 $4 $1 }
    | INDEX ASSIGN FUNC_BINARY RANGE FLOAT SEMICOLON { Printf.eprintf "binary R F\n"; $3.for_float $4 $5 $1 }
    | INDEX ASSIGN FUNC_BINARY INDEX RANGE SEMICOLON { Printf.eprintf "binary I R\n"; $3.for_index $5 $4 $1 }
    | INDEX ASSIGN FUNC_BINARY RANGE INDEX SEMICOLON { Printf.eprintf "binary R I\n"; $3.for_index $4 $5 $1 }
    | INDEX ASSIGN FUNC_BINARY RANGE RANGE SEMICOLON { Printf.eprintf "binary R R\n"; $3.for_range $5 $4 $1 }
;

