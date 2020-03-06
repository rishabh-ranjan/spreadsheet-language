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
%token <func> FUNC
%token <func_float> FUNC_FLOAT
%token <func_range> FUNC_RANGE
    /* end-of-file */
%token EOF

%start main
%type <unit> main

%type 

%%

	/* will be done later */
main: ; {}

/* TODO: parse error handling */
