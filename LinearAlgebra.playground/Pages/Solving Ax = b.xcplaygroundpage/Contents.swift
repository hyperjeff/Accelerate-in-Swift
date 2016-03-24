/*:
[Previous](@previous) | [Next](@next)
# LinearAlgebra:  Solivng A x = b for x
_Jeff Biggus (@hyperjeff) March, 2016_
*/
import Accelerate
//: - Note: A is transposed from how it has to be with LAPACK!
var A: [Float] = [
	3, 1, 2,
	1, 5, 6,
	3, 9, 5
]

var b: [Float] = [ -1, 3, -3 ]
var x = [Float](count: 3, repeatedValue:0)
//: ### First transform A and b into the world of LinearAlgebra objects (la_object_t)
let count1 = la_count_t(1) // to help with clarity
let count3 = la_count_t(3)
let index1 = la_index_t(1)

let A™ = la_matrix_from_float_buffer( &A, count3, count3, count3, 0, 0 )
let b™ = la_matrix_from_float_buffer( &b, count3, count1, count1, 0, 0 )

let x™ = la_solve( A™, b™ )
//: ### Then we transfer the number back into the world of Floats
let status = la_vector_to_float_buffer( &x, index1, x™ )

x // our answer! It's over there ➤
/*:
- Note: Returning LA objects give you a status update on how things went
- Note: You can pass "hints" to the above matrix maker, in order to tell it, for instance, type of matrix (symmetric, diagonal, etc), which also helps performance. In the above, 0 = LA_NO_HINT.
- Note: You can also pass attribute information. In the above, 0 = default attributes. You can also enable logging.
- Note: It is best to delay error checking until the very end, because it triggers any not-yet-done computations, and any code above will gracefully propagate its errors down the equation graph. The debug logging in the last note lets you track down where any problems happened in the chain. 
*/
if status == 0 {
	"Worked!"
} else if status > 0 {
	"Worked, but accuracy is poor"
} else {
	"FAILED"
}
/*:
- Note: Variables accessed by reference (A, b, x) have to be var-iable.
- Note: LA objects don't need to be mutable unless, ya know, you want to mutate them.
*/