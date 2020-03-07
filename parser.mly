/* vim: set ft=yacc: */
/* ^ vim modeline, please ignore */
%{
    open Sheet
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
%token <index> INDEX
%token <range> RANGE
    /* functions */
%token <func_unary> FUNC_UNARY
%token <func_binary> FUNC_BINARY
    /* end-of-file */
%token EOF

%start main
%type <sheet->sheet> main

%type <sheet->sheet> line

%%

main: /* empty */ { fun x -> x }
    | main line { fun x -> $1 x |> $2 }

line: INDEX ASSIGN FUNC_UNARY RANGE SEMICOLON { $3 $4 $1 }
    | INDEX ASSIGN FUNC_BINARY FLOAT RANGE SEMICOLON { $3.for_float $5 $4 $1 }
    | INDEX ASSIGN FUNC_BINARY RANGE FLOAT SEMICOLON { $3.for_float $4 $5 $1 }
    | INDEX ASSIGN FUNC_BINARY INDEX RANGE SEMICOLON { $3.for_index $5 $4 $1 }
    | INDEX ASSIGN FUNC_BINARY RANGE INDEX SEMICOLON { $3.for_index $4 $5 $1 }
    | INDEX ASSIGN FUNC_BINARY RANGE RANGE SEMICOLON { $3.for_range $5 $4 $1 }
;

/* TODO: parse error handling */
