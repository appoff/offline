import CoreLocation

extension CLLocationCoordinate2D {
    public func delta(other: Self) -> CLLocationDistance {
        pow(latitude - other.latitude, 2) + pow(longitude - other.longitude, 2)
    }
    
    var coordinate: Coordinate {
        .init(latitude: latitude, longitude: longitude)
    }
}
