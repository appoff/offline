import MapKit
import Archivable

public struct Schema: Storable {
    public let settings: Settings
    public let thumbnail: Data
    let points: [Point]
    let content: Data
    
    public var tiles: Tiles {
        content.prototype()
    }
    
    public var annotations: [(point: MKPointAnnotation, route: Route?)] {
        points
            .map {
                (point: $0.annotation, route: $0.route)
            }
    }
    
    public var polyline: MKMultiPolyline {
        .init(points.compactMap(\.route?.polyline))
    }
    
    public var data: Data {
        .init()
        .adding(settings)
        .wrapping(size: UInt32.self, data: thumbnail)
        .adding(size: UInt8.self, collection: points)
        .wrapping(size: UInt32.self, data: content)
    }
    
    public init(data: inout Data) {
        settings = .init(data: &data)
        thumbnail = data.unwrap(size: UInt32.self)
        points = data.collection(size: UInt8.self)
        content = data.unwrap(size: UInt32.self)
    }
    
    init(settings: Settings,
         thumbnail: Data,
         points: [Point],
         tiles: [UInt8 : [UInt32 : [UInt32 : UInt32]]]) {
        self.settings = settings
        self.thumbnail = thumbnail
        self.points = points
        content = Tiles(items: tiles).data
    }
}
