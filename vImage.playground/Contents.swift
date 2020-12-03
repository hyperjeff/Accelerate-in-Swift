import Cocoa
import CoreImage
import Accelerate
import PlaygroundSupport

let cookiesURL = NSURL(fileURLWithPath: Bundle.main.pathForImageResource("boobie.png")!)
let imageSource = CGImageSourceCreateWithURL(cookiesURL, nil)
let image = CGImageSourceCreateImageAtIndex(imageSource!, 0, nil)!

let width = image.width
let height = image.height
let bytesPerRow = image.bytesPerRow
let size = NSMakeSize(CGFloat(width), CGFloat(height))

let nsImage = NSImage(cgImage: image, size: size)
var frame = NSMakeRect(0, 0, 0, 0)
frame.size = size
let playgroundView = NSImageView(frame: frame)
playgroundView.image = nsImage

let colorSpace = CGColorSpaceCreateDeviceRGB()
var backgroundColor : Array<UInt8> = [0,0,0,0]
let fillBackground: vImage_Flags = UInt32(kvImageBackgroundColorFill)

func doStuff() {
    guard let inProvider = image.dataProvider else { return }
    let providerCopy = inProvider.data
    let inBitmapData = UnsafeMutableRawPointer(mutating: CFDataGetBytePtr(providerCopy))
	
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
	
    guard let context = CGContext(data: outBuffer.data, width: width, height: height, bitsPerComponent: 8, bytesPerRow: outBuffer.rowBytes, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else { return }
	
    let outCGimage = context.makeImage()
	
    playgroundView.image = NSImage(cgImage: outCGimage!, size: size)
	
	free(pixelBuffer)
}

class Controller: NSViewController {
    
    override func mouseDown(with event: NSEvent) {
        doStuff()
    }
    
    override func mouseUp(with event: NSEvent) {
        playgroundView.image = nsImage
    }
}

let controller = Controller()
controller.view = playgroundView

PlaygroundPage.current.liveView = playgroundView
PlaygroundPage.current.needsIndefiniteExecution = true
