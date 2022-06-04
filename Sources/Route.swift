#if os(iOS) || os(macOS)
import MapKit
#endif

import Archivable

public struct Route: Storable {
    public let distance: UInt16
    public let duration: UInt16
    let coordinates: [Coordinate]

#if os(iOS) || os(macOS)
    var polyline: MKPolyline {
        .init(coordinates: coordinates.map(\.coordinate), count: coordinates.count)
    }
#endif
    
    public var data: Data {
        .init()
        .adding(distance)
        .adding(duration)
        .adding(size: UInt8.self, collection: coordinates)
    }
    
    public init(data: inout Data) {
        distance = data.number()
        duration = data.number()
        coordinates = data.collection(size: UInt8.self)
    }
    
    init(distance: UInt16, duration: UInt16, coordinates: [Coordinate]) {
        self.distance = distance
        self.duration = duration
        self.coordinates = coordinates
    }
}
