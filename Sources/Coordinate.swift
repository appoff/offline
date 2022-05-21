import CoreLocation
import Archivable

private let divider = Double(10_000_000)

struct Coordinate: Storable {
    let latitude: Int32
    let longitude: Int32
    
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: .init(latitude) / divider, longitude: .init(longitude) / divider)
    }
    
    var data: Data {
        .init()
        .adding(latitude)
        .adding(longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = .init(latitude * divider)
        self.longitude = .init(longitude * divider)
    }
    
    init(data: inout Data) {
        latitude = data.number()
        longitude = data.number()
    }
}
