import CoreLocation

extension CLLocationCoordinate2D {
    var coordinate: Coordinate {
        .init(latitude: latitude, longitude: longitude)
    }
}
