type index = int * int
type range = index * index
type sheet = float option array array

type func_unary = range -> index -> sheet -> sheet
type func_float = range -> float -> index -> sheet -> sheet
type func_index = range -> index -> index -> sheet -> sheet
type func_range = range -> range -> index -> sheet -> sheet
type func_binary = {
    for_float: func_float;
    for_index: func_index;
    for_range: func_range
}

exception Undefined_cell_value
exception Negative_index
exception Range_size_mismatch

(*
 * expands sheet so that cell (r,c) is contained in it.
 * returned sheet is guaranteed to be of requisite size.
 *)
let expand (r,c) sheet =
    if r < 0 || c < 0 then
        raise Negative_index
    else (
        let h = Array.length sheet in
        let w = Array.length sheet.(0) in
        if r < h && c < w then
            sheet
        else
            let max x y = if x > y then x else y in
            let nh = max (r+1) h in
            let nw = max (c+1) w in
            let new_sheet = Array.make_matrix nh nw None in
            for i = 0 to h-1 do
                for j = 0 to w-1 do
                    new_sheet.(i).(j) <- sheet.(i).(j)
                done
            done;
            new_sheet
    )

(*
 * fold_left but on a range in an array
 * x -> intial value
 * f -> accumulation function
 * b -> begin index (inclusive)
 * e -> end index (inclusive)
 * a -> array
 * tail recursive
 *)
let r_fold_left x f b e a =
    (* return x for empty range *)
    if b > e then x else
    let rec aux acc i =
        if i = e then f acc a.(i)
        else aux (f acc a.(i)) (i+1)
    in aux x b

(* count functions are handled separately *)

(* helper function to count non-None cells *)
let count_func x = function
| None -> x
| Some _ -> x +. 1.

(* function for count on range *)
let full_count ((r1,c1),(r2,c2)) (r,c) sheet =
    let sheet = expand (r1,c1) (expand (r2,c2) (expand (r,c) sheet)) in
    let acc_row x y = x +. (r_fold_left 0. count_func c1 c2 y) in
    sheet.(r).(c) <- Some (r_fold_left 0. acc_row r1 r2 sheet);
    sheet

(* function for count on rows *)
let row_count ((r1,c1),(r2,c2)) (r,c) sheet =
    let sheet = expand (r1,c1) (expand (r2,c2) (expand (r,c) (expand (r+r2-r1,c) sheet))) in
    let rec aux r1 r =
        if r1 > r2 then ()
        else (
            sheet.(r).(c) <- Some (r_fold_left 0. count_func c1 c2 sheet.(r1));
            aux (r1+1) (r+1)
        )
    in aux r1 r;
    sheet

(* function for count on columns *)
let col_count ((r1,c1),(r2,c2)) (r,c) sheet =
    let sheet = expand (r1,c1) (expand (r2,c2) (expand (r,c) (expand (r,c+c2-c1) sheet))) in
    let rec aux c1 c =
        if c1 > c2 then ()
        else (
            let acc_row x y = x +. (count_func 0. y.(c1)) in
            sheet.(r).(c) <- Some (r_fold_left 0. acc_row r1 r2 sheet);
            aux (c1+1) (c+1)
        )
    in aux c1 c;
    sheet

(*
 * full_func, row_func and col_func are
 * generalised functions for the unary operations (except count)
 * on ranges, rows and columns respectively.
 * func -> accumulation function for cell values
 * iden -> identity value for func
 *)

let full_func func iden ((r1,c1),(r2,c2)) (r,c) sheet =
    let sheet = expand (r1,c1) (expand (r2,c2) (expand (r,c) sheet)) in
    (* accumulation function for rows *)
    let acc_row x y = func x (r_fold_left iden func c1 c2 y) in
    sheet.(r).(c) <- r_fold_left iden acc_row r1 r2 sheet;
    sheet

let row_func func iden ((r1,c1),(r2,c2)) (r,c) sheet =
    let sheet = expand (r1,c1) (expand (r2,c2) (expand (r,c) (expand (r+r2-r1,c) sheet))) in
    let rec aux r1 r =
        if r1 > r2 then () (* base case for recursion *)
        else (
            sheet.(r).(c) <- r_fold_left iden func c1 c2 sheet.(r1);
            aux (r1+1) (r+1)
        )
    in aux r1 r;
    sheet

let col_func func iden ((r1,c1),(r2,c2)) (r,c) sheet =
    let sheet = expand (r1,c1) (expand (r2,c2) (expand (r,c) (expand (r,c+c2-c1) sheet))) in
    let rec aux c1 c =
        if c1 > c2 then () (* base case for recursion *)
        else (
            let acc_row x y = func x y.(c1) in
            sheet.(r).(c) <- r_fold_left iden acc_row r1 r2 sheet;
            aux (c1+1) (c+1)
        )
    in aux c1 c;
    sheet

(* Wrapper to handle option types *)
let option_func f x y = match x, y with
| Some x', Some y' -> Some (f x' y')
| _ -> raise Undefined_cell_value

let full_sum = full_func (option_func ( +. )) (Some 0.)
let row_sum = row_func (option_func ( +. )) (Some 0.)
let col_sum = col_func (option_func ( +. )) (Some 0.)

let min_func x y = if y < x then y else x
let min_iden = max_float (* infinity *)
let full_min = full_func (option_func min_func) (Some min_iden)
let row_min = row_func (option_func min_func) (Some min_iden)
let col_min = col_func (option_func min_func) (Some min_iden)

let max_func x y = if y > x then y else x
let max_iden = -.max_float (* -infinity *)
let full_max = full_func (option_func max_func) (Some max_iden)
let row_max = row_func (option_func max_func) (Some max_iden)
let col_max = col_func (option_func max_func) (Some max_iden)

(*
 * float_func, index_func and range_func
 * are generalised functions to handle binary operations
 * on float, index and range respectively.
 *)

let float_func func ((r1,c1),(r2,c2)) e (r,c) sheet =
    let sheet = expand (r1,c1) (expand (r2,c2) (expand (r,c) (expand (r+r2-r1,c+c2-c1) sheet))) in
    for i = 0 to r2-r1 do
        for j = 0 to c2-c1 do
            sheet.(r+i).(c+j) <- func sheet.(r1+i).(c1+j) (Some e)
        done
    done;
    sheet

let index_func func ((r1,c1),(r2,c2)) (r',c') (r,c) sheet =
    let sheet = expand (r1,c1) (expand (r2,c2) (expand (r',c') (expand (r,c) (expand (r+r2-r1,c+c2-c1) sheet)))) in
    for i = 0 to r2-r1 do
        for j = 0 to c2-c1 do
            sheet.(r+i).(c+j) <- func sheet.(r1+i).(c1+j) sheet.(r').(c')
        done
    done;
    sheet

let range_func func ((r1,c1),(r2,c2)) ((r1',c1'),(r2',c2')) (r,c) sheet =
    if r2-r1 <> r2'-r1' || c2-c1 <> c2'-c1' then
        raise Range_size_mismatch
    else (
        let sheet = expand (r1,c1) (expand (r2,c2) (expand (r1',c1') (expand (r2',c2') (expand (r,c) (expand (r+r2-r1,c+c2-c1) sheet))))) in
        for i = 0 to r2-r1 do
            for j = 0 to c2-c1 do
                sheet.(r+i).(c+j) <- func sheet.(r1+i).(c1+j) sheet.(r1'+i).(c1'+j)
            done
        done;
        sheet
    )

let add_float = float_func (option_func ( +. ))
let subt_float = float_func (option_func ( -. ))
let mult_float = float_func (option_func ( *. ))
let div_float = float_func (option_func ( /. ))

let add_index = index_func (option_func ( +. ))
let subt_index = index_func (option_func ( -. ))
let mult_index = index_func (option_func ( *. ))
let div_index = index_func (option_func ( /. ))

let add_range = range_func (option_func ( +. ))
let subt_range = range_func (option_func ( -. ))
let mult_range = range_func (option_func ( *. ))
let div_range = range_func (option_func ( /. ))

(* averaging is done using sum followed by division *)

let full_avg (((r1,c1),(r2,c2)) as range) ((r,c) as index) sheet =
    let sheet = full_sum range index sheet in
    div_float (index,index) (float ((r2-r1+1)*(c2-c1+1))) index sheet

let row_avg (((r1,c1),(r2,c2)) as range) ((r,c) as index) sheet =
    let sheet = row_sum range index sheet in
    div_float ((r,c),(r+r2-r1,c)) (float (c2-c1+1)) index sheet

let col_avg (((r1,c1),(r2,c2)) as range) ((r,c) as index) sheet =
    let sheet = col_sum range index sheet in
    div_float ((r,c),(r,c+c2-c1)) (float (r2-r1+1)) index sheet

(*
 * prints the sheet in tabular form
 * with `-' for undefined values
 *)
let print_sheet sheet =
    Printf.printf "\n";
    Array.iteri (
        fun i a ->
            (* Printf.printf "%d\t|\t" i; *)
            Array.iter (
                fun x -> match x with
                | None -> Printf.printf "-\t"
                | Some y -> Printf.printf "%g\t" y
            ) a;
            Printf.printf "\n"
    ) sheet;
    Printf.printf "\n"

