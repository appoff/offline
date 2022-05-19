import MapKit

extension MKRoute {
    var coordinate: [CLLocationCoordinate2D] {
        UnsafeBufferPointer(start: polyline.points(), count: polyline.pointCount)
            .map(\.coordinate)
    }
}
