//:# vForce
//:## Standard Math on Arrays
// Example code from Jeff Biggus @hyperjeff
// Share, use, enhance

import Accelerate

func floats(n: Int32)->[Float] {
	return [Float](count:Int(n), repeatedValue:0)
}

//:## Example: Absolute values

var count: Int32 = 4
var a:[Float] = [3,-2,5,-10]
var aAbsolute = floats(count)

vvfabsf( &aAbsolute, &a, &count )

aAbsolute

//:### Lessons:
//: * Docs claim y[i] = abs(x[i]-1), but it's actually abs(x[i]). Docs fallable.
//: * "count" needs to be Int32, not just Int

//:## Example: Integers from Floats

count = 3
var b:[Float] = [3.3796, 1.8036, -2.1205]
var bInt = floats(count)

vvintf( &bInt, &b, &count )

bInt

//:### Lesson:
//: * Sometimes NO variables in the docs at all!

//:## Example: Square Roots

count = 4
var c:[Float] = [16,9,4,1]
var cSquareRoots = floats(count)

vvsqrtf( &cSquareRoots, &c, &count )

cSquareRoots

//:## Example: Flipping Numbers Over

count = 4
var d:[Float] = [1/3, 2/5, 1/8, -3/1]
var dFlipped = floats(count)

vvrecf( &dFlipped, &d, &count )

dFlipped


//:## Example: Taking a Sin

let π: Float = 355/113
count = 100
var ramp = floats(count)
var rampStart: Float = 0
var rampIncrease: Float = 1/(5 * π) //Float(count) / (2 * π)

var rampSin = floats(count)

vDSP_vramp( &rampStart, &rampIncrease, &ramp, 1, vDSP_Length(count) )
ramp

vvsinpif( &rampSin, &ramp, &count )

rampSin.map { $0 }

//:## But: Cos for free at the same time

var rampCos = floats(count)
rampIncrease = 1/5
vDSP_vramp( &rampStart, &rampIncrease, &ramp, 1, vDSP_Length(count) )
ramp

vvsincosf( &rampSin, &rampCos, &ramp, &count )

rampSin.map { $0 }

rampCos.map { $0 }

//:### Lesson:
//: * The input values are off by a factor of π from the other function!
//:   (Not mentioned in the docs)
