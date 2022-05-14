import MapKit
import Combine

public final class Factory {
    public let fail = PassthroughSubject<Void, Never>()
    public let finished = PassthroughSubject<Tiles, Never>()
    public let progress = CurrentValueSubject<_, Never>(Double())
    public let map: Map
    private var shots: [Shot]
    private var thumbnail: Data?
    private var result = [UInt8 : [UInt32 : [UInt32 : Data]]]()
    private var canceled = false
    private let total: Double
    private let points: [MKPointAnnotation]
    private let route: [MKRoute]
    private let settings: Settings
    
    public init(map: Map, points: [MKPointAnnotation], route: [MKRoute], settings: Settings) {
        self.map = map
        self.points = points
        self.route = route
        self.settings = settings
        
        shots = (points.map(\.coordinate) + route.coordinate)
            .rect
            .shots
        total = .init(shots.count)
    }
    
    @MainActor public func shoot() async {
        guard let next = shots.last else { return }
        progress.send((total - .init(shots.count)) / total)
        
        if thumbnail == nil {
            let shooter = MKMapSnapshotter(options: points.last!.options.configure(settings: settings))
            
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
                
                snapshot.split(result: &result, shot: next)
                shots.removeLast()
                
                if shots.isEmpty {
                    let tiles = Tiles(thumbnail: thumbnail!, items: result)
                    try Local().save(map: map, tiles: tiles)
                    finished.send(tiles)
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
    }
}
