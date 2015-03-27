//:# vDSP: Fast Fourier Transforms
// Example code from Jeff Biggus @hyperjeff
// Share, use, enhance

import Accelerate

let sampleSize = 500
let sampleLength = vDSP_Length(sampleSize)
var data = [Float](count: sampleSize, repeatedValue:0.0)
for i in 0..<sampleSize {
	let noise = Float(random())/Float(RAND_MAX)
//	data[i] = noise
//	data[i] = Float(random()) * sin(Float(i)) * sin(Float(4*i)) * sin(Float(4*i))/Float(RAND_MAX)
	data[i] = sin(Float(i)/30.0)
//	data[i] = sin(Float(i)/30.0) * sin(Float(i)/60.0) * sin(Float(i)/60.0)
//	data[i] = sin(Float(i)/30.0) + 0.5 * sin(Float(i)/10.0) + noise
//	data[i] = sin(Float(i)/30.0) + Float(random())/(Float(RAND_MAX) * 2.0)
//	data[i] = Float(random()) * (sin(Float(i)/3.0))/Float(RAND_MAX)
//	data[i] = Float(random()) * (ceil(sin(Float(i)/3.0))-0.5)/Float(RAND_MAX)
}
data.map { $0 }

let log2n: vDSP_Length = vDSP_Length(log2f(Float(sampleSize)))
let fftSetup = vDSP_create_fftsetup(log2n, FFTRadix(FFT_RADIX2))
let nOver2 = sampleSize/2

var Arealp = [Float](count:nOver2 * sizeof(Float), repeatedValue:0.0)
var Aimagp = [Float](count:nOver2 * sizeof(Float), repeatedValue:0.0)
var A = DSPSplitComplex(realp: &Arealp, imagp: &Aimagp)

let stride: vDSP_Stride = 1
let stride2:vDSP_Stride = 2

let nOver2Length = vDSP_Length(nOver2)

data.withUnsafeBufferPointer { (dataPointer: UnsafeBufferPointer<Float>) -> Void in
	var complexData = UnsafePointer<DSPComplex>( dataPointer.baseAddress )
	vDSP_ctoz(complexData, stride2, &A, stride, nOver2Length)
	vDSP_fft_zrip(fftSetup, &A, stride, log2n, FFTDirection(FFT_FORWARD))
}

let ampCount: Int = sampleSize / 50
var amp = [Float](count: ampCount, repeatedValue: 0.0)
amp[0] = A.realp[0] / Float(sampleSize * 2)
for i in 1..<ampCount {
	amp[i] = A.realp[i] * A.realp[i] + A.imagp[i] * A.imagp[i]
}
amp.map { $0 }
