import MapKit
import Combine

public final class Factory {
    public let fail = PassthroughSubject<Void, Never>()
    public let finished = PassthroughSubject<Void, Never>()
    public let progress = CurrentValueSubject<_, Never>(Double())
    public let map: Map
    private weak var shooter: MKMapSnapshotter?
    private var shots: [Shot]
    private var result = [UInt8 : [UInt32 : [UInt32 : Data]]]()
    private let total: Double
    private let points: [MKPointAnnotation]
    private let route: [MKRoute]
    private let timer = DispatchSource.makeTimerSource()
    
    public init(map: Map, points: [MKPointAnnotation], route: [MKRoute]) {
        self.map = map
        self.points = points
        self.route = route
        
        shots = (points.map(\.coordinate) + route.coordinate)
            .rect
            .shots
        total = .init(shots.count)
        
        timer.activate()
        timer.schedule(deadline: .distantFuture)
        timer.setEventHandler { [weak self] in
            self?.shooter?.cancel()
            self?.fail.send()
        }
    }
    
    deinit {
        print("factory gone")
    }
    
    @MainActor public func shoot() async {
        print("Shoot")
        guard let next = shots.last else { return }
        progress.send((total - .init(shots.count)) / total)
        timer.schedule(deadline: .now() + 10)
        
        let shooter = MKMapSnapshotter(options: next.options)
        self.shooter = shooter
        
        do {
            let snapshot = try await shooter.start()
            timer.schedule(deadline: .distantFuture)
            result[.init(next.z)] = snapshot.split(shot: next)
            shots.removeLast()
            
            if shots.isEmpty {
                try Local().save(map: map, tiles: .init(items: result))
                finished.send()
            } else {
                Task
                    .detached { [weak self] in
                        await self?.shoot()
                    }
            }
        } catch {
            fail.send()
            timer.schedule(deadline: .distantFuture)
        }
    }
    
    @MainActor public func cancel() {
        shots = []
        timer.cancel()
        shooter?.cancel()
    }
}
