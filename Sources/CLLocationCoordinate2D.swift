import CoreLocation

extension CLLocationCoordinate2D {
    public func delta(other: Self) -> CLLocationDistance {
        abs(latitude - other.latitude) + abs(longitude - other.longitude)
    }
    
    var coordinate: Coordinate {
        .init(latitude: latitude, longitude: longitude)
    }
}
