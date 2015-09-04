//:# vDSP: Fast Fourier Transforms
// Example code from Jeff Biggus @hyperjeff
// Share, use, enhance
import Accelerate
//:## Setup. See section down below to see what the input signals are and how to customize them
enum InputSignal {
	case Noise, Sine, Sines, NoisySinesA, NoisySinesB, NoisySinesC, NoisySinesD, NoisySinesE
}
func floats(n: Int)->[Float] {
	return [Float](count:n, repeatedValue:0)
}
var ƒ: Float -> Float
func frandom() -> Float { return Float(random()) / Float( RAND_MAX ) }
let stride1: vDSP_Stride = 1
let stride2:vDSP_Stride = 2
//:## Pick your signal and pick your sample size:
let signal: InputSignal = .Sine
let sampleSize = 500
//:## A little more setup, now that we have the signal and sample size
let sampleLength = vDSP_Length(sampleSize)
var start: Float = 0
var increment: Float = 1
var ramp = floats( sampleSize )
vDSP_vramp( &start, &increment, &ramp, stride1, vDSP_Length( sampleSize ) )
var data = floats(sampleSize)
//:## Define how each signal is created
switch signal {
case .Sine: ƒ = { sin( $0 / 3 ) }
case .Sines: ƒ = { sin( $0 / 3 ) * sin( $0 / 6 ) * sin( $0 / 12 ) }
case .Noise: ƒ = { frandom() + $0 - $0 }
case .NoisySinesA: ƒ = { sin( $0 / 3 ) + frandom() / 2 }
case .NoisySinesB: ƒ = { sin( $0 / 3 ) + 0.5 * sin( $0 / 1 ) + frandom() }
case .NoisySinesC: ƒ = { frandom() * sin( $0 / 3 ) }
case .NoisySinesD: ƒ = { frandom() * sin( $0 ) * sin( 4 * $0 ) * sin( 4 * $0 ) }
case .NoisySinesE: ƒ = { frandom() * (ceil( sin( $0 / 3 ) ) - 0.5) }
}
data = ramp.map( ƒ )
data.map { $0 }
//:## Set up for doing an FFT
let log2n: vDSP_Length = vDSP_Length(log2f(Float(sampleSize)))
let fftSetup = vDSP_create_fftsetup(log2n, FFTRadix(FFT_RADIX2))
let nOver2 = sampleSize/2
let nOver2Length = vDSP_Length(nOver2)
var real = floats(nOver2 * sizeof(Float))
var imaginary = floats(nOver2 * sizeof(Float))
var splitComplex = DSPSplitComplex(realp: &real, imagp: &imaginary)
//:## Calculate a 1-d real-valued, discrete Fourier transform, from time domain to frequency domain
data.withUnsafeBufferPointer { (dataPointer: UnsafeBufferPointer<Float>) -> Void in
	var complexData = UnsafePointer<DSPComplex>( dataPointer.baseAddress )
	vDSP_ctoz(complexData, stride2, &splitComplex, stride1, nOver2Length)
	vDSP_fft_zrip(fftSetup, &splitComplex, stride1, log2n, FFTDirection(FFT_FORWARD))
}
//:## Take a look at the amplitudes of the frequencies
let amplitudeCount = sampleSize / 10
var amplitudes = floats( amplitudeCount )
vDSP_zvmags( &splitComplex, stride1, &amplitudes, stride1, vDSP_Length( amplitudeCount ) )
amplitudes[0] = splitComplex.realp[0] / Float(sampleSize * 2)
amplitudes.map { $0 }
