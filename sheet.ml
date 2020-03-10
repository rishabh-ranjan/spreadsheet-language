(* TODO: error detection and handling *)
(* TODO: replace sheet with unit in return types *)
(* TODO: documentation *)
type index = int * int
type range = index * index
type sheet = float option array array

type func_unary = range -> index -> sheet
type func_float = range -> float -> index -> sheet
type func_index = range -> index -> index -> sheet
type func_range = range -> range -> index -> sheet
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
    sheet.(r).(c) <- Some (r_fold_left iden acc_row r1 r2 sheet)

let rec row_func func iden ((r1,c1),(r2,c2)) (r,c) sheet =
    if r1 > r2 then () else
    sheet.(r).(c) <- Some (r_fold_left iden func c1 c2 sheet.(r1));
    row_func func iden ((r1+1,c1),(r2,c2)) (r+1,c) sheet

let rec col_func func iden ((r1,c1),(r2,c2)) (r,c) sheet =
    if c1 > c2 then () else
    let acc_row x y = func x y.(c1) in
    sheet.(r).(c) <- Some (r_fold_left iden acc_row r1 r2 sheet);
    col_func func iden ((r1,c1+1),(r2,c2)) (r,c+1) sheet

let count_func x = function
| None -> x
| Some _ -> x +. 1.

let full_count = full_func count_func 0.
let row_count = row_func count_func 0.
let col_count = col_func count_func 0.

let full_sum = full_func ( +. ) 0.
let row_sum = row_func ( +. ) 0.
let col_sum = col_func ( +. ) 0.

let full_avg (((r1,c1),(r2,c2)) as range) ((r,c) as index) sheet =
    full_sum range index sheet;
    div_float (index,index) (float ((r2-r1+1)*(c2-c1+1))) index sheet

let row_avg (((r1,c1),(r2,c2)) as range) ((r,c) as index) sheet =
    row_sum range index sheet;
    div_float ((r,c),(r+r2-r1,c)) (float (c2-c1+1)) index sheet

let col_avg (((r1,c1),(r2,c2)) as range) ((r,c) as index) sheet =
    col_sum range index sheet;
    div_float ((r,c),(r,c+c2-c1)) (float (r2-r1+1)) index sheet

let min_func x y = if y < x then y else x
let min_iden = max_int (* infinity *)
let full_min = full_func min_func min_iden
let row_min = row_func min_func min_iden
let col_min = col_func min_func min_iden

let max_func x y = if y > x then y else x
let max_iden = -max_int (* -infinity *)
let full_max = full_func max_func max_iden
let row_max = row_func max_func max_iden
let col_max = col_func max_func max_iden

(**************************************************************)

let dummy_func_unary r i s = s
let dummy_func_float r f i s = s
let dummy_func_index r i i s = s
let dummy_func_range r r i s = s

let row_count = dummy_func_unary
let col_count = dummy_func_unary

let full_sum = dummy_func_unary
let row_sum = dummy_func_unary
let col_sum = dummy_func_unary

let full_avg = dummy_func_unary
let row_avg = dummy_func_unary
let col_avg = dummy_func_unary

let full_min = dummy_func_unary
let row_min = dummy_func_unary
let col_min = dummy_func_unary

let full_max = dummy_func_unary
let row_max = dummy_func_unary
let col_max = dummy_func_unary

let add_float = dummy_func_float
let subt_float = dummy_func_float
let mult_float = dummy_func_float
let div_float = dummy_func_float

let add_index = dummy_func_index
let subt_index = dummy_func_index
let mult_index = dummy_func_index
let div_index = dummy_func_index

let add_range = dummy_func_range
let subt_range = dummy_func_range
let mult_range = dummy_func_range
let div_range = dummy_func_range

