/*:
# Complex Numbers with BLAS
_Jeff Biggus (@hyperjeff) March, 2016_
*/
import Accelerate
/*:
## How to use complex numbers
- Note: Complex numbers are differently in different Accelerate libraries. Here, using the BLAS functions, they are represented by two floats in succession in an array. The first is the real component, the next the complex component. So each complex number is found every 2 elements in the array.
- Note: When you get the result out, you are responsible for remembering that the array of floats you're left with are the complex valued results. Below the result is the array **[2,0,0,8]**, but this is code for **2 + 0i** and **0 + 8i**.
*/
var z:[Float] = [ -3,  4,  5, -7  ]  // -3 + 4i, 5 - 7i

// Ex 1: Sum of absolute value of components

cblas_scasum( 2, &z, 1 )             // |-3| + |4| + |5| + |-7|  =  19


var a:[Float] = [ 1,  2,  3, 4 ]     // [ 1 + 2i,  3 + 4i ]
var b:[Float] = [ 1, -2, -3, 4 ]     // [ 1 - 2i, -3 + 4i ]
var alpha: Float = 1

//               alpha * a  +   b

cblas_caxpy( 2, &alpha, &a, 1, &b, 1 )

b                                    // [ 2 + 0i, 0 + 8 i ]
/*:
## Complex Struct
- Note: You can make a struct to group the complex values, as long as the only properties are the real and imaginary components, are floats, and are in the right order. But then you can add any convenience functions you'd like from there.
*/
struct Complex: CustomStringConvertible {
	var real: Float
	var imag: Float
	
	var description: String {
		let threshold: Float = 0.00000001
		
		if fabsf(real) > threshold && fabsf(imag) > threshold {
			return "\(real) + \(imag) i"
		}
		else if fabsf(imag) > threshold {
			return "\(imag) i"
		}
		else {
			return "\(real) + 0 i"
		}
	}
}

var c: [Complex] = [ Complex(real: 1, imag: 2), Complex(real: 3, imag: 4) ]
var d: [Complex] = [ Complex(real: 1, imag:-2), Complex(real:-3, imag: 4) ]

//               alpha * c  +   d

cblas_caxpy( 2, &alpha, &c, 1, &d, 1 )

d[0]
d[1]
/*:
## Variation Using a Postfix Operator
- Note: The above struct makes the code very wordy. One can clean up the code by actually making something like the "i" above into an operator. Here, instead of using the letter (which you can't turn into an operator anyway), we make use of the **¡** (an inverted exclamation mark, easily typed using option-1). This makes the code look very much like standard math notation.
*/
postfix operator ¡ {}
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

f[0]
f[1]
/*:
## Dot product of complex vectors:
- Note: Type-completion hint as of Xcode 7.3, since it now does fuzzy string completion: To find the BLAS dot product function without wading thru the documentation, start by typing "blas" then type "dot" and right away you're down to a selection of 4 versions of the dot product. Season to taste from there.
*/
var g: [Complex] = [ 1 + 2¡,  3 + 4¡ ]
var h: [Complex] = [ 1 - 2¡, -3 + 4¡ ]

var gDotH: Complex = 0¡

//                  g  •   h  -> gDotH   = ∑ g[i] * h[i]

cblas_cdotu_sub(2, &g, 1, &h, 1, &gDotH)

gDotH                        // 1 + 4 - 9 - 16 = -20
