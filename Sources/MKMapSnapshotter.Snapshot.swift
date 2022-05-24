import MapKit

extension MKMapSnapshotter.Snapshot {
    static let thumbnail = 480.0
    
    var thumbnail: Data {
#if os(iOS)
        let width = Self.thumbnail * 2
        let height = Self.thumbnail
        UIGraphicsBeginImageContext(.init(width: width, height: height))
        UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: height)
        UIGraphicsGetCurrentContext()!.scaleBy(x: 1, y: -1)
        UIGraphicsGetCurrentContext()!.draw(image.cgImage!, in:
                .init(x: 0,
                      y: height - .init(image.cgImage!.height),
                      width: .init(image.cgImage!.width),
                      height: .init(image.cgImage!.height)))
        
        let result = UIImage(cgImage: UIGraphicsGetCurrentContext()!.makeImage()!).jpegData(compressionQuality: 1)!
        
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
