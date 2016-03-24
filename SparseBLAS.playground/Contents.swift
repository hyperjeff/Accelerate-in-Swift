/*:
# Sparse BLAS
_Jeff Biggus (@hyperjeff) March, 2016_

----
## BLAS for Sparse matrices
- Note: Introduces in 2015 for iOS 9 and Mac OS X 10.10.
- Note: Single and Double precision operations: products, triangular solves, norms, traces, permutations, inserts & extracts. Many storage formats available. Uses a sparse matrix data type.

*/
import Accelerate
/*:
## Sparse Matrix Data Type
- Note: Manages data buffer, storage format and dimension details for you.
*/
var A = sparse_matrix_create_float(3700, 4041)

// insert a single value

sparse_insert_entry_float(A, 15, 2874, 1798)

// insert a whole row or column of stuff at once

let rowValues:[Float]  = [   3,    9,    7 ]
let rowIndices:[sparse_index] = [ 937, 1599, 2300 ]

let status = sparse_insert_row_float(A, 1100, 3, rowValues, rowIndices)

status.rawValue
//: From here, you can operate on the matrices as with BLAS.