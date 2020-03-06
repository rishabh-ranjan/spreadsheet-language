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
%token <index> INDEX
%token <range> RANGE
	/* unary operators */
%token COUNT ROWCOUNT COLCOUNT
%token SUM ROWSUM COLSUM
%token AVG ROWAVG COLAVG
%token MIN ROWMIN COLMIN
%token MAX ROWMAX COLMAX
	/* binary operators */
%token ADD
%token SUBT
%token MULT
%token DIV
	/* assignment operator */
%token ASSIGN
	/* formula termination */
%token SEMICOLON
    /* end-of-file */
%token EOF

%start main
%type <unit> main

%type 

%%

	/* will be done later */
main: ; {}

/* TODO: parse error handling */
