//:# vImage
//:## Image manipulation, but more also

import Cocoa
import Accelerate
import CoreGraphics

// supposedly nice vImage Buffer creation
// CoreGraphics interop

// vImageBuffer_InitWithCGImage, vImageCreateCGImageFromBuffer

var image = NSImage(named: "tree-dwelling-goats.jpg")!
var source = CGImageSourceCreateWithData(image.TIFFRepresentation, nil)
var inImage = CGImageSourceCreateImageAtIndex(source, 0, nil)

var format = vImage_CGImageFormat(bitsPerComponent: UInt32(8), bitsPerPixel: UInt32(32), colorSpace: nil, bitmapInfo: CGBitmapInfo(rawValue: 68), version: UInt32(0), decode: nil, renderingIntent: CGColorRenderingIntent(0))

// kCGRenderingIntentDefault = 0

//var inBuffer: vImage_Buffer = vImage_Buffer(data: &image, height: image.size.height, width: image.size.width, rowBytes: 4 * image.size.width)

//vImageBuffer_InitWithCGImage( &inBuffer, &format, nil, inImage, vImage_Flags(0) )

var buffer:vImage_Buffer?
if var inBuffer = buffer {
	vImageBuffer_InitWithCGImage( &inBuffer, &format, nil , inImage, 0 )
	// kvImageNoFlags = 0
	
	
}
// vImageConvert_AnyToAny
