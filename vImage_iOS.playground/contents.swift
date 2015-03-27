//: Playground - noun: a place where people can play
// Example code from Jeff Biggus @hyperjeff
// Share, use, enhance

import UIKit
import Accelerate

let image = UIImage(named: "tree-dwelling-goats.jpg")!

image.CGImage


var buffer: vImage_Buffer
//var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 24, colorSpace: colorSpace, bitmapInfo: <#CGBitmapInfo#>, version: <#UInt32#>, decode: <#UnsafePointer<CGFloat>#>, renderingIntent: <#CGColorRenderingIntent#>)
var format: vImage_CGImageFormat

let error = vImageBuffer_InitWithCGImage(&buffer, &format, nil, image.CGImage, kvImageNoFlags)




var newCGImage = vImageCreateCGImageFromBuffer( &buffer, &format, nil, nil, kvImageNoFlags, &error)

// vImageConvert_AnyToAny <--






/*
let imageSize = image.size
let w = Int(imageSize.width)
let h = Int(imageSize.height)

func ARGB888imageDataForImage(image: UIImage) -> NSData {
	var data = NSData()
	let imageRef = image.CGImage
	
	let colorSpace = CGColorSpaceCreateDeviceRGB()
	let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
	
	// draw the image into a compliant buffer and get that data
	
	let context = CGBitmapContextCreate(nil, w, h, 8, 0, colorSpace, bitmapInfo)
	
	let rect = CGRectMake(0, 0, imageSize.width, imageSize.height)
	CGContextDrawImage(context, rect, imageRef)
	let newImage = CGBitmapContextCreateImage(context)
	let dataProvider = CGImageGetDataProvider(newImage)
	let dataRef = CGDataProviderCopyData(dataProvider)
	
	return dataRef
}

struct Color {
	var a,r,g,b: Int8
}

//let data = ARGB888imageDataForImage(image)
//data.length

var kernel:[Int16] = [
	-2, -2, 0,
	-2,  6, 0,
	 0,  0, 0
]
var data = NSMutableData()
var outData = [Int](count: data.length, repeatedValue: 0)
var outData2 = [Int](count: data.length, repeatedValue:0)

var src   = vImage_Buffer(data: &data,     height: vImagePixelCount(h), width: vImagePixelCount(w), rowBytes: 4*w)
var dest  = vImage_Buffer(data: &outData,  height: vImagePixelCount(h), width: vImagePixelCount(w), rowBytes: 4*w)
var dest2 = vImage_Buffer(data: &outData2, height: vImagePixelCount(h), width: vImagePixelCount(w), rowBytes: 4*w)

var bgColor: [UInt8] = [0,0,0,0]

//vImagePixelCount(3)

//vImageConvolve_ARGB8888( &src, &dest, nil, vImagePixelCount(0), vImagePixelCount(0), kernel, UInt32(3), UInt32(3), Int32(1), bgColor, kvImageBackgroundColorFill )


/*
vImagePremultipliedAlphaBlend_ARGB8888( &src, &dest, &dest2, kvImageNoFlags );

vImageRotate_ARGB8888( &dest2, &dest, NULL, PI/16, (Pixel_8888){ 0, 255, 0, 0 }, kvImageBackgroundColorFill );

NSData *destData = [NSData dataWithBytesNoCopy:dest.data length:[data length]];
CGDataProviderRef dataProviderRef = CGDataProviderCreateWithCFData((__bridge CFDataRef)destData);
CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

CGImageRef gak = CGImageCreate(imageSize.width, imageSize.height,
	8, 32, imageSize.width * 4, colorSpace,
	kCGBitmapByteOrder32Host | kCGImageAlphaNoneSkipFirst, dataProviderRef,
	NULL, NO, kCGRenderingIntentDefault);

UIImage *image2 = [UIImage imageWithCGImage:gak];
*/


public extension UIImage {
	public func applyLightEffect() -> UIImage? {
		return applyBlurWithRadius(30, tintColor: UIColor(white: 1.0, alpha: 0.3), saturationDeltaFactor: 1.8)
	}
	
	public func applyExtraLightEffect() -> UIImage? {
		return applyBlurWithRadius(20, tintColor: UIColor(white: 0.97, alpha: 0.82), saturationDeltaFactor: 1.8)
	}
	
	public func applyDarkEffect() -> UIImage? {
		return applyBlurWithRadius(20, tintColor: UIColor(white: 0.11, alpha: 0.73), saturationDeltaFactor: 1.8)
	}
	
	public func applyTintEffectWithColor(tintColor: UIColor) -> UIImage? {
		let effectColorAlpha: CGFloat = 0.6
		var effectColor = tintColor
		
		let componentCount = CGColorGetNumberOfComponents(tintColor.CGColor)
		
		if componentCount == 2 {
			var b: CGFloat = 0
			if tintColor.getWhite(&b, alpha: nil) {
				effectColor = UIColor(white: b, alpha: effectColorAlpha)
			}
		} else {
			var red: CGFloat = 0
			var green: CGFloat = 0
			var blue: CGFloat = 0
			
			if tintColor.getRed(&red, green: &green, blue: &blue, alpha: nil) {
				effectColor = UIColor(red: red, green: green, blue: blue, alpha: effectColorAlpha)
			}
		}
		
		return applyBlurWithRadius(10, tintColor: effectColor, saturationDeltaFactor: -1.0, maskImage: nil)
	}
	
	public func applyBlurWithRadius(blurRadius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage? = nil) -> UIImage? {
		
		let __FLT_EPSILON__ = CGFloat(FLT_EPSILON)
		let screenScale = UIScreen.mainScreen().scale
		let imageRect = CGRect(origin: CGPointZero, size: size)
		var effectImage = self
		
		let hasBlur = blurRadius > __FLT_EPSILON__
		let hasSaturationChange = fabs(saturationDeltaFactor - 1.0) > __FLT_EPSILON__
		
		if hasBlur || hasSaturationChange {
			func createEffectBuffer(context: CGContext) -> vImage_Buffer {
				let data = CGBitmapContextGetData(context)
				let width = CGBitmapContextGetWidth(context)
				let height = CGBitmapContextGetHeight(context)
				let rowBytes = CGBitmapContextGetBytesPerRow(context)
				
				return vImage_Buffer(data: data, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: rowBytes)
			}
			
			UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
			let effectInContext = UIGraphicsGetCurrentContext()
			
			CGContextScaleCTM(effectInContext, 1.0, -1.0)
			CGContextTranslateCTM(effectInContext, 0, -size.height)
			CGContextDrawImage(effectInContext, imageRect, self.CGImage)
			
			var effectInBuffer = createEffectBuffer(effectInContext)
			
			
			UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
			let effectOutContext = UIGraphicsGetCurrentContext()
			
			var effectOutBuffer = createEffectBuffer(effectOutContext)
			
			
			if hasBlur {
				let inputRadius = blurRadius * screenScale
				var radius = UInt32(floor(inputRadius * 3.0 * CGFloat(sqrt(2 * M_PI)) / 4 + 0.5))
				if radius % 2 != 1 {
					radius += 1
				}
				
				let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
				
				vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
				vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
				vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
			}
			
			var effectImageBuffersAreSwapped = false
			
			if hasSaturationChange {
				let s: CGFloat = saturationDeltaFactor
				let floatingPointSaturationMatrix: [CGFloat] = [
					0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
					0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
					0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
					0,                    0,                    0,  1
				]
				
				let divisor: CGFloat = 256
				let matrixSize = floatingPointSaturationMatrix.count
				var saturationMatrix = [Int16](count: matrixSize, repeatedValue: 0)
				
				for var i: Int = 0; i < matrixSize; ++i {
					saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
				}
				
				if hasBlur {
					vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
					effectImageBuffersAreSwapped = true
				} else {
					vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
				}
			}
			
			if !effectImageBuffersAreSwapped {
				effectImage = UIGraphicsGetImageFromCurrentImageContext()
			}
			
			UIGraphicsEndImageContext()
			
			if effectImageBuffersAreSwapped {
				effectImage = UIGraphicsGetImageFromCurrentImageContext()
			}
			
			UIGraphicsEndImageContext()
		}
		
		UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
		let outputContext = UIGraphicsGetCurrentContext()
		CGContextScaleCTM(outputContext, 1.0, -1.0)
		CGContextTranslateCTM(outputContext, 0, -size.height)
		
		CGContextDrawImage(outputContext, imageRect, self.CGImage)
		
		if hasBlur {
			CGContextSaveGState(outputContext)
			if let image = maskImage {
				CGContextClipToMask(outputContext, imageRect, image.CGImage);
			}
			CGContextDrawImage(outputContext, imageRect, effectImage.CGImage)
			CGContextRestoreGState(outputContext)
		}
		
		if let color = tintColor {
			CGContextSaveGState(outputContext)
			CGContextSetFillColorWithColor(outputContext, color.CGColor)
			CGContextFillRect(outputContext, imageRect)
			CGContextRestoreGState(outputContext)
		}
		
		let outputImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return outputImage
	}
}
*/
