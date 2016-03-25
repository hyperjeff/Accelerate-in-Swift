import Cocoa
import CoreImage
import Accelerate
import XCPlayground

let cookiesURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForImageResource("boobie.png")!)
let imageSource = CGImageSourceCreateWithURL(cookiesURL, nil)
let image = CGImageSourceCreateImageAtIndex(imageSource!, 0, nil)!

let width = CGImageGetWidth(image)
let height = CGImageGetHeight(image)
let bytesPerRow = CGImageGetBytesPerRow(image)
let size = NSMakeSize(CGFloat(width), CGFloat(height))

let nsImage = NSImage(CGImage: image, size: size)
var frame = NSMakeRect(0, 0, 0, 0)
frame.size = size
let playgroundView = NSImageView(frame: frame)
playgroundView.image = nsImage

let colorSpace = CGColorSpaceCreateDeviceRGB()
var backgroundColor : Array<UInt8> = [0,0,0,0]
let fillBackground: vImage_Flags = UInt32(kvImageBackgroundColorFill)

func doStuff() {
	let inProvider = CGImageGetDataProvider(image)
	let providerCopy = CGDataProviderCopyData(inProvider)
	let inBitmapData = UnsafeMutablePointer<UInt8>(CFDataGetBytePtr(providerCopy))
	
	var inBuffer = vImage_Buffer(data: inBitmapData, height: UInt(height), width: UInt(width), rowBytes: bytesPerRow)
	
	let pixelBuffer = malloc(bytesPerRow * height)
	
	var midBuffer = vImage_Buffer(data: pixelBuffer, height: UInt(height), width: UInt(width), rowBytes: bytesPerRow)
	var outBuffer = vImage_Buffer(data: pixelBuffer, height: UInt(height), width: UInt(width), rowBytes: bytesPerRow)
	
	// Kernel close to Apple's example in their vImage Programming Guide

	let kernel:[Int16] = [
		-2, -2, 1,
		-2,  6, 0,
		 1,  0, 0
	]
	
	vImageConvolve_ARGB8888(&inBuffer, &midBuffer, nil, 0, 0, kernel, 3, 3, 3, &backgroundColor, fillBackground)
	
	vImageRotate_ARGB8888(&midBuffer, &inBuffer, nil, 20, &backgroundColor, fillBackground)
	
	vImageHorizontalReflect_ARGB8888(&inBuffer, &outBuffer, fillBackground)
	
	let context = CGBitmapContextCreate(outBuffer.data, width, height, 8, outBuffer.rowBytes, colorSpace, CGImageAlphaInfo.NoneSkipLast.rawValue)
	
	let outCGimage = CGBitmapContextCreateImage(context)
	
	playgroundView.image = NSImage(CGImage: outCGimage!, size: size)
	
	free(pixelBuffer)
}

class Controller: NSViewController {
	override func mouseDown(event: NSEvent) {
		doStuff()
	}
	
	override func mouseUp(event: NSEvent) {
		playgroundView.image = nsImage
	}
}

let controller = Controller()
controller.view = playgroundView

XCPlaygroundPage.currentPage.liveView = playgroundView
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
