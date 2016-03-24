/*:
# Compression
_Jeff Biggus (@hyperjeff) March, 2016_
*/
import Compression
/*:
lossless data compression\
high speed + energy efficiency

4 compressors:
 * lz4 (fastest)
 * lzfse (bit faster and a touch better compression than zlib)
 * zlib (standard)
 * lzma (slower but best compression)

All optimzed on Apple hardware, so better than just using usual zlib
*/
let source:[UInt8] = [1,4,9,8,6,3,0,2,9,2]
let destinationCapacity = size_t(30)
var destination = [UInt8](count: Int(destinationCapacity), repeatedValue:0)

let destinationSize = compression_encode_buffer(&destination, destinationCapacity, source, source.count, nil, COMPRESSION_LZFSE)

destination

var returnBuffer = [UInt8](count: source.count, repeatedValue:0)

compression_decode_buffer(&returnBuffer, source.count, destination, destinationSize, nil, COMPRESSION_LZFSE)

returnBuffer
/*:
- Note: If the destination capacity in the above example is set below 23, the LZFSE compression is not possible, and you are left with all zeros. So, make sure you have enough room.
----
## Buffer and Streaming APIs
That is the simple buffer API.
From here there is a streaming API version that works asynchronously while your app is doing something, where you can check on the status and wrap things up when it's finished. You will need to also set up a scratch buffer for the compressor to work with.
*/