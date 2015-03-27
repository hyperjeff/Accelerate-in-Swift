//:# vDSP: Audio, but also much more
// Example code from Jeff Biggus @hyperjeff
// Share, use, enhance

import Accelerate

var data:[Float]
var output:[Float]
var count: vDSP_Length
let stride1:vDSP_Stride = 1

//:## Example 1: Create a nice ramp of data

count = 10
var start: Float = -3
var end:   Float =  0.1
var ramp = [Float](count:Int(count), repeatedValue:0)

vDSP_vramp( &start, &end, &ramp, stride1, count )

ramp.map { $0 }

//:## Example 2: Absolute values

data = [0,0,0,0,9,-4,7,10,6,-8,9,-14,3,-4,-6,-8,8,7,4,2,0,0,0,0]

data.map { $0 }

count = vDSP_Length(data.count)
output = [Float](count:Int(count), repeatedValue:0)

vDSP_vabs( &data, stride1, &output, stride1, count )

output.map { $0 }

//:## Example 4: Clipping

var low: Float = 2.5
var high:Float = 4.5

vDSP_vclip( &data, stride1, &low, &high, &output, stride1, count )

output.map { $0 }

//:## Example 5: Reversing

vDSP_vrvrs(&data, stride1, count)

data.map { $0 }

//:## Example 6: Maximum value

var maximum: Float = 0
var mean: Float = 0
var rms: Float = 0
var sum: Float = 0

vDSP_maxv(&data, stride1, &maximum, count);  maximum

vDSP_meanv(&data, stride1, &mean, count);    mean

vDSP_rmsqv(&data, stride1, &rms, count);     rms

vDSP_sve(&data, stride1, &sum, count);       sum

