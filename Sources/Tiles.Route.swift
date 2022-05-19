import Foundation
import Archivable

extension Tiles {
    struct Route: Storable {
        let distance: UInt32
        let duration: UInt32
        let coordinates: [Coordinate]
        
        var data: Data {
            .init()
            .adding(distance)
            .adding(duration)
            .adding(size: UInt16.self, collection: coordinates)
        }
        
        init(distance: UInt32, duration: UInt32, coordinates: [Coordinate]) {
            self.distance = distance
            self.duration = duration
            self.coordinates = coordinates
        }
        
        init(data: inout Data) {
            distance = data.number()
            duration = data.number()
            coordinates = data.collection(size: UInt16.self)
        }
    }
}
