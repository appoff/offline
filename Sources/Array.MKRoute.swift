import MapKit

extension Array where Element == MKRoute {
    var coordinate: [CLLocationCoordinate2D] {
        flatMap {
            UnsafeBufferPointer(start: $0.polyline.points(), count: $0.polyline.pointCount)
                .map(\.coordinate)
        }
    }
}
