/*:
# Using vDSP: Smooth out a Random Path
_Jeff Biggus (@hyperjeff) March, 2016_
*/
import Cocoa
import Accelerate

var points: [CGPoint] = [.zero]

func randomNudge() -> CGPoint {
    return CGPoint(x: CGFloat(Int(arc4random_uniform(101)) - 50) / 5.0,
                   y: CGFloat(Int(arc4random_uniform(101)) - 50) / 5.0)
}

// infix operator +
// infix operator /

func + (left: CGPoint, right:CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
func / (left: CGPoint, right: Float) -> CGPoint {
    return CGPoint(x: left.x / CGFloat(right), y: left.y / CGFloat(right))
}

var v = CGPoint.zero

for _ in 0...99 {
	let p = points.last!
	v = randomNudge() + (v / 1.2)
    points.append(CGPoint(x: p.x + v.x, y: p.y + v.y))
}

let path = NSBezierPath()
points.withUnsafeBufferPointer { buffer in
    buffer.baseAddress!.withMemoryRebound(to: NSPoint.self, capacity: points.count) { nsp in
        path.appendPoints(NSPointArray(mutating: nsp), count: points.count)
    }
}

path
// tease out the x and y values
let xs: [Float] = points.map { Float($0.x) }
let ys: [Float] = points.map { Float($0.y) }

// set up a variable to hold the result
var distance = [Float](repeating: 0, count: points.count)

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

var smoothXs = [Float](repeating: 0, count: points.count)
var smoothYs = [Float](repeating: 0, count: points.count)
let window = vDSP_Length(windowSize)

vDSP_vswsum(xs, 1, &smoothXs, 1, vDSP_Length(points.count), window)
vDSP_vswsum(ys, 1, &smoothYs, 1, vDSP_Length(points.count), window)

let smoothXsGuts = smoothXs[0 ..< points.count - windowSize - 1]
xs.map { $0 }
smoothXsGuts.map { $0 }

var smoothPoints: [CGPoint] = []
for i in 0 ..< smoothXs.count - windowSize - 1 {
	let x = CGFloat(smoothXs[i] / 5)
	let y = CGFloat(smoothYs[i] / 5)
    smoothPoints.append(CGPoint(x: x, y: y))
}

let smoothPath = NSBezierPath()
smoothPoints.withUnsafeBufferPointer { buffer in
    buffer.baseAddress!.withMemoryRebound(to: NSPoint.self, capacity: smoothPoints.count) { nsp in
        smoothPath.appendPoints(NSPointArray(mutating: nsp), count: smoothPoints.count)
    }
}

path
smoothPath
