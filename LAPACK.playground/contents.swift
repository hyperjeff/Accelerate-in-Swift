//:# LAPACK
//:## Linear Algebra Package
// Example code from Jeff Biggus @hyperjeff
// Share, use, enhance

import Accelerate
typealias LAInt = __CLPK_integer // = Int32
//:## Solving A x = b for x

/*
	Idea: Solving simultaneous equations.
	
	3x +  y + 2z = -1
	 x + 5y + 6z =  3
	3x + 9y + 5z = -3

	Question: what's x, y and z?

	Note: the way A is set up may look flipped (LAPACK convention)
*/


var A:[Float] = [
	3, 1, 3,
	1, 5, 9,
	2, 6, 5
]

var b:[Float] = [ -1, 3, -3 ]

let equations = 3

var numberOfEquations:LAInt = 3
var columnsInA:       LAInt = 3
var elementsInB:      LAInt = 3
var bSolutionCount:   LAInt = 1

var outputOk: LAInt = 0
var pivot = [LAInt](count: equations, repeatedValue: 0)

sgesv_( &numberOfEquations, &bSolutionCount, &A, &columnsInA, &pivot, &b, &elementsInB, &outputOk)

outputOk // 0 = everything went ok

pivot // this gives an information about how the equations were solved

b

// Now to show the solutions really work:

3 * b[0] +     b[1] + 2 * b[2]
    b[0] + 5 * b[1] + 6 * b[2]
3 * b[0] + 9 * b[1] + 5 * b[2]

// the solution is good!

