/*:
# vDSP: Fast Fourier Transforms
_Jeff Biggus (@hyperjeff) March, 2016_
*/
import Accelerate
//:## Setup. See section down below to see what the input signals are and how to customize them
//:- Note: Here we will make use of **stride1** and **stride2** constants. We could just pop a 1 and a 2 in the functions below, but the functions are sufficiently complicated that the variable name helps keep straight what values go where and why.
enum InputSignal {
	case Noise, Sine, Sines, NoisySinesA, NoisySinesB, NoisySinesC, NoisySinesD, NoisySinesE
}
func floats(_ n: Int)->[Float] {
    return [Float](repeating: 0.0, count: n)
}
var ƒ: (Float) -> Float
func frandom() -> Float { return Float(arc4random()) / Float( RAND_MAX ) }
let stride1: vDSP_Stride = 1
let stride2:vDSP_Stride = 2
//:## Pick your signal and pick your sample size:
let signal: InputSignal = .Sine
let sampleSize = 2000
//:## A little more setup, now that we have the signal and sample size
//:- Note: We'll use the ramp function to use for making sine waves
let sampleLength = vDSP_Length(sampleSize)
var start: Float = 0
var increment: Float = 1
var ramp = floats( sampleSize )
vDSP_vramp( &start, &increment, &ramp, stride1, vDSP_Length( sampleSize ) )
var data = floats(sampleSize)
//:## Define how each signal is created
do {switch signal {
case .Sine: ƒ = { sin( $0 / 3 ) }
case .Sines: ƒ = { sin( $0 / 3 ) * sin( $0 / 6 ) * sin( $0 / 12 ) }
case .Noise: ƒ = { frandom() + $0 - $0 }
case .NoisySinesA: ƒ = { sin( $0 / 3 ) + frandom() / 2 }
case .NoisySinesB: ƒ = { sin( $0 / 3 ) + 0.5 * sin( $0 / 1 ) + frandom() }
case .NoisySinesC: ƒ = { frandom() * sin( $0 / 3 ) }
case .NoisySinesD: ƒ = { frandom() * sin( $0 ) * sin( 4 * $0 ) * sin( 4 * $0 ) }
case .NoisySinesE: ƒ = { frandom() * (ceil( sin( $0 / 3 ) ) - 0.5) }
}}
data = ramp.map( ƒ )
data[0..<200].map { $0 }
//:## Set up for doing an FFT
//:- Note: The FFT functions use a _Split Complex_ data type, which places the real and imaginary components in two separate arrays, below is an example of how to work with these.
let log2n: vDSP_Length = vDSP_Length(log2f(Float(sampleSize)))
let fftSetup = vDSP_create_fftsetup(log2n, FFTRadix(FFT_RADIX2))!
let nOver2 = sampleSize/2
let nOver2Length = vDSP_Length(nOver2)
var real = floats(nOver2)
var imaginary = floats(nOver2)
var splitComplex = DSPSplitComplex(realp: &real, imagp: &imaginary)
//:## Calculate a 1-d real-valued, discrete Fourier transform, from time domain to frequency domain
//:- Note: This is perhaps the most unusual part. We grab a pointer to the data's baseAddress.
data.withUnsafeBufferPointer { buffer in
    buffer.baseAddress!.withMemoryRebound(to: DSPComplex.self, capacity: buffer.count / 2) { body in
        vDSP_ctoz(body, stride2, &splitComplex, stride1, nOver2Length)
        vDSP_fft_zrip(fftSetup, &splitComplex, stride1, log2n, FFTDirection(FFT_FORWARD))
    }
}
//:## Take a look at the amplitudes of the frequencies
let amplitudeCount = sampleSize / 10
var amplitudes = floats( amplitudeCount )

vDSP_zvmags( &splitComplex, stride1, &amplitudes, stride1, vDSP_Length( amplitudeCount ) )

amplitudes[0] = splitComplex.realp[0] / Float(sampleSize * 2)
amplitudes.map { $0 }
