(*
 * changes from assignment 2 to 3:
    * integers are also accepted as `FLOAT' now.
        * note that this was not done in assignment 2 only because
        * the specification seems to imply that '.' is mandatory
        * for `FLOAT' tokens.
    * all functions are captured under 3 token types:
        * `FUNC', `FUNC_FLOAT' and `FUNC_RANGE'
        * corresponding to the `func', `func_float' and `func_range' types
        * defined in module `Sheet'.
        * This enables greater flexibility and easier implementation.
*)
{
    open Sheet (* Contains function declarations/definitions *)
	open Parser	(* The type token is defined in parser.mli *)
    exception LexicalError
}

    (* whitespace *)
let ws = (' '|'\t'|'\n'|'\r')
    (* decimal point optional *)
let float_ = ['-''+']?('0'|['1'-'9']['0'-'9']*)('.'('0'|['0'-'9']*['1'-'9']))?
    (* only non-negative integers are recognized, and only within indices and ranges *)
let int_ = '0'|['1'-'9']['0'-'9']*
    (* whitespace between components is supported (i.e. ignored) for both index and range *)
let index_ = '[' ws* (int_ as i) ws* ',' ws* (int_ as j) ws* ']'
let range_ = '(' ws* '[' ws* (int_ as i1) ws* ',' ws* (int_ as j1) ws* ']' ws* ':' ws* '[' ws* (int_ as i2) ws* ',' ws* (int_ as j2) ws* ']' ws* ')'

    (* return value is of type `token' as defined in Parser *)
rule scan = parse
| float_ as str { FLOAT (float_of_string str); }
| '(' { LPAREN }
| ')' { RPAREN }
| '[' { LBRAC }
| ']' { RBRAC }
| ',' { COMMA }
| ':' { COLON }
| ":=" { ASSIGN }
| ';' { SEMICOLON }
| index_ { INDEX (int_of_string i, int_of_string j) }
| range_ { RANGE ((int_of_string i1, int_of_string j1), (int_of_string i2, int_of_string j2)) }
    (* unary operators *)
| "COUNT" { FUNC full_count }
| "ROWCOUNT" { FUNC row_count }
| "COLCOUNT" { FUNC col_count }
| "SUM" { FUNC full_sum }
| "ROWSUM" { FUNC row_sum }
| "COLSUM" { FUNC col_sum }
| "AVG" { FUNC full_avg }
| "ROWAVG" { FUNC row_avg }
| "COLAVG" { FUNC col_avg }
| "MIN" { FUNC full_min }
| "ROWMIN" { FUNC row_min }
| "COLMIN" { FUNC col_min }
| "MAX" { FUNC full_max }
| "ROWMAX" { FUNC row_max }
| "COLMAX" { FUNC col_max }
    (* unary operators *)
| "ADD"
| "SUBT"
| "MULT"
| "DIV"
    (* ignore whitespace *)
| ' '|'\t'|'\n'|'\r' { scan lexbuf }
    (* exception case *)
| _ { raise LexicalError }
| eof { EOF }

{
    (* this section is for demo only, and may not be used in subsequent assignments *)

    (* returns a list of tokens in lexbuf, acc is accumulator list *)
    let rec token_list acc lexbuf =
        let token = scan lexbuf in
        let acc' = token::acc in
        (* stop recursion at EOF *)
        if token = EOF then List.rev acc'
        else token_list acc' lexbuf

    (* reads from stdin and returns a list of tokens (unless LexicalError exception occurs) *)
    (* example usage: (in containing directory)
     *  $ ocaml
     *  # #use "lexer.ml";;
     *  # demo ();;
     *  [0,3]:=DIV([0,4]: [2,4])[1,1];
     *  ^D
     *  - : Parser.token list =
     *  [INDEX (0, 4); ASSIGN; MULT; RANGE ((0, 0), (2, 0)); RANGE ((0, 2), (2, 2)); EOF]
     *  #
     *)
    let demo () =
        let lexbuf = Lexing.from_channel stdin in
        token_list [] lexbuf
}
