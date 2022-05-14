import MapKit

extension MKMapSnapshotter.Snapshot {
    static let thumbnail = 512.0
    
    func split(result: inout [UInt8 : [UInt32 : [UInt32 : Data]]], shot: Factory.Shot) {
        (1 ..< shot.width)
            .forEach { x in
                (0 ..< shot.height)
                    .forEach { y in
#if os(iOS)
                        let size = Factory.Shot.tile * 2
                        UIGraphicsBeginImageContext(.init(width: size, height: size))
                        UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: size)
                        UIGraphicsGetCurrentContext()!.scaleBy(x: 1, y: -1)
                        UIGraphicsGetCurrentContext()!.draw(image.cgImage!, in:
                                .init(x: size * -.init(x),
                                      y: (size * .init(y + 1)) - .init(image.cgImage!.height),
                                      width: .init(image.cgImage!.width),
                                      height: .init(image.cgImage!.height)))
                        
                        result[.init(shot.z), default: [:]][.init(x + shot.x), default: [:]][.init(y + shot.y)] = UIImage(cgImage: UIGraphicsGetCurrentContext()!.makeImage()!).pngData()!
                        
                        UIGraphicsEndImageContext()
#elseif os(macOS)
                        let tile = NSImage(size: .init(width: Factory.Shot.tile, height: Factory.Shot.tile))
                        tile.lockFocus()
                        image
                            .draw(in: .init(x: 0, y: 0, width: Factory.Shot.tile, height: Factory.Shot.tile),
                                  from: .init(x: Factory.Shot.tile * .init(x),
                                              y: Factory.Shot.tile * .init(y),
                                              width: Factory.Shot.tile,
                                              height: Factory.Shot.tile),
                                  operation: .copy,
                                  fraction: 1)
                        tile.unlockFocus()

                        result[.init(shot.z), default: [:]][.init(x + shot.x), default: [:]][.init(shot.y + shot.height - y - 1)]
                        = NSBitmapImageRep(
                            cgImage: tile.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
                        .representation(using: .png, properties: [:])!
#endif
                    }
            }
    }
    
    var thumbnail: Data {
#if os(iOS)
        let width = Self.thumbnail * 2
        let height = Self.thumbnail * 1.5
        UIGraphicsBeginImageContext(.init(width: width, height: height))
        UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: height)
        UIGraphicsGetCurrentContext()!.scaleBy(x: 1, y: -1)
        UIGraphicsGetCurrentContext()!.draw(image.cgImage!, in:
                .init(x: 0,
                      y: height - .init(image.cgImage!.height),
                      width: .init(image.cgImage!.width),
                      height: .init(image.cgImage!.height)))
        
        let result = UIImage(cgImage: UIGraphicsGetCurrentContext()!.makeImage()!).pngData()!
        
        UIGraphicsEndImageContext()
        
        return result
                        
#elseif os(macOS)
        let tile = NSImage(size: .init(width: Self.thumbnail, height: Self.thumbnail))
        tile.lockFocus()
        image
            .draw(in: .init(x: 0, y: 0, width: Self.thumbnail, height: Self.thumbnail),
                  from: .init(x: 0,
                              y: 0,
                              width: Self.thumbnail,
                              height: Self.thumbnail),
                  operation: .copy,
                  fraction: 1)
        tile.unlockFocus()
        
        return NSBitmapImageRep(
            cgImage: tile.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
        .representation(using: .png, properties: [:])!
#endif
    }
}
