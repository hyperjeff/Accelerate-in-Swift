/*:
# simd: Single Instruction, Multiple Data
_Jeff Biggus (@hyperjeff) March, 2016_
### Introduced in 2014 for use with Metal, but also very useful on its own. It's available for iOS 8 and OS X 10.10 on up.
 * Support 2, 3 and 4-d math & geometry.
 * Floats, doubles, 32-bit ints (signed & unsigned), long vectors and unaligned vectors supported.
 * Uses normal operators + - * / (etc) to work on vectors and matrices.
 * There are conversion functions to change types
 * Has uniform function names to work on different sized objects.
 * Provide Metal-esque feature parity. Helpful for prototyping Metal code.
 * Works great with other libraries like ModelIO, Metal, SpriteKit, etc.
----
*/
import simd
/*:
----
### Convenient and frequently useful data types
- Note: The component labels are optional
*/
let geoLocation = float2(x: 15.1231, y: -23.846)

let voxelLocation = float3(3, -2, 4)

let spacetimeLocation = float4(x: 2, y: 5, z: 3, w: -1)

let specialRelativitySpacetimeMetric = float4x4([
	[ 1, 0, 0, 0],
	[ 0, 1, 0, 0],
	[ 0, 0, 1, 0],
	[ 0, 0, 0,-1]
])

spacetimeLocation * specialRelativitySpacetimeMetric * spacetimeLocation
/*:
----
### Grabbing components via properties or indexes
*/
geoLocation[0]
geoLocation.x

voxelLocation[2]
voxelLocation.z

spacetimeLocation[3]
spacetimeLocation.w
/*:
----
### Easier ways to do common functions without needing to roll your own:
*/
let x = double3(2)        // one argument makes all components to the value
let y = double3(5, 6, 7)

x + 3 * y

dot(x, y)          // 2 * 5 + 2 * 6 + 2 * 7 = 36

cross(x, y)

reflect(x, n: y)   // reflect the vector x in the plane defined by the normal vector y
/*:
----
## Matrices
Lots of standard functions available.
- Note: Matrices are (columns) x (rows). This is the opposite of most math / science books, but some graphics programming texts use this ordering and it leaked into some (but by no means all) real world code. Why they decided to go down this path is a historical accident we are stuck with. This means the order of operations may be the opposite of what you expect or read in a source text. Re-ordering and transposing can get things right.
*/
let m = float3x2( [[1,2], [3,4], [5,6]] ) // collection of *columns*

m.cmatrix
m.transpose

geoLocation * m
m.transpose * geoLocation

abs(geoLocation)
vector_max(voxelLocation, float3(-5))
vector_max(vector_abs(voxelLocation), vector_abs(float3(-5)))
vector_clamp(voxelLocation, float3(-1), float3(2))

vector_smoothstep(float3(-10), float3(10), voxelLocation)
//: - Note: There are fats and precise versions of several functions. Make sure to actually check on the precision that you need in your apps and then make a choice about which functions to use.
vector_fast_recip(geoLocation)
vector_precise_recip(geoLocation)

vector_fast_recip(geoLocation) * geoLocation
vector_precise_recip(geoLocation) * geoLocation
/*:
----
- Note: There may be times when you need to interoperate with other parts of the system that insist on, say, a vector_float4 instead of a float4, or a matrix_float4x4 instaed of float4x4. Just convert to the other type and be happy.
*/