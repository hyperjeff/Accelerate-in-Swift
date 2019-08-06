/*:
# vDSP: Audio, but also much more
_Jeff Biggus (@hyperjeff) March, 2016_
*/
import Accelerate

var data:[Float]
var output:[Float]
var count: vDSP_Length
/*:
## Example 1: Create a nice ramp of data
- Note: Despite many places in functions where it looks like you should be able to just pop a number in there, often you have to send in the variable as a reference, as with the **start** and **increment** numbers below. Option-clicking the function in Xcode will show which items need to be references, typed as some kind of pointer.
- Note: As with most functions in the Accelerate framework, functions do not return anything. You pass in a reference to a _var_ variable and go from there.
*/
count = 10
var start: Float = -3
var increment: Float =  0.1
var ramp = [Float](unsafeUninitializedCapacity:Int(count), initializingWith: {_, _ in})

vDSP_vramp( &start, &increment, &ramp, 1, count )

ramp.map { $0 }
/*:
## Example 2: Absolute values
- Note: The **length** is always required to be of **vDSP_Length** type, as so you need to cast it. This used to be the case with strides as well, but now we can just put a nice **1** in there. Perhaps some day we can do that with lengths. That said, this does prevent us from mixing up items passed to the functions, arguments very easily mixed up.
*/
data = [0,0,0,0,9,-4,7,10,6,-8,9,-14,3,-4,-6,-8,8,7,4,2,0,0,0,0]

data.map { $0 }

count = vDSP_Length(data.count)
output = [Float](unsafeUninitializedCapacity:Int(count), initializingWith: {_, _ in})

vDSP_vabs( &data, 1, &output, 1, count )

output.map { $0 }

//:## Example 4: Clipping
var low: Float = 2.5
var high:Float = 4.5

vDSP_vclip( &data, 1, &low, &high, &output, 1, count )

output.map { $0 }
/*:
## Example 5: Reversing
- Note: If you're even on a job interview and someone asks you to reverse an array of floats, you can tell them that I said the following function is all you need to know.
*/
vDSP_vrvrs(&data, 1, count)

data.map { $0 }
//:## Example 6: Maximum value
var maximum: Float = 0
var mean: Float = 0
var rms: Float = 0
var sum: Float = 0

vDSP_maxv(&data, 1, &maximum, count);  maximum

vDSP_meanv(&data, 1, &mean, count);    mean

vDSP_rmsqv(&data, 1, &rms, count);     rms

vDSP_sve(&data, 1, &sum, count);       sum

