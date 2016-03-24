/*:
[Previous](@previous)
# Equation Trees and Lazy Evaluation
_Jeff Biggus (@hyperjeff) March, 2016_
*/
import Accelerate

var aSourceOfFloats: [Float] = [1,2,3,4,5,6]

let aAsMatrix = la_matrix_from_float_buffer( &aSourceOfFloats, 1, 6, 6, 0, 0 )

let aVector = la_vector_from_matrix_row(aAsMatrix, 0)

var aCheckOnThatVector = [Float](count: 6, repeatedValue: 0)

la_vector_to_float_buffer(&aCheckOnThatVector, 1, aVector)

aCheckOnThatVector

// ahhhh... ok, a pain, but it works. Get the data in, get it out.
/*:
### So let's turn that into a convenient function (why isn't there one?)
*/
func la_vector(vector: [Float]) -> la_object_t {
	var floats = vector
	let count = la_count_t(floats.count)
	let floatsAsMatrix = la_matrix_from_float_buffer( &floats, 1, count, count, 0, 0 )
	return la_vector_from_matrix_row(floatsAsMatrix, 0)
}

func vectorAsFloats(vector: la_object_t) -> [Float] {
	var vectorAsFloats = [Float](count: Int(la_vector_length(vector)), repeatedValue:0)
	la_vector_to_float_buffer(&vectorAsFloats, 1, vector)
	return vectorAsFloats
}

let a = la_vector([1,2,3,4,5,6,7,8,9])
let b = la_vector([9,8,7,6,5,4,3,2,1])

let c = la_sum(a, b)

vectorAsFloats(c)
/*:
### Yes, that was a terrible payoff for all that work. Continuing on...
*/
let d = la_scale_with_float(b, 10)

let e = la_inner_product(c, d)

let f = la_vector_slice(a, 2, 3, 3)

vectorAsFloats(f)
/*:
- Note: Nothing is actually computed until you ask to transfer the data in the LA objects into a buffer. Above, that happens each time with run **vectorAsFloats**. But, as with blocks, we can set up an arbitrarily long chain of functions which do something, but don't actually do any evaluating until the whole chain is set off by a request to put the result into the buffer. This also has the nice side effect of not evaluating anything that doesn't need to be.
 */
