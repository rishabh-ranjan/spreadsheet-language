let init_sheet_from_file filename =
    (* TODO: error handling *)
    let in_channel = open_in filename in
    let header = input_line in_channel in
    match String.split_on_char '\t' header with
    | [r; c] -> (
        let sheet = Array.make_matrix (int_of_string r) (int_of_string c) None in
        let rec aux in_channel r =
            try
                let line = input_line in_channel in
                let tokens = String.split_on_char '\t' line in
                List.iteri (
                    fun i x ->
                        try sheet.(r).(i) <- Some (float_of_string x)
                        with _ -> ()
                ) tokens;
                aux in_channel (r+1)
            with _ ->
                close_in in_channel
        in
        aux in_channel 0;
        sheet
    )
    | _ -> failwith "some exception" (* TODO: ... *)

let () =
    let lexbuf = Lexing.from_channel stdin in
    let func = Parser.main Lexer.scan lexbuf in
    let sheet = init_sheet_from_file Sys.argv.(1) in
    Sheet.print_sheet sheet;
    func sheet
