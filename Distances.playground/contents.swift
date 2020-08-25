/*:
# vDSP: Distances Along a 2-d Path
_Jeff Biggus (@hyperjeff) March, 2016_
*/
import Cocoa
import Accelerate

var points:[CGPoint] = [
    CGPoint(x:  -40, y:   0),
    CGPoint(x:   35, y:  40),
    CGPoint(x:   30, y:  70),
    CGPoint(x:  110, y:  20),
    CGPoint(x:   10, y: -10),
    CGPoint(x:  -20, y: -70),
    CGPoint(x: -110, y: -20),
    CGPoint(x:   20, y: -40),
    CGPoint(x:    0, y:   0)
]

let path = NSBezierPath()
path.move(to: points[0])
for i in 1..<points.count {
    path.line(to: points[i])
}
//:## Let's say you have a set of points describing a path:
path
/*:
## How far are we from the origin at each step?
- Note: Put away that geometry book! (Actually, no, go ahead, geometry is great, just not needed here.) We have a distance function in the vDSP library! A few lines of set-up code and then a one-liner, and we get each leg's distance as an array.
*/
var xs = points.compactMap { Float($0.x) }
var ys = points.compactMap { Float($0.y) }

var distance = [Float](repeating: 0.0, count: points.count);

vDSP_vdist(&xs, 1, &ys, 1, &distance, 1, vDSP_Length(points.count))

distance.map { $0 }
//:## Total distance
distance.reduce(0, +)

