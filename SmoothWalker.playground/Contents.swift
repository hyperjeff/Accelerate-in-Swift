/*:
# Using vDSP: Smooth out a Random Path
_Jeff Biggus (@hyperjeff) March, 2016_
*/
import Cocoa
import Accelerate

var points: [CGPoint] = [CGPointMake(0, 0)]

func randomNudge() -> CGPoint {
	return CGPointMake(
		CGFloat(Int(arc4random_uniform(101)) - 50) / 5.0,
		CGFloat(Int(arc4random_uniform(101)) - 50) / 5.0)
}

infix operator + {}
infix operator / {}
func + (left: CGPoint, right:CGPoint) -> CGPoint {
	return CGPointMake(left.x + right.x, left.y + right.y)
}
func / (left: CGPoint, right: Float) -> CGPoint {
	return CGPointMake(left.x / CGFloat(right), left.y / CGFloat(right))
}

var v = CGPointMake(0, 0)

for _ in 0...99 {
	let p = points.last!
	v = randomNudge() + (v / 1.2)
	points.append(CGPointMake(p.x + v.x, p.y + v.y))
}

let path = NSBezierPath()
path.appendBezierPathWithPoints(UnsafeMutablePointer<CGPoint>(points), count: points.count)
path
// tease out the x and y values
let xs: [Float] = points.map { Float($0.x) }
let ys: [Float] = points.map { Float($0.y) }

// set up a variable to hold the result
var distance = [Float](count: points.count, repeatedValue: 0)

// one-liner!
vDSP_vdist(xs, 1, ys, 1, &distance, 1, vDSP_Length(points.count))

// display
distance.map { $0 }
var maximumX: Float = 0
var minimumX: Float = 0

vDSP_maxv(xs, 1, &maximumX, vDSP_Length(points.count))
vDSP_minv(xs, 1, &minimumX, vDSP_Length(points.count))

maximumX
minimumX

let windowSize: Int = 5

var smoothXs = [Float](count: points.count, repeatedValue: 0)
var smoothYs = [Float](count: points.count, repeatedValue: 0)
let window = vDSP_Length(windowSize)

vDSP_vswsum(xs, 1, &smoothXs, 1, vDSP_Length(points.count), window)
vDSP_vswsum(ys, 1, &smoothYs, 1, vDSP_Length(points.count), window)

let smoothXsGuts = smoothXs[0 ..< points.count - windowSize - 1]
xs.map { $0 }
smoothXsGuts.map { $0 }

var smoothPoints: [CGPoint] = []
for i in 0 ..< smoothXs.count - windowSize - 1 {
	let x = smoothXs[i] / 5
	let y = smoothYs[i] / 5
	smoothPoints.append(CGPointMake(CGFloat(x), CGFloat(y)))
}

let smoothPath = NSBezierPath()
smoothPath.appendBezierPathWithPoints(
	UnsafeMutablePointer<CGPoint>(smoothPoints), count: smoothPoints.count)

path
smoothPath
