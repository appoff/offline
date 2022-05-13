import MapKit

#if os(iOS)
private let size = 512.0
#elseif os(macOS)
private let size = 256.0
#endif

extension MKMapSnapshotter.Snapshot {
    func split(result: inout [UInt8 : [UInt32 : [UInt32 : Data]]], shot: Factory.Shot) {
        (1 ..< shot.width)
            .forEach { x in
                (0 ..< shot.height)
                    .forEach { y in
#if os(iOS)
                        result[.init(shot.z), default: [:]][.init(x + shot.x), default: [:]][.init(y + shot.y)]
                        = data(x: x, y: y)
#elseif os(macOS)
                        result[.init(shot.z), default: [:]][.init(x + shot.x), default: [:]][.init(shot.y + shot.height - y - 1)]
                        = data(x: x, y: y)
#endif
                    }
            }
    }
    
    func data(x: Int, y: Int) -> Data {
#if os(iOS)
        UIGraphicsBeginImageContext(.init(width: size, height: size))
        UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: size)
        UIGraphicsGetCurrentContext()!.scaleBy(x: 1, y: -1)
        UIGraphicsGetCurrentContext()!.draw(image.cgImage!, in:
                .init(x: size * -.init(x),
                      y: (size * .init(y + 1)) - .init(image.cgImage!.height),
                      width: .init(image.cgImage!.width),
                      height: .init(image.cgImage!.height)))
        
        let result = UIImage(cgImage: UIGraphicsGetCurrentContext()!.makeImage()!).pngData()!
        
        UIGraphicsEndImageContext()
        
        return result
                        
#elseif os(macOS)
        let tile = NSImage(size: .init(width: size, height: size))
        tile.lockFocus()
        image
            .draw(in: .init(x: 0, y: 0, width: size, height: size),
                  from: .init(x: size * .init(x),
                              y: size * .init(y),
                              width: size,
                              height: size),
                  operation: .copy,
                  fraction: 1)
        tile.unlockFocus()
        
        return NSBitmapImageRep(
            cgImage: tile.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
        .representation(using: .png, properties: [:])!
#endif
    }
}
