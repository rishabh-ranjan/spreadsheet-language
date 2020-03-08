let _ =
    let lexbuf = Lexing.from_channel stdin in
    Parser.main Lexer.scan lexbuf
