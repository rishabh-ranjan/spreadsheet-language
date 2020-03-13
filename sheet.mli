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

(* Fills count of valid entries in the given range into the specified cell *)
val full_count: func_unary

(* Fills count of valid entries per row in the given range into the column starting from the specified cell *)
val row_count: func_unary

(* Fills count of valid entries per column in the given range into the row starting from the specified cell. *)
val col_count: func_unary

(* Fills the sum of entries of cells in the given range into the specified cell *)
val full_sum: func_unary

(* Fills the sum of entries of cells per row in the given range into the column starting from the specified cell *)
val row_sum: func_unary

(* Fills the sum of entries of cells per column in the given range into the row starting from the specified cell *)
val col_sum: func_unary

(* Fills the average of entries of cells in the given range into the specified cell *)
val full_avg: func_unary

(* Fills the average of entries of cells per row in the given range into the column starting from the specified cell *)
val row_avg: func_unary

(* Fills the sum of entries of cells per column in the given range into the row starting from the specified cell *)
val col_avg: func_unary

(* Fills the min of entries of cells in the given range into the specified cell *)
val full_min: func_unary

(* Fills the min of entries of cells per row in the given range into the column starting from the specified cell *)
val row_min: func_unary

(* Fills the min of entries of cells per column in the given range into the row starting from the specified cell *)
val col_min: func_unary

(* Fills the max of entries of cells in the given range into the specified cell *)
val full_max: func_unary

(* Fills the max of entries of cells per row in the given range into the column starting from the specified cell *)
val row_max: func_unary

(* Fills the max of entries of cells per column in the given range into the row starting from the specified cell *)
val col_max: func_unary

(* adds a constant to the contents of each cell in the selected cell range *)
val add_float: func_float

(* subtracts a constant from the contents of each cell in the selected cell range *)
val subt_float: func_float

(* multiplies the contents of each cell in the selected cell range by a constant. *)
val mult_float: func_float

(* divides the contents of each cell in the selected cell range by a constant. *)
val div_float: func_float

(* adds value at index to the contents of each cell in the selected cell range *)
val add_index: func_index

(* subtracts value at index from the contents of each cell in the selected cell range *)
val subt_index: func_index

(* multiplies the contents of each cell in the selected cell range by value at index. *)
val mult_index: func_index

(* divides the contents of each cell in the selected cell range by value at index. *)
val div_index: func_index

(* adds the cell contents for each corresponding pair of cells in two selected cell ranges *)
val add_range: func_range

(* performs a subtraction on the cell contents for each corresponding pair if cells in two selected cell ranges *)
val subt_range: func_range

(* multiplies the cell contents for each corresponding pair of cells in two selected cell ranges *)
val mult_range: func_range

(* performs a division on the cell contents for each corresponding pair of cells in two selected cell ranges *)
val div_range: func_range

