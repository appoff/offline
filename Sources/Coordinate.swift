import CoreLocation
import Archivable

struct Coordinate: Storable {
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
    
    var data: Data {
        .init()
        .adding(latitude)
        .adding(longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(data: inout Data) {
        latitude = data.number()
        longitude = data.number()
    }
}
