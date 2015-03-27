// Example code from Jeff Biggus @hyperjeff
// Share, use, enhance

import Accelerate

/*
	Solivng A x = b for x

	Note: A is transposed from how it has to be with LAPACK!
*/

var A:[Float] = [
	3, 1, 2,
	1, 5, 6,
	3, 9, 5
]

var b:[Float] = [ -1, 3, -3 ]
var x = [Float](count: 3, repeatedValue:0)

// First transform A and b into the world of LinearAlgebra objects (la_object_t)

let count1 = la_count_t(1) // to help with clarity
let count3 = la_count_t(3)
let index1 = la_index_t(1)

// la_hint_t(LA_NO_HINT) = 0
// la_attribute_t(LA_DEFAULT_ATTRIBUTES) = 0


let A™ = la_matrix_from_float_buffer( &A, count3, count3, count3, 0, 0 )
let b™ = la_matrix_from_float_buffer( &b, count3, count1, count1, 0, 0 )

let x™ = la_solve( A™, b™ )


// Then we transfer the number back into the world of Floats

let status = la_vector_to_float_buffer( &x, index1, x™ )


// Note: returning LA objects give you a status update on how things went


println()
if status == 0 {
	println("Worked!")
} else if status > 0 {
	println("Worked, but accuracy is poor")
} else {
	println("FALID")
}
println()
println( "Answer: \(x)" )
println()

// Minor notes: Variables accessed by reference (A, b, x) have to be var-iable
//              LA objects don't need to be mutable unless, ya know, you want to mutate them
