type index = int * int
type range = index * index
type sheet

(* Fills count of valid entries in the given range into the specified cell *)
val full_count: sheet -> range -> index -> sheet

(* Fills count of valid entries per row in the given range into the column starting from the specified cell *)
val row_count: sheet -> range -> index -> sheet

(* Fills count of valid entries per column in the given range into the row starting from the specified cell. *)
val col_count: sheet -> range -> index -> sheet

(* Fills the sum of entries of cells in the given range into the specified cell *)
val full_sum: sheet -> range -> index -> sheet

(* Fills the sum of entries of cells per row in the given range into the column starting from the specified cell *)
val row_sum: sheet -> range -> index -> sheet

(* Fills the sum of entries of cells per column in the given range into the row starting from the specified cell *)
val col_sum: sheet -> range -> index -> sheet

(* Fills the average of entries of cells in the given range into the specified cell *)
val full_avg: sheet -> range -> index -> sheet

(* Fills the average of entries of cells per row in the given range into the column starting from the specified cell *)
val row_avg: sheet -> range -> index -> sheet

(* Fills the sum of entries of cells per column in the given range into the row starting from the specified cell *)
val col_avg: sheet -> range -> index -> sheet

(* Fills the min of entries of cells in the given range into the specified cell *)
val full_min: sheet -> range -> index -> sheet

(* Fills the min of entries of cells per row in the given range into the column starting from the specified cell *)
val row_min: sheet -> range -> index -> sheet

(* Fills the min of entries of cells per column in the given range into the row starting from the specified cell *)
val col_min: sheet -> range -> index -> sheet

(* Fills the max of entries of cells in the given range into the specified cell *)
val full_max: sheet -> range -> index -> sheet

(* Fills the max of entries of cells per row in the given range into the column starting from the specified cell *)
val row_max: sheet -> range -> index -> sheet

(* Fills the max of entries of cells per column in the given range into the row starting from the specified cell *)
val col_max: sheet -> range -> index -> sheet

(* adds a constant to the contents of each cell in the selected cell range *)
val add_const: sheet -> range -> float -> index -> sheet

(* subtracts a constant from the contents of each cell in the selected cell range *)
val subt_const: sheet -> range -> float -> index -> sheet

(* multiplies the contents of each cell in the selected cell range by a constant. *)
val mult_const: sheet -> range -> float -> index -> sheet

(* divides the contents of each cell in the selected cell range by a constant. *)
val div_const: sheet -> range -> float -> index -> sheet

(* adds the cell contents for each corresponding pair of cells in two selected cell ranges *)
val add_range: sheet -> range -> range -> index -> sheet

(* performs a subtraction on the cell contents for each corresponding pair if cells in two selected cell ranges *)
val subt_range: sheet -> range -> range -> index -> sheet

(* multiplies the cell contents for each corresponding pair of cells in two selected cell ranges *)
val mult_range: sheet -> range -> range -> index -> sheet

(* performs a division on the cell contents for each corresponding pair of cells in two selected cell ranges *)
val div_range: sheet -> range -> range -> index -> sheet

