import MapKit

private let margin = 0.001

extension Array where Element == CLLocationCoordinate2D {
    var rect: MKMapRect {
        { latitude, longitude in
            { min, max in
                .init(x: min.x, y: min.y, width: max.x - min.x, height: max.y - min.y)
            } (MKMapPoint(.init(latitude: latitude.first!.latitude + margin, longitude: longitude.first!.longitude - margin)),
               MKMapPoint(.init(latitude: latitude.last!.latitude - margin, longitude: longitude.last!.longitude + margin)))
        } (sorted { $0.latitude > $1.latitude }, sorted { $0.longitude < $1.longitude })
    }
}
