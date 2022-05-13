import MapKit
import Combine

public final class Factory {
    public let fail = PassthroughSubject<Void, Never>()
    public let finished = PassthroughSubject<Tiles, Never>()
    public let progress = CurrentValueSubject<_, Never>(Double())
    public let map: Map
    private var shots: [Shot]
    private var result = [UInt8 : [UInt32 : [UInt32 : Data]]]()
    private var canceled = false
    private let total: Double
    private let points: [MKPointAnnotation]
    private let route: [MKRoute]
    
    public init(map: Map, points: [MKPointAnnotation], route: [MKRoute]) {
        self.map = map
        self.points = points
        self.route = route
        
        shots = (points.map(\.coordinate) + route.coordinate)
            .rect
            .shots
        total = .init(shots.count)
    }
    
    @MainActor public func shoot() async {
        guard let next = shots.last else { return }
        progress.send((total - .init(shots.count)) / total)
        
        let shooter = MKMapSnapshotter(options: next.options)
        
        do {
            let snapshot = try await shooter.start()
            
            guard !canceled else { return }
            
            snapshot.split(result: &result, shot: next)
            shots.removeLast()
            
            if shots.isEmpty {
                let tiles = Tiles(items: result)
                try Local().save(map: map, tiles: tiles)
                finished.send(tiles)
            } else {
                await shoot()
            }
        } catch {
            fail.send()
        }
    }
    
    @MainActor public func cancel() {
        canceled = true
        shots = []
    }
}
