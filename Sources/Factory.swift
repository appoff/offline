#if os(iOS) || os(macOS)
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
    private let builder: Builder
    private let total: Double
    private let points: [MKPointAnnotation]
    private let route: Set<Routing>
    private let settings: Settings
    
    public init(header: Header, points: [MKPointAnnotation], route: Set<Routing>, settings: Settings) {
        self.header = header
        self.points = points
        self.route = route
        self.settings = settings
        
        shots = (points.map(\.coordinate) + route.map(\.route).flatMap(\.coordinate))
            .rect
            .shots
        total = .init(shots.count)
        builder = .init(url: Local().url(header: header))
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
                try await split(image: snapshot.image, shot: next)
                shots.removeLast()
                
                if shots.isEmpty {
                    builder.output.close()
                    await finished.send(.init(settings: settings,
                                        thumbnail: thumbnail!,
                                        points: points.points(with: route),
                                        tiles: builder.result))
                } else {
                    Task
                        .detached { [weak self] in
                            await self?.shoot()
                        }
                }
            } catch {
                fail.send()
            }
        }
    }
    
    @MainActor public func cancel() {
        canceled = true
        shots = []
        builder.output.close()
        Local().delete(header: header)
    }
    
#if os(iOS)
    private func split(image: UIImage, shot: Shot) async throws {
        for x in 1 ..< shot.width {
            for y in 0 ..< shot.height {
                let size = Shot.tile * 2
                UIGraphicsBeginImageContext(.init(width: size, height: size))
                UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: size)
                UIGraphicsGetCurrentContext()!.scaleBy(x: 1, y: -1)
                UIGraphicsGetCurrentContext()!.draw(image.cgImage!, in:
                        .init(x: size * -.init(x),
                              y: (size * .init(y + 1)) - .init(image.cgImage!.height),
                              width: .init(image.cgImage!.width),
                              height: .init(image.cgImage!.height)))
                
                let data = UIImage(cgImage: UIGraphicsGetCurrentContext()!.makeImage()!)
                    .jpegData(compressionQuality: 1)!
                
                UIGraphicsEndImageContext()
                
                try await builder.add(image: data,
                              z: shot.z,
                              x: x + shot.x,
                              y: y + shot.y)
            }
        }
    }
#elseif os(macOS)
    private func split(image: NSImage, shot: Shot) async throws {
        for x in 1 ..< shot.width {
            for y in 0 ..< shot.height {
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
                
                let data = NSBitmapImageRep(cgImage: tile.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
                    .representation(using: .png, properties: [:])!
                
                try await builder.add(image: data,
                              z: shot.z,
                              x: x + shot.x,
                              y: shot.y + shot.height - y - 1)
            }
        }
    }
#endif
}
#endif
