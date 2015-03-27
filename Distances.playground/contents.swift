//:# vDSP: Vectory Distances
// Example code from Jeff Biggus @hyperjeff
// Share, use, enhance

import Cocoa
import Accelerate

var points:[CGPoint] = [
	CGPointMake( -40,   0),
	CGPointMake(  35,  40),
	CGPointMake(  30,  70),
	CGPointMake( 110,  20),
	CGPointMake(  10, -10),
	CGPointMake( -20, -70),
	CGPointMake(-110, -20),
	CGPointMake(  20, -40),
	CGPointMake(   0,   0)
]

let path = NSBezierPath()
path.moveToPoint(points[0])
for i in 1..<points.count {
	path.lineToPoint(points[i])
}

path

var xs = [Float](count: points.count, repeatedValue:0)
var ys = [Float](count: points.count, repeatedValue:0)

for i in 0..<points.count {
	xs[i] = Float(points[i].x)
	ys[i] = Float(points[i].y)
}

var distance = [Float](count: points.count, repeatedValue:0)

let stride1:vDSP_Stride = 1
let length = vDSP_Length(points.count)


vDSP_vdist(&xs, stride1, &ys, stride1, &distance, stride1, length)


distance

distance.reduce(0, combine: +)

