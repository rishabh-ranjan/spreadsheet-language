type index = int * int
type range = index * index
type sheet = float option array array ref

type func_unary = range -> index -> sheet -> sheet
type func_float = range -> float -> index -> sheet -> sheet
type func_index = range -> index -> index -> sheet -> sheet
type func_range = range -> range -> index -> sheet -> sheet
type func_binary = {
    for_float: func_float;
    for_index: func_index;
    for_range: func_range
}

let dummy_func_unary r i s = s
let dummy_func_float r f i s = s
let dummy_func_index r i i s = s
let dummy_func_range r r i s = s

let full_count = dummy_func_unary
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

