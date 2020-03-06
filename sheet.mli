type index = int * int
type range = index * index
type sheet

type func = sheet -> range -> index -> sheet
type func_float = sheet -> range -> float -> index -> sheet
type func_range = sheet -> range -> range -> index -> sheet

(* Fills count of valid entries in the given range into the specified cell *)
val full_count: func

(* Fills count of valid entries per row in the given range into the column starting from the specified cell *)
val row_count: func

(* Fills count of valid entries per column in the given range into the row starting from the specified cell. *)
val col_count: func

(* Fills the sum of entries of cells in the given range into the specified cell *)
val full_sum: func

(* Fills the sum of entries of cells per row in the given range into the column starting from the specified cell *)
val row_sum: func

(* Fills the sum of entries of cells per column in the given range into the row starting from the specified cell *)
val col_sum: func

(* Fills the average of entries of cells in the given range into the specified cell *)
val full_avg: func

(* Fills the average of entries of cells per row in the given range into the column starting from the specified cell *)
val row_avg: func

(* Fills the sum of entries of cells per column in the given range into the row starting from the specified cell *)
val col_avg: func

(* Fills the min of entries of cells in the given range into the specified cell *)
val full_min: func

(* Fills the min of entries of cells per row in the given range into the column starting from the specified cell *)
val row_min: func

(* Fills the min of entries of cells per column in the given range into the row starting from the specified cell *)
val col_min: func

(* Fills the max of entries of cells in the given range into the specified cell *)
val full_max: func

(* Fills the max of entries of cells per row in the given range into the column starting from the specified cell *)
val row_max: func

(* Fills the max of entries of cells per column in the given range into the row starting from the specified cell *)
val col_max: func

(* adds a constant to the contents of each cell in the selected cell range *)
val add_const: func_float

(* subtracts a constant from the contents of each cell in the selected cell range *)
val subt_const: func_float

(* multiplies the contents of each cell in the selected cell range by a constant. *)
val mult_const: func_float

(* divides the contents of each cell in the selected cell range by a constant. *)
val div_const: func_float

(* adds the cell contents for each corresponding pair of cells in two selected cell ranges *)
val add_range: func_range

(* performs a subtraction on the cell contents for each corresponding pair if cells in two selected cell ranges *)
val subt_range: func_range

(* multiplies the cell contents for each corresponding pair of cells in two selected cell ranges *)
val mult_range: func_range

(* performs a division on the cell contents for each corresponding pair of cells in two selected cell ranges *)
val div_range: func_range

