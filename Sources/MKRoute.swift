import MapKit

extension MKRoute {
    var coordinate: [CLLocationCoordinate2D] {
        UnsafeBufferPointer(start: polyline.points(), count: polyline.pointCount)
            .map(\.coordinate)
    }
    
    var route: Route {
        .init(distance: .init(distance), duration: .init(expectedTravelTime), coordinates: coordinate.map(\.coordinate))
    }
}
