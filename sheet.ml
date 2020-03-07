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
