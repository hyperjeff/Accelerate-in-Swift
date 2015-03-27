//:# Basic Linear Algebra (BLAS)
// Example code from Jeff Biggus @hyperjeff
// Share, use, enhance

import Accelerate

//:## Basic example: Ax + y

var x:[Float] = [ 1, 2, 3 ]
var y:[Float] = [ 3, 4, 5 ]

// 3 elements, stride 1 in x, stride 1 in y

//              10 * x    + y

cblas_saxpy( 3, 10, &x, 1, &y, 1 )

y


//:## Dot product of vectors: ∑ a[i] * b[i]

// remember: y was overwritten by cblas_saxpy before
// so we have to make sure it's what we want:

y = [ 3, 4, 5 ]

cblas_sdot( 3, &x, 1, &y, 1 )   // == 1*3 + 2*4 + 3*5


//:## Scale a vector by some value

var z:[Float] = [1,2,3,4,5,6]

cblas_sscal( 6, 10, &z, 1 )
z

cblas_sscal( 6, 100, &z, 2 )
z


