import MapKit
import Archivable

extension Tiles {
    struct Point: Storable {
        let title: String
        let subtitle: String
        let coordinate: Coordinate
        
        var annotation: MKPointAnnotation {
            let result = MKPointAnnotation()
            result.coordinate = coordinate.coordinate
            result.title = title
            result.subtitle = subtitle
            return result
        }
        
        var data: Data {
            .init()
            .adding(size: UInt8.self, string: title)
            .adding(size: UInt8.self, string: subtitle)
            .adding(coordinate)
        }
        
        init(title: String, subtitle: String, coordinate: Coordinate) {
            self.title = title.max8
            self.subtitle = subtitle.max8
            self.coordinate = coordinate
        }
        
        init(data: inout Data) {
            title = data.string(size: UInt8.self)
            subtitle = data.string(size: UInt8.self)
            coordinate = .init(data: &data)
        }
    }
}