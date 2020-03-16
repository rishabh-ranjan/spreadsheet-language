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
  | ERROR

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Sheet.sheet -> Sheet.sheet
val line :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Sheet.sheet -> Sheet.sheet
