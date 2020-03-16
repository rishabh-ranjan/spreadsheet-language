(* TODO: error detection and handling *)
(* TODO: replace sheet with unit in return types *)
(* TODO: documentation *)
(* TODO: improved handling of undefined cells... instead of error, use None + None = None, etc. *)

(* TODO: count function definitely has error *)

type index = int * int
type range = index * index
type sheet = float option array array

type func_unary = range -> index -> sheet -> unit
type func_float = range -> float -> index -> sheet -> unit
type func_index = range -> index -> index -> sheet -> unit
type func_range = range -> range -> index -> sheet -> unit
type func_binary = {
    for_float: func_float;
    for_index: func_index;
    for_range: func_range
}

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
    let rec aux acc i =
        if i = e then f acc a.(i)
        else aux (f acc a.(i)) (i+1)
    in aux x b

let full_func func iden ((r1,c1),(r2,c2)) (r,c) sheet =
    let acc_row x y = func x (r_fold_left iden func c1 c2 y) in
    sheet.(r).(c) <- r_fold_left iden acc_row r1 r2 sheet

let rec row_func func iden ((r1,c1),(r2,c2)) (r,c) sheet =
    if r1 > r2 then () else (
        sheet.(r).(c) <- r_fold_left iden func c1 c2 sheet.(r1);
        row_func func iden ((r1+1,c1),(r2,c2)) (r+1,c) sheet
    )

let rec col_func func iden ((r1,c1),(r2,c2)) (r,c) sheet =
    if c1 > c2 then () else
    let acc_row x y = func x y.(c1) in
    sheet.(r).(c) <- r_fold_left iden acc_row r1 r2 sheet;
    col_func func iden ((r1,c1+1),(r2,c2)) (r,c+1) sheet

let count_func x y = match x, y with
| Some _, None -> x
| Some x', Some _ -> Some (x' +. 1.)
| None, _ -> failwith "undefined initial value" (* TODO: change the error handling *)

let full_count = full_func count_func (Some 0.)
let row_count = row_func count_func (Some 0.)
let col_count = col_func count_func (Some 0.)

let option_func f x y = match x, y with
| Some x', Some y' -> Some (f x' y')
| _ -> failwith "undefined cell value" (* TODO: raise exception *)

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

let float_func func ((r1,c1),(r2,c2)) e (r,c) sheet =
    for i = 0 to r2-r1 do
        for j = 0 to c2-c1 do
            sheet.(r+i).(c+j) <- func sheet.(r1+i).(c1+j) (Some e)
        done
    done

let index_func func ((r1,c1),(r2,c2)) (r',c') (r,c) sheet =
    for i = 0 to r2-r1 do
        for j = 0 to c2-c1 do
            sheet.(r+i).(c+j) <- func sheet.(r1+i).(c1+j) sheet.(r').(c')
        done
    done

let range_func func ((r1,c1),(r2,c2)) ((r1',c1'),(r2',c2')) (r,c) sheet =
    for i = 0 to r2-r1 do
        for j = 0 to c2-c1 do
            sheet.(r+i).(c+j) <- func sheet.(r1+i).(c1+j) sheet.(r1'+i).(c1'+j)
        done
    done

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

let full_avg (((r1,c1),(r2,c2)) as range) ((r,c) as index) sheet =
    full_sum range index sheet;
    div_float (index,index) (float ((r2-r1+1)*(c2-c1+1))) index sheet

let row_avg (((r1,c1),(r2,c2)) as range) ((r,c) as index) sheet =
    row_sum range index sheet;
    div_float ((r,c),(r+r2-r1,c)) (float (c2-c1+1)) index sheet

let col_avg (((r1,c1),(r2,c2)) as range) ((r,c) as index) sheet =
    col_sum range index sheet;
    div_float ((r,c),(r,c+c2-c1)) (float (r2-r1+1)) index sheet

let print_sheet =
    Array.iter (
        fun a ->
        Array.iter (
            fun x -> match x with
            | None -> Printf.printf "-\t"
            | Some y -> Printf.printf "%g\t" y
        ) a;
        Printf.printf "\n"
    )
