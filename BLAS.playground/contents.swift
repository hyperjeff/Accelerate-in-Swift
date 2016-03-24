/*:
# Basic Linear Algebra (BLAS)
_Jeff Biggus (@hyperjeff) March, 2016_
*/
import Accelerate
/*:
## Basic example: Ax + y
- Note: **s** = float function, **axpy** = abbreviation for "a times x plus y"\
Here we will find **10 * x + y** for a 3 element array.
- Note: It's useful to add a comment above the code illustrating what you think the function is doing, because it's easy to grab the wrong function and very hard to figure out what you meant without such notes. Often there's enough room to align the math right over the variables.
*/
var x:[Float] = [ 1, 2, 3 ]
var y:[Float] = [ 3, 4, 5 ]

//              10 * x    + y

cblas_saxpy( 3, 10, &x, 1, &y, 1 )

y
//: ----
//:## Dot product of vectors: ∑ a[i] * b[i]
//: - Note: Since the original value of **y** was overwritten by **cblas_saxpy** above, we reset it here. It's important when using values in multiple places to check and see if they were mutated by preceding functions.
y = [ 3, 4, 5 ]

//              x  •   y

cblas_sdot( 3, &x, 1, &y, 1 )   // == 1*3 + 2*4 + 3*5
//: ----
//:## Scale a vector by some value
var z:[Float] = [1,2,3,4,5,6]

//              10 * z

cblas_sscal( 6, 10, &z, 1 )
z

//              100 * z  for every other element

cblas_sscal( 6, 100, &z, 2 )
z
