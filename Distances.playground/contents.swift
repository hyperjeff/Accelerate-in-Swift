/*:
# vDSP: Distances Along a 2-d Path
_Jeff Biggus (@hyperjeff) March, 2016_
*/
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
//:## Let's say you have a set of points describing a path:
path
/*:
## How far are we from the origin at each step?
- Note: Put away that geometry book! (Actually, no, go ahead, geometry is great, just not needed here.) We have a distance function in the vDSP library! A few lines of set-up code and then a one-liner, and we get each leg's distance as an array.
*/
var xs = points.flatMap { Float($0.x) }
var ys = points.flatMap { Float($0.y) }

var distance = [Float](count: points.count, repeatedValue:0)

vDSP_vdist(&xs, 1, &ys, 1, &distance, 1, vDSP_Length(points.count))

distance.map { $0 }
//:## Total distance
distance.reduce(0, combine: +)

