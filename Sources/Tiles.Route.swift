import MapKit
import Archivable

extension Tiles {
    public struct Route: Storable {
        public let distance: UInt32
        public let duration: UInt32
        let coordinates: [Coordinate]

        var polyline: MKPolyline {
            .init(coordinates: coordinates.map(\.coordinate), count: coordinates.count)
        }
        
        public var data: Data {
            .init()
            .adding(distance)
            .adding(duration)
            .adding(size: UInt16.self, collection: coordinates)
        }
        
        public init(data: inout Data) {
            distance = data.number()
            duration = data.number()
            coordinates = data.collection(size: UInt16.self)
        }
        
        init(distance: UInt32, duration: UInt32, coordinates: [Coordinate]) {
            self.distance = distance
            self.duration = duration
            self.coordinates = coordinates
        }
    }
}
