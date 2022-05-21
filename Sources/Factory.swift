import MapKit
import Combine

public final class Factory {
    public let fail = PassthroughSubject<Void, Never>()
    public let finished = PassthroughSubject<Schema, Never>()
    public let progress = CurrentValueSubject<_, Never>(Double())
    public let header: Header
    private var shots: [Shot]
    private var thumbnail: Data?
    private var canceled = false
    private var offset = UInt32()
    private var result = [UInt8 : [UInt32 : [UInt32 : UInt32]]]()
    private let total: Double
    private let points: [MKPointAnnotation]
    private let route: Set<Routing>
    private let settings: Settings
    private let output: OutputStream
    
    public init(header: Header, points: [MKPointAnnotation], route: Set<Routing>, settings: Settings) {
        self.header = header
        self.points = points
        self.route = route
        self.settings = settings
        
        shots = (points.map(\.coordinate) + route.map(\.route).flatMap(\.coordinate))
            .rect
            .shots
        total = .init(shots.count)
        output = .init(url: Local().url(header: header), append: false)!
        output.open()
    }
    
    deinit {
        print("Factory gone")
        output.close()
    }
    
    @MainActor public func shoot() async {
        guard let next = shots.last else { return }
        progress.send((total - .init(shots.count)) / total)
        
        if thumbnail == nil {
            let shooter = MKMapSnapshotter(options: points.last!.thumbnail.configure(settings: settings))
            
            do {
                let snapshot = try await shooter.start()
                
                guard !canceled else { return }
                
                thumbnail = snapshot.thumbnail
                await shoot()
            } catch {
                fail.send()
            }
        } else {
            let shooter = MKMapSnapshotter(options: next.options.configure(settings: settings))
            
            do {
                let snapshot = try await shooter.start()
                guard !canceled else { return }
                try split(image: snapshot.image, shot: next)
                shots.removeLast()
                
                if shots.isEmpty {
                    output.close()
                    finished.send(.init(settings: settings,
                                        thumbnail: thumbnail!,
                                        points: points.points(with: route),
                                        tiles: result))
                } else {
                    await shoot()
                }
            } catch {
                fail.send()
            }
        }
    }
    
    @MainActor public func cancel() {
        canceled = true
        shots = []
        output.close()
        Local().delete(header: header)
    }
    
#if os(iOS)
    private func split(image: UIImage, shot: Shot) throws {
        try (1 ..< shot.width)
            .forEach { x in
                try (0 ..< shot.height)
                    .forEach { y in
                        let size = Shot.tile * 2
                        UIGraphicsBeginImageContext(.init(width: size, height: size))
                        UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: size)
                        UIGraphicsGetCurrentContext()!.scaleBy(x: 1, y: -1)
                        UIGraphicsGetCurrentContext()!.draw(image.cgImage!, in:
                                .init(x: size * -.init(x),
                                      y: (size * .init(y + 1)) - .init(image.cgImage!.height),
                                      width: .init(image.cgImage!.width),
                                      height: .init(image.cgImage!.height)))
                        
                         let content = UIImage(cgImage: UIGraphicsGetCurrentContext()!.makeImage()!)
                            .jpegData(compressionQuality: 1)!
                        
                        UIGraphicsEndImageContext()
                        
                        try content
                            .withUnsafeBytes {
                                if content.count == output.write($0.bindMemory(to: UInt8.self).baseAddress!,
                                                                 maxLength: content.count) {
                                    result[.init(shot.z), default: [:]][.init(x + shot.x), default: [:]][.init(y + shot.y)]
                                    = (offset: offset, size: .init(content.count))
                                } else {
                                    throw NSError(domain: "", code: 1)
                                }
                            }
                    }
            }
    }
#elseif os(macOS)
    private func split(image: NSImage, shot: Shot) throws {
        try (1 ..< shot.width)
            .forEach { x in
                try (0 ..< shot.height)
                    .forEach { y in
                        let tile = NSImage(size: .init(width: Shot.tile, height: Shot.tile))
                        tile.lockFocus()
                        image
                            .draw(in: .init(x: 0, y: 0, width: Shot.tile, height: Shot.tile),
                                  from: .init(x: Shot.tile * .init(x),
                                              y: Shot.tile * .init(y),
                                              width: Shot.tile,
                                              height: Shot.tile),
                                  operation: .copy,
                                  fraction: 1)
                        tile.unlockFocus()
                        
                        let content = NSBitmapImageRep(
                            cgImage: tile.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
                        .representation(using: .png, properties: [:])!
                        
                        try content
                            .withUnsafeBytes {
                                if content.count == output.write($0.bindMemory(to: UInt8.self).baseAddress!,
                                                                 maxLength: content.count) {
//                                    result[.init(shot.z), default: [:]][.init(x + shot.x), default: [:]][.init(shot.y + shot.height - y - 1)]
//                                    = (offset: offset, size: .init(content.count))
                                } else {
                                    throw NSError(domain: "", code: 1)
                                }
                            }
                    }
            }
    }
#endif
}
