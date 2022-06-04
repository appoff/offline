#if os(iOS) || os(macOS)
import MapKit
#else
import Foundation
#endif

import Archivable

struct Point: Storable {
    let title: String
    let subtitle: String
    let coordinate: Coordinate
    let route: Route?

#if os(iOS) || os(macOS)
    var annotation: MKPointAnnotation {
        let result = MKPointAnnotation()
        result.coordinate = coordinate.coordinate
        result.title = title
        result.subtitle = subtitle
        return result
    }
#endif
    
    var data: Data {
        .init()
        .adding(size: UInt8.self, string: title)
        .adding(size: UInt8.self, string: subtitle)
        .adding(coordinate)
        .adding(route != nil)
        .adding(optional: route)
    }
    
    init(title: String, subtitle: String, coordinate: Coordinate, route: Route?) {
        self.title = title.max8
        self.subtitle = subtitle.max8
        self.coordinate = coordinate
        self.route = route
    }
    
    init(data: inout Data) {
        title = data.string(size: UInt8.self)
        subtitle = data.string(size: UInt8.self)
        coordinate = .init(data: &data)
        route = data.bool() ? .init(data: &data) : nil
    }
}
