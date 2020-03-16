(*
 * changes from assignment 2 to 3:
    * integers are also accepted as `FLOAT' now.
        * note that this was not done in assignment 2 only because
        * the specification seems to imply that '.' is mandatory
        * for `FLOAT' tokens.
    * all functions are captured under 2 token types:
        * `FUNC_UNARY' and `FUNC_BINARY'
        * corresponding to the `func_unary' and `func_binary' types
        * defined in module `Sheet'.
        * This enables greater flexibility and easier implementation.
*)
{
    open Sheet (* Contains function declarations/definitions *)
	open Parser	(* The type token is defined in parser.mli *)

    (* To keep track of the line numbers for better error msgs *)
    let incr_linenum lexbuf =
        let pos = lexbuf.Lexing.lex_curr_p in
        lexbuf.Lexing.lex_curr_p <- { pos with
          Lexing.pos_lnum = pos.Lexing.pos_lnum + 1;
        }
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
| "COUNT" { FUNC_UNARY full_count }
| "ROWCOUNT" { FUNC_UNARY row_count }
| "COLCOUNT" { FUNC_UNARY col_count }
| "SUM" { FUNC_UNARY full_sum }
| "ROWSUM" { FUNC_UNARY row_sum }
| "COLSUM" { FUNC_UNARY col_sum }
| "AVG" { FUNC_UNARY full_avg }
| "ROWAVG" { FUNC_UNARY row_avg }
| "COLAVG" { FUNC_UNARY col_avg }
| "MIN" { FUNC_UNARY full_min }
| "ROWMIN" { FUNC_UNARY row_min }
| "COLMIN" { FUNC_UNARY col_min }
| "MAX" { FUNC_UNARY full_max }
| "ROWMAX" { FUNC_UNARY row_max }
| "COLMAX" { FUNC_UNARY col_max }
    (* binary operators *)
| "ADD" { FUNC_BINARY { for_float = add_float; for_index = add_index; for_range = add_range } }
| "SUBT" { FUNC_BINARY { for_float = subt_float; for_index = subt_index; for_range = subt_range } }
| "MULT" { FUNC_BINARY { for_float = mult_float; for_index = mult_index; for_range = mult_range } }
| "DIV" { FUNC_BINARY { for_float = div_float; for_index = div_index; for_range = div_range } }
    (* ignore whitespace *)
| ' '|'\t'|'\r' { scan lexbuf }
    (* newline *)
| '\n' { incr_linenum lexbuf; scan lexbuf }
    (* exception case - intimate about lexical error and continue scanning*)
| _ { Printf.eprintf "Line %d: lexical error\n" lexbuf.Lexing.lex_curr_p.pos_lnum; scan lexbuf }
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
    let lex_demo () =
        let lexbuf = Lexing.from_channel stdin in
        token_list [] lexbuf
}
