/*:
# vBigNum: 128 to 1024-bit Integer functions
- Note: 2^1024 is ~224 *orders of magnitude* greater than (someone's) estimate of the number of particles in the univers. Used in Crypto a lot.
*/
import Accelerate
/*:
### Here we'll make a bunch of 1024-bit integers. They are represented by structs that contain 32 32-bit integers, the lowest is the LSW (least significant word) and the highest is the MSW (most significant word). You set their values, then use vBigNum functions to manipulate.
- Note: 2^1024 =\
179_769_313_486_231_590_772_930_519_078_902_473_361_797_697_894_230_657_273_430_081_157_732_675_805_500_963_132_708_477_322_407_536_021_120_113_879_871_393_357_658_789_768_814_416_622_492_847_430_639_474_124_377_767_893_424_865_485_276_302_219_601_246_094_119_453_082_952_085_005_768_838_150_682_342_462_881_473_913_110_540_827_237_163_350_510_684_586_298_239_947_245_938_479_716_304_835_356_329_624_224_137_216
*/
var a: vS1024 = vS1024()
var b: vS1024 = vS1024()
var c: vS1024 = vS1024()
var d: vS1024 = vS1024()
var e: vS1024 = vS1024()
var f: vS1024 = vS1024()
//:## First example, encode the numbers 1 and 3, add, then divide them:
a.s.LSW = 1
b.s.LSW = 3

vS1024Add(&a, &b, &c)

"\(a.s.LSW) + \(b.s.LSW) = \(c.s.LSW)"

vS1024Divide(&a, &b, &d, &e)

"\(a.s.LSW) / \(b.s.LSW) = \(d.s.LSW) remainder \(e.s.LSW)"
//:## Now a *huge* number: 2^1023 divided by 3
f.s.MSW = 1

vS1024Divide(&f, &b, &d, &e) // f / b

d.s.MSW
d.s.d2 // 1431655765 = UInt32.max / 3
d.s.d3
// etc
d.s.d10
// etc
d.s.d31
d.s.LSW

e.s.LSW // (the higher struct parts of e are 0)
/*:
- Note: Fun (?) analogy:\
Just as 1_000_000/3 = 333_333 remainder 1\
which is (1/3) * 10^6 + (1/3) * 10^5 + ... (1/3) * 10^1 + 1\
so also this is "just"\
(1/3) * (UInt32.max)^31 + (1/3) * (UInt32.max)^30 + ... + 1\
i.e., 1_431_655_765 is just the 1/3rd number in base 4_294_967_296
*/