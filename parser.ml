type token =
  | FLOAT of (float)
  | LPAREN
  | RPAREN
  | LBRAC
  | RBRAC
  | COMMA
  | COLON
  | ASSIGN
  | SEMICOLON
  | INDEX of (Sheet.index)
  | RANGE of (Sheet.range)
  | FUNC_UNARY of (Sheet.func_unary)
  | FUNC_BINARY of (Sheet.func_binary)
  | EOF

open Parsing;;
let _ = parse_error;;
# 7 "parser.mly"
# 21 "parser.ml"
let yytransl_const = [|
  258 (* LPAREN *);
  259 (* RPAREN *);
  260 (* LBRAC *);
  261 (* RBRAC *);
  262 (* COMMA *);
  263 (* COLON *);
  264 (* ASSIGN *);
  265 (* SEMICOLON *);
    0 (* EOF *);
    0|]

let yytransl_block = [|
  257 (* FLOAT *);
  266 (* INDEX *);
  267 (* RANGE *);
  268 (* FUNC_UNARY *);
  269 (* FUNC_BINARY *);
    0|]

let yylhs = "\255\255\
\001\000\001\000\001\000\002\000\002\000\002\000\002\000\002\000\
\002\000\000\000"

let yylen = "\002\000\
\000\000\002\000\002\000\005\000\006\000\006\000\006\000\006\000\
\006\000\002\000"

let yydefred = "\000\000\
\001\000\000\000\000\000\003\000\000\000\002\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\004\000\000\000\000\000\
\000\000\000\000\000\000\005\000\007\000\006\000\008\000\009\000"

let yydgoto = "\002\000\
\003\000\006\000"

let yysindex = "\005\000\
\000\000\000\000\003\255\000\000\249\254\000\000\248\254\252\254\
\255\254\005\255\253\254\004\255\001\255\000\000\007\255\008\255\
\009\255\010\255\011\255\000\000\000\000\000\000\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\021\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\000\000"

let yytablesize = 21
let yytable = "\011\000\
\007\000\017\000\004\000\008\000\009\000\001\000\010\000\015\000\
\012\000\013\000\018\000\019\000\005\000\014\000\016\000\020\000\
\021\000\022\000\023\000\024\000\010\000"

let yycheck = "\001\001\
\008\001\001\001\000\001\012\001\013\001\001\000\011\001\011\001\
\010\001\011\001\010\001\011\001\010\001\009\001\011\001\009\001\
\009\001\009\001\009\001\009\001\000\000"

let yynames_const = "\
  LPAREN\000\
  RPAREN\000\
  LBRAC\000\
  RBRAC\000\
  COMMA\000\
  COLON\000\
  ASSIGN\000\
  SEMICOLON\000\
  EOF\000\
  "

let yynames_block = "\
  FLOAT\000\
  INDEX\000\
  RANGE\000\
  FUNC_UNARY\000\
  FUNC_BINARY\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    Obj.repr(
# 32 "parser.mly"
                  ( fun x -> () )
# 108 "parser.ml"
               : Sheet.sheet -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Sheet.sheet -> unit) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Sheet.sheet -> unit) in
    Obj.repr(
# 33 "parser.mly"
                ( fun x -> (_1 x; _2 x) )
# 116 "parser.ml"
               : Sheet.sheet -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Sheet.sheet -> unit) in
    Obj.repr(
# 34 "parser.mly"
                 ( 
        let start_pos = Parsing.rhs_start_pos 2 in
        Printf.eprintf "Line %d: parse error\n" start_pos.pos_lnum;
        fun x -> ()
    )
# 127 "parser.ml"
               : Sheet.sheet -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : Sheet.index) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : Sheet.func_unary) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Sheet.range) in
    Obj.repr(
# 41 "parser.mly"
                                              ( Printf.eprintf "unary R\n"; _3 _4 _1 )
# 136 "parser.ml"
               : Sheet.sheet -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : Sheet.index) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Sheet.func_binary) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : float) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Sheet.range) in
    Obj.repr(
# 42 "parser.mly"
                                                     ( Printf.eprintf "binary F R\n"; _3.for_float _5 _4 _1 )
# 146 "parser.ml"
               : Sheet.sheet -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : Sheet.index) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Sheet.func_binary) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Sheet.range) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : float) in
    Obj.repr(
# 43 "parser.mly"
                                                     ( Printf.eprintf "binary R F\n"; _3.for_float _4 _5 _1 )
# 156 "parser.ml"
               : Sheet.sheet -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : Sheet.index) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Sheet.func_binary) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Sheet.index) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Sheet.range) in
    Obj.repr(
# 44 "parser.mly"
                                                     ( Printf.eprintf "binary I R\n"; _3.for_index _5 _4 _1 )
# 166 "parser.ml"
               : Sheet.sheet -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : Sheet.index) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Sheet.func_binary) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Sheet.range) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Sheet.index) in
    Obj.repr(
# 45 "parser.mly"
                                                     ( Printf.eprintf "binary R I\n"; _3.for_index _4 _5 _1 )
# 176 "parser.ml"
               : Sheet.sheet -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : Sheet.index) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Sheet.func_binary) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Sheet.range) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Sheet.range) in
    Obj.repr(
# 46 "parser.mly"
                                                     ( Printf.eprintf "binary R R\n"; _3.for_range _5 _4 _1 )
# 186 "parser.ml"
               : Sheet.sheet -> unit))
(* Entry main *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let main (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Sheet.sheet -> unit)
