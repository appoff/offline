import MapKit

#if os(iOS)
private let size = 512.0
#elseif os(macOS)
private let size = 256.0
#endif

extension MKMapSnapshotter.Snapshot {
    func split(shot: Factory.Shot) -> [UInt32 : [UInt32 : Data]] {
        (1 ..< shot.width)
            .reduce(into: [:]) { result, x in
                result[.init(x + shot.x)] = (0 ..< shot.height)
                    .reduce(into: [UInt32 : Data]()) { result, y in
#if os(iOS)
                        UIGraphicsBeginImageContext(.init(width: size, height: size))
                        UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: size)
                        UIGraphicsGetCurrentContext()!.scaleBy(x: 1, y: -1)
                        UIGraphicsGetCurrentContext()!.draw(image.cgImage!, in:
                            .init(x: size * -.init(x),
                                  y: (size * .init(y + 1)) - .init(image.cgImage!.height),
                                  width: .init(image.cgImage!.width),
                                  height: .init(image.cgImage!.height)))
                        
                        result[.init(y + shot.y)] = UIImage(cgImage: UIGraphicsGetCurrentContext()!.makeImage()!).pngData()!

                        UIGraphicsEndImageContext()
                        
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
                        
                        result[.init(shot.y + shot.height - y - 1)] = NSBitmapImageRep(
                            cgImage: tile.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
                        .representation(using: .png, properties: [:])!
#endif
                    }
            }
    }
}
