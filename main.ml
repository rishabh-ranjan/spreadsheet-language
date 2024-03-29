let init_sheet_from_file filename =
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
    | _ -> failwith "<num_rows>\t<num_cols> required in first line"

let rec repl sheet =
    Sheet.print_sheet sheet;
    Printf.printf "> ";
    flush stdout;
    let lexbuf = Lexing.from_channel stdin in
    let func = Parser.line Lexer.scan lexbuf in
    let new_sheet = ( try func sheet with 
        | Sheet.Undefined_cell_value ->
            Printf.eprintf "Error: cell with undefined value was used\n";
            flush stderr;
            sheet
        | Sheet.Negative_index ->
            Printf.eprintf "Error: Negative index was used\n";
            flush stderr;
            sheet
        | Sheet.Range_size_mismatch ->
            Printf.eprintf "Error: Sizes of ranges don't match\n";
            flush stderr;
            sheet
        | _ ->
            Printf.eprintf "Error: Some error occurred\n";
            flush stderr;
            sheet
    ) in
    repl new_sheet

let compile sheet in_channel =
    let lexbuf = Lexing.from_channel in_channel in
    let func = Parser.main Lexer.scan lexbuf in
    ( try Sheet.print_sheet (func sheet) with
        | Sheet.Undefined_cell_value ->
            Printf.eprintf "Error: cell with undefined value was used\n";
        | Sheet.Negative_index ->
            Printf.eprintf "Error: Negative index was used\n";
        | Sheet.Range_size_mismatch ->
            Printf.eprintf "Error: Sizes of ranges don't match\n";
        | _ ->
            Printf.eprintf "Error: Some error occurred\n";
    )

let () = match Array.length Sys.argv with
| 1 -> Printf.eprintf "Please specify sheet initialization file as command-line argument!\n"
| 2 ->
    let sheet = init_sheet_from_file Sys.argv.(1) in
    repl sheet
| _ ->
    let sheet = init_sheet_from_file Sys.argv.(1) in
    let in_channel = open_in Sys.argv.(2) in
    compile sheet in_channel
