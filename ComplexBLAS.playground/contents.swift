//:# Complex Numbers with BLAS
// Example code from Jeff Biggus @hyperjeff
// Share, use, enhance

import Accelerate

//: How to use complex numbers

var z:[Float] = [ -3,  4,  5, -7  ]  // -3 + 4i, 5 - 7i

cblas_scasum( 2, &z, 1 )             // |-3| + |4| + |5| + |-7|  =  19


var a:[Float] = [ 1,  2,  3, 4 ]  // [ 1 + 2i,  3 + 4i ]
var b:[Float] = [ 1, -2, -3, 4 ]  // [ 1 - 2i, -3 + 4i ]
var alpha: Float = 1

cblas_caxpy( 2, &alpha, &a, 1, &b, 1 )

b

//: Make a nice complex struct

struct Complex {
	var real: Float
	var imag: Float
	
	var description: String {
		if real > 0.00000001 && imag > 0.00000001 {
			return "\(real) + \(imag) i"
		}
		else if imag > 0.00000001 {
			return "\(imag) i"
		}
		else {
			return "\(real) + 0 i"
		}
	}
}

var c: [Complex] = [ Complex(real: 1, imag: 2), Complex(real: 3, imag: 4) ]
var d: [Complex] = [ Complex(real: 1, imag:-2), Complex(real:-3, imag: 4) ]

cblas_caxpy( 2, &alpha, &c, 1, &d, 1 )

d[0].description
d[1].description


//: For fun, using ¡ as a postfix operator

postfix operator ¡ { }
postfix func ¡ (x: Float) -> Complex {
	return Complex(real: 0, imag: x)
}
infix operator + {}
func + (lhs: Float, rhs: Complex) -> Complex {
	return Complex(real: lhs + rhs.real, imag:rhs.imag)
}
infix operator - {}
func - (lhs: Float, rhs: Complex) -> Complex {
	return Complex(real: lhs - rhs.real, imag:-1 * rhs.imag)
}

var e: [Complex] = [ 1 + 2¡,  3 + 4¡ ]
var f: [Complex] = [ 1 - 2¡, -3 + 4¡ ]

cblas_caxpy( 2, &alpha, &e, 1, &f, 1 )

f[0].description
f[1].description


//: Dot product of complex vectors:

var g: [Complex] = [ ]
