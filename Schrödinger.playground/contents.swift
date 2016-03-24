/*:
# LAPACK: Schrödinger Solutions for 1-d Square Well
_Jeff Biggus (@hyperjeff) March, 2016_
- Note: The makes use of the work done here: http://physics-simulation.blogspot.com/2007/10/solving-schrodinger-equation-linear.html
*/
import Accelerate
typealias LAInt = __CLPK_integer

let N = 80
let dx = 10 / Double(N)
let dx² = dx * dx

var hDiag = [Double](count:  N, repeatedValue: 0)
var hOff  = [Double](count:  N, repeatedValue:-1)
var v     = [Double](count:  N, repeatedValue: 0)
var work  = [Double](count:2*N, repeatedValue: 0)
var z     = [Double](count:N*N, repeatedValue: 0)

var n:      LAInt = LAInt(N-1)
var ldz:    LAInt = n
var info:   LAInt = 0
var jobType: Int8 = 86 // = "V" in ASCII

for i in 0..<N {
	v[i] =  fabs(Double(i+1) * dx - 5) < 1 ? 0 : 1
	hDiag[i] = 2.0 + 2.0 * dx² * v[i]
}
//:### The main event:
dstev_( &jobType, &n, &hDiag, &hOff, &z, &ldz, &work, &info )

info == 0 ? "Worked!" : "Failed"
//:### The lowest 4 Eigenvalues:
for i in 0..<N-1 {
	hDiag[i] / (2 * dx²)
}
//:### The lowest 4 Eigenvectors. Groundstate, 1st, 2nd, 3rd, ...
for i in 0..<N-2 {
	let m = N-1
	z[i]
	z[m + i]
	z[2*m + i]
	z[3*m + i]
	z[4*m + i]
	z[5*m + i]
	z[6*m + i]
	z[7*m + i]
	z[8*m + i]
	z[9*m + i]
}

//:### Note: After difficult setup, ONE line of code for solution
